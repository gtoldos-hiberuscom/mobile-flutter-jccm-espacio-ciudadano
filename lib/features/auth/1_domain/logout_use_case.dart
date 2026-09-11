import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class LogoutResult {}

final class LogoutSuccess extends LogoutResult {}

final class LogoutFailed extends LogoutResult {
  LogoutFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Terminates the current Cl@ve session via the end-session endpoint.
final class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<LogoutResult> call({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {
    try {
      try {
        await _repository.logout(
          idToken: idToken,
          postLogoutRedirectUri: postLogoutRedirectUri,
        );
      } on AuthException catch (e) {
        if (e.reason != AuthFailureReason.ephemeralUnavailable) {
          rethrow;
        }
        // The device browser cannot provide an ephemeral session. Retry in a
        // shared context silently: logout is best-effort and the RP-initiated
        // logout (id_token_hint) closes the Keycloak session either way.
        await _repository.logout(
          idToken: idToken,
          postLogoutRedirectUri: postLogoutRedirectUri,
          ephemeralSession: false,
        );
      }
      return LogoutSuccess();
    } on Object catch (e) {
      return LogoutFailed(message: e.toString(), cause: e);
    }
  }
}
