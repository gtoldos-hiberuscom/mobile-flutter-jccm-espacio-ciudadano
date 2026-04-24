import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Step 5 of the aportación wizard — success acknowledgement after the
/// upload session has been finalized (STORY-37).
class AportacionCompleteStep extends ConsumerWidget {
  const AportacionCompleteStep({required this.expedienteRef, super.key});

  final String expedienteRef;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Icon(Icons.check_circle, size: 56, color: Colors.green),
          const SizedBox(height: AppDimensions.space16),
          Text(
            l10n.caseworkAportacionCompleteHeadline,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.caseworkAportacionCompleteBody(expedienteRef),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.space24),
          FilledButton(
            onPressed: () {
              ref.read(aportacionSessionProvider.notifier).start();
              GoRouter.of(context).go(Routes.casework);
            },
            child: Text(l10n.caseworkAportacionCompleteHomeCta),
          ),
        ],
      ),
    );
  }
}
