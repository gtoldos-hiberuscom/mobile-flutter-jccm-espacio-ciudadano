import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_offers_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_required_state.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offers_content.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offers_load_error.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentOffersPage extends ConsumerWidget {
  const MyDataEmploymentOffersPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final offersAsync = ref.watch(employmentOfferRegistrationsProvider);

    return AppDetailScaffold(
      title: l10n.myDataEmploymentOffersPageTitle,
      onBack: () => context.go(Routes.myDataEmployment),
      onInfo: () => _showInfoSheet(context),
      appBarBackgroundColor: AppColors.backgroundBlueLighter,
      body: offersAsync.when(
        data: (final offers) => MyDataEmploymentOffersContent(offers: offers),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stackTrace) => error is MyDataAuthorizationRequired
            ? MyDataAuthorizationRequiredState(
                returnTo: Routes.myDataEmploymentOffers,
                message: l10n.myDataEmploymentOffersAuthorizationRequiredMessage,
                showTextAction: true,
                onAuthorized: () => ref.invalidate(employmentOfferRegistrationsProvider),
              )
            : MyDataEmploymentOffersLoadError(
                onRetry: () => ref.invalidate(employmentOfferRegistrationsProvider),
              ),
      ),
    );
  }

  Future<void> _showInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataEmploymentOffersInfoSheetTitle,
      bodyText: l10n.myDataEmploymentOffersInfoSheetDescription,
      footerText: l10n.myDataEmploymentOffersInfoSheetFooter,
      actionLabel: l10n.myDataEmploymentInfoSheetOfficeContactsButton,
      onActionPressed: () => launchExternalUrlWithConfirmation(
        context,
        Uri.parse('https://empleo.castillalamancha.es/'),
      ),
      actionIcon: AppIcons.openInNew,
      actionIsExternalLink: true,
    );
  }
}
