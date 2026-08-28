import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_expediente_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/usecases/buscar_expediente_tercero_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_expediente_repository_impl.dart';

/// Clave del detalle de expediente: `tercero` no nulo sustituye el
/// documento del JWT por el del titular localizado al aportar a un
/// expediente ajeno — necesario para no mezclar en caché el detalle de un
/// expediente propio con el de un tercero bajo la misma clave `numexp`.
typedef ExpedienteDetailKey = ({String numexp, TerceroIdentificacion? tercero});

final gestionExpedienteRepositoryProvider = Provider<GestionExpedienteRepository>((final ref) {
  return GestionExpedienteRepositoryImpl(dio: ref.watch(dioProvider));
});

final buscarExpedienteTerceroUsecaseProvider = Provider<BuscarExpedienteTerceroUsecase>((final ref) {
  return BuscarExpedienteTerceroUsecase(ref.watch(gestionExpedienteRepositoryProvider));
});

final expedientesProvider = FutureProvider.autoDispose<List<Expediente>>((final ref) async {
  // `citizenId` va en el path /ciudadanos/{sid} (sub_alt contra el gateway);
  // `documentNumber` es el NIF real que viaja en el cuerpo SOAP.
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireIdAgente();
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(gestionExpedienteRepositoryProvider);
  return repository.loadExpedientes(citizenId: citizenId, documentNumber: documentNumber);
});

final expedienteDetailProvider = FutureProvider.autoDispose.family<Expediente, ExpedienteDetailKey>((final ref, final key) async {
  final tercero = key.tercero;
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireIdAgente();
  final documentNumber = tercero?.documentNumber ?? _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(gestionExpedienteRepositoryProvider);
  return repository.loadExpedienteDetail(citizenId: citizenId, documentNumber: documentNumber, numexp: key.numexp, tipodoc: tercero?.tipodoc ?? 'NIF');
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
