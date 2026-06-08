import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

sealed class CheckAcceptedConsentClauseResult {
  const CheckAcceptedConsentClauseResult();
}

class AcceptedConsentClauseStatus extends CheckAcceptedConsentClauseResult {
  const AcceptedConsentClauseStatus(this.isAccepted);
  final bool isAccepted;
}

class CheckAcceptedConsentClauseFailed extends CheckAcceptedConsentClauseResult {
  const CheckAcceptedConsentClauseFailed(this.message);
  final String message;
}

class CheckAcceptedConsentClauseUsecase {
  const CheckAcceptedConsentClauseUsecase(this._repository);
  final ConsentRepository _repository;

  Future<CheckAcceptedConsentClauseResult> execute({
    required final String idAgente,
    required final int clauseId,
  }) async {
    try {
      final isAccepted = await _repository.hasAcceptedClause(
        idAgente: idAgente,
        clauseId: clauseId,
      );
      return AcceptedConsentClauseStatus(isAccepted);
    } catch (e) {
      return CheckAcceptedConsentClauseFailed(e.toString());
    }
  }
}
