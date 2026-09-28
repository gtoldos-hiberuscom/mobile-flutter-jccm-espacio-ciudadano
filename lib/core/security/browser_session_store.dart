import 'package:flutter/services.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';

/// Acceso al almacén de datos del navegador embebido de la app.
///
/// En iOS, el login de Cl@ve y los portales de JCCM comparten el contenedor de
/// `SFSafariViewController` — es lo que hace que Empleo y Educamos abran ya
/// identificados (`documentation/sso_portales_externos.md`, §6). Ese mismo
/// contenedor es el que conserva el estado del IdP de certificado y permite
/// entrar como el ciudadano anterior tras cerrar sesión (§10).
///
/// **POC en curso (§10.6).** Lo que hay que medir es si vaciar ese almacén se
/// lleva también el estado del certificado o sólo las cookies: Apple documenta
/// «local storage, cached resources and cookies» y no dice nada del
/// certificado. Si se lo lleva, esta es la vía que conserva el SSO — se comparte
/// mientras dura la sesión y se vacía al salir.
///
/// Android no expone ningún equivalente: la Custom Tab vive en el navegador del
/// ciudadano y una app no puede vaciarlo.
final class BrowserSessionStore {
  const BrowserSessionStore({final MethodChannel channel = _defaultChannel}) : _channel = channel;

  static const MethodChannel _defaultChannel = MethodChannel('es.jccm.espaciociudadano/browser_session');

  final MethodChannel _channel;

  /// Vacía el almacén del navegador de la app.
  ///
  /// Devuelve `true` sólo si la plataforma lo hizo de verdad. `false` en Android
  /// (no hay canal) y en iOS 15 (la API es iOS 16+, y el mínimo de la app es
  /// 15). Nunca propaga: no poder limpiar no puede impedir cerrar sesión.
  Future<bool> clearWebsiteData() async {
    try {
      final bool? cleared = await _channel.invokeMethod<bool>('clearWebsiteData');
      if (cleared ?? false) {
        logger.i('Browser website data cleared');
        return true;
      }
      logger.i('Browser website data not cleared: unsupported on this platform or OS version');
      return false;
    } on MissingPluginException {
      // Android: el canal no existe, y es lo esperado.
      return false;
    } on Object catch (error, stackTrace) {
      logger.w('Could not clear the browser website data', error: error, stackTrace: stackTrace);
      return false;
    }
  }
}
