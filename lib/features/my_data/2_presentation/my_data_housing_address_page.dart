import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/housing_address.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_housing_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_required_state.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Housing address detail — Figma node 43973:2103.
class MyDataHousingAddressPage extends ConsumerWidget {
  const MyDataHousingAddressPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final addressAsync = ref.watch(housingAddressProvider);

    return AppDetailScaffold(
      title: l10n.myDataHousingAddressTitle,
      onBack: () => context.go(Routes.myDataHousing),
      onInfo: () => _showInfoSheet(context),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      body: addressAsync.when(
        data: (final address) => address == null ? const _AddressEmpty() : _AddressContent(address: address),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => error is MyDataAuthorizationRequired
            ? MyDataAuthorizationRequiredState(returnTo: Routes.myDataHousingAddress, onAuthorized: () => ref.invalidate(housingAddressProvider))
            : _AddressError(
                onRetry: () => ref.invalidate(housingAddressProvider),
              ),
      ),
    );
  }

  Future<void> _showInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataHousingAddressInfoSheetTitle,
      bodyText: l10n.myDataHousingAddressInfoSheetDescription,
      footerText: l10n.myDataHousingAddressInfoSheetFooter,
      actionLabel: l10n.familiaNumerosaMoreInformation,
      onActionPressed: () => launchExternalUrlWithConfirmation(context, Uri.parse(_ineUrl)),
      actionIcon: AppIcons.openInNew,
      actionIsExternalLink: true,
    );
  }
}

const String _ineUrl = 'https://www.ine.es/';

class _AddressContent extends StatelessWidget {
  const _AddressContent({required this.address});

  final HousingAddress address;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: l10n.myDataHousingAddressDataTitle),
          AppInfoLabelList(
            horizontal: false,
            items: [
              AppInfoLabelEntry(label: l10n.myDataHousingAddressLabel, value: _display(address.address)),
              AppInfoLabelEntry(label: l10n.myDataHousingAddressPostalCodeLabel, value: _display(address.postalCode)),
              AppInfoLabelEntry(label: l10n.myDataHousingAddressMunicipalityLabel, value: _display(address.municipality)),
              AppInfoLabelEntry(label: l10n.myDataHousingAddressProvinceLabel, value: _display(address.province)),
              AppInfoLabelEntry(label: l10n.myDataHousingAddressCollectiveEntityLabel, value: _display(address.collectiveEntity)),
              AppInfoLabelEntry(label: l10n.myDataHousingAddressSingleEntityLabel, value: _display(address.singleEntity)),
              AppInfoLabelEntry(label: l10n.myDataHousingAddressPopulationUnitLabel, value: _display(address.populationUnit)),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          _SectionTitle(title: l10n.myDataHousingAddressRegistrationDataTitle),
          AppInfoLabelList(
            horizontal: false,
            items: [
              AppInfoLabelEntry(label: l10n.myDataHousingAddressVariationTypeLabel, value: _display(address.variationType)),
              AppInfoLabelEntry(label: l10n.myDataHousingAddressVariationDateLabel, value: _formatDate(context, address.variationDate)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      child: Text(
        title,
        style: AppTypography.h2.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _AddressEmpty extends StatelessWidget {
  const _AddressEmpty();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MyDataNoData(
      message: l10n.myDataHousingAddressNoDataMessage,
      actionLabel: l10n.myDataNoDataOfficeContacts,
      contactUrl: 'https://www.ine.es/',
    );
  }
}

class _AddressError extends StatelessWidget {
  const _AddressError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MyDataServiceUnavailable(
      message: l10n.myDataHousingAddressServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: onRetry,
    );
  }
}

String _display(final String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return '-';
  }
  return normalized;
}

String _formatDate(final BuildContext context, final DateTime? date) {
  if (date == null) {
    return '-';
  }
  final months = AppLocalizations.of(context).localeName.toLowerCase().startsWith('en') ? const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] : const ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
