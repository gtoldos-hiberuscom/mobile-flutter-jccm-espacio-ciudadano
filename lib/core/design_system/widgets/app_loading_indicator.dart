import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_colors.dart';

/// Centered [CircularProgressIndicator] with a [Semantics] node for screen
/// readers.
///
/// Used as the canonical loading indicator across the design system. Wrap in
/// a [Scaffold] / [SizedBox] / [Expanded] as needed to fill available space.
///
/// Example:
/// ```dart
/// state.when(
///   loading: () => const AppLoadingIndicator(),
///   data: (data) => MyWidget(data),
///   error: (e, _) => ErrorView(error: e),
/// );
/// ```
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.semanticsLabel = 'Cargando',
    this.color,
    this.strokeWidth = 4.0,
  });

  /// Screen-reader label. Override with a localised string when possible.
  final String semanticsLabel;

  /// Indicator colour. Defaults to [AppColors.primary] when not provided.
  final Color? color;

  /// Stroke width passed to [CircularProgressIndicator]. Defaults to `4.0`.
  final double strokeWidth;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      liveRegion: true,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
