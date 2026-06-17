import 'package:flutter/material.dart';
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
  });

  /// List of segment labels to display.
  final List<String> segments;

  /// Index of the currently selected segment.
  final int selectedIndex;

  /// Callback when a segment is tapped.
  final ValueChanged<int> onSelected;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderNeutralLight),
      ),
      child: Row(
        children: [
          for (var i = 0; i < segments.length; i++) ...[
            if (i > 0) const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: _SegmentButton(
                label: segments[i],
                isSelected: i == selectedIndex,
                onTap: () => onSelected(i),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
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
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.backgroundBlueLighter : AppColors.backgroundWhite,
              border: Border.all(
                color: isSelected ? AppColors.borderDarkPrimary : AppColors.neutral500,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              boxShadow: isSelected ? AppShadows.low : AppShadows.medium,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textBlack,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
