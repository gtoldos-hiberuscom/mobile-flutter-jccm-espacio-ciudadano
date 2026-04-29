/// The four UI tabs / segmentation buckets exposed by STORY-56.
///
/// Mapping to backend operations (see TASK-58 §D1):
///
/// - [todos]                → `GET /hechos-vitales/servicios/{idAgente}` (7.1)
/// - [ultimosDias]          → 7.2 with `operacion=ultimos_dias`
/// - [novedades]            → 7.2 with `operacion=novedades`
/// - [tramitacionInmediata] → 7.2 with `operacion=inmediatos`
enum RecommendationBucket {
  todos,
  ultimosDias,
  novedades,
  tramitacionInmediata,
}

/// l10n key per bucket — resolved at the presentation layer against
/// `AppLocalizations`.
abstract final class RecommendationBucketLabels {
  static const Map<RecommendationBucket, String> l10nKey = {
    RecommendationBucket.todos: 'recommendationsTabAll',
    RecommendationBucket.ultimosDias: 'recommendationsTabRecent',
    RecommendationBucket.novedades: 'recommendationsTabNew',
    RecommendationBucket.tramitacionInmediata: 'recommendationsTabImmediate',
  };

  /// Backend `operacion` query parameter for buckets that map to 7.2.
  ///
  /// `null` for [RecommendationBucket.todos] (which calls 7.1 instead).
  static const Map<RecommendationBucket, String?> backendOperation = {
    RecommendationBucket.todos: null,
    RecommendationBucket.ultimosDias: 'ultimos_dias',
    RecommendationBucket.novedades: 'novedades',
    RecommendationBucket.tramitacionInmediata: 'inmediatos',
  };
}
