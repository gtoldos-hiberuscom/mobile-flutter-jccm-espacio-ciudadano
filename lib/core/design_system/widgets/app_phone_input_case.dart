import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';

/// Split phone input used when a country prefix selector is part of the field.
class AppPhoneInputCase extends StatelessWidget {
  const AppPhoneInputCase({
    required this.label,
    required this.controller,
    super.key,
    this.countryLabel = '(ES)',
    this.hint = '600 000 000',
    this.errorText,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String countryLabel;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(final BuildContext context) {
    final isError = errorText != null && errorText!.isNotEmpty;
    final color = isError ? AppColors.error : AppColors.primary;
    final borderColor = isError ? AppColors.error : AppColors.borderBlueMutedBase;
    final fillColor = isError ? AppColors.errorContainer : AppColors.backgroundWhite;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.captionUppercase.copyWith(color: color),
        ),
        const SizedBox(height: AppDimensions.space8),
        Container(
          height: AppDimensions.minTouchTarget,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            boxShadow: AppShadows.low,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
                child: Row(
                  children: [
                    const AppIcon(AppIcons.globeLocationPin, color: AppColors.textPrimary),
                    const SizedBox(width: AppDimensions.space4),
                    Text(
                      countryLabel,
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.borderBlueMutedBase),
                    ),
                    const AppIcon(AppIcons.keyboardArrowDown, color: AppColors.textPrimary),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.borderBlueMutedLight,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  onChanged: onChanged,
                  style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTypography.bodyRegular.copyWith(color: AppColors.borderBlueMutedBase),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                  ),
                ),
              ),
              if (isError) ...[
                const SizedBox(width: AppDimensions.space8),
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: AppDimensions.iconSmall,
                ),
                const SizedBox(width: AppDimensions.space8),
              ],
            ],
          ),
        ),
        if (isError) ...[
          const SizedBox(height: AppDimensions.space8),
          AppDescriptionText(
            text: errorText!,
            state: AppDescriptionTextState.error,
          ),
        ],
      ],
    );
  }
}
