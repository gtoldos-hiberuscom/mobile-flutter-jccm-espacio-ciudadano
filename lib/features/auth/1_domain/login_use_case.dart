import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/logger/log_redaction.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class LoginResult {}

final class LoginSuccess extends LoginResult {
  LoginSuccess({
    required this.tokenResponse,
    required this.jwtClaims,
    this.sessionIsolationDegraded = false,
  });

  final TokenResponse tokenResponse;
  final JwtClaims jwtClaims;

  /// True when the device browser could not provide an ephemeral (isolated)
  /// session and authentication ran in a shared browser context instead.
  /// The UI must surface a warning: Cl@ve web session state may be remembered
  /// by the browser on this device.
  final bool sessionIsolationDegraded;
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
///
/// An ephemeral (isolated) browser session is attempted first so no Cl@ve web
/// session survives between logins. If the device browser cannot provide one
/// ([AuthException.ephemeralUnavailable], Android-only), the login is retried
/// once in a shared browser context and the result is flagged with
/// [LoginSuccess.sessionIsolationDegraded] so the UI warns the user.
final class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<LoginResult> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) async {
    var isolationDegraded = false;
    try {
      TokenResponse session;
      try {
        session = await _repository.login(
          loginHint: loginHint,
          scopes: scopes,
        );
      } on AuthException catch (e) {
        if (e.reason != AuthFailureReason.ephemeralUnavailable) {
          rethrow;
        }
        isolationDegraded = true;
        session = await _repository.login(
          loginHint: loginHint,
          scopes: scopes,
          ephemeralSession: false,
        );
      }
      final accessToken = session.accessToken!;
      final payload = JwtDecoder.decodePayload(accessToken);
      final JwtClaims user = JwtClaims.fromMap(payload);

      // Temporal diagnostic trace to compare personal and representative
      // certificates. Never print the encoded token itself. In debug builds
      // configured for development/preproduction, values are visible; in all
      // other builds the existing allow-list redaction remains in force.
      logger.d({
        'event': 'auth_claims_access_token',
        'claims': redactForLog(payload),
      });

      return LoginSuccess(
        tokenResponse: session,
        jwtClaims: user,
        sessionIsolationDegraded: isolationDegraded,
      );
    } on Object catch (e) {
      return LoginFailed(message: e.toString(), cause: e);
    }
  }
}
