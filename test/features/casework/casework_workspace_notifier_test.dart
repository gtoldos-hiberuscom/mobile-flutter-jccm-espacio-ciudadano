import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_workspace_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';

class _ConfigurableRepo implements CaseworkRepository {
  _ConfigurableRepo({this.empty, this.failing});
  final CaseworkTab? empty;
  final CaseworkTab? failing;

  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async {
    if (failing == tab) {
      throw StateError('boom');
    }
    if (empty == tab) {
      return const <CaseworkItem>[];
    }
    return <CaseworkItem>[
      CaseworkItem(
        id: '$tab-1',
        type: tab,
        number: 'N-1',
        date: DateTime(2025, 3, 4),
        organism: 'Org',
        subject: 'Subject',
        status: CaseworkItemStatus.enTramite,
      ),
    ];
  }

  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async =>
      const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(
    final String number,
  ) async =>
      const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(
    final String number,
  ) async =>
      const <CaseworkItem>[];
}

ProviderContainer _container(final CaseworkRepository repo) {
  final c = ProviderContainer(
    overrides: [
      caseworkRepositoryProvider.overrideWith((final ref) => repo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('CaseworkWorkspaceNotifier', () {
    test('initial build loads all three tabs as loaded', () async {
      final c = _container(_ConfigurableRepo());
      final snap = await c.read(caseworkWorkspaceProvider.future);
      expect(snap.selectedTab, CaseworkTab.expedientes);
      expect(snap.expedientes.status, CaseworkSectionStatus.loaded);
      expect(snap.entradasRegistro.status, CaseworkSectionStatus.loaded);
      expect(snap.salidasRegistro.status, CaseworkSectionStatus.loaded);
    });

    test('a failing tab surfaces an error section without breaking siblings',
        () async {
      final c = _container(
        _ConfigurableRepo(failing: CaseworkTab.entradasRegistro),
      );
      final snap = await c.read(caseworkWorkspaceProvider.future);
      expect(snap.expedientes.status, CaseworkSectionStatus.loaded);
      expect(snap.entradasRegistro.status, CaseworkSectionStatus.error);
      expect(snap.salidasRegistro.status, CaseworkSectionStatus.loaded);
    });

    test('an empty tab is reported as empty', () async {
      final c = _container(
        _ConfigurableRepo(empty: CaseworkTab.salidasRegistro),
      );
      final snap = await c.read(caseworkWorkspaceProvider.future);
      expect(snap.salidasRegistro.status, CaseworkSectionStatus.empty);
      expect(snap.salidasRegistro.items, isEmpty);
    });

    test('selectTab updates the snapshot without re-fetching', () async {
      final c = _container(_ConfigurableRepo());
      await c.read(caseworkWorkspaceProvider.future);
      c
          .read(caseworkWorkspaceProvider.notifier)
          .selectTab(CaseworkTab.salidasRegistro);
      final state = c.read(caseworkWorkspaceProvider).requireValue;
      expect(state.selectedTab, CaseworkTab.salidasRegistro);
    });

    test('refreshTab transitions error → loaded after retry', () async {
      var firstCall = true;
      final repo = _CallbackRepo((final tab) async {
        if (tab == CaseworkTab.expedientes && firstCall) {
          firstCall = false;
          throw StateError('first call fails');
        }
        return <CaseworkItem>[
          CaseworkItem(
            id: 'x',
            type: tab,
            number: 'N',
            date: DateTime(2025, 3, 4),
            organism: 'Org',
            subject: 'Subject',
            status: CaseworkItemStatus.finalizado,
          ),
        ];
      });
      final c = _container(repo);
      var snap = await c.read(caseworkWorkspaceProvider.future);
      expect(snap.expedientes.status, CaseworkSectionStatus.error);
      await c
          .read(caseworkWorkspaceProvider.notifier)
          .refreshTab(CaseworkTab.expedientes);
      snap = c.read(caseworkWorkspaceProvider).requireValue;
      expect(snap.expedientes.status, CaseworkSectionStatus.loaded);
      expect(snap.expedientes.items, hasLength(1));
    });
  });

  group('CaseworkRepositoryImpl mock', () {
    test('returns deterministic items per tab', () async {
      const repo = CaseworkRepositoryImpl();
      final exps = await repo.loadByTab(CaseworkTab.expedientes);
      final ents = await repo.loadByTab(CaseworkTab.entradasRegistro);
      final sals = await repo.loadByTab(CaseworkTab.salidasRegistro);
      expect(exps, isNotEmpty);
      expect(ents, isNotEmpty);
      expect(sals, isNotEmpty);
      expect(
        exps.every((final e) => e.type == CaseworkTab.expedientes),
        isTrue,
      );
    });

    test('forceErrorTab makes the tab throw', () async {
      const repo = CaseworkRepositoryImpl(
        forceErrorTab: CaseworkTab.expedientes,
      );
      await expectLater(
        repo.loadByTab(CaseworkTab.expedientes),
        throwsA(isA<StateError>()),
      );
    });
  });
}

class _CallbackRepo implements CaseworkRepository {
  _CallbackRepo(this._cb);
  final Future<List<CaseworkItem>> Function(CaseworkTab) _cb;
  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) => _cb(tab);

  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async =>
      const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(
    final String number,
  ) async =>
      const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(
    final String number,
  ) async =>
      const <CaseworkItem>[];
}
