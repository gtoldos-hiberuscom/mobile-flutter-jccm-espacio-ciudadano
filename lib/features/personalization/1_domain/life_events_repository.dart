import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';

/// Domain contract for loading and persisting life-event preferences.
///
/// Only pure Dart types cross this boundary — no DTOs, generated models,
/// Dio responses, or infrastructure SDKs.
abstract interface class LifeEventsRepository {
  /// Loads the full life-event catalogue for the given citizen.
  ///
  /// Returns an empty list when the citizen has no registered preferences yet.
  /// Throws on network or deserialization failure.
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente});

  /// Persists the complete (mutated) list for the given citizen.
  ///
  /// Callers pass the full list rather than a delta so the backend can
  /// reconcile the selection atomically.
  Future<void> saveLifeEvents({
    required final String idAgente,
    required final List<LifeEvent> events,
  });

  /// Deletes all persisted life-event preferences for the citizen.
  ///
  /// After a successful reset the caller should reload the catalogue to
  /// reflect the cleared state.
  Future<void> resetPreferences({required final String idAgente});
}
