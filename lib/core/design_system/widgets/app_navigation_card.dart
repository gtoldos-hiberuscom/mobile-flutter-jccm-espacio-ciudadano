import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Interactive navigation card with title, short description and arrow.
class AppNavigationCard extends StatelessWidget {
  const AppNavigationCard({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
    this.semanticLabel,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);

    return Semantics(
      button: true,
      label: semanticLabel ?? '$title. $description',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border.all(color: AppColors.borderBlueMutedLight),
            borderRadius: borderRadius,
            boxShadow: AppShadows.medium,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
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
                                style: AppTypography.leadingMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space4),
                              Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.smallRegular.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      const AppIcon(
                        AppIcons.arrowForward,
                        color: AppColors.textPrimary,
                        size: AppDimensions.iconLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
