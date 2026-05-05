import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';

/// Card widget that displays a single service category from "Qué encontrarás".
///
/// Fully accessible: icon has a [semanticLabel] and the card respects the
/// minimum touch target size. Stateless — all data flows in via [item].
class LandingFeatureCard extends StatelessWidget {
  const LandingFeatureCard({required this.item, super.key});

  /// The feature item to render.
  final LandingFeatureItem item;

  @override
  Widget build(final BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: '${item.title}: ${item.description}',
      child: Card(
        elevation: AppDimensions.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
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
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.space4),
              Text(
                item.description,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
