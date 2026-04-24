import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/extensions/date_time_format.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/2_presentation/widgets/expediente_estado_chip.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders the metadata section of the expediente detail (STORY-35).
class ExpedienteMetadataBlock extends StatelessWidget {
  const ExpedienteMetadataBlock({required this.detail, super.key});

  final ExpedienteDetail detail;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final entries = <(String, String)>[
      (l10n.caseworkExpedienteDetailNumero, detail.numero),
      (l10n.caseworkExpedienteDetailAsuntoCodigo, detail.asuntoCodigo),
      (l10n.caseworkExpedienteDetailAsunto, detail.asunto),
      (l10n.caseworkExpedienteDetailConsejeria, detail.consejeria),
      (l10n.caseworkExpedienteDetailOficina, detail.oficinaTramitadora),
      (l10n.caseworkExpedienteDetailProcedimiento, detail.procedimiento),
      (
        l10n.caseworkExpedienteDetailFechaInicio,
        detail.fechaInicio.formatDdMmYyyy(),
      ),
      (
        l10n.caseworkExpedienteDetailFechaActualizacion,
        detail.fechaUltimaActualizacion.formatDdMmYyyy(),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    l10n.caseworkExpedienteDetailMetadataTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                ExpedienteEstadoChip(estado: detail.estado),
              ],
            ),
            const SizedBox(height: AppDimensions.space12),
            for (final entry in entries) ...<Widget>[
              _MetadataRow(label: entry.$1, value: entry.$2),
              const SizedBox(height: AppDimensions.space8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
