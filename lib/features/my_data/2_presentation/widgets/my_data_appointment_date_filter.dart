import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

// Filtro por rango de fechas de un listado de citas.
//
// Lo usan las dos consultas —primaria y hospitalaria—, así que el `id` del
// campo y el rótulo viven en un solo sitio. El título de la hoja lo pone cada
// pantalla: antes se decidía con un `switch` sobre un enum de ámbito que ya no
// existe.

/// Identificador del campo dentro de [AppListFilters]. Es el que hay que pasar
/// a `filters.range(...)` al filtrar.
const String myDataAppointmentDateFilterFieldId = 'date';

/// Acción para la barra superior, con el contador de filtros activos.
Widget myDataAppointmentDateFilterAction({
  required final BuildContext context,
  required final AppListFilters filters,
  required final VoidCallback onPressed,
}) {
  final l10n = AppLocalizations.of(context);
  final active = filters.activeCount;

  return IconButton(
    tooltip: active > 0 ? l10n.myDataHealthActiveFiltersTooltip(active) : l10n.myDataHealthSearchAppointmentsTooltip,
    icon: Badge.count(
      count: active,
      isLabelVisible: active > 0,
      child: const AppIcon(AppIcons.search, color: AppColors.textPrimary),
    ),
    onPressed: onPressed,
  );
}

/// Abre la hoja de filtros. Devuelve `null` si se cerró sin aplicar.
Future<AppListFilters?> showMyDataAppointmentDateFilter({
  required final BuildContext context,
  required final String sheetTitle,
  required final AppListFilters initialFilters,
}) {
  final l10n = AppLocalizations.of(context);
  return AppBottomSheet.show<AppListFilters>(
    context: context,
    title: sheetTitle,
    body: AppListFilterSheet(
      initialFilters: initialFilters,
      fields: [
        AppListDateRangeFilterField(id: myDataAppointmentDateFilterFieldId, label: l10n.myDataHealthFilterDateLabel),
      ],
    ),
  );
}
