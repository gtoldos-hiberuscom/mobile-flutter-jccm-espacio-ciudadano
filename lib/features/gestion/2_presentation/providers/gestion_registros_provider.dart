import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/authorization_guard.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_registros_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_registros_repository_impl.dart';

final gestionRegistrosRepositoryProvider = Provider<GestionRegistrosRepository>((final ref) {
  return GestionRegistrosRepositoryImpl(dio: ref.watch(dioProvider));
});

final entradasProvider = FutureProvider.autoDispose<List<Registro>>(retry: _noRetryOnAuthorization, (final ref) async {
  // `citizenId` va en el path /ciudadanos/{sid} (sub_alt contra el gateway);
  // `documentNumber` es el NIF real que viaja en el cuerpo SOAP.
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireIdAgente();
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  // Expedientes y registros solo exigen la cláusula obligatoria: no hay cláusula
  // intermedia que ofrecer, así que el rechazo solo puede ser revocación (cierra
  // sesión) o fallo transitorio (error con reintento).
  final repository = ref.watch(gestionRegistrosRepositoryProvider);
  return withAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId},
    request: () => repository.loadEntradas(citizenId: citizenId, documentNumber: documentNumber),
  );
});

final salidasProvider = FutureProvider.autoDispose<List<Registro>>(retry: _noRetryOnAuthorization, (final ref) async {
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireIdAgente();
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(gestionRegistrosRepositoryProvider);
  return withAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId},
    request: () => repository.loadSalidas(citizenId: citizenId, documentNumber: documentNumber),
  );
});

String? _documentNumber(final JwtClaims? claims) {
  final candidates = [
    claims?.personIdentifier,
    claims?.preferredUsername,
    claims?.sub,
  ];
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}

/// El rechazo por autorización no se reintenta con espera creciente: lo
/// resuelve el guard y la pantalla ya ofrece reintentar.
Duration? _noRetryOnAuthorization(final int retryCount, final Object error) {
  if (error is AuthorizationFailure) {
    return null;
  }
  return ProviderContainer.defaultRetry(retryCount, error);
}
