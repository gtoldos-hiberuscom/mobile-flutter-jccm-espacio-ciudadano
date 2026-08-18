import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart' show AppDimensions;

/// Reusable section block for the thematic dashboard landings
/// (STORY-23/24/25/26).
///
/// Renders a localized title, an optional subtitle, an optional info
/// tooltip (used by the controlled-placeholder cards) and an arbitrary
/// body. Padding and typography come from [AppDimensions] / [Theme] so
/// the design system stays the single source of truth for spacing.
class DomainSection extends StatelessWidget {
  const DomainSection({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
    this.infoTooltip,
    this.trailing,
  }) : assert(title != '', 'title must not be empty'),
       assert(subtitle == null || subtitle != '', 'subtitle must not be empty'),
       assert(infoTooltip == null || infoTooltip != '', 'infoTooltip must not be empty');

  final String title;
  final String? subtitle;
  final String? infoTooltip;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final tooltipKey = GlobalKey<TooltipState>();
    final hasHeaderActions = infoTooltip != null || trailing != null;
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final heading = Semantics(
      header: true,
      headingLevel: 2,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    final headerActions = <Widget>[
      if (infoTooltip != null)
        Semantics(
          container: true,
          excludeSemantics: true,
          button: true,
          label: infoTooltip,
          onTap: () => tooltipKey.currentState?.ensureTooltipVisible(),
          child: Tooltip(
            key: tooltipKey,
            message: infoTooltip,
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
        ),
      ?trailing,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (usesLargeText && hasHeaderActions)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                heading,
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppDimensions.space8,
                  runSpacing: AppDimensions.space4,
                  children: headerActions,
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(child: heading),
                if (hasHeaderActions) ...[
                  const SizedBox(width: AppDimensions.space8),
                  ...headerActions,
                ],
              ],
            ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimensions.space4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.space12),
          child,
        ],
      ),
    );
  }
}
