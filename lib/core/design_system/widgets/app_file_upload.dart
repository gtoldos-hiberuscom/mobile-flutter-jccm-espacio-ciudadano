import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';

/// Upload status for [AppFileUpload].
///
/// Mirrors the three Figma states of the "FileUpload" component (node `102:1689`):
/// - [uploading] — file is being transferred; shows an indeterminate/partial
///   progress bar and a cancel action.
/// - [complete]  — transfer finished; shows a full progress bar (success
///   colour) and a remove action.
/// - [uploaded]  — file is already stored (no progress bar); shows the file
///   details and a delete action.
/// - [error]     — the upload failed; shows an error-coloured bar and a
///   retry action. Not part of the original Figma component — added to
///   surface per-file upload failures without losing progress on siblings.
enum AppFileUploadStatus { uploading, complete, uploaded, error }

/// Displays a file row with upload progress and contextual actions.
///
/// Figma node `102:1689` — "FileUpload" component.
///
/// Example:
/// ```dart
/// AppFileUpload(
///   fileName: '8905454_Documento_aportado.pdf',
///   fileInfo: 'PDF, 123 KB',
///   status: AppFileUploadStatus.uploading,
///   progress: 0.65,
///   onCancel: () { /* cancel upload */ },
/// )
/// ```
class AppFileUpload extends StatelessWidget {
  const AppFileUpload({
    required this.fileName,
    required this.fileInfo,
    required this.status,
    super.key,
    this.progress,
    this.onCancel,
    this.onRemove,
    this.onDelete,
    this.onRetry,
    this.cancelLabel = 'Cancelar',
    this.removeLabel = 'Eliminar',
    this.retryLabel = 'Reintentar',
  });

  /// Displayed file name — rendered as bold underlined link text.
  final String fileName;

  /// Secondary metadata shown below the file name (e.g. "PDF, 123 KB").
  final String fileInfo;

  final AppFileUploadStatus status;

  /// Upload progress in `[0.0, 1.0]`.  `null` renders an indeterminate bar.
  /// Only used when [status] is [AppFileUploadStatus.uploading].
  final double? progress;

  /// Called when the user taps the cancel button during upload.
  final VoidCallback? onCancel;

  /// Called when the user taps the remove button after a completed upload.
  final VoidCallback? onRemove;

  /// Called when the user taps the delete icon on an already-uploaded file.
  final VoidCallback? onDelete;

  /// Called when the user taps the retry action after a failed upload.
  final VoidCallback? onRetry;

  /// Label for the cancel action. Defaults to `'Cancelar'`.
  final String cancelLabel;

  /// Label for the remove action. Defaults to `'Eliminar'`.
  final String removeLabel;

  /// Label for the retry action. Defaults to `'Reintentar'`.
  final String retryLabel;

  @override
  Widget build(final BuildContext context) {
    return switch (status) {
      AppFileUploadStatus.uploading => _UploadingRow(
        fileName: fileName,
        fileInfo: fileInfo,
        progress: progress,
        onCancel: onCancel,
        cancelLabel: cancelLabel,
      ),
      AppFileUploadStatus.complete => _CompleteRow(
        fileName: fileName,
        fileInfo: fileInfo,
        onRemove: onRemove,
        removeLabel: removeLabel,
      ),
      AppFileUploadStatus.uploaded => _UploadedRow(
        fileName: fileName,
        fileInfo: fileInfo,
        onDelete: onDelete,
      ),
      AppFileUploadStatus.error => _ErrorRow(
        fileName: fileName,
        fileInfo: fileInfo,
        onRetry: onRetry,
        retryLabel: retryLabel,
      ),
    };
  }
}

// ── Internal row widgets ───────────────────────────────────────────────────────

/// Shared filename row — bold underlined, file icon on the left.
class _FileNameRow extends StatelessWidget {
  const _FileNameRow({required this.fileName});

  final String fileName;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.description_outlined,
          size: AppDimensions.iconMedium,
          color: AppColors.primary,
        ),
        const SizedBox(width: AppDimensions.space8),
        Expanded(
          child: Text(
            fileName,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyBold.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// A row with file info text on the left and an action widget on the right.
class _FileMetaRow extends StatelessWidget {
  const _FileMetaRow({required this.fileInfo, required this.action});

  final String fileInfo;
  final Widget action;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Text(
          fileInfo,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
        ),
        const Spacer(),
        action,
      ],
    );
  }
}

// ── Uploading ─────────────────────────────────────────────────────────────────

class _UploadingRow extends StatelessWidget {
  const _UploadingRow({
    required this.fileName,
    required this.fileInfo,
    required this.cancelLabel,
    this.progress,
    this.onCancel,
  });

  final String fileName;
  final String fileInfo;
  final double? progress;
  final VoidCallback? onCancel;
  final String cancelLabel;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _FileNameRow(fileName: fileName),
        const SizedBox(height: AppDimensions.space8),
        AppProgressBar(value: progress),
        const SizedBox(height: AppDimensions.space8),
        _FileMetaRow(
          fileInfo: fileInfo,
          action: TextButton.icon(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, AppDimensions.minTouchTarget),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(
              Icons.cancel_outlined,
              size: AppDimensions.iconSmall,
              color: AppColors.primary,
            ),
            iconAlignment: IconAlignment.end,
            label: Text(
              cancelLabel,
              style: AppTypography.smallRegular.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Complete ──────────────────────────────────────────────────────────────────

class _CompleteRow extends StatelessWidget {
  const _CompleteRow({
    required this.fileName,
    required this.fileInfo,
    required this.removeLabel,
    this.onRemove,
  });

  final String fileName;
  final String fileInfo;
  final VoidCallback? onRemove;
  final String removeLabel;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _FileNameRow(fileName: fileName),
        const SizedBox(height: AppDimensions.space8),
        const AppProgressBar(value: 1, color: AppColors.successDark),
        const SizedBox(height: AppDimensions.space8),
        _FileMetaRow(
          fileInfo: fileInfo,
          action: TextButton.icon(
            onPressed: onRemove,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, AppDimensions.minTouchTarget),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              size: AppDimensions.iconSmall,
              color: AppColors.successDark,
            ),
            iconAlignment: IconAlignment.end,
            label: Text(
              removeLabel,
              style: AppTypography.smallRegular.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Uploaded (default) ────────────────────────────────────────────────────────

class _UploadedRow extends StatelessWidget {
  const _UploadedRow({
    required this.fileName,
    required this.fileInfo,
    this.onDelete,
  });

  final String fileName;
  final String fileInfo;
  final VoidCallback? onDelete;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _FileNameRow(fileName: fileName),
              const SizedBox(height: AppDimensions.space4),
              Text(
                fileInfo,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded),
          color: AppColors.primary,
          iconSize: AppDimensions.iconMedium,
          tooltip: 'Eliminar archivo',
        ),
      ],
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorRow extends StatelessWidget {
  const _ErrorRow({
    required this.fileName,
    required this.fileInfo,
    required this.retryLabel,
    this.onRetry,
  });

  final String fileName;
  final String fileInfo;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _FileNameRow(fileName: fileName),
        const SizedBox(height: AppDimensions.space8),
        const AppProgressBar(value: 1, color: AppColors.errorDark),
        const SizedBox(height: AppDimensions.space8),
        _FileMetaRow(
          fileInfo: fileInfo,
          action: TextButton.icon(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, AppDimensions.minTouchTarget),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(
              Icons.refresh_rounded,
              size: AppDimensions.iconSmall,
              color: AppColors.errorDark,
            ),
            iconAlignment: IconAlignment.end,
            label: Text(
              retryLabel,
              style: AppTypography.smallRegular.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
