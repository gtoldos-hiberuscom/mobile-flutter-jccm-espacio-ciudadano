import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';

abstract interface class AgendaRepository {
  Future<List<AgendaAppointment>> loadUpcomingAppointments({
    required final String documentNumber,
  });
}
