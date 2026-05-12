import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/onboarding_preferences_repository.dart';

// No imports from 2_presentation, 3_data, package:flutter/*, Dio, or Riverpod

sealed class CheckLifeEventsOnboardingResult {
  const CheckLifeEventsOnboardingResult();
}

class CheckLifeEventsOnboardingSuccess
    extends CheckLifeEventsOnboardingResult {
  const CheckLifeEventsOnboardingSuccess(this.hasSeen);
  final bool hasSeen;
}

class CheckLifeEventsOnboardingFailed extends CheckLifeEventsOnboardingResult {
  const CheckLifeEventsOnboardingFailed(this.message);
  final String message;
}

class CheckLifeEventsOnboardingUsecase {
  const CheckLifeEventsOnboardingUsecase(this._repository);
  final OnboardingPreferencesRepository _repository;

  Future<CheckLifeEventsOnboardingResult> execute({
    required final String idAgente,
  }) async {
    try {
      final hasSeen = await _repository.hasSeenLifeEventsOnboarding(
        idAgente: idAgente,
      );
      return CheckLifeEventsOnboardingSuccess(hasSeen);
    } catch (e) {
      return CheckLifeEventsOnboardingFailed(e.toString());
    }
  }
}
