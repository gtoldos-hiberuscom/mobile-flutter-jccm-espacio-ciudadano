import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

/// Initiates a Cl@ve login and returns an [AuthSession] on success.
///
/// Throws [AuthException] on failure.
final class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSession> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) {
    return _repository.login(loginHint: loginHint, scopes: scopes);
  }
}
