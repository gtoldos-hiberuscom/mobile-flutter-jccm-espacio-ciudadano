import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
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

  /// Pide al backend que consulte los sistemas origen (`eventos/refrescar`) y
  /// después recarga los eventos. Si el refresco falla se recarga igualmente:
  /// el usuario pidió actualizar y los datos cacheados pueden haber cambiado.
  Future<void> _refreshAgenda() async {
    if (_refreshing) {
      return;
    }
    setState(() => _refreshing = true);
    try {
      final agentId = ref.read(citizenEndpointIdsProvider).idAgente;
      if (agentId != null && agentId.isNotEmpty) {
        await ref.read(refreshAgendaEventsUsecaseProvider).execute(agentId: agentId);
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

  @override
  Widget build(final BuildContext context) {
    final agenda = ref.watch(agendaAppointmentsProvider);

    return Scaffold(
      appBar: AppNavBar(
        title: AppLocalizations.of(context).agendaPageTitle,
        isLoggedIn: true,
        showNotifications: false,
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
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space16,
                AppDimensions.space24,
                AppDimensions.space16,
                AppDimensions.space24,
              ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.hasJccmAuthorization) ...[
          _FilterNavigation(
            selectedFilter: _selectedFilter,
            onSelected: (final filter) => setState(() => _selectedFilter = filter),
          ),
          const SizedBox(height: AppDimensions.space8),
        ] else ...[
          MyDataAuthorizationContextualHelper(
            onOpenSettings: () => unawaited(_openJccmAuthorization()),
          ),
          const SizedBox(height: AppDimensions.space8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: AppCalendar(
            key: ValueKey('${_selectedFilter.name}-${initialDate.year}-${initialDate.month}'),
            initialDate: initialDate,
            eventDates: eventDates,
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
        else if (appointments.isEmpty)
          const _AgendaEmptyState()
        else
          for (final section in sections) ...[
            _AgendaSection(section: section),
            const SizedBox(height: AppDimensions.space16),
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
        const SizedBox(height: AppDimensions.space32),
        _AgendaErrorState(
          onRetry: () => ref.invalidate(agendaAppointmentsProvider),
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
              const AppIcon(
                AppIcons.autorenew,
                color: AppColors.borderBlueMutedBase,
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Text(
                  _formatUpdateDate(l10n, updatedAt),
                  style: AppTypography.smallRegular.copyWith(
                    color: AppColors.borderBlueMutedBase,
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
          child: IconButton(
            icon: const AppIcon(AppIcons.autorenew, color: AppColors.textPrimary),
            onPressed: onRefresh,
            tooltip: l10n.agendaRefreshTooltip,
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
    return Column(
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
        for (final appointment in section.appointments) ...[
          _AgendaAppointmentCard(appointment: appointment),
          const SizedBox(height: AppDimensions.space8),
        ],
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
    final detail = appointment.detail ?? appointment.center ?? '';

    return AppAgendaInfoCard(
      type: switch (appointment.kind) {
        AgendaAppointmentKind.notification => AppAgendaInfoCardType.notification,
        AgendaAppointmentKind.health => AppAgendaInfoCardType.health,
        AgendaAppointmentKind.credential => AppAgendaInfoCardType.credential,
      },
      day: date.day.toString(),
      weekday: l10n.commonWeekdayName(_weekdayKey(date.weekday)),
      time: appointment.kind == AgendaAppointmentKind.credential ? null : _formatAppointmentTime(date),
      title: appointment.kind == AgendaAppointmentKind.health ? appointment.description : appointment.title,
      channel: appointment.kind == AgendaAppointmentKind.health ? _appointmentChannel(l10n, appointment.channel, detail) : null,
      primaryText: appointment.kind == AgendaAppointmentKind.health ? appointment.title : appointment.description,
      secondaryText: appointment.kind == AgendaAppointmentKind.credential ? null : detail,
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
  next365Days(days: 365)
  ;

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
