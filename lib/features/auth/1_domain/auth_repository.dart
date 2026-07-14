import 'package:flutter_appauth/flutter_appauth.dart';

const List<String> authDefaultScopes = ['openid'];

/// Domain contract for authentication operations.
abstract interface class AuthRepository {
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool forceLogin = false,
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
