import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_file_upload.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class AppAttachmentField extends StatelessWidget {
  const AppAttachmentField({
    required this.label,
    required this.hint,
    required this.pickLabel,
    required this.changeLabel,
    required this.onPick,
    required this.onRemove,
    super.key,
    this.fileName,
    this.fileBytes,
    this.isExpanded = false,
    this.hintAfterButton = false,
    this.isRequired = false,
    this.errorText,
    this.semanticsLabel,
    this.announceChanges = true,
  }) : assert(label.length > 0, 'label must not be empty'),
       assert(hint.length > 0, 'hint must not be empty'),
       assert(pickLabel.length > 0, 'pickLabel must not be empty'),
       assert(changeLabel.length > 0, 'changeLabel must not be empty'),
       assert(fileName == null || fileName.length > 0, 'fileName must not be empty'),
       assert(errorText == null || errorText.length > 0, 'errorText must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String label;
  final String hint;
  final String pickLabel;
  final String changeLabel;
  final String? fileName;
  final int? fileBytes;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final bool isExpanded;
  final bool hintAfterButton;
  final bool isRequired;
  final String? errorText;
  final String? semanticsLabel;
  final bool announceChanges;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fieldLabel = semanticsLabel ?? (isRequired ? l10n.a11yRequiredAttachmentField(label, hint) : l10n.a11yAttachmentField(label, hint));
    final fileInfo = _formatFileInfo(fileBytes);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            label: fieldLabel,
            child: const SizedBox(width: 1, height: 1),
          ),
          ExcludeSemantics(
            child: Text(
              label,
              style: AppTypography.bodyBold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          if (!hintAfterButton) ...[
            const SizedBox(height: AppDimensions.space4),
            ExcludeSemantics(
              child: Text(
                hint,
                style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.space16),
          if (fileName == null)
            AppButton(
              label: pickLabel,
              hierarchy: AppButtonHierarchy.secondary,
              leadingIcon: AppIcons.upload,
              isExpanded: isExpanded,
              onPressed: onPick,
            )
          else ...[
            Semantics(
              container: true,
              label: l10n.a11yAttachmentSelected(fileName!, fileInfo),
              liveRegion: announceChanges,
              child: const SizedBox(width: 1, height: 1),
            ),
            AppFileUpload(
              fileName: fileName!,
              fileInfo: fileInfo,
              status: AppFileUploadStatus.uploaded,
              onDelete: onRemove,
            ),
          ],
          if (hintAfterButton) ...[
            const SizedBox(height: AppDimensions.space16),
            ExcludeSemantics(child: AppDescriptionText(text: hint)),
          ],
          if (fileName != null) ...[
            const SizedBox(height: AppDimensions.space8),
            AppButton(
              label: changeLabel,
              hierarchy: AppButtonHierarchy.tertiary,
              leadingIcon: AppIcons.attachment,
              isExpanded: isExpanded,
              onPressed: onPick,
            ),
          ],
          if (errorText != null) ...[
            const SizedBox(height: AppDimensions.space8),
            Semantics(
              container: true,
              label: l10n.a11yFieldError(label, errorText!),
              liveRegion: announceChanges,
              child: ExcludeSemantics(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppIcon(AppIcons.cancel, color: AppColors.errorDark),
                    const SizedBox(width: AppDimensions.space8),
                    Expanded(
                      child: Text(
                        errorText!,
                        style: AppTypography.smallRegular.copyWith(color: AppColors.errorDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatFileInfo(final int? bytes) {
    if (bytes == null) {
      return '';
    }
    if (bytes < 1024) {
      return '$bytes B';
    }
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(kb >= 100 ? 0 : 1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(mb >= 100 ? 0 : 1)} MB';
  }
}
