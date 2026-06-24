import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Interactive navigation card with title, short description and arrow.
///
/// Set [isDisabled] to true to render the card in the disabled visual state
/// (grey background, no shadow, muted text) without interaction.
class AppNavigationCard extends StatelessWidget {
  const AppNavigationCard({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
    this.semanticLabel,
    this.isDisabled = false,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool isDisabled;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);
    final textColor = isDisabled ? AppColors.textDisabled : AppColors.primary;

    return Semantics(
      button: !isDisabled,
      label: semanticLabel ?? '$title. $description',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isDisabled ? AppColors.background : AppColors.backgroundWhite,
            border: Border.all(color: isDisabled ? AppColors.borderNeutralLight : AppColors.borderBlueMutedLight),
            borderRadius: borderRadius,
            boxShadow: isDisabled ? [] : AppShadows.medium,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onTap,
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
                                style: AppTypography.leadingMedium.copyWith(color: textColor),
                              ),
                              const SizedBox(height: AppDimensions.space4),
                              Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.smallRegular.copyWith(color: textColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      AppIcon(
                        AppIcons.arrowForward,
                        color: isDisabled ? AppColors.disabled : AppColors.textPrimary,
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
