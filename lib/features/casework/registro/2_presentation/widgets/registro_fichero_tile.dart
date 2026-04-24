import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_fichero.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Single-row representation of a [RegistroFichero] inside the registro
/// detail. Read-only — STORY-36 does not own the descarga affordance.
class RegistroFicheroTile extends StatelessWidget {
  const RegistroFicheroTile({required this.fichero, super.key});

  final RegistroFichero fichero;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final subtitle = _subtitle(l10n);

    return ListTile(
      leading: Icon(
        _iconFor(fichero.mimeType),
        color: theme.colorScheme.primary,
      ),
      title: Text(
        fichero.nombre,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  String _subtitle(final AppLocalizations l10n) {
    final parts = <String>[fichero.mimeType];
    final size = fichero.sizeBytes;
    if (size != null && size > 0) {
      parts.add(_humanSize(size));
    }
    return parts.join(' · ');
  }

  static String _humanSize(final int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    final kb = bytes / 1024.0;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(kb >= 100 ? 0 : 1)} KB';
    }
    final mb = kb / 1024.0;
    return '${mb.toStringAsFixed(mb >= 100 ? 0 : 1)} MB';
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
}

/// Inline divider used between consecutive [RegistroFicheroTile]s.
class RegistroFicheroDivider extends StatelessWidget {
  const RegistroFicheroDivider({super.key});

  @override
  Widget build(final BuildContext context) => const Divider(
        height: 1,
        thickness: 1,
        indent: AppDimensions.space16,
        endIndent: AppDimensions.space16,
      );
}
