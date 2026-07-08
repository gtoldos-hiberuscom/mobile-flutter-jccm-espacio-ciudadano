import 'package:flutter/material.dart';

/// JCCM brand colour palette — full Figma design-system token set.
///
/// Organised in three groups:
///   1. **Primitive palettes** — raw colour scales (Blue, Neutral, Green,
///      Yellow, Red, Blue Muted), matching Figma design-system gradations.
///   2. **Semantic tokens** — intent-driven aliases that reference primitives.
///   3. **Legacy / backwards-compat** — names kept for existing widget code.
///
/// All values are `const` — safe to reference in widget trees without context.
abstract final class AppColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // 1. PRIMITIVE PALETTES
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Blue ──────────────────────────────────────────────────────────────────
  static const Color blue100 = Color(0xFFE4F3F6);
  static const Color blue200 = Color(0xFFBAE3EE);
  static const Color blue300 = Color(0xFF71BDD0);
  static const Color blue400 = Color(0xFF219CBA);
  static const Color blue500 = Color(0xFF117D98);
  static const Color blue600 = Color(0xFF156579);
  static const Color blue700 = Color(0xFF074183);
  static const Color blue800 = Color(0xFF002855);
  static const Color blue900 = Color(0xFF031B35);

  // ── Neutral ───────────────────────────────────────────────────────────────
  static const Color neutral000 = Color(0xFFFFFFFF);
  static const Color neutral100 = Color(0xFFE5E2E1);
  static const Color neutral200 = Color(0xFFC9C6C5);
  static const Color neutral300 = Color(0xFFADAAAA);
  static const Color neutral400 = Color(0xFF939090);
  static const Color neutral500 = Color(0xFF797676);
  static const Color neutral600 = Color(0xFF605E5E);
  static const Color neutral700 = Color(0xFF484646);
  static const Color neutral800 = Color(0xFF313030);
  static const Color neutral900 = Color(0xFF1C1B1B);
  static const Color neutral1000 = Color(0xFF000000);

  // ── Green ─────────────────────────────────────────────────────────────────
  static const Color green100 = Color(0xFFD7F4E3);
  static const Color green500 = Color(0xFF22A85A);
  static const Color green900 = Color(0xFF297047);

  // ── Yellow ────────────────────────────────────────────────────────────────
  static const Color yellow100 = Color(0xFFFAE9CE);
  static const Color yellow500 = Color(0xFFE6900A);
  static const Color yellow900 = Color(0xFF8E5806);

  // ── Red ───────────────────────────────────────────────────────────────────
  static const Color red100 = Color(0xFFF9E1E1);
  static const Color red500 = Color(0xFFD93434);
  static const Color red900 = Color(0xFFA31F1F);

  // ── Blue Muted ─────────────────────────────────────────────────────────────
  static const Color blueMuted100 = Color(0xFFE7EBEF);
  static const Color blueMuted500 = Color(0xFFC2CCD6);
  static const Color blueMuted700 = Color(0xFF8599AD);
  static const Color blueMuted900 = Color(0xFF35485E);

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. SEMANTIC TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Primary ───────────────────────────────────────────────────────────────
  /// Figma: Color(new)/Primary — Light  {Blue/700}
  static const Color primaryLight = blue700;

  /// Figma: Color(new)/Primary — Base  {Blue/800}
  static const Color primary = blue800;

  /// Figma: Color(new)/Primary — Dark  {Blue/900}
  static const Color primaryDark = blue900;

  static const Color primaryContainer = blue100;
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Secondary ─────────────────────────────────────────────────────────────
  /// Figma: Color(new)/Secondary — Light 100  {Blue/100}
  static const Color secondaryLight100 = blue100;

  /// Figma: Color(new)/Secondary — Light 200  {Blue/200}
  static const Color secondaryLight200 = blue200;

  /// Figma: Color(new)/Secondary — Light 300  {Blue/300}
  static const Color secondaryLight300 = blue300;

  /// Figma: Color(new)/Secondary — Light 400  {Blue/400}
  static const Color secondaryLight400 = blue400;

  /// Figma: Color(new)/Secondary — Base  {Blue/500}
  static const Color secondary = blue500;

  /// Figma: Color(new)/Secondary — Dark  {Blue/600}
  static const Color secondaryDark = blue600;

  static const Color secondaryContainer = blue100;
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ── Text ──────────────────────────────────────────────────────────────────
  /// Figma: Color(new)/Text — Primary  {Blue/900}
  static const Color textPrimary = blue900;

  /// Figma: Color(new)/Text — Black  {Neutral/1000}
  static const Color textBlack = neutral1000;

  /// Figma: Color(new)/Text — White  {Neutral/000}
  static const Color textWhite = neutral000;

  /// Figma: Color(new)/Text — Link on light  {Blue/500}
  static const Color textLinkOnLight = blue500;

  /// Figma: Color(new)/Text — Link on dark  {Blue/300}
  static const Color textLinkOnDark = blue300;

  /// Figma: Color(new)/Text — Bluemuted-dark  {#383E45}
  static const Color textBlueMutedDark = Color(0xFF383E45);

  // Kept for backward-compat with existing widgets
  static const Color textSecondary = neutral700;
  static const Color textDisabled = neutral500;
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSurface = blue900;

  /// Figma token `Color-Text-Base` / `ColorBrand-Main-Black`.
  static const Color textBase = Color(0xFF0C0D0D);

  // ── Status — Error ────────────────────────────────────────────────────────
  /// Figma: Color(new)/Status/Error — Light  {Red/100}
  static const Color errorLight = red100;

  /// Figma: Color(new)/Status/Error — Middle  {Red/500}
  static const Color error = red500;

  /// Figma: Color(new)/Status/Error — Dark  {Red/900}
  static const Color errorDark = red900;

  static const Color errorContainer = red100;
  static const Color onError = Color(0xFFFFFFFF);

  // ── Status — Warning ──────────────────────────────────────────────────────
  /// Figma: Color(new)/Status/Warning — Light  {Yellow/100}
  static const Color warningLight = yellow100;

  /// Figma: Color(new)/Status/Warning — Middle  {Yellow/500}
  static const Color warning = yellow500;

  /// Figma: Color(new)/Status/Warning — Dark  {Yellow/900}
  static const Color warningDark = yellow900;

  static const Color warningContainer = yellow100;
  static const Color onWarning = Color(0xFF000000);

  // ── Status — Success ──────────────────────────────────────────────────────
  /// Figma: Color(new)/Status/Success — Light  {Green/100}
  static const Color successLight = green100;

  /// Figma: Color(new)/Status/Success — Middle  {Green/500}
  static const Color success = green500;

  /// Figma: Color(new)/Status/Success — Dark  {Green/900}
  static const Color successDark = green900;

  static const Color successContainer = green100;
  static const Color onSuccess = Color(0xFFFFFFFF);

  // ── Background ────────────────────────────────────────────────────────────
  /// Figma: Color(new)/Background — Gray  {Neutral/100}
  static const Color background = neutral100;

  /// Figma: Color(new)/Background — Lightblue  {Blue/100}
  static const Color backgroundLightBlue = blue100;

  /// Figma: Color(new)/Background — Blue-lighter  {#F1F8F9}
  /// Used in card description blocks (active state).
  static const Color backgroundBlueLighter = Color(0xFFF1F8F9);

  /// Figma: Color(new)/Background — Bluemuted-light  {#E0E5EB}
  /// Used in card description blocks (disabled), NavBar grey type,
  /// and progress-bar track.
  static const Color backgroundBlueMutedLight = Color(0xFFE0E5EB);

  /// Figma: Color(new)/Background — Success  {Green/100}
  static const Color backgroundSuccess = green100;

  /// Figma: Color(new)/Background — Warning  {Yellow/100}
  static const Color backgroundWarning = yellow100;

  /// Figma: Color(new)/Background — Error  {Red/100}
  static const Color backgroundError = red100;

  /// Figma: Color(new)/Background — White  {Neutral/000}
  static const Color backgroundWhite = neutral000;

  /// Figma: Color(new)/Background — Dark-primary  {Blue/900}
  static const Color backgroundDarkPrimary = blue900;

  /// Figma: Color(new)/Background — Dark-secondary  {Blue/600}
  static const Color backgroundDarkSecondary = blue600;

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = neutral200;
  static const Color onBackground = neutral900;
  static const Color onSurface = neutral900;

  // ── Border ────────────────────────────────────────────────────────────────
  /// Figma: Color(new)/Border — Dark-primary  {Blue/900}
  static const Color borderDarkPrimary = blue900;

  /// Figma: Color(new)/Border — Error  {Red/900}
  static const Color borderError = red900;

  /// Figma: Color(new)/Border — Warning  {Yellow/900}
  static const Color borderWarning = yellow900;

  /// Figma: Color(new)/Border — Success  {Green/900}
  static const Color borderSuccess = green900;

  /// Figma: Color(new)/Border — Bluemuted-base  {#678098}
  static const Color borderBlueMutedBase = Color(0xFF678098);

  /// Figma: Color(new)/Border — Bluemuted-light  {#A0B2C5}
  static const Color borderBlueMutedLight = Color(0xFFA0B2C5);

  // Kept for backward-compat
  static const Color outline = neutral400;
  static const Color outlineVariant = neutral300;
  static const Color divider = neutral300;
  static const Color borderNeutralLight = neutral200;
  static const Color outlineNeutralBase = blueMuted500;
  static const Color neutralGray = neutral100;
  static const Color neutralDark = blueMuted700;
  static const Color dividerColor = neutral200;
  static const Color statusNeutralLight = blueMuted100;

  // ── Interactive ───────────────────────────────────────────────────────────
  static const Color disabled = neutral500;
  static const Color disabledContainer = neutral200;

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. DARK-THEME VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color primaryDarkTheme = blue400;
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFEEEEEE);
}
