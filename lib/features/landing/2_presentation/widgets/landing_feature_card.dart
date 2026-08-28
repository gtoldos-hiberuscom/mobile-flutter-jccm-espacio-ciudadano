import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';

/// Card widget that displays a single service category from "Qué encontrarás".
///
/// Fully accessible: icon has a semantic label and the card respects the
/// minimum touch target size. Stateless — all data flows in via [item].
class LandingFeatureCard extends StatelessWidget {
  const LandingFeatureCard({
    required this.item,
    super.key,
    this.headingLevel = 3,
    this.titleSemanticLabel,
  }) : assert(headingLevel >= 1 && headingLevel <= 6, 'headingLevel must be between 1 and 6'),
       assert(
         titleSemanticLabel == null || titleSemanticLabel != '',
         'titleSemanticLabel must not be empty',
       );

  /// The feature item to render.
  final LandingFeatureItem item;

  /// Semantic heading level for the feature title.
  final int headingLevel;

  /// Optional spoken form of the title when it contains abbreviations.
  final String? titleSemanticLabel;

  @override
  Widget build(final BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              _resolveIcon(item.icon),
              size: AppDimensions.iconLarge,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Semantics(
            container: true,
            excludeSemantics: titleSemanticLabel != null,
            header: true,
            headingLevel: headingLevel,
            label: titleSemanticLabel,
            child: Text(
              item.title,
              style: AppTypography.bodyBold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: AppDimensions.space4),
          Text(
            item.description,
            style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Resolves a semantic icon name from the entity layer to a [IconData].
  IconData _resolveIcon(final String iconName) {
    return switch (iconName) {
      'notifications' => Icons.notifications_outlined,
      'health' => Icons.local_hospital_outlined,
      'work' => Icons.work_outline,
      'assignment' => Icons.assignment_outlined,
      'badge' => Icons.badge_outlined,
      'map' => Icons.map_outlined,
      _ => Icons.info_outline,
    };
  }
}
