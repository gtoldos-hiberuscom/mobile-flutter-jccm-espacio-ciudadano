import 'package:flutter/material.dart';

/// Application text-style tokens — JCCM Figma design-system type scale.
///
/// Mirrors the complete Figma typography specification (pages 7–13):
///
///   **Headings**      H1 / H2 / H3  — Inter SemiBold
///   **Leading**       Medium / Bold / Link  — Inter 18 px
///   **Body**          Regular / Bold / Link — Inter 16 px
///   **Small**         Regular / Bold / Link — Inter 14 px
///   **Caption**       Regular / Uppercase   — Inter Bold 12 px
///
/// All font-family tokens resolve to `Inter`.
/// No [BuildContext] dependency — safe to reference in theme factories.
abstract final class AppTypography {
  static const String _fontFamily = 'Inter';

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADINGS  (Figma: Headings/H*)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Figma: Headings/H1 — Inter SemiBold 28 / 36
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    letterSpacing: 0,
  );

  /// Figma: Headings/H2 — Inter SemiBold 24 / 32
  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: 0,
  );

  /// Figma: Headings/H3 — Inter SemiBold 20 / 28
  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: 0,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LEADING  (Figma: Leading/*  — Body/Large — 18 px)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Figma: Leading/Medium — Inter Medium 18 / 28
  static const TextStyle leadingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 28 / 18,
    letterSpacing: 0,
  );

  /// Figma: Leading/Bold — Inter Bold 18 / 28
  static const TextStyle leadingBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 28 / 18,
    letterSpacing: 0,
  );

  /// Figma: Leading/Link — Inter Medium 18 / 28  (underlined)
  static const TextStyle leadingLink = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 28 / 18,
    letterSpacing: 0,
    decoration: TextDecoration.underline,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY  (Figma: Body/*  — Body/Base — 16 px)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Figma: Body/Regular — Inter Regular 16 / 24
  static const TextStyle bodyRegular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
  );

  /// Figma: Body/Bold — Inter Bold 16 / 24
  static const TextStyle bodyBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 24 / 16,
    letterSpacing: 0,
  );

  /// Figma: Body/Link — Inter Regular 16 / 24  (underlined)
  static const TextStyle bodyLink = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
    decoration: TextDecoration.underline,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SMALL  (Figma: Small/*  — Body/Small — 14 px)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Figma: Small/Regular — Inter Regular 14 / 20
  static const TextStyle smallRegular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
  );

  /// Figma: Small/Bold — Inter Bold 14 / 20
  static const TextStyle smallBold = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );

  /// Figma: Small/Link — Inter Regular 14 / 20  (underlined)
  static const TextStyle smallLink = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    decoration: TextDecoration.underline,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CAPTION  (Figma: Caption/*  — 12 px)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Figma: Caption/Regular — Inter Bold 12 / 18  (letterSpacing 0.15)
  static const TextStyle captionRegular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 18 / 12,
    letterSpacing: 0.15,
  );

  /// Figma: Caption/Uppercase — Inter Bold 12 / 18  (letterSpacing 0.15, UPPERCASE)
  static const TextStyle captionUppercase = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 18 / 12,
    letterSpacing: 0.15,
  );

  /// Figma: Body/Caption — Inter Regular 12 / 18  (letterSpacing 0)
  ///
  /// Not to be confused with [captionRegular]: despite its name, that one is
  /// bold and tracked.
  static const TextStyle bodyCaption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
    letterSpacing: 0,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ALIASES — backward-compat names kept for existing widget code
  // ═══════════════════════════════════════════════════════════════════════════

  /// Alias → [leadingMedium]
  static const TextStyle bodyL = leadingMedium;

  /// Alias → [bodyRegular]
  static const TextStyle bodyBase = bodyRegular;

  /// Alias → [smallRegular]
  static const TextStyle bodyS = smallRegular;

  /// Alias → [captionRegular]
  static const TextStyle caption = captionRegular;

  // ═══════════════════════════════════════════════════════════════════════════
  // Material 3 TextTheme
  // ═══════════════════════════════════════════════════════════════════════════

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
    titleLarge: leadingBold,
    titleMedium: bodyBold,
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: leadingMedium,
    bodyMedium: bodyRegular,
    bodySmall: smallRegular,
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    labelMedium: captionRegular,
    labelSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: 0.5,
    ),
  );
}
