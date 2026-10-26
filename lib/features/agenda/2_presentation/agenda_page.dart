import 'dart:async' show unawaited;
import 'dart:ui' show SemanticsRole;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show OrdinalSortKey;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointments_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/usecases/refresh_agenda_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_elevation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/identity_verification_prompt.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment_access.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Agency agenda screen — Figma node 43716:12909.
class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  _AgendaFilter _selectedFilter = _AgendaFilter.all;
  bool _refreshing = false;

  /// La elevación en curso la pidió esta pantalla. El desenlace es una señal
  /// de un solo uso: sin esta marca, Agenda se lo quitaría a Mis datos.
  bool _elevationRequested = false;

  /// Pide al backend que consulte los sistemas origen (`eventos/refrescar`) y
  /// después recarga los eventos. Si el refresco falla se recarga igualmente
  /// —el usuario pidió actualizar y los datos cacheados pueden haber cambiado—
  /// pero se le avisa: sin el aviso, el «Actualizado el …» recién estampado
  /// afirmaba frescura sobre datos que los sistemas origen no refrescaron.
  Future<void> _refreshAgenda() async {
    if (_refreshing) {
      return;
    }
    setState(() => _refreshing = true);
    try {
      final agentId = ref.read(citizenEndpointIdsProvider).idAgente;
      if (agentId != null && agentId.isNotEmpty) {
        final result = await ref.read(refreshAgendaEventsUsecaseProvider).execute(agentId: agentId);
        if (result case RefreshAgendaEventsFailed(:final message, :final cause)) {
          logger.e('Agenda refresh failed: $message', error: cause);
          if (mounted) {
            AppAlertSnackbar.show(
              context,
              message: AppLocalizations.of(context).agendaRefreshFailedMessage,
              severity: AppAlertSeverity.error,
            );
          }
        }
      }
    } finally {
      if (mounted) {
        setState(() => _refreshing = false);
        ref.invalidate(agendaAppointmentsProvider);
      }
    }
  }

  Future<void> _openJccmAuthorization() async {
    await context.push<void>(
      Uri(
        path: Routes.consent,
        queryParameters: const {
          'mode': 'preferences',
          'returnTo': Routes.agenda,
        },
      ).toString(),
    );
    if (mounted) {
      ref
        ..invalidate(jccmDataAuthorizationProvider)
        ..invalidate(agendaAppointmentsProvider);
    }
  }

  Future<void> _showInfoSheet() async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.agendaInfoSheetTitle,
      bodyText: l10n.agendaInfoSheetBody,
      footerText: l10n.agendaInfoSheetFooter,
      actionLabel: l10n.agendaInfoSheetMoreInformation,
      actionIcon: Icons.north_east,
      // Lleva a Ayuda y contacto, dentro de la app: no es un enlace externo.
      onActionPressed: () {
        Navigator.of(context).pop();
        unawaited(context.push<void>(Routes.helpContact));
      },
    );
  }

  /// Explica por qué hace falta verificar y, si el ciudadano acepta, lanza la
  /// elevación con Cl@ve. [message] es el motivo de un intento anterior.
  Future<void> _verifyIdentity({final String? message}) async {
    final accepted = await confirmIdentityVerification(context, ref, message: message);
    if (!accepted || !mounted) {
      return;
    }
    _elevationRequested = true;
    final notifier = ref.read(elevationProvider.notifier)..acknowledge();
    // El notifier lleva su propia guarda de reentrada y traza sus fallos.
    unawaited(notifier.elevate(minimum: kHospitalAppointmentsMinimumLevel));
  }

  /// Desenlace de una elevación pedida desde aquí. Con éxito, la agenda se
  /// vuelve a pedir sola (su provider observa el nivel) y el aviso desaparece.
  void _handleElevationOutcome(final ElevationOutcome outcome) {
    _elevationRequested = false;
    ref.read(elevationProvider.notifier).acknowledge();
    final l10n = AppLocalizations.of(context);
    switch (outcome) {
      case ElevationOutcome.succeeded:
        AppAlertSnackbar.show(context, message: l10n.identityVerificationCompletedMessage, severity: AppAlertSeverity.success);
      case ElevationOutcome.stillInsufficient:
        unawaited(_verifyIdentity(message: l10n.myDataHealthLevelStillInsufficientMessage));
      case ElevationOutcome.failed:
        unawaited(_verifyIdentity(message: l10n.myDataHealthLevelElevationFailedMessage));
      // Otra persona: la sesión ya es suya y entra como en un login nuevo.
      case ElevationOutcome.identitySwitched:
        AppAlertSnackbar.show(context, message: l10n.identityVerificationSwitchedMessage);
        context.go(Routes.home);
      // Cancelar deja el aviso donde estaba.
      case ElevationOutcome.cancelled:
        break;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final agenda = ref.watch(agendaAppointmentsProvider);
    final l10n = AppLocalizations.of(context);
    ref.listen<ElevationState>(elevationProvider, (final previous, final next) {
      final outcome = next.outcome;
      if (!_elevationRequested || outcome == null || outcome == previous?.outcome) {
        return;
      }
      _handleElevationOutcome(outcome);
    });

    return Scaffold(
      appBar: AppNavBar(
        title: l10n.agendaPageTitle,
        isLoggedIn: true,
        showNotifications: false,
        actions: [
          IconButton(
            constraints: const BoxConstraints.tightFor(
              width: AppDimensions.minTouchTarget,
              height: AppDimensions.minTouchTarget,
            ),
            icon: const AppIcon(AppIcons.info, color: AppColors.textPrimary),
            onPressed: () => unawaited(_showInfoSheet()),
            tooltip: l10n.agendaInfoTooltip,
          ),
        ],
        profileInitials: authenticatedProfileInitials(ref),
        showLeading: false,
        onAvatarTap: () => showAuthenticatedProfileMenu(context: context, ref: ref),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (final context, final constraints) => SingleChildScrollView(
              padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight > AppDimensions.space48 ? constraints.maxHeight - AppDimensions.space48 : 0,
                ),
                child: agenda.when(
                  data: _buildLoadedContent,
                  loading: _buildLoadingContent,
                  error: (final error, final stackTrace) => _buildErrorContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedContent(final AgendaAppointmentsState state) {
    final appointments = _selectedFilter.apply(state.appointments);
    final eventDates = state.appointments.map((final appointment) => DateUtils.dateOnly(appointment.dateTime)).toSet();
    final sections = _buildSections(appointments);
    final initialDate = appointments.isEmpty ? DateTime.now() : appointments.first.dateTime;
    final showEmptyState = state.hasJccmAuthorization && appointments.isEmpty && !(state.appointments.isEmpty && (state.isPartial || state.healthCipMissing));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          onSelected: state.hasJccmAuthorization ? (final filter) => setState(() => _selectedFilter = filter) : null,
        ),
        // Todos los avisos de Agenda se muestran antes del calendario: así
        // quedan junto a los filtros que contextualizan lo que el ciudadano
        // está viendo, sin interrumpir la lectura de las citas.
        if (!state.hasJccmAuthorization) ...[
          const SizedBox(height: AppDimensions.space8),
          MyDataAuthorizationContextualHelper(
            onOpenSettings: () => unawaited(_openJccmAuthorization()),
          ),
        ],
        // Un aviso por fuente caída, en el orden del enum para que no dependa
        // de la iteración del `Set`.
        for (final source in AgendaAppointmentSource.values.where(state.failedSources.contains)) ...[
          const SizedBox(height: AppDimensions.space8),
          _AgendaPartialLoadNotice(source: source),
        ],
        // Con la agenda sin autorizar, el aviso de consentimiento va primero y
        // este esperaría: verificar no serviría de nada todavía.
        if (state.hasJccmAuthorization && state.hospitalAppointmentsLocked) ...[
          const SizedBox(height: AppDimensions.space8),
          _AgendaHospitalLockedNotice(
            isVerifying: ref.watch(elevationProvider.select((final elevation) => elevation.isElevating)),
            onVerify: () => unawaited(_verifyIdentity()),
          ),
        ],
        if (state.healthCipMissing) ...[
          const SizedBox(height: AppDimensions.space8),
          const _AgendaHealthCipMissingNotice(),
        ],
        if (showEmptyState) ...[
          const SizedBox(height: AppDimensions.space8),
          const _AgendaEmptyState(),
        ],
        const SizedBox(height: AppDimensions.space8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: AppCalendar(
            key: ValueKey('${_selectedFilter.name}-${initialDate.year}-${initialDate.month}'),
            initialDate: initialDate,
            eventDates: eventDates,
            // «Calendario» es una sección de la pantalla (WCAG 1.3.1).
            headingLevel: 2,
          ),
        ),
        if (state.hasJccmAuthorization) ...[
          const SizedBox(height: AppDimensions.space8),
          _LastUpdateRow(
            updatedAt: state.updatedAt,
            onRefresh: _refreshing ? null : () => unawaited(_refreshAgenda()),
          ),
        ],
        const SizedBox(height: AppDimensions.space12),
        if (!state.hasJccmAuthorization)
          const SizedBox.shrink()
        // Con la carga a medias y nada cargado, "no hay citas" sería mentira:
        // el aviso de arriba es el único mensaje. Se mira `state.appointments`
        // y no la lista filtrada, para que un filtro sin resultados sí siga
        // diciendo que ese periodo está vacío.
        else if (appointments.isEmpty && state.appointments.isEmpty && (state.isPartial || state.healthCipMissing))
          const SizedBox.shrink()
        else if (appointments.isEmpty)
          const SizedBox.shrink()
        else ...[
          Semantics(
            header: true,
            headingLevel: 2,
            child: Text(
              AppLocalizations.of(context).agendaPendingAppointmentsTitle,
              style: AppTypography.h2.copyWith(color: AppColors.textBase),
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          for (final section in sections) ...[
            _AgendaSection(section: section),
            const SizedBox(height: AppDimensions.space16),
          ],
        ],
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterNavigation(selectedFilter: _selectedFilter),
        const SizedBox(height: AppDimensions.space32),
        const Center(child: AppLoadingIndicator()),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          onSelected: (final filter) => setState(() => _selectedFilter = filter),
        ),
        const SizedBox(height: AppDimensions.space8),
        _AgendaErrorState(
          onRetry: () => ref.invalidate(agendaAppointmentsProvider),
        ),
        const SizedBox(height: AppDimensions.space8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: const AppCalendar(headingLevel: 2),
        ),
      ],
    );
  }

  List<_AgendaMonthSection> _buildSections(final List<AgendaAppointment> appointments) {
    final l10n = AppLocalizations.of(context);
    final sections = <String, _AgendaMonthSection>{};
    for (final appointment in appointments) {
      final date = appointment.dateTime;
      final key = '${date.year}-${date.month}';
      sections.putIfAbsent(
        key,
        () => _AgendaMonthSection(
          year: date.year.toString(),
          month: l10n.commonMonthName(_monthKey(date.month)),
          appointments: [],
        ),
      );
      sections[key]!.appointments.add(appointment);
    }
    return sections.values.toList(growable: false);
  }
}

class _FilterNavigation extends StatelessWidget {
  const _FilterNavigation({
    required this.selectedFilter,
    this.onSelected,
  });

  final _AgendaFilter selectedFilter;
  final ValueChanged<_AgendaFilter>? onSelected;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: AppFloatingNavigation(
        tabs: _AgendaFilter.values.map((final filter) => filter.label(l10n)).toList(growable: false),
        selectedIndex: selectedFilter.index,
        onTabSelected: (final index) => onSelected?.call(_AgendaFilter.values[index]),
      ),
    );
  }
}

class _LastUpdateRow extends StatelessWidget {
  const _LastUpdateRow({
    required this.updatedAt,
    required this.onRefresh,
  });

  final DateTime updatedAt;
  final VoidCallback? onRefresh;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              // Icono decorativo: el texto ya dice qué es. Texto e icono usan
              // el color secundario de texto, que supera 4,5:1 sobre el fondo
              // de la Agenda (WCAG 1.4.3); el gris azulado anterior se quedaba
              // en 3,8:1.
              const ExcludeSemantics(
                child: AppIcon(
                  AppIcons.autorenew,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Text(
                  _formatUpdateDate(l10n, updatedAt),
                  style: AppTypography.smallRegular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: AppDimensions.minTouchTarget,
          height: AppDimensions.minTouchTarget,
          decoration: BoxDecoration(
            color: AppColors.secondaryLight100,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            boxShadow: AppShadows.low,
          ),
          child: AppFocusRing(
            enabled: onRefresh != null,
            child: IconButton(
              icon: const AppIcon(AppIcons.autorenew, color: AppColors.textPrimary),
              onPressed: onRefresh,
              tooltip: l10n.agendaRefreshTooltip,
            ),
          ),
        ),
      ],
    );
  }
}

class _AgendaSection extends StatelessWidget {
  const _AgendaSection({required this.section});

  final _AgendaMonthSection section;

  @override
  Widget build(final BuildContext context) {
    final monthYear = '${section.month} de ${section.year}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          headingLevel: 3,
          label: monthYear,
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
                  child: Text(
                    section.year,
                    style: AppTypography.h2.copyWith(color: AppColors.textBase),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppDimensions.space4,
                    bottom: AppDimensions.space8,
                  ),
                  child: Text(
                    section.month,
                    style: AppTypography.h3.copyWith(color: AppColors.textBase),
                  ),
                ),
              ],
            ),
          ),
        ),
        Semantics(
          role: SemanticsRole.list,
          container: true,
          explicitChildNodes: true,
          child: Column(
            children: [
              for (final (index, appointment) in section.appointments.indexed) ...[
                Semantics(
                  role: SemanticsRole.listItem,
                  sortKey: OrdinalSortKey(index.toDouble()),
                  child: _AgendaAppointmentCard(appointment: appointment),
                ),
                if (index < section.appointments.length - 1) const SizedBox(height: AppDimensions.space8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AgendaAppointmentCard extends StatelessWidget {
  const _AgendaAppointmentCard({required this.appointment});

  final AgendaAppointment appointment;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = appointment.dateTime;
    // Un evento cuyo mensaje llega por párrafos etiquetados se pinta como en
    // la web: título del evento, intro y una fila por etiqueta (JCCMEC-256).
    // Las citas de SESCAM conservan la jerarquía de Figma, sin el centro
    // (JCCMEC-274).
    final hasStructuredDetails = appointment.details.isNotEmpty;
    final isHealthLayout = appointment.kind == AgendaAppointmentKind.health && !hasStructuredDetails;
    final legacyDetail = appointment.detail ?? appointment.center?.trim() ?? '';
    final String? secondaryText;
    if (hasStructuredDetails || appointment.kind == AgendaAppointmentKind.credential) {
      secondaryText = null;
    } else if (isHealthLayout) {
      secondaryText = appointment.detail;
    } else {
      secondaryText = legacyDetail;
    }

    return AppAgendaInfoCard(
      type: switch (appointment.kind) {
        AgendaAppointmentKind.notification => AppAgendaInfoCardType.notification,
        AgendaAppointmentKind.health || AgendaAppointmentKind.hospital => AppAgendaInfoCardType.health,
        AgendaAppointmentKind.credential => AppAgendaInfoCardType.credential,
      },
      day: date.day.toString(),
      weekday: l10n.commonWeekdayName(_weekdayKey(date.weekday)),
      time: appointment.kind == AgendaAppointmentKind.credential ? null : _formatAppointmentTime(date),
      title: isHealthLayout ? appointment.description : appointment.title,
      channel: isHealthLayout ? _appointmentChannel(l10n, appointment.channel, legacyDetail) : null,
      primaryText: isHealthLayout ? appointment.title : appointment.description,
      secondaryText: secondaryText,
      details: appointment.details,
    );
  }
}

class _AgendaEmptyState extends StatelessWidget {
  const _AgendaEmptyState();

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space24),
      child: Text(
        AppLocalizations.of(context).agendaEmptyAppointments,
        style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

/// Aviso de carga parcial: la agenda se pinta igual, pero nombra la fuente que
/// no ha respondido. Sin acción propia — la fila "Actualizado el…" justo
/// encima ya ofrece el refresco.
class _AgendaPartialLoadNotice extends StatelessWidget {
  const _AgendaPartialLoadNotice({required this.source});

  final AgendaAppointmentSource source;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppAlertContextual(
      message: switch (source) {
        AgendaAppointmentSource.health => l10n.agendaHealthAppointmentsUnavailable,
        AgendaAppointmentSource.general => l10n.agendaEventsUnavailable,
      },
      severity: AppAlertSeverity.warning,
      size: AppAlertContextualSize.small,
      // Aparece después de cargar, no junto con la pantalla.
      announce: true,
    );
  }
}

class _AgendaHealthCipMissingNotice extends StatelessWidget {
  const _AgendaHealthCipMissingNotice();

  @override
  Widget build(final BuildContext context) {
    return AppAlertContextual(
      message: AppLocalizations.of(context).agendaHealthCipMissing,
      size: AppAlertContextualSize.small,
      announce: true,
    );
  }
}

/// Aviso de citas hospitalarias ocultas — Figma 45049:59928.
///
/// Solo se pinta cuando el nivel de la sesión no alcanza el que exigen las
/// citas hospitalarias; con nivel suficiente no hay nada que avisar (Figma
/// 45049:60339). «Verificar» lleva a Cl@ve, fuera de la app, de ahí el icono.
class _AgendaHospitalLockedNotice extends StatelessWidget {
  const _AgendaHospitalLockedNotice({required this.isVerifying, required this.onVerify});

  final bool isVerifying;
  final VoidCallback onVerify;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final usesLargeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final message = Row(
      children: [
        const ExcludeSemantics(child: AppIcon(AppIcons.lock, color: AppColors.primaryDark)),
        const SizedBox(width: AppDimensions.space8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                headingLevel: 2,
                child: Text(
                  l10n.agendaHospitalLockedTitle,
                  style: AppTypography.bodyRegular.copyWith(color: AppColors.primaryDark),
                ),
              ),
              Text(
                l10n.agendaHospitalLockedBody,
                style: AppTypography.smallRegular.copyWith(color: AppColors.primaryDark),
              ),
            ],
          ),
        ),
      ],
    );
    final button = AppButton(
      label: l10n.agendaHospitalLockedAction,
      size: AppButtonSize.small,
      trailingIcon: AppIcons.openInNew,
      isExternalLink: true,
      isLoading: isVerifying,
      onPressed: onVerify,
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space4, vertical: AppDimensions.space8),
        child: usesLargeText
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  message,
                  const SizedBox(height: AppDimensions.space8),
                  Align(alignment: AlignmentDirectional.centerEnd, child: button),
                ],
              )
            : Row(
                children: [
                  Expanded(child: message),
                  const SizedBox(width: AppDimensions.space8),
                  button,
                ],
              ),
      ),
    );
  }
}

class _AgendaErrorState extends StatelessWidget {
  const _AgendaErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Mismo tratamiento visual que el resto de errores de servicio de la app.
    return AppAlertContextual(
      message: l10n.agendaError,
      action: AppButton(
        label: l10n.agendaParseErrorRetry,
        hierarchy: AppButtonHierarchy.tertiary,
        trailingIcon: AppIcons.autorenew,
        onPressed: onRetry,
      ),
    );
  }
}

class _AgendaMonthSection {
  _AgendaMonthSection({
    required this.year,
    required this.month,
    required this.appointments,
  });

  final String year;
  final String month;
  final List<AgendaAppointment> appointments;
}

enum _AgendaFilter {
  all,
  next7Days(days: 7),
  next30Days(days: 30),
  next365Days(days: 365);

  const _AgendaFilter({
    this.days,
  });

  final int? days;

  String label(final AppLocalizations l10n) => switch (this) {
    _AgendaFilter.all => l10n.agendaFilterAll,
    _AgendaFilter.next7Days || _AgendaFilter.next30Days || _AgendaFilter.next365Days => l10n.agendaFilterDays(days!),
  };

  List<AgendaAppointment> apply(final List<AgendaAppointment> appointments) {
    final rangeDays = days;
    if (rangeDays == null) {
      return appointments;
    }

    final today = DateUtils.dateOnly(DateTime.now());
    final endDate = today.add(Duration(days: rangeDays));

    return appointments
        .where((final appointment) {
          final appointmentDate = DateUtils.dateOnly(appointment.dateTime);
          return !appointmentDate.isBefore(today) && !appointmentDate.isAfter(endDate);
        })
        .toList(growable: false);
  }
}

String _formatUpdateDate(final AppLocalizations l10n, final DateTime dateTime) {
  return l10n.commonUpdatedAt(
    dateTime.day,
    l10n.commonMonthShortName(_monthKey(dateTime.month)),
    dateTime.year,
    _formatAppointmentTime(dateTime),
  );
}

String _formatAppointmentTime(final DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _appointmentChannel(final AppLocalizations l10n, final String? channel, final String detail) {
  final trimmedChannel = channel?.trim();
  if (trimmedChannel != null && trimmedChannel.isNotEmpty) {
    return trimmedChannel;
  }

  final normalizedDetail = detail.toLowerCase();
  if (normalizedDetail.contains('teleconsulta') || normalizedDetail.contains('telef')) {
    return l10n.agendaChannelPhone;
  }

  return l10n.agendaChannelInPerson;
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
