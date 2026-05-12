import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class ResetLifeEventsResult {}

final class ResetLifeEventsSuccess extends ResetLifeEventsResult {}

final class ResetLifeEventsFailed extends ResetLifeEventsResult {
  ResetLifeEventsFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Deletes all persisted life-event preferences for the given citizen.
///
/// After a successful reset the caller should reload the catalogue to reflect
/// the cleared state.
final class ResetLifeEventsUsecase {
  const ResetLifeEventsUsecase(this._repository);

  final LifeEventsRepository _repository;

  Future<ResetLifeEventsResult> execute({
    required final String idAgente,
  }) async {
    try {
      await _repository.resetPreferences(idAgente: idAgente);
      return ResetLifeEventsSuccess();
    } on Object catch (e) {
      return ResetLifeEventsFailed(message: e.toString(), cause: e);
    }
  }
}
