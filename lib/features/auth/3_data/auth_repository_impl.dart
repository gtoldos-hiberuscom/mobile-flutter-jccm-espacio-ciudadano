import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_auth_remote_datasource.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_token_response_dto.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_user_info_dto.dart';

/// Implements [AuthRepository] by delegating to [ClaveAuthRemoteDatasource]
/// and mapping Cl@ve-specific DTOs to clean domain entities.
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final ClaveAuthRemoteDatasource _datasource;

  @override
  Future<AuthSession> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  }) async {
    final dto = await _datasource.login(scopes: scopes, loginHint: loginHint);
    return _mapSession(dto);
  }

  @override
  Future<AuthSession> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) async {
    final dto = await _datasource.refreshToken(
      refreshToken: refreshToken,
      scopes: scopes,
    );
    return _mapSession(dto);
  }

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) {
    return _datasource.logout(
      idToken: idToken,
      postLogoutRedirectUri: postLogoutRedirectUri,
    );
  }

  @override
  Future<AuthUser> fetchUserInfo({required final String accessToken}) async {
    final dto = await _datasource.fetchUserInfo(accessToken: accessToken);
    return _mapUser(dto);
  }

  static AuthSession _mapSession(final ClaveTokenResponseDto dto) {
    return AuthSession(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      idToken: dto.idToken,
      tokenType: dto.tokenType,
      accessTokenExpiresAt: dto.accessTokenExpiresAt,
      refreshTokenExpiresAt: dto.refreshTokenExpiresAt,
      scopes: dto.scopes,
    );
  }

  static AuthUser _mapUser(final ClaveUserInfoDto dto) {
    return AuthUser(
      sub: dto.sub,
      nif: dto.nif,
      givenName: dto.givenName,
      familyName: dto.familyName,
      email: dto.email,
    );
  }
}
