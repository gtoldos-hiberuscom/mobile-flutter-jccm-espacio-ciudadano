import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_status_chip.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Horizontal status filter bar for the notifications center (STORY-41).
///
/// The "Todas" chip clears every filter; status chips toggle individual
/// statuses in the active filter set.
class NotificationFilterBar extends StatelessWidget {
  const NotificationFilterBar({
    required this.activeFilters,
    required this.onChanged,
    super.key,
  });

  final Set<NotificationStatus> activeFilters;
  final ValueChanged<Set<NotificationStatus>> onChanged;

  static const List<NotificationStatus> _selectableStatuses = <NotificationStatus>[
    NotificationStatus.pendiente,
    NotificationStatus.aceptada,
    NotificationStatus.rechazada,
    NotificationStatus.caducada,
  ];

  void _toggle(final NotificationStatus status) {
    final next = <NotificationStatus>{...activeFilters};
    if (!next.add(status)) {
      next.remove(status);
    }
    onChanged(next);
  }

  void _clear() {
    if (activeFilters.isEmpty) {
      return;
    }
    onChanged(const <NotificationStatus>{});
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allActive = activeFilters.isEmpty;
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.space8),
            child: FilterChip(
              label: Text(l10n.notificationsFilterAll),
              selected: allActive,
              onSelected: (_) => _clear(),
            ),
          ),
          for (final status in _selectableStatuses)
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.space8),
              child: FilterChip(
                label: Text(NotificationStatusChip.labelFor(l10n, status)),
                selected: activeFilters.contains(status),
                onSelected: (_) => _toggle(status),
              ),
            ),
        ],
      ),
    );
  }
}
