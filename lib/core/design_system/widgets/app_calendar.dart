import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// A month calendar widget following the JCCM design system (Figma node
/// 313:2762).
///
/// Displays a header with navigation arrows + month/year selector, weekday
/// labels, and a 7-column day grid with the following states:
/// - **Normal** — black text on white
/// - **Today** — bold primary-light text (#074183)
/// - **Selected** — light-blue bg (#BAE3EE) + 2 dp primary border
/// - **Outside month** — grey bg (#E0E5EB) + muted text (#A0B2C5)
class AppCalendar extends StatefulWidget {
  const AppCalendar({
    super.key,
    this.initialDate,
    this.selectedDates = const {},
    this.onDateSelected,
    this.onMonthChanged,
    this.firstDayOfWeek = DateTime.monday,
  });

  /// The initial month to display. Defaults to today.
  final DateTime? initialDate;

  /// Dates that should appear as selected (light-blue + border).
  final Set<DateTime> selectedDates;

  /// Callback when a day is tapped.
  final ValueChanged<DateTime>? onDateSelected;

  /// Callback when the displayed month changes.
  final ValueChanged<DateTime>? onMonthChanged;

  /// First day of the week (1 = Monday, 7 = Sunday).
  final int firstDayOfWeek;

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _currentMonth;
  late DateTime _today;

  static const List<String> _weekdayLabels = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  @override
  void initState() {
    super.initState();
    _today = DateUtils.dateOnly(DateTime.now());
    final initial = widget.initialDate ?? _today;
    _currentMonth = DateTime(initial.year, initial.month);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  bool _isSelected(final DateTime date) {
    return widget.selectedDates.any(
      (final d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  bool _isToday(final DateTime date) {
    return date.year == _today.year && date.month == _today.month && date.day == _today.day;
  }

  String _monthYearLabel() {
    const months = [
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
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  List<DateTime> _daysInGrid() {
    final firstOfMonth = DateTime(_currentMonth.year, _currentMonth.month);
    // Weekday offset (Monday = 0 ... Sunday = 6)
    final startWeekday = (firstOfMonth.weekday - widget.firstDayOfWeek + 7) % 7;
    final startDate = firstOfMonth.subtract(Duration(days: startWeekday));

    final days = <DateTime>[];
    // Always show 5 weeks (35 days) for consistent height
    for (var i = 0; i < 35; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        _buildWeekdayRow(),
        _buildDayGrid(),
      ],
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: AppColors.secondary,
      padding: const EdgeInsets.all(AppDimensions.space8),
      child: Row(
        children: [
          _navButton(Icons.chevron_left, _previousMonth),
          Expanded(child: _monthSelector()),
          _navButton(Icons.chevron_right, _nextMonth),
        ],
      ),
    );
  }

  Widget _navButton(final IconData icon, final VoidCallback onTap) {
    final label = icon == Icons.chevron_left ? 'Mes anterior' : 'Mes siguiente';
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: ExcludeSemantics(
          child: SizedBox(
            width: AppDimensions.space48,
            height: AppDimensions.space48,
            child: Icon(icon, color: AppColors.textWhite, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _monthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(12, 13, 13, 0.16),
        border: Border.all(color: AppColors.borderBlueMutedBase),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        boxShadow: AppShadows.low,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 24,
            color: AppColors.textWhite,
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Text(
              _monthYearLabel(),
              style: AppTypography.h2.copyWith(color: AppColors.textWhite),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: AppColors.textWhite,
          ),
        ],
      ),
    );
  }

  // ── Weekday labels ────────────────────────────────────────────────────────
  Widget _buildWeekdayRow() {
    return Container(
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
        children: _weekdayLabels
            .map(
              (final label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: AppTypography.smallRegular.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Day grid ──────────────────────────────────────────────────────────────
  Widget _buildDayGrid() {
    final days = _daysInGrid();
    final rows = <Widget>[];

    for (var row = 0; row < 5; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final date = days[row * 7 + col];
        cells.add(Expanded(child: _dayCell(date)));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
          child: Row(children: cells),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: const Color.fromRGBO(12, 13, 13, 0.16)),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space24),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.space16),
            rows[i],
          ],
        ],
      ),
    );
  }

  Widget _dayCell(final DateTime date) {
    final isCurrentMonth = date.month == _currentMonth.month;
    final selected = _isSelected(date);
    final today = _isToday(date) && !selected;

    Color backgroundColor;
    Color textColor;
    FontWeight fontWeight;
    BoxBorder? border;

    if (!isCurrentMonth) {
      backgroundColor = AppColors.backgroundBlueMutedLight;
      textColor = AppColors.borderBlueMutedLight; // #A0B2C5
      fontWeight = FontWeight.w400;
    } else if (selected) {
      backgroundColor = AppColors.secondaryLight200; // #BAE3EE
      textColor = AppColors.textBlack;
      fontWeight = FontWeight.w400;
      border = Border.all(color: AppColors.primary, width: 2);
    } else if (today) {
      backgroundColor = Colors.transparent;
      textColor = AppColors.primaryLight; // #074183
      fontWeight = FontWeight.w700;
    } else {
      backgroundColor = Colors.transparent;
      textColor = AppColors.textBlack;
      fontWeight = FontWeight.w400;
    }

    return Semantics(
      label: '${date.day}${selected ? ", seleccionado" : ""}${today ? ", hoy" : ""}',
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: () => widget.onDateSelected?.call(date),
        child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          border: border,
          boxShadow: selected ? AppShadows.low : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${date.day}',
          style: AppTypography.smallRegular.copyWith(
            color: textColor,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
    );
  }
}
