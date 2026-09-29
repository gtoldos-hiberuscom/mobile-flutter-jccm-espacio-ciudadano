import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guardia del contrato con el fork vendorizado (`packages/flutter_appauth`,
/// ver `CHANGELOG_JCCM.md`).
///
/// El lado Android del fork no lee un nombre: lee el **índice del enum** que el
/// platform interface serializa por el MethodChannel, y compara contra su
/// constante `EPHEMERAL_EXTERNAL_USER_AGENT = 1`. Si un día ese índice cambia
/// —porque alguien reordene el enum al subir
/// `flutter_appauth_platform_interface`—, Android dejaría de pedir sesión
/// aislada **en silencio**: el login seguiría funcionando y el certificado
/// volvería a quedarse pegado, sin que nada falle a la vista.
///
/// Este test es lo único que lo avisa. Si se pone rojo, hay que actualizar a la
/// vez la constante del fork y este fichero.
void main() {
  test('los índices de ExternalUserAgent siguen casando con el fork', () {
    expect(ExternalUserAgent.asWebAuthenticationSession.index, 0);
    expect(ExternalUserAgent.ephemeralAsWebAuthenticationSession.index, 1);
    // El del login de iOS y el del logout de las dos plataformas.
    expect(ExternalUserAgent.sfSafariViewController.index, 2);
  });
}
