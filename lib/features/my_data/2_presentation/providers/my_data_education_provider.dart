import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/non_university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_education_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_education_repository_impl.dart';

final myDataEducationRepositoryProvider = Provider<MyDataEducationRepository>((final ref) {
  return MyDataEducationRepositoryImpl(dio: ref.watch(dioProvider));
});

final universityTitlesProvider = FutureProvider.autoDispose<List<UniversityTitle>>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(myDataEducationRepositoryProvider);
  return repository.loadUniversityTitles(
    citizenId: ref.watch(citizenEndpointIdsProvider).requireNumDocumento(),
    documentNumber: documentNumber,
  );
});

final nonUniversityTitlesProvider = FutureProvider.autoDispose<List<NonUniversityTitle>>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(myDataEducationRepositoryProvider);
  return repository.loadNonUniversityTitles(
    citizenId: ref.watch(citizenEndpointIdsProvider).requireNumDocumento(),
    documentNumber: documentNumber,
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
