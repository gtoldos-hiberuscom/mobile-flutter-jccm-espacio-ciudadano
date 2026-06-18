import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Future<void> launchSocialWelfareOfficeContacts(
  final BuildContext context,
  final WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context);
  final ExternalLink? link = ref.read(externalLinkCatalogProvider).findById('jccm_offices_oir');
  if (link == null) {
    AppAlertSnackbar.show(
      context,
      message: l10n.externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
    return;
  }

  final result = await ref.read(externalLinkLauncherProvider).launch(link);
  if (!context.mounted || result is ExternalLinkLaunchSuccess) {
    return;
  }

  AppAlertSnackbar.show(
    context,
    message: l10n.externalLinkOpenFailed,
    severity: AppAlertSeverity.error,
  );
}
