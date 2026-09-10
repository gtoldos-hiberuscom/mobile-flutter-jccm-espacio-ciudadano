import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/consent_revocation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';

/// Ejecuta [request] y, si el backend responde que falta autorización,
/// averigua **cuál** falta antes de que la pantalla decida qué mostrar.
///
/// Los repositorios lanzan [AuthorizationRequiredException] al reconocer el
/// sobre `412.00`/`3034`, que no distingue una revocación real de un fallo del
/// servicio de preferencias. Aquí se resuelve contra una lectura fresca de las
/// cláusulas y se relanza el resultado como [AuthorizationFailure], de modo
/// que la UI solo tiene que distinguir tres casos:
///
/// - [ConsentRevoked] — además dispara el cierre de sesión (una sola vez).
/// - [ClauseMissing] — la pantalla ofrece concederla en Preferencias.
/// - [AuthorizationUnknown] — error reintentable, sin acusar al ciudadano.
///
/// Cualquier otro error pasa de largo sin tocarse.
Future<T> withAuthorizationGuard<T>(
  final Ref ref, {
  required final Set<int> requiredClauseIds,
  required final Future<T> Function() request,
}) async {
  try {
    return await request();
  } on AuthorizationRequiredException catch (error) {
    final idAgente = ref.read(citizenEndpointIdsProvider).idAgente ?? '';
    if (idAgente.isEmpty) {
      throw AuthorizationUnknown('Sin idAgente para releer las cláusulas ($error)');
    }

    final failure = await ref
        .read(resolveAuthorizationFailureUsecaseProvider)
        .execute(
          idAgente: idAgente,
          requiredClauseIds: requiredClauseIds,
        );

    if (failure is ConsentRevoked) {
      await ref.read(consentRevocationProvider.notifier).signalRevoked();
    }
    throw failure;
  }
}
