import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    required this.child,
    super.key,
    this.leadingBorderColor = AppColors.borderBlueMutedLight,
    this.borderColor = AppColors.borderBlueMutedLight,
  });

  final Widget child;
  final Color leadingBorderColor;
  final Color borderColor;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border(
          top: BorderSide(color: borderColor),
          right: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
          left: BorderSide(color: leadingBorderColor, width: AppDimensions.space8),
        ),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space8),
        child: child,
      ),
    );
  }
}
