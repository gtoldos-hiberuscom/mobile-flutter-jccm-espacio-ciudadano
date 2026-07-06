import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

// API estado values aligned with GET /api/v1/ciudadanos/{id}/notificaciones?estado=
const _kEstadoPendiente = 'pendiente';
const _kEstadoAceptada = 'aceptada';

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

  // null → no filter (Todo), 'pendiente', 'aceptada'
  static const List<String?> _tabEstados = [null, _kEstadoPendiente, _kEstadoAceptada];

  String? get _currentEstado => _tabEstados[_selectedTab];

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabLabels = [
      l10n.gestionNotificacionesTabTodo,
      l10n.gestionNotificacionesTabPendientes,
      l10n.gestionNotificacionesTabAceptadas,
    ];
    final notifAsync = ref.watch(gestionNotificacionesProvider(_currentEstado));

    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.gestionNotificacionesPageTitle,
        onBack: () => context.go(widget.backRoute),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.settings),
            tooltip: 'Configurar notificaciones',
            onPressed: () => context.go(Routes.notificationContact),
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
                  onMore: () => AppAlertSnackbar.show(context, message: l10n.gestionSectionComingSoon),
                ),
              ),
              Expanded(
                child: notifAsync.when(
                  loading: () => const LoadingStateWidget(),
                  error: (final _, final _) => ErrorStateWidget(
                    message: l10n.gestionNotificacionesLoadError,
                    onRetry: () => ref.invalidate(gestionNotificacionesProvider(_currentEstado)),
                  ),
                  data: (final notifs) => notifs.isEmpty
                      ? EmptyStateWidget(message: l10n.gestionNotificacionesEmpty)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimensions.space16,
                            0,
                            AppDimensions.space16,
                            AppDimensions.space24,
                          ),
                          itemCount: notifs.length,
                          separatorBuilder: (final _, final _) => const SizedBox(height: AppDimensions.space16),
                          itemBuilder: (final context, final index) => _NotificacionCard(
                            notificacion: notifs[index],
                            filterEstado: _currentEstado,
                            onTap: () => AppAlertSnackbar.show(context, message: l10n.gestionSectionComingSoon),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Filter bar ──────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    required this.onMore,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onMore;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderNeutralLight),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: _TabSegment(
                label: labels[i],
                isSelected: i == selectedIndex,
                onTap: () => onSelected(i),
              ),
            ),
          ],
          const SizedBox(width: AppDimensions.space8),
          Semantics(
            button: true,
            label: 'Ver más filtros',
            child: GestureDetector(
              onTap: onMore,
              child: const Padding(
                padding: EdgeInsets.all(AppDimensions.space8),
                child: Icon(AppIcons.arrowForward, size: AppDimensions.iconMedium, color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSegment extends StatelessWidget {
  const _TabSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.backgroundBlueLighter : AppColors.backgroundWhite,
              border: Border.all(
                color: isSelected ? AppColors.borderDarkPrimary : AppColors.neutral500,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              boxShadow: isSelected ? AppShadows.low : AppShadows.medium,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textBlack,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Notification card ────────────────────────────────────────────────────────

class _NotificacionCard extends StatelessWidget {
  const _NotificacionCard({
    required this.notificacion,
    required this.onTap,
    this.filterEstado,
  });

  final Notificacion notificacion;
  final String? filterEstado;
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
                  _headerRow(),
                  _titleRow(l10n),
                  _refBlock(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerRow() {
    final tag = _statusTag();
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
                  orgName,
                  style: AppTypography.captionUppercase.copyWith(color: AppColors.neutralDark),
                ),
              ),
            ),
          ?tag,
        ],
      ),
    );
  }

  Widget _titleRow(final AppLocalizations l10n) {
    final title = notificacion.concepto.isNotEmpty ? notificacion.concepto : notificacion.procedimientoDenominacion;
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

  Widget _refBlock(final AppLocalizations l10n) {
    final idFicha = notificacion.procedimientoIdFicha;
    final fecha = notificacion.fechaCaducidad;
    if (idFicha == null && fecha == null) {
      return const SizedBox.shrink();
    }
    final isWarning = filterEstado == _kEstadoPendiente;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      color: AppColors.backgroundBlueLighter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (idFicha != null)
            _RefRow(
              label: l10n.gestionNotificacionesProcedimientoLabel,
              value: idFicha,
            ),
          if (fecha != null)
            _RefRow(
              label: l10n.gestionNotificacionesFechaCaducidadLabel,
              value: _formatFecha(fecha),
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

  Widget? _statusTag() {
    return switch (filterEstado) {
      _kEstadoPendiente => const AppTag(status: AppTagStatus.warning, label: 'Pendiente', showIcon: false),
      _kEstadoAceptada => const AppTag(status: AppTagStatus.success, label: 'Aceptada', showIcon: false),
      'rechazada' => const AppTag(status: AppTagStatus.error, label: 'Rechazada', showIcon: false),
      'expirada' => const AppTag(status: AppTagStatus.infoInactive, label: 'Expirada', showIcon: false),
      _ => null,
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

String _formatFecha(final DateTime date) {
  const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
