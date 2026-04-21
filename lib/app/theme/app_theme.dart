import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_typography.dart';

/// Central theme factory for the application.
///
/// Colour and typography tokens are sourced from [AppColors] and
/// [AppTypography]. Expand design-system tokens here in the theming story.
///
/// Use [AppTheme.light] and [AppTheme.dark] factory methods directly.
final class AppTheme {
  const AppTheme._();

  /// Light [ThemeData].
  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.jccmPrimary,
        ),
        textTheme: AppTypography.textTheme,
      );

  /// Dark [ThemeData].
  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.jccmPrimary,
          brightness: Brightness.dark,
        ),
        textTheme: AppTypography.textTheme,
        brightness: Brightness.dark,
      );
}
