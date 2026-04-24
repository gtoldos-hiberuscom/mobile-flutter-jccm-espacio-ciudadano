import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Minimal monthly calendar grid built from scratch (no `table_calendar`).
///
/// Renders the weekday header and a 6-row grid of day cells anchored on
/// [month] (the first day of the month). Days outside the month are
/// rendered as faded out-of-range cells. Days listed in [daysWithEvents]
/// receive a small dot indicator under the day number. Tapping a day
/// invokes [onDaySelected].
class AgendaMonthCalendar extends StatelessWidget {
  const AgendaMonthCalendar({
    required this.month,
    required this.daysWithEvents,
    required this.onDaySelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.selectedDay,
    super.key,
  });

  final DateTime month;
  final Set<DateTime> daysWithEvents;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  /// Spanish month names — kept inline to satisfy the "no `intl`" rule.
  static const List<String> _spanishMonths = <String>[
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final materialL10n = MaterialLocalizations.of(context);

    // Monday-first week (Spain). MaterialLocalizations exposes
    // `firstDayOfWeekIndex` (0 = Sunday, 1 = Monday) — we just clamp to
    // Monday to keep the grid culture-stable for Spanish users.
    const firstWeekday = DateTime.monday;
    final firstOfMonth = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // 0-based offset of the 1st-of-month relative to the calendar's
    // first weekday (Monday).
    final leadingOffset = (firstOfMonth.weekday - firstWeekday + 7) % 7;
    const totalCells = 42; // 6 weeks
    final cells = <_DayCell>[];
    for (var i = 0; i < totalCells; i++) {
      final dayNumber = i - leadingOffset + 1;
      final inMonth = dayNumber >= 1 && dayNumber <= daysInMonth;
      final cellDate = inMonth ? DateTime(month.year, month.month, dayNumber) : null;
      cells.add(
        _DayCell(
          date: cellDate,
          inMonth: inMonth,
          hasEvents: cellDate != null && daysWithEvents.contains(cellDate),
          isSelected: cellDate != null && selectedDay != null && cellDate.year == selectedDay!.year && cellDate.month == selectedDay!.month && cellDate.day == selectedDay!.day,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.agendaPreviousMonth,
              onPressed: onPreviousMonth,
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                '${_spanishMonths[month.month - 1]} ${month.year}',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l10n.agendaNextMonth,
              onPressed: onNextMonth,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space4),
        Row(
          children: List<Widget>.generate(7, (final i) {
            final weekdayIndex = (firstWeekday - 1 + i) % 7;
            final label = materialL10n.narrowWeekdays[(weekdayIndex + 1) % 7];
            return Expanded(
              child: Center(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppDimensions.space4),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          children: [
            for (final cell in cells)
              _CalendarCell(
                cell: cell,
                onTap: cell.date != null ? () => onDaySelected(cell.date!) : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _DayCell {
  const _DayCell({
    required this.date,
    required this.inMonth,
    required this.hasEvents,
    required this.isSelected,
  });

  final DateTime? date;
  final bool inMonth;
  final bool hasEvents;
  final bool isSelected;
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({required this.cell, required this.onTap});

  final _DayCell cell;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final isToday = cell.date != null && cell.date!.year == today.year && cell.date!.month == today.month && cell.date!.day == today.day;

    final foreground = !cell.inMonth ? theme.colorScheme.outlineVariant : (cell.isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface);
    final background = cell.isSelected ? theme.colorScheme.primary : (isToday ? theme.colorScheme.primaryContainer : null);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: background ?? Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cell.date != null ? '${cell.date!.day}' : '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: foreground,
                    fontWeight: isToday ? FontWeight.bold : null,
                  ),
                ),
                if (cell.hasEvents)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: cell.isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
