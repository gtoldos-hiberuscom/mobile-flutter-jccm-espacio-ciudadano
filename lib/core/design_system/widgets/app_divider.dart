import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';

enum AppDividerStrength {
  /// Very light line (1 dp, 20 % opacity).
  soft,

  /// Standard line (1 dp, 50 % opacity).
  medium,

  /// Bold line (1 dp, 100 % opacity).
  hard,
}

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.strength = AppDividerStrength.medium,
    this.dark = false,
    this.axis = Axis.horizontal,
    this.extent,
    this.indent = 0,
    this.endIndent = 0,
  });

  final AppDividerStrength strength;
  final bool dark;
  final Axis axis;
  final double? extent;
  final double indent;
  final double endIndent;

  double get _thickness => 1.0;

  Color get _color {
    if (dark) {
      return switch (strength) {
        AppDividerStrength.soft => const Color.fromRGBO(12, 13, 13, 0.05),
        AppDividerStrength.medium => const Color.fromRGBO(12, 13, 13, 0.16),
        AppDividerStrength.hard => const Color.fromRGBO(12, 13, 13, 0.50),
      };
    }

    const base = AppColors.dividerColor;
    return switch (strength) {
      AppDividerStrength.soft => base.withValues(alpha: 0.2),
      AppDividerStrength.medium => base.withValues(alpha: 0.5),
      AppDividerStrength.hard => base,
    };
  }

  @override
  Widget build(final BuildContext context) {
    if (axis == Axis.vertical) {
      return Container(
        width: _thickness,
        height: extent,
        margin: EdgeInsets.symmetric(vertical: indent),
        color: _color,
      );
    }

    return Divider(
      thickness: _thickness,
      color: _color,
      indent: indent,
      endIndent: endIndent,
      height: extent ?? _thickness * 2,
    );
  }
}
