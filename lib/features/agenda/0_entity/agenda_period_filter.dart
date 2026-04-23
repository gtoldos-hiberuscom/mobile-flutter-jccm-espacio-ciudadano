/// Temporal filter applied to the agenda list view.
///
/// Pure Dart — no Flutter or Riverpod. UI labels are resolved through ARB
/// by mapping each enum value to its `agenda_filter_*` key (canon §21).
enum AgendaPeriodFilter {
  /// All events (past + future).
  all,

  /// Events whose [DateTime] falls in the next 7 days, inclusive of `now`.
  next7Days,

  /// Events whose [DateTime] falls in the next 30 days, inclusive of `now`.
  next30Days,

  /// Events whose [DateTime] falls in the next 365 days, inclusive of `now`.
  next365Days,

  /// Events strictly in the past (before the start of the current day).
  past;

  /// Returns `true` when [eventDate] passes the filter relative to [now].
  ///
  /// Boundaries are computed against the start of [now]'s local day so
  /// "next 7 days" covers `[startOfToday, startOfToday + 7d)` and so on.
  /// `past` returns `true` for any event whose start lies strictly before
  /// the start of today.
  bool matches(final DateTime now, final DateTime eventDate) {
    final today = DateTime(now.year, now.month, now.day);
    switch (this) {
      case AgendaPeriodFilter.all:
        return true;
      case AgendaPeriodFilter.past:
        return eventDate.isBefore(today);
      case AgendaPeriodFilter.next7Days:
        return _withinFutureWindow(eventDate, today, 7);
      case AgendaPeriodFilter.next30Days:
        return _withinFutureWindow(eventDate, today, 30);
      case AgendaPeriodFilter.next365Days:
        return _withinFutureWindow(eventDate, today, 365);
    }
  }

  static bool _withinFutureWindow(
    final DateTime eventDate,
    final DateTime today,
    final int days,
  ) {
    if (eventDate.isBefore(today)) {
      return false;
    }
    final upperBound = today.add(Duration(days: days));
    return eventDate.isBefore(upperBound);
  }
}
