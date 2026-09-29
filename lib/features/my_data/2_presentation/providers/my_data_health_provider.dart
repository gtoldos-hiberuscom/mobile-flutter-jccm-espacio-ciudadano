import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_guard.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment_access.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_guard.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_health_repository_impl.dart';

final myDataHealthRepositoryProvider = Provider<MyDataHealthRepository>((final ref) {
  return MyDataHealthRepositoryImpl(dio: ref.watch(dioProvider));
});

/// CIP del ciudadano. Se resuelve aparte del listado de citas para que un fallo
/// en una consulta no deje sin datos a la otra.
final myDataHealthCipProvider = FutureProvider.autoDispose<String?>((final ref) async {
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireNumDocumento();
  return withMyDataAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
    request: () => ref.watch(myDataHealthRepositoryProvider).loadCip(citizenId: citizenId),
  );
});

/// Citas pendientes de atención primaria.
///
/// El listado de pasadas vive en `pastPrimaryCareAppointmentsProvider` porque es
/// el único paginado: sólo esa operación acepta el parámetro `pagina`.
final myDataPrimaryCarePendingAppointmentsProvider = FutureProvider.autoDispose<List<HealthAppointment>>((final ref) async {
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireNumDocumento();
  return withMyDataAuthorizationGuard(
    ref,
    requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
    request: () => ref
        .watch(myDataHealthRepositoryProvider)
        .loadPrimaryCareAppointments(
          citizenId: citizenId,
          filter: HealthAppointmentFilter.pending,
        ),
  );
});

/// Citas hospitalarias del SESCAM.
///
/// Doble puerta, y el orden importa: **primero el nivel, después las
/// cláusulas**. Por dos razones, las dos deliberadas:
///
/// - El nivel se decide en local, así que no puede dar un mensaje falso porque
///   se haya caído el servicio de preferencias. El de cláusulas sí depende de
///   red.
/// - Elevar el nivel implica volver a identificarse, y eso puede acabar en otra
///   identidad; cualquier lectura de cláusulas hecha antes quedaría obsoleta.
///
/// El coste asumido es que quien tenga las dos cosas pendientes haga dos
/// viajes. Con el orden inverso también serían dos, pero empezando por el
/// mensaje equivocado.
final myDataHospitalAppointmentsProvider = FutureProvider.autoDispose.family<List<HospitalAppointment>, HealthAppointmentFilter>((
  final ref,
  final filter,
) async {
  return withAuthenticationLevelGuard(
    ref,
    minimum: kHospitalAppointmentsMinimumLevel,
    request: () {
      final citizenId = ref.watch(citizenEndpointIdsProvider).requireIdAgente();
      return withMyDataAuthorizationGuard(
        ref,
        requiredClauseIds: const {requiredConsentClauseId, jccmDataConsentClauseId},
        request: () => ref
            .watch(myDataHealthRepositoryProvider)
            .loadHospitalAppointments(
              citizenId: citizenId,
              filter: filter,
            ),
      );
    },
  );
});
