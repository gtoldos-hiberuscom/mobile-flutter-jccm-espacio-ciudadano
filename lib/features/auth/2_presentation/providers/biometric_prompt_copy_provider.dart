import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Copia del diálogo biométrico para los refrescos que **no** nacen de una
/// pantalla.
///
/// El guard de rutas y el interceptor de Dio renuevan la sesión sin
/// `BuildContext`, así que no pueden traducir nada: dejaban la copia en `null`
/// y Android sacaba su texto genérico. Y es justo el diálogo que más necesita
/// explicarse, porque el ciudadano no ha pedido nada — sólo ha navegado y le
/// salta un lector de huella.
///
/// El texto es distinto del de la reanudación a propósito: allí el ciudadano
/// está entrando, aquí ya está dentro.
final biometricPromptCopyProvider = Provider<BiometricPromptCopy>((final ref) {
  final l10n = lookupAppLocalizations(_deviceLocale());
  return BiometricPromptCopy(
    title: l10n.sessionContinueBiometricTitle,
    subtitle: l10n.sessionContinueBiometricReason,
    cancelLabel: l10n.sessionUnlockBiometricCancel,
  );
});

/// Idiomas declarados en `supportedLocales`. `lookupAppLocalizations` lanza
/// con cualquier otro, así que un idioma no soportado cae al del template.
const List<String> _supportedLanguages = ['es', 'en'];

/// `lookupAppLocalizations` es síncrono, así que el idioma del dispositivo
/// basta: no hace falta el árbol de widgets para resolver la copia.
Locale _deviceLocale() {
  final String language = PlatformDispatcher.instance.locale.languageCode;
  return Locale(_supportedLanguages.contains(language) ? language : 'es');
}
