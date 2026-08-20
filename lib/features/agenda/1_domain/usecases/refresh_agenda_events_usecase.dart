import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/repositories/agenda_repository.dart';

sealed class RefreshAgendaEventsResult {
  const RefreshAgendaEventsResult();
}

final class RefreshAgendaEventsSuccess extends RefreshAgendaEventsResult {
  const RefreshAgendaEventsSuccess();
}

final class RefreshAgendaEventsFailed extends RefreshAgendaEventsResult {
  const RefreshAgendaEventsFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

/// Pide al backend que consulte los sistemas origen y actualice los eventos de
/// agenda del ciudadano. El resultado se ve recargando los eventos después.
final class RefreshAgendaEventsUsecase {
  const RefreshAgendaEventsUsecase(this._repository);

  final AgendaRepository _repository;

  Future<RefreshAgendaEventsResult> execute({required final String agentId}) async {
    try {
      await _repository.refreshEvents(agentId: agentId);
      return const RefreshAgendaEventsSuccess();
    } on Object catch (error) {
      return RefreshAgendaEventsFailed(
        message: error.toString(),
        cause: error,
      );
    }
  }
}
