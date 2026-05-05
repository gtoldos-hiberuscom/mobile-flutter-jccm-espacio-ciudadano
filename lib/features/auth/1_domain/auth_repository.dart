import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';

const List<String> authDefaultScopes = ['openid'];

/// Domain contract for authentication operations.
abstract interface class AuthRepository {
  Future<AuthSession> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  });

  Future<AuthSession> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  });

  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  });

  Future<AuthUser> fetchUserInfo({
    required final String accessToken,
  });
}
