// No imports from 2_presentation, 3_data, package:flutter/*, Dio, or Riverpod
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

sealed class CheckConsentRequiredResult {
  const CheckConsentRequiredResult();
}

class ConsentRequired extends CheckConsentRequiredResult {
  const ConsentRequired();
}

class ConsentNotRequired extends CheckConsentRequiredResult {
  const ConsentNotRequired();
}

class CheckConsentRequiredFailed extends CheckConsentRequiredResult {
  const CheckConsentRequiredFailed(this.message);
  final String message;
}

/// Determines whether the authenticated citizen must complete the legal-consent
/// gate before accessing any functional authenticated surface.
class CheckConsentRequiredUsecase {
  const CheckConsentRequiredUsecase(this._repository);
  final ConsentRepository _repository;

  Future<CheckConsentRequiredResult> execute({
    required final String idAgente,
  }) async {
    try {
      final hasAccepted = await _repository.hasAcceptedConsent(
        idAgente: idAgente,
      );
      return hasAccepted ? const ConsentNotRequired() : const ConsentRequired();
    } catch (e) {
      return CheckConsentRequiredFailed(e.toString());
    }
  }
}
