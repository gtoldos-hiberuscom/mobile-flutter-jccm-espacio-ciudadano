import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_empty_variant.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders the *Mis Recomendaciones* empty / onboarding state for the
/// resolved [RecommendationsEmptyVariant] (STORY-57 §D5).
///
/// Each variant uses the same [_EmptyScaffold] for layout and
/// accessibility (the title is announced as a heading) but exposes a
/// distinct copy + CTA pair:
///
/// - [RecommendationsEmptyVariant.unconfigured]:
///   primary  CTA → `Routes.preferencesConsent`
///   secondary CTA → SnackBar fallback for "Mis hechos vitales"
///                   (the dedicated route does not exist yet — see
///                   `// TODO(future-sprint)` below).
/// - [RecommendationsEmptyVariant.unauthorised]:
///   primary  CTA → `Routes.preferencesConsent`.
/// - [RecommendationsEmptyVariant.configuredButEmpty]:
///   secondary CTA → invokes [onSeeAll] so the page can switch back to
///                   the "Todos" tab (no-op when already on Todos).
class RecommendationsEmptyView extends StatelessWidget {
  const RecommendationsEmptyView({
    required this.variant,
    this.onSeeAll,
    super.key,
  });

  final RecommendationsEmptyVariant variant;

  /// Invoked by the "Ver todos" secondary CTA on the
  /// [RecommendationsEmptyVariant.configuredButEmpty] branch. Optional —
  /// when null, the secondary CTA is hidden (e.g. when already on the
  /// Todos tab).
  final VoidCallback? onSeeAll;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (variant) {
      case RecommendationsEmptyVariant.unconfigured:
        return _EmptyScaffold(
          icon: Icons.explore_outlined,
          title: l10n.recommendationsEmptyUnconfiguredTitle,
          body: l10n.recommendationsEmptyUnconfiguredBody,
          primaryLabel: l10n.recommendationsEmptyUnconfiguredPrimaryCta,
          onPrimary: () => context.go(Routes.preferencesConsent),
          secondaryLabel: l10n.recommendationsEmptyUnconfiguredSecondaryCta,
          // TODO(future-sprint): replace this SnackBar with
          //                      `context.go(Routes.lifeEvents)` once the
          //                      "Mis hechos vitales" surface ships.
          onSecondary: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(l10n.recommendationsLifeEventsComingSoon),
                ),
              );
          },
        );
      case RecommendationsEmptyVariant.unauthorised:
        return _EmptyScaffold(
          icon: Icons.lock_outline,
          title: l10n.recommendationsEmptyUnauthorisedTitle,
          body: l10n.recommendationsEmptyUnauthorisedBody,
          primaryLabel: l10n.recommendationsEmptyUnauthorisedPrimaryCta,
          onPrimary: () => context.go(Routes.preferencesConsent),
        );
      case RecommendationsEmptyVariant.configuredButEmpty:
        return _EmptyScaffold(
          icon: Icons.check_circle_outline,
          title: l10n.recommendationsEmptyConfiguredTitle,
          body: l10n.recommendationsEmptyConfiguredBody,
          secondaryLabel: onSeeAll == null ? null : l10n.recommendationsEmptyConfiguredSecondaryCta,
          onSecondary: onSeeAll,
        );
    }
  }
}

/// Shared visual scaffolding for the three empty variants — keeps
/// vertical rhythm, accessibility semantics and CTA layout consistent.
class _EmptyScaffold extends StatelessWidget {
  const _EmptyScaffold({
    required this.icon,
    required this.title,
    required this.body,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              size: 72,
              color: theme.colorScheme.primary,
              semanticLabel: '',
            ),
            const SizedBox(height: AppDimensions.space24),
            Semantics(
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (primaryLabel != null && onPrimary != null) ...[
              const SizedBox(height: AppDimensions.space24),
              FilledButton(
                onPressed: onPrimary,
                child: Text(primaryLabel!),
              ),
            ],
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: AppDimensions.space8),
              TextButton(
                onPressed: onSecondary,
                child: Text(secondaryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
