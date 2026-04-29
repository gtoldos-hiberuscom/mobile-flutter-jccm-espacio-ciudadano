import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Visual chip representing a [NotificationStatus] (STORY-41).
///
/// Pure presentation — colour is derived from the theme + the canonical
/// semantic palette so the indicator stays consistent with the rest of
/// the workspace surfaces.
class NotificationStatusChip extends StatelessWidget {
  const NotificationStatusChip({required this.status, super.key});

  final NotificationStatus status;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final color = _colorFor(theme, status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
      child: Text(
        labelFor(l10n, status),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Resolves the localised label for [status].
  static String labelFor(final AppLocalizations l10n, final NotificationStatus status) {
    switch (status) {
      case NotificationStatus.pendiente:
        return l10n.notificationStatusPendiente;
      case NotificationStatus.aceptada:
        return l10n.notificationStatusAceptada;
      case NotificationStatus.rechazada:
        return l10n.notificationStatusRechazada;
      case NotificationStatus.caducada:
        return l10n.notificationStatusCaducada;
      case NotificationStatus.unknown:
        return l10n.notificationStatusUnknown;
    }
  }

  Color _colorFor(final ThemeData theme, final NotificationStatus status) {
    switch (status) {
      case NotificationStatus.pendiente:
        return AppColors.warning;
      case NotificationStatus.aceptada:
        return AppColors.success;
      case NotificationStatus.rechazada:
        return AppColors.error;
      case NotificationStatus.caducada:
        return theme.colorScheme.outline;
      case NotificationStatus.unknown:
        return theme.colorScheme.outline;
    }
  }
}
