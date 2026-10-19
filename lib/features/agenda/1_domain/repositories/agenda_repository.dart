import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';

abstract interface class AgendaRepository {
  /// Devuelve lo que se haya podido cargar de cada fuente.
  ///
  /// Si una fuente falla pero otra responde, la carga es parcial y las caídas
  /// se listan en `failedSources`. Solo cuando fallan **todas** las fuentes
  /// intentadas se lanza el error original.
  Future<AgendaAppointmentsSnapshot> loadAppointments({
    required final String documentNumber,
    final String? agentId,
    final bool includeHealth = true,
  });

  /// Lanza en el backend la consulta a los sistemas origen para actualizar los
  /// eventos del ciudadano. Tras completarse hay que recargar los eventos para
  /// ver el resultado.
  Future<void> refreshEvents({required final String agentId});
}
