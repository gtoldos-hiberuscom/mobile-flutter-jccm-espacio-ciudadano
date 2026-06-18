import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/dependency_care_status.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_contact_actions.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_social_welfare_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Dependency care detail — Figma nodes 43973:1934 and 43973:1987.
class MyDataSocialWelfareDependencyPage extends ConsumerWidget {
  const MyDataSocialWelfareDependencyPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final statusAsync = ref.watch(dependencyCareStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppHeaderBar(
        title: l10n.socialWelfareDependenciaTitle,
        backgroundColor: AppColors.backgroundBlueLighter,
        onBack: () => context.go(Routes.myDataSocialWelfare),
        onInfo: () => AppInfoSheet.show(
          context: context,
          title: l10n.socialWelfareDependenciaInfoSheetTitle,
          bodyText: l10n.socialWelfareDependenciaInfoSheetDescription,
          footerText: l10n.familiaNumerosaContactHint,
          actionLabel: l10n.familiaNumerosaOfficeContactsButton,
          onActionPressed: () => launchSocialWelfareOfficeContacts(context, ref),
          actionIcon: AppIcons.openInNew,
        ),
      ),
      body: SizedBox.expand(
        child: ColoredBox(
          color: AppColors.backgroundWhite,
          child: SafeArea(
            top: false,
            child: statusAsync.when(
              data: (final status) => status == null ? _DependencyEmpty(ref: ref) : _DependencyContent(status: status),
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (final error, final stackTrace) => _DependencyError(ref: ref),
            ),
          ),
        ),
      ),
    );
  }
}

class _DependencyContent extends StatelessWidget {
  const _DependencyContent({required this.status});

  final DependencyCareStatus status;

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
          _sectionTitle(l10n.socialWelfareDependenciaCurrentStatusTitle),
          AppInfoLabelList(
            items: [
              AppInfoLabelEntry(label: l10n.socialWelfareDependenciaRequestDateLabel, value: _formatDate(status.requestDate)),
              AppInfoLabelEntry(label: l10n.socialWelfareDependenciaResolutionDateLabel, value: _formatDate(status.resolutionDate)),
              AppInfoLabelEntry(label: l10n.socialWelfareDependenciaRecognizedDegreeLabel, value: _display(status.recognizedDegree)),
              AppInfoLabelEntry(label: l10n.socialWelfareDependenciaBaremoLabel, value: _display(status.baremo)),
            ],
          ),
          if (status.benefits.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.space16),
            _sectionTitle(l10n.socialWelfareDependenciaBenefitsTitle),
            for (final benefit in status.benefits) ...[
              _BenefitCard(benefit: benefit),
              const SizedBox(height: AppDimensions.space16),
            ],
          ],
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final DependencyCareBenefit benefit;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppInfoCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
              child: Text(
                _display(benefit.category),
                style: AppTypography.captionUppercase.copyWith(color: AppColors.borderBlueMutedBase),
              ),
            ),
            Text(
              _display(benefit.name),
              style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
            ),
            AppInfoLabelList(
              items: [
                AppInfoLabelEntry(label: l10n.socialWelfareDependenciaBenefitResolutionDateLabel, value: _formatDate(benefit.resolutionDate)),
                AppInfoLabelEntry(label: l10n.socialWelfareDependenciaBenefitEffectiveDateLabel, value: _formatDate(benefit.effectiveDate)),
                AppInfoLabelEntry(label: l10n.socialWelfareDependenciaBenefitAmountLabel, value: _display(benefit.amount)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DependencyEmpty extends StatelessWidget {
  const _DependencyEmpty({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Text(
          l10n.socialWelfareDependenciaUnavailableMessage,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _DependencyError extends StatelessWidget {
  const _DependencyError({required this.ref});

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
              l10n.socialWelfareDependenciaErrorMessage,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.discapacidadRetry,
              hierarchy: AppButtonHierarchy.secondary,
              onPressed: () => ref.invalidate(dependencyCareStatusProvider),
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
