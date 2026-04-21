import 'package:flutter/material.dart';

/// JCCM brand colour palette (placeholder values).
///
/// Replace hex values with the official JCCM design system tokens
/// when the branding spec is finalised.
abstract final class AppColors {
  /// Primary brand colour — JCCM institutional blue (placeholder).
  static const Color jccmPrimary = Color(0xFF003087);

  /// Secondary accent colour (placeholder).
  static const Color jccmAccent = Color(0xFF0070C0);

  /// Success / confirmation green.
  static const Color success = Color(0xFF2E7D32);

  /// Warning amber.
  static const Color warning = Color(0xFFF57C00);

  /// Error / destructive red.
  static const Color error = Color(0xFFC62828);

  /// Light surface white.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Dark surface.
  static const Color surfaceDark = Color(0xFF121212);
}
