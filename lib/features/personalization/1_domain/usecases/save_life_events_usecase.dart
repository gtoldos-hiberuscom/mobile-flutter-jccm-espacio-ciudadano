import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class SaveLifeEventsResult {}

final class SaveLifeEventsSuccess extends SaveLifeEventsResult {}

final class SaveLifeEventsFailed extends SaveLifeEventsResult {
  SaveLifeEventsFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Persists the complete life-event selection for the given citizen.
final class SaveLifeEventsUsecase {
  const SaveLifeEventsUsecase(this._repository);

  final LifeEventsRepository _repository;

  Future<SaveLifeEventsResult> execute({
    required final String idAgente,
    required final List<LifeEvent> events,
  }) async {
    try {
      await _repository.saveLifeEvents(idAgente: idAgente, events: events);
      return SaveLifeEventsSuccess();
    } on Object catch (e) {
      return SaveLifeEventsFailed(message: e.toString(), cause: e);
    }
  }
}
