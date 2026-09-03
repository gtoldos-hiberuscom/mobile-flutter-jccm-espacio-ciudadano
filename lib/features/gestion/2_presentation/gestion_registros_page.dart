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
        title: l10n.gestionRegistrosPageTitle,
        onBack: () => context.go(Routes.gestion),
        actions: [
          IconButton(
            tooltip: _selectedTab == _RegistrosTab.entradas ? 'Buscar entradas de registro' : 'Buscar salidas de registro',
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
                child: switch (_selectedTab) {
                  _RegistrosTab.entradas => _EntradasTab(filters: _entryFilters),
                  _RegistrosTab.salidas => _SalidasTab(filters: _exitFilters),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilters() async {
    final isEntry = _selectedTab == _RegistrosTab.entradas;
    final result = await AppBottomSheet.show<AppListFilters>(
      context: context,
      title: isEntry ? 'Filtrar entradas de registro' : 'Filtrar salidas de registro',
      body: AppListFilterSheet(
        initialFilters: _filters,
        fields: [
          const AppListTextFilterField(id: 'number', label: 'Número de registro', hint: 'Introduce el número'),
          AppListTextFilterField(
            id: 'description',
            label: isEntry ? 'Descripción de la entrada' : 'Descripción de la salida',
            hint: 'Introduce palabras de la descripción',
          ),
          AppListDateRangeFilterField(id: 'date', label: isEntry ? 'Fecha de entrada' : 'Fecha de salida'),
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
                  onRetry: () => ref.invalidate(entradasProvider),
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
                  onRetry: () => ref.invalidate(salidasProvider),
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
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16, vertical: AppDimensions.space24),
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
      expiryDate: _formatDate(context, registro.fecha),
      expiryDateLabel: l10n.gestionRegistrosFechaLabel,
      onTap: () => context.push(
        Routes.gestionRegistrosDetail,
        extra: (registro, isEntrada),
      ),
    );
  }

  String? _formatDate(final BuildContext context, final String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return null;
    }
    final date = DateTime.tryParse(rawDate);
    if (date == null) {
      return rawDate;
    }
    final parts = DateFormat(
      'd MMM yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(date).split(' ');
    if (parts.length >= 3 && parts[1].isNotEmpty) {
      parts[1] = '${parts[1][0].toUpperCase()}${parts[1].substring(1)}';
    }
    return parts.join(' ');
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
