import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_offers_provider.dart';
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
        error: (final error, final stackTrace) => MyDataEmploymentOffersLoadError(
          onRetry: () => ref.invalidate(employmentOfferRegistrationsProvider),
        ),
      ),
    );
  }

  Future<void> _showInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataEmploymentOffersPageTitle,
      bodyText: l10n.myDataEmploymentOffersInfoSheetDescription,
      // El ciudadano no puede corregir sus inscripciones desde aquí: el sitio
      // donde se gestionan es el Portal de empleabilidad.
      footerText: l10n.myDataEmploymentOffersInfoSheetFooter,
    );
  }
}
