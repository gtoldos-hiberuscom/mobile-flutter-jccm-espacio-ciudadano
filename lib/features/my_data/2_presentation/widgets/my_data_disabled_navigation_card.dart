import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

class MyDataDisabledNavigationCard extends StatelessWidget {
  const MyDataDisabledNavigationCard({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);

    return Semantics(
      enabled: false,
      label: '$title. $description',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            border: Border.all(color: AppColors.borderBlueMutedLight),
            borderRadius: borderRadius,
            boxShadow: AppShadows.medium,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space24,
                AppDimensions.space8,
                AppDimensions.space16,
                AppDimensions.space8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.leadingMedium.copyWith(color: AppColors.textDisabled),
                          ),
                          const SizedBox(height: AppDimensions.space4),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.smallRegular.copyWith(color: AppColors.textDisabled),
                          ),
                        ],
                      ),
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
