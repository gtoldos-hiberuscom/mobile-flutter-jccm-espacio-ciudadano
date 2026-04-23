import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';

/// Load outcome for the agenda payload.
enum AgendaLoadState { loading, loaded, error }

/// Aggregated agenda payload returned by the repository.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
final class AgendaSnapshot {
  const AgendaSnapshot({
    required this.events,
    required this.lastUpdatedAt,
    required this.loadState,
  });

  /// Empty placeholder snapshot used by the notifier on first build.
  factory AgendaSnapshot.empty() => AgendaSnapshot(
        events: const <AgendaEvent>[],
        lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(0),
        loadState: AgendaLoadState.loading,
      );

  final List<AgendaEvent> events;
  final DateTime lastUpdatedAt;
  final AgendaLoadState loadState;
}
