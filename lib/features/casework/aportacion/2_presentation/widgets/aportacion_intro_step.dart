import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Step 1 of the third-party aportación wizard (STORY-37).
///
/// Static introductory copy + a list of restrictions + the "Continuar"
/// CTA that advances to the identification step.
class AportacionIntroStep extends ConsumerWidget {
  const AportacionIntroStep({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final restrictions = <String>[
      l10n.caseworkAportacionIntroRestriction1,
      l10n.caseworkAportacionIntroRestriction2,
      l10n.caseworkAportacionIntroRestriction3,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.caseworkAportacionIntroHeadline,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.space12),
          Text(
            l10n.caseworkAportacionIntroBody,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(
            l10n.caseworkAportacionIntroRestrictionsTitle,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppDimensions.space8),
          for (final entry in restrictions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.space8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.check_circle_outline, size: 18),
                  const SizedBox(width: AppDimensions.space8),
                  Expanded(
                    child: Text(
                      entry,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppDimensions.space24),
          FilledButton(
            onPressed: () => ref
                .read(aportacionSessionProvider.notifier)
                .confirmIntro(),
            child: Text(l10n.caseworkAportacionIntroContinueCta),
          ),
        ],
      ),
    );
  }
}
