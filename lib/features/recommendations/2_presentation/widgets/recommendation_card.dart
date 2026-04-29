import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Card-style summary of a single [Recommendation].
///
/// Renders title (heading semantics), summary, responsible-unit chip,
/// deadline chip, life-event chip and the *Tramitación inmediata*
/// badge. Tap behaviour:
/// - if [Recommendation.detailUri] is non-null → launch external app.
/// - otherwise → SnackBar fallback ("Detalle disponible próximamente").
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    required this.recommendation,
    super.key,
    this.urlLauncher,
  });

  final Recommendation recommendation;

  /// Test seam — overrides the platform `launchUrl`.
  final Future<bool> Function(Uri uri)? urlLauncher;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: InkWell(
        onTap: () => _onTap(context, l10n),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  recommendation.title,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              if (recommendation.summary != null) ...[
                const SizedBox(height: AppDimensions.space8),
                Text(
                  recommendation.summary!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: AppDimensions.space12),
              Wrap(
                spacing: AppDimensions.space8,
                runSpacing: AppDimensions.space8,
                children: [
                  if (recommendation.isImmediateProcessing)
                    _Badge(
                      label: l10n.recommendationsImmediateBadge,
                      color: theme.colorScheme.tertiaryContainer,
                      foreground: theme.colorScheme.onTertiaryContainer,
                    ),
                  if (recommendation.responsibleUnit != null)
                    _Chip(
                      label:
                          '${l10n.recommendationsResponsibleUnitPrefix} ${recommendation.responsibleUnit!}',
                      icon: Icons.account_balance_outlined,
                    ),
                  if (recommendation.deadlineLabel != null)
                    _Chip(
                      label:
                          '${l10n.recommendationsDeadlinePrefix} ${recommendation.deadlineLabel!}',
                      icon: Icons.schedule_outlined,
                    ),
                  if (recommendation.lifeEventLabel != null)
                    _Chip(
                      label:
                          '${l10n.recommendationsLifeEventPrefix} ${recommendation.lifeEventLabel!}',
                      icon: Icons.label_outline,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTap(
    final BuildContext context,
    final AppLocalizations l10n,
  ) async {
    final uri = recommendation.detailUri;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (uri == null) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.recommendationsDetailUnavailable)),
      );
      return;
    }
    final launcher = urlLauncher ??
        (final Uri u) => launchUrl(u, mode: LaunchMode.externalApplication);
    final ok = await launcher(uri);
    if (!ok) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.recommendationsDetailUnavailable)),
      );
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(final BuildContext context) => Chip(
    avatar: Icon(icon, size: AppDimensions.iconSmall),
    label: Text(label),
    visualDensity: VisualDensity.compact,
  );
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.foreground,
  });

  final String label;
  final Color color;
  final Color foreground;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space4,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
