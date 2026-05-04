import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session_state.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_repository.dart';

/// Initiates a Cl@ve login and persists the resulting session locally.
///
/// Two-step orchestration:
///   1. [AuthRepository.login] talks to Cl@ve and returns the OAuth tokens.
///   2. [AuthSessionRepository.save] persists them and derives the
///      [AuthenticatedSession] (decoding the `id_token` to obtain the
///      citizen's NIF / displayName).
///
/// Throws [AuthException] when Cl@ve fails, or [StateError] when the
/// returned session cannot be assembled (missing / undecodable `id_token`).
final class LoginUseCase {
  const LoginUseCase(this._authRepository, this._sessionRepository);

  final AuthRepository _authRepository;
  final AuthSessionRepository _sessionRepository;

  Future<AuthenticatedSession> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) async {
    final session = await _authRepository.login(
      loginHint: loginHint,
      scopes: scopes,
    );
    return _sessionRepository.save(session);
  }
}
