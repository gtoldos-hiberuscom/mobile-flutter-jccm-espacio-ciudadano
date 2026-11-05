import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_representative_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Explains why a section cannot be queried with a representative certificate.
/// Routing blocks the request before the page providers can call the backend.
class RepresentativeUnavailablePage extends StatelessWidget {
  const RepresentativeUnavailablePage({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: l10n.representativeUnavailableTitle,
        onBack: () => _goBack(context),
        leading: IconButton(
          onPressed: () => _goBack(context),
          tooltip: l10n.a11yBack,
          icon: const AppIcon(
            AppIcons.arrowBack,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: appPagePadding(
            context,
            top: AppDimensions.space24,
            bottom: AppDimensions.space24,
          ),
          child: const MyDataRepresentativeUnavailableAlert(),
        ),
      ),
    );
  }

  void _goBack(final BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }
}
