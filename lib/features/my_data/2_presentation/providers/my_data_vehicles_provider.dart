import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_vehicles_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_vehicles_repository_impl.dart';

final myDataVehiclesRepositoryProvider = Provider<MyDataVehiclesRepository>((final ref) {
  return MyDataVehiclesRepositoryImpl(dio: ref.watch(dioProvider));
});

final vehiclesProvider = FutureProvider.autoDispose<List<Vehicle>>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(myDataVehiclesRepositoryProvider);
  return repository.loadVehicles(documentNumber: documentNumber);
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
