import 'package:flutter/material.dart';

/// Elevation-based shadow tokens — Figma design-system "Shadows" node
/// (`165:5898`).
///
/// Four levels: Low → Medium → High → OverAll.
/// Each level ships as a [List<BoxShadow>] ready for [BoxDecoration.boxShadow].
///
/// No [BuildContext] dependency — safe to reference in any layer.
abstract final class AppShadows {
  // ── Low ────────────────────────────────────────────────────────────────────
  /// Botones e inputs en reposo.
  /// Figma token Shadow/Low: DROP_SHADOW color:#0000001F offset(0,1) radius:2 spread:0.
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x1F000000), // 12 % black — #0000001F
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  // ── Medium ─────────────────────────────────────────────────────────────────
  /// Cards interactivas y menús.
  /// Figma: DROP_SHADOW rgba(0,0,0,0.16) offset(0,4) blur 6 spread 0.
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x29000000), // 16 % black — #00000029
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  // ── High ───────────────────────────────────────────────────────────────────
  /// Floating Buttons como FABs, popovers y ventanas de diálogo.
  /// Figma: DROP_SHADOW rgba(0,0,0,0.20) offset(0,8) blur 16 spread 0.
  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x33000000), // 20 % black — #00000033
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // ── OverAll ────────────────────────────────────────────────────────────────
  /// Modales, Alerts y elementos críticos.
  /// Figma: DROP_SHADOW rgba(0,0,0,0.25) offset(0,16) blur 32 spread 0.
  static const List<BoxShadow> overAll = [
    BoxShadow(
      color: Color(0x40000000), // 25 % black — #00000040
      blurRadius: 32,
      offset: Offset(0, 16),
    ),
  ];
}
