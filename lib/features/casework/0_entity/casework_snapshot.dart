import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';

/// Per-tab load outcome — each tab is rendered independently so a failure
/// on one feed does not blank the whole workspace.
enum CaseworkSectionStatus { loading, loaded, empty, error }

final class CaseworkSection {
  const CaseworkSection({required this.status, this.items = const []});

  factory CaseworkSection.loading() => const CaseworkSection(status: CaseworkSectionStatus.loading);

  factory CaseworkSection.loaded(final List<CaseworkItem> items) => CaseworkSection(
    status: items.isEmpty ? CaseworkSectionStatus.empty : CaseworkSectionStatus.loaded,
    items: items,
  );

  factory CaseworkSection.empty() => const CaseworkSection(status: CaseworkSectionStatus.empty);

  factory CaseworkSection.error() => const CaseworkSection(status: CaseworkSectionStatus.error);

  final CaseworkSectionStatus status;
  final List<CaseworkItem> items;
}

/// Aggregated payload for the "Mis gestiones" workspace (STORY-34).
///
/// Holds one [CaseworkSection] per [CaseworkTab] plus the currently
/// selected tab. The notifier rebuilds this snapshot on tab switch /
/// refresh.
final class CaseworkSnapshot {
  const CaseworkSnapshot({
    required this.selectedTab,
    required this.expedientes,
    required this.entradasRegistro,
    required this.salidasRegistro,
  });

  final CaseworkTab selectedTab;
  final CaseworkSection expedientes;
  final CaseworkSection entradasRegistro;
  final CaseworkSection salidasRegistro;

  CaseworkSection sectionFor(final CaseworkTab tab) {
    switch (tab) {
      case CaseworkTab.expedientes:
        return expedientes;
      case CaseworkTab.entradasRegistro:
        return entradasRegistro;
      case CaseworkTab.salidasRegistro:
        return salidasRegistro;
    }
  }

  CaseworkSnapshot copyWith({
    final CaseworkTab? selectedTab,
    final CaseworkSection? expedientes,
    final CaseworkSection? entradasRegistro,
    final CaseworkSection? salidasRegistro,
  }) => CaseworkSnapshot(
    selectedTab: selectedTab ?? this.selectedTab,
    expedientes: expedientes ?? this.expedientes,
    entradasRegistro: entradasRegistro ?? this.entradasRegistro,
    salidasRegistro: salidasRegistro ?? this.salidasRegistro,
  );
}
