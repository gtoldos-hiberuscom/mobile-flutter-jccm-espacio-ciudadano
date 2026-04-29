/// Coarse configuration state used to short-circuit the recommendations
/// list before issuing a paged request.
///
/// STORY-56 only acts on [configured] (renders the live list); the other
/// two values are wired by STORY-57 (empty / onboarding variants) and
/// today simply cause STORY-56 to render an empty placeholder.
enum RecommendationsConfigState {
  /// Citizen has not selected any life event yet.
  unconfigured,

  /// Citizen selected life events but has not granted authorisation.
  unauthorised,

  /// Citizen is fully configured and the list can be requested.
  configured,
}
