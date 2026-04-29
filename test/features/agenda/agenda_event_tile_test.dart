import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/agenda_event_tile.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Wraps [child] with the minimum scaffolding needed to render an
/// agenda widget under test (Material, Riverpod, ARB delegate).
Widget _wrap(final Widget child) => ProviderScope(
  child: MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

void main() {
  group('AgendaEventTile (STORY-30)', () {
    final event = AgendaEvent(
      id: 'evt-1',
      rawTitle: 'Análisis de sangre',
      description: 'Acuda en ayunas con la tarjeta sanitaria.',
      startsAt: DateTime(2026, 5, 4, 9, 30),
      category: AgendaCategory.salud,
      source: AgendaEventSource.ssalud,
      centro: 'Centro de Salud Talavera Centro',
      profesional: 'Equipo de extracciones',
      tipo: 'Análisis clínico',
    );

    testWidgets('expand toggle reveals inline detail and collapses again', (final tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          AgendaEventTile(
            event: event,
            subtitle: 'subtitle',
            onTap: () => taps++,
          ),
        ),
      );

      // Inline detail is hidden by default.
      expect(find.byKey(const ValueKey('agenda-tile-inline-detail')), findsNothing);
      expect(find.textContaining('Análisis clínico'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('agenda-tile-expand')));
      await tester.pumpAndSettle();

      // Inline detail is now visible with the new STORY-30 fields.
      expect(find.byKey(const ValueKey('agenda-tile-inline-detail')), findsOneWidget);
      expect(find.textContaining('Análisis clínico'), findsOneWidget);
      expect(find.textContaining('Centro de Salud Talavera Centro'), findsOneWidget);
      expect(find.textContaining('Equipo de extracciones'), findsOneWidget);

      // Expanding does not navigate — the title onTap is the only route trigger.
      expect(taps, 0);

      await tester.tap(find.byKey(const ValueKey('agenda-tile-expand')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('agenda-tile-inline-detail')), findsNothing);
    });

    testWidgets('event without detail fields renders chevron, no toggle', (final tester) async {
      final bareEvent = AgendaEvent(
        id: 'evt-bare',
        rawTitle: 'Recordatorio',
        startsAt: DateTime(2026, 5, 4, 9, 30),
        category: AgendaCategory.otros,
        source: AgendaEventSource.manual,
      );
      await tester.pumpWidget(
        _wrap(
          AgendaEventTile(
            event: bareEvent,
            subtitle: 'subtitle',
            onTap: () {},
          ),
        ),
      );

      expect(find.byKey(const ValueKey('agenda-tile-expand')), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });
  });
}
