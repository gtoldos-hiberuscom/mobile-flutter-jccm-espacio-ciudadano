import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';

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
  /// - [footerSpan]: Rich footer, including inline links; overrides [footerText].
  /// - [actionLabel]: Optional label for action button
  /// - [onActionPressed]: Optional callback for action button
  /// - [actionIcon]: Optional trailing icon for action button
  static Future<void> show({
    required final BuildContext context,
    required final String title,
    required final String bodyText,
    final String? footerText,
    final InlineSpan? footerSpan,
    final String? actionLabel,
    final VoidCallback? onActionPressed,
    final IconData? actionIcon,
    final AppButtonHierarchy actionHierarchy = AppButtonHierarchy.ghost,
    final bool actionIsExpanded = false,
    final bool actionIsExternalLink = false,
    final AlignmentGeometry actionAlignment = Alignment.center,
    final String? semanticsLabel,
    final String? closeLabel,
  }) async {
    assert(title != '', 'title must not be empty');
    assert(bodyText != '', 'bodyText must not be empty');
    assert(footerText == null || footerText != '', 'footerText must not be empty');
    assert(
      (actionLabel == null) == (onActionPressed == null),
      'actionLabel and onActionPressed must be provided together',
    );
    assert(actionLabel == null || actionLabel != '', 'actionLabel must not be empty');
    assert(
      semanticsLabel == null || semanticsLabel != '',
      'semanticsLabel must not be empty',
    );
    final hasFooter = footerText != null || footerSpan != null;
    final hasAction = actionLabel != null;

    await AppBottomSheet.show<void>(
      context: context,
      title: title,
      semanticsLabel: semanticsLabel,
      closeLabel: closeLabel,
      horizontalMargin: AppDimensions.space4,
      body: _AppInfoSheetBody(
        bodyText: bodyText,
        footerText: footerText,
        footerSpan: footerSpan,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
        actionIcon: actionIcon,
        actionHierarchy: actionHierarchy,
        actionIsExpanded: actionIsExpanded,
        actionIsExternalLink: actionIsExternalLink,
        actionAlignment: actionAlignment,
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
    this.footerSpan,
    this.actionLabel,
    this.onActionPressed,
    this.actionIcon,
    required this.actionHierarchy,
    required this.actionIsExpanded,
    required this.actionIsExternalLink,
    required this.actionAlignment,
  });

  final String bodyText;
  final String? footerText;
  final InlineSpan? footerSpan;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final AppButtonHierarchy actionHierarchy;
  final bool actionIsExpanded;
  final bool actionIsExternalLink;
  final AlignmentGeometry actionAlignment;
  final bool hasFooter;
  final bool hasAction;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
          child: Text(
            bodyText,
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),

        if (hasFooter || hasAction) ...[
          const ExcludeSemantics(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
              child: Divider(
                color: AppColors.neutral100,
                thickness: 1,
                height: 1,
              ),
            ),
          ),
        ],

        if (hasFooter) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
            child: Text.rich(
              footerSpan ?? TextSpan(text: footerText),
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],

        if (hasAction) ...[
          const SizedBox(height: AppDimensions.space8),
          Align(
            alignment: actionAlignment,
            child: _AppInfoSheetActionButton(
              label: actionLabel!,
              onPressed: onActionPressed!,
              icon: actionIcon,
              hierarchy: actionHierarchy,
              isExpanded: actionIsExpanded,
              isExternalLink: actionIsExternalLink,
            ),
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
    required this.hierarchy,
    required this.isExpanded,
    required this.isExternalLink,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final AppButtonHierarchy hierarchy;
  final bool isExpanded;
  final bool isExternalLink;

  @override
  Widget build(final BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      hierarchy: hierarchy,
      trailingIcon: icon,
      isExpanded: isExpanded,
      isExternalLink: isExternalLink,
    );
  }
}
