import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_health_repository_impl.dart';

final myDataHealthRepositoryProvider = Provider<MyDataHealthRepository>((final ref) {
  return MyDataHealthRepositoryImpl(dio: ref.watch(dioProvider));
});

/// CIP del ciudadano. Se resuelve aparte del listado de citas para que un fallo
/// en una consulta no deje sin datos a la otra.
final myDataHealthCipProvider = FutureProvider.autoDispose<String?>((final ref) async {
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireNumDocumento();
  return ref.watch(myDataHealthRepositoryProvider).loadCip(citizenId: citizenId);
});

/// Citas pendientes de atención primaria.
///
/// El listado de pasadas vive en `pastPrimaryCareAppointmentsProvider` porque es
/// el único paginado: sólo esa operación acepta el parámetro `pagina`.
final myDataPrimaryCarePendingAppointmentsProvider = FutureProvider.autoDispose<List<HealthAppointment>>((final ref) async {
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireNumDocumento();
  return ref.watch(myDataHealthRepositoryProvider).loadPrimaryCareAppointments(
    citizenId: citizenId,
    filter: HealthAppointmentFilter.pending,
  );
});

final myDataHospitalAppointmentsProvider = FutureProvider.autoDispose.family<List<HospitalAppointment>, HealthAppointmentFilter>((
  final ref,
  final filter,
) async {
  final citizenId = ref.watch(citizenEndpointIdsProvider).requireIdAgente();
  return ref.watch(myDataHealthRepositoryProvider).loadHospitalAppointments(
    citizenId: citizenId,
    filter: filter,
  );
});
