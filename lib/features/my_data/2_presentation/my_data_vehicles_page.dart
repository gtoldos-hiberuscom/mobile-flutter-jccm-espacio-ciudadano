import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_vehicles_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _dgtContactUrl = 'https://sede.dgt.gob.es/es/contenido/contactar/index.html';

/// Vehicles list page — Figma node 43973:2068.
class MyDataVehiclesPage extends StatefulWidget {
  const MyDataVehiclesPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  State<MyDataVehiclesPage> createState() => _MyDataVehiclesPageState();
}

class _MyDataVehiclesPageState extends State<MyDataVehiclesPage> {
  _VehiclesTab _selectedTab = _VehiclesTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataVehiclesTitle,
      onBack: () => context.go(widget.backRoute),
      onInfo: () => _showVehiclesInfoSheet(context),
      tabs: [l10n.myDataVehiclesDataTab, l10n.myDataVehiclesServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _VehiclesTab.values[index]),
      tabViews: const [
        _VehiclesDataTab(),
        _VehiclesServicesTab(),
      ],
    );
  }

  Future<void> _showVehiclesInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataVehiclesInfoSheetTitle,
      bodyText: l10n.myDataVehiclesInfoSheetDescription,
      footerText: l10n.myDataVehiclesInfoSheetFooter,
      actionLabel: l10n.myDataVehiclesInfoSheetContactButton,
      onActionPressed: () => _launchDgtContactUrl(context),
      actionIcon: Icons.open_in_new,
    );
  }

  Future<void> _launchDgtContactUrl(final BuildContext context) async {
    final uri = Uri.parse(_dgtContactUrl);
    await launchExternalUrlWithConfirmation(context, uri);
  }
}

enum _VehiclesTab { data, services }

class _VehiclesDataTab extends ConsumerWidget {
  const _VehiclesDataTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authorizationAsync = ref.watch(ageDataAuthorizationProvider);

    return authorizationAsync.when(
      data: (final hasAgeAuthorization) => hasAgeAuthorization ? const _AuthorizedVehiclesData() : _buildAuthorizationRequired(context, l10n),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (final error, final stack) => _buildAuthorizationRequired(context, l10n),
    );
  }

  Widget _buildAuthorizationRequired(
    final BuildContext context,
    final AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: MyDataAuthorizationContextualHelper(
        message: l10n.myDataAgeAuthorizationRequiredMessage,
        semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta,
        onOpenSettings: () => unawaited(
          context.push(
            Uri(
              path: Routes.consent,
              queryParameters: {
                'mode': 'preferences',
                'returnTo': Routes.myDataVehicles,
              },
            ).toString(),
          ),
        ),
      ),
    );
  }
}

class _AuthorizedVehiclesData extends ConsumerWidget {
  const _AuthorizedVehiclesData();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return vehiclesAsync.when(
      data: (final vehicles) => _buildVehiclesList(context, l10n, vehicles),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (final error, final stack) => _buildErrorState(l10n, ref),
    );
  }

  Widget _buildVehiclesList(
    final BuildContext context,
    final AppLocalizations l10n,
    final List<Vehicle> vehicles,
  ) {
    if (vehicles.isEmpty) {
      return MyDataNoData(
        message: l10n.myDataVehiclesNoDataMessage,
        actionLabel: l10n.myDataVehiclesInfoSheetContactButton,
        contactUrl: _dgtContactUrl,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
            child: Text(
              l10n.myDataVehiclesSectionTitle,
              style: AppTypography.h2.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          // Vehicle cards
          for (final vehicle in vehicles) ...[
            _VehicleCard(vehicle: vehicle),
            const SizedBox(height: AppDimensions.space16),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(
    final AppLocalizations l10n,
    final WidgetRef ref,
  ) {
    return MyDataServiceUnavailable(
      message: l10n.myDataVehiclesServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: () => ref.invalidate(vehiclesProvider),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicle.licensePlate,
            style: AppTypography.bodyBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            l10n.myDataVehiclesLicensePlateLabel,
            style: AppTypography.smallRegular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VehiclesServicesTab extends StatelessWidget {
  const _VehiclesServicesTab();

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
          AppExternalLinkSection(
            title: l10n.myDataVehiclesLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataVehiclesLinkDgt,
                onTap: () => _launchUrl(context, 'https://sede.dgt.gob.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataVehiclesLinkAge,
                onTap: () => _launchUrl(context, 'https://carpetaciudadana.gob.es/'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataVehiclesProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataVehiclesProcedureMoves3Vehicle,
                onTap: () => _launchUrl(context, 'https://www.castillalamancha.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataVehiclesProcedureMoves3Infrastructure,
                onTap: () => _launchUrl(context, 'https://www.castillalamancha.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataVehiclesProcedureCap,
                onTap: () => _launchUrl(context, 'https://www.castillalamancha.es/'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(final BuildContext context, final String urlString) async {
    final uri = Uri.parse(urlString);
    await launchExternalUrlWithConfirmation(context, uri);
  }
}
