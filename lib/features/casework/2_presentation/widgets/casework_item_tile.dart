import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders a single [CaseworkItem] as a tappable card.
///
/// Visual-only widget — does not own state or navigation logic. The
/// parent page passes [onTap] when an item gains a destination
/// (deferred to a later story; for STORY-34 we keep it null).
class CaseworkItemTile extends StatelessWidget {
  const CaseworkItemTile({required this.item, super.key, this.onTap});

  final CaseworkItem item;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dateLabel = _formatDate(item.date);
    final statusLabel = _statusLabel(l10n, item.status);
    final statusColor = _statusColor(theme, item.status);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space4,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.number,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space8,
                      vertical: AppDimensions.space4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                    ),
                    child: Text(
                      statusLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                item.subject,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                item.organism,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.space4),
              Text(
                l10n.caseworkItemDateLabel(dateLabel),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(final DateTime d) {
    final yyyy = d.year.toString().padLeft(4, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy';
  }

  static String _statusLabel(
    final AppLocalizations l10n,
    final CaseworkItemStatus status,
  ) {
    switch (status) {
      case CaseworkItemStatus.enTramite:
        return l10n.caseworkStatusEnTramite;
      case CaseworkItemStatus.finalizado:
        return l10n.caseworkStatusFinalizado;
      case CaseworkItemStatus.pendiente:
        return l10n.caseworkStatusPendiente;
      case CaseworkItemStatus.rechazado:
        return l10n.caseworkStatusRechazado;
    }
  }

  static Color _statusColor(
    final ThemeData theme,
    final CaseworkItemStatus status,
  ) {
    switch (status) {
      case CaseworkItemStatus.enTramite:
        return theme.colorScheme.primary;
      case CaseworkItemStatus.finalizado:
        return theme.colorScheme.tertiary;
      case CaseworkItemStatus.pendiente:
        return theme.colorScheme.secondary;
      case CaseworkItemStatus.rechazado:
        return theme.colorScheme.error;
    }
  }
}
