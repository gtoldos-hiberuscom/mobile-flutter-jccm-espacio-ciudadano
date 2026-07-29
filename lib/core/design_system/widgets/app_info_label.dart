import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// A single label/value pair row.
///
/// Mirrors the Figma **"TextBlocks/Labels"** component (`53:2705`) from
/// the "text" DS canvas section (node `165:6362`).
///
/// ## Layout modes
///
/// | [horizontal] | Layout |
/// |---|---|
/// | `true` (default) | Label and value on the same line using a [Wrap]; the label occupies at least `124 dp`. |
/// | `false` | Label above the value in a [Column]. |
///
/// ## Design spec
/// - Label: [AppTypography.captionUppercase] — Inter 700, 12/18, uppercase,
///   `ls 0.15`, `AppColors.primary`
/// - Value: [AppTypography.bodyRegular] — Inter 400, 16/24, `AppColors.primary`
/// - Row padding: `py = 4 dp`
/// - Horizontal gap between label and value: `16 dp`
///
/// ## Example
/// ```dart
/// // Horizontal (default)
/// AppInfoLabel(label: 'Estado', value: 'Activo')
///
/// // Stacked
/// AppInfoLabel(label: 'Descripción', value: 'Texto largo...', horizontal: false)
/// ```
class AppInfoLabel extends StatelessWidget {
  const AppInfoLabel({
    required this.label,
    required this.value,
    super.key,
    this.horizontal = true,
    this.valueColor,
  });

  /// Uppercase caption label shown on the left (horizontal) or above (vertical).
  final String label;

  /// Value text shown on the right (horizontal) or below (vertical).
  final String value;

  /// When `true` (default) the label and value are laid out side-by-side.
  /// When `false` they are stacked vertically.
  final bool horizontal;

  /// Optional value colour. Defaults to [AppColors.primary].
  final Color? valueColor;

  @override
  Widget build(final BuildContext context) {
    final labelWidget = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 124, minHeight: 32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
        ),
      ),
    );

    final valueWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Text(
        value,
        style: AppTypography.bodyRegular.copyWith(
          color: valueColor ?? AppColors.primary,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: horizontal
          ? Wrap(
              spacing: AppDimensions.space16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [labelWidget, valueWidget],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [labelWidget, valueWidget],
            ),
    );
  }
}

/// A vertical list of [AppInfoLabel] rows.
///
/// Mirrors the Figma **"TextLists/InfoLabel_List"** component (`53:2917`).
///
/// Renders each [AppInfoLabel] in a [Column] without dividers, matching the
/// Figma spec where rows are separated only by their built-in vertical padding.
///
/// ## Example
/// ```dart
/// AppInfoLabelList(
///   items: [
///     AppInfoLabelEntry(label: 'NIF', value: '12345678A'),
///     AppInfoLabelEntry(label: 'Nombre', value: 'María García'),
///     AppInfoLabelEntry(label: 'Estado', value: 'Activo'),
///   ],
/// )
/// ```
class AppInfoLabelList extends StatelessWidget {
  const AppInfoLabelList({
    required this.items,
    super.key,
    this.horizontal = true,
  });

  /// The label/value pairs to display.
  final List<AppInfoLabelEntry> items;

  /// Layout passed down to every [AppInfoLabel] in the list.
  /// Defaults to `true` (horizontal).
  final bool horizontal;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: items
          .map(
            (final AppInfoLabelEntry e) => AppInfoLabel(
              label: e.label,
              value: e.value,
              horizontal: horizontal,
              valueColor: e.valueColor,
            ),
          )
          .toList(),
    );
  }
}

/// A single label/value entry used by [AppInfoLabelList].
class AppInfoLabelEntry {
  const AppInfoLabelEntry({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}
