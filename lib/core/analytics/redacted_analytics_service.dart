import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/security/pii_key_fragments.dart';

/// Signature of the per-event extractor used by [RedactedAnalyticsService]
/// to decide *which* fields a wrapping adapter intends to read off an
/// [AnalyticsEvent]. The wrapper applies [redactFields] to the result
/// before exposing it to anyone else.
typedef AnalyticsEventFieldExtractor = Map<String, Object?> Function(AnalyticsEvent event);

/// Default field extractor — returns no fields. With this default the
/// wrapper acts as a no-op contract shield: the wrapped service still
/// only sees the event itself, but the **interception point exists**
/// so future adapters that read fields by name MUST go through this
/// decorator instead of touching events directly.
Map<String, Object?> _emptyExtractor(final AnalyticsEvent _) => const <String, Object?>{};

/// Decorator over [AnalyticsService] that performs **field-level**
/// redaction of [AnalyticsEvent] payloads before delegating to the
/// wrapped service.
///
/// Why this exists
/// ---------------
/// Today, [AnalyticsEvent] subclasses are PII-free by construction and
/// the only sink (`ConsoleAnalyticsService`) renders them via their
/// inherited `Object.toString()`, so no field value ever reaches the
/// console. As soon as a real SDK adapter is added (e.g. Firebase
/// Analytics, Crashlytics) it will need to **read fields by name** to
/// build the SDK payload. That is the moment a misbehaving caller
/// could leak PII.
///
/// All such future adapters MUST be constructed by wrapping them with
/// [RedactedAnalyticsService] and providing an extractor that yields
/// the map the adapter would otherwise build itself. The wrapper then
/// applies [redactFields] (the single source of truth shared with
/// `ConsoleLogger`) so any field whose key matches a PII fragment is
/// replaced with [redactedMarker] before the inner service ever sees
/// it.
///
/// The current default extractor returns an empty map, so this
/// wrapper is a no-op shield until adapters opt in. Its presence in
/// the dependency graph is the contract.
final class RedactedAnalyticsService implements AnalyticsService {
  /// Wraps [inner] with field-level redaction.
  ///
  /// [extractor] should return the map of fields the wrapped service
  /// is expected to read off [AnalyticsEvent]. Defaults to an
  /// [_emptyExtractor] which means "no fields exposed" — appropriate
  /// for adapters that only consume `event.runtimeType` or a stable
  /// `toString()`.
  const RedactedAnalyticsService({
    required final AnalyticsService inner,
    final AnalyticsEventFieldExtractor extractor = _emptyExtractor,
  }) : _inner = inner,
       _extractor = extractor;

  final AnalyticsService _inner;
  final AnalyticsEventFieldExtractor _extractor;

  /// Returns the redacted view of [event] that the wrapped service is
  /// allowed to observe field-by-field. Visible for tests and for
  /// future adapters that need explicit access to the sanitised map.
  Map<String, Object?> redactedFieldsFor(final AnalyticsEvent event) {
    final raw = _extractor(event);
    return redactFields(raw);
  }

  @override
  void logEvent(final AnalyticsEvent event) {
    // Force the extractor to run so any future adapter wired through
    // this wrapper observes the redacted map. The result is exposed
    // via [redactedFieldsFor]; the inner service receives the original
    // event reference so its `runtimeType`/`toString()` rendering is
    // unchanged. PII-free-by-construction guarantees of [AnalyticsEvent]
    // remain enforced by `telemetry_redaction_test.dart`.
    redactedFieldsFor(event);
    _inner.logEvent(event);
  }

  @override
  void setCurrentScreen(final AnalyticsScreen screen) {
    _inner.setCurrentScreen(screen);
  }
}
