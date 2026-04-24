import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/app/localization/localization.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_provider.dart';

class _FakeLifeEventsRepository implements LifeEventsRepository {
  _FakeLifeEventsRepository({
    required this.items,
    required this.initialSelection,
  }) : _selected = Set<String>.from(initialSelection);

  final List<LifeEvent> items;
  final Set<String> initialSelection;
  Set<String> _selected;
  int resetCalls = 0;

  @override
  Future<LifeEventsLoadResult> loadHechos(final String idAgente) async =>
      LifeEventsLoadResult(
        items: items,
        selectedIds: Set<String>.unmodifiable(_selected),
      );

  @override
  Future<void> saveHechos(
    final String idAgente,
    final Set<String> selectedIds,
  ) async {
    _selected = Set<String>.from(selectedIds);
  }

  @override
  Future<void> resetPreferencias(final String idAgente) async {
    resetCalls += 1;
    _selected = <String>{};
  }
}

const _catalog = <LifeEvent>[
  LifeEvent(
    id: 'fam-nacimiento',
    label: 'Nacimiento de un hijo',
    category: LifeEventCategory.familia,
  ),
  LifeEvent(
    id: 'emp-desempleo',
    label: 'Situación de desempleo',
    category: LifeEventCategory.empleo,
  ),
];

Widget _harness(final _FakeLifeEventsRepository repo) {
  return ProviderScope(
    overrides: [
      lifeEventsRepositoryProvider.overrideWith((final _) => repo),
    ],
    child: const MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalization.delegates,
      supportedLocales: AppLocalization.supportedLocales,
      home: LifeEventsPage(idAgente: 'agent-1'),
    ),
  );
}

void main() {
  testWidgets('renders the catalog grouped by category and reflects selection',
      (final tester) async {
    final repo = _FakeLifeEventsRepository(
      items: _catalog,
      initialSelection: <String>{'fam-nacimiento'},
    );

    await tester.pumpWidget(_harness(repo));
    await tester.pumpAndSettle();

    expect(find.text('Mis hechos vitales'), findsOneWidget);
    expect(find.text('Familia'), findsOneWidget);
    expect(find.text('Empleo'), findsOneWidget);
    expect(find.text('Nacimiento de un hijo'), findsOneWidget);
    expect(find.text('Situación de desempleo'), findsOneWidget);

    // Save action is disabled when selection matches the persisted baseline.
    final saveButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Guardar'),
    );
    expect(saveButton.onPressed, isNull);

    // The pre-selected hecho vital is visually selected.
    final preSelected = tester.widget<CheckboxListTile>(
      find.byKey(const ValueKey<String>('life-event-tile-fam-nacimiento')),
    );
    expect(preSelected.value, isTrue);

    final unselected = tester.widget<CheckboxListTile>(
      find.byKey(const ValueKey<String>('life-event-tile-emp-desempleo')),
    );
    expect(unselected.value, isFalse);
  });

  testWidgets('reset action requires explicit confirmation before clearing',
      (final tester) async {
    final repo = _FakeLifeEventsRepository(
      items: _catalog,
      initialSelection: <String>{'fam-nacimiento'},
    );

    await tester.pumpWidget(_harness(repo));
    await tester.pumpAndSettle();

    // Cancel path — repository must NOT be called.
    await tester.tap(
      find.byKey(const ValueKey<String>('life-events-reset-button')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Borrar tus preferencias'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
    await tester.pumpAndSettle();
    expect(repo.resetCalls, 0);

    // Confirm path — repository.resetPreferencias is invoked once.
    await tester.tap(
      find.byKey(const ValueKey<String>('life-events-reset-button')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Borrar'));
    await tester.pumpAndSettle();
    expect(repo.resetCalls, 1);
  });
}
