import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class LoadLifeEventsResult {}

final class LoadLifeEventsSuccess extends LoadLifeEventsResult {
  LoadLifeEventsSuccess({required this.events});

  final List<LifeEvent> events;
}

final class LoadLifeEventsFailed extends LoadLifeEventsResult {
  LoadLifeEventsFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Loads the life-event catalogue for the given citizen.
final class LoadLifeEventsUsecase {
  const LoadLifeEventsUsecase(this._repository);

  final LifeEventsRepository _repository;

  Future<LoadLifeEventsResult> execute({required final String idAgente}) async {
    try {
      final events = await _repository.loadLifeEvents(idAgente: idAgente);
      return LoadLifeEventsSuccess(events: events);
    } on Object catch (e) {
      return LoadLifeEventsFailed(message: e.toString(), cause: e);
    }
  }
}
