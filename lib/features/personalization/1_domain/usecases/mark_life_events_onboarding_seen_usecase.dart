import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/onboarding_preferences_repository.dart';

// No imports from 2_presentation, 3_data, package:flutter/*, Dio, or Riverpod

sealed class MarkLifeEventsOnboardingSeenResult {
  const MarkLifeEventsOnboardingSeenResult();
}

class MarkLifeEventsOnboardingSeenSuccess
    extends MarkLifeEventsOnboardingSeenResult {
  const MarkLifeEventsOnboardingSeenSuccess();
}

class MarkLifeEventsOnboardingSeenFailed
    extends MarkLifeEventsOnboardingSeenResult {
  const MarkLifeEventsOnboardingSeenFailed(this.message);
  final String message;
}

class MarkLifeEventsOnboardingSeenUsecase {
  const MarkLifeEventsOnboardingSeenUsecase(this._repository);
  final OnboardingPreferencesRepository _repository;

  Future<MarkLifeEventsOnboardingSeenResult> execute({
    required final String idAgente,
  }) async {
    try {
      await _repository.markLifeEventsOnboardingSeen(idAgente: idAgente);
      return const MarkLifeEventsOnboardingSeenSuccess();
    } catch (e) {
      return MarkLifeEventsOnboardingSeenFailed(e.toString());
    }
  }
}
