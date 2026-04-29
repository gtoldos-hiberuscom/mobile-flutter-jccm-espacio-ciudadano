import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_page_result.dart';

/// Domain contract for *Mis Recomendaciones* (STORY-56 / STORY-57).
///
/// Sprint 6 ships a mock implementation; live wiring against
/// `/hechos-vitales/servicios/{idAgente}` (7.1) and
/// `/hechos-vitales/servicios/segmentacion/{idAgente}` (7.2) is deferred
/// behind `kRecommendationsLiveBackendEnabled`
/// (see TASK-58 §D6 and `recommendations_feature_flags.dart`).
abstract interface class RecommendationsRepository {
  /// Loads one page of the unfiltered "Todos" tab (endpoint 7.1).
  Future<RecommendationsPageResult> loadAll({final String? cursor});

  /// Loads one page for a segmented bucket (endpoint 7.2).
  ///
  /// Implementations must accept [RecommendationBucket.todos] and
  /// delegate to [loadAll] for symmetry.
  Future<RecommendationsPageResult> loadBucket(
    final RecommendationBucket bucket, {
    final String? cursor,
  });

  /// Quick configuration probe used to decide whether to render the list
  /// or short-circuit to an empty / onboarding state. STORY-57 owns the
  /// onboarding variants; STORY-56 only relies on this to know whether
  /// the list query should run.
  Future<RecommendationsConfigState> loadConfigState();
}
