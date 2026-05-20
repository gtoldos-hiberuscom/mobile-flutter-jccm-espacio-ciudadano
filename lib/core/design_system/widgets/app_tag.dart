import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

enum AppTagState { success, error, warning, infoActive, infoInactive }

class AppTag extends StatelessWidget {
  const AppTag({
    required this.state,
    required this.label,
    super.key,
    this.icon,
  });

  final AppTagState state;
  final String label;
  final IconData? icon;

  @override
  Widget build(final BuildContext context) {
    final (bg, border, fg, defaultIcon) = _tokens(state);
    final effectiveIcon = icon ?? defaultIcon;

    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.space4,
          2,
          AppDimensions.space8,
          2,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: 1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(effectiveIcon, size: 16, color: fg),
            const SizedBox(width: AppDimensions.space4),
            Text(
              label.toUpperCase(),
              style: AppTypography.caption.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static (Color bg, Color border, Color fg, IconData icon) _tokens(
    final AppTagState state,
  ) => switch (state) {
    AppTagState.success => (
      const Color(0xFFD7F4E3),
      const Color(0xFF297047),
      const Color(0xFF297047),
      Icons.check_circle_outline_rounded,
    ),
    AppTagState.error => (
      const Color(0xFFF9E1E1),
      const Color(0xFFA31F1F),
      const Color(0xFFA31F1F),
      Icons.error_outline_rounded,
    ),
    AppTagState.warning => (
      const Color(0xFFFAE9CE),
      const Color(0xFF8E5806),
      const Color(0xFF8E5806),
      Icons.warning_amber_rounded,
    ),
    AppTagState.infoActive => (
      AppColors.secondaryLight200,
      AppColors.secondaryDark,
      AppColors.secondaryDark,
      Icons.autorenew_rounded,
    ),
    AppTagState.infoInactive => (
      AppColors.neutralGray,
      AppColors.primary,
      AppColors.primary,
      Icons.hourglass_empty_rounded,
    ),
  };
}
