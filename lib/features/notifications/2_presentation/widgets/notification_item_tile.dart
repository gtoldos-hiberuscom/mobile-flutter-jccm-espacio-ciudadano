import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_item.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_status_chip.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Single notification row in the inbox listing (STORY-41).
class NotificationItemTile extends StatelessWidget {
  const NotificationItemTile({required this.item, required this.onTap, super.key});

  final NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dateLabel = _formatDate(item.fechaEmision);

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
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.asunto,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  NotificationStatusChip(status: item.status),
                ],
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                item.organismoEmisor,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.space4),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.event_outlined,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: AppDimensions.space4),
                  Text(
                    dateLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (item.hasDocuments) ...<Widget>[
                    const SizedBox(width: AppDimensions.space12),
                    Icon(
                      Icons.attach_file_outlined,
                      size: AppDimensions.iconSmall,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: AppDimensions.space4),
                    Text(
                      l10n.notificationsItemHasDocuments,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(final DateTime when) {
    final dd = when.day.toString().padLeft(2, '0');
    final mm = when.month.toString().padLeft(2, '0');
    return '$dd/$mm/${when.year}';
  }
}
