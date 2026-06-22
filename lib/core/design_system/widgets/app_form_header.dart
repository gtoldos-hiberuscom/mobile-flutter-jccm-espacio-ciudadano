import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

class AppFormHeader extends StatelessWidget {
  const AppFormHeader({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h2.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppDimensions.space8),
        Text(
          description,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
