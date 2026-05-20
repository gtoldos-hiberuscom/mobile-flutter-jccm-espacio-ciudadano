import 'package:flutter/material.dart';

/// JCCM brand colour palette — full Figma design-system token set.
///
/// Organised in three groups:
///   1. **Primitive palettes** — raw colour scales (Blue, Neutral, Green,
///      Yellow, Red, DullBlue), 100–1000 gradations.
///   2. **Semantic tokens** — intent-driven aliases that reference primitives.
///   3. **Legacy / backwards-compat** — names kept for existing widget code.
///
/// All values are `const` — safe to reference in widget trees without context.
abstract final class AppColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // 1. PRIMITIVE PALETTES
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Blue ──────────────────────────────────────────────────────────────────
  static const Color blue100 = Color(0xFFDDE6F7);
  static const Color blue200 = Color(0xFFBBCDEF);
  static const Color blue300 = Color(0xFF7B9FDB);
  static const Color blue400 = Color(0xFF4D7FD4);
  static const Color blue500 = Color(0xFF2563C8);
  static const Color blue600 = Color(0xFF003DA5);
  static const Color blue700 = Color(0xFF002B73);
  static const Color blue800 = Color(0xFF001F54);
  static const Color blue900 = Color(0xFF001338);
  static const Color blue1000 = Color(0xFF000A1F);

  // ── Neutral ───────────────────────────────────────────────────────────────
  static const Color neutral100 = Color(0xFFF8F9FA);
  static const Color neutral200 = Color(0xFFF5F5F5);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF1A1A1A);
  static const Color neutral1000 = Color(0xFF0A0A0A);

  // ── Green ─────────────────────────────────────────────────────────────────
  static const Color green100 = Color(0xFFC8E6C9);
  static const Color green200 = Color(0xFFA5D6A7);
  static const Color green300 = Color(0xFF81C784);
  static const Color green400 = Color(0xFF66BB6A);
  static const Color green500 = Color(0xFF4CAF50);
  static const Color green600 = Color(0xFF388E3C);
  static const Color green700 = Color(0xFF2E7D32);
  static const Color green800 = Color(0xFF1B5E20);
  static const Color green900 = Color(0xFF0A3D0F);
  static const Color green1000 = Color(0xFF042207);

  // ── Yellow ────────────────────────────────────────────────────────────────
  static const Color yellow100 = Color(0xFFFFF9C4);
  static const Color yellow200 = Color(0xFFFFF59D);
  static const Color yellow300 = Color(0xFFFFF176);
  static const Color yellow400 = Color(0xFFFFEE58);
  static const Color yellow500 = Color(0xFFFFEB3B);
  static const Color yellow600 = Color(0xFFF9A825);
  static const Color yellow700 = Color(0xFFF57F17);
  static const Color yellow800 = Color(0xFFE65100);
  static const Color yellow900 = Color(0xFF993400);
  static const Color yellow1000 = Color(0xFF4A1A00);

  // ── Red ───────────────────────────────────────────────────────────────────
  static const Color red100 = Color(0xFFFFDAD6);
  static const Color red200 = Color(0xFFFFB4AB);
  static const Color red300 = Color(0xFFFF8A80);
  static const Color red400 = Color(0xFFFF6659);
  static const Color red500 = Color(0xFFF44336);
  static const Color red600 = Color(0xFFD32F2F);
  static const Color red700 = Color(0xFFB00020);
  static const Color red800 = Color(0xFF7F0000);
  static const Color red900 = Color(0xFF4E0000);
  static const Color red1000 = Color(0xFF2A0000);

  // ── DullBlue ──────────────────────────────────────────────────────────────
  static const Color dullBlue100 = Color(0xFFE3EAF4);
  static const Color dullBlue200 = Color(0xFFC8D5EA);
  static const Color dullBlue300 = Color(0xFFA3BAD9);
  static const Color dullBlue400 = Color(0xFF7A9CC6);
  static const Color dullBlue500 = Color(0xFF5480B4);
  static const Color dullBlue600 = Color(0xFF3A659E);
  static const Color dullBlue700 = Color(0xFF005B9A);
  static const Color dullBlue800 = Color(0xFF003F6B);
  static const Color dullBlue900 = Color(0xFF002540);
  static const Color dullBlue1000 = Color(0xFF00111E);

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. SEMANTIC TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Primary ───────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF002855);

  /// Figma token primaryDark — deep navy background used on landing/hero sections.
  static const Color primaryDark = Color(0xFF031B35);
  static const Color primaryLight = blue400;
  static const Color primaryContainer = blue100;
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Secondary ─────────────────────────────────────────────────────────────
  static const Color secondary = dullBlue700;
  static const Color secondaryContainer = dullBlue100;
  static const Color onSecondary = Color(0xFFFFFFFF);

  /// Secondary dark teal — Figma token.
  static const Color secondaryDark = Color(0xFF156579);

  /// Secondary lighter-2 — light teal tint.
  static const Color secondaryLighter2 = Color(0xFFBAE3EE);

  /// Secondary lighter-3 — very light teal tint.
  static const Color secondaryLighter3 = Color(0xFFF1F8F9);

  /// Secondary light 100 — soft teal wash.
  static const Color secondaryLight100 = Color(0xFFE4F3F6);

  /// Secondary light 200 — same as secondaryLighter2.
  static const Color secondaryLight200 = Color(0xFFBAE3EE);

  // ── Status — Success ──────────────────────────────────────────────────────
  static const Color success = green700;
  static const Color successContainer = green100;
  static const Color onSuccess = Color(0xFFFFFFFF);

  // ── Status — Warning ──────────────────────────────────────────────────────
  static const Color warning = yellow700;
  static const Color warningContainer = yellow100;
  static const Color onWarning = Color(0xFF000000);

  // ── Status — Error ────────────────────────────────────────────────────────
  static const Color error = red700;
  static const Color errorContainer = red100;
  static const Color onError = Color(0xFFFFFFFF);

  // ── Background ────────────────────────────────────────────────────────────
  static const Color background = neutral100;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = neutral200;
  static const Color onBackground = neutral900;
  static const Color onSurface = neutral900;

  // ── Border ────────────────────────────────────────────────────────────────
  static const Color outline = neutral400;
  static const Color outlineVariant = neutral300;
  static const Color divider = neutral300;

  /// Neutral outline base — used for card/nav-card borders.
  static const Color outlineNeutralBase = Color(0xFFA0B2C5);

  /// Neutral gray — disabled background / subtle fill.
  static const Color neutralGray = Color(0xFFE5E2E1);

  /// Neutral dark — subdued icon and helper text.
  static const Color neutralDark = Color(0xFF678098);

  /// Divider base color — 1 dp separator token.
  static const Color dividerColor = Color(0xFFE0E5EB);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral700;
  static const Color textDisabled = neutral500;
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSurface = neutral900;

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
