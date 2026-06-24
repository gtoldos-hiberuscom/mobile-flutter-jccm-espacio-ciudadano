import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Health data detail — Figma node 43973:1861.
class MyDataHealthPage extends ConsumerStatefulWidget {
  const MyDataHealthPage({super.key});

  @override
  ConsumerState<MyDataHealthPage> createState() => _MyDataHealthPageState();
}

class _MyDataHealthPageState extends ConsumerState<MyDataHealthPage> {
  _HealthTab _selectedTab = _HealthTab.data;
  HealthAppointmentFilter _selectedAppointmentFilter = HealthAppointmentFilter.pending;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataHealthTitle,
      onBack: () => context.go(Routes.myData),
      onInfo: () => _showHealthInfoSheet(context),
      tabs: [l10n.myDataHealthDataTab, l10n.myDataHealthServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _HealthTab.values[index]),
      tabViews: [
        _HealthAppointmentsTab(
          selectedAppointmentFilter: _selectedAppointmentFilter,
          onAppointmentFilterSelected: (final filter) => setState(() => _selectedAppointmentFilter = filter),
        ),
        const _HealthServicesTab(),
      ],
    );
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

class _HealthAppointmentsTab extends ConsumerWidget {
  const _HealthAppointmentsTab({
    required this.selectedAppointmentFilter,
    required this.onAppointmentFilterSelected,
  });

  final HealthAppointmentFilter selectedAppointmentFilter;
  final ValueChanged<HealthAppointmentFilter> onAppointmentFilterSelected;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authorizationAsync = ref.watch(jccmDataAuthorizationProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space24,
        AppDimensions.space16,
        AppDimensions.space24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myDataHealthAppointmentsTitle,
            style: AppTypography.h2.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.space24),
          authorizationAsync.when(
            data: (final hasJccmAuthorization) {
              if (!hasJccmAuthorization) {
                return MyDataAuthorizationContextualHelper(
                  onOpenSettings: () => _openSettings(context),
                );
              }

              final healthState = ref.watch(myDataHealthProvider(selectedAppointmentFilter));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CipText(cip: healthState.asData?.value.cip),
                  const SizedBox(height: AppDimensions.space16),
                  AppSegmentedControl(
                    segments: [l10n.myDataHealthPendingTab, l10n.myDataHealthPastTab],
                    selectedIndex: selectedAppointmentFilter == HealthAppointmentFilter.pending ? 0 : 1,
                    onSelected: (final index) => onAppointmentFilterSelected(
                      index == 0 ? HealthAppointmentFilter.pending : HealthAppointmentFilter.past,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space20),
                  healthState.when(
                    data: (final state) => _AppointmentsContent(
                      appointments: state.appointments,
                      l10n: l10n,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: AppDimensions.space24),
                      child: Center(child: AppLoadingIndicator()),
                    ),
                    error: (final error, final stackTrace) => _HealthErrorState(
                      onRetry: () => ref.invalidate(myDataHealthProvider(selectedAppointmentFilter)),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.only(top: AppDimensions.space24),
              child: Center(child: AppLoadingIndicator()),
            ),
            error: (final error, final stackTrace) => MyDataAuthorizationContextualHelper(
              onOpenSettings: () => _openSettings(context),
            ),
          ),
        ],
      ),
    );
  }

  void _openSettings(final BuildContext context) {
    context.go(
      Uri(
        path: Routes.consent,
        queryParameters: {
          'mode': 'preferences',
          'returnTo': Routes.myDataHealth,
        },
      ).toString(),
    );
  }
}

class _HealthServicesTab extends StatelessWidget {
  const _HealthServicesTab();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space24,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppExternalLinkSection(
            title: l10n.myDataHealthProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureComplaints,
                onTap: () => _showComingSoon(context, l10n.myDataHealthProcedureComplaints),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureHealthCard,
                onTap: () => _showComingSoon(context, l10n.myDataHealthProcedureHealthCard),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureSpecializedCare,
                onTap: () => _showComingSoon(context, l10n.myDataHealthProcedureSpecializedCare),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataHealthInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkSescam,
                onTap: () => _showComingSoon(context, l10n.myDataHealthLinkSescam),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkDigitalHealth,
                onTap: () => _showComingSoon(context, l10n.myDataHealthLinkDigitalHealth),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkClinicalHistory,
                onTap: () => _showComingSoon(context, l10n.myDataHealthLinkClinicalHistory),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(final BuildContext context, final String label) {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).myDataSectionComingSoon(label),
    );
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
    required this.appointments,
    required this.l10n,
  });

  final List<HealthAppointment> appointments;
  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    if (appointments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: AppDimensions.space24),
        child: Text(
          l10n.myDataHealthAppointmentsEmpty,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final sections = _buildSections(appointments);
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
              _monthName(monthSection.month, l10n.localeName),
              style: AppTypography.h3.copyWith(
                color: AppColors.textBase,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            for (final appointment in monthSection.appointments) ...[
              _AppointmentCard(appointment: appointment),
              const SizedBox(height: AppDimensions.space12),
            ],
          ],
        ],
      ],
    );
  }

  List<_AppointmentYearSection> _buildSections(final List<HealthAppointment> appointments) {
    final yearSections = <int, Map<int, List<HealthAppointment>>>{};
    for (final appointment in appointments) {
      final date = appointment.dateTime;
      yearSections.putIfAbsent(date.year, () => <int, List<HealthAppointment>>{});
      yearSections[date.year]!.putIfAbsent(date.month, () => <HealthAppointment>[]);
      yearSections[date.year]![date.month]!.add(appointment);
    }

    return yearSections.entries
        .map(
          (final yearEntry) => _AppointmentYearSection(
            year: yearEntry.key,
            months: yearEntry.value.entries
                .map(
                  (final monthEntry) => _AppointmentMonthSection(
                    month: monthEntry.key,
                    appointments: monthEntry.value,
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
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.myDataHealthAppointmentsError,
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          AppButton(
            label: l10n.errorStateRetry,
            onPressed: onRetry,
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final HealthAppointment appointment;

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
                    appointment.dateTime.day.toString(),
                    style: AppTypography.h1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    _weekdayName(appointment.dateTime.weekday, AppLocalizations.of(context).localeName),
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
                          _formatTime(appointment.dateTime),
                          style: AppTypography.smallRegular.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space16),
                        Flexible(
                          child: Text(
                            _appointmentType(appointment),
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
                      appointment.professional,
                      style: AppTypography.bodyBold.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      appointment.description,
                      style: AppTypography.smallRegular.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      appointment.modality ?? appointment.center ?? '',
                      style: AppTypography.captionRegular.copyWith(
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
    required this.appointments,
  });

  final int month;
  final List<HealthAppointment> appointments;
}

String _formatTime(final DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:${minute}h';
}

String _appointmentType(final HealthAppointment appointment) {
  final raw = appointment.channel ?? appointment.modality ?? '';
  if (raw.trim().isEmpty) {
    return '';
  }
  return raw.toUpperCase();
}

String _weekdayName(final int weekday, final String localeName) {
  final isEnglish = localeName.toLowerCase().startsWith('en');
  return switch (weekday) {
    DateTime.monday => isEnglish ? 'Monday' : 'Lunes',
    DateTime.tuesday => isEnglish ? 'Tuesday' : 'Martes',
    DateTime.wednesday => isEnglish ? 'Wednesday' : 'Miércoles',
    DateTime.thursday => isEnglish ? 'Thursday' : 'Jueves',
    DateTime.friday => isEnglish ? 'Friday' : 'Viernes',
    DateTime.saturday => isEnglish ? 'Saturday' : 'Sábado',
    DateTime.sunday => isEnglish ? 'Sunday' : 'Domingo',
    _ => '',
  };
}

String _monthName(final int month, final String localeName) {
  final isEnglish = localeName.toLowerCase().startsWith('en');
  return switch (month) {
    1 => isEnglish ? 'January' : 'enero',
    2 => isEnglish ? 'February' : 'febrero',
    3 => isEnglish ? 'March' : 'marzo',
    4 => isEnglish ? 'April' : 'abril',
    5 => isEnglish ? 'May' : 'mayo',
    6 => isEnglish ? 'June' : 'junio',
    7 => isEnglish ? 'July' : 'julio',
    8 => isEnglish ? 'August' : 'agosto',
    9 => isEnglish ? 'September' : 'septiembre',
    10 => isEnglish ? 'October' : 'octubre',
    11 => isEnglish ? 'November' : 'noviembre',
    12 => isEnglish ? 'December' : 'diciembre',
    _ => '',
  };
}
