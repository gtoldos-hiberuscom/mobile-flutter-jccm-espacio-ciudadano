import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/thermal_spa_award.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_contact_actions.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_social_welfare_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Thermal-spa detail — Figma nodes 43973:1927 and 43973:1986.
class MyDataSocialWelfareThermalSpaPage extends ConsumerWidget {
  const MyDataSocialWelfareThermalSpaPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final awardAsync = ref.watch(thermalSpaAwardProvider);

    return AppDetailScaffold(
      title: l10n.socialWelfareTermalismoNavTitle,
      onBack: () => context.go(Routes.myDataSocialWelfare),
      onInfo: () => AppInfoSheet.show(
        context: context,
        title: l10n.socialWelfareTermalismoInfoSheetTitle,
        bodyText: l10n.socialWelfareTermalismoInfoSheetDescription,
        footerText: l10n.familiaNumerosaContactHint,
        actionLabel: l10n.familiaNumerosaOfficeContactsButton,
        onActionPressed: () => launchSocialWelfareOfficeContacts(context, ref),
        actionIcon: AppIcons.openInNew,
      ),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      body: awardAsync.when(
        data: (final award) => award == null ? _ThermalSpaEmpty(ref: ref) : _ThermalSpaContent(award: award),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => _ThermalSpaError(ref: ref),
      ),
    );
  }
}

class _ThermalSpaContent extends StatelessWidget {
  const _ThermalSpaContent({required this.award});

  final ThermalSpaAward award;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l10n.socialWelfareTermalismoAwardTitle),
          AppInfoLabelList(
            horizontal: false,
            items: [
              AppInfoLabelEntry(label: l10n.socialWelfareTermalismoSpaNameLabel, value: _display(award.name)),
              AppInfoLabelEntry(label: l10n.socialWelfareTermalismoStartDateLabel, value: _formatDate(award.startDate)),
              AppInfoLabelEntry(label: l10n.socialWelfareTermalismoEndDateLabel, value: _formatDate(award.endDate)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
            child: Divider(color: AppColors.neutral100),
          ),
        ],
      ),
    );
  }
}

class _ThermalSpaEmpty extends StatelessWidget {
  const _ThermalSpaEmpty({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Text(
          l10n.socialWelfareTermalismoUnavailableMessage,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ThermalSpaError extends StatelessWidget {
  const _ThermalSpaError({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.socialWelfareTermalismoErrorMessage,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.discapacidadRetry,
              hierarchy: AppButtonHierarchy.secondary,
              onPressed: () => ref.invalidate(thermalSpaAwardProvider),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _sectionTitle(final String title) => Padding(
  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
  child: AppSectionHeading(title),
);

String _display(final String value) => value.trim().isEmpty ? '-' : value.trim();

String _formatDate(final DateTime? date) {
  if (date == null) {
    return '-';
  }
  const months = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
