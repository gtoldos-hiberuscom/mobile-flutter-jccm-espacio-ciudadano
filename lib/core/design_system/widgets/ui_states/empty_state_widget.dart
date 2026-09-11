import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart' show AppButton;
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A centred empty-state placeholder with an icon, message and optional action.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.message,
    super.key,
    this.subtitle,
    this.action,
    this.icon = Icons.inbox_outlined,
    this.semanticsLabel,
    this.announce = true,
  }) : assert(message.length > 0, 'message must not be empty'),
       assert(subtitle == null || subtitle.length > 0, 'subtitle must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String message;
  final String? subtitle;

  /// Optional action widget (e.g. an [AppButton]).
  final Widget? action;

  /// Leading icon — defaults to [Icons.inbox_outlined].
  final IconData icon;

  final String? semanticsLabel;

  /// Whether a dynamically inserted empty state should be announced.
  final bool announce;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final stateLabel =
        semanticsLabel ??
        [
          AppLocalizations.of(context).a11yEmptyState(message),
          if (subtitle != null) subtitle,
        ].join('. ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  container: true,
                  label: stateLabel,
                  liveRegion: announce,
                  child: const SizedBox(width: 1, height: 1),
                ),
                ExcludeSemantics(
                  child: Icon(
                    icon,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  header: true,
                  headingLevel: 2,
                  child: Text(
                    message,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  ExcludeSemantics(
                    child: Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: 24),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
