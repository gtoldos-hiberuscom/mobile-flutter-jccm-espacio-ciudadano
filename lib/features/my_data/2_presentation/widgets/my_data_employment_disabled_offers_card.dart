import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentDisabledOffersCard extends StatelessWidget {
  const MyDataEmploymentDisabledOffersCard({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);

    return Semantics(
      enabled: false,
      label: '${l10n.myDataEmploymentOffersTitle}. ${l10n.myDataEmploymentOffersDescription}',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            border: Border.all(color: AppColors.borderNeutralLight),
            borderRadius: borderRadius,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space8,
                AppDimensions.space8,
                AppDimensions.space16,
                AppDimensions.space8,
              ),
              child: Row(
                children: [
                  Container(
                    width: AppDimensions.space64,
                    height: AppDimensions.space64,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    child: const Center(
                      child: AppIcon(
                        AppIcons.corporateFare,
                        color: AppColors.textDisabled,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.myDataEmploymentOffersTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.leadingMedium.copyWith(color: AppColors.textDisabled),
                        ),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          l10n.myDataEmploymentOffersDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.smallRegular.copyWith(color: AppColors.textDisabled),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  const AppIcon(
                    AppIcons.arrowForward,
                    color: AppColors.textDisabled,
                    size: AppDimensions.iconLarge,
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
