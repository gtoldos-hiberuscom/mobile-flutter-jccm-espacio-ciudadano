import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';

abstract interface class AgendaRepository {
  Future<List<AgendaAppointment>> loadAppointments({
    required final String documentNumber,
    final String? agentId,
  });

  /// Lanza en el backend la consulta a los sistemas origen para actualizar los
  /// eventos del ciudadano. Tras completarse hay que recargar los eventos para
  /// ver el resultado.
  Future<void> refreshEvents({required final String agentId});
}
