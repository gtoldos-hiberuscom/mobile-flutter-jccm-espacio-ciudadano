import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Size variant for [AppLabel] — mirrors Figma "Labels" node (`53:3355`).
enum AppLabelSize {
  /// Medium — small bold uppercase, 14 sp w700, primary colour.
  m,

  /// Small — bodyS, 14 sp regular, primary colour.
  s,
}

/// Form-field label text.
///
/// - [AppLabelSize.m]: uppercase small bold (14 sp / w700) in
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
    this.semanticsLabel,
  }) : assert(text != '', 'text must not be empty'),
       assert(
         semanticsLabel == null || semanticsLabel != '',
         'semanticsLabel must not be empty',
       );

  final String text;
  final AppLabelSize size;
  final bool required;
  final Color? color;

  /// Optional pronunciation-friendly alternative for [text].
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    final TextStyle textStyle;
    final String displayText;

    switch (size) {
      case AppLabelSize.m:
        textStyle = AppTypography.smallBold.copyWith(
          color: effectiveColor,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        );
        displayText = text.toUpperCase();
      case AppLabelSize.s:
        textStyle = AppTypography.bodyS.copyWith(color: effectiveColor);
        displayText = text;
    }

    final visibleLabel = required
        ? Text.rich(
            TextSpan(
              text: displayText,
              style: textStyle,
              children: [
                TextSpan(
                  text: '*',
                  style: textStyle.copyWith(color: AppColors.error),
                ),
              ],
            ),
          )
        : Text(displayText, style: textStyle);

    return Semantics(
      label: semanticsLabel ?? text,
      isRequired: required,
      child: ExcludeSemantics(
        child: visibleLabel,
      ),
    );
  }
}
