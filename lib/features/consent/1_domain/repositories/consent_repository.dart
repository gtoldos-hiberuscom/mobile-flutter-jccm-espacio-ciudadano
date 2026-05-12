// Pure domain interface — no Flutter, no Riverpod, no Dio
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';

abstract interface class ConsentRepository {
  /// Returns `true` when the citizen identified by [idAgente] has already
  /// accepted the legal consent for the current version.
  Future<bool> hasAcceptedConsent({required final String idAgente});

  /// Persists the fact that the citizen has accepted the legal consent.
  Future<void> markConsentAccepted({required final String idAgente});

  /// Returns the ordered list of authorisation clauses the citizen must
  /// accept. Falls back to a hardcoded static list when remote data is
  /// unavailable.
  Future<List<Clause>> fetchClauses();
}
