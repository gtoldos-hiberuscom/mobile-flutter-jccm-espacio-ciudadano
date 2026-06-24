import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataAuthorizationRequiredMessage extends StatelessWidget {
  const MyDataAuthorizationRequiredMessage({
    required this.onOpenAuthorizations,
    super.key,
  });

  final VoidCallback onOpenAuthorizations;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ColoredBox(
      color: AppColors.backgroundBlueLighter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.space16,
          AppDimensions.space24,
          AppDimensions.space24,
          AppDimensions.space24,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppIcon(
              AppIcons.info,
              color: AppColors.primary,
              size: AppDimensions.iconLarge,
            ),
            const SizedBox(width: AppDimensions.space16),
            Expanded(
              child: Text(
                l10n.myDataJccmAuthorizationRequiredMessage,
                style: AppTypography.leadingMedium.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(width: AppDimensions.space16),
            Semantics(
              button: true,
              label: l10n.myDataJccmAuthorizationRequiredCta,
              child: ExcludeSemantics(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    boxShadow: AppShadows.low,
                  ),
                  child: InkWell(
                    onTap: onOpenAuthorizations,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    child: const SizedBox(
                      width: AppDimensions.space64,
                      height: AppDimensions.space64,
                      child: Center(
                        child: AppIcon(
                          AppIcons.settings,
                          color: AppColors.textPrimary,
                          size: AppDimensions.iconLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
