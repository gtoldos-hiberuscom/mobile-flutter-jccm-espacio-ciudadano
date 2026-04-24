import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/extensions/date_time_format.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_fichero.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Tile representation for an [ExpedienteFichero] (STORY-35).
///
/// The download action is a placeholder until the future-sprint backend
/// download endpoint is wired — tapping it surfaces a SnackBar.
class ExpedienteFicheroTile extends StatelessWidget {
  const ExpedienteFicheroTile({required this.fichero, super.key});

  final ExpedienteFichero fichero;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final subtitleParts = <String>[
      fichero.fechaSubida.formatDdMmYyyy(),
      if (fichero.sizeBytes != null) _formatSize(fichero.sizeBytes!),
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: ListTile(
        leading: Icon(_iconFor(fichero.mimeType), size: AppDimensions.iconLarge),
        title: Text(fichero.nombre, style: theme.textTheme.bodyLarge),
        subtitle: Text(subtitleParts.join(' · ')),
        trailing: IconButton(
          tooltip: l10n.caseworkExpedienteDetailFicheroDownloadTooltip,
          icon: const Icon(Icons.download_outlined),
          // TODO(future-sprint): wire real backend file download.
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.caseworkExpedienteDetailFicheroDownloadStub,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static IconData _iconFor(final String mimeType) {
    if (mimeType.startsWith('image/')) {
      return Icons.image_outlined;
    }
    if (mimeType == 'application/pdf') {
      return Icons.picture_as_pdf_outlined;
    }
    if (mimeType.startsWith('text/')) {
      return Icons.description_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  static String _formatSize(final int sizeBytes) {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    }
    final kb = sizeBytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}
