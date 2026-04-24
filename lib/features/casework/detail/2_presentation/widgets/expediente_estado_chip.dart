import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_estado.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Chip-style indicator for [ExpedienteEstado] (STORY-35).
class ExpedienteEstadoChip extends StatelessWidget {
  const ExpedienteEstadoChip({required this.estado, super.key});

  final ExpedienteEstado estado;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (Color bg, Color fg, String label) = switch (estado) {
      ExpedienteEstado.abierto => (
          AppColors.successContainer,
          AppColors.success,
          l10n.caseworkExpedienteDetailEstadoAbierto,
        ),
      ExpedienteEstado.cerrado => (
          AppColors.errorContainer,
          AppColors.error,
          l10n.caseworkExpedienteDetailEstadoCerrado,
        ),
      ExpedienteEstado.unknown => (
          AppColors.surfaceVariant,
          AppColors.textSecondary,
          l10n.caseworkExpedienteDetailEstadoUnknown,
        ),
    };
    return Semantics(
      label: '${l10n.caseworkExpedienteDetailEstadoLabel}: $label',
      child: Chip(
        label: Text(label),
        labelStyle: TextStyle(color: fg, fontWeight: FontWeight.w600),
        backgroundColor: bg,
        side: BorderSide(color: fg),
      ),
    );
  }
}
