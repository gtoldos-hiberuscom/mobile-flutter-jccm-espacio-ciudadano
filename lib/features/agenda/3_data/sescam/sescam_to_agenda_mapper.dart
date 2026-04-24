import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/sescam/sescam_payload_parser.dart';

/// Bridges the tolerant SESCAM parser (TASK-32) onto the agenda
/// snapshot's load-state discriminator (STORY-30).
///
/// Lives in `3_data/` because it depends on parser DTOs — never
/// imported from `0_entity/`, `1_domain/` or `2_presentation/`.
/// Pure Dart, no Flutter, no Riverpod (canon §13).
class SescamToAgendaMapper {
  const SescamToAgendaMapper();

  /// Maps a SESCAM citas parse result onto an [AgendaSnapshot].
  ///
  /// - `ok`   → [AgendaLoadState.loaded] (or [AgendaLoadState.partial] when
  ///   any non-decodable item was discarded along the way, signalled by the
  ///   caller via [partialReason]).
  /// - `err`  → maps each [SescamParseErrorKind] onto the matching agenda
  ///   discriminator. The raw `rawPreview` is intentionally NOT propagated
  ///   to the UI; only a stable reason code travels.
  AgendaSnapshot toSnapshot(
    final SescamParseResult<SescamCitasPayload> result,
    final List<AgendaEvent> events,
    final DateTime now, {
    final String? partialReason,
  }) {
    if (result.isOk) {
      if (partialReason != null) {
        return AgendaSnapshot(
          events: events,
          lastUpdatedAt: now,
          loadState: AgendaLoadState.partial,
          parseErrorReason: partialReason,
        );
      }
      return AgendaSnapshot(
        events: events,
        lastUpdatedAt: now,
        loadState: AgendaLoadState.loaded,
      );
    }

    final err = result.error!;
    final loadState = mapKind(err.kind);
    return AgendaSnapshot(
      events: events,
      lastUpdatedAt: now,
      loadState: loadState,
      parseErrorReason: err.reason,
    );
  }

  /// Pure mapping from parser-error kind to agenda load state.
  static AgendaLoadState mapKind(final SescamParseErrorKind kind) {
    switch (kind) {
      case SescamParseErrorKind.empty:
        // No payload → looks like an empty agenda to the user.
        return AgendaLoadState.loaded;
      case SescamParseErrorKind.partial:
        return AgendaLoadState.partial;
      case SescamParseErrorKind.unknownShape:
        return AgendaLoadState.parseError;
      case SescamParseErrorKind.serverEnvelopeKo:
        return AgendaLoadState.error;
    }
  }
}
