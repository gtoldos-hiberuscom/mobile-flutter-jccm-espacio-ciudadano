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
    this.messageSemanticLabel,
  }) : assert(message == null || message != '', 'message must not be empty'),
       assert(semanticsLabel == null || semanticsLabel != '', 'semanticsLabel must not be empty'),
       assert(
         messageSemanticLabel == null || messageSemanticLabel != '',
         'messageSemanticLabel must not be empty',
       );

  final VoidCallback onOpenSettings;
  final String? message;
  final String? semanticsLabel;
  final String? messageSemanticLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final effectiveMessage = message ?? l10n.myDataJccmAuthorizationRequiredMessage;
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final messageBlock = Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExcludeSemantics(
            child: AppIcon(
              AppIcons.info,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Semantics(
              container: true,
              excludeSemantics: messageSemanticLabel != null,
              label: messageSemanticLabel,
              child: Text(
                effectiveMessage,
                style: AppTypography.smallRegular.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    final settingsButton = AppIconButton(
      icon: AppIcons.settings,
      onPressed: onOpenSettings,
      semanticsLabel: semanticsLabel ?? l10n.myDataJccmAuthorizationRequiredCta,
      hierarchy: AppButtonHierarchy.secondary,
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space4,
          vertical: AppDimensions.space8,
        ),
        child: usesLargeText
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  messageBlock,
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: settingsButton,
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: messageBlock),
                  const SizedBox(width: AppDimensions.space8),
                  settingsButton,
                ],
              ),
      ),
    );
  }
}
