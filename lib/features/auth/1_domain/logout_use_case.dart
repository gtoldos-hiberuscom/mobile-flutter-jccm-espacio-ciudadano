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
      await _repository.logout(
        idToken: idToken,
        postLogoutRedirectUri: postLogoutRedirectUri,
      );
      return LogoutSuccess();
    } on Object catch (e) {
      return LogoutFailed(message: e.toString(), cause: e);
    }
  }
}
