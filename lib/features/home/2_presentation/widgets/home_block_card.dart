import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_widget_summary.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Reusable card that renders a single home dashboard block.
///
/// Each block is independent: a failure in one card never prevents the
/// other cards from being rendered (canon §16). Shows the per-block
/// `lastUpdatedAt` so the user can judge data freshness on every visit.
///
/// Visual states:
/// - [HomeBlockLoadState.loaded] — title, optional headline / count, tap navigates.
/// - [HomeBlockLoadState.empty]  — [EmptyStateWidget] inside the card body.
/// - [HomeBlockLoadState.error]  — [ErrorStateWidget] with a retry callback.
class HomeBlockCard extends StatelessWidget {
  const HomeBlockCard({
    required this.title,
    required this.summary,
    required this.icon,
    required this.onTap,
    required this.onRetry,
    super.key,
  });

  /// Localised, user-facing title of the block.
  final String title;

  /// Block payload — drives which sub-widget renders.
  final HomeWidgetSummary summary;

  /// Leading icon for the card header.
  final IconData icon;

  /// Invoked when the user taps the card and the block is loaded.
  ///
  /// Empty cards are still tappable (the user may want to land on the
  /// section anyway); error cards expose [onRetry] instead.
  final VoidCallback onTap;

  /// Invoked from the per-block error state to retry loading.
  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isError = summary.loadState == HomeBlockLoadState.error;

    final lastUpdatedLabel = _formatLastUpdated(context, summary.lastUpdatedAt);

    return Semantics(
      container: true,
      button: !isError,
      label: title,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        elevation: AppDimensions.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isError ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: AppDimensions.iconMedium,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (!isError)
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.outline,
                        size: AppDimensions.iconMedium,
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space12),
                _buildBody(context, l10n),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  lastUpdatedLabel,
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(final BuildContext context, final AppLocalizations l10n) {
    final theme = Theme.of(context);
    switch (summary.loadState) {
      case HomeBlockLoadState.loaded:
        final headline = summary.headline;
        final count = summary.count;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (headline != null && headline.isNotEmpty)
              Text(
                headline,
                style: theme.textTheme.bodyMedium,
              ),
            if (count != null) ...[
              if (headline != null && headline.isNotEmpty) const SizedBox(height: AppDimensions.space4),
              Text(
                l10n.homeBlockCount(count),
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        );
      case HomeBlockLoadState.empty:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
          child: EmptyStateWidget(
            message: l10n.homeBlockEmpty,
          ),
        );
      case HomeBlockLoadState.error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
          child: ErrorStateWidget(
            message: l10n.homeBlockError,
            onRetry: onRetry,
          ),
        );
    }
  }

  String _formatLastUpdated(
    final BuildContext context,
    final DateTime? value,
  ) {
    final l10n = AppLocalizations.of(context);
    if (value == null) {
      return l10n.homeBlockLastUpdatedUnknown;
    }
    String two(final int n) => n.toString().padLeft(2, '0');
    final formatted = '${two(value.hour)}:${two(value.minute)}';
    return l10n.homeBlockLastUpdated(formatted);
  }
}
