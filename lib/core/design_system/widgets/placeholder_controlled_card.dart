import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';

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
    this.titleSemanticLabel,
  }) : assert(title != '', 'title must not be empty'),
       assert(tooltip != '', 'tooltip must not be empty'),
       assert(badge != '', 'badge must not be empty'),
       assert(description != '', 'description must not be empty'),
       assert(
         titleSemanticLabel == null || titleSemanticLabel != '',
         'titleSemanticLabel must not be empty',
       );

  final String title;
  final String tooltip;
  final String badge;
  final String description;

  /// Optional spoken form of [title] when it contains abbreviations.
  final String? titleSemanticLabel;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final tooltipKey = GlobalKey<TooltipState>();
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final heading = Semantics(
      header: true,
      headingLevel: 3,
      label: titleSemanticLabel,
      excludeSemantics: titleSemanticLabel != null,
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    final infoButton = Semantics(
      container: true,
      excludeSemantics: true,
      button: true,
      label: tooltip,
      onTap: () => tooltipKey.currentState?.ensureTooltipVisible(),
      child: Tooltip(
        key: tooltipKey,
        message: tooltip,
        excludeFromSemantics: true,
        triggerMode: TooltipTriggerMode.manual,
        child: IconButton(
          onPressed: () => tooltipKey.currentState?.ensureTooltipVisible(),
          icon: Icon(
            Icons.info_outline,
            size: AppDimensions.iconSmall,
            color: theme.colorScheme.outline,
          ),
        ),
      ),
    );
    return Card(
      semanticContainer: false,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (usesLargeText)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  heading,
                  Align(alignment: AlignmentDirectional.centerEnd, child: infoButton),
                ],
              )
            else
              Row(
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: AppDimensions.space8),
                  infoButton,
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
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
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
