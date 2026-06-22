import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_vehicles_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Vehicles list page — Figma node 43973:2068.
class MyDataVehiclesPage extends StatefulWidget {
  const MyDataVehiclesPage({super.key});

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
      onBack: () => context.go(Routes.myData),
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
    const dgtContactUrl = 'https://sede.dgt.gob.es/es/contacto/';
    final uri = Uri.parse(dgtContactUrl);
    final accepted = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!accepted && context.mounted) {
      AppAlertSnackbar.show(
        context,
        message: 'No se pudo abrir el enlace de contacto de la DGT',
      );
    }
  }
}

enum _VehiclesTab { data, services }

class _VehiclesDataTab extends ConsumerWidget {
  const _VehiclesDataTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return vehiclesAsync.when(
      data: (final vehicles) => _buildVehiclesList(context, l10n, vehicles),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (final error, final stack) => _buildErrorState(context, l10n, ref),
    );
  }

  Widget _buildVehiclesList(
    final BuildContext context,
    final AppLocalizations l10n,
    final List<Vehicle> vehicles,
  ) {
    if (vehicles.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

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

  Widget _buildEmptyState(
    final BuildContext context,
    final AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Text(
          l10n.myDataVehiclesEmpty,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.textBase,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildErrorState(
    final BuildContext context,
    final AppLocalizations l10n,
    final WidgetRef ref,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.myDataVehiclesError,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textBase,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.maintenanceRetry,
              onPressed: () => ref.invalidate(vehiclesProvider),
              hierarchy: AppButtonHierarchy.secondary,
            ),
          ],
        ),
      ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // License plate (bold)
            Text(
              vehicle.licensePlate,
              style: AppTypography.bodyBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.space4),
            // Description
            Text(
              l10n.myDataVehiclesLicensePlateLabel,
              style: AppTypography.smallRegular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
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
    final accepted = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!accepted && context.mounted) {
      AppAlertSnackbar.show(
        context,
        message: 'No se pudo abrir el enlace: $urlString',
      );
    }
  }
}
