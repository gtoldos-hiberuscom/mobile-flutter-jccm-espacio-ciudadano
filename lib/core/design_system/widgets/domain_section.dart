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
  });

  final String title;
  final String? subtitle;
  final String? infoTooltip;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (infoTooltip != null) ...[
                Tooltip(
                  message: infoTooltip,
                  child: Icon(
                    Icons.info_outline,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.outline,
                    semanticLabel: infoTooltip,
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: AppDimensions.space8),
                trailing!,
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
