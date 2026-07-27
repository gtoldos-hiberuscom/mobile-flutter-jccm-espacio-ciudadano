import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> confirmExternalNavigation(final BuildContext context) {
  return AppExternalNavigationDialog.show(context);
}

Future<bool> launchExternalUrlWithConfirmation(
  final BuildContext context,
  final Uri uri,
) async {
  if (!await confirmExternalNavigation(context) || !context.mounted) {
    return false;
  }
  final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!opened && context.mounted) {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
  return opened;
}
