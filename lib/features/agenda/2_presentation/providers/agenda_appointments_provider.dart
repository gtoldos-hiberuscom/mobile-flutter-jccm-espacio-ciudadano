import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/usecases/load_agenda_appointments_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment_access.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';

final class AgendaAppointmentsState {
  const AgendaAppointmentsState({
    required this.appointments,
    required this.updatedAt,
    required this.hasJccmAuthorization,
    this.failedSources = const {},
    this.healthCipMissing = false,
    this.hospitalAppointmentsLocked = false,
  });

  final List<AgendaAppointment> appointments;
  final DateTime updatedAt;
  final bool hasJccmAuthorization;

  /// Fuentes caídas en esta carga; vacío = la agenda llegó completa.
  final Set<AgendaAppointmentSource> failedSources;
  final bool healthCipMissing;

  /// El nivel de la sesión no alcanza el de las citas hospitalarias: la
  /// pantalla avisa de que están ocultas y ofrece verificar la identidad. Qué
  /// citas llegan lo decide el backend; esto solo explica la ausencia.
  final bool hospitalAppointmentsLocked;

  bool get isPartial => failedSources.isNotEmpty;

  /// Citas futuras, o `null` cuando la carga fue parcial: con una fuente caída
  /// el recuento no es fiable, y la portada prefiere enseñar la tarjeta sin
  /// número a esconderla porque "hay 0 citas".
  int? upcomingAppointmentsCount(final DateTime now) => isPartial ? null : appointments.where((final appointment) => !appointment.dateTime.isBefore(now)).length;
}

final agendaAppointmentsProvider = FutureProvider.autoDispose<AgendaAppointmentsState>((final ref) async {
  final hasJccmAuthorization = await ref.watch(jccmDataAuthorizationProvider.future);
  if (!hasJccmAuthorization) {
    return AgendaAppointmentsState(
      appointments: const [],
      updatedAt: DateTime.now(),
      hasJccmAuthorization: false,
    );
  }

  // Los identificadores salen de `citizenEndpointIdsProvider`, no directamente
  // del token: contra el gateway toda la app debe mandar el mismo identificador
  // (`sub_alt`); leer `idAgente` del claim mandaba `PER…` y daba 403/404.
  final ids = ref.watch(citizenEndpointIdsProvider);
  final isRepresentative = ref.watch(jwtClaimsProvider.select((final claims) => claims?.isRepresentative ?? false));
  // Se observa el nivel para que, al elevarlo, la agenda se vuelva a pedir sola
  // con el token nuevo y lleguen las citas hospitalarias. A quien actúa como
  // representante no se le ofrece: la agenda no le muestra datos de salud.
  final hospitalAppointmentsLocked = !isRepresentative && !ref.watch(authenticationLevelProvider).meets(kHospitalAppointmentsMinimumLevel);
  final documentNumber = ids.numDocumento;
  if (documentNumber == null || documentNumber.isEmpty) {
    throw StateError('No se ha encontrado el documento del usuario.');
  }

  final result = await ref
      .read(loadAgendaAppointmentsUsecaseProvider)
      .execute(
        documentNumber: documentNumber,
        agentId: ids.idAgente,
        includeHealth: !isRepresentative,
      );

  return switch (result) {
    LoadAgendaAppointmentsSuccess(:final appointments, :final failedSources, :final healthCipMissing) => AgendaAppointmentsState(
      appointments: appointments,
      updatedAt: DateTime.now(),
      hasJccmAuthorization: true,
      failedSources: failedSources,
      healthCipMissing: healthCipMissing,
      hospitalAppointmentsLocked: hospitalAppointmentsLocked,
    ),
    LoadAgendaAppointmentsFailed(:final message) => throw Exception(message),
  };
});
