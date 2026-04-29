import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document_status.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/widgets/signature_status_chip.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Single signature document row (STORY-45).
class SignatureDocumentTile extends StatelessWidget {
  const SignatureDocumentTile({
    required this.document,
    required this.onSign,
    super.key,
  });

  final SignatureDocument document;

  /// Invoked when the citizen taps the "Firmar" CTA. Only meaningful
  /// for documents whose [SignatureDocument.status] is `pendiente` —
  /// the tile only renders the CTA in that case.
  final VoidCallback onSign;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dateLabel = _formatDate(document.fechaCreacion);
    final isPending = document.status == SignatureDocumentStatus.pendiente;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    document.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.space8),
                SignatureStatusChip(status: document.status),
              ],
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              document.organismoEmisor,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.space4),
            Row(
              children: <Widget>[
                Icon(
                  Icons.event_outlined,
                  size: AppDimensions.iconSmall,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: AppDimensions.space4),
                Text(
                  dateLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                if (document.sizeBytes != null) ...<Widget>[
                  const SizedBox(width: AppDimensions.space12),
                  Icon(
                    Icons.attach_file_outlined,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: AppDimensions.space4),
                  Text(
                    l10n.signatureDocumentSize(_formatSize(document.sizeBytes!)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
            if (isPending) ...<Widget>[
              const SizedBox(height: AppDimensions.space12),
              Align(
                alignment: Alignment.centerRight,
                // STORY-46: the parent inbox page wires this callback to
                // [SignatureHandoffController.startHandoff] so the citizen
                // is taken to the external Afirma flow.
                child: FilledButton.tonalIcon(
                  onPressed: onSign,
                  icon: const Icon(Icons.draw_outlined),
                  label: Text(l10n.signatureSignAction),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(final DateTime when) {
    final dd = when.day.toString().padLeft(2, '0');
    final mm = when.month.toString().padLeft(2, '0');
    return '$dd/$mm/${when.year}';
  }

  String _formatSize(final int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
