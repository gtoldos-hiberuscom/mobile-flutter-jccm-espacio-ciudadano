import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'casework_workspace_notifier.g.dart';

/// Owns the "Mis gestiones" workspace state (STORY-34). Loads the three
/// tabs in parallel so each section surfaces its own loading / empty /
/// error state independently.
@riverpod
class CaseworkWorkspaceNotifier extends _$CaseworkWorkspaceNotifier {
  @override
  Future<CaseworkSnapshot> build() async {
    final repo = ref.watch(caseworkRepositoryProvider);
    return _loadAll(repo, selectedTab: CaseworkTab.expedientes);
  }

  /// Switches the active tab without re-fetching data.
  void selectTab(final CaseworkTab tab) {
    final current = state.value;
    if (current == null || current.selectedTab == tab) {
      return;
    }
    state = AsyncValue<CaseworkSnapshot>.data(
      current.copyWith(selectedTab: tab),
    );
  }

  /// Reloads every tab and resets the snapshot.
  Future<void> refresh() async {
    final selected = state.value?.selectedTab ?? CaseworkTab.expedientes;
    state = const AsyncValue<CaseworkSnapshot>.loading();
    state = await AsyncValue.guard<CaseworkSnapshot>(
      () => _loadAll(
        ref.read(caseworkRepositoryProvider),
        selectedTab: selected,
      ),
    );
  }

  /// Reloads a single tab. Other tabs keep their previous state.
  Future<void> refreshTab(final CaseworkTab tab) async {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue<CaseworkSnapshot>.data(
      _replaceSection(current, tab, CaseworkSection.loading()),
    );
    final repo = ref.read(caseworkRepositoryProvider);
    CaseworkSection next;
    try {
      final items = await repo.loadByTab(tab);
      next = CaseworkSection.loaded(items);
    } on Object {
      next = CaseworkSection.error();
    }
    final latest = state.value;
    if (latest == null) {
      return;
    }
    state = AsyncValue<CaseworkSnapshot>.data(
      _replaceSection(latest, tab, next),
    );
  }

  static Future<CaseworkSnapshot> _loadAll(
    final CaseworkRepository repo, {
    required final CaseworkTab selectedTab,
  }) async {
    final results = await Future.wait<CaseworkSection>(
      CaseworkTab.values.map(
        (final tab) async {
          try {
            final items = await repo.loadByTab(tab);
            return CaseworkSection.loaded(items);
          } on Object {
            return CaseworkSection.error();
          }
        },
      ),
    );
    return CaseworkSnapshot(
      selectedTab: selectedTab,
      expedientes: results[CaseworkTab.expedientes.index],
      entradasRegistro: results[CaseworkTab.entradasRegistro.index],
      salidasRegistro: results[CaseworkTab.salidasRegistro.index],
    );
  }

  static CaseworkSnapshot _replaceSection(
    final CaseworkSnapshot snap,
    final CaseworkTab tab,
    final CaseworkSection section,
  ) {
    switch (tab) {
      case CaseworkTab.expedientes:
        return snap.copyWith(expedientes: section);
      case CaseworkTab.entradasRegistro:
        return snap.copyWith(entradasRegistro: section);
      case CaseworkTab.salidasRegistro:
        return snap.copyWith(salidasRegistro: section);
    }
  }
}
