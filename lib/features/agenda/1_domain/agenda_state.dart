import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_period_filter.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';

/// Immutable view-model carried inside the agenda notifier's `AsyncValue`.
///
/// Pure Dart — no Flutter or Riverpod (canon §11/§14). Computes the
/// derived [visibleEvents] from [snapshot] + [period] + optional
/// [selectedDay].
final class AgendaState {
  const AgendaState({
    required this.snapshot,
    required this.period,
    required this.calendarMonth,
    this.selectedDay,
  });

  /// Builds the initial state anchored to the start of the current month.
  factory AgendaState.initial(final DateTime now) => AgendaState(
    snapshot: AgendaSnapshot.empty(),
    period: AgendaPeriodFilter.all,
    calendarMonth: DateTime(now.year, now.month),
  );

  final AgendaSnapshot snapshot;
  final AgendaPeriodFilter period;

  /// First day of the month currently displayed by the calendar view.
  final DateTime calendarMonth;

  /// When non-null, the list view is further narrowed to events whose
  /// day matches [selectedDay] (used by the calendar tap-to-filter UX).
  final DateTime? selectedDay;

  AgendaState copyWith({
    final AgendaSnapshot? snapshot,
    final AgendaPeriodFilter? period,
    final DateTime? calendarMonth,
    final DateTime? selectedDay,
    final bool clearSelectedDay = false,
  }) => AgendaState(
    snapshot: snapshot ?? this.snapshot,
    period: period ?? this.period,
    calendarMonth: calendarMonth ?? this.calendarMonth,
    selectedDay: clearSelectedDay ? null : (selectedDay ?? this.selectedDay),
  );

  /// Events filtered by [period], sorted ascending by [AgendaEvent.startsAt],
  /// and optionally narrowed to [selectedDay].
  List<AgendaEvent> visibleEvents(final DateTime now) {
    final filtered = <AgendaEvent>[];
    for (final event in snapshot.events) {
      if (!period.matches(now, event.startsAt)) {
        continue;
      }
      if (selectedDay != null) {
        final day = selectedDay!;
        if (event.startsAt.year != day.year || event.startsAt.month != day.month || event.startsAt.day != day.day) {
          continue;
        }
      }
      filtered.add(event);
    }
    filtered.sort((final a, final b) => a.startsAt.compareTo(b.startsAt));
    return filtered;
  }

  /// Returns the unique set of day-buckets that contain at least one event
  /// inside [calendarMonth] (used by the calendar grid to render dots).
  Set<DateTime> daysWithEvents() {
    final result = <DateTime>{};
    for (final event in snapshot.events) {
      if (event.startsAt.year == calendarMonth.year && event.startsAt.month == calendarMonth.month) {
        result.add(event.day);
      }
    }
    return result;
  }
}
