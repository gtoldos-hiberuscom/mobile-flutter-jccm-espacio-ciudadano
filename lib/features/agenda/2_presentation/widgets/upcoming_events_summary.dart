import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/extensions/date_time_format.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Compact list of the next [maxItems] upcoming agenda events, ordered
/// ascending by `startsAt` (STORY-31, AC2).
///
/// Reused both in the agenda page header (so the resumen sits at the
/// top of the full surface) and inside the home `upcomingEvents` block
/// (so the home preview matches the agenda list 1-to-1).
///
/// Pure presentation: takes a fully-loaded [AgendaSnapshot] and a
/// reference `now` so the same widget can be exercised by deterministic
/// widget tests.
class UpcomingEventsSummary extends StatelessWidget {
  const UpcomingEventsSummary({
    required this.snapshot,
    required this.now,
    this.maxItems = 3,
    this.onEventTap,
    super.key,
  });

  final AgendaSnapshot snapshot;
  final DateTime now;
  final int maxItems;

  /// Optional tap handler; when null the rows are non-interactive.
  final ValueChanged<AgendaEvent>? onEventTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final upcoming = snapshot.events
        .where((final e) => !e.startsAt.isBefore(now))
        .toList(growable: false)
      ..sort((final a, final b) => a.startsAt.compareTo(b.startsAt));
    final visible = upcoming.take(maxItems).toList(growable: false);

    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        child: Text(
          l10n.homeUpcomingEventsEmpty,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      key: const ValueKey('upcoming-events-summary'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          child: Text(
            l10n.homeUpcomingEventsTitle,
            style: theme.textTheme.titleSmall,
          ),
        ),
        for (final event in visible)
          ListTile(
            key: ValueKey('upcoming-events-summary-${event.id}'),
            dense: true,
            leading: const Icon(Icons.event_outlined),
            title: Text(event.rawTitle ?? event.titleKey ?? event.id),
            subtitle: Text(event.startsAt.formatDdMmYyyyHhMm()),
            onTap: onEventTap == null ? null : () => onEventTap!(event),
          ),
      ],
    );
  }
}
