import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_screen.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Envuelve [child] con el velo de "Accediendo con Cl@ve" mientras
/// [isAuthenticating].
///
/// El guard de sesión hace comprobaciones asíncronas antes de que el router
/// pinte la home privada, así que sin el velo la pantalla anterior se queda a
/// la vista durante ese hueco y se percibe como una redirección extraña.
///
/// Vive aparte porque hay **dos** sitios desde los que se accede con Cl@ve —la
/// home pública y "Saber más sobre Espacio Ciudadano"—, y el segundo se quedó
/// sin él: desde ahí se pulsaba "Acceder" y no ocurría nada visible hasta que
/// abría el navegador.
class ClaveLoginVeil extends StatelessWidget {
  const ClaveLoginVeil({
    required this.isAuthenticating,
    required this.child,
    super.key,
  });

  final bool isAuthenticating;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    if (!isAuthenticating) {
      return child;
    }
    final l10n = AppLocalizations.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // El velo es azul oscuro y cubre también la franja de la barra de estado:
      // con los iconos en su color habitual (oscuro, para fondos claros) la
      // barra parecía tapada.
      value: SystemUiOverlayStyle.light,
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: AppLoadingScreen(
              title: l10n.loginPageTitle,
              description: l10n.loginPageLoadingDescription,
            ),
          ),
        ],
      ),
    );
  }
}
