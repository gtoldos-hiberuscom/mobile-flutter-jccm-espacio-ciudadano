import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_event_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/agenda_page.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _StubRepo implements AgendaRepository {
  _StubRepo(this._snapshot);
  final AgendaSnapshot _snapshot;
  @override
  Future<AgendaSnapshot> loadAgenda() async => _snapshot;
  @override
  Stream<AgendaSnapshot> watchAgenda() async* {
    yield _snapshot;
  }
}

GoRouter _router(final String initial) => GoRouter(
  initialLocation: initial,
  routes: [
    GoRoute(
      path: '/agenda',
      builder: (final BuildContext context, final GoRouterState _) => const AgendaPage(),
    ),
    GoRoute(
      path: '/agenda/:id',
      builder: (final BuildContext context, final GoRouterState state) => AgendaEventDetailPage(eventId: state.pathParameters['id']!),
    ),
  ],
);

Widget _app({
  required final AgendaSnapshot snapshot,
  required final String initial,
}) => ProviderScope(
  overrides: [
    agendaRepositoryProvider.overrideWith((final ref) => _StubRepo(snapshot)),
  ],
  child: MaterialApp.router(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: _router(initial),
  ),
);

void main() {
  group('Agenda STORY-30 surfaces', () {
    testWidgets('parse-error snapshot renders the recoverable error state '
        'with the "intentar de nuevo" CTA', (final tester) async {
      final snapshot = AgendaSnapshot(
        events: const <AgendaEvent>[],
        lastUpdatedAt: DateTime(2026, 5, 4),
        loadState: AgendaLoadState.parseError,
        parseErrorReason: 'unknown_shape',
      );
      await tester.pumpWidget(
        _app(snapshot: snapshot, initial: '/agenda'),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('agenda-parse-error')), findsOneWidget);
      // Localised CTA from app_es.arb -> agendaParseErrorRetry.
      expect(find.text('Intentar de nuevo'), findsOneWidget);
      // Raw reason must NEVER leak into the UI.
      expect(find.text('unknown_shape'), findsNothing);
    });

    testWidgets('partial snapshot renders the warning banner above the list', (final tester) async {
      final snapshot = AgendaSnapshot(
        events: <AgendaEvent>[
          AgendaEvent(
            id: 'evt',
            rawTitle: 'Análisis',
            startsAt: DateTime(2026, 5, 4, 9),
            category: AgendaCategory.salud,
            source: AgendaEventSource.ssalud,
          ),
        ],
        lastUpdatedAt: DateTime(2026, 5, 4),
        loadState: AgendaLoadState.partial,
        parseErrorReason: 'one_item_dropped',
      );
      await tester.pumpWidget(
        _app(snapshot: snapshot, initial: '/agenda'),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('agenda-partial-banner')),
        findsOneWidget,
      );
      expect(find.text('Análisis'), findsOneWidget);
    });

    testWidgets('justificante CTA is visible only when justificanteUrl is set '
        'and a tap surfaces the pending-allow-list snackbar', (final tester) async {
      final eventWithProof = AgendaEvent(
        id: 'with-proof',
        rawTitle: 'Cita con justificante',
        startsAt: DateTime(2026, 5, 4, 9),
        category: AgendaCategory.salud,
        source: AgendaEventSource.ssalud,
        justificanteUrl: 'https://example.org/proof.pdf',
      );
      final snapshot = AgendaSnapshot(
        events: <AgendaEvent>[eventWithProof],
        lastUpdatedAt: DateTime(2026, 5, 4),
        loadState: AgendaLoadState.loaded,
      );
      await tester.pumpWidget(
        _app(snapshot: snapshot, initial: '/agenda/with-proof'),
      );
      await tester.pumpAndSettle();

      final cta = find.byKey(const ValueKey('agenda-justificante-cta'));
      expect(cta, findsOneWidget);

      await tester.tap(cta);
      await tester.pump(); // surface the snackbar
      expect(
        find.text(
          'El justificante se podrá abrir cuando se habilite el enlace externo.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('detail page hides justificante CTA when URL is null', (final tester) async {
      final bare = AgendaEvent(
        id: 'no-proof',
        rawTitle: 'Cita sin justificante',
        startsAt: DateTime(2026, 5, 4, 9),
        category: AgendaCategory.salud,
        source: AgendaEventSource.ssalud,
      );
      final snapshot = AgendaSnapshot(
        events: <AgendaEvent>[bare],
        lastUpdatedAt: DateTime(2026, 5, 4),
        loadState: AgendaLoadState.loaded,
      );
      await tester.pumpWidget(
        _app(snapshot: snapshot, initial: '/agenda/no-proof'),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('agenda-justificante-cta')),
        findsNothing,
      );
    });
  });
}
