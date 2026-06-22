import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_checkbox.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_tag.dart';

class AppCaptchaCheck extends StatelessWidget {
  const AppCaptchaCheck({
    required this.label,
    required this.badgeLabel,
    required this.value,
    required this.onChanged,
    super.key,
    this.errorText,
  });

  final String label;
  final String badgeLabel;
  final bool value;
  final String? errorText;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(
          color: errorText == null ? AppColors.borderBlueMutedLight : AppColors.error,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space12),
        child: Row(
          children: [
            Expanded(
              child: AppCheckbox(
                label: label,
                value: value,
                isError: errorText != null,
                errorText: errorText,
                contentPadding: EdgeInsets.zero,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            AppTag(
              status: AppTagStatus.infoInactive,
              label: badgeLabel,
              showIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}
