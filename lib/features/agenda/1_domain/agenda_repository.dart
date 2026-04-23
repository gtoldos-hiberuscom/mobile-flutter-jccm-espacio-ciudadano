import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';

/// Domain contract for retrieving the agenda payload.
///
/// Implementations live in `3_data/`. No Flutter / Dio / Riverpod imports
/// allowed (canon §13). Errors during a fetch must be encoded inside the
/// returned [AgendaSnapshot.loadState] so the notifier can render partial
/// states without entering an unrecoverable `AsyncValue.error`.
abstract interface class AgendaRepository {
  /// Resolves a fresh agenda snapshot for the currently authenticated user.
  Future<AgendaSnapshot> loadAgenda();

  /// Optional periodic stream of snapshots. Default implementations may
  /// return a single-shot stream backed by [loadAgenda].
  Stream<AgendaSnapshot> watchAgenda();
}
