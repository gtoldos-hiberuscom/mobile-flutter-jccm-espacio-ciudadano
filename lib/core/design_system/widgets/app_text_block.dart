import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Typography variant for [AppTextBlock].
///
/// Maps directly to the Figma `TextBlocks/TextBlocks` `function` property
/// (node `8:684`).
enum AppTextBlockVariant {
  h1,
  h2,
  h3,

  /// Body-L / Leading — `leadingMedium` (Inter 500, 18/28).
  leadingMedium,

  /// Body-Base — `bodyRegular` (Inter 400, 16/24).
  bodyRegular,

  /// Body-S — `smallRegular` (Inter 400, 14/20).
  smallRegular,

  /// Label — `captionUppercase` (Inter 700, 12/18, uppercase, +0.15 ls).
  label,

  /// Caption — `captionRegular` (Inter 700, 12/18, +0.15 ls).
  caption,
}

/// A rich-text row composed of an optional leading `chevron_right` icon,
/// a flexible text span, and an optional trailing `call_made` icon.
///
/// Mirrors the Figma **"TextBlocks/TextBlocks"** component (`8:684`) from
/// the "text" DS canvas section (node `165:6362`).
///
/// Supports all eight typography variants exposed in Figma via the
/// [AppTextBlockVariant] enum, an optional **link** decoration mode that adds
/// an underline, and fully customisable leading/trailing icon overrides.
///
/// ## Design spec (Figma `165:6362`)
/// - Leading icon: `chevron_right` 24 dp, `AppColors.primary`
/// - Trailing icon: `call_made` 24 dp, `AppColors.primary`
/// - Gap: `8 dp` between all elements
/// - Text color: `AppColors.primary` (all variants)
/// - Link mode: `TextDecoration.underline`
/// - Vertical padding: varies per variant (matches Figma row heights)
///
/// ## Example
/// ```dart
/// // Plain text block
/// AppTextBlock(
///   text: 'Acceder a mis datos',
///   variant: AppTextBlockVariant.bodyRegular,
/// )
///
/// // Tappable link row (H3)
/// AppTextBlock(
///   text: 'Política de privacidad',
///   variant: AppTextBlockVariant.h3,
///   isLink: true,
///   onTap: () => launchUrl(privacyUri),
/// )
///
/// // Disable one of the default icons
/// AppTextBlock(
///   text: 'Solo con icono de salida',
///   variant: AppTextBlockVariant.bodyRegular,
///   showLeadingIcon: false,
/// )
/// ```
class AppTextBlock extends StatelessWidget {
  const AppTextBlock({
    required this.text,
    super.key,
    this.variant = AppTextBlockVariant.bodyRegular,
    this.showLeadingIcon = true,
    this.showTrailingIcon = true,
    this.leadingIcon,
    this.trailingIcon,
    this.isLink = false,
    this.onTap,
    this.color,
  });

  /// The text to display.
  final String text;

  /// Typography size/weight variant. Defaults to [AppTextBlockVariant.bodyRegular].
  final AppTextBlockVariant variant;

  /// Whether to show the leading `chevron_right` icon. Defaults to `true`.
  final bool showLeadingIcon;

  /// Whether to show the trailing `call_made` icon. Defaults to `true`.
  final bool showTrailingIcon;

  /// Override the leading icon widget. When `null` the default `chevron_right`
  /// is used (if [showLeadingIcon] is true).
  final Widget? leadingIcon;

  /// Override the trailing icon widget. When `null` the default `call_made`
  /// is used (if [showTrailingIcon] is true).
  final Widget? trailingIcon;

  /// When `true`, adds underline decoration to the text.
  final bool isLink;

  /// Tap callback. Wraps the row in [InkWell] when non-null.
  final VoidCallback? onTap;

  /// Override the text / icon color. Defaults to [AppColors.primary].
  final Color? color;

  // ── Typography ─────────────────────────────────────────────────────────────

  TextStyle _textStyle(final Color resolvedColor) {
    final base = switch (variant) {
      AppTextBlockVariant.h1 => AppTypography.h1,
      AppTextBlockVariant.h2 => AppTypography.h2,
      AppTextBlockVariant.h3 => AppTypography.h3,
      AppTextBlockVariant.leadingMedium => AppTypography.leadingMedium,
      AppTextBlockVariant.bodyRegular => AppTypography.bodyRegular,
      AppTextBlockVariant.smallRegular => AppTypography.smallRegular,
      AppTextBlockVariant.label => AppTypography.captionUppercase,
      AppTextBlockVariant.caption => AppTypography.captionRegular,
    };
    return base.copyWith(
      color: resolvedColor,
      decoration: isLink ? TextDecoration.underline : TextDecoration.none,
      decorationColor: resolvedColor,
    );
  }

  // ── Padding per variant (matches Figma row heights) ────────────────────────

  EdgeInsets get _padding => switch (variant) {
    AppTextBlockVariant.h1 => const EdgeInsets.only(
      top: AppDimensions.space8,
      bottom: AppDimensions.space16,
    ),
    AppTextBlockVariant.h2 => const EdgeInsets.symmetric(
      vertical: AppDimensions.space8,
    ),
    AppTextBlockVariant.h3 => const EdgeInsets.only(
      top: AppDimensions.space4,
      bottom: AppDimensions.space8,
    ),
    AppTextBlockVariant.leadingMedium => const EdgeInsets.only(
      top: AppDimensions.space4,
      bottom: AppDimensions.space8,
    ),
    AppTextBlockVariant.bodyRegular => const EdgeInsets.symmetric(
      vertical: AppDimensions.space4,
    ),
    AppTextBlockVariant.smallRegular => const EdgeInsets.only(
      bottom: AppDimensions.space4,
    ),
    AppTextBlockVariant.label || AppTextBlockVariant.caption => EdgeInsets.zero,
  };

  @override
  Widget build(final BuildContext context) {
    final resolvedColor = color ?? AppColors.primary;

    Widget row = Padding(
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Leading icon
          if (showLeadingIcon)
            leadingIcon ??
                Icon(
                  AppIcons.chevronRight,
                  size: AppDimensions.iconMedium,
                  color: resolvedColor,
                ),
          if (showLeadingIcon) const SizedBox(width: AppDimensions.space8),

          // Text
          Flexible(
            child: Text(
              text,
              style: _textStyle(resolvedColor),
            ),
          ),

          // Trailing icon
          if (showTrailingIcon) const SizedBox(width: AppDimensions.space8),
          if (showTrailingIcon)
            trailingIcon ??
                Icon(
                  AppIcons.callMade,
                  size: AppDimensions.iconMedium,
                  color: resolvedColor,
                ),
        ],
      ),
    );

    if (onTap != null) {
      row = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        child: row,
      );
    }

    return Semantics(
      button: onTap != null,
      link: isLink,
      label: text,
      child: row,
    );
  }
}
