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

  /// El acceso salió bien, pero **sin sesión aislada**: el navegador del
  /// dispositivo no podía darla y se entró en el contenedor compartido.
  ///
  /// La UI tiene que avisarlo. No es un detalle técnico: significa que en ese
  /// dispositivo el estado de Cl@ve puede sobrevivir al cierre de sesión, que
  /// es justo lo que el aislamiento evita.
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
final class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<LoginResult> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
    final Map<String, String> extraParameters = const <String, String>{},
  }) async {
    try {
      // Se intenta **siempre** con aislamiento. Si el navegador no puede darlo,
      // el repositorio aborta antes de abrir nada
      // (`AuthFailureReason.ephemeralUnavailable`) y aquí se decide entrar
      // igualmente en el contenedor compartido, marcándolo para que la UI
      // avise. Dejar al ciudadano sin poder acceder sería peor; hacerlo en
      // silencio, también.
      var isolationDegraded = false;
      TokenResponse session;
      try {
        session = await _repository.login(
          loginHint: loginHint,
          scopes: scopes,
          extraParameters: extraParameters,
        );
      } on AuthException catch (e) {
        if (e.reason != AuthFailureReason.ephemeralUnavailable) {
          rethrow;
        }
        isolationDegraded = true;
        session = await _repository.login(
          loginHint: loginHint,
          scopes: scopes,
          isolateSession: false,
          extraParameters: extraParameters,
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
