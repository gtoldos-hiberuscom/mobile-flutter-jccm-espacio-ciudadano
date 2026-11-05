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
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_representative_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Housing detail page — Figma nodes 43973:2061 and 43973:2085.
class MyDataHousingPage extends ConsumerStatefulWidget {
  const MyDataHousingPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  ConsumerState<MyDataHousingPage> createState() => _MyDataHousingPageState();
}

class _MyDataHousingPageState extends ConsumerState<MyDataHousingPage> {
  _HousingTab _selectedTab = _HousingTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRepresentative = ref.watch(jwtClaimsProvider.select((final claims) => claims?.isRepresentative ?? false));

    return AppTabbedDetailScaffold(
      title: l10n.myDataHousingTitle,
      onBack: () => context.go(widget.backRoute),
      tabs: [l10n.myDataHousingDataTab, l10n.myDataHousingServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _HousingTab.values[index]),
      tabViews: [
        _HousingDataTab(isRepresentative: isRepresentative),
        const _HousingServicesTab(),
      ],
    );
  }
}

enum _HousingTab { data, services }

class _HousingDataTab extends ConsumerWidget {
  const _HousingDataTab({required this.isRepresentative});

  final bool isRepresentative;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authorizationAsync = ref.watch(ageDataAuthorizationProvider);

    return authorizationAsync.when(
      data: (final hasAgeAuthorization) => _HousingDataContent(
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

class _HousingDataContent extends StatelessWidget {
  const _HousingDataContent({required this.hasAgeAuthorization, required this.isRepresentative});

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
              onOpenSettings: () => _openSettings(context),
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
          if (hasAgeAuthorization)
            AppNavigationCard(
              title: l10n.myDataHousingRealEstateTitle,
              description: l10n.myDataHousingRealEstateDescription,
              onTap: () => context.go(Routes.myDataHousingRealEstate),
            )
          else
            MyDataDisabledNavigationCard(
              title: l10n.myDataHousingRealEstateTitle,
              description: l10n.myDataHousingRealEstateDescription,
            ),
          const SizedBox(height: AppDimensions.space16),
          if (hasAgeAuthorization && !isRepresentative)
            AppNavigationCard(
              title: l10n.myDataHousingAddressTitle,
              description: l10n.myDataHousingAddressDescription,
              onTap: () => context.go(Routes.myDataHousingAddress),
            )
          else
            MyDataDisabledNavigationCard(
              title: l10n.myDataHousingAddressTitle,
              description: l10n.myDataHousingAddressDescription,
            ),
          if (isRepresentative) ...[
            const SizedBox(height: AppDimensions.space16),
            const MyDataRepresentativeUnavailableAlert(),
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
            'returnTo': Routes.myDataHousing,
          },
        ).toString(),
      ),
    );
  }
}

class _HousingServicesTab extends ConsumerWidget {
  const _HousingServicesTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppExternalLinkSection(
            title: l10n.myDataHousingProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHousingProcedureProtectedHousingRegister,
                onTap: () => _launchExternalUrl(context, config.housingProcedure(1)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHousingProcedureSocialEmergencyAid,
                onTap: () => _launchExternalUrl(context, config.housingProcedure(2)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHousingProcedureRentalHousingAid,
                onTap: () => _launchExternalUrl(context, config.housingProcedure(0)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataHousingLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHousingLinkClmHousing,
                onTap: () => _launchExternalUrl(context, config.housingUrl),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHousingLinkCadastre,
                onTap: () => _launchExternalUrl(context, config.cadastreUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchExternalUrl(final BuildContext context, final Uri url) async {
  await launchExternalUrlWithConfirmation(context, url);
}
