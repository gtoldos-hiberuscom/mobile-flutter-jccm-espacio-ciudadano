import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Maps an [AgendaCategory] to its localised label and a Material icon.
///
/// Lives in `2_presentation/` because it depends on Flutter / l10n.
class AgendaCategoryUi {
  const AgendaCategoryUi._();

  static IconData iconFor(final AgendaCategory category) {
    switch (category) {
      case AgendaCategory.salud:
        return Icons.medical_services_outlined;
      case AgendaCategory.administrativo:
        return Icons.assignment_outlined;
      case AgendaCategory.educacion:
        return Icons.school_outlined;
      case AgendaCategory.otros:
        return Icons.event_outlined;
    }
  }

  static String labelFor(
    final BuildContext context,
    final AgendaCategory category,
  ) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case AgendaCategory.salud:
        return l10n.agendaCategorySalud;
      case AgendaCategory.administrativo:
        return l10n.agendaCategoryAdministrativo;
      case AgendaCategory.educacion:
        return l10n.agendaCategoryEducacion;
      case AgendaCategory.otros:
        return l10n.agendaCategoryOtros;
    }
  }
}
