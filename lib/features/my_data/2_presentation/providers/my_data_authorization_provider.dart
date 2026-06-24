import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';

const jccmDataAuthorizationClauseId = 1;
const ageDataAuthorizationClauseId = 2;

final jccmDataAuthorizationProvider = FutureProvider.autoDispose<bool>((final ref) async {
  return _hasAcceptedClause(ref, jccmDataAuthorizationClauseId);
});

final ageDataAuthorizationProvider = FutureProvider.autoDispose<bool>((final ref) async {
  return _hasAcceptedClause(ref, ageDataAuthorizationClauseId);
});

Future<bool> _hasAcceptedClause(final Ref ref, final int clauseId) async {
  final idAgente = ref.watch(jwtClaimsProvider)?.idAgente?.trim();
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
    CheckAcceptedConsentClauseFailed() => false,
  };
}
