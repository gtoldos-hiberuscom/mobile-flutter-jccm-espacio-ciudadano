import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show OrdinalSortKey;
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_modal_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A month calendar widget following the JCCM design system (Figma node
/// `44641:24305`).
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
    this.selectedRange,
    this.eventDates = const {},
    this.onDateSelected,
    this.onMonthChanged,
    this.firstDayOfWeek = DateTime.monday,
    this.compact = false,
    this.semanticsLabel,
    this.headingLevel,
  }) : assert(
         headingLevel == null || (headingLevel >= 1 && headingLevel <= 6),
         'headingLevel must be between 1 and 6',
       ),
       assert(
         firstDayOfWeek >= DateTime.monday && firstDayOfWeek <= DateTime.sunday,
         'firstDayOfWeek must be between Monday and Sunday',
       ),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  /// The initial month to display. Defaults to today.
  final DateTime? initialDate;

  /// Dates that should appear as selected (light-blue + border).
  final Set<DateTime> selectedDates;

  /// Optional inclusive range that should appear as selected.
  final DateTimeRange? selectedRange;

  /// Dates that should display the event indicator dot.
  final Set<DateTime> eventDates;

  /// Callback when a day is tapped.
  final ValueChanged<DateTime>? onDateSelected;

  /// Callback when the displayed month changes.
  final ValueChanged<DateTime>? onMonthChanged;

  /// First day of the week (1 = Monday, 7 = Sunday).
  final int firstDayOfWeek;

  /// Uses reduced typography and spacing. Agenda keeps the regular variant.
  final bool compact;
  final String? semanticsLabel;

  /// Nivel de encabezado del nombre del calendario («Calendario»). Cuando la
  /// pantalla lo trata como una sección propia, las tecnologías de asistencia
  /// pueden llegar a él con la navegación por encabezados (WCAG 1.3.1).
  final int? headingLevel;

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _currentMonth;
  late DateTime _today;

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
    final locale = Localizations.localeOf(context).toLanguageTag();
    final selectedMonth = await showModalBottomSheet<DateTime>(
      context: context,
      constraints: appModalSheetConstraints(context),
      requestFocus: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      builder: (final context) => _CalendarMonthYearPicker(
        initialMonth: _currentMonth,
        monthLabels: [
          for (var month = 1; month <= 12; month++) _capitalize(DateFormat.MMMM(locale).format(DateTime(2024, month))),
        ],
      ),
    );
    if (selectedMonth == null || !mounted) {
      return;
    }
    _setCurrentMonth(selectedMonth);
  }

  bool _isSelected(final DateTime date) {
    final normalizedDate = DateUtils.dateOnly(date);
    final range = widget.selectedRange;
    final isInRange = range != null && !normalizedDate.isBefore(DateUtils.dateOnly(range.start)) && !normalizedDate.isAfter(DateUtils.dateOnly(range.end));
    return isInRange ||
        widget.selectedDates.any(
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

  List<DateTime> _daysInGrid() => calendarGridDays(month: _currentMonth, firstDayOfWeek: widget.firstDayOfWeek);

  /// Tablet (non-compact) uses roomier cells so the grid does not look flat
  /// when stretched across the wide page content.
  bool get _isTabletGrid => !widget.compact && isTabletLayout(context);

  double get _dayTargetSize => _isTabletGrid ? AppDimensions.space64 : AppDimensions.minTouchTarget;

  TextStyle get _dayTextStyle => _isTabletGrid
      ? AppTypography.bodyRegular
      : widget.compact
      ? AppTypography.captionRegular
      : AppTypography.smallRegular;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final monthLabel = _capitalize('${DateFormat.MMMM(locale).format(_currentMonth)} ${_currentMonth.year}');
    final name = widget.semanticsLabel ?? l10n.a11yCalendar;
    final headingLevel = widget.headingLevel;
    if (headingLevel == null) {
      return Semantics(
        container: true,
        explicitChildNodes: true,
        label: name,
        child: _buildCalendarContent(l10n, monthLabel),
      );
    }
    // Encabezado propio, anunciado antes que el contenido del calendario.
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Stack(
        children: [
          _buildCalendarContent(l10n, monthLabel),
          Positioned(
            top: 0,
            left: 0,
            child: Semantics(
              header: true,
              headingLevel: headingLevel,
              sortKey: const OrdinalSortKey(-1),
              label: name,
              child: const SizedBox(width: 1, height: 1),
            ),
          ),
        ],
      ),
    );
  }

  /// Escalado del texto de la rejilla. Se limita al 200 %, el mínimo que
  /// exige WCAG 1.4.4: más allá, siete columnas no caben en un móvil.
  TextScaler get _gridTextScaler => MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 2);

  bool get _hasLargeText => MediaQuery.textScalerOf(context).scale(1) > 1.5;

  /// Alto de la cifra del día con el texto ampliado.
  double get _dayTextHeight {
    final painter = TextPainter(
      text: TextSpan(text: '30', style: _dayTextStyle),
      textDirection: Directionality.of(context),
      textScaler: _gridTextScaler,
    )..layout();
    final height = painter.height.ceilToDouble();
    painter.dispose();
    return height;
  }

  Widget _buildCalendarContent(final AppLocalizations l10n, final String monthLabel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            container: true,
            label: l10n.a11yCalendarMonth(monthLabel),
            liveRegion: true,
            child: const SizedBox(width: 1, height: 1),
          ),
          ColoredBox(
            color: AppColors.secondary,
            child: Column(
              children: [
                _buildHeader(monthLabel),
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
  Widget _buildHeader(final String monthLabel) {
    final useVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    if (useVerticalLayout) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.space8),
        child: Column(
          children: [
            _monthSelector(monthLabel),
            const SizedBox(height: AppDimensions.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navButton(Icons.chevron_left, _previousMonth),
                _navButton(Icons.chevron_right, _nextMonth),
              ],
            ),
          ],
        ),
      );
    }

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
              child: _monthSelector(monthLabel),
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
    final materialL10n = MaterialLocalizations.of(context);
    final label = icon == Icons.chevron_left ? materialL10n.previousMonthTooltip : materialL10n.nextMonthTooltip;
    return Semantics(
      label: label,
      button: true,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: AppFocusRing(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              child: SizedBox.square(
                dimension: AppDimensions.minTouchTarget,
                child: Icon(
                  icon,
                  color: AppColors.textWhite,
                  size: widget.compact ? AppDimensions.iconSmall : AppDimensions.iconMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthSelector(final String monthLabel) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.a11ySelectCalendarMonthYear(monthLabel),
      button: true,
      onTap: _showMonthYearPicker,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: AppFocusRing(
            child: InkWell(
              onTap: _showMonthYearPicker,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: widget.compact ? AppDimensions.space40 : AppDimensions.space48,
                ),
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
                    Icon(
                      Icons.calendar_today_outlined,
                      size: widget.compact ? AppDimensions.iconSmall : AppDimensions.iconMedium,
                      color: AppColors.textWhite,
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    // El mes y el año deben permanecer juntos. Si el ancho
                    // disponible no basta, se reduce la tipografía de forma
                    // proporcional en vez de partir el año en otra línea.
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          monthLabel,
                          maxLines: 1,
                          softWrap: false,
                          style: (widget.compact ? AppTypography.bodyBold : AppTypography.h2).copyWith(color: AppColors.textWhite),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: widget.compact ? AppDimensions.iconSmall : AppDimensions.iconMedium,
                      color: AppColors.textWhite,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Weekday labels ────────────────────────────────────────────────────────
  Widget _buildWeekdayRow() {
    final locale = Localizations.localeOf(context).toLanguageTag();
    // Con el texto ampliado se usa la inicial («L», «M», «X»…): la
    // abreviatura de tres letras no cabe en una columna y se solapaba.
    final format = _hasLargeText ? DateFormat.EEEEE(locale) : DateFormat.E(locale);
    final labels = [
      for (var offset = 0; offset < 7; offset++)
        _capitalize(
          format.format(
            DateTime(2024, 1, 1 + ((widget.firstDayOfWeek - DateTime.monday + offset) % 7)),
          ),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space4),
      child: Row(
        children: labels
            .map(
              (final label) => Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: _isTabletGrid
                        ? AppDimensions.space40
                        : widget.compact
                        ? AppDimensions.space24
                        : AppDimensions.space32,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      textScaler: _gridTextScaler,
                      style: _dayTextStyle.copyWith(
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

    // Five or six rows depending on the month: a fixed row count leaves the
    // last days of the month unpainted.
    for (var row = 0; row < days.length ~/ DateTime.daysPerWeek; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < DateTime.daysPerWeek; col++) {
        final date = days[row * DateTime.daysPerWeek + col];
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
      padding: EdgeInsets.symmetric(
        vertical: _isTabletGrid
            ? AppDimensions.space16
            : widget.compact
            ? AppDimensions.space4
            : AppDimensions.space8,
      ),
      child: Column(children: rows),
    );
  }

  Widget _dayCell(final DateTime date) {
    final isCurrentMonth = date.month == _currentMonth.month;
    final hasEvent = _hasEvent(date) && isCurrentMonth;
    final selected = _isSelected(date);
    final highlighted = selected || hasEvent;
    final today = _isToday(date) && !highlighted;
    final canSelect = isCurrentMonth && widget.onDateSelected != null;
    final materialL10n = MaterialLocalizations.of(context);
    final l10n = AppLocalizations.of(context);
    final baseBoxSize = _isTabletGrid
        ? 52.0
        : _hasLargeText
        ? AppDimensions.space40
        : widget.compact
        ? AppDimensions.space32
        : 36.0;
    // La casilla crece con la cifra para que las filas no se solapen con el
    // texto ampliado (WCAG 1.4.4).
    final textBox = _dayTextHeight + AppDimensions.space8;
    final dayBoxSize = textBox > baseBoxSize ? textBox : baseBoxSize;
    final targetHeight = dayBoxSize + AppDimensions.space8 > _dayTargetSize ? dayBoxSize + AppDimensions.space8 : _dayTargetSize;
    final semanticParts = [
      materialL10n.formatFullDate(date),
      if (today) materialL10n.currentDateLabel,
      if (hasEvent) l10n.a11yCalendarHasEvent,
      if (!isCurrentMonth) l10n.a11yCalendarOutsideMonth,
    ];

    Color backgroundColor;
    Color textColor;
    FontWeight fontWeight;
    BoxBorder? border;

    if (!isCurrentMonth) {
      backgroundColor = AppColors.backgroundBlueMutedLight;
      textColor = AppColors.borderBlueMutedLight; // #A0B2C5
      fontWeight = FontWeight.w400;
    } else if (highlighted) {
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
      container: true,
      label: semanticParts.join(', '),
      button: widget.onDateSelected != null,
      enabled: widget.onDateSelected == null ? null : canSelect,
      selected: selected,
      onTap: canSelect ? () => widget.onDateSelected?.call(date) : null,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: AppFocusRing(
            enabled: canSelect,
            child: InkWell(
              onTap: canSelect ? () => widget.onDateSelected?.call(date) : null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              child: LayoutBuilder(
                builder: (final context, final constraints) {
                  final targetWidth = constraints.maxWidth < _dayTargetSize ? constraints.maxWidth : _dayTargetSize;
                  final boxWidth = dayBoxSize < targetWidth ? dayBoxSize : targetWidth;
                  return SizedBox(
                    width: targetWidth,
                    height: targetHeight,
                    child: Center(
                      child: Container(
                        width: boxWidth,
                        height: dayBoxSize,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          border: border,
                          boxShadow: highlighted ? AppShadows.low : null,
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            Center(
                              child: Text(
                                '${date.day}',
                                textScaler: _gridTextScaler,
                                style: _dayTextStyle.copyWith(
                                  color: textColor,
                                  fontWeight: fontWeight,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (hasEvent)
                              Positioned(
                                bottom: _isTabletGrid ? 3 : 1,
                                child: Container(
                                  width: _isTabletGrid ? AppDimensions.space8 : 6,
                                  height: _isTabletGrid ? AppDimensions.space8 : 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryDark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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

/// Dates rendered by the month grid of [AppCalendar]: whole weeks covering
/// every day of [month], starting on [firstDayOfWeek] (1 = Monday … 7 =
/// Sunday, as in [DateTime.weekday]).
///
/// Returns 35 or 42 dates. Six rows are needed whenever the month starts late
/// enough in the week; a grid fixed at 35 cells simply dropped the last days
/// of those months, which could not be seen, selected, nor show their event
/// dot (March, August and November 2026, for instance).
///
/// The arithmetic is civil — `DateTime(y, m, d + n)` — and never
/// `Duration(days: n)`: a duration is exactly 24 h, so on the 25-hour day of
/// the autumn DST change it does not reach the next day and the grid repeats
/// that date while dragging a 23:00 time into every cell after it.
List<DateTime> calendarGridDays({required final DateTime month, final int firstDayOfWeek = DateTime.monday}) {
  final firstOfMonth = DateTime(month.year, month.month);
  // Weekday offset (first day of week = 0 ... last = 6).
  final leadingDays = (firstOfMonth.weekday - firstDayOfWeek + DateTime.daysPerWeek) % DateTime.daysPerWeek;
  final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
  final weeks = (leadingDays + daysInMonth + DateTime.daysPerWeek - 1) ~/ DateTime.daysPerWeek;
  return [
    for (var cell = 0; cell < weeks * DateTime.daysPerWeek; cell++) DateTime(firstOfMonth.year, firstOfMonth.month, cell + 1 - leadingDays),
  ];
}

String _capitalize(final String value) {
  if (value.isEmpty) {
    return value;
  }
  return '${value[0].toUpperCase()}${value.substring(1)}';
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
    final l10n = AppLocalizations.of(context);
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
                  tooltip: l10n.appCalendarPreviousYearTooltip,
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
                  tooltip: l10n.appCalendarNextYearTooltip,
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
