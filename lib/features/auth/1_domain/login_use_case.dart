import 'package:flutter_appauth_platform_interface/src/token_response.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/token_response_notifier.dart';

final class LoginUseCase {
  const LoginUseCase(
    this._repository,
    this._sessionNotifier,
    this._userNotifier,
    this._secureStorage,
  );

  final AuthRepository _repository;
  final TokenResponseNotifier _sessionNotifier;
  final JwtClaimsNotifier _userNotifier;
  final SecureStorage _secureStorage;

  Future<bool> call({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) async {
    final TokenResponse session = await _repository.login(loginHint: loginHint, scopes: scopes);
    final JwtClaims user = await _repository.fetchUserInfo(accessToken: session.accessToken!);

    await Future.wait([
      _secureStorage.write(StorageKeys.accessToken, session.accessToken!),
      if (session.refreshToken != null) _secureStorage.write(StorageKeys.refreshToken, session.refreshToken!),
      if (session.accessTokenExpirationDateTime != null) _secureStorage.write(StorageKeys.sessionExpiresAt, session.accessTokenExpirationDateTime!.toIso8601String()),
    ]);

    _sessionNotifier.update(session);
    _userNotifier.update(user);

    return true;
  }
}
