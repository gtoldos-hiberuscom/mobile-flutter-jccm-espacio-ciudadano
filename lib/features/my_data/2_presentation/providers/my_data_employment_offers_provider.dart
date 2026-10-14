import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_guard.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_provider.dart';

final employmentOfferRegistrationsProvider = FutureProvider.autoDispose<List<EmploymentOfferRegistration>>((final ref) async {
  // Datos de muestra exclusivamente para el entorno de desarrollo. Permiten
  // revisar la composición de las tarjetas mientras el servicio de Empleo no
  // dispone de registros para el usuario de pruebas.
  if (ref.watch(appConfigProvider).debugMode) {
    return _developmentOfferRegistrations;
  }

  final documentNumber = employmentDocumentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el número de documento.');
  }

  final repository = ref.watch(myDataEmploymentRepositoryProvider);
  return withMyDataAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
    request: () => repository.loadOfferRegistrations(
      citizenId: ref.watch(citizenEndpointIdsProvider).requireIdAgente(),
      documentNumber: documentNumber,
    ),
  );
});

final _developmentOfferRegistrations = <EmploymentOfferRegistration>[
  EmploymentOfferRegistration(
    title: 'Auxiliar administrativo/a',
    applicationStatus: 'Inscrita',
    publicationDate: DateTime(2026, 9, 15),
    registrationDate: DateTime(2026, 9, 18),
    selectionEndDate: DateTime(2026, 10, 15),
  ),
  EmploymentOfferRegistration(
    title: 'Técnico/a de atención a la ciudadanía',
    applicationStatus: 'En proceso de selección',
    publicationDate: DateTime(2026, 8, 21),
    registrationDate: DateTime(2026, 8, 23),
    selectionEndDate: DateTime(2026, 9, 30),
  ),
];
