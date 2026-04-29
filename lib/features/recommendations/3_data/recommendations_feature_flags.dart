/// Compile-time flag controlling whether the recommendations feature
/// hits the live backend (`/hechos-vitales/servicios/...`) or the
/// in-memory mock shipped with Sprint 6.
///
/// Per TASK-58 §D6 this flag stays `false` until OP-1..OP-4 are
/// resolved and the live HTTP repository is wired in a follow-up
/// sprint. Flipping it without that wiring will throw at runtime via
/// the provider in `recommendations_repository_provider.dart`.
const bool kRecommendationsLiveBackendEnabled = false;
