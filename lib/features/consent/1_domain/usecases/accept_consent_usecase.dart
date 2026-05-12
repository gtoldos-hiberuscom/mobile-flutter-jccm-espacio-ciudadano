// No imports from 2_presentation, 3_data, package:flutter/*, Dio, or Riverpod
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

sealed class AcceptConsentResult {
  const AcceptConsentResult();
}

class AcceptConsentSuccess extends AcceptConsentResult {
  const AcceptConsentSuccess();
}

class AcceptConsentFailed extends AcceptConsentResult {
  const AcceptConsentFailed(this.message);
  final String message;
}

/// Persists the citizen's acceptance of all legal consent clauses.
class AcceptConsentUsecase {
  const AcceptConsentUsecase(this._repository);
  final ConsentRepository _repository;

  Future<AcceptConsentResult> execute({
    required final String idAgente,
  }) async {
    try {
      await _repository.markConsentAccepted(idAgente: idAgente);
      return const AcceptConsentSuccess();
    } catch (e) {
      return AcceptConsentFailed(e.toString());
    }
  }
}
