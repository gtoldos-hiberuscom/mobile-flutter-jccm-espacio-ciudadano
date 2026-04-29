// Sprint 8 — STORY-64 telemetry verification spot-check.
//
// Asserts the *current* documented redaction contract for analytics
// emission and structured-log context maps.
//
// The contract today is:
//
// 1. `AnalyticsEvent` subclasses are PII-free **by design**: their
//    constructors only accept stable identifiers (route slugs, enum
//    names, catalog IDs, error type names, host domains). Field-level
//    redaction is therefore not needed.
//
// 2. `ConsoleAnalyticsService.logEvent` formats the event as
//    `'[Analytics] event: <runtimeType> | <toString>'`. Because no
//    event subclass overrides `toString()`, **field values never reach
//    the rendered line** — only the type name does. This guarantees
//    that even if a caller passed PII into a field by mistake, the
//    development-console sink would not leak it.
//
// 3. `ConsoleAnalyticsService.setCurrentScreen(screenName)` *does*
//    interpolate its argument verbatim. The only documented caller
//    (`AnalyticsObserver`) feeds it a route slug, but this is a known
//    leak surface if a future caller passes user content. See
//    `documentation/qa/STORY-64-telemetry-verification-sprint8.md`
//    Sprint-9 carryover.
//
// 4. `ConsoleLogger` redacts **context-map values** whose key contains
//    a PII fragment (`token|id|name|dni|nss|plate|license|matricula`)
//    by replacing them with the literal `'[REDACTED]'`. Values are
//    never inspected.
//
// These assertions describe the contract as it actually exists on
// commit 79151ae. They are intentionally written so a future drift
// (e.g. someone adding a `toString()` to an event class that prints
// raw fields) will fail this test loudly.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/console_analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/console_logger.dart';

// Realistic Spanish-administration PII samples used as injected inputs.
const _nif = '12345678Z';
const _email = 'ciudadano@example.com';
const _phone = '+34600000000';
const _fullName = 'María García López';
const _idAgente = 'AG-007731';
const _dob = '1980-04-12';

const _piiSamples = <String>[_nif, _email, _phone, _fullName, _idAgente, _dob];

void main() {
  group('Telemetry redaction — analytics emission', () {
    late _CapturingLogger logger;
    late AnalyticsService analytics;

    setUp(() {
      logger = _CapturingLogger();
      analytics = ConsoleAnalyticsService(logger: logger);
    });

    test('logEvent: PageViewEvent with PII-like inputs does not leak field values to the console sink', () {
      // A misbehaving caller could try to push raw PII through the
      // structural-only `parameters` map and `pageName` field.
      analytics.logEvent(
        const PageViewEvent(
          '/profile/$_nif',
          parameters: <String, String>{
            'nif': _nif,
            'email': _email,
            'phone': _phone,
          },
        ),
      );

      _expectNoPii(logger.messages);
      // Type name MUST appear so analytics is actually observable.
      expect(logger.messages.single, contains('PageViewEvent'));
    });

    test('logEvent: every concrete AnalyticsEvent subclass renders type-only output (no field leakage)', () {
      final events = <AnalyticsEvent>[
        // Each event constructed with abusive PII inputs in every
        // string field that accepts free-form text.
        const PageViewEvent('/x/$_nif', parameters: {'email': _email}),
        const DownloadEvent(_nif, mimeType: _email),
        const HomeBlockNavigateEvent(_idAgente, target: '/profile/$_nif'),
        const ExternalLinkEvent('$_email.invalid'),
        const ExternalLinkOpenedEvent(linkId: _idAgente, success: true),
        const ExternalLinkOpenFailedEvent(linkId: _idAgente, reason: _phone),
        const DomainLandingViewedEvent(domain: _fullName),
        const AgendaPeriodChangedEvent(periodId: _dob),
        const AgendaEventOpenedEvent(eventId: _nif, category: _fullName),
        const AppErrorEvent(_nif, context: _email),
      ];

      // ignore: prefer_foreach — using forEach hits cascade_invocations.
      for (final event in events) {
        analytics.logEvent(event);
      }

      // Sanity: one log line per event.
      expect(logger.messages, hasLength(events.length));
      _expectNoPii(logger.messages);
    });

    test('logEvent: AnalyticsEvent subclasses do not override toString (contract guard)', () {
      // The "no field leakage" guarantee depends entirely on
      // subclasses inheriting Object.toString. If a future change
      // overrides toString to print fields, the previous test would
      // fail — this one fails earlier with a clearer message.
      const samples = <AnalyticsEvent>[
        PageViewEvent('/x'),
        DownloadEvent('certificado'),
        HomeBlockNavigateEvent('home'),
        ExternalLinkEvent('sede.jccm.es'),
        ExternalLinkOpenedEvent(linkId: 'l', success: true),
        ExternalLinkOpenFailedEvent(linkId: 'l', reason: 'r'),
        DomainLandingViewedEvent(domain: 'education'),
        AgendaPeriodChangedEvent(periodId: 'all'),
        AgendaEventOpenedEvent(eventId: 'e', category: 'salud'),
        AppErrorEvent('NetworkFailure'),
      ];
      for (final e in samples) {
        expect(
          e.toString(),
          startsWith("Instance of '"),
          reason:
              '${e.runtimeType} appears to override toString(). '
              'That breaks the analytics-sink redaction contract — '
              'see telemetry_redaction_test.dart header.',
        );
      }
    });

    test('setCurrentScreen: argument is interpolated verbatim (documented leak surface)', () {
      // The current contract trusts callers to pass route slugs.
      // We document this by asserting the verbatim behaviour so any
      // future tightening (e.g. allow-listing slugs) is a deliberate
      // contract change, not an accidental one.
      analytics.setCurrentScreen('/profile/$_nif');

      expect(logger.messages.single, contains('/profile/$_nif'));
    });
  });

  group('Telemetry redaction — ConsoleLogger context map', () {
    test('PII-keyed context values are replaced with [REDACTED]', () {
      final printed = <String>[];
      // ConsoleLogger emits via top-level `print`; capture it with a
      // print-overriding Zone so we can assert on the rendered line.
      const logger = ConsoleLogger();
      runZoned<void>(
        () {
          logger.info(
            'login attempt',
            context: <String, Object?>{
              'agentId': _idAgente,
              'userName': _fullName,
              'dni': _nif,
              'sessionToken': 'sek-abc',
              'plateNumber': '1234ABC',
              'safeKey': 'visible-value',
            },
          );
        },
        zoneSpecification: ZoneSpecification(
          print: (final self, final parent, final zone, final line) => printed.add(line),
        ),
      );

      expect(printed, hasLength(1));
      final line = printed.single;
      // Redacted keys → values gone.
      for (final secret in <String>[_idAgente, _fullName, _nif, 'sek-abc', '1234ABC']) {
        expect(
          line,
          isNot(contains(secret)),
          reason: 'PII value "$secret" leaked into log line: $line',
        );
      }
      // Non-PII key passes through.
      expect(line, contains('safeKey: visible-value'));
      // Redaction marker present at least once.
      expect(line, contains('[REDACTED]'));
    });
  });
}

void _expectNoPii(final Iterable<String> lines) {
  for (final line in lines) {
    for (final secret in _piiSamples) {
      expect(
        line,
        isNot(contains(secret)),
        reason: 'PII value "$secret" leaked into analytics output: $line',
      );
    }
  }
}

// ── Test doubles ──────────────────────────────────────────────────────────────

class _CapturingLogger implements AppLogger {
  final List<String> messages = <String>[];

  @override
  void debug(final String message, {final Map<String, Object?>? context}) {
    messages.add(message);
  }

  @override
  void info(final String message, {final Map<String, Object?>? context}) {
    messages.add(message);
  }

  @override
  void warning(final String message, {final Map<String, Object?>? context}) {
    messages.add(message);
  }

  @override
  void error(
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) {
    messages.add(message);
  }
}
