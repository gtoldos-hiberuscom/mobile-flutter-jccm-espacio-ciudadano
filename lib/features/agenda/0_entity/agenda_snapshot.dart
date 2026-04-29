import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';

/// Load outcome for the agenda payload.
///
/// - [loading] / [loaded] / [error] are the original STORY-29 states.
/// - [partial] (STORY-30) means some events were decoded but at least one
///   item was discarded by the parser; the UI shows a non-blocking warning
///   banner and still renders the items that did load.
/// - [parseError] (STORY-30) means the payload could not be decoded into
///   any usable event; the UI shows a recoverable error surface with a
///   "intentar de nuevo" CTA.
enum AgendaLoadState { loading, loaded, partial, parseError, error }

/// Aggregated agenda payload returned by the repository.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
final class AgendaSnapshot {
  const AgendaSnapshot({
    required this.events,
    required this.lastUpdatedAt,
    required this.loadState,
    this.parseErrorReason,
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

  /// Optional, locale-independent reason associated with
  /// [AgendaLoadState.parseError] or [AgendaLoadState.partial] outcomes.
  /// Never rendered raw — the UI maps it to a localised message.
  final String? parseErrorReason;
}
