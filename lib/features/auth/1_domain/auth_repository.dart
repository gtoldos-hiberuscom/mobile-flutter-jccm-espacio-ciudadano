import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';

/// Default OAuth2 scopes for Cl@ve authentication.
const List<String> authDefaultScopes = ['openid'];

/// Domain contract for authentication operations.
abstract interface class AuthRepository {
  /// Initiates the Cl@ve authorization-code + token exchange flow.
  ///
  /// Throws [AuthException] on failure.
  Future<AuthSession> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  });

  /// Refreshes an existing session using a valid refresh token.
  ///
  /// Throws [AuthException] on failure.
  Future<AuthSession> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  });

  /// Terminates the session via the Cl@ve end-session endpoint.
  ///
  /// Throws [AuthException] on failure.
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  });

  /// Fetches the authenticated user's identity claims from the userinfo endpoint.
  ///
  /// Throws [AuthException] on failure.
  Future<AuthUser> fetchUserInfo({
    required final String accessToken,
  });

  /// Decodes an OIDC `id_token` (compact JWT) and builds an [AuthUser] from
  /// its payload claims (`sub`, `nif` or `idAgente`, `given_name`,
  /// `family_name`, `email`).
  ///
  /// Pure transformation — no I/O, no signature verification (the token has
  /// already been validated by the AppAuth library at the OIDC endpoint).
  /// Returns `null` when the token cannot be decoded or lacks a `sub` claim.
  AuthUser? decodeIdTokenUser(final String idToken);
}
