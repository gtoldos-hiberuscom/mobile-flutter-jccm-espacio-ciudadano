import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/large_family_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_contact_actions.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_social_welfare_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Large family detail — Figma nodes 43973:1908 and 43973:1903.
class MyDataSocialWelfareFamilyPage extends ConsumerWidget {
  const MyDataSocialWelfareFamilyPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final familyAsync = ref.watch(largeFamilyTitleProvider);

    return AppDetailScaffold(
      title: l10n.familiaNumerosaDetailTitle,
      onBack: () => context.go(Routes.myDataSocialWelfare),
      onInfo: () => _showFamilyInfoSheet(context, ref),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      body: familyAsync.when(
        data: (final title) => title == null ? _NoLargeFamilyData(ref: ref) : _LargeFamilyContent(title: title, ref: ref),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => _LargeFamilyError(ref: ref),
      ),
    );
  }
}

Future<void> _showFamilyInfoSheet(final BuildContext context, final WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  await AppInfoSheet.show(
    context: context,
    title: l10n.familiaNumerosaInfoSheetTitle,
    bodyText: l10n.familiaNumerosaInfoSheetDescription,
    footerText: l10n.familiaNumerosaContactHint,
    actionLabel: l10n.familiaNumerosaOfficeContactsButton,
    onActionPressed: () => launchSocialWelfareOfficeContacts(context, ref),
    actionIcon: AppIcons.openInNew,
  );
}

class _LargeFamilyContent extends StatelessWidget {
  const _LargeFamilyContent({
    required this.title,
    required this.ref,
  });

  final LargeFamilyTitle title;
  final WidgetRef ref;

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
          _sectionTitle(l10n.familiaNumerosaTitleSection),
          AppInfoLabelList(
            horizontal: false,
            items: [
              AppInfoLabelEntry(label: l10n.familiaNumerosaRegionLabel, value: title.region),
              AppInfoLabelEntry(label: l10n.familiaNumerosaTitleNumberLabel, value: _display(title.titleNumber)),
              AppInfoLabelEntry(label: l10n.familiaNumerosaCategoryLabel, value: _display(title.category)),
              AppInfoLabelEntry(label: l10n.familiaNumerosaValidLabel, value: title.isValid ? l10n.familiaNumerosaYes : l10n.familiaNumerosaNo),
              AppInfoLabelEntry(label: l10n.familiaNumerosaIssueDateLabel, value: _formatDate(title.issueDate)),
              AppInfoLabelEntry(label: l10n.familiaNumerosaExpiryDateLabel, value: _formatDate(title.expiryDate)),
              AppInfoLabelEntry(label: l10n.familiaNumerosaChildrenCountLabel, value: title.childrenCount?.toString() ?? '-'),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          _sectionTitle(l10n.familiaNumerosaBeneficiariesTitle),
          for (var i = 0; i < title.beneficiaries.length; i++) ...[
            _BeneficiaryBlock(
              beneficiary: title.beneficiaries[i],
              index: i + 1,
            ),
            const SizedBox(height: AppDimensions.space8),
          ],
          if (title.beneficiaries.isEmpty)
            Text(
              l10n.familiaNumerosaMemberFallbackName,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
            child: Divider(color: AppColors.neutral100),
          ),
          _FamilyContactHelper(
            message: l10n.familiaNumerosaContactHint,
            ref: ref,
          ),
        ],
      ),
    );
  }
}

class _BeneficiaryBlock extends StatelessWidget {
  const _BeneficiaryBlock({
    required this.beneficiary,
    required this.index,
  });

  final LargeFamilyBeneficiary beneficiary;
  final int index;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppDimensions.space4,
            bottom: AppDimensions.space8,
          ),
          child: Text(
            l10n.familiaNumerosaBeneficiaryTitle(index),
            style: AppTypography.h3.copyWith(color: AppColors.primary),
          ),
        ),
        AppInfoLabelList(
          horizontal: false,
          items: [
            AppInfoLabelEntry(label: l10n.familiaNumerosaDocumentNumberLabel, value: _display(beneficiary.documentNumber)),
            AppInfoLabelEntry(label: l10n.familiaNumerosaBirthDateLabel, value: _formatDate(beneficiary.birthDate)),
            AppInfoLabelEntry(label: l10n.familiaNumerosaFullNameLabel, value: _display(beneficiary.fullName)),
            AppInfoLabelEntry(label: l10n.familiaNumerosaHolderLabel, value: beneficiary.isHolder ? l10n.familiaNumerosaYes : l10n.familiaNumerosaNo),
          ],
        ),
      ],
    );
  }
}

class _NoLargeFamilyData extends StatelessWidget {
  const _NoLargeFamilyData({required this.ref});

  final WidgetRef ref;

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
      child: _FamilyContactHelper(
        message: l10n.familiaNumerosaNoDataMessage,
        ref: ref,
      ),
    );
  }
}

class _LargeFamilyError extends StatelessWidget {
  const _LargeFamilyError({required this.ref});

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
              l10n.familiaNumerosaErrorMessage,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.familiaNumerosaRetry,
              hierarchy: AppButtonHierarchy.secondary,
              onPressed: () => ref.invalidate(largeFamilyTitleProvider),
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyContactHelper extends StatelessWidget {
  const _FamilyContactHelper({
    required this.message,
    required this.ref,
  });

  final String message;
  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppAlertContextual(
      message: message,
      action: AppButton(
        label: l10n.familiaNumerosaOfficeContactsButton,
        hierarchy: AppButtonHierarchy.secondary,
        trailingIcon: AppIcons.openInNew,
        onPressed: () => launchSocialWelfareOfficeContacts(context, ref),
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
