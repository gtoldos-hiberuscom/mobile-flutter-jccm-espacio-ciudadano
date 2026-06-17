import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// A month calendar widget following the JCCM design system (Figma node
/// 43716:12920).
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
    this.eventDates = const {},
    this.onDateSelected,
    this.onMonthChanged,
    this.firstDayOfWeek = DateTime.monday,
  });

  /// The initial month to display. Defaults to today.
  final DateTime? initialDate;

  /// Dates that should appear as selected (light-blue + border).
  final Set<DateTime> selectedDates;

  /// Dates that should display the event indicator dot.
  final Set<DateTime> eventDates;

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

  static const List<String> _monthLabels = [
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

  void _setCurrentMonth(final DateTime month) {
    setState(() {
      _currentMonth = DateTime(month.year, month.month);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  Future<void> _showMonthYearPicker() async {
    final selectedMonth = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      builder: (final context) => _CalendarMonthYearPicker(
        initialMonth: _currentMonth,
        monthLabels: _monthLabels,
      ),
    );
    if (selectedMonth == null || !mounted) {
      return;
    }
    _setCurrentMonth(selectedMonth);
  }

  bool _isSelected(final DateTime date) {
    return widget.selectedDates.any(
      (final d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  bool _isToday(final DateTime date) {
    return date.year == _today.year && date.month == _today.month && date.day == _today.day;
  }

  bool _hasEvent(final DateTime date) {
    return widget.eventDates.any(
      (final d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  bool _hasEventsInCurrentMonth() {
    return widget.eventDates.any(
      (final d) => d.year == _currentMonth.year && d.month == _currentMonth.month,
    );
  }

  String _monthYearLabel() {
    return '${_monthLabels[_currentMonth.month - 1]} ${_currentMonth.year}';
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredBox(
            color: AppColors.secondary,
            child: Column(
              children: [
                _buildHeader(),
                _buildWeekdayRow(),
              ],
            ),
          ),
          _buildDayGrid(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.space8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _navButton(Icons.chevron_left, _previousMonth),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: AppDimensions.space4,
                bottom: AppDimensions.space4,
              ),
              child: _monthSelector(),
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _navButton(Icons.chevron_right, _nextMonth),
              if (_hasEventsInCurrentMonth())
                Positioned(
                  top: AppDimensions.space4,
                  right: AppDimensions.space4,
                  child: _eventDot(),
                ),
            ],
          ),
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
    return Semantics(
      label: 'Seleccionar mes y año',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showMonthYearPicker,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          child: Container(
            constraints: const BoxConstraints(minHeight: AppDimensions.space48),
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
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconMedium,
                  color: AppColors.textWhite,
                ),
                const SizedBox(width: AppDimensions.space8),
                Expanded(
                  child: Text(
                    _monthYearLabel(),
                    style: AppTypography.h2.copyWith(color: AppColors.textWhite),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 24,
                  color: AppColors.textWhite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Weekday labels ────────────────────────────────────────────────────────
  Widget _buildWeekdayRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space4),
      child: Row(
        children: _weekdayLabels
            .map(
              (final label) => Expanded(
                child: SizedBox(
                  height: AppDimensions.space32,
                  child: Center(
                    child: Text(
                      label,
                      style: AppTypography.smallRegular.copyWith(
                        color: AppColors.textWhite,
                      ),
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
        if (col > 0) {
          cells.add(const SizedBox(width: AppDimensions.space8));
        }
        cells.add(Expanded(child: Center(child: _dayCell(date))));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
          child: Row(children: cells),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border(
          top: BorderSide(color: Color.fromRGBO(12, 13, 13, 0.16)),
          left: BorderSide(color: Color.fromRGBO(12, 13, 13, 0.16)),
          right: BorderSide(color: Color.fromRGBO(12, 13, 13, 0.16)),
          bottom: BorderSide(color: Color.fromRGBO(12, 13, 13, 0.16)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.space8),
            rows[i],
          ],
        ],
      ),
    );
  }

  Widget _dayCell(final DateTime date) {
    final isCurrentMonth = date.month == _currentMonth.month;
    final hasEvent = _hasEvent(date) && isCurrentMonth;
    final selected = _isSelected(date) || hasEvent;
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
        child: SizedBox.square(
          dimension: AppDimensions.minTouchTarget,
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                border: border,
                boxShadow: selected ? AppShadows.low : null,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: AppTypography.smallRegular.copyWith(
                      color: textColor,
                      fontWeight: fontWeight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: AppDimensions.space8,
                    child: Center(
                      child: hasEvent
                          ? Container(
                              width: AppDimensions.space8,
                              height: AppDimensions.space8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryDark,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventDot() {
    return Container(
      width: AppDimensions.space8,
      height: AppDimensions.space8,
      decoration: const BoxDecoration(
        color: AppColors.textWhite,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CalendarMonthYearPicker extends StatefulWidget {
  const _CalendarMonthYearPicker({
    required this.initialMonth,
    required this.monthLabels,
  });

  final DateTime initialMonth;
  final List<String> monthLabels;

  @override
  State<_CalendarMonthYearPicker> createState() => _CalendarMonthYearPickerState();
}

class _CalendarMonthYearPickerState extends State<_CalendarMonthYearPicker> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = widget.initialMonth.year;
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                  onPressed: () => setState(() => _year--),
                  tooltip: 'Año anterior',
                ),
                Expanded(
                  child: Text(
                    _year.toString(),
                    style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  onPressed: () => setState(() => _year++),
                  tooltip: 'Año siguiente',
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.monthLabels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 48,
                crossAxisSpacing: AppDimensions.space8,
                mainAxisSpacing: AppDimensions.space8,
              ),
              itemBuilder: (final context, final index) {
                final month = index + 1;
                final isSelected = _year == widget.initialMonth.year && month == widget.initialMonth.month;
                return OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(DateTime(_year, month)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected ? AppColors.secondaryLight200 : AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.borderBlueMutedLight,
                      width: isSelected ? 2 : 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    textStyle: AppTypography.bodyRegular,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.monthLabels[index],
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
