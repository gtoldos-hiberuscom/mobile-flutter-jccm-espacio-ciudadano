import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_modal_layout.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentAuthorizationDialog extends StatelessWidget {
  const MyDataEmploymentAuthorizationDialog({
    required this.onOpenAuthorizations,
    super.key,
  });

  final VoidCallback onOpenAuthorizations;

  static Future<void> show(
    final BuildContext context, {
    required final VoidCallback onOpenAuthorizations,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final context) => MyDataEmploymentAuthorizationDialog(
        onOpenAuthorizations: onOpenAuthorizations,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.space8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlueMutedLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                ),
                child: const AppIcon(
                  AppIcons.info,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.myDataEmploymentAuthorizationDialogTitle,
              textAlign: TextAlign.center,
              style: AppTypography.h3.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.myDataEmploymentAuthorizationDialogBody,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.space16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOpenAuthorizations();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textBlack,
                padding: const EdgeInsets.all(AppDimensions.space8),
                minimumSize: const Size(AppDimensions.minTouchTarget, AppDimensions.minTouchTarget),
              ),
              child: Text(
                l10n.myDataEmploymentAuthorizationDialogAuthorizationsCta,
                textAlign: TextAlign.center,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.textBlack,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.myDataEmploymentAuthorizationDialogBack,
              onPressed: () => Navigator.of(context).pop(),
              hierarchy: AppButtonHierarchy.tertiary,
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}
