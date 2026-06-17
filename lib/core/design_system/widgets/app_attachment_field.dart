import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_file_upload.dart';

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
  });

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

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyBold.copyWith(color: AppColors.textPrimary),
        ),
        if (!hintAfterButton) ...[
          const SizedBox(height: AppDimensions.space4),
          Text(
            hint,
            style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary),
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
        else
          AppFileUpload(
            fileName: fileName!,
            fileInfo: _formatFileInfo(fileBytes),
            status: AppFileUploadStatus.uploaded,
            onDelete: onRemove,
          ),
        if (hintAfterButton) ...[
          const SizedBox(height: AppDimensions.space16),
          AppDescriptionText(text: hint),
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
      ],
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
