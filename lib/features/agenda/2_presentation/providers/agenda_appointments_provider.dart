import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/usecases/load_agenda_appointments_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';

final class AgendaAppointmentsState {
  const AgendaAppointmentsState({
    required this.appointments,
    required this.updatedAt,
    required this.hasJccmAuthorization,
  });

  final List<AgendaAppointment> appointments;
  final DateTime updatedAt;
  final bool hasJccmAuthorization;
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
  final documentNumber = ids.numDocumento;
  if (documentNumber == null || documentNumber.isEmpty) {
    throw StateError('No se ha encontrado el documento del usuario.');
  }

  final result = await ref
      .read(loadAgendaAppointmentsUsecaseProvider)
      .execute(
        documentNumber: documentNumber,
        agentId: ids.idAgente,
      );

  return switch (result) {
    LoadAgendaAppointmentsSuccess(:final appointments) => AgendaAppointmentsState(
      appointments: appointments,
      updatedAt: DateTime.now(),
      hasJccmAuthorization: true,
    ),
    LoadAgendaAppointmentsFailed(:final message) => throw Exception(message),
  };
});
