import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentServicesTab extends ConsumerWidget {
  const MyDataEmploymentServicesTab({super.key});

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
            title: l10n.myDataEmploymentProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureProfessionalCertificate,
                onTap: () => _launchExternalUrl(context, config.employmentProcedure(0)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureJobSeekerRegistration,
                onTap: () => _launchExternalUrl(context, config.employmentProcedure(1)),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureVirtualOfficeCredentials,
                onTap: () => _launchExternalUrl(context, config.employmentProcedure(2)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataEmploymentInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEmploymentLinkEmploymentClm,
                // En pestaña integrada a propósito: comparte la sesión del
                // navegador con la del login, y por eso Empleo CLM abre ya
                // identificado (#282847, análisis de SSO con portales).
                onTap: () => _launchExternalUrl(
                  context,
                  config.employmentUrl,
                  mode: LaunchMode.inAppBrowserView,
                ),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentLinkPublicEmploymentClm,
                onTap: () => _launchExternalUrl(context, config.publicEmploymentUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchExternalUrl(
  final BuildContext context,
  final Uri url, {
  final LaunchMode mode = LaunchMode.externalApplication,
}) async {
  await launchExternalUrlWithConfirmation(context, url, mode: mode);
}
