import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart' show AppButton;
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart' show AppButton;

/// A centred empty-state placeholder with an icon, message and optional action.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.message, super.key,
    this.subtitle,
    this.action,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final String? subtitle;

  /// Optional action widget (e.g. an [AppButton]).
  final Widget? action;

  /// Leading icon — defaults to [Icons.inbox_outlined].
  final IconData icon;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(icon, size: 48, color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
