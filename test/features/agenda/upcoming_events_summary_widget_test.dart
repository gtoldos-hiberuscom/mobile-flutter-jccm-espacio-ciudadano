import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/upcoming_events_summary.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

AgendaEvent _event(final String id, final DateTime when) => AgendaEvent(
  id: id,
  rawTitle: 'event-$id',
  startsAt: when,
  category: AgendaCategory.salud,
  source: AgendaEventSource.manual,
);

void main() {
  testWidgets('UpcomingEventsSummary renders the top-3 upcoming events in '
      'ascending startsAt order', (final tester) async {
    final now = DateTime(2026, 5, 4, 10);
    final snapshot = AgendaSnapshot(
      events: <AgendaEvent>[
        _event('past', now.subtract(const Duration(days: 1))),
        _event('plus20', now.add(const Duration(days: 20))),
        _event('plus3', now.add(const Duration(days: 3))),
        _event('plus1', now.add(const Duration(days: 1))),
        _event('plus10', now.add(const Duration(days: 10))),
      ],
      lastUpdatedAt: now,
      loadState: AgendaLoadState.loaded,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: UpcomingEventsSummary(snapshot: snapshot, now: now),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('upcoming-events-summary')),
      findsOneWidget,
    );
    // The three nearest upcoming events must be rendered in order.
    expect(
      find.byKey(const ValueKey('upcoming-events-summary-plus1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('upcoming-events-summary-plus3')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('upcoming-events-summary-plus10')),
      findsOneWidget,
    );
    // Past and the 4th-furthest entry must NOT be rendered.
    expect(
      find.byKey(const ValueKey('upcoming-events-summary-past')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('upcoming-events-summary-plus20')),
      findsNothing,
    );
  });
}
