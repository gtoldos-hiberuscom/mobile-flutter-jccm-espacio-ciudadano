import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_period_filter.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_state.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'agenda_notifier.g.dart';

/// Owns the agenda screen state (snapshot + temporal filter + calendar
/// month + selected day).
///
/// On `build()` it asks the repository for a snapshot and rebuilds the
/// state machine around it. UI mutators ([setPeriod], [setMonth],
/// [selectDay], [clearSelectedDay]) only mutate the in-memory view-model
/// — they never re-fetch (use [refresh] for that).
@riverpod
class AgendaNotifier extends _$AgendaNotifier {
  @override
  Future<AgendaState> build() async {
    final repo = ref.watch(agendaRepositoryProvider);
    final snapshot = await repo.loadAgenda();
    final now = DateTime.now();
    return AgendaState(
      snapshot: snapshot,
      period: AgendaPeriodFilter.all,
      calendarMonth: DateTime(now.year, now.month),
    );
  }

  /// Replaces the current period filter and clears any day selection.
  void setPeriod(final AgendaPeriodFilter period) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<AgendaState>.data(
      current.copyWith(period: period, clearSelectedDay: true),
    );
  }

  /// Anchors the calendar grid to the first day of [month].
  void setMonth(final DateTime month) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<AgendaState>.data(
      current.copyWith(
        calendarMonth: DateTime(month.year, month.month),
        clearSelectedDay: true,
      ),
    );
  }

  /// Narrows the list view to events on [day]. Pass `null` to clear.
  void selectDay(final DateTime day) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<AgendaState>.data(
      current.copyWith(
        selectedDay: DateTime(day.year, day.month, day.day),
      ),
    );
  }

  /// Clears any previously selected day on the calendar.
  void clearSelectedDay() {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<AgendaState>.data(
      current.copyWith(clearSelectedDay: true),
    );
  }

  /// Forces a fresh fetch of the agenda snapshot, preserving the current
  /// filter / month / day selection.
  Future<void> refresh() async {
    final preserved = state.value;
    state = const AsyncValue<AgendaState>.loading();
    state = await AsyncValue.guard<AgendaState>(() async {
      final snapshot = await ref.read(agendaRepositoryProvider).loadAgenda();
      if (preserved != null) {
        return preserved.copyWith(snapshot: snapshot);
      }
      final now = DateTime.now();
      return AgendaState(
        snapshot: snapshot,
        period: AgendaPeriodFilter.all,
        calendarMonth: DateTime(now.year, now.month),
      );
    });
  }

  /// Test/utility helper: replaces the in-memory snapshot without
  /// touching the repository (used by deterministic notifier tests).
  // ignore: use_setters_to_change_properties
  void debugReplaceSnapshot(final AgendaSnapshot snapshot) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<AgendaState>.data(
      current.copyWith(snapshot: snapshot),
    );
  }
}
