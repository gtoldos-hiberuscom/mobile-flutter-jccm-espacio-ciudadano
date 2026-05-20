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
  /// Subtle shadow for cards and list items resting on a surface.
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x0F000000), // 6 % black
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4 % black
      blurRadius: 2,
      offset: Offset(0, 0),
    ),
  ];

  // ── Medium ─────────────────────────────────────────────────────────────────
  /// Medium shadow for dropdowns, menus, and floating cards.
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000), // 10 % black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0D000000), // 5 % black
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  // ── High ───────────────────────────────────────────────────────────────────
  /// Strong shadow for modals, dialogs, and bottom sheets.
  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x29000000), // 16 % black
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x14000000), // 8 % black
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // ── OverAll ────────────────────────────────────────────────────────────────
  /// Full surround shadow used for popovers and overlays that need depth on
  /// all sides.
  static const List<BoxShadow> overAll = [
    BoxShadow(
      color: Color(0x33000000), // 20 % black
      blurRadius: 32,
      offset: Offset(0, 0),
      spreadRadius: 4,
    ),
  ];
}
