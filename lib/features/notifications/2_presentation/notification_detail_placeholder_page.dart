import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Placeholder notification detail screen (STORY-41).
///
/// Real detail (with accept/reject and document download) is owned by
/// STORY-43 / STORY-44. This page exists only so the inbox tile has a
/// reviewable destination.
class NotificationDetailPlaceholderPage extends StatelessWidget {
  const NotificationDetailPlaceholderPage({required this.notificationId, super.key});

  final String notificationId;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationDetailPlaceholderTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.notificationDetailPlaceholderBody(notificationId),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              // TODO(STORY-44): replace placeholder with real detail page.
              l10n.notificationDetailPlaceholderPending,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
