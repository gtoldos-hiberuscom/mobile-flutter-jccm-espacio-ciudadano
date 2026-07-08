// Pure domain interface — no Flutter, no Riverpod, no Dio
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';

abstract interface class ConsentRepository {
  /// Returns `true` when the citizen identified by [idAgente] has already
  /// accepted the legal consent for the current version.
  Future<bool> hasAcceptedConsent({required final String idAgente});

  /// Persists that the citizen completed the legal consent step and records
  /// which optional clauses were accepted.
  Future<void> markConsentAccepted({
    required final String idAgente,
    required final List<Clause> clauses,
  });

  /// Resets every persisted clause to rejected for [idAgente].
  ///
  /// This must not create a new remote preference if the citizen does not have
  /// one yet; account deletion should leave the profile as a fresh user.
  Future<void> resetConsentClauses({required final String idAgente});

  /// Returns `true` when the citizen accepted the optional clause [clauseId].
  Future<bool> hasAcceptedClause({
    required final String idAgente,
    required final int clauseId,
  });

  /// Returns the ordered list of optional authorisation clauses presented to
  /// the citizen. Falls back to a hardcoded static list when remote data is
  /// unavailable.
  Future<List<Clause>> fetchClauses({final String? idAgente});
}
