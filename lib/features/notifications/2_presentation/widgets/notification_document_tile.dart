import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Read-only tile representing a document attached to a notification
/// (STORY-44).
///
/// Renders the filename, a short metadata line (mime label + formatted
/// size), the availability chip and a download `IconButton`. The
/// button is disabled when the document is not
/// [NotificationDocumentAvailability.available].
class NotificationDocumentTile extends StatelessWidget {
  const NotificationDocumentTile({
    required this.document,
    required this.onDownload,
    super.key,
    this.isDownloading = false,
  });

  final NotificationDocument document;

  /// Invoked when the user taps the download button. Must be `null`
  /// when the document is not [NotificationDocumentAvailability.available]
  /// — the tile disables the button accordingly.
  final VoidCallback? onDownload;

  /// When `true`, the download icon is replaced by a spinner so the
  /// user gets feedback while the repository call is in flight.
  final bool isDownloading;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isAvailable = document.availability == NotificationDocumentAvailability.available;
    final canDownload = isAvailable && !isDownloading && onDownload != null;
    final metaParts = <String>[
      _mimeLabel(document.mimeType),
      _sizeLabel(l10n, document.sizeBytes),
    ].where((final part) => part.isNotEmpty).toList(growable: false);

    return Card(
      margin: const EdgeInsets.only(top: AppDimensions.space4, bottom: AppDimensions.space4),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space12),
        child: Row(
          children: <Widget>[
            ExcludeSemantics(
              child: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    document.name,
                    style: theme.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  if (metaParts.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      metaParts.join(' · '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                  if (!isAvailable) ...<Widget>[
                    const SizedBox(height: AppDimensions.space8),
                    _UnavailableChip(label: l10n.notificationDetailDocumentUnavailableChip),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            if (isDownloading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                tooltip: l10n.notificationDetailDocumentDownload,
                icon: const Icon(Icons.download_outlined),
                onPressed: canDownload ? onDownload : null,
              ),
          ],
        ),
      ),
    );
  }

  String _mimeLabel(final String? mimeType) {
    if (mimeType == null || mimeType.isEmpty) {
      return '';
    }
    // Friendly short labels for the most common types; otherwise show
    // the raw value so future mime types are still self-explanatory.
    switch (mimeType) {
      case 'application/pdf':
        return 'PDF';
      case 'application/zip':
        return 'ZIP';
      default:
        return mimeType;
    }
  }

  String _sizeLabel(final AppLocalizations l10n, final int? sizeBytes) {
    if (sizeBytes == null || sizeBytes <= 0) {
      return l10n.notificationDetailDocumentSizeUnknown;
    }
    const oneKb = 1024;
    const oneMb = 1024 * 1024;
    if (sizeBytes >= oneMb) {
      final mb = sizeBytes / oneMb;
      return l10n.notificationDetailDocumentSizeMb(_round1(mb));
    }
    final kb = sizeBytes / oneKb;
    return l10n.notificationDetailDocumentSizeKb(_round1(kb));
  }

  double _round1(final double value) => (value * 10).round() / 10;
}

class _UnavailableChip extends StatelessWidget {
  const _UnavailableChip({required this.label});

  final String label;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
