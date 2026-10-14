import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';

/// Interactive navigation card with title, short description and arrow.
///
/// Set [isDisabled] to true to render the card in the disabled visual state
/// (grey background, no shadow, muted text) without interaction.
///
/// [descriptionIcon] precedes the description at 16 dp (e.g. the lock of a
/// destination that asks to verify identity first).
class AppNavigationCard extends StatelessWidget {
  const AppNavigationCard({
    required this.title,
    required this.onTap,
    super.key,
    this.description,
    this.descriptionIcon,
    this.semanticLabel,
    this.isDisabled = false,
  }) : assert(title != '', 'title must not be empty'),
       assert(description == null || description != '', 'description must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  final String title;
  final String? description;
  final IconData? descriptionIcon;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool isDisabled;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);
    final textColor = isDisabled ? AppColors.textDisabled : AppColors.primary;

    return Semantics(
      container: true,
      button: true,
      label: semanticLabel ?? (description != null ? '$title. $description' : title),
      enabled: !isDisabled,
      onTap: isDisabled ? null : onTap,
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
            child: AppFocusRing(
              borderRadius: borderRadius,
              enabled: !isDisabled,
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
                                  style: AppTypography.leadingMedium.copyWith(color: textColor),
                                ),
                                if (description != null) ...[
                                  const SizedBox(height: AppDimensions.space4),
                                  if (descriptionIcon case final icon?)
                                    Row(
                                      children: [
                                        AppIcon(icon, color: textColor, size: AppDimensions.iconSmall),
                                        const SizedBox(width: AppDimensions.space4),
                                        Expanded(
                                          child: Text(
                                            description!,
                                            style: AppTypography.smallRegular.copyWith(color: textColor),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      description!,
                                      style: AppTypography.smallRegular.copyWith(color: textColor),
                                    ),
                                ],
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
      ),
    );
  }
}
