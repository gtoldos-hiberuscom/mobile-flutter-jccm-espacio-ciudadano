import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_detail.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders the textual metadata of a [RegistroDetail] — número, fecha,
/// consejería destino, oficina, asunto and observaciones.
class RegistroMetadataBlock extends StatelessWidget {
  const RegistroMetadataBlock({required this.detail, super.key});

  final RegistroDetail detail;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _row(
              theme,
              label: l10n.caseworkRegistroDetailFieldNumero,
              value: detail.numero,
            ),
            const SizedBox(height: AppDimensions.space8),
            _row(
              theme,
              label: l10n.caseworkRegistroDetailFieldFecha,
              value: _formatDate(detail.fecha),
            ),
            const SizedBox(height: AppDimensions.space8),
            _row(
              theme,
              label: l10n.caseworkRegistroDetailFieldConsejeria,
              value: detail.consejeriaDestino,
            ),
            const SizedBox(height: AppDimensions.space8),
            _row(
              theme,
              label: l10n.caseworkRegistroDetailFieldOficina,
              value: detail.oficina,
            ),
            const SizedBox(height: AppDimensions.space8),
            _row(
              theme,
              label: l10n.caseworkRegistroDetailFieldAsunto,
              value: detail.asunto,
            ),
            if (detail.observaciones != null && detail.observaciones!.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppDimensions.space8),
              _row(
                theme,
                label: l10n.caseworkRegistroDetailFieldObservaciones,
                value: detail.observaciones!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(
    final ThemeData theme, {
    required final String label,
    required final String value,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: AppDimensions.space4),
      Text(value, style: theme.textTheme.bodyMedium),
    ],
  );

  static String _formatDate(final DateTime d) {
    final yyyy = d.year.toString().padLeft(4, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy $hh:$mi';
  }
}
