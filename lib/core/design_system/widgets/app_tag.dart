import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// APP TAG  (Figma node `211:4013`)
// ═══════════════════════════════════════════════════════════════════════════════

/// Status of the [AppTag] — controls background, border, foreground and icon.
///
/// Variants (Figma DS node `211:4013`):
/// - [success]      — green pill, checkmark icon
/// - [error]        — red pill, close icon
/// - [warning]      — yellow pill, warning icon
/// - [infoActive]   — teal pill, refresh icon
/// - [infoInactive] — grey pill, hourglass icon
enum AppTagStatus {
  success,
  error,
  warning,
  infoActive,
  infoInactive,
}

/// Design-system status tag — pill-shaped badge with an icon and an uppercase
/// caption label.
///
/// Mirrors Figma DS node `211:4013`:
/// - Border radius: `3XL = 64 dp` (pill)
/// - Padding: `l=4 dp, r=8 dp, v=2 dp`
/// - Gap between icon and text: `XS = 4 dp`
/// - Icon size: `16 dp`
/// - Typography: `Caption/Uppercase` (Inter Bold 12/18, ls=0.15)
///
/// ```dart
/// AppTag(status: AppTagStatus.success, label: 'Éxito')
/// AppTag(status: AppTagStatus.error, label: 'Error')
/// AppTag(status: AppTagStatus.warning, label: 'Atención')
/// AppTag(status: AppTagStatus.infoActive, label: 'Actualizado')
/// AppTag(status: AppTagStatus.infoInactive, label: 'Caducado')
/// ```
class AppTag extends StatelessWidget {
  const AppTag({
    required this.status,
    required this.label,
    super.key,
    this.icon,
  });

  /// The semantic status that drives the colour palette and default icon.
  final AppTagStatus status;

  /// The tag label. Rendered in uppercase per Figma spec.
  final String label;

  /// Optional icon override — defaults to the Figma-specified icon per status.
  final IconData? icon;

  @override
  Widget build(final BuildContext context) {
    final (:bg, :border, :fg, :defaultIcon) = _resolve(status);
    final effectiveIcon = icon ?? defaultIcon;

    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.space4, // l = XS = 4 dp
          2,
          AppDimensions.space8, // r = S  = 8 dp
          2,
        ),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(effectiveIcon, size: 16, color: fg),
            const SizedBox(width: AppDimensions.space4),
            Text(
              label.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }

  /// Resolves [AppTagStatus] → colour set + default icon from DS tokens.
  static ({Color bg, Color border, Color fg, IconData defaultIcon}) _resolve(
    final AppTagStatus status,
  ) => switch (status) {
    AppTagStatus.success => (
      bg: AppColors.successLight,
      border: AppColors.successDark,
      fg: AppColors.successDark,
      defaultIcon: AppIcons.check,
    ),
    AppTagStatus.error => (
      bg: AppColors.errorLight,
      border: AppColors.errorDark,
      fg: AppColors.errorDark,
      defaultIcon: AppIcons.close,
    ),
    AppTagStatus.warning => (
      bg: AppColors.warningLight,
      border: AppColors.warningDark,
      fg: AppColors.warningDark,
      defaultIcon: AppIcons.warning,
    ),
    AppTagStatus.infoActive => (
      bg: AppColors.secondaryLight200,
      border: AppColors.secondaryDark,
      fg: AppColors.secondaryDark,
      defaultIcon: AppIcons.autorenew,
    ),
    AppTagStatus.infoInactive => (
      bg: AppColors.background,
      border: AppColors.primary,
      fg: AppColors.primary,
      defaultIcon: AppIcons.hourglass,
    ),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// BACKWARDS COMPATIBILITY
// ═══════════════════════════════════════════════════════════════════════════════

/// @deprecated Use [AppTagStatus] instead.
@Deprecated('Use AppTagStatus')
typedef AppTagState = AppTagStatus;
