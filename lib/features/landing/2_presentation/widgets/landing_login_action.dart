import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/demo_mode_confirmation_sheet.dart';

/// Acción de los botones de acceso de la parte pública.
///
/// ⚠️ Solo en la rama de publicación para tiendas (`store/tiendas-demo-login`),
/// no debe llegar a `develop`: la build de revisión sale de PRE, los revisores
/// no están tras la VPN y Cl@ve les falla. Con `DEMO_MODE_ENABLED` el acceso
/// abre directamente la hoja de la demostración; sin él, Cl@ve como siempre.
/// Solo en la home pública y en «Saber más»: «Cómo acceder» sigue con Cl@ve.
Future<void> startLandingLogin(final BuildContext context, final WidgetRef ref) async {
  if (ref.read(appConfigProvider).demoModeEnabled) {
    await openDemoModeEntry(context, ref);
    return;
  }
  await ref.read(landingProvider.notifier).login();
}

/// Abre la hoja de la demostración y, si el ciudadano confirma con el código,
/// entra. Se consulta antes si hay una sesión guardada: entrar la cierra, y
/// eso hay que decirlo antes, no después.
Future<void> openDemoModeEntry(final BuildContext context, final WidgetRef ref) async {
  final notifier = ref.read(landingProvider.notifier);
  final hasPersistedSession = await notifier.hasPersistedSession();
  if (!context.mounted) {
    return;
  }
  final confirmed = await DemoModeConfirmationSheet.show(context, hasPersistedSession: hasPersistedSession);
  if (!context.mounted || !confirmed) {
    return;
  }
  await notifier.enterDemoMode(closePersistedSession: hasPersistedSession);
}
