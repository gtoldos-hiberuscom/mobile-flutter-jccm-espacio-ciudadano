import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Interactive summary card for compact data records.
///
/// Mirrors Figma cards that combine a leading title, optional navigation arrow,
/// a highlighted data block, and footer label/value rows.
class AppDataSummaryCard extends StatelessWidget {
  const AppDataSummaryCard({
    required this.title,
    super.key,
    this.highlightedItems = const [],
    this.footerItems = const [],
    this.onTap,
    this.showTrailingIcon = false,
  });

  final String title;
  final List<AppDataSummaryEntry> highlightedItems;
  final List<AppDataSummaryEntry> footerItems;
  final VoidCallback? onTap;
  final bool showTrailingIcon;

  @override
  Widget build(final BuildContext context) {
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: AppColors.borderBlueMutedLight),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.medium,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.space4,
                      bottom: AppDimensions.space8,
                    ),
                    child: Text(
                      title,
                      style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
                    ),
                  ),
                ),
                if (showTrailingIcon || onTap != null) ...[
                  const SizedBox(width: AppDimensions.space8),
                  const Padding(
                    padding: EdgeInsets.only(top: AppDimensions.space8),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.primaryDark,
                      size: AppDimensions.iconMedium,
                    ),
                  ),
                ],
              ],
            ),
            if (highlightedItems.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.space8),
              ColoredBox(
                color: AppColors.backgroundLightBlue,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space8,
                    vertical: AppDimensions.space4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: highlightedItems
                        .map(
                          (final entry) => _DataSummaryRow(
                            entry: entry,
                            valueAlignment: TextAlign.right,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
            ],
            if (footerItems.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.space8),
              ...footerItems.map(
                (final entry) => _DataSummaryRow(
                  entry: entry,
                  valueStyle: AppTypography.smallRegular.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: card,
      ),
    );
  }
}

class _DataSummaryRow extends StatelessWidget {
  const _DataSummaryRow({
    required this.entry,
    this.valueStyle,
    this.valueAlignment = TextAlign.left,
  });

  final AppDataSummaryEntry entry;
  final TextStyle? valueStyle;
  final TextAlign valueAlignment;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 124, minHeight: 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                entry.label.toUpperCase(),
                style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
              child: Text(
                entry.value,
                textAlign: valueAlignment,
                style: valueStyle ?? AppTypography.bodyRegular.copyWith(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppDataSummaryEntry {
  const AppDataSummaryEntry({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
