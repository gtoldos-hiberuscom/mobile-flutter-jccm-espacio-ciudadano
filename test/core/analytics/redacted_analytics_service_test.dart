import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/redacted_analytics_service.dart';

void main() {
  group('RedactedAnalyticsService', () {
    late _CapturingAnalytics inner;

    setUp(() {
      inner = _CapturingAnalytics();
    });

    test('default extractor exposes no fields (no-op shield)', () {
      final wrapper = RedactedAnalyticsService(inner: inner);
      const event = PageViewEvent('/home');

      wrapper.logEvent(event);

      expect(inner.events, hasLength(1));
      expect(inner.events.single, same(event));
      expect(wrapper.redactedFieldsFor(event), isEmpty);
    });

    test('custom extractor: PII-keyed fields are redacted, benign fields pass through', () {
      // Simulate a future Firebase-style adapter that needs to read
      // fields off an event to build the SDK payload. We re-purpose
      // an existing concrete event (HomeBlockNavigateEvent) to carry
      // PII-shaped values into PII-named extractor keys ("idAgente",
      // "nif") plus one benign key ("screen"). Real callers would
      // never push PII into these fields — the test models the
      // misbehaving-caller scenario the wrapper is meant to defend
      // against.
      const event = HomeBlockNavigateEvent('AG-007731', target: '/home');
      const piiNif = '12345678Z';
      final wrapper = RedactedAnalyticsService(
        inner: inner,
        extractor: (final e) {
          final navEvent = e as HomeBlockNavigateEvent;
          return <String, Object?>{
            'idAgente': navEvent.blockId,
            'userDni': piiNif,
            'screen': navEvent.target,
          };
        },
      );

      final redacted = wrapper.redactedFieldsFor(event);

      // Benign field is preserved verbatim.
      expect(redacted['screen'], '/home');
      // PII-keyed fields are replaced with the canonical marker.
      expect(redacted['userDni'], '[REDACTED]');
      expect(redacted['idAgente'], '[REDACTED]');
      expect(redacted.values, isNot(contains('12345678Z')));
      expect(redacted.values, isNot(contains('AG-007731')));

      // Inner service still receives the original event reference;
      // its rendering is governed by the toString() contract in
      // telemetry_redaction_test.dart.
      wrapper.logEvent(event);
      expect(inner.events.single, same(event));
    });

    test('setCurrentScreen is forwarded unchanged', () {
      RedactedAnalyticsService(inner: inner).setCurrentScreen(AnalyticsScreen.profile);
      expect(inner.screens, [AnalyticsScreen.profile]);
    });
  });
}

class _CapturingAnalytics implements AnalyticsService {
  final List<AnalyticsEvent> events = <AnalyticsEvent>[];
  final List<AnalyticsScreen> screens = <AnalyticsScreen>[];

  @override
  void logEvent(final AnalyticsEvent event) => events.add(event);

  @override
  void setCurrentScreen(final AnalyticsScreen screen) => screens.add(screen);
}
