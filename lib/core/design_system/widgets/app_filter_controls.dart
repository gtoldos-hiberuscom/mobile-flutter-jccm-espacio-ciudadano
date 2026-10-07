import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class AppFilterButton extends StatelessWidget {
  const AppFilterButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.activeFilterCount = 0,
    this.semanticsLabel,
  }) : assert(label.length > 0, 'label must not be empty'),
       assert(activeFilterCount >= 0, 'activeFilterCount must not be negative');

  final String label;
  final int activeFilterCount;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final effectiveLabel = activeFilterCount == 0 ? label : '$label ($activeFilterCount)';
    final effectiveSemanticsLabel = semanticsLabel ?? (activeFilterCount == 0 ? label : AppLocalizations.of(context).a11yFilterButtonActiveCount(label, activeFilterCount));
    return AppButton(
      label: effectiveLabel,
      semanticsLabel: effectiveSemanticsLabel,
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
  }) : assert(label.length > 0, 'label must not be empty');

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      enabled: onTap != null,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: AppFocusRing(
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            enabled: onTap != null,
            child: InkWell(
              onTap: onTap,
              canRequestFocus: onTap != null,
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 52),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.backgroundBlueLighter : AppColors.backgroundWhite,
                  border: Border.all(
                    color: onTap == null ? AppColors.outline : AppColors.secondary,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: AppTypography.bodyRegular.copyWith(
                          color: onTap == null ? AppColors.textDisabled : AppColors.textBlack,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: AppDimensions.space8),
                      AppIcon(
                        AppIcons.checkCircle,
                        color: onTap == null ? AppColors.textDisabled : AppColors.secondary,
                      ),
                    ],
                  ],
                ),
              ),
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
    this.semanticsLabel,
  }) : assert(clearLabel.length > 0, 'clearLabel must not be empty'),
       assert(applyLabel.length > 0, 'applyLabel must not be empty');

  final VoidCallback? onClear;
  final VoidCallback? onApply;
  final String clearLabel;
  final String applyLabel;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final useHorizontalLayout = isLandscape && MediaQuery.textScalerOf(context).scale(1) <= 1.5;
    final groupLabel = semanticsLabel ?? AppLocalizations.of(context).a11yFilterActions;
    assert(groupLabel.isNotEmpty, 'semanticsLabel must not be empty');
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: groupLabel,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.backgroundBlueLighter,
          border: Border(top: BorderSide(color: AppColors.backgroundBlueMutedLight)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space16),
            child: useHorizontalLayout
                ? Row(
                    children: [
                      Expanded(child: _sortedButton(1, _clearButton())),
                      const SizedBox(width: AppDimensions.space16),
                      Expanded(child: _sortedButton(2, _applyButton())),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _sortedButton(1, _clearButton()),
                      const SizedBox(height: AppDimensions.space16),
                      _sortedButton(2, _applyButton()),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _sortedButton(final double order, final Widget child) => Semantics(
    sortKey: OrdinalSortKey(order),
    child: child,
  );

  Widget _clearButton() => AppButton(
    label: clearLabel,
    onPressed: onClear,
    hierarchy: AppButtonHierarchy.secondary,
    leadingIcon: AppIcons.autorenew,
    isExpanded: true,
    showDisabledOutline: true,
  );

  Widget _applyButton() => AppButton(
    label: applyLabel,
    onPressed: onApply,
    leadingIcon: AppIcons.check,
    isExpanded: true,
    showDisabledOutline: true,
  );
}
