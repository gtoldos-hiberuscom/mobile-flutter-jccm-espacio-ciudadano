import 'package:flutter_appauth/flutter_appauth.dart';

const List<String> authDefaultScopes = ['openid'];

/// Domain contract for authentication operations.
///
/// Implementations must always request full re-authentication
/// (`prompt=login`, `max_age=0`) so the Cl@ve method selector is shown on
/// every attempt regardless of broker cookies.
abstract interface class AuthRepository {
  /// [ephemeralSession] requests an isolated browser context (ephemeral
  /// ASWebAuthenticationSession on iOS/macOS, Ephemeral Custom Tab on Android
  /// via the vendored flutter_appauth fork). On Android, when the browser
  /// cannot guarantee it, the flow aborts with
  /// `AuthException.ephemeralUnavailable` instead of silently sharing cookies.
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool ephemeralSession = true,
  });

  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  });

  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
    final bool ephemeralSession = true,
  });
}
