import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';

/// A standardized info sheet for displaying help information with optional footer.
///
/// This component provides a consistent pattern for info modals across the app,
/// with support for a main body text, optional divider, optional footer text,
/// and optional action button.
///
/// Example usage:
/// ```dart
/// // Simple info sheet with just body text
/// AppInfoSheet.show(
///   context: context,
///   title: 'About Health Data',
///   bodyText: 'Your health data is retrieved from...',
/// );
///
/// // Info sheet with footer text
/// AppInfoSheet.show(
///   context: context,
///   title: 'About Education',
///   bodyText: 'Your education records are...',
///   footerText: 'Contact your institution if data is incorrect.',
/// );
///
/// // Info sheet with footer and action button
/// AppInfoSheet.show(
///   context: context,
///   title: 'About University Titles',
///   bodyText: 'Check your titles from the National Registry...',
///   footerText: 'If your data is incorrect, contact the Ministry.',
///   actionLabel: 'Contact',
///   onActionPressed: () => launchUrl(...),
/// );
/// ```
class AppInfoSheet {
  const AppInfoSheet._();

  /// Shows an info sheet with the given content.
  ///
  /// - [title]: The title of the bottom sheet
  /// - [bodyText]: Main informational text
  /// - [footerText]: Optional footer text, shown after a divider
  /// - [actionLabel]: Optional label for action button
  /// - [onActionPressed]: Optional callback for action button
  /// - [actionIcon]: Optional trailing icon for action button
  static Future<void> show({
    required final BuildContext context,
    required final String title,
    required final String bodyText,
    final String? footerText,
    final String? actionLabel,
    final VoidCallback? onActionPressed,
    final IconData? actionIcon,
  }) async {
    final hasFooter = footerText != null;
    final hasAction = actionLabel != null && onActionPressed != null;

    await AppBottomSheet.show<void>(
      context: context,
      title: title,
      body: _AppInfoSheetBody(
        bodyText: bodyText,
        footerText: footerText,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        actionIcon: actionIcon,
        hasFooter: hasFooter,
        hasAction: hasAction,
      ),
    );
  }
}

class _AppInfoSheetBody extends StatelessWidget {
  const _AppInfoSheetBody({
    required this.bodyText,
    required this.hasFooter,
    required this.hasAction,
    this.footerText,
    this.actionLabel,
    this.onActionPressed,
    this.actionIcon,
  });

  final String bodyText;
  final String? footerText;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final bool hasFooter;
  final bool hasAction;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main body text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
          child: Text(
            bodyText,
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),

        // Divider (only if there's footer or action)
        if (hasFooter || hasAction) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
            child: Divider(
              color: AppColors.divider,
              thickness: 1,
            ),
          ),
        ],

        // Footer text
        if (footerText != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
            child: Text(
              footerText!,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],

        // Action button
        if (hasAction) ...[
          const SizedBox(height: AppDimensions.space8),
          _AppInfoSheetActionButton(
            label: actionLabel!,
            onPressed: onActionPressed!,
            icon: actionIcon,
          ),
        ],
      ],
    );
  }
}

class _AppInfoSheetActionButton extends StatelessWidget {
  const _AppInfoSheetActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: AppDimensions.space8),
              Icon(icon, size: 20, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
