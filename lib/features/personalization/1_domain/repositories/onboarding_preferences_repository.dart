// Pure domain interface — no Flutter, no Riverpod, no Dio
abstract interface class OnboardingPreferencesRepository {
  /// Returns true when the citizen has already seen the life-events onboarding
  /// screen.
  Future<bool> hasSeenLifeEventsOnboarding({required final String idAgente});

  /// Persists the fact that the citizen has seen the life-events onboarding
  /// screen.
  Future<void> markLifeEventsOnboardingSeen({required final String idAgente});
}
