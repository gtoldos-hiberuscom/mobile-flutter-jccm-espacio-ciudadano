import 'package:flutter_appauth/flutter_appauth.dart';

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
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
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
