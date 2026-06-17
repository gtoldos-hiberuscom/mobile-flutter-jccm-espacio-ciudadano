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

    return Scaffold(
      appBar: AppHeaderBar(
        title: l10n.myDataVehiclesTitle,
        onBack: () => context.go(Routes.myData),
        onInfo: () => _showVehiclesInfoSheet(context),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              AppTopTabBar(
                tabs: [l10n.myDataVehiclesDataTab, l10n.myDataVehiclesServicesTab],
                selectedIndex: _selectedTab.index,
                onTabSelected: (final index) => setState(() => _selectedTab = _VehiclesTab.values[index]),
              ),
              Expanded(
                child: switch (_selectedTab) {
                  _VehiclesTab.data => const _VehiclesDataTab(),
                  _VehiclesTab.services => const _VehiclesServicesTab(),
                },
              ),
            ],
          ),
        ),
      ),
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          left: BorderSide(color: AppColors.borderBlueMutedLight, width: 4),
          top: BorderSide(color: AppColors.borderBlueMutedLight),
          right: BorderSide(color: AppColors.borderBlueMutedLight),
          bottom: BorderSide(color: AppColors.borderBlueMutedLight),
        ),
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
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
          // Enlaces de interés
          _VehiclesSectionTitle(title: l10n.myDataVehiclesLinksTitle),
          const SizedBox(height: AppDimensions.space16),
          _VehiclesLinkItem(
            label: l10n.myDataVehiclesLinkDgt,
            url: 'https://sede.dgt.gob.es/',
          ),
          const SizedBox(height: AppDimensions.space16),
          _VehiclesLinkItem(
            label: l10n.myDataVehiclesLinkAge,
            url: 'https://carpetaciudadana.gob.es/',
          ),
          const SizedBox(height: AppDimensions.space24),

          // Trámites que te pueden interesar
          _VehiclesSectionTitle(title: l10n.myDataVehiclesProceduresTitle),
          const SizedBox(height: AppDimensions.space16),
          _VehiclesLinkItem(
            label: l10n.myDataVehiclesProcedureMoves3Vehicle,
            url: 'https://www.castillalamancha.es/',
          ),
          const SizedBox(height: AppDimensions.space16),
          _VehiclesLinkItem(
            label: l10n.myDataVehiclesProcedureMoves3Infrastructure,
            url: 'https://www.castillalamancha.es/',
          ),
          const SizedBox(height: AppDimensions.space16),
          _VehiclesLinkItem(
            label: l10n.myDataVehiclesProcedureCap,
            url: 'https://www.castillalamancha.es/',
          ),
        ],
      ),
    );
  }
}

/// Section title widget (H2 typography).
class _VehiclesSectionTitle extends StatelessWidget {
  const _VehiclesSectionTitle({required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      child: Text(
        title,
        style: AppTypography.h2.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Link item with double-bullet indicator and external link icon.
class _VehiclesLinkItem extends StatelessWidget {
  const _VehiclesLinkItem({
    required this.label,
    required this.url,
  });

  final String label;
  final String url;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: () => _launchUrl(context, url),
      child: Padding(
        padding: const EdgeInsets.only(left: AppDimensions.space16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: AppDimensions.space8),
              child: _VehiclesDoubleBullet(),
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                child: Text(
                  label,
                  style: AppTypography.bodyLink.copyWith(
                    color: AppColors.primary,
                    decorationColor: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            const Padding(
              padding: EdgeInsets.only(top: AppDimensions.space4),
              child: AppIcon(
                AppIcons.openInNew,
                color: AppColors.textBase,
              ),
            ),
          ],
        ),
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

/// Double-bullet indicator (primary + secondary colors).
class _VehiclesDoubleBullet extends StatelessWidget {
  const _VehiclesDoubleBullet();

  @override
  Widget build(final BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _VehiclesBulletDot(color: AppColors.primary),
        SizedBox(width: AppDimensions.space4),
        _VehiclesBulletDot(color: AppColors.secondaryLight400),
      ],
    );
  }
}

/// Single bullet dot.
class _VehiclesBulletDot extends StatelessWidget {
  const _VehiclesBulletDot({required this.color});

  final Color color;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: const SizedBox.square(dimension: AppDimensions.space8),
    );
  }
}
