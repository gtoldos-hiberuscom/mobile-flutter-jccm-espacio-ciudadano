import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_auth_remote_datasource.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_token_response_dto.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_user_info_dto.dart';

void main() {
  late FakeClaveAuthRemoteDatasource datasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    datasource = FakeClaveAuthRemoteDatasource();
    repository = AuthRepositoryImpl(datasource);
  });

  group('AuthRepositoryImpl.login', () {
    test('maps ClaveTokenResponseDto to AuthSession', () async {
      final receivedAt = DateTime.utc(2026, 1, 1, 12);
      datasource.loginResult = ClaveTokenResponseDto(
        accessToken: 'access-token',
        tokenType: 'Bearer',
        scopes: const ['openid'],
        additionalParameters: const {},
        refreshToken: 'refresh-token',
        idToken: 'id-token',
        accessTokenExpiresAt: receivedAt.add(const Duration(minutes: 5)),
        refreshTokenExpiresAt: receivedAt.add(const Duration(hours: 1)),
      );

      final session = await repository.login();

      expect(session.accessToken, 'access-token');
      expect(session.refreshToken, 'refresh-token');
      expect(session.idToken, 'id-token');
      expect(session.tokenType, 'Bearer');
      expect(session.scopes, const ['openid']);
      expect(session.hasRefreshToken, isTrue);
      expect(session.hasIdToken, isTrue);
    });

    test('uses authDefaultScopes when no scopes are given', () async {
      datasource.loginResult = ClaveTokenResponseDto(
        accessToken: 'token',
        tokenType: 'Bearer',
        scopes: authDefaultScopes,
        additionalParameters: const {},
      );

      await repository.login();

      expect(datasource.lastLoginScopes, authDefaultScopes);
    });

    test('propagates AuthException from datasource', () {
      datasource.loginError = const AuthException.cancelled();

      expect(
        () => repository.login(),
        throwsA(isA<AuthException>().having(
          (final e) => e.reason,
          'reason',
          AuthFailureReason.cancelled,
        )),
      );
    });
  });

  group('AuthRepositoryImpl.logout', () {
    test('delegates to datasource with idToken', () async {
      await repository.logout(idToken: 'id-token');

      expect(datasource.lastLogoutIdToken, 'id-token');
    });

    test('passes through optional postLogoutRedirectUri', () async {
      await repository.logout(
        idToken: 'id-token',
        postLogoutRedirectUri: 'custom://redirect',
      );

      expect(datasource.lastLogoutRedirectUri, 'custom://redirect');
    });
  });

  group('AuthRepositoryImpl.fetchUserInfo', () {
    test('maps ClaveUserInfoDto to AuthUser', () async {
      datasource.userInfoResult = ClaveUserInfoDto.fromJson({
        'sub': 'abc123',
        'nif': '12345678Z',
        'given_name': 'Juan',
        'family_name': 'García',
        'email': 'juan@example.com',
      });

      final user = await repository.fetchUserInfo(accessToken: 'token');

      expect(user.sub, 'abc123');
      expect(user.nif, '12345678Z');
      expect(user.idAgente, '12345678Z');
      expect(user.givenName, 'Juan');
      expect(user.familyName, 'García');
      expect(user.email, 'juan@example.com');
      expect(user.displayName, 'Juan García');
    });

    test('idAgente falls back to sub when nif is absent', () async {
      datasource.userInfoResult = ClaveUserInfoDto.fromJson({'sub': 'sub-value'});

      final user = await repository.fetchUserInfo(accessToken: 'token');

      expect(user.idAgente, 'sub-value');
    });
  });
}

final class FakeClaveAuthRemoteDatasource implements ClaveAuthRemoteDatasource {
  ClaveTokenResponseDto? loginResult;
  Object? loginError;
  List<String>? lastLoginScopes;

  ClaveTokenResponseDto? refreshResult;

  String? lastLogoutIdToken;
  String? lastLogoutRedirectUri;

  ClaveUserInfoDto? userInfoResult;

  @override
  Future<ClaveTokenResponseDto> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  }) async {
    lastLoginScopes = scopes;
    if (loginError != null) throw loginError!;
    return loginResult ??
        ClaveTokenResponseDto(
          accessToken: 'default-token',
          tokenType: 'Bearer',
          scopes: scopes,
          additionalParameters: const {},
        );
  }

  @override
  Future<ClaveTokenResponseDto> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) async {
    return refreshResult ??
        ClaveTokenResponseDto(
          accessToken: 'refreshed-token',
          tokenType: 'Bearer',
          scopes: scopes,
          additionalParameters: const {},
        );
  }

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {
    lastLogoutIdToken = idToken;
    lastLogoutRedirectUri = postLogoutRedirectUri;
  }

  @override
  Future<ClaveUserInfoDto> fetchUserInfo({
    required final String accessToken,
  }) async {
    return userInfoResult ?? ClaveUserInfoDto.fromJson({'sub': 'fallback'});
  }
}
