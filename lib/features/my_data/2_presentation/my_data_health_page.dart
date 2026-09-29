import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/controllers/past_primary_care_appointments_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Health data detail — Figma node 43973:1861.
class MyDataHealthPage extends ConsumerStatefulWidget {
  const MyDataHealthPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  ConsumerState<MyDataHealthPage> createState() => _MyDataHealthPageState();
}

class _MyDataHealthPageState extends ConsumerState<MyDataHealthPage> {
  _HealthTab _selectedTab = _HealthTab.data;
  HealthAppointmentScope _selectedScope = HealthAppointmentScope.primaryCare;
  HealthAppointmentFilter _selectedAppointmentFilter = HealthAppointmentFilter.pending;
  AppListFilters _appointmentFilters = const AppListFilters();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataHealthTitle,
      onBack: () => context.go(widget.backRoute),
      onInfo: () => _showHealthInfoSheet(context),
      actions: _selectedTab == _HealthTab.data
          ? [
              IconButton(
                tooltip: _appointmentFilters.activeCount > 0 ? l10n.myDataHealthActiveFiltersTooltip(_appointmentFilters.activeCount) : l10n.myDataHealthSearchAppointmentsTooltip,
                icon: Badge.count(
                  count: _appointmentFilters.activeCount,
                  isLabelVisible: _appointmentFilters.activeCount > 0,
                  child: const AppIcon(AppIcons.search, color: AppColors.textPrimary),
                ),
                onPressed: _showAppointmentFilters,
              ),
            ]
          : const [],
      tabs: [l10n.myDataHealthDataTab, l10n.myDataHealthServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _HealthTab.values[index]),
      tabViews: [
        _HealthAppointmentsTab(
          selectedScope: _selectedScope,
          onScopeSelected: (final scope) => setState(() => _selectedScope = scope),
          selectedAppointmentFilter: _selectedAppointmentFilter,
          onAppointmentFilterSelected: (final filter) => setState(() => _selectedAppointmentFilter = filter),
          filters: _appointmentFilters,
        ),
        const _HealthServicesTab(),
      ],
    );
  }

  Future<void> _showAppointmentFilters() async {
    final l10n = AppLocalizations.of(context);
    final result = await AppBottomSheet.show<AppListFilters>(
      context: context,
      title: switch (_selectedScope) {
        HealthAppointmentScope.primaryCare => l10n.myDataHealthFilterPrimaryCareTitle,
        HealthAppointmentScope.hospital => l10n.myDataHealthFilterHospitalTitle,
      },
      body: AppListFilterSheet(
        initialFilters: _appointmentFilters,
        fields: [
          AppListDateRangeFilterField(id: 'date', label: l10n.myDataHealthFilterDateLabel),
        ],
      ),
    );
    if (result != null && mounted) {
      setState(() => _appointmentFilters = result);
    }
  }

  Future<void> _showHealthInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataHealthInfoSheetTitle,
      bodyText: l10n.myDataHealthInfoSheetDescription,
      footerText: l10n.myDataHealthInfoSheetContactHint,
    );
  }
}

enum _HealthTab { data, services }

/// Muestra el selector de ámbito asistencial y, con él, las citas hospitalarias.
///
/// Desactivado mientras `BASE_URL` siga apuntando a la fachada: sus rutas
/// (`/ciudadanos/{sid}/salud/hospitalaria-citas-*`) sólo existen en el gateway,
/// así que hoy responderían 403 y la pantalla mostraría el aviso de autorización
/// sin que el ciudadano pueda hacer nada al respecto.
///
/// La capa de datos, el mapeo y los tests siguen activos; para volver a
/// publicarlo basta poner esto a `true`.
const bool kHospitalAppointmentsEnabled = false;

/// Distancia al final del listado, en píxeles, a la que se pide la página
/// siguiente de citas pasadas de primaria.
const double _loadMoreScrollThreshold = 240;

class _HealthAppointmentsTab extends ConsumerWidget {
  const _HealthAppointmentsTab({
    required this.selectedScope,
    required this.onScopeSelected,
    required this.selectedAppointmentFilter,
    required this.onAppointmentFilterSelected,
    required this.filters,
  });

  final HealthAppointmentScope selectedScope;
  final ValueChanged<HealthAppointmentScope> onScopeSelected;
  final HealthAppointmentFilter selectedAppointmentFilter;
  final ValueChanged<HealthAppointmentFilter> onAppointmentFilterSelected;
  final AppListFilters filters;

  /// Sólo las citas pasadas de primaria se paginan: es la única operación del
  /// gateway que acepta el parámetro `pagina`.
  bool get _isPaginated => selectedScope == HealthAppointmentScope.primaryCare && selectedAppointmentFilter == HealthAppointmentFilter.past;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authorizationAsync = ref.watch(jccmDataAuthorizationProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: (final notification) {
        if (_isPaginated && notification.metrics.axis == Axis.vertical && notification.metrics.extentAfter <= _loadMoreScrollThreshold) {
          unawaited(ref.read(pastPrimaryCareAppointmentsProvider.notifier).loadMore());
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              switch (selectedScope) {
                HealthAppointmentScope.primaryCare => l10n.myDataHealthAppointmentsTitle,
                HealthAppointmentScope.hospital => l10n.myDataHealthHospitalAppointmentsTitle,
              },
              style: AppTypography.h2.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            authorizationAsync.when(
              data: (final hasJccmAuthorization) {
                if (!hasJccmAuthorization) {
                  return MyDataAuthorizationContextualHelper(
                    onOpenSettings: () => _openConsentSettings(context),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CipText(cip: ref.watch(myDataHealthCipProvider).asData?.value),
                    const SizedBox(height: AppDimensions.space16),
                    // Apartado 2.1 del requisito: el acceso a hospitalaria es un
                    // enlace a su propia pantalla, no otro selector apilado
                    // aquí. Mismo patrón que Vivienda y Educación.
                    AppNavigationCard(
                      title: l10n.myDataHealthHospitalLinkTitle,
                      description: l10n.myDataHealthHospitalLinkDescription,
                      onTap: () => context.go(Routes.myDataHealthHospitalAppointments),
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    if (kHospitalAppointmentsEnabled) ...[
                      AppSegmentedControl(
                        segments: [l10n.myDataHealthScopePrimaryCare, l10n.myDataHealthScopeHospital],
                        selectedIndex: selectedScope == HealthAppointmentScope.primaryCare ? 0 : 1,
                        onSelected: (final index) => onScopeSelected(
                          index == 0 ? HealthAppointmentScope.primaryCare : HealthAppointmentScope.hospital,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space12),
                    ],
                    AppSegmentedControl(
                      segments: [l10n.myDataHealthPendingTab, l10n.myDataHealthPastTab],
                      selectedIndex: selectedAppointmentFilter == HealthAppointmentFilter.pending ? 0 : 1,
                      onSelected: (final index) => onAppointmentFilterSelected(
                        index == 0 ? HealthAppointmentFilter.pending : HealthAppointmentFilter.past,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space20),
                    if (_isPaginated)
                      _PastPrimaryCareAppointmentsList(filters: filters, l10n: l10n)
                    else
                      _SingleShotAppointmentsList(
                        scope: selectedScope,
                        filter: selectedAppointmentFilter,
                        filters: filters,
                        l10n: l10n,
                      ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.only(top: AppDimensions.space24),
                child: Center(child: AppLoadingIndicator()),
              ),
              // Fallo del check ≠ "no autorizado": sin respuesta del backend
              // solo cabe error + reintentar, nunca pedir re-autorizar un
              // consentimiento que puede estar concedido.
              error: (final error, final stackTrace) => ErrorStateWidget(
                message: l10n.authorizationCheckFailedMessage,
                onRetry: () => ref.invalidate(jccmDataAuthorizationProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Abre las autorizaciones en modo preferencias y vuelve a Salud al terminar.
void _openConsentSettings(final BuildContext context) {
  unawaited(
    context.push(
      Uri(
        path: Routes.consent,
        queryParameters: {
          'mode': 'preferences',
          'returnTo': Routes.myDataHealth,
        },
      ).toString(),
    ),
  );
}

/// Listados que se resuelven en una sola llamada: pendientes de primaria y
/// ambos listados de hospitalaria.
class _SingleShotAppointmentsList extends ConsumerWidget {
  const _SingleShotAppointmentsList({
    required this.scope,
    required this.filter,
    required this.filters,
    required this.l10n,
  });

  final HealthAppointmentScope scope;
  final HealthAppointmentFilter filter;
  final AppListFilters filters;
  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final appointmentsAsync = switch (scope) {
      HealthAppointmentScope.primaryCare => ref.watch(myDataPrimaryCarePendingAppointmentsProvider),
      HealthAppointmentScope.hospital => ref.watch(myDataHospitalAppointmentsProvider(filter)),
    };

    return appointmentsAsync.when(
      data: (final appointments) => _AppointmentsContent(
        entries: _appointmentEntries(appointments, filters),
        emptyMessage: switch (scope) {
          HealthAppointmentScope.primaryCare => l10n.myDataHealthAppointmentsNoDataMessage,
          HealthAppointmentScope.hospital => l10n.myDataHealthHospitalAppointmentsNoDataMessage,
        },
        l10n: l10n,
      ),
      loading: () => const Padding(
        padding: EdgeInsets.only(top: AppDimensions.space24),
        child: Center(child: AppLoadingIndicator()),
      ),
      error: (final error, final stackTrace) => error is MyDataAuthorizationRequired
          ? MyDataAuthorizationContextualHelper(
              onOpenSettings: () => _openConsentSettings(context),
            )
          : error is MyDataHealthCipMissing
          ? const _HealthCipMissingState()
          : _HealthErrorState(
              onRetry: () => switch (scope) {
                HealthAppointmentScope.primaryCare => ref.invalidate(myDataPrimaryCarePendingAppointmentsProvider),
                HealthAppointmentScope.hospital => ref.invalidate(myDataHospitalAppointmentsProvider(filter)),
              },
            ),
    );
  }
}

/// Citas pasadas de primaria, acumuladas por páginas.
///
/// El scroll dispara la carga automáticamente, pero el botón se mantiene visible
/// mientras queden páginas: es el único camino accesible por teclado y lector de
/// pantalla, y también rescata el caso en el que el filtro de fechas deja la
/// lista tan corta que no hay scroll que disparar.
class _PastPrimaryCareAppointmentsList extends ConsumerWidget {
  const _PastPrimaryCareAppointmentsList({
    required this.filters,
    required this.l10n,
  });

  final AppListFilters filters;
  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(pastPrimaryCareAppointmentsProvider);

    switch (state.status) {
      case PastPrimaryCareAppointmentsStatus.loading:
        return const Padding(
          padding: EdgeInsets.only(top: AppDimensions.space24),
          child: Center(child: AppLoadingIndicator()),
        );
      case PastPrimaryCareAppointmentsStatus.authorizationRequired:
        return MyDataAuthorizationContextualHelper(
          onOpenSettings: () => _openConsentSettings(context),
        );
      case PastPrimaryCareAppointmentsStatus.cipMissing:
        return const _HealthCipMissingState();
      case PastPrimaryCareAppointmentsStatus.loadError:
        return _HealthErrorState(
          onRetry: () => unawaited(ref.read(pastPrimaryCareAppointmentsProvider.notifier).retry()),
        );
      case PastPrimaryCareAppointmentsStatus.loaded:
        final entries = _appointmentEntries(state.appointments, filters);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Con páginas pendientes no se afirma que no hay citas: puede que
            // simplemente no se hayan cargado todavía.
            if (entries.isNotEmpty || !state.hasMore)
              _AppointmentsContent(
                entries: entries,
                emptyMessage: l10n.myDataHealthAppointmentsNoDataMessage,
                l10n: l10n,
              ),
            if (state.hasMore) ...[
              const SizedBox(height: AppDimensions.space16),
              AppButton(
                label: l10n.myDataHealthLoadMoreAppointments,
                hierarchy: AppButtonHierarchy.secondary,
                isExpanded: true,
                isLoading: state.isLoadingMore,
                onPressed: state.isLoadingMore ? null : () => unawaited(ref.read(pastPrimaryCareAppointmentsProvider.notifier).loadMore()),
              ),
            ],
          ],
        );
    }
  }
}

/// Convierte primaria u hospitalaria en tarjetas fechadas para que el listado
/// agrupe por año y mes de la misma forma en ambos ámbitos.
List<_AppointmentEntry> _appointmentEntries(final List<Object> appointments, final AppListFilters filters) {
  final range = filters.range('date');
  final entries = <_AppointmentEntry>[];

  for (final appointment in appointments) {
    switch (appointment) {
      case final HealthAppointment primaryCare:
        if (appFilterDateInRange(primaryCare.dateTime, range)) {
          entries.add(
            _AppointmentEntry(
              dateTime: primaryCare.dateTime,
              card: _AppointmentCard(appointment: primaryCare),
            ),
          );
        }
      case final HospitalAppointment hospital:
        if (appFilterDateInRange(hospital.dateTime, range)) {
          entries.add(
            _AppointmentEntry(
              dateTime: hospital.dateTime,
              card: _HospitalAppointmentCard(appointment: hospital),
            ),
          );
        }
    }
  }

  return entries;
}

class _HealthServicesTab extends ConsumerWidget {
  const _HealthServicesTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppExternalLinkSection(
            title: l10n.myDataHealthProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureComplaints,
                onTap: () => _launchExternalUrl(context, config.healthProcedure(0)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureHealthCard,
                onTap: () => _launchExternalUrl(context, config.healthProcedure(1)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureSpecializedCare,
                onTap: () => _launchExternalUrl(context, config.healthProcedure(2)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataHealthInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkSescam,
                onTap: () => _launchExternalUrl(context, config.sescamUrl),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkDigitalHealth,
                onTap: () => _launchExternalUrl(context, config.digitalHealthUrl),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkClinicalHistory,
                onTap: () => _launchExternalUrl(context, config.clinicalHistoryUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchExternalUrl(final BuildContext context, final Uri url) async {
    await launchExternalUrlWithConfirmation(context, url);
  }
}

class _CipText extends StatelessWidget {
  const _CipText({required this.cip});

  final String? cip;

  @override
  Widget build(final BuildContext context) {
    final value = cip?.trim();
    final label = value == null || value.isEmpty ? 'CIP: -' : 'CIP: $value';

    return Text(
      label,
      style: AppTypography.captionRegular.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
      ),
    );
  }
}

class _AppointmentsContent extends StatelessWidget {
  const _AppointmentsContent({
    required this.entries,
    required this.emptyMessage,
    required this.l10n,
  });

  final List<_AppointmentEntry> entries;
  final String emptyMessage;
  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    if (entries.isEmpty) {
      return MyDataNoData(
        message: emptyMessage,
        actionLabel: l10n.myDataNoDataContact,
        contactUrl: 'https://sanidad.castillalamancha.es/ciudadanos',
        scrollable: false,
      );
    }

    final sections = _buildSections(entries);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final yearSection in sections) ...[
          Text(
            yearSection.year.toString(),
            style: AppTypography.h2.copyWith(
              color: AppColors.textBase,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          for (final monthSection in yearSection.months) ...[
            Text(
              l10n.commonMonthName(_monthKey(monthSection.month)),
              style: AppTypography.h3.copyWith(
                color: AppColors.textBase,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            for (final entry in monthSection.entries) ...[
              entry.card,
              const SizedBox(height: AppDimensions.space12),
            ],
          ],
        ],
      ],
    );
  }

  List<_AppointmentYearSection> _buildSections(final List<_AppointmentEntry> entries) {
    final yearSections = <int, Map<int, List<_AppointmentEntry>>>{};
    for (final entry in entries) {
      final date = entry.dateTime;
      yearSections.putIfAbsent(date.year, () => <int, List<_AppointmentEntry>>{});
      yearSections[date.year]!.putIfAbsent(date.month, () => <_AppointmentEntry>[]);
      yearSections[date.year]![date.month]!.add(entry);
    }

    return yearSections.entries
        .map(
          (final yearEntry) => _AppointmentYearSection(
            year: yearEntry.key,
            months: yearEntry.value.entries
                .map(
                  (final monthEntry) => _AppointmentMonthSection(
                    month: monthEntry.key,
                    entries: monthEntry.value,
                  ),
                )
                .toList(growable: false),
          ),
        )
        .toList(growable: false);
  }
}

class _HealthErrorState extends StatelessWidget {
  const _HealthErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MyDataServiceUnavailable(
      message: l10n.myDataHealthAppointmentsServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: onRetry,
      scrollable: false,
    );
  }
}

class _HealthCipMissingState extends StatelessWidget {
  const _HealthCipMissingState();

  @override
  Widget build(final BuildContext context) {
    return AppAlertContextual(
      message: AppLocalizations.of(context).agendaHealthCipMissing,
      size: AppAlertContextualSize.small,
      announce: true,
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final HealthAppointment appointment;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = appointment.dateTime;
    final detail = appointment.modality ?? appointment.center ?? '';
    final channel = appointment.channel?.trim();
    final isPhone = detail.toLowerCase().contains('teleconsulta') || detail.toLowerCase().contains('telef');

    return AppAgendaInfoCard(
      type: AppAgendaInfoCardType.health,
      day: date.day.toString(),
      weekday: l10n.commonWeekdayName(_weekdayKey(date.weekday)),
      time: '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
      title: appointment.description,
      channel: channel != null && channel.isNotEmpty ? channel : (isPhone ? l10n.agendaChannelPhone : l10n.agendaChannelInPerson),
      primaryText: appointment.professional,
      secondaryText: detail,
    );
  }
}

class _HospitalAppointmentCard extends StatelessWidget {
  const _HospitalAppointmentCard({required this.appointment});

  final HospitalAppointment appointment;

  @override
  Widget build(final BuildContext context) {
    final location = [appointment.room, appointment.center].nonNulls.where((final value) => value.isNotEmpty).join(' · ');

    return _AppointmentCardShell(
      dateTime: appointment.dateTime,
      heading: appointment.service.toUpperCase(),
      title: appointment.agendaDescription ?? appointment.provision,
      lines: [
        appointment.provision,
        location,
      ],
    );
  }
}

/// Tarjeta de cita: raíl de fecha a la izquierda y detalle a la derecha.
///
/// Presenta el detalle de las citas hospitalarias.
class _AppointmentCardShell extends StatelessWidget {
  const _AppointmentCardShell({
    required this.dateTime,
    required this.heading,
    required this.title,
    required this.lines,
  });

  final DateTime dateTime;

  /// Servicio hospitalario en mayúsculas junto a la hora.
  final String heading;
  final String title;
  final List<String> lines;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderBlueMutedLight),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 78,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppColors.borderBlueMutedLight,
                    width: 4,
                  ),
                  right: BorderSide(color: AppColors.backgroundBlueMutedLight),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space12,
                vertical: AppDimensions.space16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dateTime.day.toString(),
                    style: AppTypography.h1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).commonWeekdayName(_weekdayKey(dateTime.weekday)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.captionRegular.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.space8,
                  AppDimensions.space16,
                  AppDimensions.space8,
                  AppDimensions.space16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatTime(dateTime),
                          style: AppTypography.smallRegular.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space16),
                        Flexible(
                          child: Text(
                            heading,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.captionUppercase.copyWith(
                              color: AppColors.borderBlueMutedBase,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      title,
                      style: AppTypography.bodyBold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space4),
                    for (final line in lines)
                      Text(
                        line,
                        style: AppTypography.smallRegular.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentEntry {
  const _AppointmentEntry({
    required this.dateTime,
    required this.card,
  });

  final DateTime dateTime;
  final Widget card;
}

class _AppointmentYearSection {
  const _AppointmentYearSection({
    required this.year,
    required this.months,
  });

  final int year;
  final List<_AppointmentMonthSection> months;
}

class _AppointmentMonthSection {
  const _AppointmentMonthSection({
    required this.month,
    required this.entries,
  });

  final int month;
  final List<_AppointmentEntry> entries;
}

String _formatTime(final DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:${minute}h';
}

String _weekdayKey(final int weekday) => switch (weekday) {
  DateTime.monday => 'monday',
  DateTime.tuesday => 'tuesday',
  DateTime.wednesday => 'wednesday',
  DateTime.thursday => 'thursday',
  DateTime.friday => 'friday',
  DateTime.saturday => 'saturday',
  DateTime.sunday => 'sunday',
  _ => 'other',
};

String _monthKey(final int month) => switch (month) {
  1 => 'january',
  2 => 'february',
  3 => 'march',
  4 => 'april',
  5 => 'may',
  6 => 'june',
  7 => 'july',
  8 => 'august',
  9 => 'september',
  10 => 'october',
  11 => 'november',
  12 => 'december',
  _ => 'other',
};
