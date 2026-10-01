import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';

/// Interactive navigation card with a leading icon tile.
///
/// Used for hub/list screens where each row represents a destination category.
class AppIconNavigationCard extends StatelessWidget {
  const AppIconNavigationCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    super.key,
    this.semanticLabel,
  }) : assert(title != '', 'title must not be empty'),
       assert(description != '', 'description must not be empty'),
       assert(
         semanticLabel == null || semanticLabel != '',
         'semanticLabel must not be empty',
       );

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);

    return Semantics(
      button: true,
      label: semanticLabel ?? '$title. $description',
      onTap: onTap,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.borderBlueMutedLight),
            borderRadius: borderRadius,
            boxShadow: AppShadows.medium,
          ),
          child: Material(
            color: Colors.transparent,
            child: AppFocusRing(
              borderRadius: borderRadius,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadius,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.space8,
                    AppDimensions.space8,
                    AppDimensions.space16,
                    AppDimensions.space8,
                  ),
                  child: Row(
                    children: [
                      _AppNavigationIconTile(icon: icon),
                      const SizedBox(width: AppDimensions.space16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: AppTypography.leadingMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space4),
                              Text(
                                description,
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

class _AppNavigationIconTile extends StatelessWidget {
  const _AppNavigationIconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: AppDimensions.space64,
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: AppColors.backgroundBlueLighter,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      alignment: Alignment.center,
      child: AppIcon(
        icon,
        color: AppColors.textPrimary,
      ),
    );
  }
}
