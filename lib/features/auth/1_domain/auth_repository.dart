import 'package:flutter_appauth/flutter_appauth.dart';

const List<String> authDefaultScopes = ['openid'];

/// Domain contract for authentication operations.
///
/// Implementations must always request full re-authentication
/// (`prompt=login`, `max_age=0`) so the Cl@ve method selector is shown on
/// every attempt regardless of broker cookies.
abstract interface class AuthRepository {
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  });

  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  });

  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  });
}
