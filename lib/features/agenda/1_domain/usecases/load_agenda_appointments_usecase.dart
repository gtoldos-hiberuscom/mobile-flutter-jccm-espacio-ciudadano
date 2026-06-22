import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/repositories/agenda_repository.dart';

sealed class LoadAgendaAppointmentsResult {
  const LoadAgendaAppointmentsResult();
}

final class LoadAgendaAppointmentsSuccess extends LoadAgendaAppointmentsResult {
  const LoadAgendaAppointmentsSuccess({required this.appointments});

  final List<AgendaAppointment> appointments;
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
  }) async {
    try {
      final appointments = await _repository.loadAppointments(
        documentNumber: documentNumber,
        agentId: agentId,
      );
      return LoadAgendaAppointmentsSuccess(appointments: appointments);
    } on Object catch (error) {
      return LoadAgendaAppointmentsFailed(
        message: error.toString(),
        cause: error,
      );
    }
  }
}
