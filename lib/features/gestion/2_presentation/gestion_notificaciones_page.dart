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
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Pantalla de listado de notificaciones — Figma node 41972:6649.
class GestionNotificacionesPage extends ConsumerStatefulWidget {
  const GestionNotificacionesPage({
    super.key,
    this.backRoute = Routes.gestion,
  });

  final String backRoute;

  @override
  ConsumerState<GestionNotificacionesPage> createState() => _GestionNotificacionesPageState();
}

class _GestionNotificacionesPageState extends ConsumerState<GestionNotificacionesPage> {
  int _selectedTab = 0;
  AppListFilters _filters = const AppListFilters();

  // null → sin filtro (Todo)
  static const List<NotificacionEstado?> _tabEstados = [
    null,
    NotificacionEstado.pendiente,
    NotificacionEstado.aceptada,
    NotificacionEstado.expirada,
  ];

  NotificacionEstado? get _currentEstado => _tabEstados[_selectedTab];

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabLabels = [
      l10n.gestionNotificacionesTabTodo,
      l10n.gestionNotificacionesTabPendientes,
      l10n.gestionNotificacionesTabAceptadas,
      l10n.gestionNotificacionesTabExpiradas,
    ];
    final notifAsync = ref.watch(gestionNotificacionesProvider(_currentEstado));

    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.gestionNotificacionesPageTitle,
        onBack: () => context.go(widget.backRoute),
        actions: [
          IconButton(
            tooltip: l10n.gestionNotificacionesBuscarTooltip,
            icon: Badge.count(
              count: _filters.activeCount,
              isLabelVisible: _filters.activeCount > 0,
              child: const AppIcon(AppIcons.search, color: AppColors.textPrimary),
            ),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(AppIcons.settings),
            tooltip: l10n.gestionNotificacionesConfigurarTooltip,
            onPressed: () => context.go(
              Uri(
                path: Routes.notificationContact,
                queryParameters: {'returnTo': Routes.gestionNotificaciones},
              ).toString(),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.space16,
                  AppDimensions.space24,
                  AppDimensions.space16,
                  AppDimensions.space16,
                ),
                child: _FilterBar(
                  labels: tabLabels,
                  selectedIndex: _selectedTab,
                  onSelected: (final i) => setState(() => _selectedTab = i),
                ),
              ),
              Expanded(
                child: notifAsync.when(
                  loading: () => const LoadingStateWidget(),
                  // La retirada de la cláusula obligatoria ya está cerrando la
                  // sesión: decir "no se han podido cargar" sería mentir en el
                  // parpadeo previo a volver al landing. Cualquier otro fallo,
                  // incluida una autorización que no se pudo comprobar, es
                  // error reintentable.
                  error: (final error, final _) => error is ConsentRevoked
                      ? EmptyStateWidget(
                          message: l10n.authorizationRevokedMessage,
                          icon: AppIcons.info,
                        )
                      : ErrorStateWidget(
                          message: l10n.gestionNotificacionesLoadError,
                          onRetry: () => ref.invalidate(gestionNotificacionesProvider(_currentEstado)),
                        ),
                  data: (final notifs) {
                    final filtered = notifs
                        .where((final notification) {
                          final description = notification.concepto.isNotEmpty ? notification.concepto : notification.procedimientoDenominacion;
                          return appFilterContains(description, _filters.text('description')) && appFilterDateInRange(notification.fechaCaducidad, _filters.range('date'));
                        })
                        .toList(growable: false);
                    return notifs.isEmpty
                        ? EmptyStateWidget(message: l10n.gestionNotificacionesEmpty)
                        : filtered.isEmpty
                        ? EmptyStateWidget(message: l10n.caseworkSearchNoResults, subtitle: l10n.caseworkSearchNoResultsHint, icon: AppIcons.search)
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              AppDimensions.space16,
                              0,
                              AppDimensions.space16,
                              AppDimensions.space24,
                            ),
                            itemCount: filtered.length,
                            separatorBuilder: (final _, final _) => const SizedBox(height: AppDimensions.space16),
                            itemBuilder: (final context, final index) => _NotificacionCard(
                              notificacion: filtered[index],
                              onTap: () => context.push(
                                Routes.gestionNotificacionDetallePath(filtered[index].id),
                                extra: filtered[index],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFilters() async {
    final l10n = AppLocalizations.of(context);
    final result = await AppBottomSheet.show<AppListFilters>(
      context: context,
      title: l10n.gestionNotificacionesFiltrarTitle,
      body: AppListFilterSheet(
        initialFilters: _filters,
        fields: [
          AppListTextFilterField(id: 'description', label: l10n.gestionNotificacionesFiltroDescripcionLabel, hint: l10n.gestionFiltroDescripcionHint),
          AppListDateRangeFilterField(id: 'date', label: l10n.gestionNotificacionesFechaExpiracionLabel),
        ],
      ),
    );
    if (result != null && mounted) {
      setState(() => _filters = result);
    }
  }
}

// ─── Filter bar ──────────────────────────────────────────────────────────────

class _FilterBar extends StatefulWidget {
  const _FilterBar({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  static const _primaryFilterIndexes = [0, 1, 2];
  static const _expiredFilterIndexes = [2, 3];

  bool _showExpired = false;

  @override
  void didUpdateWidget(covariant final _FilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex == 3) {
      _showExpired = true;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final indexes = _showExpired ? _expiredFilterIndexes : _primaryFilterIndexes;
    final selectedIndex = indexes.contains(widget.selectedIndex) ? indexes.indexOf(widget.selectedIndex) : indexes.indexOf(2);

    return AppFloatingNavigation(
      tabs: indexes.map((final index) => widget.labels[index]).toList(growable: false),
      selectedIndex: selectedIndex,
      minTabWidths: _showExpired ? const [128, 206] : const [76, 150, 150],
      onTabSelected: (final index) => widget.onSelected(indexes[index]),
      leading: _showExpired
          ? _FloatingNavigationArrow(
              icon: AppIcons.arrowBack,
              tooltip: AppLocalizations.of(context).gestionNotificacionesFiltrosAnterioresTooltip,
              onPressed: () => setState(() => _showExpired = false),
            )
          : null,
      trailing: !_showExpired
          ? _FloatingNavigationArrow(
              icon: AppIcons.arrowForward,
              tooltip: widget.labels[3],
              onPressed: () => setState(() => _showExpired = true),
            )
          : null,
    );
  }
}

class _FloatingNavigationArrow extends StatelessWidget {
  const _FloatingNavigationArrow({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: AppDimensions.minTouchTarget,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: AppIcon(icon, color: AppColors.textPrimary),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}

// ─── Notification card ────────────────────────────────────────────────────────

class _NotificacionCard extends StatelessWidget {
  const _NotificacionCard({
    required this.notificacion,
    required this.onTap,
  });

  final Notificacion notificacion;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);
    final semanticLabel = [
      notificacion.unidadOrganicaNombre,
      if (notificacion.concepto.isNotEmpty) notificacion.concepto else notificacion.procedimientoDenominacion,
      notificacion.procedimientoIdFicha,
    ].whereType<String>().join(', ');

    return Semantics(
      button: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: borderRadius,
                border: Border.all(color: AppColors.borderBlueMutedLight),
                boxShadow: AppShadows.medium,
              ),
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _headerRow(l10n),
                  _titleRow(l10n),
                  _refBlock(context, l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerRow(final AppLocalizations l10n) {
    final tag = _statusTag(l10n);
    final orgName = notificacion.unidadOrganicaNombre;
    if (orgName == null && tag == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (orgName != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppDimensions.space4,
                  bottom: AppDimensions.space8,
                ),
                child: Text(
                  orgName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.captionUppercase.copyWith(
                    color: AppColors.textBlueMutedDark,
                  ),
                ),
              ),
            ),
          ?tag,
        ],
      ),
    );
  }

  /// Lo que la tarjeta muestra como título: el concepto y, si viene vacío, la
  /// denominación del procedimiento (mejor eso que una tarjeta sin título).
  String get _titulo => notificacion.concepto.isNotEmpty ? notificacion.concepto : notificacion.procedimientoDenominacion;

  /// Lo que la tarjeta muestra como "Procedimiento".
  ///
  /// La denominación primero y el `idFicha` después: en UAT el gateway
  /// devuelve `idFicha: null` en todos los elementos, así que leer solo ese
  /// campo dejaba la fila apagada en toda la bandeja. Es además el mismo orden
  /// que resuelve el detalle, para que las dos pantallas no muestren valores
  /// distintos bajo la misma etiqueta.
  String? get _procedimiento {
    final denominacion = notificacion.procedimientoDenominacion.trim();
    if (denominacion.isNotEmpty) {
      return denominacion;
    }
    final idFicha = notificacion.procedimientoIdFicha?.trim();
    return idFicha == null || idFicha.isEmpty ? null : idFicha;
  }

  Widget _titleRow(final AppLocalizations l10n) {
    final title = _titulo;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.space4,
        bottom: AppDimensions.space8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.leadingBold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          const AppIcon(AppIcons.arrowForward, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _refBlock(final BuildContext context, final AppLocalizations l10n) {
    // Sin concepto el título ya es la denominación: repetirla debajo con la
    // etiqueta "Procedimiento" sería pintar el mismo texto dos veces.
    final procedimiento = _procedimiento == _titulo ? null : _procedimiento;
    final fecha = notificacion.fechaCaducidad;
    final showsExpiration = notificacion.estado == NotificacionEstado.pendiente || notificacion.estado == NotificacionEstado.expirada;
    if (procedimiento == null && (!showsExpiration || fecha == null)) {
      return const SizedBox.shrink();
    }
    final isWarning = notificacion.estado == NotificacionEstado.pendiente;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      color: AppColors.backgroundLightBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (procedimiento != null)
            _RefRow(
              label: l10n.gestionNotificacionesProcedimientoLabel,
              value: procedimiento,
            ),
          if (showsExpiration && fecha != null)
            _RefRow(
              label: l10n.gestionNotificacionesFechaCaducidadLabel,
              value: _formatFecha(context, fecha),
              valueColor: isWarning ? AppColors.warningDark : AppColors.textPrimary,
              valueFontWeight: isWarning ? FontWeight.w700 : FontWeight.w400,
              trailingIcon: isWarning
                  ? const Icon(
                      Icons.warning_amber_rounded,
                      size: AppDimensions.iconMedium,
                      color: AppColors.warningDark,
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  /// Sin estado conocido no se pinta etiqueta: el listado indexado no informa
  /// el estado y en "Todo" no hay filtro del que deducirlo.
  Widget? _statusTag(final AppLocalizations l10n) {
    return switch (notificacion.estado) {
      NotificacionEstado.pendiente => AppTag(status: AppTagStatus.warning, label: l10n.gestionNotificacionesTagPendiente, showIcon: false),
      NotificacionEstado.aceptada => AppTag(status: AppTagStatus.success, label: l10n.gestionNotificacionesTagAceptada, showIcon: false),
      NotificacionEstado.rechazada => AppTag(status: AppTagStatus.error, label: l10n.gestionNotificacionesTagRechazada, showIcon: false),
      NotificacionEstado.expirada => AppTag(status: AppTagStatus.infoInactive, label: l10n.gestionNotificacionesTagExpirada, showIcon: false),
      null => null,
    };
  }
}

class _RefRow extends StatelessWidget {
  const _RefRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueFontWeight,
    this.trailingIcon,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? valueFontWeight;
  final Widget? trailingIcon;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Wrap(
        spacing: AppDimensions.space8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 124),
            child: Text(
              label.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTypography.smallRegular.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: valueFontWeight ?? FontWeight.w400,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppDimensions.space4),
                trailingIcon!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

String _formatFecha(final BuildContext context, final DateTime date) {
  final parts = DateFormat('d MMM yyyy', Localizations.localeOf(context).languageCode).format(date).split(' ');
  if (parts.length >= 3 && parts[1].isNotEmpty) {
    parts[1] = '${parts[1][0].toUpperCase()}${parts[1].substring(1)}';
  }
  return parts.join(' ');
}
