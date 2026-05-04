import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_repository.dart';

/// Terminates the current Cl@ve session and clears the persisted local data.
///
/// Two-step orchestration:
///   1. [AuthRepository.logout] hits the OIDC end-session endpoint
///      (best-effort: a remote failure does not block local cleanup).
///   2. [AuthSessionRepository.clear] wipes `SecureStorage` and emits
///      `UnauthenticatedSession`.
///
/// Errors raised by step 1 are swallowed — the local session is the source
/// of truth for "logged out".
final class LogoutUseCase {
  const LogoutUseCase(this._authRepository, this._sessionRepository);

  final AuthRepository _authRepository;
  final AuthSessionRepository _sessionRepository;

  Future<void> call({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {
    try {
      await _authRepository.logout(
        idToken: idToken,
        postLogoutRedirectUri: postLogoutRedirectUri,
      );
    } on AuthException {
      // best-effort: the local wipe below is what matters.
    }
    await _sessionRepository.clear();
  }
}
