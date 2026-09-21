import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

// Las pantallas eligen el modo de apertura, así que necesitan el enum; se
// reexporta aquí para que no tengan que depender de url_launcher.
export 'package:url_launcher/url_launcher.dart' show LaunchMode;

Future<bool> confirmExternalNavigation(final BuildContext context) {
  return AppExternalNavigationDialog.show(context);
}

/// [mode] por defecto abre en el navegador del sistema, que es lo que hace
/// falta para la mayoría de los enlaces.
///
/// `LaunchMode.inAppBrowserView` se usa en los portales de JCCM integrados con
/// Cerbero: en iOS es un `SFSafariViewController`, que comparte almacén con el
/// que abre el login, y por eso el portal llega ya identificado. En Android es
/// una Custom Tab, que usa el mismo tarro de cookies que el navegador del
/// sistema, así que el SSO se mantiene igual.
Future<bool> launchExternalUrlWithConfirmation(
  final BuildContext context,
  final Uri uri, {
  final LaunchMode mode = LaunchMode.externalApplication,
}) async {
  if (!await confirmExternalNavigation(context) || !context.mounted) {
    return false;
  }
  final opened = await launchUrl(uri, mode: mode);
  if (!opened && context.mounted) {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
  return opened;
}
