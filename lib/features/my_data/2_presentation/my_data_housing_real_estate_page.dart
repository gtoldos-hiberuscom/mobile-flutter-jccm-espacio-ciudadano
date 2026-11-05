import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_housing_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_required_state.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Real-estate assets detail — Figma nodes 43973:2113 and 43973:1978.
class MyDataHousingRealEstatePage extends ConsumerStatefulWidget {
  const MyDataHousingRealEstatePage({super.key});

  @override
  ConsumerState<MyDataHousingRealEstatePage> createState() => _MyDataHousingRealEstatePageState();
}

class _MyDataHousingRealEstatePageState extends ConsumerState<MyDataHousingRealEstatePage> {
  _PropertyFilter _selectedFilter = _PropertyFilter.all;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final propertiesAsync = ref.watch(housingRealEstatePropertiesProvider);

    return AppDetailScaffold(
      title: l10n.myDataHousingRealEstateTitle,
      onBack: () => context.go(Routes.myDataHousing),
      onInfo: () => _showInfoSheet(context),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      body: propertiesAsync.when(
        data: (final properties) => _PropertiesContent(
          properties: properties,
          selectedFilter: _selectedFilter,
          onFilterChanged: (final filter) => setState(() => _selectedFilter = filter),
        ),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => error is MyDataAuthorizationRequired
            ? MyDataAuthorizationRequiredState(returnTo: Routes.myDataHousingRealEstate, onAuthorized: () => ref.invalidate(housingRealEstatePropertiesProvider))
            : _PropertiesError(
                onRetry: () => ref.invalidate(housingRealEstatePropertiesProvider),
              ),
      ),
    );
  }

  Future<void> _showInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataHousingRealEstateInfoSheetTitle,
      bodyText: l10n.myDataHousingRealEstateInfoSheetDescription,
      footerText: l10n.myDataHousingRealEstateInfoSheetFooter,
      // El contacto de estos datos es el Catastro, que es de quien vienen.
      // Estaba solo en el estado vacío, así que quien sí tiene inmuebles no
      // tenía a dónde acudir.
      actionLabel: l10n.familiaNumerosaMoreInformation,
      onActionPressed: () => launchExternalUrlWithConfirmation(context, Uri.parse(_catastroUrl)),
      actionIcon: AppIcons.openInNew,
      actionIsExternalLink: true,
    );
  }
}

/// Sede del Catastro: es la fuente de estos datos y el sitio donde se
/// corrigen.
const String _catastroUrl = 'https://www.sedecatastro.gob.es/';

enum _PropertyFilter { all, urban, rustic }

class _PropertiesContent extends StatelessWidget {
  const _PropertiesContent({
    required this.properties,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final List<RealEstateProperty> properties;
  final _PropertyFilter selectedFilter;
  final ValueChanged<_PropertyFilter> onFilterChanged;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filteredProperties = _filter(properties);

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space64),
      child: Column(
        children: [
          AppSegmentedControl(
            segments: [
              l10n.myDataHousingRealEstateFilterAll,
              l10n.myDataHousingRealEstateFilterUrban,
              l10n.myDataHousingRealEstateFilterRustic,
            ],
            selectedIndex: selectedFilter.index,
            onSelected: (final index) => onFilterChanged(_PropertyFilter.values[index]),
          ),
          const SizedBox(height: AppDimensions.space16),
          if (filteredProperties.isEmpty)
            properties.isEmpty
                ? MyDataNoData(
                    message: l10n.myDataHousingRealEstateNoDataMessage,
                    scrollable: false,
                  )
                : _PropertiesEmpty(message: l10n.myDataHousingRealEstateFilteredEmpty)
          else
            ...filteredProperties.map(
              (final property) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space16),
                child: _PropertyCard(
                  property: property,
                  onTap: () async {
                    final reference = property.cadastralReference?.trim();
                    if (reference == null || reference.isEmpty) {
                      return;
                    }
                    await context.push('${Routes.myDataHousingRealEstate}/${Uri.encodeComponent(reference)}');
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<RealEstateProperty> _filter(final List<RealEstateProperty> source) {
    return switch (selectedFilter) {
      _PropertyFilter.all => source,
      _PropertyFilter.urban =>
        source
            .where(
              (final property) => property.kind == RealEstatePropertyKind.urban || property.kind == RealEstatePropertyKind.unknown,
            )
            .toList(growable: false),
      _PropertyFilter.rustic =>
        source
            .where(
              (final property) => property.kind == RealEstatePropertyKind.rustic || property.kind == RealEstatePropertyKind.unknown,
            )
            .toList(growable: false),
    };
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.property,
    required this.onTap,
  });

  final RealEstateProperty property;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppDataSummaryCard(
      title: l10n.myDataHousingRealEstateReferenceTitle(_display(property.cadastralReference)),
      showTrailingIcon: true,
      onTap: onTap,
      highlightedItems: [
        AppDataSummaryEntry(label: l10n.myDataHousingRealEstateAddressLabel, value: _display(property.address)),
        AppDataSummaryEntry(label: l10n.myDataHousingRealEstateCadastralValueLabel, value: _display(property.cadastralValue)),
        AppDataSummaryEntry(label: l10n.myDataHousingRealEstateLandValueLabel, value: _display(property.landValue)),
        AppDataSummaryEntry(label: l10n.myDataHousingRealEstateConstructionValueLabel, value: _display(property.constructionValue)),
        // Un dato más del inmueble, dentro del recuadro con el resto: en
        // `footerItems` se pintaba por fuera, que es lo único que lo separaba
        // de los demás.
        AppDataSummaryEntry(label: l10n.myDataHousingRealEstateUseLabel, value: _displayUse(property.use)),
      ],
    );
  }
}

class _PropertiesEmpty extends StatelessWidget {
  const _PropertiesEmpty({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.space24),
      child: Text(
        message,
        style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PropertiesError extends StatelessWidget {
  const _PropertiesError({required this.onRetry});

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

String _displayUse(final String? value) {
  final normalized = value?.replaceAll('_', ' ').replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) {
    return '-';
  }

  return '${normalized[0].toUpperCase()}${normalized.substring(1)}';
}
