import 'package:flutter_appauth/flutter_appauth.dart';
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
/// The caller is responsible for registering or persisting the returned
/// session through the central auth-session controller.
final class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<LoginResult> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) async {
    try {
      final TokenResponse session = await _repository.login(loginHint: loginHint, scopes: scopes);
      final JwtClaims user = await _repository.fetchUserInfo(accessToken: session.accessToken!);

      return LoginSuccess(tokenResponse: session, jwtClaims: user);
    } on Object catch (e) {
      return LoginFailed(message: e.toString(), cause: e);
    }
  }
}
