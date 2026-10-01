import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';

/// A top tab bar component for switching between sections.
///
/// Displays a horizontal bar with tabs separated by dividers.
/// The selected tab is indicated with a colored bar at the bottom.
///
/// Example usage:
/// ```dart
/// AppTopTabBar(
///   tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
///   selectedIndex: 0,
///   onTabSelected: (index) => print('Selected: $index'),
/// )
/// ```
class AppTopTabBar extends StatelessWidget {
  const AppTopTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    super.key,
    this.semanticLabels,
    this.semanticLabel,
  }) : assert(tabs.length > 0, 'tabs must not be empty'),
       assert(
         selectedIndex >= 0 && selectedIndex < tabs.length,
         'selectedIndex must identify an existing tab',
       ),
       assert(
         semanticLabels == null || semanticLabels.length == tabs.length,
         'semanticLabels must match tabs length',
       ),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  /// List of tab labels to display.
  final List<String> tabs;

  /// Index of the currently selected tab.
  final int selectedIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTabSelected;

  /// Optional spoken names for labels containing abbreviations or symbols.
  final List<String>? semanticLabels;

  /// Optional accessible name for the complete tab group.
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      role: SemanticsRole.tabBar,
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.backgroundBlueMutedLight,
          border: Border(
            bottom: BorderSide(color: AppColors.borderBlueMutedLight),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < tabs.length; i++) ...[
                if (i > 0)
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColors.borderBlueMutedLight,
                  ),
                Expanded(
                  child: _TopTab(
                    label: tabs[i],
                    semanticLabel: semanticLabels?[i],
                    position: i + 1,
                    tabCount: tabs.length,
                    isSelected: i == selectedIndex,
                    onTap: () => onTabSelected(i),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.semanticLabel,
    required this.position,
    required this.tabCount,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String? semanticLabel;
  final int position;
  final int tabCount;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      role: SemanticsRole.tab,
      container: true,
      excludeSemantics: true,
      selected: isSelected,
      inMutuallyExclusiveGroup: true,
      label: semanticLabel ?? label,
      value: MaterialLocalizations.of(context).tabLabel(
        tabIndex: position,
        tabCount: tabCount,
      ),
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
          child: AppFocusRing(
            borderRadius: BorderRadius.zero,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space8,
                        vertical: AppDimensions.space8,
                      ),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: AppTypography.smallRegular.copyWith(
                          color: AppColors.textBase,
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: AppDimensions.iconMedium,
                      height: AppDimensions.space4,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppDimensions.radiusXs),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
