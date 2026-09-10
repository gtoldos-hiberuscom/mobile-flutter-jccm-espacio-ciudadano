import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_modal_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Blocking confirmation shown before content opens outside the application.
///
/// Figma: `Alerts/Dialog` node `44641:25380`.
class AppExternalNavigationDialog extends StatelessWidget {
  const AppExternalNavigationDialog({
    required this.onCancel,
    required this.onContinue,
    super.key,
  });

  final VoidCallback onCancel;
  final VoidCallback onContinue;

  static Future<bool> show(final BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      requestFocus: true,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final dialogContext) => AppExternalNavigationDialog(
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onContinue: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n.externalNavigationDialogTitle;
    final useVerticalActions = MediaQuery.textScalerOf(context).scale(1) > 1.5;

    final cancelButton = AppButton(
      label: l10n.externalNavigationDialogCancel,
      hierarchy: AppButtonHierarchy.tertiary,
      onPressed: onCancel,
      isExpanded: true,
    );
    final continueButton = AppButton(
      label: l10n.externalNavigationDialogContinue,
      onPressed: onContinue,
      isExpanded: true,
    );

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Dialog(
          constraints: appModalDialogConstraints(context),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space64,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space32,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              border: Border.all(color: AppColors.borderBlueMutedLight),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: AppShadows.overAll,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.space8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundBlueMutedLight,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusRound,
                          ),
                        ),
                        child: const AppIcon(
                          AppIcons.openInNew,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Semantics(
                    header: true,
                    headingLevel: 1,
                    sortKey: const OrdinalSortKey(1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.space4,
                        bottom: AppDimensions.space8,
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTypography.h3.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  Semantics(
                    sortKey: const OrdinalSortKey(2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.space4,
                      ),
                      child: Text(
                        l10n.externalNavigationDialogBody,
                        style: AppTypography.bodyRegular.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Semantics(
                    sortKey: const OrdinalSortKey(3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space16,
                      ),
                      child: useVerticalActions
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                cancelButton,
                                const SizedBox(height: AppDimensions.space8),
                                continueButton,
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: cancelButton),
                                const SizedBox(width: AppDimensions.space16),
                                Expanded(child: continueButton),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
