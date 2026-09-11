// No imports from 2_presentation, 3_data, package:flutter/*, Dio, or Riverpod
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

sealed class ResetConsentClausesResult {
  const ResetConsentClausesResult();
}

class ResetConsentClausesSuccess extends ResetConsentClausesResult {
  const ResetConsentClausesSuccess();
}

class ResetConsentClausesFailed extends ResetConsentClausesResult {
  const ResetConsentClausesFailed(this.message, {this.cause});
  final String message;
  final Object? cause;
}

/// Clears all legal-consent clause selections for a citizen.
class ResetConsentClausesUsecase {
  const ResetConsentClausesUsecase(this._repository);
  final ConsentRepository _repository;

  Future<ResetConsentClausesResult> execute({
    required final String idAgente,
  }) async {
    try {
      await _repository.resetConsentClauses(idAgente: idAgente);
      return const ResetConsentClausesSuccess();
    } catch (e) {
      return ResetConsentClausesFailed(e.toString(), cause: e);
    }
  }
}
