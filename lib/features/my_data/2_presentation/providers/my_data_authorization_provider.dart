import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';

const jccmDataAuthorizationClauseId = jccmDataConsentClauseId;
const ageDataAuthorizationClauseId = ageDataConsentClauseId;

final jccmDataAuthorizationProvider = FutureProvider.autoDispose<bool>((final ref) async {
  return _hasAcceptedClause(ref, jccmDataAuthorizationClauseId);
});

final ageDataAuthorizationProvider = FutureProvider.autoDispose<bool>((final ref) async {
  return _hasAcceptedClause(ref, ageDataAuthorizationClauseId);
});

Future<bool> _hasAcceptedClause(final Ref ref, final int clauseId) async {
  final idAgente = ref.watch(citizenEndpointIdsProvider).idAgente;
  if (idAgente == null || idAgente.isEmpty) {
    return false;
  }

  final result = await ref
      .watch(checkAcceptedConsentClauseUsecaseProvider)
      .execute(
        idAgente: idAgente,
        clauseId: clauseId,
      );

  return switch (result) {
    AcceptedConsentClauseStatus(:final isAccepted) => isAccepted,
    // AsyncError, nunca false: con el backend caído no sabemos si la cláusula
    // está aceptada, y afirmar "no autorizado" miente sobre un consentimiento
    // RGPD que el ciudadano sí otorgó (mismo patrón que digital_cards).
    CheckAcceptedConsentClauseFailed(:final message) => throw StateError(message),
  };
}
