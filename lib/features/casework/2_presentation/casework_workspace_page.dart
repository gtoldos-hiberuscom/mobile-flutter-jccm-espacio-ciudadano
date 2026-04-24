import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_workspace_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/widgets/casework_breadcrumb.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/widgets/casework_item_tile.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// "Mis gestiones" workspace (STORY-34).
///
/// Renders three tabs (expedientes, entradas de registro, salidas de
/// registro) sharing the same shell. Each tab surfaces its own
/// loading / loaded / empty / error state via `core/ui_states/`.
///
/// STORY-39 will extend this scaffold with search.
class CaseworkWorkspacePage extends ConsumerStatefulWidget {
  const CaseworkWorkspacePage({super.key});

  @override
  ConsumerState<CaseworkWorkspacePage> createState() => _CaseworkWorkspacePageState();
}

class _CaseworkWorkspacePageState extends ConsumerState<CaseworkWorkspacePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: CaseworkTab.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncSnapshot = ref.watch(caseworkWorkspaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.caseworkWorkspaceTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.caseworkSearchOpenCta,
            onPressed: () => GoRouter.of(context).go('/casework/search'),
          ),
        ],
      ),
      body: asyncSnapshot.when(
        loading: () => LoadingStateWidget(message: l10n.loadingStateDefault),
        error: (final err, final st) => ErrorStateWidget(
          message: l10n.caseworkWorkspaceLoadError,
          onRetry: () => ref.read(caseworkWorkspaceProvider.notifier).refresh(),
        ),
        data: (final snap) => _buildLoaded(context, snap, l10n),
      ),
    );
  }

  Widget _buildLoaded(
    final BuildContext context,
    final CaseworkSnapshot snap,
    final AppLocalizations l10n,
  ) {
    // Keep the controller in sync if the notifier mutated the tab
    // outside the user gesture (e.g. refresh).
    final selectedIndex = snap.selectedTab.index;
    if (_tabController.index != selectedIndex) {
      _tabController.index = selectedIndex;
    }
    return Column(
      children: [
        CaseworkBreadcrumb(
          segments: <CaseworkBreadcrumbSegment>[
            CaseworkBreadcrumbSegment(label: l10n.caseworkBreadcrumbHome),
            CaseworkBreadcrumbSegment(label: l10n.caseworkWorkspaceTitle),
            CaseworkBreadcrumbSegment(
              label: _tabLabel(l10n, snap.selectedTab),
            ),
          ],
        ),
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            onTap: (final i) => ref.read(caseworkWorkspaceProvider.notifier).selectTab(CaseworkTab.values[i]),
            tabs: <Tab>[
              for (final tab in CaseworkTab.values) Tab(text: _tabLabel(l10n, tab)),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              for (final tab in CaseworkTab.values)
                _CaseworkTabView(
                  tab: tab,
                  section: snap.sectionFor(tab),
                  onRetry: () => ref.read(caseworkWorkspaceProvider.notifier).refreshTab(tab),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static String _tabLabel(final AppLocalizations l10n, final CaseworkTab tab) {
    switch (tab) {
      case CaseworkTab.expedientes:
        return l10n.caseworkTabExpedientes;
      case CaseworkTab.entradasRegistro:
        return l10n.caseworkTabEntradasRegistro;
      case CaseworkTab.salidasRegistro:
        return l10n.caseworkTabSalidasRegistro;
    }
  }
}

class _CaseworkTabView extends StatelessWidget {
  const _CaseworkTabView({
    required this.tab,
    required this.section,
    required this.onRetry,
  });

  final CaseworkTab tab;
  final CaseworkSection section;
  final Future<void> Function() onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case CaseworkSectionStatus.loading:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case CaseworkSectionStatus.empty:
        return EmptyStateWidget(message: _emptyMessage(l10n, tab));
      case CaseworkSectionStatus.error:
        return ErrorStateWidget(
          message: _errorMessage(l10n, tab),
          onRetry: onRetry,
        );
      case CaseworkSectionStatus.loaded:
        return RefreshIndicator(
          onRefresh: onRetry,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.space8,
            ),
            itemCount: section.items.length,
            itemBuilder: (final ctx, final i) {
              final item = section.items[i];
              return CaseworkItemTile(
                item: item,
                onTap: _onTapFor(ctx, item),
              );
            },
          ),
        );
    }
  }

  /// Returns a navigation handler only for registro items (entradas /
  /// salidas) — STORY-36 wires those to the registro detail screen.
  /// Expediente items are owned by STORY-35 and remain untouched here.
  static VoidCallback? _onTapFor(
    final BuildContext context,
    final CaseworkItem item,
  ) {
    final RegistroKind kind;
    switch (item.type) {
      case CaseworkTab.entradasRegistro:
        kind = RegistroKind.entrada;
      case CaseworkTab.salidasRegistro:
        kind = RegistroKind.salida;
      case CaseworkTab.expedientes:
        return null;
    }
    return () {
      final encoded = Uri.encodeComponent(item.number);
      GoRouter.of(context).go('/casework/registro/${kind.token}/$encoded');
    };
  }

  static String _emptyMessage(
    final AppLocalizations l10n,
    final CaseworkTab tab,
  ) {
    switch (tab) {
      case CaseworkTab.expedientes:
        return l10n.caseworkExpedientesEmpty;
      case CaseworkTab.entradasRegistro:
        return l10n.caseworkEntradasRegistroEmpty;
      case CaseworkTab.salidasRegistro:
        return l10n.caseworkSalidasRegistroEmpty;
    }
  }

  static String _errorMessage(
    final AppLocalizations l10n,
    final CaseworkTab tab,
  ) {
    switch (tab) {
      case CaseworkTab.expedientes:
        return l10n.caseworkExpedientesError;
      case CaseworkTab.entradasRegistro:
        return l10n.caseworkEntradasRegistroError;
      case CaseworkTab.salidasRegistro:
        return l10n.caseworkSalidasRegistroError;
    }
  }
}
