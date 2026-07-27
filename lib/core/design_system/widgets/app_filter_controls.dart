import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';

class AppFilterButton extends StatelessWidget {
  const AppFilterButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.activeFilterCount = 0,
  });

  final String label;
  final int activeFilterCount;
  final VoidCallback? onPressed;

  @override
  Widget build(final BuildContext context) {
    final effectiveLabel = activeFilterCount == 0 ? label : '$label ($activeFilterCount)';
    return AppButton(
      label: effectiveLabel,
      onPressed: onPressed,
      leadingIcon: Icons.filter_alt_outlined,
      isExpanded: true,
    );
  }
}

class AppSelectableFilterChip extends StatelessWidget {
  const AppSelectableFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space12,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.backgroundBlueLighter : AppColors.backgroundBlueMutedLight,
              border: Border.all(color: AppColors.secondaryLight400),
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              boxShadow: AppShadows.low,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: AppDimensions.space8),
                  const AppIcon(AppIcons.checkCircle, color: AppColors.secondary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppFilterActionsBar extends StatelessWidget {
  const AppFilterActionsBar({
    required this.onClear,
    required this.onApply,
    super.key,
    this.clearLabel = 'Desmarcar todo',
    this.applyLabel = 'Aplicar filtros',
  });

  final VoidCallback onClear;
  final VoidCallback onApply;
  final String clearLabel;
  final String applyLabel;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withValues(alpha: 0.94),
        border: Border.all(color: AppColors.borderNeutralLight),
        boxShadow: AppShadows.low,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: clearLabel,
                onPressed: onClear,
                hierarchy: AppButtonHierarchy.secondary,
                leadingIcon: AppIcons.autorenew,
                isExpanded: true,
              ),
              const SizedBox(height: AppDimensions.space16),
              AppButton(
                label: applyLabel,
                onPressed: onApply,
                leadingIcon: AppIcons.check,
                isExpanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
