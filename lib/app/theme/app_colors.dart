import 'package:flutter/material.dart';

/// JCCM brand colour palette — government institutional design tokens.
///
/// All values are `const` — safe to reference in widget trees without context.
/// Do not add [BuildContext] dependencies here.
abstract final class AppColors {
  // ── Primary (JCCM institutional blue) ────────────────────────────────────
  static const Color primary = Color(0xFF003DA5);
  static const Color primaryDark = Color(0xFF002B73);
  static const Color primaryLight = Color(0xFF4D7FD4);
  static const Color primaryContainer = Color(0xFFDDE6F7);

  // ── Accent / secondary ────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF005B9A);
  static const Color secondaryContainer = Color(0xFFD6EAF8);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFC8E6C9);
  static const Color warning = Color(0xFFF57F17);
  static const Color warningContainer = Color(0xFFFFF9C4);
  static const Color error = Color(0xFFB00020);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // ── Neutral ───────────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color background = Color(0xFFFAFAFA);
  static const Color onBackground = Color(0xFF1A1A1A);
  static const Color outline = Color(0xFFBDBDBD);
  static const Color disabled = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFFE0E0E0);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Dark theme variants ───────────────────────────────────────────────────
  static const Color primaryDarkTheme = Color(0xFF4D7FD4);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
}
