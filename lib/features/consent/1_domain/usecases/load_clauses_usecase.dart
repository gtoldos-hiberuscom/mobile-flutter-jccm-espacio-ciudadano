// No imports from 2_presentation, 3_data, package:flutter/*, Dio, or Riverpod
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

sealed class LoadClausesResult {
  const LoadClausesResult();
}

class LoadClausesSuccess extends LoadClausesResult {
  const LoadClausesSuccess(this.clauses);
  final List<Clause> clauses;
}

class LoadClausesFailed extends LoadClausesResult {
  const LoadClausesFailed(this.message);
  final String message;
}

/// Loads the ordered list of optional legal-authorisation clauses presented
/// during the consent onboarding flow.
class LoadClausesUsecase {
  const LoadClausesUsecase(this._repository);
  final ConsentRepository _repository;

  Future<LoadClausesResult> execute({
    final String? idAgente,
  }) async {
    try {
      var clauses = await _repository.fetchClauses();
      if (idAgente != null && idAgente.isNotEmpty) {
        clauses = await Future.wait(
          clauses.map((final clause) async {
            final isAccepted = await _repository.hasAcceptedClause(
              idAgente: idAgente,
              clauseId: clause.id,
            );
            return clause.copyWith(isSelected: isAccepted);
          }),
        );
      }
      return LoadClausesSuccess(clauses);
    } catch (e) {
      return LoadClausesFailed(e.toString());
    }
  }
}
