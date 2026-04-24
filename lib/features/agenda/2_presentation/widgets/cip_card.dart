import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/cip_summary.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/cip_summary_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Read-only mini-card that renders the citizen's CIP / tarjeta
/// sanitaria value (STORY-31).
///
/// Per the TASK-71 surface decision (CIP_REUSE), this widget is the
/// single rendering of the CIP across the app:
///  - mounted at the top of the agenda page header,
///  - and consumed by `salud_surface_card.dart` on the home dashboard.
///
/// **No PKPass / QR / PDF affordances** are exposed — copy-to-clipboard
/// is the only action available. The contract gap around health
/// capabilities visible in design but not yet confirmed is cited in
/// the contract-gap subtitle (TASK-27 / TASK-32).
///
/// Visual states map 1-to-1 to [CipLoadState]:
///  - `loading`     → skeleton row.
///  - `loaded`      → CIP code + holder + centre + read-only subtitle.
///  - `empty`       → tonal "sin tarjeta" message.
///  - `parseError`  → recoverable error surface with retry CTA.
///  - `error`       → recoverable error surface with retry CTA.
class CipCard extends ConsumerWidget {
  const CipCard({this.compact = false, super.key});

  /// When `true`, renders the dense home variant (no centre/region row).
  /// Used by `salud_surface_card.dart` on the home dashboard preview.
  final bool compact;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncCip = ref.watch(cipSummaryProvider);

    return asyncCip.when(
      loading: () => _CipCardShell(
        key: const ValueKey('cip-card-loading'),
        child: _SkeletonRow(),
      ),
      error: (final _, final stackTrace) => _CipCardShell(
        key: const ValueKey('cip-card-error'),
        child: ErrorStateWidget(
          message: l10n.cipCardError,
          onRetry: () => ref.read(cipSummaryProvider.notifier).refresh(),
        ),
      ),
      data: (final cip) => _buildForState(context, ref, cip, l10n, compact: compact),
    );
  }

  Widget _buildForState(
    final BuildContext context,
    final WidgetRef ref,
    final CipSummary cip,
    final AppLocalizations l10n, {
    required final bool compact,
  }) {
    switch (cip.loadState) {
      case CipLoadState.loading:
        return _CipCardShell(
          key: const ValueKey('cip-card-loading'),
          child: _SkeletonRow(),
        );
      case CipLoadState.empty:
        return _CipCardShell(
          key: const ValueKey('cip-card-empty'),
          child: Text(
            l10n.cipCardEmpty,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      case CipLoadState.parseError:
      case CipLoadState.error:
        return _CipCardShell(
          key: ValueKey('cip-card-${cip.loadState.name}'),
          child: ErrorStateWidget(
            message: cip.loadState == CipLoadState.parseError ? l10n.cipCardParseError : l10n.cipCardError,
            onRetry: () => ref.read(cipSummaryProvider.notifier).refresh(),
          ),
        );
      case CipLoadState.loaded:
        return _CipCardShell(
          key: const ValueKey('cip-card-loaded'),
          child: _LoadedBody(cip: cip, compact: compact),
        );
    }
  }
}

/// Outer chrome of the CIP card. Kept private so the loaded / loading /
/// error / empty bodies all share the same elevation and padding.
class _CipCardShell extends StatelessWidget {
  const _CipCardShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      elevation: AppDimensions.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: child,
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.cip, required this.compact});

  final CipSummary cip;
  final bool compact;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.health_and_safety_outlined,
              size: AppDimensions.iconMedium,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Text(
                l10n.cipCardTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space12),
        // CIP code + copy affordance.
        Row(
          children: [
            Expanded(
              child: SelectableText(
                cip.cipCode,
                key: const ValueKey('cip-card-code'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  letterSpacing: 1.2,
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.cipCardCopyTooltip,
              icon: const Icon(Icons.copy_outlined),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: cip.cipCode));
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.cipCardCopied)),
                );
              },
            ),
          ],
        ),
        if (cip.titular != null && cip.titular!.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.space4),
          Text(
            cip.titular!,
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (!compact && cip.centroSalud != null && cip.centroSalud!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.space4),
            child: Text(
              cip.centroSalud!,
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        if (!compact && cip.region != null && cip.region!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.space2),
            child: Text(
              cip.region!,
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        const SizedBox(height: AppDimensions.space8),
        // Read-only subtitle. The "no descargable" copy is mandated by
        // the TASK-71 decision — CIP is rendered only, never wallet-ised.
        Text(
          l10n.cipCardReadOnlySubtitle,
          key: const ValueKey('cip-card-readonly-subtitle'),
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.space4),
        // Contract gap subtitle (TASK-27 / TASK-32) — explicit gap for
        // health capabilities visible in design but not yet confirmed.
        Text(
          l10n.cipCardContractGap,
          style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    Widget bar(final double width) => Container(
      height: AppDimensions.space12,
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(160),
        const SizedBox(height: AppDimensions.space8),
        bar(220),
        const SizedBox(height: AppDimensions.space4),
        bar(180),
      ],
    );
  }
}
