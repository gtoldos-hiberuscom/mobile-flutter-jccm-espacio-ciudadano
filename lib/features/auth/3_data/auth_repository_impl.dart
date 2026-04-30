import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_auth_remote_datasource.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_token_response_dto.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_user_info_dto.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/id_token_decoder.dart';

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

  @override
  AuthUser? decodeIdTokenUser(final String idToken) {
    final claims = decodeIdTokenPayload(idToken);
    if (claims == null) {
      return null;
    }
    final sub = _string(claims['sub']);
    if (sub == null) {
      return null;
    }
    return AuthUser(
      sub: sub,
      nif: _string(claims['nif']) ?? _string(claims['idAgente']) ?? _string(claims['document_number']),
      givenName: _string(claims['given_name']) ?? _string(claims['name']),
      familyName: _string(claims['family_name']),
      email: _string(claims['email']),
    );
  }

  static String? _string(final Object? value) {
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
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
