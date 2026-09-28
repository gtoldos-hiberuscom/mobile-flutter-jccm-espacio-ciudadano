import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_disabled_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Social welfare data page — Figma node 43973:1893.
class MyDataSocialWelfarePage extends ConsumerStatefulWidget {
  const MyDataSocialWelfarePage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  ConsumerState<MyDataSocialWelfarePage> createState() => _MyDataSocialWelfarePageState();
}

class _MyDataSocialWelfarePageState extends ConsumerState<MyDataSocialWelfarePage> {
  _SocialWelfareTab? _selectedTab;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedTab = _selectedTab ?? _SocialWelfareTab.data;

    return AppTabbedDetailScaffold(
      title: l10n.socialWelfareScreenTitle,
      onBack: () => context.go(widget.backRoute),
      tabs: [
        l10n.socialWelfareDataTab,
        l10n.socialWelfareServicesTab,
      ],
      selectedIndex: selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _SocialWelfareTab.values[index]),
      tabViews: const [
        _SocialWelfareDataTab(),
        _SocialWelfareServicesTab(),
      ],
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

    return Consumer(
      builder: (final context, final ref, final child) {
        final authorizationAsync = ref.watch(jccmDataAuthorizationProvider);

        return authorizationAsync.when(
          data: (final hasJccmAuthorization) => _SocialWelfareDataList(
            items: items,
            hasJccmAuthorization: hasJccmAuthorization,
          ),
          loading: () => const Center(child: AppLoadingIndicator()),
          // Fallo del check ≠ "no autorizado": sin respuesta del backend solo
          // cabe error + reintentar, nunca afirmar que falta el consentimiento.
          error: (final error, final stackTrace) => ErrorStateWidget(
            message: AppLocalizations.of(context).authorizationCheckFailedMessage,
            onRetry: () => ref.invalidate(jccmDataAuthorizationProvider),
          ),
        );
      },
    );
  }
}

class _SocialWelfareDataList extends StatelessWidget {
  const _SocialWelfareDataList({
    required this.items,
    required this.hasJccmAuthorization,
  });

  final List<_SocialWelfareNavItem> items;
  final bool hasJccmAuthorization;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView.separated(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space24),
      itemBuilder: (final context, final index) {
        // Show contextual helper at the top when authorization is missing
        if (!hasJccmAuthorization && index == 0) {
          return MyDataAuthorizationContextualHelper(
            onOpenSettings: () => context.push(
              Uri(
                path: Routes.consent,
                queryParameters: {
                  'mode': 'preferences',
                  'returnTo': Routes.myDataSocialWelfare,
                },
              ).toString(),
            ),
          );
        }

        // Adjust index to account for the contextual helper
        final itemIndex = hasJccmAuthorization ? index : index - 1;

        final item = items[itemIndex];
        if (!hasJccmAuthorization) {
          return MyDataDisabledNavigationCard(
            title: item.title,
            description: item.description,
          );
        }

        return AppNavigationCard(
          title: item.title,
          description: item.description,
          onTap: () {
            final route = item.route;
            if (route != null) {
              context.go(route);
              return;
            }
            AppAlertSnackbar.show(
              context,
              message: l10n.myDataSectionComingSoon(item.title),
            );
          },
        );
      },
      separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
      itemCount: hasJccmAuthorization ? items.length : items.length + 1,
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
        title: l10n.socialWelfareSuggestedProceduresTitle,
        links: [
          _SocialWelfareLinkData(
            label: l10n.socialWelfareDisabilityRecognitionProcedure,
            linkId: 'social_welfare_procedure_0',
          ),
          _SocialWelfareLinkData(
            label: l10n.socialWelfareEarlyCareProcedure,
            linkId: 'social_welfare_procedure_1',
          ),
          _SocialWelfareLinkData(
            label: l10n.socialWelfareTemporaryResidentialStayProcedure,
            linkId: 'social_welfare_procedure_2',
          ),
        ],
      ),
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
    ];

    return ListView.separated(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space24),
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

    if (!await confirmExternalNavigation(context) || !context.mounted) {
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
