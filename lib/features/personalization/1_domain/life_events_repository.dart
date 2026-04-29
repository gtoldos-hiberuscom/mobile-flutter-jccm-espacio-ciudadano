import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';

/// Result of loading the life-events catalog from the backend.
///
/// Holds the catalog of [items] together with the ids the citizen had
/// previously persisted as preferences, so the notifier can seed both the
/// current selection and the baseline used for dirty detection.
final class LifeEventsLoadResult {
  const LifeEventsLoadResult({
    required this.items,
    required this.selectedIds,
  });

  final List<LifeEvent> items;
  final Set<String> selectedIds;
}

/// Domain contract for the life-events selection screen (STORY-54).
///
// TODO(STORY-54): Sprint-4 implementation returns mocked data. Real
/// wiring against `/hechos-vitales/hechos/{idAgente}` (GET catalog),
/// `PATCH /hechos-vitales/hechos` (persist selection) and
/// `/hechos-vitales/preferencias/{idAgente}` (DELETE reset) is owned by a
/// follow-up story (depends on TASK-21 idAgente closure).
abstract interface class LifeEventsRepository {
  Future<LifeEventsLoadResult> loadHechos(final String idAgente);

  Future<void> saveHechos(
    final String idAgente,
    final Set<String> selectedIds,
  );

  Future<void> resetPreferencias(final String idAgente);
}
