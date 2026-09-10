// Pure domain interface — no Flutter, no Riverpod, no Dio
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';

abstract interface class ConsentRepository {
  /// Returns `true` when the citizen identified by [idAgente] has already
  /// accepted the legal consent for the current version.
  ///
  /// Returns `true`/`false` only when the status is *known*: the remote
  /// service answered (a genuine 404 means "not registered" → `false`), or
  /// trusted local evidence of a previous acceptance exists. When the remote
  /// service cannot answer and there is no such evidence, throws
  /// `ConsentStatusUnknownException` — callers must not read that as
  /// "not accepted".
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
  ///
  /// Same three-state contract as [hasAcceptedConsent]: throws
  /// `ConsentStatusUnknownException` when the remote service cannot answer
  /// and no trusted local evidence of acceptance exists.
  Future<bool> hasAcceptedClause({
    required final String idAgente,
    required final int clauseId,
  });

  /// Returns the ordered list of optional authorisation clauses presented to
  /// the citizen. Throws `ConsentStatusUnknownException` when the remote
  /// service cannot answer, and [StateError] when it answers with no clauses.
  Future<List<Clause>> fetchClauses({final String? idAgente});

  /// Same as [fetchClauses] but **discarding any cached copy** first.
  ///
  /// [fetchClauses] and [hasAcceptedClause] are deliberately biased towards a
  /// remembered "accepted": the in-memory clause cache survives token
  /// refreshes and the persisted accepted-ids list is a positive-only
  /// fallback, so an outage never locks the citizen out. The price is that a
  /// revocation made elsewhere (the portal, another app) stays invisible.
  ///
  /// This is the read to use when the backend has just answered that the
  /// authorisation is missing: only a fresh answer can tell a genuine
  /// revocation from the gateway failing closed. Concurrent calls still share
  /// a single in-flight request.
  Future<List<Clause>> refreshClauses({required final String idAgente});
}
