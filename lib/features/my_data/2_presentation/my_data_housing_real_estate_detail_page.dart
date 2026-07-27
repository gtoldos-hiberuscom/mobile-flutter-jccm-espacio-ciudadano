import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_housing_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Real-estate asset detail — Figma node 43973:2120.
class MyDataHousingRealEstateDetailPage extends ConsumerWidget {
  const MyDataHousingRealEstateDetailPage({
    required this.reference,
    super.key,
  });

  final String reference;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final decodedReference = Uri.decodeComponent(reference);
    final propertiesAsync = ref.watch(housingRealEstatePropertiesProvider);

    return AppDetailScaffold(
      title: l10n.myDataHousingRealEstateReferenceTitle(decodedReference),
      onBack: () => context.go(Routes.myDataHousingRealEstate),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      leadingIcon: AppIcons.close,
      leadingTooltip: l10n.myDataHousingRealEstateDetailClose,
      body: propertiesAsync.when(
        data: (final properties) {
          final property = _findProperty(properties, decodedReference);
          return property == null ? const _PropertyDetailEmpty() : _PropertyDetailContent(property: property);
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => _PropertyDetailError(
          onRetry: () => ref.invalidate(housingRealEstatePropertiesProvider),
        ),
      ),
    );
  }

  RealEstateProperty? _findProperty(final List<RealEstateProperty> properties, final String reference) {
    final normalizedReference = _normalizeReference(reference);
    for (final property in properties) {
      if (_normalizeReference(property.cadastralReference) == normalizedReference) {
        return property;
      }
    }
    return null;
  }
}

class _PropertyDetailContent extends StatelessWidget {
  const _PropertyDetailContent({required this.property});

  final RealEstateProperty property;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cartographyUrl = property.cartographyUrl?.trim();

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
          _SectionTitle(title: l10n.myDataHousingRealEstateDetailHomeDataTitle),
          AppInfoLabelList(
            horizontal: false,
            items: [
              AppInfoLabelEntry(label: l10n.myDataHousingRealEstateReferenceLabel, value: _display(property.cadastralReference)),
              AppInfoLabelEntry(label: l10n.myDataHousingRealEstateAddressLabel, value: _display(property.address)),
              AppInfoLabelEntry(label: l10n.myDataHousingRealEstateUseLabel, value: _display(property.use)),
              AppInfoLabelEntry(label: l10n.myDataHousingRealEstateCadastralValueLabel, value: _display(property.cadastralValue)),
              AppInfoLabelEntry(label: l10n.myDataHousingRealEstateLandValueLabel, value: _display(property.landValue)),
              AppInfoLabelEntry(label: l10n.myDataHousingRealEstateConstructionValueLabel, value: _display(property.constructionValue)),
            ],
          ),
          if (cartographyUrl != null && cartographyUrl.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.myDataHousingRealEstateShowCartography,
              hierarchy: AppButtonHierarchy.secondary,
              trailingIcon: AppIcons.openInNew,
              isExpanded: true,
              onPressed: () => _launchCartography(context, cartographyUrl),
            ),
          ],
          const SizedBox(height: AppDimensions.space16),
          _SectionTitle(title: l10n.myDataHousingRealEstateHoldersTitle),
          if (property.holders.isEmpty)
            Text(
              l10n.myDataHousingRealEstateHoldersEmpty,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            )
          else
            ...property.holders.map(
              (final holder) => _HolderRow(holder: holder),
            ),
        ],
      ),
    );
  }

  Future<void> _launchCartography(final BuildContext context, final String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (context.mounted) {
        AppAlertSnackbar.show(
          context,
          message: AppLocalizations.of(context).externalLinkOpenFailed,
        );
      }
      return;
    }

    await launchExternalUrlWithConfirmation(context, uri);
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

class _HolderRow extends StatelessWidget {
  const _HolderRow({required this.holder});

  final RealEstatePropertyHolder holder;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              _display(holder.name).toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          Expanded(
            child: Text(
              _display(holder.ownership),
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyDetailEmpty extends StatelessWidget {
  const _PropertyDetailEmpty();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Text(
          l10n.myDataHousingRealEstateDetailEmpty,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _PropertyDetailError extends StatelessWidget {
  const _PropertyDetailError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MyDataServiceUnavailable(
      message: l10n.myDataHousingRealEstateServiceUnavailableMessage,
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

String _normalizeReference(final String? value) => (value ?? '').replaceAll(RegExp(r'\s+'), '').toUpperCase();
