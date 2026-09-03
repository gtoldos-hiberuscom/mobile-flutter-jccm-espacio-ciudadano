import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_required_state.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_authorization_dialog.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_demand_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_disabled_offers_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offers_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_server_error.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentDataTab extends ConsumerStatefulWidget {
  const MyDataEmploymentDataTab({super.key});

  @override
  ConsumerState<MyDataEmploymentDataTab> createState() => _MyDataEmploymentDataTabState();
}

class _MyDataEmploymentDataTabState extends ConsumerState<MyDataEmploymentDataTab> {
  bool _showUnavailableBanner = true;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ageAuthorizationAsync = ref.watch(ageDataAuthorizationProvider);
    final jccmAuthorizationAsync = ref.watch(jccmDataAuthorizationProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ageAuthorizationAsync.when(
            data: (final hasAgeAuthorization) {
              if (!hasAgeAuthorization) {
                return MyDataAuthorizationContextualHelper(
                  message: l10n.myDataAgeAuthorizationRequiredMessage,
                  semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta,
                  onOpenSettings: _openSettings,
                );
              }

              final demandAsync = ref.watch(employmentDemandProvider);
              // Rechazo de autorización (respuesta de negocio) ≠ error de servicio.
              if (demandAsync.error is MyDataAuthorizationRequired) {
                return MyDataAuthorizationRequiredState(returnTo: Routes.myDataEmployment, onAuthorized: () => ref.invalidate(employmentDemandProvider));
              }
              if (demandAsync.hasError) {
                return MyDataEmploymentServerError(
                  showBanner: _showUnavailableBanner,
                  onDismiss: () => setState(() => _showUnavailableBanner = false),
                  onRetry: () {
                    setState(() => _showUnavailableBanner = true);
                    ref.invalidate(employmentDemandProvider);
                  },
                  onOpenSettings: _openSettings,
                );
              }

              return demandAsync.when(
                data: (final demand) => demand == null ? const MyDataEmploymentDemandEmpty() : MyDataEmploymentDemandCard(demand: demand),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.space24),
                    child: AppLoadingIndicator(),
                  ),
                ),
                error: (final error, final stackTrace) => const SizedBox.shrink(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.space24),
                child: AppLoadingIndicator(),
              ),
            ),
            // Fallo del check ≠ "no autorizado": sin respuesta del backend solo
            // cabe error + reintentar, nunca afirmar que falta el consentimiento.
            error: (final error, final stackTrace) => ErrorStateWidget(
              message: l10n.authorizationCheckFailedMessage,
              onRetry: () => ref.invalidate(ageDataAuthorizationProvider),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          jccmAuthorizationAsync.when(
            data: (final hasJccmAuthorization) {
              if (hasJccmAuthorization) {
                return MyDataEmploymentOffersCard(
                  onTap: _openOffers,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MyDataEmploymentDisabledOffersCard(),
                  MyDataAuthorizationContextualHelper(
                    onOpenSettings: _openSettings,
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.space24),
                child: AppLoadingIndicator(),
              ),
            ),
            // Fallo del check ≠ "no autorizado": sin respuesta del backend solo
            // cabe error + reintentar, nunca afirmar que falta el consentimiento.
            error: (final error, final stackTrace) => ErrorStateWidget(
              message: l10n.authorizationCheckFailedMessage,
              onRetry: () => ref.invalidate(jccmDataAuthorizationProvider),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openOffers() async {
    // El provider lanza cuando el check no puede evaluarse (backend caído):
    // eso es un fallo, no "sin autorización" — avisar y no bloquear con el
    // diálogo de autorizar.
    final bool hasAuthorization;
    try {
      hasAuthorization = await ref.read(employmentOffersAuthorizationProvider.future);
    } on Object catch (error) {
      logger.e('Employment offers authorization check unavailable: $error');
      if (mounted) {
        AppAlertSnackbar.show(
          context,
          message: AppLocalizations.of(context).authorizationCheckFailedMessage,
          severity: AppAlertSeverity.error,
        );
      }
      return;
    }
    if (!mounted) {
      return;
    }

    if (!hasAuthorization) {
      await MyDataEmploymentAuthorizationDialog.show(
        context,
        onOpenAuthorizations: () => context.push(
          Uri(
            path: Routes.consent,
            queryParameters: {
              'mode': 'preferences',
              'returnTo': Routes.myDataEmployment,
            },
          ).toString(),
        ),
      );
      return;
    }

    context.go(Routes.myDataEmploymentOffers);
  }

  void _openSettings() {
    unawaited(
      context.push(
        Uri(
          path: Routes.consent,
          queryParameters: {
            'mode': 'preferences',
            'returnTo': Routes.myDataEmployment,
          },
        ).toString(),
      ),
    );
  }
}
