import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/auth_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/auth_user_notifier.dart';

final class LoginUseCase {
  const LoginUseCase(
    this._repository,
    this._sessionNotifier,
    this._userNotifier,
    this._secureStorage,
  );

  final AuthRepository _repository;
  final AuthSessionNotifier _sessionNotifier;
  final AuthUserNotifier _userNotifier;
  final SecureStorage _secureStorage;

  Future<(AuthSession, AuthUser)> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) async {
    final session = await _repository.login(loginHint: loginHint, scopes: scopes);
    final user = await _repository.fetchUserInfo(accessToken: session.accessToken);

    await Future.wait([
      _secureStorage.write(StorageKeys.accessToken, session.accessToken),
      if (session.refreshToken != null)
        _secureStorage.write(StorageKeys.refreshToken, session.refreshToken!),
      if (session.accessTokenExpiresAt != null)
        _secureStorage.write(
          StorageKeys.sessionExpiresAt,
          session.accessTokenExpiresAt!.toIso8601String(),
        ),
    ]);

    _sessionNotifier.update(session);
    _userNotifier.update(user);

    return (session, user);
  }
}

