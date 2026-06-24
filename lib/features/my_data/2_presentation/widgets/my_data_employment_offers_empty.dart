import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDataEmploymentOffersEmpty extends StatelessWidget {
  const MyDataEmploymentOffersEmpty({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppIcon(
              AppIcons.info,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                l10n.myDataEmploymentOffersEmptyMessage,
                style: AppTypography.bodyRegular.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space16),
        AppButton(
          label: l10n.myDataEmploymentInfoSheetOfficeContactsButton,
          onPressed: () => _launchExternalUrl(context, 'https://www.jccm.es/oficinas-oir'),
          hierarchy: AppButtonHierarchy.secondary,
          trailingIcon: AppIcons.openInNew,
        ),
      ],
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
