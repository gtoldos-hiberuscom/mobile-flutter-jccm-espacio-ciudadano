import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
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
            error: (final error, final stackTrace) => MyDataAuthorizationContextualHelper(
              message: l10n.myDataAgeAuthorizationRequiredMessage,
              semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta,
              onOpenSettings: _openSettings,
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
            error: (final error, final stackTrace) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MyDataEmploymentDisabledOffersCard(),
                MyDataAuthorizationContextualHelper(
                  onOpenSettings: _openSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openOffers() async {
    final hasAuthorization = await ref.read(employmentOffersAuthorizationProvider.future);
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
