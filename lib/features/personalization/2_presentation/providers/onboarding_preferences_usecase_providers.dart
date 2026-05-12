import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/check_life_events_onboarding_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/mark_life_events_onboarding_seen_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/onboarding_preferences_repository_provider.dart';

final checkLifeEventsOnboardingUsecaseProvider =
    Provider<CheckLifeEventsOnboardingUsecase>((final ref) {
  return CheckLifeEventsOnboardingUsecase(
    ref.watch(onboardingPreferencesRepositoryProvider),
  );
});

final markLifeEventsOnboardingSeenUsecaseProvider =
    Provider<MarkLifeEventsOnboardingSeenUsecase>((final ref) {
  return MarkLifeEventsOnboardingSeenUsecase(
    ref.watch(onboardingPreferencesRepositoryProvider),
  );
});
