import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Una cita en el listado: la fecha con la que se agrupa y la tarjeta que la
/// pinta.
///
/// La tarjeta llega ya construida porque primaria y hospitalaria pintan cosas
/// distintas —`AppAgendaInfoCard` con cuatro huecos frente a la variante con
/// filas etiquetadas—, pero agrupan igual.
typedef MyDataAppointmentEntry = ({DateTime dateTime, Widget card});

/// Listado de citas agrupado por año y mes.
///
/// Lo comparten las dos consultas de citas y la Agenda usa la misma forma. El
/// orden lo decide quien llama: aquí **no se reordena nada**, solo se agrupa,
/// porque el repositorio ya entrega pendientes ascendente y pasadas
/// descendente.
class MyDataAppointmentSections extends StatelessWidget {
  const MyDataAppointmentSections({
    required this.entries,
    required this.emptyMessage,
    super.key,
    this.contactUrl = sescamHealthCentersUrl,
  });

  /// Listado de centros del SESCAM: a dónde se manda al ciudadano tanto desde
  /// el vacío de citas como desde la hoja informativa.
  static const String sescamHealthCentersUrl = 'https://sanidad.castillalamancha.es/ciudadanos/listado-de-centros';

  final List<MyDataAppointmentEntry> entries;

  /// Qué decir cuando no hay citas. Cada pestaña tiene el suyo: el apartado 2.2
  /// prohíbe dejar la pantalla vacía sin explicación, y «no tienes pendientes»
  /// no dice lo mismo que «no tienes pasadas».
  final String emptyMessage;

  final String contactUrl;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (entries.isEmpty) {
      return MyDataNoData(
        message: emptyMessage,
        actionLabel: l10n.myDataNoDataContact,
        contactUrl: contactUrl,
        scrollable: false,
      );
    }

    final sections = <int, Map<int, List<MyDataAppointmentEntry>>>{};
    for (final entry in entries) {
      sections
          .putIfAbsent(entry.dateTime.year, () => <int, List<MyDataAppointmentEntry>>{})
          .putIfAbsent(entry.dateTime.month, () => <MyDataAppointmentEntry>[])
          .add(entry);
    }

    return Semantics(
      role: SemanticsRole.list,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final year in sections.entries) ...[
            // El año y el mes son encabezados (WCAG 1.3.1). Van en 2 y 3, no en
            // 3 y 4 como cuando el listado vivía dentro de Salud: allí había un
            // título de sección en medio, y aquí el único encabezado por encima
            // es el de la barra, que es el nivel 1. Saltarse el 2 rompería la
            // secuencia.
            Semantics(
              header: true,
              headingLevel: 2,
              child: Text(year.key.toString(), style: AppTypography.h2.copyWith(color: AppColors.primary)),
            ),
            const SizedBox(height: AppDimensions.space8),
            for (final month in year.value.entries) ...[
              // El mes se anuncia con su año —«septiembre de 2026»— para que se
              // entienda fuera de contexto, aunque en pantalla solo ponga el mes.
              Semantics(
                header: true,
                headingLevel: 3,
                label: l10n.a11yMonthYear(l10n.commonMonthName(monthKey(month.key)), year.key.toString()),
                excludeSemantics: true,
                child: Text(
                  l10n.commonMonthName(monthKey(month.key)),
                  style: AppTypography.h3.copyWith(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
              for (final entry in month.value) ...[
                Semantics(role: SemanticsRole.listItem, child: entry.card),
                const SizedBox(height: AppDimensions.space12),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

/// Clave de `l10n.commonWeekdayName` para un `DateTime.weekday`.
String weekdayKey(final int weekday) => switch (weekday) {
  DateTime.monday => 'monday',
  DateTime.tuesday => 'tuesday',
  DateTime.wednesday => 'wednesday',
  DateTime.thursday => 'thursday',
  DateTime.friday => 'friday',
  DateTime.saturday => 'saturday',
  DateTime.sunday => 'sunday',
  _ => 'other',
};

/// Clave de `l10n.commonMonthName` para un `DateTime.month`.
String monthKey(final int month) => switch (month) {
  1 => 'january',
  2 => 'february',
  3 => 'march',
  4 => 'april',
  5 => 'may',
  6 => 'june',
  7 => 'july',
  8 => 'august',
  9 => 'september',
  10 => 'october',
  11 => 'november',
  12 => 'december',
  _ => 'other',
};
