import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';

const List<String> authDefaultScopes = ['openid'];

/// Keycloak scope that turns the issued refresh token into an *offline* token:
/// one hanging off an offline session, with the realm's offline lifetimes
/// instead of the online SSO ones. Only requested where the environment
/// declares the client has it assigned (`AppConfig.ssoOfflineAccess`);
/// requesting it elsewhere fails the authorization request with
/// `invalid_scope`.
const String offlineAccessScope = 'offline_access';

/// Domain contract for authentication operations.
///
/// Implementations must always request full re-authentication
/// (`prompt=login` **a secas**, `max_age=0`) so the Cl@ve method selector is
/// shown on every attempt regardless of browser cookies. El valor exacto del
/// `prompt` importa: Cerbero lo compara entero contra `"login"` y cualquier
/// combinación adicional apaga el `ForceAuthn` hacia Cl@ve (#282296).
abstract interface class AuthRepository {
  /// [isolateSession] pide que el login ocurra en un contenedor de navegador
  /// **aislado**, que se destruye al terminar, para que no sobreviva estado de
  /// Cl@ve entre accesos.
  ///
  /// Es una petición, no una garantía: dónde se puede cumplir lo decide la
  /// implementación —hoy sólo Android, ver `AuthRepositoryImpl`—. Si se pide y
  /// el navegador del dispositivo no puede darlo, el flujo **aborta con
  /// [AuthFailureReason.ephemeralUnavailable] antes de abrir nada**, para que
  /// quien llama decida: nunca se comparte el contenedor en silencio.
  ///
  /// Pasar `false` es exactamente eso — entrar a sabiendas sin aislamiento—, y
  /// es lo que hace `LoginUsecase` al reintentar, avisando al ciudadano.
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool isolateSession = true,
  });

  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  });

  /// Revoca en Keycloak la sesión **offline** asociada a [refreshToken].
  ///
  /// El `endSession` de [logout] es de front-channel: cierra la sesión SSO del
  /// navegador, pero las sesiones offline le sobreviven. Sin esto se acumulan
  /// en el servidor —también las de quien nunca llegó a usar el acceso rápido,
  /// porque el scope se pide en todos los logins— y un dispositivo robado
  /// conservaría acceso pese a haber cerrado sesión.
  Future<void> revokeOfflineSession({required final String refreshToken});

  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  });
}
