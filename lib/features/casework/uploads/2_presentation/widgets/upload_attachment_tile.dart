import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// One row inside the upload list. Visual-only — does not own state.
class UploadAttachmentTile extends StatelessWidget {
  const UploadAttachmentTile({
    required this.attachment,
    required this.onRemove,
    super.key,
  });

  final UploadAttachment attachment;
  final VoidCallback? onRemove;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final hashPrefix = attachment.sha256Hex == null
        ? null
        : (attachment.sha256Hex!.length < 12
            ? attachment.sha256Hex
            : attachment.sha256Hex!.substring(0, 12));
    return Semantics(
      label: '${attachment.displayName} · ${_statusLabel(l10n, attachment.status)}',
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space12),
          child: Row(
            children: <Widget>[
              Icon(
                _statusIcon(attachment.status),
                color: _statusColor(theme, attachment.status),
                semanticLabel: _statusLabel(l10n, attachment.status),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      attachment.displayName,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_humanSize(attachment.sizeBytes)}'
                      '${hashPrefix == null ? '' : ' · sha256:$hashPrefix…'}',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (attachment.errorMessage != null)
                      Text(
                        _errorLabel(l10n, attachment.errorMessage!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
              if (onRemove != null)
                IconButton(
                  tooltip: l10n.caseworkUploadRemoveFile,
                  onPressed: onRemove,
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _statusIcon(final UploadAttachmentStatus s) {
    switch (s) {
      case UploadAttachmentStatus.selected:
      case UploadAttachmentStatus.validating:
        return Icons.hourglass_empty;
      case UploadAttachmentStatus.hashed:
        return Icons.fingerprint;
      case UploadAttachmentStatus.uploading:
        return Icons.cloud_upload_outlined;
      case UploadAttachmentStatus.uploaded:
        return Icons.check_circle_outline;
      case UploadAttachmentStatus.failed:
        return Icons.error_outline;
    }
  }

  static Color _statusColor(final ThemeData t, final UploadAttachmentStatus s) {
    switch (s) {
      case UploadAttachmentStatus.failed:
        return t.colorScheme.error;
      case UploadAttachmentStatus.uploaded:
        return t.colorScheme.primary;
      case UploadAttachmentStatus.selected:
      case UploadAttachmentStatus.validating:
      case UploadAttachmentStatus.hashed:
      case UploadAttachmentStatus.uploading:
        return t.colorScheme.onSurfaceVariant;
    }
  }

  static String _statusLabel(
    final AppLocalizations l10n,
    final UploadAttachmentStatus s,
  ) {
    switch (s) {
      case UploadAttachmentStatus.selected:
        return l10n.caseworkUploadStatusSelected;
      case UploadAttachmentStatus.validating:
        return l10n.caseworkUploadStatusValidating;
      case UploadAttachmentStatus.hashed:
        return l10n.caseworkUploadStatusHashed;
      case UploadAttachmentStatus.uploading:
        return l10n.caseworkUploadStatusUploading;
      case UploadAttachmentStatus.uploaded:
        return l10n.caseworkUploadStatusUploaded;
      case UploadAttachmentStatus.failed:
        return l10n.caseworkUploadStatusFailed;
    }
  }

  static String _errorLabel(final AppLocalizations l10n, final String code) {
    if (code == UploadValidationFailure.unsupportedMime.name) {
      return l10n.caseworkUploadErrorUnsupportedMime;
    }
    if (code == UploadValidationFailure.tooLarge.name) {
      return l10n.caseworkUploadErrorTooLarge;
    }
    if (code == UploadValidationFailure.tooManyFiles.name) {
      return l10n.caseworkUploadErrorTooManyFiles;
    }
    if (code == UploadValidationFailure.emptyFile.name) {
      return l10n.caseworkUploadErrorEmptyFile;
    }
    if (code == UploadValidationFailure.hashMismatch.name) {
      return l10n.caseworkUploadErrorHashMismatch;
    }
    return l10n.caseworkUploadErrorGeneric;
  }

  static String _humanSize(final int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
