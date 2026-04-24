import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/cip_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Home dashboard "Salud" entry point (STORY-31).
///
/// Per the TASK-71 surface decision (CIP_REUSE), the same read-only
/// [CipCard] used by the agenda screen is mounted here in its compact
/// variant alongside a "Ver agenda" CTA — this is the single,
/// non-wallet entry point to salud from the home dashboard.
///
/// Coordinated with the agenda upcoming-events summary so the home
/// preview matches the agenda full screen (STORY-31, AC2 / AC3).
class SaludSurfaceCard extends ConsumerWidget {
  const SaludSurfaceCard({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space24,
            ),
            child: Text(
              l10n.saludSurfaceTitle,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const CipCard(compact: true),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                key: const ValueKey('salud-surface-cta'),
                onPressed: () => context.go(Routes.agenda),
                icon: const Icon(Icons.event_outlined),
                label: Text(l10n.saludSurfaceCta),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
