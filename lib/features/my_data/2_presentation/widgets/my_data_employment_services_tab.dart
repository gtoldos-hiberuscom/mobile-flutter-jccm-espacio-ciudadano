import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';

class MyDataEmploymentServicesTab extends StatelessWidget {
  const MyDataEmploymentServicesTab({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space24,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppExternalLinkSection(
            title: l10n.myDataEmploymentProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureProfessionalCertificate,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/tramites'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureJobSeekerRegistration,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/tramites'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureVirtualOfficeCredentials,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/tramites'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataEmploymentInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEmploymentLinkEmploymentClm,
                onTap: () => _launchExternalUrl(context, 'https://empleo.castillalamancha.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentLinkPublicEmploymentClm,
                onTap: () => _launchExternalUrl(context, 'https://empleopublico.castillalamancha.es/'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchExternalUrl(final BuildContext context, final String urlString) async {
  await launchExternalUrlWithConfirmation(context, Uri.parse(urlString));
}
