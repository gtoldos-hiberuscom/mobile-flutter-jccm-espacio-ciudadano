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
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Mis expedientes list screen — Figma node 41672:55115.
class GestionExpedientesPage extends ConsumerStatefulWidget {
  const GestionExpedientesPage({super.key});

  @override
  ConsumerState<GestionExpedientesPage> createState() => _GestionExpedientesPageState();
}

class _GestionExpedientesPageState extends ConsumerState<GestionExpedientesPage> {
  AppListFilters _filters = const AppListFilters();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final expedientesAsync = ref.watch(expedientesProvider);

    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        backgroundColor: AppColors.surface,
        title: l10n.gestionExpedientesPageTitle,
        onBack: () => context.go(Routes.gestion),
        actions: [
          IconButton(
            icon: Badge.count(
              count: _filters.activeCount,
              isLabelVisible: _filters.activeCount > 0,
              child: const AppIcon(
                AppIcons.search,
                color: AppColors.textPrimary,
              ),
            ),
            tooltip: _filters.activeCount > 0 ? l10n.gestionExpedientesFiltrosActivosTooltip(_filters.activeCount) : l10n.gestionExpedientesBuscarTooltip,
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: expedientesAsync.when(
            // Al reintentar, `refresh` conserva el error mientras recarga y por
            // defecto `.when` seguiría pintándolo, con "Reintentar" activo: cada
            // pulsación lanzaba otra petición. Se muestra la carga en su lugar.
            skipLoadingOnRefresh: false,
            loading: () => const LoadingStateWidget(),
            // La retirada de la cláusula obligatoria ya está cerrando la
            // sesión: decir "no se han podido cargar" sería mentir en el
            // parpadeo previo a volver al landing. Cualquier otro fallo,
            // incluida una autorización que no se pudo comprobar, es error
            // reintentable.
            error: (final error, final _) => error is ConsentRevoked
                ? EmptyStateWidget(message: l10n.authorizationRevokedMessage, icon: AppIcons.info)
                : ErrorStateWidget(
                    message: l10n.gestionExpedientesLoadError,
                    onRetry: () => ref.refresh(expedientesProvider),
                  ),
            data: (final expedientes) {
              if (expedientes.isEmpty) {
                return EmptyStateWidget(message: l10n.gestionExpedientesEmpty);
              }
              final filteredExpedientes = _filterExpedientes(expedientes);
              if (filteredExpedientes.isEmpty) {
                return EmptyStateWidget(
                  message: l10n.caseworkSearchNoResults,
                  subtitle: l10n.caseworkSearchNoResultsHint,
                  icon: AppIcons.search,
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: appPageHorizontalPadding(context),
                  vertical: AppDimensions.space24,
                ),
                itemCount: filteredExpedientes.length,
                separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
                itemBuilder: (final context, final index) => _GestionExpedienteCard(expediente: filteredExpedientes[index]),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showFilters() async {
    final l10n = AppLocalizations.of(context);
    final result = await AppBottomSheet.show<AppListFilters>(
      context: context,
      title: l10n.gestionExpedientesFiltrarTitle,
      body: AppListFilterSheet(
        initialFilters: _filters,
        fields: [
          AppListTextFilterField(id: 'number', label: l10n.caseworkSearchFieldExpedienteLabel, hint: l10n.gestionFiltroNumeroHint),
          AppListTextFilterField(id: 'description', label: l10n.gestionExpedientesFiltroDescripcionLabel, hint: l10n.gestionFiltroDescripcionHint),
          AppListDateRangeFilterField(id: 'startDate', label: l10n.caseworkExpedienteDetailFechaInicio),
          AppListDateRangeFilterField(id: 'endDate', label: l10n.gestionExpedientesFiltroFechaCierreLabel),
        ],
      ),
    );
    if (result != null && mounted) {
      setState(() => _filters = result);
    }
  }

  List<Expediente> _filterExpedientes(final List<Expediente> expedientes) {
    if (_filters.activeCount == 0) {
      return expedientes;
    }
    return expedientes
        .where((final expediente) {
          if (!appFilterContains(expediente.numexp, _filters.text('number'))) {
            return false;
          }
          if (!appFilterContains(expediente.titulo, _filters.text('description'))) {
            return false;
          }
          if (!appFilterDateInRange(DateTime.tryParse(expediente.fechaInicio ?? ''), _filters.range('startDate'))) {
            return false;
          }
          return appFilterDateInRange(DateTime.tryParse(expediente.fechaFin ?? ''), _filters.range('endDate'));
        })
        .toList(growable: false);
  }
}

class _GestionExpedienteCard extends StatelessWidget {
  const _GestionExpedienteCard({required this.expediente});

  final Expediente expediente;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      title: _sentenceCase(expediente.titulo),
      categoryLabel: expediente.consejeria.toUpperCase(),
      showArrow: true,
      refNumber: expediente.numexp,
      refNumberLabel: l10n.gestionExpedientesNumExpedienteLabel,
      expiryDate: _formatDate(context, expediente.fechaInicio),
      expiryDateLabel: l10n.gestionExpedientesFechaInicioLabel,
      extraLabel: expediente.estado != null ? l10n.gestionExpedientesEstadoLabel : null,
      extraText: expediente.estado == null ? null : _sentenceCase(expediente.estado!),
      onTap: () => context.push(
        '${Routes.gestionExpedientes}/${Uri.encodeComponent(expediente.numexp)}',
      ),
    );
  }

  String _formatDate(final BuildContext context, final String? rawDate) {
    final date = rawDate == null ? null : DateTime.tryParse(rawDate);
    if (date == null) {
      return rawDate ?? '-';
    }
    final formatted = DateFormat(
      'd MMM yyyy',
      Localizations.localeOf(context).languageCode,
    ).format(date);
    final parts = formatted.split(' ');
    if (parts.length < 3 || parts[1].isEmpty) {
      return formatted;
    }
    parts[1] = '${parts[1][0].toUpperCase()}${parts[1].substring(1)}';
    return parts.join(' ');
  }

  String _sentenceCase(final String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed != trimmed.toUpperCase()) {
      return trimmed;
    }
    return _formatExpedienteSentenceCase(trimmed);
  }
}

String _formatExpedienteSentenceCase(final String value) {
  const acronyms = {'EOI', 'FSP', 'JCCM', 'CLM', 'NIF', 'CIF', 'DNI', 'NIE'};
  final words = value.toLowerCase().split(' ');
  for (var index = 0; index < words.length; index++) {
    final uppercaseWord = words[index].toUpperCase();
    if (acronyms.contains(uppercaseWord)) {
      words[index] = uppercaseWord;
    }
  }
  final formatted = words.join(' ');
  return '${formatted[0].toUpperCase()}${formatted.substring(1)}';
}
