import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_events_selection.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'life_events_notifier.g.dart';

/// Owns the life-events selection state for a given `idAgente` (STORY-54).
///
/// Mock-backed in Sprint 4. Real Dio wiring is deferred to a follow-up
/// story (depends on TASK-21 idAgente closure).
@riverpod
class LifeEventsNotifier extends _$LifeEventsNotifier {
  @override
  Future<LifeEventsSelection> build(final String idAgente) async {
    return _load(idAgente);
  }

  Future<LifeEventsSelection> _load(final String idAgente) async {
    final repo = ref.read(lifeEventsRepositoryProvider);
    final result = await repo.loadHechos(idAgente);
    final selected = Set<String>.from(result.selectedIds);
    final baseline = Set<String>.from(result.selectedIds);
    return LifeEventsSelection(
      items: result.items,
      selectedIds: selected,
      baselineIds: baseline,
      state: result.items.isEmpty ? LifeEventsLoadState.empty : LifeEventsLoadState.loaded,
    );
  }

  /// Toggles [eventId] in the current selection. No-op if no data is loaded.
  void toggle(final String eventId) {
    final current = state.value;
    if (current == null) {
      return;
    }
    final next = Set<String>.from(current.selectedIds);
    if (!next.remove(eventId)) {
      next.add(eventId);
    }
    state = AsyncValue<LifeEventsSelection>.data(
      current.copyWith(
        selectedIds: next,
        state: LifeEventsLoadState.loaded,
        clearError: true,
      ),
    );
  }

  /// Persists the current selection. Emits `saving` then `saved`, and finally
  /// returns to `loaded` after the baseline is updated.
  Future<void> save() async {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<LifeEventsSelection>.data(
      current.copyWith(
        state: LifeEventsLoadState.saving,
        clearError: true,
      ),
    );
    try {
      await ref.read(lifeEventsRepositoryProvider).saveHechos(idAgente, current.selectedIds);
      state = AsyncValue<LifeEventsSelection>.data(
        current.copyWith(
          baselineIds: Set<String>.from(current.selectedIds),
          state: LifeEventsLoadState.saved,
          clearError: true,
        ),
      );
    } catch (e) {
      state = AsyncValue<LifeEventsSelection>.data(
        current.copyWith(
          state: LifeEventsLoadState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Acknowledges the transient `saved` flash and returns to `loaded`.
  void acknowledgeSaved() {
    final current = state.value;
    if (current == null || current.state != LifeEventsLoadState.saved) {
      return;
    }
    state = AsyncValue<LifeEventsSelection>.data(
      current.copyWith(state: LifeEventsLoadState.loaded),
    );
  }

  /// Clears all preferences via `DELETE /hechos-vitales/preferencias/{idAgente}`
  /// (mocked) and resets both the current selection and the baseline.
  Future<void> resetPreferencias() async {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<LifeEventsSelection>.data(
      current.copyWith(
        state: LifeEventsLoadState.saving,
        clearError: true,
      ),
    );
    try {
      await ref.read(lifeEventsRepositoryProvider).resetPreferencias(idAgente);
      state = AsyncValue<LifeEventsSelection>.data(
        current.copyWith(
          selectedIds: <String>{},
          baselineIds: <String>{},
          state: LifeEventsLoadState.saved,
          clearError: true,
        ),
      );
    } catch (e) {
      state = AsyncValue<LifeEventsSelection>.data(
        current.copyWith(
          state: LifeEventsLoadState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Reloads the catalog from the repository, discarding any unsaved edits.
  Future<void> refresh() async {
    state = const AsyncValue<LifeEventsSelection>.loading();
    state = await AsyncValue.guard<LifeEventsSelection>(
      () => _load(idAgente),
    );
  }

  /// Test-only convenience: returns the catalog grouped by category in the
  /// canonical category order, preserving the catalog order within a group.
  static Map<LifeEventCategory, List<LifeEvent>> groupByCategory(
    final List<LifeEvent> items,
  ) {
    final result = <LifeEventCategory, List<LifeEvent>>{
      for (final c in LifeEventCategory.values) c: <LifeEvent>[],
    };
    for (final item in items) {
      result[item.category]!.add(item);
    }
    result.removeWhere((_, final v) => v.isEmpty);
    return result;
  }
}
