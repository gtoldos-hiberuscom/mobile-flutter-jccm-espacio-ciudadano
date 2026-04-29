import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/app/config/build_environment.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_auth_remote_datasource.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_token_response_dto.dart';

void main() {
  group('FlutterAppAuthClaveAuthRemoteDatasource', () {
    test('login uses AppAuth authorization-code exchange with Cl@ve discovery', () async {
      final receivedAt = DateTime.utc(2026, 1, 1, 12);
      final appAuthClient = FakeClaveAppAuthClient(
        authorizationResponse: AuthorizationTokenResponse(
          'access-token',
          'refresh-token',
          receivedAt.add(const Duration(minutes: 5)),
          'id-token',
          'Bearer',
          const ['openid'],
          const {'auth_param': 'value'},
          const {'refresh_expires_in': 3600},
        ),
      );
      final datasource = FlutterAppAuthClaveAuthRemoteDatasource(
        config: _config,
        dio: Dio(),
        appAuthClient: appAuthClient,
        clock: () => receivedAt,
      );

      final result = await datasource.login(loginHint: '12345678Z');

      expect(result.accessToken, 'access-token');
      expect(result.refreshToken, 'refresh-token');
      expect(result.idToken, 'id-token');
      expect(
        result.accessTokenExpiresAt,
        receivedAt.add(const Duration(minutes: 5)),
      );
      expect(
        result.refreshTokenExpiresAt,
        receivedAt.add(const Duration(hours: 1)),
      );

      final request = appAuthClient.authorizationTokenRequest;
      expect(request, isNotNull);
      expect(request!.clientId, _config.ssoClientId);
      expect(request.redirectUrl, _config.ssoRedirectUri);
      expect(
        request.discoveryUrl,
        'https://sso.example.test/auth/realms/usuarios/.well-known/openid-configuration',
      );
      expect(request.loginHint, '12345678Z');
      expect(request.scopes, authDefaultScopes);
    });

    test('refreshToken uses AppAuth token endpoint with the refresh grant', () async {
      final receivedAt = DateTime.utc(2026, 1, 1, 12);
      final appAuthClient = FakeClaveAppAuthClient(
        tokenResponse: TokenResponse(
          'new-access-token',
          'new-refresh-token',
          receivedAt.add(const Duration(minutes: 10)),
          'new-id-token',
          'Bearer',
          const ['openid'],
          const {},
        ),
      );
      final datasource = FlutterAppAuthClaveAuthRemoteDatasource(
        config: _config,
        dio: Dio(),
        appAuthClient: appAuthClient,
        clock: () => receivedAt,
      );

      final result = await datasource.refreshToken(refreshToken: 'old-refresh-token');

      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');

      final request = appAuthClient.tokenRequest;
      expect(request, isNotNull);
      expect(request!.clientId, _config.ssoClientId);
      expect(request.redirectUrl, _config.ssoRedirectUri);
      expect(
        request.discoveryUrl,
        'https://sso.example.test/auth/realms/usuarios/.well-known/openid-configuration',
      );
      expect(request.refreshToken, 'old-refresh-token');
      expect(request.scopes, authDefaultScopes);
    });

    test('logout uses AppAuth end-session with the configured redirect URI', () async {
      final appAuthClient = FakeClaveAppAuthClient();
      final datasource = FlutterAppAuthClaveAuthRemoteDatasource(
        config: _config,
        dio: Dio(),
        appAuthClient: appAuthClient,
      );

      await datasource.logout(idToken: 'id-token');

      final request = appAuthClient.endSessionRequest;
      expect(request, isNotNull);
      expect(request!.idTokenHint, 'id-token');
      expect(request.postLogoutRedirectUrl, _config.ssoRedirectUri);
      expect(
        request.discoveryUrl,
        'https://sso.example.test/auth/realms/usuarios/.well-known/openid-configuration',
      );
      expect(
        request.additionalParameters,
        const {'client_id': 'mobile-client'},
      );
    });
  });

  group('ClaveTokenResponseDto', () {
    test('rejects token responses without an access token', () {
      expect(
        () => ClaveTokenResponseDto.fromAppAuth(
          TokenResponse(null, null, null, null, null, null, null),
          receivedAt: DateTime.utc(2026),
        ),
        throwsA(
          isA<AuthException>().having(
            (final error) => error.reason,
            'reason',
            AuthFailureReason.invalidResponse,
          ),
        ),
      );
    });
  });
}

const _config = AppConfig(
  environment: BuildEnvironment.development,
  baseUrl: 'https://api.example.test',
  appName: 'Test',
  ssoClientId: 'mobile-client',
  ssoRedirectUri: 'es.jccm.espaciociudadano://auth/callback',
  ssoRealm: 'usuarios',
  ssoBaseUrl: 'https://sso.example.test/auth',
);

final class FakeClaveAppAuthClient implements ClaveAppAuthClient {
  FakeClaveAppAuthClient({
    final AuthorizationTokenResponse? authorizationResponse,
    final TokenResponse? tokenResponse,
  }) : _authorizationResponse = authorizationResponse,
       _tokenResponse = tokenResponse;

  final AuthorizationTokenResponse? _authorizationResponse;
  final TokenResponse? _tokenResponse;

  AuthorizationTokenRequest? authorizationTokenRequest;
  TokenRequest? tokenRequest;
  EndSessionRequest? endSessionRequest;

  @override
  Future<AuthorizationTokenResponse> authorizeAndExchangeCode(
    final AuthorizationTokenRequest request,
  ) async {
    authorizationTokenRequest = request;
    return _authorizationResponse ??
        AuthorizationTokenResponse(
          'access-token',
          'refresh-token',
          DateTime.utc(2026, 1, 1, 12, 5),
          'id-token',
          'Bearer',
          const ['openid'],
          const {},
          const {},
        );
  }

  @override
  Future<TokenResponse> token(final TokenRequest request) async {
    tokenRequest = request;
    return _tokenResponse ??
        TokenResponse(
          'access-token',
          null,
          null,
          null,
          'Bearer',
          const ['openid'],
          const {},
        );
  }

  @override
  Future<EndSessionResponse> endSession(final EndSessionRequest request) async {
    endSessionRequest = request;
    return EndSessionResponse(null);
  }
}
