import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_repository.dart';
import 'package:jccm_espacio_ciudadano/features/education/3_data/education_repository_impl.dart';

/// DI composition for [EducationRepository].
///
/// [currentAuthUserProvider] is watched so the repository is recreated
/// whenever the authenticated user changes (login / logout).
final educationRepositoryProvider = Provider<EducationRepository>((final ref) {
  final dio = ref.watch(dioProvider);
  return EducationRepositoryImpl(
    apiWrapper: EducacionApi(dio, standardSerializers),
    numDocumento: ref.watch(jwtClaimsProvider)?.personIdentifier ?? 'ERROR',
  );
});
