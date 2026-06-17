import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

class AppCaptchaPlaceholder extends StatelessWidget {
  const AppCaptchaPlaceholder({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 24),
      color: AppColors.borderBlueMutedBase,
      child: Text(
        label,
        style: AppTypography.leadingMedium.copyWith(color: AppColors.textWhite),
      ),
    );
  }
}

class AppPrivacyInfoText extends StatelessWidget {
  const AppPrivacyInfoText({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        text,
        style: AppTypography.leadingMedium.copyWith(
          color: AppColors.primary,
          height: 1.5,
        ),
      ),
    );
  }
}
