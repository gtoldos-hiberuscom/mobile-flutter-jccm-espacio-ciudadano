import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Placeholder casework item detail page (STORY-39).
///
/// Real detail screen and aportación documental experience are owned by
/// STORY-35 / STORY-36 / STORY-37 / STORY-38. This page exists only so the
/// search results can navigate somewhere reviewable.
class CaseworkItemDetailPlaceholderPage extends StatelessWidget {
  const CaseworkItemDetailPlaceholderPage({required this.itemId, super.key});

  final String itemId;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.caseworkItemDetailPlaceholderTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              l10n.caseworkItemDetailPlaceholderBody(itemId),
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              // TODO(STORY-35): replace with real detail screen owned
              // by STORY-35 / STORY-36.
              l10n.caseworkItemDetailPlaceholderPending,
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
