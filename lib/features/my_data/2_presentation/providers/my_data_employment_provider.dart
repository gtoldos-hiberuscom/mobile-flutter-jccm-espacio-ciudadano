import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_employment_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_guard.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_employment_repository_impl.dart';

final myDataEmploymentRepositoryProvider = Provider<MyDataEmploymentRepository>((final ref) {
  return MyDataEmploymentRepositoryImpl(dio: ref.watch(dioProvider));
});

final employmentOffersAuthorizationProvider = FutureProvider.autoDispose<bool>((final ref) async {
  return ref.watch(jccmDataAuthorizationProvider.future);
});

final employmentDemandProvider = FutureProvider.autoDispose<EmploymentDemand?>((final ref) async {
  final claims = ref.watch(jwtClaimsProvider);
  final documentNumber = employmentDocumentNumber(claims);
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(myDataEmploymentRepositoryProvider);
  return withMyDataAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId, ageDataConsentClauseId},
    request: () => repository.loadDemand(
      citizenId: ref.watch(citizenEndpointIdsProvider).requireNumDocumento(),
      documentNumber: documentNumber,
      givenName: claims?.givenName,
      firstSurname: claims?.firstSurname,
      secondSurname: claims?.secondSurname,
    ),
  );
});

/// Documento sobre el que se consulta, que viaja en el cuerpo.
///
/// No confundir con el segmento de ruta, que resuelve
/// `citizenEndpointIdsProvider` y que contra el gateway es `sub_alt`.
String? employmentDocumentNumber(final JwtClaims? claims) {
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
