import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/disability_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_contact_actions.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_social_welfare_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_required_state.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Disability title detail — Figma node 43973:1919.
class MyDataSocialWelfareDisabilityPage extends ConsumerWidget {
  const MyDataSocialWelfareDisabilityPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final disabilityAsync = ref.watch(disabilityTitleProvider);

    return AppDetailScaffold(
      title: l10n.socialWelfareDisabilityTitle,
      onBack: () => context.go(Routes.myDataSocialWelfare),
      onInfo: () => AppInfoSheet.show(
        context: context,
        title: l10n.socialWelfareDisabilityInfoSheetTitle,
        bodyText: l10n.socialWelfareDisabilityInfoSheetDescription,
        footerText: l10n.familiaNumerosaContactHint,
        actionLabel: l10n.familiaNumerosaOfficeContactsButton,
        onActionPressed: () => launchSocialWelfareOfficeContacts(context, ref),
        actionIcon: AppIcons.openInNew,
      ),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      body: disabilityAsync.when(
        data: (final title) => title == null ? _DisabilityEmpty(ref: ref) : _DisabilityContent(title: title),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => error is MyDataAuthorizationRequired ? MyDataAuthorizationRequiredState(returnTo: Routes.myDataSocialWelfareDisability, onAuthorized: () => ref.invalidate(disabilityTitleProvider)) : _DisabilityError(ref: ref),
      ),
    );
  }
}

class _DisabilityContent extends StatelessWidget {
  const _DisabilityContent({required this.title});

  final DisabilityTitle title;

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
          _sectionTitle(l10n.socialWelfareDisabilityTitleSection),
          AppInfoLabelList(
            horizontal: false,
            items: [
              AppInfoLabelEntry(label: l10n.discapacidadGradoLabel, value: _formatPercent(title.degreePercent)),
              AppInfoLabelEntry(label: l10n.socialWelfareDisabilityEffectiveDateLabel, value: _formatDate(title.effectiveDate)),
              AppInfoLabelEntry(label: l10n.socialWelfareDisabilityPermanentValidityLabel, value: _formatBool(context, title.hasPermanentValidity)),
              AppInfoLabelEntry(label: l10n.socialWelfareDisabilityFileNumberLabel, value: _display(title.fileNumber)),
              AppInfoLabelEntry(label: l10n.socialWelfareDisabilityBirthDateLabel, value: _formatDate(title.birthDate)),
              AppInfoLabelEntry(label: l10n.socialWelfareDisabilityMobilityLabel, value: _formatBool(context, title.hasReducedMobility)),
              AppInfoLabelEntry(label: l10n.socialWelfareDisabilityThirdPersonLabel, value: _formatBool(context, title.hasThirdPersonAssistance)),
              AppInfoLabelEntry(label: l10n.socialWelfareDisabilityRoyalDecreeLabel, value: _display(title.royalDecree)),
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

class _DisabilityEmpty extends StatelessWidget {
  const _DisabilityEmpty({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MyDataNoData(
      message: l10n.discapacidadNoDataMessage,
      actionLabel: l10n.familiaNumerosaOfficeContactsButton,
      onAction: () => launchSocialWelfareOfficeContacts(context, ref),
    );
  }
}

class _DisabilityError extends StatelessWidget {
  const _DisabilityError({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MyDataServiceUnavailable(
      message: l10n.discapacidadServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: () => ref.invalidate(disabilityTitleProvider),
    );
  }
}

Widget _sectionTitle(final String title) => Padding(
  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
  child: AppSectionHeading(title),
);

String _display(final String value) => value.trim().isEmpty ? '-' : value.trim();

String _formatPercent(final int? value) => value == null ? '-' : '$value%';

String _formatBool(final BuildContext context, final bool? value) {
  if (value == null) {
    return '-';
  }
  final l10n = AppLocalizations.of(context);
  return value ? l10n.familiaNumerosaYes : l10n.familiaNumerosaNo;
}

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
