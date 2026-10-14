import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Upload status for [AppFileUpload].
///
/// Mirrors the three Figma states of the "FileUpload" component (node `102:1689`),
/// which a file goes through in order: [uploading] → [complete] → [uploaded].
/// - [pending]   — file selected and waiting for its upload to start (queued
///   behind another file, or while the transaction opens). Drawn like
///   [uploading] with an indeterminate bar and the cancel action: a delete
///   icon here read as "already uploaded" before anything was sent
///   (JCCMEC-245). Its status reads "Seleccionado", never "Subido" (AP-7).
/// - [uploading] — file is being transferred; shows an indeterminate/partial
///   progress bar and a cancel action.
/// - [complete]  — transfer just finished; shows a full progress bar (success
///   colour) and a "Completado" label, with no action. Meant to be shown
///   briefly before switching to [uploaded].
/// - [uploaded]  — file is already stored (no progress bar); shows the file
///   details and a delete action.
/// - [error]     — the upload failed; shows an error-coloured bar and a
///   retry action. Not part of the original Figma component — added to
///   surface per-file upload failures without losing progress on siblings.
enum AppFileUploadStatus { pending, uploading, complete, uploaded, error }

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
    this.onDelete,
    this.onRetry,
    this.cancelLabel,
    this.deleteLabel,
    this.retryLabel,
  }) : assert(fileName != '', 'fileName must not be empty'),
       assert(fileInfo != '', 'fileInfo must not be empty');

  /// Displayed file name — rendered as bold underlined link text.
  final String fileName;

  /// Secondary metadata shown below the file name (e.g. "PDF, 123 KB").
  final String fileInfo;

  final AppFileUploadStatus status;

  /// Upload progress in `[0.0, 1.0]`.  `null` renders an indeterminate bar.
  /// Only used when [status] is [AppFileUploadStatus.uploading];
  /// [AppFileUploadStatus.pending] is always indeterminate.
  final double? progress;

  /// Called when the user taps the cancel button while the file is pending or
  /// uploading.
  final VoidCallback? onCancel;

  /// Called when the user taps the delete icon on an already-uploaded file.
  final VoidCallback? onDelete;

  /// Called when the user taps the retry action after a failed upload.
  final VoidCallback? onRetry;

  /// Label for the cancel action. Defaults to `'Cancelar'`.
  final String? cancelLabel;

  /// Accessible and visible tooltip for deleting an uploaded file.
  final String? deleteLabel;

  /// Label for the retry action. Defaults to `'Reintentar'`.
  final String? retryLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusLabel = switch (status) {
      AppFileUploadStatus.pending => l10n.caseworkUploadStatusSelected,
      AppFileUploadStatus.uploading => l10n.caseworkUploadStatusUploading,
      AppFileUploadStatus.complete || AppFileUploadStatus.uploaded => l10n.caseworkUploadStatusUploaded,
      AppFileUploadStatus.error => l10n.caseworkUploadStatusFailed,
    };
    final content = switch (status) {
      AppFileUploadStatus.pending => _UploadingRow(
        fileName: fileName,
        fileInfo: fileInfo,
        onCancel: onCancel,
        cancelLabel: cancelLabel ?? l10n.fileUploadCancel,
      ),
      AppFileUploadStatus.uploading => _UploadingRow(
        fileName: fileName,
        fileInfo: fileInfo,
        progress: progress,
        onCancel: onCancel,
        cancelLabel: cancelLabel ?? l10n.fileUploadCancel,
      ),
      AppFileUploadStatus.complete => _CompleteRow(
        fileName: fileName,
        fileInfo: fileInfo,
        completedLabel: l10n.fileUploadCompleted,
      ),
      AppFileUploadStatus.uploaded => _UploadedRow(
        fileName: fileName,
        fileInfo: fileInfo,
        onDelete: onDelete,
        deleteLabel: deleteLabel ?? l10n.fileUploadDelete,
      ),
      AppFileUploadStatus.error => _ErrorRow(
        fileName: fileName,
        fileInfo: fileInfo,
        onRetry: onRetry,
        retryLabel: retryLabel ?? l10n.fileUploadRetry,
        onDelete: onDelete,
        deleteLabel: deleteLabel ?? l10n.fileUploadDelete,
      ),
    };

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: l10n.a11yFileUpload(fileName, fileInfo, statusLabel),
            liveRegion: true,
            child: const SizedBox(width: 1, height: 1),
          ),
          content,
        ],
      ),
    );
  }
}

// ── Internal row widgets ───────────────────────────────────────────────────────

/// Shared filename row — bold underlined, file icon on the left.
class _FileNameRow extends StatelessWidget {
  const _FileNameRow({required this.fileName});

  final String fileName;

  @override
  Widget build(final BuildContext context) {
    return ExcludeSemantics(
      child: Row(
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
              style: AppTypography.bodyBold.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
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
    final info = ExcludeSemantics(
      child: Text(
        fileInfo,
        style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
      ),
    );
    if (MediaQuery.textScalerOf(context).scale(1) > 1.5) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          info,
          Align(alignment: AlignmentDirectional.centerEnd, child: action),
        ],
      );
    }
    return Row(children: [info, const Spacer(), action]);
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
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
              minimumSize: const Size(
                AppDimensions.minTouchTarget,
                AppDimensions.minTouchTarget,
              ),
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
    required this.completedLabel,
  });

  final String fileName;
  final String fileInfo;
  final String completedLabel;

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
          // Plain status, not an action: the delete icon only appears once
          // the card moves on to `uploaded`.
          action: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    completedLabel,
                    style: AppTypography.smallRegular.copyWith(color: AppColors.successDark),
                  ),
                  const SizedBox(width: AppDimensions.space4),
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: AppDimensions.iconSmall,
                    color: AppColors.successDark,
                  ),
                ],
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
    required this.deleteLabel,
    this.onDelete,
  });

  final String fileName;
  final String fileInfo;
  final String deleteLabel;
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
              ExcludeSemantics(
                child: Text(
                  fileInfo,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onDelete,
          constraints: const BoxConstraints(
            minWidth: AppDimensions.minTouchTarget,
            minHeight: AppDimensions.minTouchTarget,
          ),
          icon: const Icon(Icons.delete_outline_rounded),
          color: AppColors.primary,
          iconSize: AppDimensions.iconMedium,
          tooltip: deleteLabel,
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
    required this.deleteLabel,
    this.onRetry,
    this.onDelete,
  });

  final String fileName;
  final String fileInfo;
  final VoidCallback? onRetry;
  final String retryLabel;

  /// Opcional: sin él la tarjeta en error solo ofrece reintentar y el fichero
  /// que falla no se puede quitar del lote.
  final VoidCallback? onDelete;
  final String deleteLabel;

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
          // `Wrap` y no `Row`: con dos acciones a 320 dp y el texto al 200 % no
          // caben en una línea, y la fila de meta ya está en columna a esa
          // escala, así que la segunda acción baja en vez de desbordar.
          action: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton.icon(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
                  minimumSize: const Size(
                    AppDimensions.minTouchTarget,
                    AppDimensions.minTouchTarget,
                  ),
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
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  constraints: const BoxConstraints(
                    minWidth: AppDimensions.minTouchTarget,
                    minHeight: AppDimensions.minTouchTarget,
                  ),
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: AppColors.primary,
                  iconSize: AppDimensions.iconMedium,
                  tooltip: deleteLabel,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
