import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';

/// Visual / behavioural variants of the *Mis Recomendaciones* empty
/// state, owned by STORY-57.
///
/// Maps the cross-product of [RecommendationsConfigState] and the
/// per-bucket "is the list empty?" predicate down to the three branches
/// described in `documentation/discovery/TASK-58-recommendations-segmentation-strategy.md`
/// §D5:
///
/// - [unconfigured]      → onboarding CTA toward life-events / preferences.
/// - [unauthorised]      → CTA toward the consent / authorisation surface.
/// - [configuredButEmpty] → backend has nothing to recommend right now.
enum RecommendationsEmptyVariant {
  unconfigured,
  unauthorised,
  configuredButEmpty;

  /// Pure mapping helper.
  ///
  /// - [RecommendationsConfigState.unconfigured] → [unconfigured].
  /// - [RecommendationsConfigState.unauthorised] → [unauthorised].
  /// - [RecommendationsConfigState.configured] → [configuredButEmpty]
  ///   (the helper is only meaningful when the bucket is actually empty;
  ///   the [bucketHasItems] flag is accepted for symmetry and for tests
  ///   that exercise the truth table exhaustively).
  ///
  /// Per the contract: "Bucket-empty + configured → configuredButEmpty.
  /// Anything else takes the config branch."
  static RecommendationsEmptyVariant from({
    required final RecommendationsConfigState config,
    required final bool bucketHasItems,
  }) {
    switch (config) {
      case RecommendationsConfigState.unconfigured:
        return RecommendationsEmptyVariant.unconfigured;
      case RecommendationsConfigState.unauthorised:
        return RecommendationsEmptyVariant.unauthorised;
      case RecommendationsConfigState.configured:
        return RecommendationsEmptyVariant.configuredButEmpty;
    }
  }
}
