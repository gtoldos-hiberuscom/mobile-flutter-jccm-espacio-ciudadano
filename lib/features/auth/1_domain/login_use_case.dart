import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class LoginResult {}

final class LoginSuccess extends LoginResult {
  LoginSuccess({required this.tokenResponse, required this.jwtClaims});

  final TokenResponse tokenResponse;
  final JwtClaims jwtClaims;
}

final class LoginFailed extends LoginResult {
  LoginFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Authenticates the citizen via the Cl@ve OIDC flow.
///
/// Persists the access token in [SecureStorage] so it is available to the
/// network auth interceptor for subsequent requests.  The caller is responsible
/// for updating any in-memory notifiers (e.g. `TokenResponseNotifier`,
/// `JwtClaimsNotifier`) with the values in [LoginSuccess].
final class LoginUseCase {
  const LoginUseCase(this._repository, this._secureStorage);

  final AuthRepository _repository;
  final SecureStorage _secureStorage;

  Future<LoginResult> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) async {
    try {
      final TokenResponse session =
          await _repository.login(loginHint: loginHint, scopes: scopes);
      final JwtClaims user =
          await _repository.fetchUserInfo(accessToken: session.accessToken!);

      await Future.wait([
        _secureStorage.write(StorageKeys.accessToken, session.accessToken!),
        if (session.refreshToken != null)
          _secureStorage.write(
              StorageKeys.refreshToken, session.refreshToken!),
        if (session.accessTokenExpirationDateTime != null)
          _secureStorage.write(
            StorageKeys.sessionExpiresAt,
            session.accessTokenExpirationDateTime!.toIso8601String(),
          ),
      ]);

      return LoginSuccess(tokenResponse: session, jwtClaims: user);
    } on Object catch (e) {
      return LoginFailed(message: e.toString(), cause: e);
    }
  }
}
