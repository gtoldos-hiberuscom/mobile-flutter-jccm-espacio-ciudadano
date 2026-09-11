import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// A segmented control for selecting between multiple options.
///
/// This component provides a rounded container with multiple segments,
/// where only one can be selected at a time. The selected segment
/// is highlighted with a different background and border color.
///
/// Example usage:
/// ```dart
/// AppSegmentedControl(
///   segments: ['Option 1', 'Option 2', 'Option 3'],
///   selectedIndex: 0,
///   onSelected: (index) => print('Selected: $index'),
/// )
/// ```
class AppSegmentedControl extends StatelessWidget {
  const AppSegmentedControl({
    required this.segments,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
    this.enabledSegments,
    this.semanticLabels,
    this.semanticLabel,
  }) : assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  /// List of segment labels to display.
  final List<String> segments;

  /// Index of the currently selected segment.
  final int selectedIndex;

  /// Callback when a segment is tapped.
  final ValueChanged<int> onSelected;

  final List<bool>? enabledSegments;
  final List<String>? semanticLabels;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    assert(segments.isNotEmpty, 'segments must not be empty');
    assert(segments.every((final segment) => segment.isNotEmpty), 'segment labels must not be empty');
    assert(selectedIndex >= 0 && selectedIndex < segments.length, 'selectedIndex is out of range');
    assert(enabledSegments == null || enabledSegments!.length == segments.length, 'enabledSegments must match segments length');
    assert(semanticLabels == null || semanticLabels!.length == segments.length, 'semanticLabels must match segments length');
    assert(semanticLabels == null || semanticLabels!.every((final label) => label.isNotEmpty), 'semanticLabels must not contain empty values');

    final usesScrollableLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final buttons = List.generate(
      segments.length,
      (final index) => _SegmentButton(
        label: segments[index],
        position: index + 1,
        tabCount: segments.length,
        semanticLabel: semanticLabels?[index],
        isSelected: index == selectedIndex,
        isEnabled: enabledSegments?[index] ?? true,
        sortKey: OrdinalSortKey(index.toDouble()),
        onTap: () => onSelected(index),
      ),
    );

    Widget tabGroup(final Widget child) => Semantics(
      role: SemanticsRole.tabBar,
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: child,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderNeutralLight),
      ),
      child: usesScrollableLayout
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: tabGroup(
                Row(
                  children: buttons.indexed
                      .expand(
                        (final entry) => [
                          if (entry.$1 > 0) const SizedBox(width: AppDimensions.space8),
                          SizedBox(width: 160, child: entry.$2),
                        ],
                      )
                      .toList(growable: false),
                ),
              ),
            )
          : tabGroup(
              Row(
                children: buttons.indexed
                    .expand(
                      (final entry) => [
                        if (entry.$1 > 0) const SizedBox(width: AppDimensions.space8),
                        Expanded(child: entry.$2),
                      ],
                    )
                    .toList(growable: false),
              ),
            ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.position,
    required this.tabCount,
    required this.isSelected,
    required this.isEnabled,
    required this.sortKey,
    required this.onTap,
    this.semanticLabel,
  });

  final String label;
  final int position;
  final int tabCount;
  final bool isSelected;
  final bool isEnabled;
  final SemanticsSortKey sortKey;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      role: SemanticsRole.tab,
      container: true,
      label: semanticLabel ?? label,
      value: MaterialLocalizations.of(context).tabLabel(
        tabIndex: position,
        tabCount: tabCount,
      ),
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      enabled: isEnabled,
      sortKey: sortKey,
      onTap: isEnabled ? onTap : null,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: InkWell(
            onTap: isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            child: Container(
              constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.backgroundBlueLighter : AppColors.backgroundWhite,
                border: Border.all(
                  color: isSelected ? AppColors.borderDarkPrimary : AppColors.neutral500,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                boxShadow: isSelected ? AppShadows.low : AppShadows.medium,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space8,
                vertical: AppDimensions.space8,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular.copyWith(
                  color: isEnabled ? AppColors.textBlack : AppColors.textDisabled,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
