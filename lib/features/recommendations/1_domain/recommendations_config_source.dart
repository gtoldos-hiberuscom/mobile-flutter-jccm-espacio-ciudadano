import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart' show RecommendationsRepository;

/// Domain port (STORY-57) that resolves the citizen's *Mis
/// Recomendaciones* configuration state.
///
/// Decoupled from [RecommendationsRepository] on purpose: STORY-57 only
/// needs the coarse [RecommendationsConfigState] to drive the empty /
/// onboarding view, and we want to keep the door open for a future
/// implementation that probes a different surface (preferences profile,
/// permissions registry, …) without dragging the recommendations list
/// repository along.
abstract interface class RecommendationsConfigSource {
  /// Returns the current configuration state. Implementations should
  /// keep this cheap — it is awaited on every page entry.
  Future<RecommendationsConfigState> loadState();

  /// Records that the citizen just came back from the preferences /
  /// consent flow. Live impls will refresh the underlying preferences
  /// snapshot; the in-memory mock simply bumps to
  /// [RecommendationsConfigState.configured] so the empty view rebuilds
  /// into the populated list on the next read.
  ///
  // TODO(future-sprint): wire this from the navigation pop callback once
  //                      the Mis preferencias / Mis hechos vitales flow
  //                      lands and reports completion back to the
  //                      recommendations surface.
  Future<void> markPreferencesAcknowledged();
}
