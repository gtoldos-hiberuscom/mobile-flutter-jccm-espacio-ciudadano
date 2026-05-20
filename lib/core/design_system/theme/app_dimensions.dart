/// Spacing, radius, icon, and elevation tokens on a 4-point grid.
///
/// No Flutter dependency — safe in any layer.
abstract final class AppDimensions {
  // ── Spacing scale (4-point grid) ─────────────────────────────────────────
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space56 = 56;
  static const double space64 = 64;

  // ── Border radius ─────────────────────────────────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSmall = 4;
  static const double radiusMedium = 8;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 16;
  static const double radiusRound = 100;

  // ── Icon sizes ────────────────────────────────────────────────────────────
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;

  // ── Elevation ─────────────────────────────────────────────────────────────
  static const double elevationNone = 0;
  static const double elevationLow = 1;
  static const double elevationMedium = 2;
  static const double elevationHigh = 4;

  // ── Layout ────────────────────────────────────────────────────────────────
  /// Standard Material app-bar height.
  static const double appBarHeight = 56;

  /// Bottom navigation bar height (accounts for gesture insets via padding).
  static const double bottomNavHeight = 80;

  // ── Accessibility ─────────────────────────────────────────────────────────
  /// Minimum touch-target size — WCAG 2.1 SC 2.5.5 / Material 48 dp guidance.
  static const double minTouchTarget = 48;
}
