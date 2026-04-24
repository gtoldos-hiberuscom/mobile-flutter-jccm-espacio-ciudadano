import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent_state.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/data_consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/data_consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/data_consent_repository_provider.dart';

class _FakeDataConsentRepository implements DataConsentRepository {
  _FakeDataConsentRepository({
    required this.items,
    this.failOnSave = false,
  }) : _state = <String, bool>{
          for (final c in items) c.id: c.accepted,
        };

  final List<DataConsent> items;
  final bool failOnSave;
  Map<String, bool> _state;
  int saveCalls = 0;
  int revokeCalls = 0;
  Map<DataConsentType, bool>? lastSaved;

  @override
  Future<DataConsentLoadResult> loadClausulas(
    final String idAgente,
  ) async =>
      DataConsentLoadResult(
        items: <DataConsent>[
          for (final c in items)
            DataConsent(
              id: c.id,
              type: c.type,
              accepted: _state[c.id] ?? false,
              version: c.version,
              lastUpdatedAt: c.lastUpdatedAt,
            ),
        ],
      );

  @override
  Future<void> saveClausulas(
    final String idAgente,
    final Map<DataConsentType, bool> acceptance,
  ) async {
    saveCalls += 1;
    if (failOnSave) {
      throw StateError('boom');
    }
    lastSaved = Map<DataConsentType, bool>.from(acceptance);
    _state = <String, bool>{
      for (final c in items) c.id: acceptance[c.type] ?? false,
    };
  }

  @override
  Future<void> revokeAll(final String idAgente) async {
    revokeCalls += 1;
    _state = <String, bool>{
      for (final c in items) c.id: false,
    };
  }
}

const _catalog = <DataConsent>[
  DataConsent(
    id: 'consent-jccm',
    type: DataConsentType.jccm,
    accepted: true,
  ),
  DataConsent(
    id: 'consent-otras-admin',
    type: DataConsentType.otrasAdmin,
    accepted: false,
  ),
  DataConsent(
    id: 'consent-perfilado',
    type: DataConsentType.perfilado,
    accepted: false,
  ),
];

ProviderContainer _container(final _FakeDataConsentRepository repo) =>
    ProviderContainer(
      overrides: [
        dataConsentRepositoryProvider.overrideWith((final _) => repo),
      ],
    );

void main() {
  group('DataConsentNotifier', () {
    test('initial build seeds catalog and baseline acceptance', () async {
      final repo = _FakeDataConsentRepository(items: _catalog);
      final c = _container(repo);
      addTearDown(c.dispose);

      final snapshot = await c.read(dataConsentProvider('agent-1').future);

      expect(snapshot.state, DataConsentLoadState.loaded);
      expect(snapshot.items.length, 3);
      expect(snapshot.draft['consent-jccm'], isTrue);
      expect(snapshot.draft['consent-otras-admin'], isFalse);
      expect(snapshot.baseline['consent-jccm'], isTrue);
      expect(snapshot.isDirty, isFalse);
    });

    test('toggle flips a single consent and marks the snapshot dirty',
        () async {
      final repo = _FakeDataConsentRepository(items: _catalog);
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(dataConsentProvider('agent-1').future);
      final notifier = c.read(dataConsentProvider('agent-1').notifier)
        ..toggle('consent-otras-admin');

      var current = c.read(dataConsentProvider('agent-1')).requireValue;
      expect(current.draft['consent-otras-admin'], isTrue);
      expect(current.isDirty, isTrue);

      // Unknown ids are no-ops (defensive — real ids come from the catalog).
      notifier.toggle('does-not-exist');
      current = c.read(dataConsentProvider('agent-1')).requireValue;
      expect(current.draft.containsKey('does-not-exist'), isFalse);
    });

    test('save persists draft, refreshes baseline and emits saved → loaded',
        () async {
      final repo = _FakeDataConsentRepository(items: _catalog);
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(dataConsentProvider('agent-1').future);
      final notifier = c.read(dataConsentProvider('agent-1').notifier)
        ..toggle('consent-perfilado');
      await notifier.save();

      var current = c.read(dataConsentProvider('agent-1')).requireValue;
      expect(current.state, DataConsentLoadState.saved);
      expect(repo.saveCalls, 1);
      expect(
        repo.lastSaved,
        <DataConsentType, bool>{
          DataConsentType.jccm: true,
          DataConsentType.otrasAdmin: false,
          DataConsentType.perfilado: true,
        },
      );
      expect(current.baseline['consent-perfilado'], isTrue);
      expect(current.isDirty, isFalse);

      notifier.acknowledgeSaved();
      current = c.read(dataConsentProvider('agent-1')).requireValue;
      expect(current.state, DataConsentLoadState.loaded);
    });

    test('save surfaces an error snapshot on repository failure', () async {
      final repo = _FakeDataConsentRepository(
        items: _catalog,
        failOnSave: true,
      );
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(dataConsentProvider('agent-1').future);
      c
          .read(dataConsentProvider('agent-1').notifier)
          .toggle('consent-otras-admin');
      await c.read(dataConsentProvider('agent-1').notifier).save();

      final current = c.read(dataConsentProvider('agent-1')).requireValue;
      expect(current.state, DataConsentLoadState.error);
      expect(current.errorMessage, isNotNull);
      // Baseline must NOT advance on a failed save.
      expect(current.baseline['consent-jccm'], isTrue);
      expect(current.baseline['consent-otras-admin'], isFalse);
    });

    test('revokeAll clears every consent in draft and baseline', () async {
      final repo = _FakeDataConsentRepository(items: _catalog);
      final c = _container(repo);
      addTearDown(c.dispose);

      await c.read(dataConsentProvider('agent-1').future);
      await c.read(dataConsentProvider('agent-1').notifier).revokeAll();

      final current = c.read(dataConsentProvider('agent-1')).requireValue;
      expect(repo.revokeCalls, 1);
      expect(current.draft.values.every((final v) => v == false), isTrue);
      expect(
        current.baseline.values.every((final v) => v == false),
        isTrue,
      );
      expect(current.state, DataConsentLoadState.saved);
      expect(current.isDirty, isFalse);
    });
  });
}
