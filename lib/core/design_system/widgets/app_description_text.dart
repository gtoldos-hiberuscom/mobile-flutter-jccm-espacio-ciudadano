import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// State for [AppDescriptionText] — mirrors Figma "Description Text" node.
enum AppDescriptionTextState {
  /// Helper hint (info icon, neutral/dark color).
  helper,

  /// Field-level error (warning icon, error/dark color).
  error,
}

/// Icon + caption row displayed below form inputs.
class AppDescriptionText extends StatelessWidget {
  const AppDescriptionText({
    required this.text,
    super.key,
    this.state = AppDescriptionTextState.helper,
  });

  final String text;
  final AppDescriptionTextState state;

  @override
  Widget build(final BuildContext context) {
    final (color, icon) = switch (state) {
      AppDescriptionTextState.helper => (
        AppColors.neutralDark,
        Icons.info_outline_rounded,
      ),
      AppDescriptionTextState.error => (
        AppColors.error,
        Icons.warning_amber_rounded,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppDimensions.iconMedium, color: color),
        const SizedBox(width: AppDimensions.space8),
        Flexible(
          child: Text(
            text,
            style: AppTypography.caption.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
