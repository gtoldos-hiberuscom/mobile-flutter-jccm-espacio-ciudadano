import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/parking_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_social_welfare_contact_actions.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_social_welfare_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Parking card detail — Figma nodes 43973:1942 and 43973:1988.
class MyDataSocialWelfareParkingPage extends ConsumerWidget {
  const MyDataSocialWelfareParkingPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cardAsync = ref.watch(parkingCardProvider);

    return AppDetailScaffold(
      title: l10n.socialWelfareParkingTitle,
      onBack: () => context.go(Routes.myDataSocialWelfare),
      onInfo: () => AppInfoSheet.show(
        context: context,
        title: l10n.socialWelfareParkingInfoSheetTitle,
        bodyText: l10n.socialWelfareParkingInfoSheetDescription,
        footerText: l10n.familiaNumerosaContactHint,
        actionLabel: l10n.familiaNumerosaOfficeContactsButton,
        onActionPressed: () => launchSocialWelfareOfficeContacts(context, ref),
        actionIcon: AppIcons.openInNew,
      ),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      body: cardAsync.when(
        data: (final card) => card == null ? _ParkingEmpty(ref: ref) : _ParkingContent(card: card),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => _ParkingError(ref: ref),
      ),
    );
  }
}

class _ParkingContent extends StatelessWidget {
  const _ParkingContent({required this.card});

  final ParkingCard card;

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
          _sectionTitle(l10n.socialWelfareParkingCardTitle),
          AppInfoLabelList(
            horizontal: false,
            items: [
              AppInfoLabelEntry(label: l10n.socialWelfareParkingCodeLabel, value: _display(card.cardCode)),
              AppInfoLabelEntry(label: l10n.socialWelfareParkingModalityLabel, value: _display(card.modality)),
              AppInfoLabelEntry(label: l10n.socialWelfareParkingValidFromLabel, value: _formatDate(card.validFrom)),
              AppInfoLabelEntry(label: l10n.socialWelfareParkingValidUntilLabel, value: _formatDate(card.validUntil)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParkingEmpty extends StatelessWidget {
  const _ParkingEmpty({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MyDataNoData(
      message: l10n.socialWelfareParkingNoDataMessage,
      actionLabel: l10n.familiaNumerosaOfficeContactsButton,
      onAction: () => launchSocialWelfareOfficeContacts(context, ref),
    );
  }
}

class _ParkingError extends StatelessWidget {
  const _ParkingError({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MyDataServiceUnavailable(
      message: l10n.socialWelfareParkingServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: () => ref.invalidate(parkingCardProvider),
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
