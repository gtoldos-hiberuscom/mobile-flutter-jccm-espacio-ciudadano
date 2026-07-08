import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_expediente_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_expediente_repository_impl.dart';

final gestionExpedienteRepositoryProvider = Provider<GestionExpedienteRepository>((final ref) {
  return GestionExpedienteRepositoryImpl(dio: ref.watch(dioProvider));
});

final expedientesProvider = FutureProvider.autoDispose<List<Expediente>>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(gestionExpedienteRepositoryProvider);
  return repository.loadExpedientes(documentNumber: documentNumber);
});

final expedienteDetailProvider = FutureProvider.autoDispose.family<Expediente, String>((final ref, final numexp) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(gestionExpedienteRepositoryProvider);
  return repository.loadExpedienteDetail(documentNumber: documentNumber, numexp: numexp);
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
