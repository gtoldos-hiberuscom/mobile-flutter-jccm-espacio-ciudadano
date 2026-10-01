import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_disabled_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Área de Salud de Mis datos — Figma node 43973:1861.
///
/// Es un **menú**, como Bienestar Social, Educación y Vivienda: las dos
/// consultas de citas —atención primaria y atención hospitalaria— están al
/// mismo nivel y cada una tiene su pantalla. Antes primaria se mostraba aquí
/// dentro y hospitalaria se enlazaba, que eran dos cosas del mismo rango
/// presentadas en planos distintos.
class MyDataHealthPage extends ConsumerStatefulWidget {
  const MyDataHealthPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  ConsumerState<MyDataHealthPage> createState() => _MyDataHealthPageState();
}

class _MyDataHealthPageState extends ConsumerState<MyDataHealthPage> {
  _HealthTab _selectedTab = _HealthTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataHealthTitle,
      onBack: () => context.go(widget.backRoute),
      tabs: [l10n.myDataHealthDataTab, l10n.myDataHealthServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _HealthTab.values[index]),
      tabViews: const [
        _HealthMenuTab(),
        _HealthServicesTab(),
      ],
    );
  }
}

enum _HealthTab { data, services }

/// Las dos consultas de citas, como tarjetas de navegación.
class _HealthMenuTab extends ConsumerWidget {
  const _HealthMenuTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return ref.watch(jccmDataAuthorizationProvider).when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: AppDimensions.space24),
        child: Center(child: AppLoadingIndicator()),
      ),
      // Fallo del check ≠ «no autorizado»: sin respuesta del backend solo cabe
      // error + reintentar, nunca pedir re-autorizar un consentimiento que
      // puede estar concedido.
      error: (final _, final _) => ErrorStateWidget(
        message: l10n.authorizationCheckFailedMessage,
        onRetry: () => ref.invalidate(jccmDataAuthorizationProvider),
      ),
      data: (final hasJccmAuthorization) => SingleChildScrollView(
        padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasJccmAuthorization) ...[
              MyDataAuthorizationContextualHelper(onOpenSettings: () => _openConsentSettings(context)),
              const SizedBox(height: AppDimensions.space16),
            ],
            if (hasJccmAuthorization)
              AppNavigationCard(
                title: l10n.myDataHealthPrimaryCareNavTitle,
                description: l10n.myDataHealthPrimaryCareNavDescription,
                onTap: () => context.go(Routes.myDataHealthPrimaryCareAppointments),
              )
            else
              MyDataDisabledNavigationCard(
                title: l10n.myDataHealthPrimaryCareNavTitle,
                description: l10n.myDataHealthPrimaryCareNavDescription,
              ),
            const SizedBox(height: AppDimensions.space16),
            if (hasJccmAuthorization)
              AppNavigationCard(
                title: l10n.myDataHealthHospitalNavTitle,
                description: l10n.myDataHealthHospitalNavDescription,
                onTap: () => context.go(Routes.myDataHealthHospitalAppointments),
              )
            else
              MyDataDisabledNavigationCard(
                title: l10n.myDataHealthHospitalNavTitle,
                description: l10n.myDataHealthHospitalNavDescription,
              ),
          ],
        ),
      ),
    );
  }
}

/// Abre las autorizaciones en modo preferencias y vuelve a Salud al terminar.
void _openConsentSettings(final BuildContext context) {
  unawaited(
    context.push(
      Uri(
        path: Routes.consent,
        queryParameters: {
          'mode': 'preferences',
          'returnTo': Routes.myDataHealth,
        },
      ).toString(),
    ),
  );
}

class _HealthServicesTab extends ConsumerWidget {
  const _HealthServicesTab();

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
            title: l10n.myDataHealthProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureComplaints,
                onTap: () => _launchExternalUrl(context, config.healthProcedure(0)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureHealthCard,
                onTap: () => _launchExternalUrl(context, config.healthProcedure(1)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthProcedureSpecializedCare,
                onTap: () => _launchExternalUrl(context, config.healthProcedure(2)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataHealthInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkSescam,
                onTap: () => _launchExternalUrl(context, config.sescamUrl),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkDigitalHealth,
                onTap: () => _launchExternalUrl(context, config.digitalHealthUrl),
              ),
              AppExternalLinkItem(
                label: l10n.myDataHealthLinkClinicalHistory,
                onTap: () => _launchExternalUrl(context, config.clinicalHistoryUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchExternalUrl(final BuildContext context, final Uri url) async {
    await launchExternalUrlWithConfirmation(context, url);
  }
}
