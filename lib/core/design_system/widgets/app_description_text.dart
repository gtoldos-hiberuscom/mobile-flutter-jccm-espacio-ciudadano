import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

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
    this.semanticsLabel,
    this.announceChanges = true,
  }) : assert(text.length > 0, 'text must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String text;
  final AppDescriptionTextState state;
  final String? semanticsLabel;
  final bool announceChanges;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isError = state == AppDescriptionTextState.error;
    final (color, icon) = switch (state) {
      // El gris azulado anterior se quedaba en 2,9:1 (WCAG 1.4.3).
      AppDescriptionTextState.helper => (
        AppColors.textHelper,
        Icons.info_outline_rounded,
      ),
      AppDescriptionTextState.error => (
        AppColors.error,
        Icons.warning_amber_rounded,
      ),
    };

    return Semantics(
      container: true,
      label: semanticsLabel ?? (isError ? l10n.a11yErrorState(text) : text),
      liveRegion: isError && announceChanges,
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppDimensions.iconMedium, color: color),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                text,
                style: (isError ? AppTypography.bodyRegular : AppTypography.smallRegular).copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
