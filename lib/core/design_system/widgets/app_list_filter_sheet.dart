import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_calendar.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';

@immutable
class AppListFilters {
  const AppListFilters({this.textValues = const {}, this.dateRanges = const {}});

  final Map<String, String> textValues;
  final Map<String, DateTimeRange> dateRanges;

  String text(final String id) => textValues[id] ?? '';
  DateTimeRange? range(final String id) => dateRanges[id];
  int get activeCount => textValues.values.where((final value) => value.trim().isNotEmpty).length + dateRanges.length;
}

sealed class AppListFilterField {
  const AppListFilterField({required this.id, required this.label});
  final String id;
  final String label;
}

final class AppListTextFilterField extends AppListFilterField {
  const AppListTextFilterField({required super.id, required super.label, required this.hint});
  final String hint;
}

final class AppListDateRangeFilterField extends AppListFilterField {
  const AppListDateRangeFilterField({required super.id, required super.label});
}

class AppListFilterSheet extends StatefulWidget {
  const AppListFilterSheet({required this.fields, required this.initialFilters, super.key});

  final List<AppListFilterField> fields;
  final AppListFilters initialFilters;

  @override
  State<AppListFilterSheet> createState() => _AppListFilterSheetState();
}

class _AppListFilterSheetState extends State<AppListFilterSheet> {
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, DateTimeRange> _ranges;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in widget.fields.whereType<AppListTextFilterField>()) field.id: TextEditingController(text: widget.initialFilters.text(field.id)),
    };
    _ranges = Map.of(widget.initialFilters.dateRanges);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: AppDimensions.space8, bottom: MediaQuery.viewInsetsOf(context).bottom + AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < widget.fields.length; index++) ...[
            if (index > 0) const SizedBox(height: AppDimensions.space16),
            switch (widget.fields[index]) {
              final AppListTextFilterField field => AppInputCase(label: field.label, hint: field.hint, controller: _controllers[field.id]),
              final AppListDateRangeFilterField field => _DateRangeField(
                label: field.label,
                value: _ranges[field.id],
                onPressed: () => _selectRange(field),
              ),
            },
          ],
          const SizedBox(height: AppDimensions.space24),
          AppButton(label: 'Limpiar filtros', hierarchy: AppButtonHierarchy.secondary, isExpanded: true, onPressed: () => Navigator.of(context).pop(const AppListFilters())),
          const SizedBox(height: AppDimensions.space12),
          AppButton(label: 'Aplicar filtros', isExpanded: true, onPressed: _apply),
        ],
      ),
    );
  }

  Future<void> _selectRange(final AppListDateRangeFilterField field) async {
    final selected = await AppBottomSheet.show<DateTimeRange>(
      context: context,
      title: field.label,
      body: _DateRangePicker(
        initialRange: _ranges[field.id],
        onClear: _ranges[field.id] == null
            ? null
            : () => setState(() {
                _ranges.remove(field.id);
              }),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _ranges[field.id] = selected);
    }
  }

  void _apply() => Navigator.of(context).pop(
    AppListFilters(
      textValues: {for (final entry in _controllers.entries) entry.key: entry.value.text.trim()},
      dateRanges: Map.unmodifiable(_ranges),
    ),
  );
}

class _DateRangePicker extends StatefulWidget {
  const _DateRangePicker({this.initialRange, this.onClear});
  final DateTimeRange? initialRange;
  final VoidCallback? onClear;

  @override
  State<_DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<_DateRangePicker> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange?.start;
    _end = widget.initialRange?.end;
  }

  @override
  Widget build(final BuildContext context) {
    final range = _start == null || _end == null ? null : DateTimeRange(start: _start!, end: _end!);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: AppDimensions.space8, bottom: AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _start == null
                ? 'Selecciona la fecha inicial.'
                : _end == null
                ? 'Selecciona la fecha final.'
                : 'Rango seleccionado.',
            style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.space12),
          AppCalendar(
            initialDate: _start ?? DateTime.now(),
            selectedDates: _end == null && _start != null ? {_start!} : const {},
            selectedRange: range,
            onDateSelected: _selectDate,
            compact: true,
          ),
          const SizedBox(height: AppDimensions.space16),
          if (widget.onClear != null) ...[
            AppButton(
              label: 'Quitar rango',
              hierarchy: AppButtonHierarchy.secondary,
              isExpanded: true,
              onPressed: () {
                widget.onClear!();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: AppDimensions.space12),
          ],
          AppButton(
            label: 'Seleccionar rango',
            isExpanded: true,
            onPressed: range == null ? null : () => Navigator.of(context).pop(range),
          ),
        ],
      ),
    );
  }

  void _selectDate(final DateTime date) {
    final selected = DateUtils.dateOnly(date);
    setState(() {
      if (_start == null || _end != null) {
        _start = selected;
        _end = null;
      } else if (selected.isBefore(_start!)) {
        _end = _start;
        _start = selected;
      } else {
        _end = selected;
      }
    });
  }
}

class _DateRangeField extends StatelessWidget {
  const _DateRangeField({required this.label, required this.value, required this.onPressed});
  final String label;
  final DateTimeRange? value;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy', Localizations.localeOf(context).languageCode);
    final text = value == null ? 'Seleccionar rango de fechas' : '${formatter.format(value!.start)} – ${formatter.format(value!.end)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodyBold.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: AppDimensions.space8),
        AppButton(label: text, hierarchy: AppButtonHierarchy.secondary, leadingIcon: AppIcons.calendarToday, isExpanded: true, onPressed: onPressed),
      ],
    );
  }
}

bool appFilterContains(final String value, final String query) {
  final normalizedValue = _normalize(value);
  return _normalize(query).split(RegExp(r'\s+')).where((final word) => word.isNotEmpty).every(normalizedValue.contains);
}

bool appFilterDateInRange(final DateTime? date, final DateTimeRange? range) {
  if (range == null) {
    return true;
  }
  if (date == null) {
    return false;
  }
  final day = DateUtils.dateOnly(date);
  return !day.isBefore(DateUtils.dateOnly(range.start)) && !day.isAfter(DateUtils.dateOnly(range.end));
}

String _normalize(final String value) => value.toLowerCase().replaceAll(RegExp('[áàäâ]'), 'a').replaceAll(RegExp('[éèëê]'), 'e').replaceAll(RegExp('[íìïî]'), 'i').replaceAll(RegExp('[óòöô]'), 'o').replaceAll(RegExp('[úùüû]'), 'u').replaceAll('ñ', 'n');
