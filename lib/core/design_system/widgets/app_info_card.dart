import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    required this.child,
    super.key,
    this.leadingBorderColor = AppColors.borderBlueMutedLight,
    this.borderColor = AppColors.borderBlueMutedLight,
    this.leadingBorderWidth = AppDimensions.space8,
    this.contentPadding = const EdgeInsets.all(AppDimensions.space8),
    this.semanticLabel,
  }) : assert(leadingBorderWidth >= 0, 'leadingBorderWidth must not be negative'),
       assert(
         semanticLabel == null || semanticLabel != '',
         'semanticLabel must not be empty',
       );

  final Widget child;
  final Color leadingBorderColor;
  final Color borderColor;
  final double leadingBorderWidth;
  final EdgeInsetsGeometry contentPadding;

  /// Optional name for the information group. Descendants remain independently
  /// navigable so links and buttons inside the card keep their own actions.
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: BorderDirectional(
          top: BorderSide(color: borderColor),
          end: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
          start: BorderSide(color: leadingBorderColor, width: leadingBorderWidth),
        ),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Padding(
        padding: contentPadding,
        child: child,
      ),
    );

    if (semanticLabel == null) {
      return card;
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: card,
    );
  }
}
