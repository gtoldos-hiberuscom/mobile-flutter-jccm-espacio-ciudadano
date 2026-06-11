import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';

/// Card widget that displays a single service category from "Qué encontrarás".
///
/// Fully accessible: icon has a semantic label and the card respects the
/// minimum touch target size. Stateless — all data flows in via [item].
class LandingFeatureCard extends StatelessWidget {
  const LandingFeatureCard({required this.item, super.key});

  /// The feature item to render.
  final LandingFeatureItem item;

  @override
  Widget build(final BuildContext context) {
    return AppSurfaceCard(
      semanticLabel: '${item.title}: ${item.description}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _resolveIcon(item.icon),
            size: AppDimensions.iconLarge,
            color: AppColors.primary,
            semanticLabel: item.title,
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            item.title,
            style: AppTypography.bodyBold.copyWith(color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.space4),
          Text(
            item.description,
            style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
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
