import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class ElevationResult {}

/// El ciudadano se reidentificó, sigue siendo el mismo, y el nivel ya basta.
final class ElevationSucceeded extends ElevationResult {
  ElevationSucceeded({
    required this.tokenResponse,
    required this.jwtClaims,
    required this.reading,
  });

  final TokenResponse tokenResponse;
  final JwtClaims jwtClaims;
  final AuthenticationLevelReading reading;
}

/// Se reidentificó, pero el método elegido **sigue sin alcanzar** el nivel.
///
/// Es un desenlace esperado, no un error: con Cl@ve Permanente sin reforzar se
/// vuelve con el mismo nivel bajo. La sesión nueva **sí se adopta** —es del
/// mismo ciudadano y más reciente que la anterior—, y la pantalla vuelve a
/// bloquear explicando qué falta.
///
/// Nunca se reintenta solo: metería al ciudadano en un carrusel de Cl@ve.
final class ElevationInsufficient extends ElevationResult {
  ElevationInsufficient({
    required this.tokenResponse,
    required this.jwtClaims,
    required this.reading,
  });

  final TokenResponse tokenResponse;
  final JwtClaims jwtClaims;
  final AuthenticationLevelReading reading;
}

/// El token nuevo es **de otra persona**.
///
/// Pasa en un móvil compartido, o al elegir otro certificado. No se adopta el
/// token nuevo, y tampoco vale seguir con el viejo: acaba de identificarse
/// **otra persona** en este dispositivo, y no hay forma de saber si quien lo
/// tiene en la mano sigue siendo el titular de la sesión anterior. Quien llama
/// tiene que cerrar sesión del todo.
final class ElevationIdentityMismatch extends ElevationResult {
  ElevationIdentityMismatch({required this.previous, required this.next, this.idToken});

  final JwtClaims previous;
  final JwtClaims next;

  /// `id_token` de la identificación nueva. No se adopta nada con él: es la
  /// pista para que el siguiente login cierre en el navegador la sesión de esa
  /// otra persona, que de lo contrario Cerbero encontraría viva.
  final String? idToken;
}

/// El ciudadano volvió atrás. Se mantiene el bloqueo, sin ruido.
final class ElevationCancelled extends ElevationResult {}

final class ElevationFailed extends ElevationResult {
  ElevationFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Eleva el nivel de seguridad de la sesión reidentificando al ciudadano.
///
/// **Es el único sitio del código que nombra el mecanismo:** repetir el login
/// **pidiendo el nivel en el scope** (`openid substantial`). La petición ya sale
/// con `prompt=login` a secas, que hace que Cerbero propague
/// `ForceAuthn="true"` y Cl@ve vuelva a desafiar; el scope del nivel es lo que
/// Cerbero traduce al `AuthnContextClassRef` hacia Cl@ve, de modo que el
/// selector solo ofrece métodos que lo alcanzan y Cl@ve Permanente pide el OTP.
/// Sin él, repetir el login devolvía el mismo nivel. No hace falta ningún
/// endpoint nuevo.
///
/// El login normal **no** pide nivel: eso obligaría a todos los ciudadanos a
/// identificarse con nivel medio para entrar en la app.
///
/// `AppConfig.ssoStepUpParameters` sigue disponible para añadir parámetros que
/// exija un entorno sin tocar código.
///
/// No se construye un formulario de OTP propio. El código de prueba que da el
/// documento del cliente para elevar con Cl@ve Permanente describe un paso
/// dentro de la pasarela, no algo que la app deba pedir.
final class ElevateAuthenticationLevelUseCase {
  const ElevateAuthenticationLevelUseCase({
    required final LoginUseCase login,
    required final Map<String, String> stepUpParameters,
  }) : _login = login,
       _stepUpParameters = stepUpParameters;

  final LoginUseCase _login;

  final Map<String, String> _stepUpParameters;

  /// **Lo único que garantiza la reautenticación es `prompt=login`.**
  ///
  /// El contenedor del navegador es **compartido** —`SFSafariViewController` en
  /// iOS, Custom Tab en Android—, así que el estado de Cl@ve sobrevive entre
  /// accesos: la pasarela reidentifica sola durante unos 60 minutos y el estado
  /// del IdP de certificado vive por debajo de las cookies. Nada de eso lo puede
  /// invalidar la app.
  ///
  /// Lo que sí llega es el `ForceAuthn` que Cerbero propaga desde
  /// `prompt=login` (#282296), y por eso la elevación no necesita cerrar ni
  /// limpiar nada antes: basta con volver a atravesar la pasarela.
  ///
  /// **Consecuencia a vigilar en las pruebas:** dentro de esa ventana, el
  /// método de identificación puede no volver a pedirse aunque Cl@ve sí
  /// desafíe, así que una elevación puede volver con el mismo nivel. Ese
  /// desenlace está contemplado ([ElevationInsufficient]) y no es un error.
  Future<ElevationResult> call({
    required final AuthenticationLevel minimum,
    required final JwtClaims currentClaims,
  }) async {
    final result = await _login(
      scopes: [...authDefaultScopes, minimum.cerberoScope],
      extraParameters: _stepUpParameters,
    );

    switch (result) {
      case LoginFailed(:final message, :final cause):
        if (cause is AuthException && cause.reason == AuthFailureReason.cancelled) {
          return ElevationCancelled();
        }
        return ElevationFailed(message: message, cause: cause);

      case LoginSuccess(:final tokenResponse, :final jwtClaims):
        // Identidad primero, nivel después: un token de otra persona no se
        // adopta aunque su nivel baste.
        if (!currentClaims.identifiesSamePersonAs(jwtClaims)) {
          return ElevationIdentityMismatch(previous: currentClaims, next: jwtClaims, idToken: tokenResponse.idToken);
        }

        // Misma regla que el gate: si aquí se leyera solo el access token, un
        // nivel que viaje en el id token daría la elevación por insuficiente
        // con el gate ya abierto.
        final reading = AuthenticationLevelReading.fromSession(accessTokenClaims: jwtClaims, idToken: tokenResponse.idToken);
        if (!reading.meets(minimum)) {
          return ElevationInsufficient(
            tokenResponse: tokenResponse,
            jwtClaims: jwtClaims,
            reading: reading,
          );
        }
        return ElevationSucceeded(
          tokenResponse: tokenResponse,
          jwtClaims: jwtClaims,
          reading: reading,
        );
    }
  }
}
