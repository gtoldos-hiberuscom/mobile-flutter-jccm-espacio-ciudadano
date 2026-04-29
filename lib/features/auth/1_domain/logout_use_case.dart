import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

/// Terminates the current Cl@ve session via the end-session endpoint.
///
/// Throws [AuthException] on failure.
final class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) {
    return _repository.logout(
      idToken: idToken,
      postLogoutRedirectUri: postLogoutRedirectUri,
    );
  }
}
