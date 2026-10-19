import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_disabled_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Education data detail — Figma node 43973:1875.
class MyDataEducationPage extends ConsumerStatefulWidget {
  const MyDataEducationPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  ConsumerState<MyDataEducationPage> createState() => _MyDataEducationPageState();
}

class _MyDataEducationPageState extends ConsumerState<MyDataEducationPage> {
  _EducationTab? _selectedTab;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRepresentative = ref.watch(jwtClaimsProvider.select((final claims) => claims?.isRepresentative ?? false));
    final selectedTab = _selectedTab ?? _EducationTab.data;

    return AppTabbedDetailScaffold(
      title: l10n.myDataEducationTitle,
      onBack: () => context.go(widget.backRoute),
      tabs: [l10n.myDataEducationDataTab, l10n.myDataEducationServicesTab],
      selectedIndex: selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _EducationTab.values[index]),
      tabViews: [
        _EducationDataTab(isRepresentative: isRepresentative),
        const _EducationServicesTab(),
      ],
    );
  }
}

enum _EducationTab { data, services }

class _EducationDataTab extends ConsumerWidget {
  const _EducationDataTab({required this.isRepresentative});

  final bool isRepresentative;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authorizationAsync = ref.watch(ageDataAuthorizationProvider);

    return authorizationAsync.when(
      data: (final hasAgeAuthorization) => _EducationDataContent(
        hasAgeAuthorization: hasAgeAuthorization,
        isRepresentative: isRepresentative,
      ),
      loading: () => const Center(child: AppLoadingIndicator()),
      // Fallo del check ≠ "no autorizado": sin respuesta del backend solo
      // cabe error + reintentar, nunca afirmar que falta el consentimiento.
      error: (final error, final stackTrace) => ErrorStateWidget(
        message: AppLocalizations.of(context).authorizationCheckFailedMessage,
        onRetry: () => ref.invalidate(ageDataAuthorizationProvider),
      ),
    );
  }
}

class _EducationDataContent extends StatelessWidget {
  const _EducationDataContent({required this.hasAgeAuthorization, required this.isRepresentative});

  final bool hasAgeAuthorization;
  final bool isRepresentative;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
      child: Column(
        children: [
          if (!hasAgeAuthorization) ...[
            MyDataAuthorizationContextualHelper(
              message: l10n.myDataAgeAuthorizationRequiredMessage,
              semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta,
              showTextAction: true,
              onOpenSettings: () => _openSettings(context),
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
          if (isRepresentative)
            AppAlertContextual(
              size: AppAlertContextualSize.small,
              message: l10n.representativeUnavailableMessage,
            )
          else if (hasAgeAuthorization)
            AppNavigationCard(
              title: l10n.myDataEducationUniversityTitles,
              description: l10n.myDataEducationTitlesDescription,
              onTap: () => context.go(Routes.myDataEducationUniversityTitles),
            )
          else
            MyDataDisabledNavigationCard(
              title: l10n.myDataEducationUniversityTitles,
              description: l10n.myDataEducationTitlesDescription,
            ),
          if (!isRepresentative) ...[
            const SizedBox(height: AppDimensions.space16),
            if (hasAgeAuthorization)
              AppNavigationCard(
                title: l10n.myDataEducationNonUniversityTitles,
                description: l10n.myDataEducationNonUniversityTitlesDescription,
                onTap: () => context.go(Routes.myDataEducationNonUniversityTitles),
              )
            else
              MyDataDisabledNavigationCard(
                title: l10n.myDataEducationNonUniversityTitles,
                description: l10n.myDataEducationNonUniversityTitlesDescription,
              ),
          ],
        ],
      ),
    );
  }

  void _openSettings(final BuildContext context) {
    unawaited(
      context.push(
        Uri(
          path: Routes.consent,
          queryParameters: {
            'mode': 'preferences',
            'returnTo': Routes.myDataEducation,
          },
        ).toString(),
      ),
    );
  }
}

class _EducationServicesTab extends ConsumerWidget {
  const _EducationServicesTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppExternalLinkSection(
            title: l10n.myDataEducationProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEducationProcedureEquivalence,
                onTap: () => _launchExternalUrl(context, config.educationProcedure(0)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEducationProcedureScholarships,
                onTap: () => _launchExternalUrl(context, config.educationProcedure(1)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEducationProcedureSecondaryDegree,
                onTap: () => _launchExternalUrl(context, config.educationProcedure(2)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataEducationInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.externalLinkEducamosClmLabel,
                // En pestaña integrada a propósito: comparte la sesión del
                // navegador con la del login, y por eso Educamos abre ya
                // identificado (#282847, análisis de SSO con portales).
                onTap: () => _launchExternalUrl(
                  context,
                  config.educamosUrl,
                  mode: LaunchMode.inAppBrowserView,
                ),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEducationLinkTeachingStaff,
                onTap: () => _launchExternalUrl(context, config.teachingStaffUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchExternalUrl(
    final BuildContext context,
    final Uri url, {
    final LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    await launchExternalUrlWithConfirmation(context, url, mode: mode);
  }
}
