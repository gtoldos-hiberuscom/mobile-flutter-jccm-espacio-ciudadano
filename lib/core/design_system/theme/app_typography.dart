import 'package:flutter/material.dart';

/// Application text-style tokens — JCCM Figma design-system type scale.
///
/// Covers all Figma nodes: H1–H6, LargeText, BodyBold, Body (L/Base/S),
/// Caption, and Small.  Also exposes a full Material 3 [TextTheme] for
/// the [MaterialApp] theme factory.
///
/// No [BuildContext] dependency — safe to reference in theme factories.
abstract final class AppTypography {
  static const String _fontFamily = 'Roboto';

  // ═══════════════════════════════════════════════════════════════════════════
  // JCCM-specific named text styles (mirror Figma node names)
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.28,
    letterSpacing: -0.25,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.44,
  );

  static const TextStyle h6 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static const TextStyle largeText = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Body Large — 18 sp medium, line-height 28/18 ≈ 1.556.
  static const TextStyle bodyL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 28 / 18,
  );

  /// Body Base — default body text.
  static const TextStyle bodyBase = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
  );

  /// Body Small — 14 sp regular, line-height 20/14 ≈ 1.429.
  static const TextStyle bodyS = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static const TextStyle small = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // Material 3 TextTheme (maps Figma scale → Material tokens)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Full Material 3 [TextTheme] applied to [MaterialApp].
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    titleLarge: h4,
    titleMedium: h6,
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: bodyL,
    bodyMedium: bodyBase,
    bodySmall: bodyS,
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    labelMedium: caption,
    labelSmall: small,
  );
}
