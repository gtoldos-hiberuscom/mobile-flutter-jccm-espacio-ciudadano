import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_disabled_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Housing detail page — Figma nodes 43973:2061 and 43973:2085.
class MyDataHousingPage extends StatefulWidget {
  const MyDataHousingPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  State<MyDataHousingPage> createState() => _MyDataHousingPageState();
}

class _MyDataHousingPageState extends State<MyDataHousingPage> {
  _HousingTab _selectedTab = _HousingTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataHousingTitle,
      onBack: () => context.go(widget.backRoute),
      onInfo: () => _showHousingInfoSheet(context),
      tabs: [l10n.myDataHousingDataTab, l10n.myDataHousingServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _HousingTab.values[index]),
      tabViews: const [
        _HousingDataTab(),
        _HousingServicesTab(),
      ],
    );
  }

  Future<void> _showHousingInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataHousingInfoSheetTitle,
      bodyText: l10n.myDataHousingInfoSheetDescription,
    );
  }
}

enum _HousingTab { data, services }

class _HousingDataTab extends ConsumerWidget {
  const _HousingDataTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authorizationAsync = ref.watch(ageDataAuthorizationProvider);

    return authorizationAsync.when(
      data: (final hasAgeAuthorization) => _HousingDataContent(
        hasAgeAuthorization: hasAgeAuthorization,
      ),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (final error, final stackTrace) => const _HousingDataContent(
        hasAgeAuthorization: false,
      ),
    );
  }
}

class _HousingDataContent extends StatelessWidget {
  const _HousingDataContent({required this.hasAgeAuthorization});

  final bool hasAgeAuthorization;

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
          if (hasAgeAuthorization)
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

class _HousingServicesTab extends StatelessWidget {
  const _HousingServicesTab();

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
            title: l10n.myDataHousingLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHousingLinkClmHousing,
                onTap: () => _launchExternalUrl(context, 'https://vivienda.castillalamancha.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHousingLinkCadastre,
                onTap: () => _launchExternalUrl(context, 'https://www.sedecatastro.gob.es/'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataHousingProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHousingProcedureProtectedHousingRegister,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHousingProcedureSocialEmergencyAid,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHousingProcedureRentalHousingAid,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/tramites/1021878'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchExternalUrl(final BuildContext context, final String urlString) async {
  final uri = Uri.parse(urlString);
  final accepted = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!accepted && context.mounted) {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
    );
  }
}
