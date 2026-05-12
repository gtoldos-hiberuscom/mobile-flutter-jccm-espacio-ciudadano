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

/// Loads the ordered list of legal-authorisation clauses the citizen must
/// accept during the consent onboarding flow.
class LoadClausesUsecase {
  const LoadClausesUsecase(this._repository);
  final ConsentRepository _repository;

  Future<LoadClausesResult> execute() async {
    try {
      final clauses = await _repository.fetchClauses();
      return LoadClausesSuccess(clauses);
    } catch (e) {
      return LoadClausesFailed(e.toString());
    }
  }
}
