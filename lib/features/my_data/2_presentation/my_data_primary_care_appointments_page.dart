import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/controllers/past_primary_care_appointments_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_appointment_date_filter.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_appointment_sections.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Citas de atención primaria.
///
/// Sale de la pantalla de Salud, que pasa a ser un menú de dos opciones al
/// mismo nivel —primaria y hospitalaria—, en vez de mostrar una de las dos
/// consultas directamente y enlazar la otra.
///
/// **No cambia de comportamiento al mudarse**: mismas pestañas, misma
/// paginación de pasadas, mismo filtro y mismos estados. Y **sin gate por
/// `authNLevel`**: ese requisito es solo de hospitalaria, y aplicarlo aquí
/// rompería una consulta que hoy funciona con cualquier nivel.
class MyDataPrimaryCareAppointmentsPage extends ConsumerStatefulWidget {
  const MyDataPrimaryCareAppointmentsPage({super.key});

  @override
  ConsumerState<MyDataPrimaryCareAppointmentsPage> createState() => _MyDataPrimaryCareAppointmentsPageState();
}

/// Distancia al final del listado, en píxeles, a la que se pide la página
/// siguiente de citas pasadas.
const double _loadMoreScrollThreshold = 240;

/// Listado de centros del SESCAM: es el enlace de «más información» de la hoja
/// informativa y también el de contacto cuando no hay citas.
const String _healthCentersUrl = 'https://sanidad.castillalamancha.es/ciudadanos/listado-de-centros';

class _MyDataPrimaryCareAppointmentsPageState extends ConsumerState<MyDataPrimaryCareAppointmentsPage> {
  HealthAppointmentFilter _filter = HealthAppointmentFilter.pending;
  AppListFilters _filters = const AppListFilters();

  /// Sólo las citas pasadas se paginan: es la única operación del gateway que
  /// acepta el parámetro `pagina`.
  bool get _isPaginated => _filter == HealthAppointmentFilter.past;

  Future<void> _showFilters() async {
    final result = await showMyDataAppointmentDateFilter(
      context: context,
      sheetTitle: AppLocalizations.of(context).myDataHealthFilterPrimaryCareTitle,
      initialFilters: _filters,
    );
    if (result != null && mounted) {
      setState(() => _filters = result);
    }
  }

  Future<void> _showInfoSheet() async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataHealthInfoSheetTitle,
      bodyText: l10n.myDataHealthInfoSheetDescription,
      footerText: l10n.myDataHealthInfoSheetContactHint,
      actionLabel: l10n.myDataHealthInfoSheetMoreInformation,
      actionIcon: AppIcons.openInNew,
      actionIsExternalLink: true,
      onActionPressed: () => launchExternalUrlWithConfirmation(context, Uri.parse(_healthCentersUrl)),
    );
  }

  void _openConsentSettings() {
    unawaited(
      context.push(
        Uri(
          path: Routes.consent,
          queryParameters: const {
            'mode': 'preferences',
            'returnTo': Routes.myDataHealthPrimaryCareAppointments,
          },
        ).toString(),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authorizationAsync = ref.watch(jccmDataAuthorizationProvider);

    return AppDetailScaffold(
      title: l10n.myDataHealthAppointmentsTitle,
      onBack: () => context.go(Routes.myDataHealth),
      onInfo: _showInfoSheet,
      actions: [
        myDataAppointmentDateFilterAction(context: context, filters: _filters, onPressed: _showFilters),
      ],
      body: NotificationListener<ScrollNotification>(
        onNotification: (final notification) {
          if (_isPaginated && notification.metrics.axis == Axis.vertical && notification.metrics.extentAfter <= _loadMoreScrollThreshold) {
            unawaited(ref.read(pastPrimaryCareAppointmentsProvider.notifier).loadMore());
          }
          return false;
        },
        child: SingleChildScrollView(
          padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
          child: authorizationAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(top: AppDimensions.space24),
              child: Center(child: AppLoadingIndicator()),
            ),
            // Fallo del check ≠ «no autorizado»: sin respuesta del backend solo
            // cabe error + reintentar, nunca pedir re-autorizar un
            // consentimiento que puede estar concedido.
            error: (final _, final _) => ErrorStateWidget(
              message: l10n.authorizationCheckFailedMessage,
              onRetry: () => ref.invalidate(jccmDataAuthorizationProvider),
            ),
            data: (final hasJccmAuthorization) {
              if (!hasJccmAuthorization) {
                return MyDataAuthorizationContextualHelper(onOpenSettings: _openConsentSettings, message: l10n.myDataHealthAppointmentsAuthorizationRequiredMessage, semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSegmentedControl(
                    segments: [l10n.myDataHealthPendingTab, l10n.myDataHealthPastTab],
                    selectedIndex: _filter == HealthAppointmentFilter.pending ? 0 : 1,
                    onSelected: (final index) => setState(
                      () => _filter = index == 0 ? HealthAppointmentFilter.pending : HealthAppointmentFilter.past,
                    ),
                    semanticLabel: l10n.myDataHealthAppointmentsTitle,
                  ),
                  const SizedBox(height: AppDimensions.space20),
                  if (_isPaginated)
                    _PastAppointmentsList(filters: _filters, onOpenConsentSettings: _openConsentSettings)
                  else
                    _PendingAppointmentsList(filters: _filters, onOpenConsentSettings: _openConsentSettings),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Citas pendientes, que se resuelven en una sola llamada.
class _PendingAppointmentsList extends ConsumerWidget {
  const _PendingAppointmentsList({required this.filters, required this.onOpenConsentSettings});

  final AppListFilters filters;
  final VoidCallback onOpenConsentSettings;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return ref.watch(myDataPrimaryCarePendingAppointmentsProvider).when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: AppDimensions.space24),
        child: Center(child: AppLoadingIndicator()),
      ),
      error: (final error, final _) => switch (error) {
        MyDataAuthorizationRequired() => MyDataAuthorizationContextualHelper(onOpenSettings: onOpenConsentSettings, message: l10n.myDataHealthAppointmentsAuthorizationRequiredMessage, semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta),
        MyDataHealthCipMissing() => const _HealthCipMissingState(),
        _ => _HealthErrorState(onRetry: () => ref.invalidate(myDataPrimaryCarePendingAppointmentsProvider)),
      },
      data: (final appointments) => MyDataAppointmentSections(
        entries: _entries(appointments, filters),
        emptyMessage: l10n.myDataHealthAppointmentsNoDataMessage,
      ),
    );
  }
}

/// Citas pasadas, acumuladas por páginas.
///
/// El scroll dispara la carga automáticamente, pero el botón se mantiene
/// visible mientras queden páginas: es el único camino accesible por teclado y
/// lector de pantalla, y también rescata el caso en el que el filtro de fechas
/// deja la lista tan corta que no hay scroll que disparar.
class _PastAppointmentsList extends ConsumerWidget {
  const _PastAppointmentsList({required this.filters, required this.onOpenConsentSettings});

  final AppListFilters filters;
  final VoidCallback onOpenConsentSettings;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(pastPrimaryCareAppointmentsProvider);

    switch (state.status) {
      case PastPrimaryCareAppointmentsStatus.loading:
        return const Padding(
          padding: EdgeInsets.only(top: AppDimensions.space24),
          child: Center(child: AppLoadingIndicator()),
        );
      case PastPrimaryCareAppointmentsStatus.authorizationRequired:
        return MyDataAuthorizationContextualHelper(onOpenSettings: onOpenConsentSettings, message: l10n.myDataHealthAppointmentsAuthorizationRequiredMessage, semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta);
      case PastPrimaryCareAppointmentsStatus.cipMissing:
        return const _HealthCipMissingState();
      case PastPrimaryCareAppointmentsStatus.loadError:
        return _HealthErrorState(
          onRetry: () => unawaited(ref.read(pastPrimaryCareAppointmentsProvider.notifier).retry()),
        );
      case PastPrimaryCareAppointmentsStatus.loaded:
        final entries = _entries(state.appointments, filters);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Con páginas pendientes no se afirma que no hay citas: puede que
            // simplemente no se hayan cargado todavía.
            if (entries.isNotEmpty || !state.hasMore)
              MyDataAppointmentSections(
                entries: entries,
                emptyMessage: l10n.myDataHealthAppointmentsNoDataMessage,
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

List<MyDataAppointmentEntry> _entries(final List<HealthAppointment> appointments, final AppListFilters filters) {
  final range = filters.range(myDataAppointmentDateFilterFieldId);
  return [
    for (final appointment in appointments)
      if (appFilterDateInRange(appointment.dateTime, range))
        (dateTime: appointment.dateTime, card: _AppointmentCard(appointment: appointment)),
  ];
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final HealthAppointment appointment;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = appointment.dateTime;
    final detail = appointment.description;
    final channel = appointment.channel?.trim();
    final isPhone = detail.toLowerCase().contains('teleconsulta') || detail.toLowerCase().contains('telef');

    return AppAgendaInfoCard(
      type: AppAgendaInfoCardType.health,
      day: date.day.toString(),
      weekday: l10n.commonWeekdayName(weekdayKey(date.weekday)),
      time: '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
      title: appointment.professional,
      channel: channel != null && channel.isNotEmpty ? channel : (isPhone ? l10n.agendaChannelPhone : l10n.agendaChannelInPerson),
      showTypeIcon: false,
      channelBeforeTitle: true,
      titleIsRegular: true,
      secondaryText: detail,
    );
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
