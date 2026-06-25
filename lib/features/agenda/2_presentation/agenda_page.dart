import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';

/// Agency agenda screen — Figma node 43716:12909.
class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  _AgendaFilter _selectedFilter = _AgendaFilter.all;

  @override
  Widget build(final BuildContext context) {
    final agenda = ref.watch(agendaAppointmentsProvider);

    return Scaffold(
      appBar: AppNavBar(
        title: 'Agenda',
        isLoggedIn: true,
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
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          onSelected: (final filter) => setState(() => _selectedFilter = filter),
        ),
        const SizedBox(height: AppDimensions.space8),
        _LastUpdateRow(
          updatedAt: state.updatedAt,
          onRefresh: () => ref.invalidate(agendaAppointmentsProvider),
        ),
        const SizedBox(height: AppDimensions.space8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          child: AppCalendar(
            key: ValueKey('${_selectedFilter.name}-${initialDate.year}-${initialDate.month}'),
            initialDate: initialDate,
            eventDates: eventDates,
          ),
        ),
        const SizedBox(height: AppDimensions.space12),
        if (appointments.isEmpty)
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
    final sections = <String, _AgendaMonthSection>{};
    for (final appointment in appointments) {
      final date = appointment.dateTime;
      final key = '${date.year}-${date.month}';
      sections.putIfAbsent(
        key,
        () => _AgendaMonthSection(
          year: date.year.toString(),
          month: _monthName(date.month),
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
    return SizedBox(
      width: double.infinity,
      child: AppFloatingNavigation(
        tabs: _AgendaFilter.values.map((final filter) => filter.label).toList(growable: false),
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
  final VoidCallback onRefresh;

  @override
  Widget build(final BuildContext context) {
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
                  'Actualizado el ${_formatUpdateDate(updatedAt)}',
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
            tooltip: 'Actualizar agenda',
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
    final date = appointment.dateTime;
    final day = date.day.toString();
    final weekday = _weekdayName(date.weekday);
    final time = _formatTime(date);
    final detail = appointment.detail ?? appointment.center ?? '';
    final channel = _appointmentChannel(appointment.channel, detail);

    return Semantics(
      label: '$day $weekday, $time, $channel, ${appointment.title}, ${appointment.description}, $detail',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space8,
          vertical: AppDimensions.space16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            left: BorderSide(color: AppColors.borderBlueMutedLight, width: 4),
            top: BorderSide(color: AppColors.borderBlueMutedLight),
            right: BorderSide(color: AppColors.borderBlueMutedLight),
            bottom: BorderSide(color: AppColors.borderBlueMutedLight),
          ),
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.backgroundBlueMutedLight),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      weekday,
                      style: AppTypography.captionRegular.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          time,
                          style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: AppDimensions.space16),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                channel.toUpperCase(),
                                style: AppTypography.captionUppercase.copyWith(color: AppColors.borderBlueMutedBase),
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      appointment.title,
                      style: AppTypography.bodyBold.copyWith(color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      appointment.description,
                      style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (detail.isNotEmpty)
                      Text(
                        detail,
                        style: AppTypography.captionRegular.copyWith(color: AppColors.textPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
        'No hay citas para el periodo seleccionado.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No hemos podido cargar tu agenda.',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppDimensions.space8),
        AppButton(
          label: 'Intentar de nuevo',
          onPressed: onRetry,
          leadingIcon: AppIcons.autorenew,
        ),
      ],
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
  all(label: 'Todos'),
  next7Days(label: '7 días', days: 7),
  next30Days(label: '30 días', days: 30),
  next365Days(label: '365 dias', days: 365);

  const _AgendaFilter({
    required this.label,
    this.days,
  });

  final String label;
  final int? days;

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

String _formatUpdateDate(final DateTime dateTime) {
  return '${dateTime.day} ${_shortMonthName(dateTime.month)} ${dateTime.year} a las ${_formatTime(dateTime)}';
}

String _formatTime(final DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:${minute}h';
}

String _appointmentChannel(final String? channel, final String detail) {
  final trimmedChannel = channel?.trim();
  if (trimmedChannel != null && trimmedChannel.isNotEmpty) {
    return trimmedChannel;
  }

  final normalizedDetail = detail.toLowerCase();
  if (normalizedDetail.contains('teleconsulta') || normalizedDetail.contains('telef')) {
    return 'telefónica';
  }

  return 'presencial';
}

String _weekdayName(final int weekday) => switch (weekday) {
  DateTime.monday => 'Lunes',
  DateTime.tuesday => 'Martes',
  DateTime.wednesday => 'Miércoles',
  DateTime.thursday => 'Jueves',
  DateTime.friday => 'Viernes',
  DateTime.saturday => 'Sábado',
  DateTime.sunday => 'Domingo',
  _ => '',
};

String _monthName(final int month) => switch (month) {
  1 => 'enero',
  2 => 'febrero',
  3 => 'marzo',
  4 => 'abril',
  5 => 'mayo',
  6 => 'junio',
  7 => 'julio',
  8 => 'agosto',
  9 => 'septiembre',
  10 => 'octubre',
  11 => 'noviembre',
  12 => 'diciembre',
  _ => '',
};

String _shortMonthName(final int month) => switch (month) {
  1 => 'ene',
  2 => 'feb',
  3 => 'mar',
  4 => 'abr',
  5 => 'may',
  6 => 'jun',
  7 => 'jul',
  8 => 'ago',
  9 => 'sep',
  10 => 'oct',
  11 => 'nov',
  12 => 'dic',
  _ => '',
};
