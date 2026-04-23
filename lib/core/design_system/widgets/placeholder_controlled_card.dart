import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';

/// Controlled "Próximamente" card for dashboard surfaces whose backend
/// is not yet exposed (TASK-27 PLACEHOLDER_CONTROLLED decision).
///
/// Renders a localized title, an info icon with an explanatory tooltip
/// and the localized "Próximamente" badge — never a fake state, never a
/// hard-coded boolean. When the backend appears, the card is swapped
/// for the real bound widget without changing the layout.
class PlaceholderControlledCard extends StatelessWidget {
  const PlaceholderControlledCard({
    required this.title,
    required this.tooltip,
    required this.badge,
    required this.description,
    super.key,
  });

  final String title;
  final String tooltip;
  final String badge;
  final String description;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Tooltip(
                  message: tooltip,
                  child: Icon(
                    Icons.info_outline,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.outline,
                    semanticLabel: tooltip,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space8,
                vertical: AppDimensions.space4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Text(
                badge,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(description, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
