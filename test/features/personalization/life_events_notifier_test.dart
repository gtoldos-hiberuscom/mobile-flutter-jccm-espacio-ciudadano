import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_events_selection.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_provider.dart';

class _FakeLifeEventsRepository implements LifeEventsRepository {
  _FakeLifeEventsRepository({
    required this.items,
    required this.initialSelection,
    this.failOnSave = false,
  }) : _selected = Set<String>.from(initialSelection);

  final List<LifeEvent> items;
  final Set<String> initialSelection;
  final bool failOnSave;
  Set<String> _selected;
  int saveCalls = 0;
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
    saveCalls += 1;
    if (failOnSave) {
      throw StateError('boom');
    }
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
    label: 'Nacimiento',
    category: LifeEventCategory.familia,
  ),
  LifeEvent(
    id: 'emp-desempleo',
    label: 'Desempleo',
    category: LifeEventCategory.empleo,
  ),
  LifeEvent(
    id: 'sal-discapacidad',
    label: 'Discapacidad',
    category: LifeEventCategory.salud,
  ),
];

ProviderContainer _container(final _FakeLifeEventsRepository repo) =>
    ProviderContainer(
      overrides: [
        lifeEventsRepositoryProvider.overrideWith((final _) => repo),
      ],
    );

void main() {
  group('LifeEventsNotifier', () {
    test('initial build seeds catalog and baseline selection', () async {
      final repo = _FakeLifeEventsRepository(
        items: _catalog,
        initialSelection: <String>{'fam-nacimiento'},
      );
      final c = _container(repo);
      addTearDown(c.dispose);

      final state = await c.read(lifeEventsProvider('agent-1').future);

      expect(state.state, LifeEventsLoadState.loaded);
      expect(state.items.length, 3);
      expect(state.selectedIds, <String>{'fam-nacimiento'});
      expect(state.baselineIds, <String>{'fam-nacimiento'});
      expect(state.isDirty, isFalse);
    });

    test('toggle adds/removes ids and marks the snapshot dirty', () async {
      final repo = _FakeLifeEventsRepository(
        items: _catalog,
        initialSelection: <String>{'fam-nacimiento'},
      );
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(lifeEventsProvider('agent-1').future);
      final notifier = c.read(lifeEventsProvider('agent-1').notifier)
        ..toggle('emp-desempleo');

      var current = c.read(lifeEventsProvider('agent-1')).requireValue;
      expect(current.selectedIds,
          <String>{'fam-nacimiento', 'emp-desempleo'});
      expect(current.isDirty, isTrue);

      notifier.toggle('fam-nacimiento');
      current = c.read(lifeEventsProvider('agent-1')).requireValue;
      expect(current.selectedIds, <String>{'emp-desempleo'});
      expect(current.isDirty, isTrue);
    });

    test('save persists selection, refreshes baseline and emits saved → loaded',
        () async {
      final repo = _FakeLifeEventsRepository(
        items: _catalog,
        initialSelection: <String>{'fam-nacimiento'},
      );
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(lifeEventsProvider('agent-1').future);
      final notifier = c.read(lifeEventsProvider('agent-1').notifier)
        ..toggle('sal-discapacidad');
      await notifier.save();

      var current = c.read(lifeEventsProvider('agent-1')).requireValue;
      expect(current.state, LifeEventsLoadState.saved);
      expect(repo.saveCalls, 1);
      expect(current.baselineIds,
          <String>{'fam-nacimiento', 'sal-discapacidad'});
      expect(current.isDirty, isFalse);

      notifier.acknowledgeSaved();
      current = c.read(lifeEventsProvider('agent-1')).requireValue;
      expect(current.state, LifeEventsLoadState.loaded);
    });

    test('save surfaces an error snapshot on repository failure', () async {
      final repo = _FakeLifeEventsRepository(
        items: _catalog,
        initialSelection: <String>{'fam-nacimiento'},
        failOnSave: true,
      );
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(lifeEventsProvider('agent-1').future);
      c.read(lifeEventsProvider('agent-1').notifier).toggle('emp-desempleo');
      await c.read(lifeEventsProvider('agent-1').notifier).save();

      final current = c.read(lifeEventsProvider('agent-1')).requireValue;
      expect(current.state, LifeEventsLoadState.error);
      expect(current.errorMessage, isNotNull);
      // Baseline must NOT advance on a failed save.
      expect(current.baselineIds, <String>{'fam-nacimiento'});
    });

    test('resetPreferencias clears selection and baseline', () async {
      final repo = _FakeLifeEventsRepository(
        items: _catalog,
        initialSelection: <String>{'fam-nacimiento', 'emp-desempleo'},
      );
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(lifeEventsProvider('agent-1').future);
      await c.read(lifeEventsProvider('agent-1').notifier).resetPreferencias();

      final current = c.read(lifeEventsProvider('agent-1')).requireValue;
      expect(repo.resetCalls, 1);
      expect(current.selectedIds, isEmpty);
      expect(current.baselineIds, isEmpty);
      expect(current.state, LifeEventsLoadState.saved);
      expect(current.isDirty, isFalse);
    });

    test('groupByCategory preserves order and skips empty categories', () {
      final grouped = LifeEventsNotifier.groupByCategory(_catalog);
      expect(
        grouped.keys.toList(),
        <LifeEventCategory>[
          LifeEventCategory.familia,
          LifeEventCategory.salud,
          LifeEventCategory.empleo,
        ],
      );
      expect(grouped[LifeEventCategory.familia]!.length, 1);
      expect(grouped.containsKey(LifeEventCategory.vivienda), isFalse);
    });
  });
}
