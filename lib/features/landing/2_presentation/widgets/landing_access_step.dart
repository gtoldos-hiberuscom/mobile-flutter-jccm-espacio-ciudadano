import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';

/// Numbered step row used in the "Cómo acceder" section.
///
/// Displays a circular step number badge, a title, and a description.
/// Accessible: the full step content is exposed as a single semantic unit.
class LandingAccessStepWidget extends StatelessWidget {
  const LandingAccessStepWidget({required this.step, super.key});

  /// The access step data to render.
  final LandingAccessStep step;

  @override
  Widget build(final BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Paso ${step.stepNumber}: ${step.title}. ${step.description}',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Step number badge ────────────────────────────────────────────
          ExcludeSemantics(
            child: Container(
              width: AppDimensions.minTouchTarget,
              height: AppDimensions.minTouchTarget,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${step.stepNumber}',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          // ── Step content ─────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppDimensions.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    step.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
