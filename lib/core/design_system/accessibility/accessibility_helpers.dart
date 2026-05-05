import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_dimensions.dart';

/// Accessibility utility functions and widgets.
///
/// All helpers enforce WCAG 2.1 / Material accessibility guidance.
/// None of them depend on generated code or feature layers.

/// Wraps [child] in a [SizedBox] that enforces the minimum 48 dp touch target
/// required by WCAG 2.1 SC 2.5.5 and Material design guidelines.
///
/// Use when a widget is intrinsically smaller than 48 dp (e.g. icons, chips).
Widget withMinTouchTarget(final Widget child) => SizedBox(
  width: AppDimensions.minTouchTarget,
  height: AppDimensions.minTouchTarget,
  child: child,
);

/// Wraps [child] in a [Semantics] node with the given [label] and optional
/// [hint] text.
///
/// Use instead of raw [Semantics] to keep accessibility annotations consistent
/// across the design system.
Widget withSemantics({
  required final Widget child,
  required final String label,
  final String? hint,
  final bool button = false,
  final bool excludeSemantics = false,
}) => Semantics(
  label: label,
  hint: hint,
  button: button,
  excludeSemantics: excludeSemantics,
  child: child,
);

/// Returns an [ExcludeSemantics] wrapper for decorative / redundant widgets
/// that should be invisible to screen readers.
Widget excludeFromSemantics(final Widget child) => ExcludeSemantics(child: child);
