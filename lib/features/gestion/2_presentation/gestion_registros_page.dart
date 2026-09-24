import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_registros_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Mis registros list screen — Figma node 41672:55987.
class GestionRegistrosPage extends StatefulWidget {
  const GestionRegistrosPage({super.key});

  @override
  State<GestionRegistrosPage> createState() => _GestionRegistrosPageState();
}

class _GestionRegistrosPageState extends State<GestionRegistrosPage> {
  _RegistrosTab _selectedTab = _RegistrosTab.entradas;
  AppListFilters _entryFilters = const AppListFilters();
  AppListFilters _exitFilters = const AppListFilters();

  AppListFilters get _filters => _selectedTab == _RegistrosTab.entradas ? _entryFilters : _exitFilters;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        backgroundColor: AppColors.surface,
        title: l10n.gestionRegistrosPageTitle,
        onBack: () => context.go(Routes.gestion),
        actions: [
          IconButton(
            tooltip: _selectedTab == _RegistrosTab.entradas ? l10n.gestionRegistrosBuscarEntradasTooltip : l10n.gestionRegistrosBuscarSalidasTooltip,
            icon: Badge.count(
              count: _filters.activeCount,
              isLabelVisible: _filters.activeCount > 0,
              child: const AppIcon(AppIcons.search, color: AppColors.textPrimary),
            ),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          AppTopTabBar(
            tabs: [l10n.gestionRegistrosEntradasTab, l10n.gestionRegistrosSalidasTab],
            selectedIndex: _selectedTab.index,
            onTabSelected: (final index) => setState(() => _selectedTab = _RegistrosTab.values[index]),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.backgroundBlueLighter,
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: appPageHorizontalPadding(context),
                        top: AppDimensions.space24,
                        right: appPageHorizontalPadding(context),
                      ),
                      child: Text(
                        switch (_selectedTab) {
                          _RegistrosTab.entradas => l10n.gestionRegistrosEntradasDescription,
                          _RegistrosTab.salidas => l10n.gestionRegistrosSalidasDescription,
                        },
                        style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
                      ),
                    ),
                    Expanded(
                      child: switch (_selectedTab) {
                        _RegistrosTab.entradas => _EntradasTab(filters: _entryFilters),
                        _RegistrosTab.salidas => _SalidasTab(filters: _exitFilters),
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilters() async {
    final l10n = AppLocalizations.of(context);
    final isEntry = _selectedTab == _RegistrosTab.entradas;
    final result = await AppBottomSheet.show<AppListFilters>(
      context: context,
      title: isEntry ? l10n.gestionRegistrosFiltrarEntradasTitle : l10n.gestionRegistrosFiltrarSalidasTitle,
      body: AppListFilterSheet(
        initialFilters: _filters,
        fields: [
          AppListTextFilterField(id: 'number', label: l10n.caseworkSearchFieldRegistroLabel, hint: l10n.gestionFiltroNumeroHint),
          AppListTextFilterField(
            id: 'description',
            label: isEntry ? l10n.gestionRegistrosFiltroDescripcionEntradaLabel : l10n.gestionRegistrosFiltroDescripcionSalidaLabel,
            hint: l10n.gestionFiltroDescripcionHint,
          ),
          AppListDateRangeFilterField(id: 'date', label: isEntry ? l10n.gestionRegistrosFiltroFechaEntradaLabel : l10n.gestionRegistrosFiltroFechaSalidaLabel),
        ],
      ),
    );
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      if (isEntry) {
        _entryFilters = result;
      } else {
        _exitFilters = result;
      }
    });
  }
}

enum _RegistrosTab { entradas, salidas }

class _EntradasTab extends ConsumerWidget {
  const _EntradasTab({required this.filters});
  final AppListFilters filters;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(entradasProvider)
        .when(
          loading: () => const LoadingStateWidget(),
          // Igual que en notificaciones: la revocación de la cláusula
          // obligatoria ya está cerrando la sesión, y todo lo demás —incluida
          // una autorización que no se pudo comprobar— es error reintentable.
          error: (final error, final _) => error is ConsentRevoked
              ? EmptyStateWidget(message: l10n.authorizationRevokedMessage, icon: AppIcons.info)
              : ErrorStateWidget(
                  message: l10n.gestionRegistrosEntradasLoadError,
                  onRetry: () => ref.refresh(entradasProvider),
                ),
          data: (final registros) => _RegistrosList(registros: registros, filters: filters, isEntrada: true),
        );
  }
}

class _SalidasTab extends ConsumerWidget {
  const _SalidasTab({required this.filters});
  final AppListFilters filters;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(salidasProvider)
        .when(
          loading: () => const LoadingStateWidget(),
          // Igual que en notificaciones: la revocación de la cláusula
          // obligatoria ya está cerrando la sesión, y todo lo demás —incluida
          // una autorización que no se pudo comprobar— es error reintentable.
          error: (final error, final _) => error is ConsentRevoked
              ? EmptyStateWidget(message: l10n.authorizationRevokedMessage, icon: AppIcons.info)
              : ErrorStateWidget(
                  message: l10n.gestionRegistrosSalidasLoadError,
                  onRetry: () => ref.refresh(salidasProvider),
                ),
          data: (final registros) => _RegistrosList(registros: registros, filters: filters, isEntrada: false),
        );
  }
}

class _RegistrosList extends StatelessWidget {
  const _RegistrosList({required this.registros, required this.filters, required this.isEntrada});
  final List<Registro> registros;
  final AppListFilters filters;
  final bool isEntrada;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (registros.isEmpty) {
      return EmptyStateWidget(message: isEntrada ? l10n.gestionRegistrosEntradasEmpty : l10n.gestionRegistrosSalidasEmpty);
    }
    final filtered = registros
        .where((final registro) {
          return appFilterContains(registro.numregistro, filters.text('number')) && appFilterContains(registro.titulo, filters.text('description')) && appFilterDateInRange(DateTime.tryParse(registro.fecha ?? ''), filters.range('date'));
        })
        .toList(growable: false);
    if (filtered.isEmpty) {
      return EmptyStateWidget(message: l10n.caseworkSearchNoResults, subtitle: l10n.caseworkSearchNoResultsHint, icon: AppIcons.search);
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: appPageHorizontalPadding(context), vertical: AppDimensions.space24),
      itemCount: filtered.length,
      separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
      itemBuilder: (final context, final index) => _RegistroCard(registro: filtered[index], isEntrada: isEntrada),
    );
  }
}

class _RegistroCard extends StatelessWidget {
  const _RegistroCard({required this.registro, required this.isEntrada});

  final Registro registro;
  final bool isEntrada;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      title: _sentenceCase(registro.titulo),
      showArrow: true,
      refNumber: registro.numregistro,
      refNumberLabel: l10n.gestionRegistrosNumRegistroLabel,
      expiryDate: _formatDate(registro.fecha),
      expiryDateLabel: l10n.gestionRegistrosCardDateLabel,
      inlineMetadata: true,
      onTap: () => context.push(
        Routes.gestionRegistrosDetail,
        extra: (registro, isEntrada),
      ),
    );
  }

  String? _formatDate(final String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return null;
    }
    final date = DateTime.tryParse(rawDate);
    if (date == null) {
      return rawDate;
    }
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _sentenceCase(final String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed != trimmed.toUpperCase()) {
      return trimmed;
    }
    final lowerCase = trimmed.toLowerCase();
    return '${lowerCase[0].toUpperCase()}${lowerCase.substring(1)}';
  }
}
