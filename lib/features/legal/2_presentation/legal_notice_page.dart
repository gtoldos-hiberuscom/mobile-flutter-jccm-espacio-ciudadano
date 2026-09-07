import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Legal notice screen from Figma node `41853:13694`.
class LegalNoticePage extends ConsumerStatefulWidget {
  const LegalNoticePage({super.key});

  @override
  ConsumerState<LegalNoticePage> createState() => _LegalNoticePageState();
}

class _LegalNoticePageState extends ConsumerState<LegalNoticePage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: l10n.legalNoticeTitle,
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
      // `SafeArea` inferior y no un padding fijo: el último bloque quedaba
      // debajo del gesto de navegación del dispositivo y el texto parecía
      // cortado. Igual que en Accesibilidad y Protección de datos.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
            left: AppDimensions.space16,
            right: AppDimensions.space16,
            top: AppDimensions.space24,
            bottom: AppDimensions.space48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                headingLevel: 1,
                child: Text.rich(
                  TextSpan(
                    text: l10n.legalNoticeHeading,
                    style: AppTypography.h1.copyWith(color: AppColors.primary),
                  ),
                  semanticsLabel: l10n.legalNoticeHeading,
                  textScaler: MediaQuery.textScalerOf(context),
                  strutStyle: StrutStyle.fromTextStyle(AppTypography.h1),
                ),
              ),
              const SizedBox(height: AppDimensions.space32),
              _LegalNoticeBody(
                onRoyalDecreeTap: () => _openExternalLink('boe_rd_1112_2018'),
                onSiteTap: () => _openExternalLink('espacio_ciudadano'),
              ),
            ],
          ),
        ),
      ),
    );
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

class _LegalNoticeBody extends StatelessWidget {
  const _LegalNoticeBody({
    required this.onRoyalDecreeTap,
    required this.onSiteTap,
  });

  final VoidCallback onRoyalDecreeTap;
  final VoidCallback onSiteTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.primary);
    final linkStyle = style.copyWith(
      color: AppColors.secondary,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.secondary,
    );

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(
            text: l10n.accessibilityIntroCommitment,
            style: style,
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InkWell(
              onTap: onRoyalDecreeTap,
              child: Text.rich(
                TextSpan(
                  text: '${l10n.accessibilityIntroDecreeLink} ⇲',
                  style: linkStyle,
                ),
              ),
            ),
          ),
          TextSpan(
            text: l10n.accessibilityIntroDecreeSuffix,
            style: style,
          ),
          TextSpan(
            text: l10n.accessibilityDeclarationScope,
            style: style,
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InkWell(
              onTap: onSiteTap,
              child: Text.rich(
                TextSpan(
                  text: 'https://espaciociudadano.jccm.es/⇲',
                  style: linkStyle,
                ),
              ),
            ),
          ),
          TextSpan(text: '.', style: style),
        ],
      ),
    );
  }
}
