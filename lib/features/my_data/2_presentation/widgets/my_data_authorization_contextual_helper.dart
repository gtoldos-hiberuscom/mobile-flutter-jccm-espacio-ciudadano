import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Contextual helper widget that prompts users to authorize data access.
///
/// Figma node: 42544:27272 (Alerts/ ContextualHelper)
///
/// Displays an info message with a settings button that navigates to preferences.
class MyDataAuthorizationContextualHelper extends StatelessWidget {
  const MyDataAuthorizationContextualHelper({
    required this.onOpenSettings,
    super.key,
    this.message,
    this.semanticsLabel,
  });

  final VoidCallback onOpenSettings;
  final String? message;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space4,
        vertical: AppDimensions.space8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text block with icon and message
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.space4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info icon
                  const AppIcon(
                    AppIcons.info,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  // Message text
                  Expanded(
                    child: Text(
                      message ?? l10n.myDataJccmAuthorizationRequiredMessage,
                      style: AppTypography.smallRegular.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          // Settings button
          AppIconButton(
            icon: AppIcons.settings,
            onPressed: onOpenSettings,
            semanticsLabel: semanticsLabel ?? l10n.myDataJccmAuthorizationRequiredCta,
            hierarchy: AppButtonHierarchy.secondary,
          ),
        ],
      ),
    );
  }
}
