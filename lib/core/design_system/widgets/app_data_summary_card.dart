import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';

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
    this.semanticLabel,
    this.semanticHint,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty'),
       assert(semanticHint == null || semanticHint.length > 0, 'semanticHint must not be empty');

  final String title;
  final List<AppDataSummaryEntry> highlightedItems;
  final List<AppDataSummaryEntry> footerItems;
  final VoidCallback? onTap;
  final bool showTrailingIcon;
  final String? semanticLabel;
  final String? semanticHint;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);
    final entries = [...highlightedItems, ...footerItems];
    final effectiveSemanticLabel = semanticLabel ?? [title, ...entries.map((final entry) => '${entry.label}: ${entry.value}')].join('. ');
    final content = ConstrainedBox(
      constraints: onTap == null ? const BoxConstraints() : const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.borderBlueMutedLight),
          borderRadius: borderRadius,
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
      ),
    );

    if (onTap == null) {
      return Semantics(
        container: true,
        label: semanticLabel,
        child: semanticLabel == null ? content : ExcludeSemantics(child: content),
      );
    }

    return Semantics(
      container: true,
      label: effectiveSemanticLabel,
      hint: semanticHint,
      button: true,
      enabled: true,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          // Anillo de foco común (WCAG 1.4.11 / 2.4.7) en lugar del sombreado
          // de Material, que no llega a 3:1.
          child: AppFocusRing(
            borderRadius: borderRadius,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              focusColor: Colors.transparent,
              child: content,
            ),
          ),
        ),
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
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final label = Text(
      entry.label.toUpperCase(),
      style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
    );
    final value = Text(
      entry.value,
      textAlign: usesLargeText ? TextAlign.left : valueAlignment,
      style: valueStyle ?? AppTypography.bodyRegular.copyWith(color: AppColors.primary),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Semantics(
        container: true,
        label: '${entry.label}: ${entry.value}',
        child: ExcludeSemantics(
          child: usesLargeText
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label,
                    const SizedBox(height: AppDimensions.space4),
                    value,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 124, minHeight: 32),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: label,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                        child: value,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class AppDataSummaryEntry {
  const AppDataSummaryEntry({
    required this.label,
    required this.value,
  }) : assert(label.length > 0, 'label must not be empty'),
       assert(value.length > 0, 'value must not be empty');

  final String label;
  final String value;
}
