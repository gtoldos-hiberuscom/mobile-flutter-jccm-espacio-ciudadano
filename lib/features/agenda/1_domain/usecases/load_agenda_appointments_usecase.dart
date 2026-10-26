import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/repositories/agenda_repository.dart';

sealed class LoadAgendaAppointmentsResult {
  const LoadAgendaAppointmentsResult();
}

final class LoadAgendaAppointmentsSuccess extends LoadAgendaAppointmentsResult {
  const LoadAgendaAppointmentsSuccess({
    required this.appointments,
    this.failedSources = const {},
    this.healthCipMissing = false,
  });

  final List<AgendaAppointment> appointments;

  /// Fuentes que no respondieron. Si no está vacío la lista es parcial y la
  /// pantalla debe avisar de lo que falta sin bloquear lo que sí llegó; el
  /// fallo total sigue llegando como [LoadAgendaAppointmentsFailed].
  final Set<AgendaAppointmentSource> failedSources;
  final bool healthCipMissing;
}

final class LoadAgendaAppointmentsFailed extends LoadAgendaAppointmentsResult {
  const LoadAgendaAppointmentsFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

final class LoadAgendaAppointmentsUsecase {
  const LoadAgendaAppointmentsUsecase(this._repository);

  final AgendaRepository _repository;

  Future<LoadAgendaAppointmentsResult> execute({
    required final String documentNumber,
    final String? agentId,
    final bool includeHealth = true,
  }) async {
    try {
      final snapshot = await _repository.loadAppointments(
        documentNumber: documentNumber,
        agentId: agentId,
        includeHealth: includeHealth,
      );
      return LoadAgendaAppointmentsSuccess(
        appointments: snapshot.appointments,
        failedSources: snapshot.failedSources,
        healthCipMissing: snapshot.healthCipMissing,
      );
    } on Object catch (error) {
      return LoadAgendaAppointmentsFailed(
        message: error.toString(),
        cause: error,
      );
    }
  }
}
