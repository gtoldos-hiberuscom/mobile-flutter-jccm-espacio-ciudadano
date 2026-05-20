import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Size variant for [AppLabel] — mirrors Figma "Labels" node (`53:3355`).
enum AppLabelSize {
  /// Medium — caption bold uppercase, 12 sp w700 ls 0.15, primary colour.
  m,

  /// Small — bodyS, 14 sp regular, primary colour.
  s,
}

/// Form-field label text.
///
/// - [AppLabelSize.m]: uppercase caption bold (12 sp / w700 / ls 0.15) in
///   primary colour.
/// - [AppLabelSize.s]: bodyS (14 sp / w400) in primary colour.
///
/// Optional [required] asterisk signals mandatory fields.
///
/// Example:
/// ```dart
/// AppLabel(text: 'Nombre completo', size: AppLabelSize.m)
/// AppLabel(text: 'Email', required: true)
/// ```
class AppLabel extends StatelessWidget {
  const AppLabel({
    required this.text,
    super.key,
    this.size = AppLabelSize.m,
    this.required = false,
    this.color,
  });

  final String text;
  final AppLabelSize size;
  final bool required;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    final TextStyle textStyle;
    final String displayText;

    switch (size) {
      case AppLabelSize.m:
        textStyle = AppTypography.caption.copyWith(
          color: effectiveColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        );
        displayText = text.toUpperCase();
      case AppLabelSize.s:
        textStyle = AppTypography.bodyS.copyWith(color: effectiveColor);
        displayText = text;
    }

    if (!required) {
      return Text(displayText, style: textStyle);
    }

    return Text.rich(
      TextSpan(
        text: displayText,
        style: textStyle,
        children: [
          TextSpan(
            text: ' *',
            style: textStyle.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
