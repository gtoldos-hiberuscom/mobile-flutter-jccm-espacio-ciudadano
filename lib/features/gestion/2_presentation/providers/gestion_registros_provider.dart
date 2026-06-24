import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_registros_repository.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/3_data/repositories/gestion_registros_repository_impl.dart';

final gestionRegistrosRepositoryProvider = Provider<GestionRegistrosRepository>((final ref) {
  return GestionRegistrosRepositoryImpl(dio: ref.watch(dioProvider));
});

final entradasProvider = FutureProvider.autoDispose<List<Registro>>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(gestionRegistrosRepositoryProvider);
  return repository.loadEntradas(documentNumber: documentNumber);
});

final salidasProvider = FutureProvider.autoDispose<List<Registro>>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(gestionRegistrosRepositoryProvider);
  return repository.loadSalidas(documentNumber: documentNumber);
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
