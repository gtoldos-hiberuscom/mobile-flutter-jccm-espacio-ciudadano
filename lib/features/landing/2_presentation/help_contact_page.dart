import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/faq_detail_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Help and contact screen from Figma node `41911:6750`.
class HelpContactPage extends ConsumerStatefulWidget {
  const HelpContactPage({super.key});

  @override
  ConsumerState<HelpContactPage> createState() => _HelpContactPageState();
}

class _HelpContactPageState extends ConsumerState<HelpContactPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAuthenticated = ref.watch(jwtClaimsProvider) != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: l10n.helpContactPageTitle,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.arrowBack,
            size: AppDimensions.iconLarge,
            color: AppColors.textPrimary,
          ),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.homeFromDrawer);
            }
          },
        ),
      ),
      body: Column(
        children: [
          ColoredBox(
            color: AppColors.backgroundBlueMutedLight,
            child: AppTabBar(
              controller: _tabController,
              level: AppTabBarLevel.nivel2,
              isScrollable: true,
              tabs: [
                AppTabItem(label: l10n.helpFaqSectionTitle),
                AppTabItem(label: l10n.helpContactSectionTitle),
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _FaqTab(onOpenGuides: () => _openExternalLink('help_guides')),
                  _ContactTab(
                    onCallPhone: _callPhone,
                    onOpenOffices: () => _openExternalLink('jccm_offices_oir'),
                    // Sin sesión el gateway no atiende el formulario de la
                    // app, así que se manda al de la web (JCCMEC-212).
                    opensSupportOutsideApp: !isAuthenticated,
                    onOpenSupport: isAuthenticated ? _navigateToSupportForm : () => _openExternalLink('web_support_form'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callPhone(final String number) async {
    final accepted = await launchUrl(
      Uri(scheme: 'tel', path: number.replaceAll(' ', '')),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || accepted) {
      return;
    }
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }

  Future<void> _navigateToSupportForm() async {
    await context.push<void>(Routes.supportForm);
  }

  Future<void> _openExternalLink(final String id) async {
    final link = ref.read(externalLinkCatalogProvider).findById(id);
    if (link == null) {
      return;
    }

    if (!await confirmExternalNavigation(context) || !mounted) {
      return;
    }
    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
}

class _FaqTab extends StatelessWidget {
  const _FaqTab({required this.onOpenGuides});

  final VoidCallback onOpenGuides;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    AppListExpandableItem categoryItem(final FaqCategory category, {final bool initiallyExpanded = false}) => AppListExpandableItem(
      title: '${category.title(l10n)} (${category.entries.length})',
      initiallyExpanded: initiallyExpanded,
      headerPadding: const EdgeInsets.only(
        left: AppDimensions.space16,
        top: AppDimensions.space8,
        right: AppDimensions.space8,
        bottom: AppDimensions.space8,
      ),
      semanticsLabel: '${category.title(l10n)}. ${category.entries.length} preguntas',
      children: category.entries
          .map(
            (final entry) => AppListItem(
              title: entry.question(l10n),
              trailing: const Icon(
                Icons.arrow_forward,
                color: AppColors.primaryDark,
                size: AppDimensions.iconMedium,
              ),
              onTap: () => context.push(Routes.faqDetailPath(entry.id)),
            ),
          )
          .toList(),
    );

    return ListView(
      // The FAQ composition uses the 16dp page gutters, with the heading in
      // the card and 32dp before the guides block.
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space48),
      children: [
        AppList(
          variant: AppListVariant.expandable,
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.space16,
                    AppDimensions.space8,
                    AppDimensions.space16,
                    AppDimensions.space24,
                  ),
                  child: AppSectionHeading(l10n.helpFaqSectionTitle),
                ),
                categoryItem(faqCategories.first),
              ],
            ),
            ...faqCategories.skip(1).map(categoryItem),
          ],
        ),
        const SizedBox(height: AppDimensions.space32),
        AppSectionHeading(l10n.helpContactGuidesTitle),
        const SizedBox(height: AppDimensions.space16),
        AppIconTextBlock(
          iconAsset: AppIconAssets.question,
          iconSize: 36,
          text: l10n.helpContactGuidesIntro,
        ),
        const SizedBox(height: AppDimensions.space24),
        AppContactActionCard(
          title: l10n.helpContactShowAllGuides,
          subtitle: l10n.helpContactGoToJccmPortal,
          onTap: onOpenGuides,
        ),
      ],
    );
  }
}

class _ContactTab extends StatelessWidget {
  const _ContactTab({
    required this.onCallPhone,
    required this.onOpenOffices,
    required this.opensSupportOutsideApp,
    required this.onOpenSupport,
  });

  final ValueChanged<String> onCallPhone;
  final VoidCallback onOpenOffices;
  final bool opensSupportOutsideApp;
  final VoidCallback onOpenSupport;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space48),
      children: [
        AppSectionHeading(l10n.helpContactInfoHeading),
        const SizedBox(height: AppDimensions.space24),
        AppIconTextBlock(
          iconAsset: AppIconAssets.chat,
          iconSize: 36,
          text: l10n.helpContactPhonesIntro,
          boldParts: [l10n.helpContactPhonesIntroBold1, l10n.helpContactPhonesIntroBold2],
        ),
        const SizedBox(height: AppDimensions.space24),
        AppPhoneActionCard(
          number: '012',
          subtitle: l10n.helpContactCallCitizenService,
          showSubtitle: false,
          onTap: () => onCallPhone('012'),
        ),
        const SizedBox(height: AppDimensions.space16),
        AppPhoneActionCard(
          number: '925 274 552',
          subtitle: l10n.helpContactCallCitizenService,
          showSubtitle: false,
          onTap: () => onCallPhone('925 274 552'),
        ),
        const SizedBox(height: AppDimensions.space24),
        AppIconTextBlock(
          iconAsset: AppIconAssets.chat,
          iconSize: 36,
          text: l10n.helpContactExpedienteIntro,
          boldParts: [l10n.helpContactExpedienteIntroBold],
        ),
        const SizedBox(height: AppDimensions.space24),
        AppContactActionCard(
          title: l10n.helpContactOfficesListTitle,
          subtitle: l10n.helpContactGoToJccmPortal,
          onTap: onOpenOffices,
        ),
        const SizedBox(height: AppDimensions.space24),
        AppIconTextBlock(
          iconAsset: AppIconAssets.ajustes,
          iconSize: 36,
          text: l10n.helpContactSupportIntro,
          boldParts: [l10n.helpContactSupportIntroBold],
        ),
        const SizedBox(height: AppDimensions.space24),
        AppButton(
          label: l10n.helpContactSupportFormButton,
          semanticsLabel: opensSupportOutsideApp ? '${l10n.helpContactSupportFormButton}. ${l10n.externalLinkA11yHint}' : null,
          trailingIcon: opensSupportOutsideApp ? AppIcons.openInNew : AppIcons.arrowForward,
          isExpanded: true,
          onPressed: onOpenSupport,
        ),
      ],
    );
  }
}
