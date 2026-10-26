import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_elevation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/digital_health_access.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment_access.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_disabled_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_health_cip_field.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_representative_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

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
  /// Nulo hasta que el ciudadano elija; la pantalla siempre abre en «Mis
  /// datos», también para representantes, donde se muestra la restricción.
  _HealthTab? _selectedTab;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isRepresentative = ref.watch(jwtClaimsProvider.select((final claims) => claims?.isRepresentative ?? false));
    final selectedTab = _selectedTab ?? _HealthTab.data;

    return AppTabbedDetailScaffold(
      title: l10n.myDataHealthTitle,
      onBack: () => context.go(widget.backRoute),
      tabs: [l10n.myDataHealthDataTab, l10n.myDataHealthServicesTab],
      selectedIndex: selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _HealthTab.values[index]),
      tabViews: [
        if (isRepresentative) const MyDataRepresentativeUnavailable() else const _HealthMenuTab(),
        const _HealthServicesTab(),
      ],
    );
  }
}

enum _HealthTab { data, services }

/// El CIP y las dos consultas de citas, como tarjetas de navegación.
///
/// El CIP vive **solo aquí** (Figma `45045:57735`): es del ciudadano, no de una
/// consulta, así que se muestra una vez encima de las dos y no se repite dentro.
class _HealthMenuTab extends ConsumerWidget {
  const _HealthMenuTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Se avisa en la tarjeta de que hospitalaria pedirá verificar la identidad,
    // con el mismo umbral que aplica el gate de la consulta.
    final hospitalNeedsVerification = !ref.watch(authenticationLevelProvider).meets(kHospitalAppointmentsMinimumLevel);

    return ref
        .watch(jccmDataAuthorizationProvider)
        .when(
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
                if (hasJccmAuthorization) ...[
                  // Sin autorización no se puede consultar al SESCAM: el CIP sale
                  // solo cuando hay con qué pedirlo.
                  const MyDataHealthCipField(),
                  const SizedBox(height: AppDimensions.space16),
                  AppNavigationCard(
                    title: l10n.myDataHealthPrimaryCareNavTitle,
                    onTap: () => context.go(Routes.myDataHealthPrimaryCareAppointments),
                  ),
                ] else
                  MyDataDisabledNavigationCard(title: l10n.myDataHealthPrimaryCareNavTitle),
                const SizedBox(height: AppDimensions.space16),
                if (hasJccmAuthorization)
                  AppNavigationCard(
                    title: l10n.myDataHealthHospitalNavTitle,
                    description: hospitalNeedsVerification ? l10n.myDataHealthHospitalNavVerificationRequired : null,
                    descriptionIcon: hospitalNeedsVerification ? AppIcons.lock : null,
                    onTap: () => context.go(Routes.myDataHealthHospitalAppointments),
                  )
                else
                  MyDataDisabledNavigationCard(title: l10n.myDataHealthHospitalNavTitle),
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

class _HealthServicesTab extends ConsumerStatefulWidget {
  const _HealthServicesTab();

  @override
  ConsumerState<_HealthServicesTab> createState() => _HealthServicesTabState();
}

class _HealthServicesTabState extends ConsumerState<_HealthServicesTab> {
  bool _isShowingVerification = false;

  /// Abre Mi Salud Digital, elevando antes el nivel si la sesión no lo alcanza.
  ///
  /// Mismo aviso, misma preferencia de «No volver a mostrar» y misma elevación
  /// que las citas hospitalarias (`_LevelBlockedState`). La diferencia es que
  /// aquí no hay pantalla que bloquear: el desenlace se espera en el sitio y,
  /// si basta, se abre el enlace sin otro aviso de navegación externa, porque
  /// el ciudadano ya decidió ir y acaba de pasar por Cl@ve.
  ///
  /// Con nivel suficiente se abre en la pestaña integrada, como Educamos:
  /// comparte la sesión de Cerbero del login y Mi Salud Digital entra ya
  /// identificado.
  Future<void> _openDigitalHealth() async {
    if (ref.read(authenticationLevelProvider).meets(kDigitalHealthMinimumLevel)) {
      await _launchExternalUrl(context, ref.read(appConfigProvider).digitalHealthUrl, mode: LaunchMode.inAppBrowserView);
      return;
    }
    await _verifyIdentityThenOpenDigitalHealth();
  }

  /// [message] es el motivo de un intento anterior; con él el aviso sale
  /// siempre, aunque el ciudadano pidiera no volver a verlo.
  Future<void> _verifyIdentityThenOpenDigitalHealth({final String? message}) async {
    if (message != null || !_isVerificationNoticeSuppressed) {
      if (_isShowingVerification) {
        return;
      }
      _isShowingVerification = true;
      final choice = await AppIdentityVerificationDialog.show(context, message: message);
      _isShowingVerification = false;
      if (!mounted) {
        return;
      }
      // La preferencia se guarda con cualquiera de los dos botones: es sobre el
      // aviso, no sobre la decisión de ir o no a Cl@ve.
      if (choice?.suppressFuture ?? false) {
        final key = _verificationNoticeSuppressionKey;
        if (key != null) {
          unawaited(ref.read(appStorageProvider).write(key, true));
        }
      }
      if (choice == null || !choice.accepted) {
        return;
      }
    }

    final notifier = ref.read(elevationProvider.notifier)..acknowledge();
    await notifier.elevate(minimum: kDigitalHealthMinimumLevel);
    if (!mounted) {
      return;
    }
    final outcome = ref.read(elevationProvider).outcome;
    notifier.acknowledge();
    final l10n = AppLocalizations.of(context);
    switch (outcome) {
      case ElevationOutcome.succeeded:
        final opened = await launchUrl(ref.read(appConfigProvider).digitalHealthUrl, mode: LaunchMode.inAppBrowserView);
        if (!opened && mounted) {
          AppAlertSnackbar.show(context, message: l10n.externalLinkOpenFailed, severity: AppAlertSeverity.error);
        }
      // El motivo sale **siempre**, aunque se pidiera no volver a ver el aviso:
      // es otro mensaje, y saltárselo relanzaría Cl@ve sin que lo pida nadie.
      case ElevationOutcome.stillInsufficient:
        await _verifyIdentityThenOpenDigitalHealth(message: l10n.myDataHealthLevelStillInsufficientMessage);
      case ElevationOutcome.failed:
        await _verifyIdentityThenOpenDigitalHealth(message: l10n.myDataHealthLevelElevationFailedMessage);
      // Otra persona: la sesión ya es suya y entra como en un login nuevo, por
      // el inicio; Mi Salud Digital no se abre a quien no lo ha pedido.
      case ElevationOutcome.identitySwitched:
        AppAlertSnackbar.show(context, message: l10n.identityVerificationSwitchedMessage);
        context.go(Routes.home);
      // Cancelar deja al ciudadano en Salud, sin relanzar Cl@ve.
      case ElevationOutcome.cancelled:
      case null:
        return;
    }
  }

  String? get _verificationNoticeSuppressionKey {
    final idAgente = ref.read(citizenEndpointIdsProvider).idAgente;
    return idAgente == null || idAgente.isEmpty
        ? null
        : '${StorageKeys.identityVerificationNoticeSuppressedPrefix}$idAgente';
  }

  bool get _isVerificationNoticeSuppressed {
    final key = _verificationNoticeSuppressionKey;
    return key != null && (ref.read(appStorageProvider).read<bool>(key) ?? false);
  }

  @override
  Widget build(final BuildContext context) {
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
                onTap: () => unawaited(_openDigitalHealth()),
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

  Future<void> _launchExternalUrl(
    final BuildContext context,
    final Uri url, {
    final LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    await launchExternalUrlWithConfirmation(context, url, mode: mode);
  }
}
