import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Social welfare data page — Figma node 43973:1893.
class MyDataSocialWelfarePage extends StatefulWidget {
  const MyDataSocialWelfarePage({super.key});

  @override
  State<MyDataSocialWelfarePage> createState() => _MyDataSocialWelfarePageState();
}

class _MyDataSocialWelfarePageState extends State<MyDataSocialWelfarePage> {
  _SocialWelfareTab _selectedTab = _SocialWelfareTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.socialWelfareScreenTitle,
      onBack: () => context.go(Routes.myData),
      onInfo: () => _showInfoSheet(context),
      tabs: [
        l10n.socialWelfareDataTab,
        l10n.socialWelfareServicesTab,
      ],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(
        () => _selectedTab = _SocialWelfareTab.values[index],
      ),
      tabViews: const [
        _SocialWelfareDataTab(),
        _SocialWelfareServicesTab(),
      ],
    );
  }

  Future<void> _showInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.socialWelfareInfoSheetTitle,
      bodyText: l10n.socialWelfareInfoSheetDescription,
    );
  }
}

enum _SocialWelfareTab { data, services }

class _SocialWelfareDataTab extends StatelessWidget {
  const _SocialWelfareDataTab();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      _SocialWelfareNavItem(
        title: l10n.socialWelfareFamilyTitle,
        description: l10n.socialWelfareFamilyNavDescription,
        route: Routes.myDataSocialWelfareFamily,
      ),
      _SocialWelfareNavItem(
        title: l10n.socialWelfareDisabilityTitle,
        description: l10n.socialWelfareDisabilityNavDescription,
        route: Routes.myDataSocialWelfareDisability,
      ),
      _SocialWelfareNavItem(
        title: l10n.socialWelfareTermalismoNavTitle,
        description: l10n.socialWelfareTermalismoNavDescription,
        route: Routes.myDataSocialWelfareThermalSpa,
      ),
      _SocialWelfareNavItem(
        title: l10n.socialWelfareDependenciaTitle,
        description: l10n.socialWelfareDependenciaNavDescription,
        route: Routes.myDataSocialWelfareDependency,
      ),
      _SocialWelfareNavItem(
        title: l10n.socialWelfareParkingNavTitle,
        description: l10n.socialWelfareParkingNavDescription,
        route: Routes.myDataSocialWelfareParking,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space24,
      ),
      itemBuilder: (final context, final index) => AppNavigationCard(
        title: items[index].title,
        description: items[index].description,
        onTap: () {
          final route = items[index].route;
          if (route != null) {
            context.go(route);
            return;
          }
          AppAlertSnackbar.show(
            context,
            message: l10n.myDataSectionComingSoon(items[index].title),
          );
        },
      ),
      separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
      itemCount: items.length,
    );
  }
}

class _SocialWelfareServicesTab extends ConsumerWidget {
  const _SocialWelfareServicesTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final linkSections = [
      _SocialWelfareLinkSectionData(
        title: l10n.socialWelfareInterestLinksTitle,
        links: [
          _SocialWelfareLinkData(
            label: l10n.externalLinkHistoriaSocialUnicaLabel,
            linkId: 'historia_social_unica',
          ),
          _SocialWelfareLinkData(
            label: l10n.externalLinkInfanciaFamiliasLabel,
            linkId: 'infancia_familias',
          ),
        ],
      ),
      _SocialWelfareLinkSectionData(
        title: l10n.socialWelfareSuggestedProceduresTitle,
        links: [
          _SocialWelfareLinkData(
            label: l10n.socialWelfareDisabilityRecognitionProcedure,
            linkId: 'bienestar_social_clm',
          ),
          _SocialWelfareLinkData(
            label: l10n.socialWelfareEarlyCareProcedure,
            linkId: 'bienestar_social_clm',
          ),
          _SocialWelfareLinkData(
            label: l10n.socialWelfareTemporaryResidentialStayProcedure,
            linkId: 'bienestar_social_clm',
          ),
        ],
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space24,
      ),
      itemBuilder: (final context, final sectionIndex) => AppExternalLinkSection(
        title: linkSections[sectionIndex].title,
        links: [
          for (final link in linkSections[sectionIndex].links)
            AppExternalLinkItem(
              label: link.label,
              onTap: () => _launchExternalLink(context, ref, link.linkId),
            ),
        ],
      ),
      separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
      itemCount: linkSections.length,
    );
  }

  Future<void> _launchExternalLink(
    final BuildContext context,
    final WidgetRef ref,
    final String linkId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ExternalLink? link = ref.read(externalLinkCatalogProvider).findById(linkId);

    if (link == null) {
      AppAlertSnackbar.show(
        context,
        message: l10n.externalLinkOpenFailed,
        severity: AppAlertSeverity.error,
      );
      return;
    }

    final result = await ref.read(externalLinkLauncherProvider).launch(link);

    if (!context.mounted || result is ExternalLinkLaunchSuccess) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: l10n.externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
}

class _SocialWelfareLinkSectionData {
  const _SocialWelfareLinkSectionData({
    required this.title,
    required this.links,
  });

  final String title;
  final List<_SocialWelfareLinkData> links;
}

class _SocialWelfareLinkData {
  const _SocialWelfareLinkData({
    required this.label,
    required this.linkId,
  });

  final String label;
  final String linkId;
}

class _SocialWelfareNavItem {
  const _SocialWelfareNavItem({
    required this.title,
    required this.description,
    this.route,
  });

  final String title;
  final String description;
  final String? route;
}
