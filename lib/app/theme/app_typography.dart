import 'package:flutter/material.dart';

/// Application text-style tokens.
///
/// Uses the default Roboto font family already registered in pubspec.yaml.
/// Extend with brand-specific type scale when the design system is delivered.
abstract final class AppTypography {
  static const String _fontFamily = 'Roboto';

  /// Baseline [TextTheme] applied to [MaterialApp].
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );
}
