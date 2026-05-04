// Sprint 9 — STORY-67 / EPIC-2 PII-leak regression guard.
//
// Verifies that the post-login log emission on the landing CTA does
// **not** leak session PII (NIF, idAgente, access token, etc.) into
// either the rendered log message or the structured context map.
//
// Contract under test:
//
//  1. The `LandingPage` CTA must call `appLoggerProvider.info(...)`
//     after a successful login.
//  2. The message string must NOT interpolate the `AuthSession`
//     (so token-like substrings cannot reach the sink even before
//     redaction).
//  3. The context map keys are subject to `ConsoleLogger`'s
//     `_kPiiKeyFragments` redaction. Even if a future refactor were
//     to push PII-shaped values through, this test asserts no PII
//     value appears anywhere in the captured `message + context`.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/console_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/logger_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/auth.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

// Realistic Spanish-administration PII samples used as injected inputs.
const _nif = '12345678Z';
const _idAgente = 'AGT-1';
const _accessToken = 'tok-secret-abc.def.ghi';
const _refreshToken = 'rtk-secret-xyz';
const _idToken = 'idt-secret-jwt';

const _piiSamples = <String>[
  _nif,
  _idAgente,
  _accessToken,
  _refreshToken,
  _idToken,
];

void main() {
  testWidgets(
    'Landing CTA: post-login log redacts session and avoids PII leakage',
    (final tester) async {
      final logger = _CapturingLogger();
      final fakeRepo = _FakeAuthRepository(
        const AuthSession(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
          idToken: _idToken,
          tokenType: 'Bearer',
          scopes: ['openid'],
        ),
      );

      final router = GoRouter(
        initialLocation: '/landing',
        routes: [
          GoRoute(
            path: '/landing',
            builder: (final c, final s) => const LandingPage(),
          ),
          GoRoute(
            path: '/sitemap',
            builder: (final c, final s) =>
                const Scaffold(body: Text('SITEMAP_PAGE')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appLoggerProvider.overrideWithValue(logger),
            authRepositoryProvider.overrideWithValue(fakeRepo),
            authSessionRepositoryProvider
                .overrideWithValue(_FakeAuthSessionRepository(nif: _nif)),
            secureStorageProvider.overrideWithValue(_InMemorySecureStorage()),
            goRouterProvider.overrideWith((final ref) => router),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('es'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Locate the landing CTA and tap it. The CTA carries a Semantics
      // label equal to its localized text. We scroll the page to ensure
      // the button is visible before tapping it.
      await tester.ensureVisible(find.byType(LandingPage));
      // Scroll all the way down so the CTA is reachable.
      await tester.drag(
        find.byType(LandingPage),
        const Offset(0, -2000),
      );
      await tester.pumpAndSettle();

      // Tap the CTA. We re-find by widget type after the scroll.
      // AppButton renders an ElevatedButton internally in most variants;
      // tapping the visible button by label is the most stable selector.
      final ctaByLabel = find.text(
        AppLocalizations.of(tester.element(find.byType(LandingPage)))
            .landingCtaButton,
      );
      expect(ctaByLabel, findsWidgets);
      await tester.tap(ctaByLabel.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      // The login use case should have been invoked.
      expect(fakeRepo.loginCalls, 1);

      // The CTA must emit exactly one info log carrying the redacted
      // contract message. Other internal info logs (e.g. notifier
      // diagnostics) are allowed and asserted against PII leakage below.
      final ctaEntries = logger.entries
          .where((final e) => e.message == 'Login successful')
          .toList();
      expect(ctaEntries, hasLength(1));
      final entry = ctaEntries.single;
      expect(entry.level, 'info');

      // The message must NOT contain any session field interpolation —
      // not the AuthSession runtime values, not its toString() output.
      for (final secret in _piiSamples) {
        expect(
          entry.message,
          isNot(contains(secret)),
          reason:
              'PII value "$secret" leaked into log MESSAGE: ${entry.message}',
        );
      }

      // Combined message + JSON-encoded context must not contain any
      // PII sample. We additionally pipe context through ConsoleLogger's
      // redaction contract to assert PII-keyed values would be redacted
      // even if a future caller re-adds them.
      final encodedContext = jsonEncode(entry.context ?? const {});
      final combined = '${entry.message}|$encodedContext';
      for (final secret in _piiSamples) {
        expect(
          combined,
          isNot(contains(secret)),
          reason:
              'PII value "$secret" leaked into log message+context: $combined',
        );
      }

      // Sanity: the structural marker we DO log (`hasIdAgente`) is a
      // boolean, does not match `_kPiiKeyFragments`, and never carries
      // the actual identifier value.
      expect(entry.context, isNotNull);
      expect(entry.context, contains('hasIdAgente'));
      expect(entry.context!['hasIdAgente'], isA<bool>());

      // Cross-check against the real ConsoleLogger redaction sink: even
      // when emitted through ConsoleLogger, no PII reaches the rendered
      // line. (Belt + braces against future regressions.)
      final printed = <String>[];
      const sinkLogger = ConsoleLogger();
      await _runWithCapturedPrint(printed, () async {
        sinkLogger.info(entry.message, context: entry.context);
      });
      expect(printed, hasLength(1));
      for (final secret in _piiSamples) {
        expect(
          printed.single,
          isNot(contains(secret)),
          reason:
              'PII value "$secret" leaked through ConsoleLogger sink: '
              '${printed.single}',
        );
      }
    },
  );
}

// ── Test doubles ──────────────────────────────────────────────────────────────

class _LogEntry {
  const _LogEntry({
    required this.level,
    required this.message,
    required this.context,
  });

  final String level;
  final String message;
  final Map<String, Object?>? context;
}

class _CapturingLogger implements AppLogger {
  final List<_LogEntry> entries = <_LogEntry>[];

  @override
  void debug(final String message, {final Map<String, Object?>? context}) {
    entries.add(_LogEntry(level: 'debug', message: message, context: context));
  }

  @override
  void info(final String message, {final Map<String, Object?>? context}) {
    entries.add(_LogEntry(level: 'info', message: message, context: context));
  }

  @override
  void warning(final String message, {final Map<String, Object?>? context}) {
    entries.add(
      _LogEntry(level: 'warning', message: message, context: context),
    );
  }

  @override
  void error(
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) {
    entries.add(_LogEntry(level: 'error', message: message, context: context));
  }
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._session);

  final AuthSession _session;
  int loginCalls = 0;

  @override
  Future<AuthSession> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  }) async {
    loginCalls += 1;
    return _session;
  }

  @override
  Future<AuthSession> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) async => _session;

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {}

  @override
  Future<AuthUser> fetchUserInfo({required final String accessToken}) async {
    throw UnimplementedError();
  }
}

class _FakeAuthSessionRepository implements AuthSessionRepository {
  _FakeAuthSessionRepository({required this.nif});

  final String nif;
  final StreamController<AuthSessionState> _controller =
      StreamController<AuthSessionState>.broadcast();

  @override
  Future<AuthSessionState> read() async => const UnauthenticatedSession();

  @override
  Future<AuthenticatedSession> save(final AuthSession session) async {
    final authenticated = AuthenticatedSession(
      session: session,
      user: AuthUser(sub: 'fake-sub', nif: nif),
    );
    _controller.add(authenticated);
    return authenticated;
  }

  @override
  Future<void> clear() async {
    _controller.add(const UnauthenticatedSession());
  }

  @override
  Stream<AuthSessionState> watch() => _controller.stream;
}

Future<void> _runWithCapturedPrint(
  final List<String> sink,
  final Future<void> Function() body,
) async {
  await runZoned<Future<void>>(
    body,
    zoneSpecification: ZoneSpecification(
      print: (final self, final parent, final zone, final line) =>
          sink.add(line),
    ),
  );
}

class _InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _store = <String, String>{};

  @override
  Future<String?> read(final String key) async => _store[key];

  @override
  Future<void> write(final String key, final String value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(final String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}
