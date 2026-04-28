import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_token_response_dto.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_user_info_dto.dart';

typedef Clock = DateTime Function();

abstract interface class ClaveAppAuthClient {
  Future<AuthorizationTokenResponse> authorizeAndExchangeCode(
    final AuthorizationTokenRequest request,
  );

  Future<TokenResponse> token(final TokenRequest request);

  Future<EndSessionResponse> endSession(final EndSessionRequest request);
}

final class FlutterClaveAppAuthClient implements ClaveAppAuthClient {
  const FlutterClaveAppAuthClient([this._appAuth = const FlutterAppAuth()]);

  final FlutterAppAuth _appAuth;

  @override
  Future<AuthorizationTokenResponse> authorizeAndExchangeCode(
    final AuthorizationTokenRequest request,
  ) {
    return _appAuth.authorizeAndExchangeCode(request);
  }

  @override
  Future<TokenResponse> token(final TokenRequest request) {
    return _appAuth.token(request);
  }

  @override
  Future<EndSessionResponse> endSession(final EndSessionRequest request) {
    return _appAuth.endSession(request);
  }
}

abstract interface class ClaveAuthRemoteDatasource {
  Future<ClaveTokenResponseDto> login({
    final List<String> scopes,
    final String? loginHint,
  });

  Future<ClaveTokenResponseDto> refreshToken({
    required final String refreshToken,
    final List<String> scopes,
  });

  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  });

  Future<ClaveUserInfoDto> fetchUserInfo({
    required final String accessToken,
  });
}

final class FlutterAppAuthClaveAuthRemoteDatasource
    implements ClaveAuthRemoteDatasource {
  FlutterAppAuthClaveAuthRemoteDatasource({
    required final AppConfig config,
    required final Dio dio,
    final ClaveAppAuthClient appAuthClient = const FlutterClaveAppAuthClient(),
    final Clock clock = DateTime.now,
  }) : _config = config,
       _dio = dio,
       _appAuthClient = appAuthClient,
       _clock = clock {
    _validateConfig();
  }

  final AppConfig _config;
  final Dio _dio;
  final ClaveAppAuthClient _appAuthClient;
  final Clock _clock;

  @override
  Future<ClaveTokenResponseDto> login({
    final List<String> scopes = const ['openid'],
    final String? loginHint,
  }) async {
    try {
      final response = await _appAuthClient.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _config.ssoClientId,
          _config.ssoRedirectUri,
          discoveryUrl: _discoveryUrl,
          loginHint: loginHint,
          scopes: scopes,
        ),
      );

      return ClaveTokenResponseDto.fromAppAuth(
        response,
        receivedAt: _clock(),
      );
    } on FlutterAppAuthUserCancelledException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.cancelled(cause: error),
        stackTrace,
      );
    } on FlutterAppAuthPlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.remoteFailure(
          message: _appAuthErrorMessage(error),
          cause: error,
        ),
        stackTrace,
      );
    } on AuthException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.unexpected(cause: error),
        stackTrace,
      );
    }
  }

  @override
  Future<ClaveTokenResponseDto> refreshToken({
    required final String refreshToken,
    final List<String> scopes = const ['openid'],
  }) async {
    _requireNotBlank(refreshToken, 'refreshToken');

    try {
      final response = await _appAuthClient.token(
        TokenRequest(
          _config.ssoClientId,
          _config.ssoRedirectUri,
          discoveryUrl: _discoveryUrl,
          refreshToken: refreshToken,
          scopes: scopes,
        ),
      );

      return ClaveTokenResponseDto.fromAppAuth(
        response,
        receivedAt: _clock(),
      );
    } on FlutterAppAuthPlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.remoteFailure(
          message: _appAuthErrorMessage(error),
          cause: error,
        ),
        stackTrace,
      );
    } on AuthException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.unexpected(cause: error),
        stackTrace,
      );
    }
  }

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {
    _requireNotBlank(idToken, 'idToken');

    try {
      await _appAuthClient.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl:
              postLogoutRedirectUri ?? _config.ssoRedirectUri,
          discoveryUrl: _discoveryUrl,
          additionalParameters: {
            'client_id': _config.ssoClientId,
          },
        ),
      );
    } on FlutterAppAuthUserCancelledException {
      return;
    } on FlutterAppAuthPlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.remoteFailure(
          message: _appAuthErrorMessage(error),
          cause: error,
        ),
        stackTrace,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.unexpected(cause: error),
        stackTrace,
      );
    }
  }

  @override
  Future<ClaveUserInfoDto> fetchUserInfo({
    required final String accessToken,
  }) async {
    _requireNotBlank(accessToken, 'accessToken');

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _userInfoUrl,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          },
        ),
      );

      final data = response.data;
      if (data == null) {
        throw const AuthException.invalidResponse(
          message: 'Cl@ve userinfo response was empty.',
        );
      }

      return ClaveUserInfoDto.fromJson(data);
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.remoteFailure(
          message: 'Unable to fetch Cl@ve user information.',
          cause: error,
        ),
        stackTrace,
      );
    } on AuthException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.unexpected(cause: error),
        stackTrace,
      );
    }
  }

  String get _discoveryUrl => _realmUri('.well-known/openid-configuration');

  String get _userInfoUrl => _realmUri('protocol/openid-connect/userinfo');

  String _realmUri(final String childPath) {
    final base = Uri.parse(_config.ssoBaseUrl);
    final pathSegments = <String>[
      ...base.pathSegments.where((final segment) => segment.isNotEmpty),
      'realms',
      _config.ssoRealm,
      ...childPath.split('/').where((final segment) => segment.isNotEmpty),
    ];

    return base.replace(pathSegments: pathSegments).toString();
  }

  void _validateConfig() {
    final missing = <String>[
      if (_config.ssoBaseUrl.trim().isEmpty) 'SSO_BASE_URL',
      if (_config.ssoRealm.trim().isEmpty) 'SSO_REALM',
      if (_config.ssoClientId.trim().isEmpty) 'SSO_CLIENT_ID',
      if (_config.ssoRedirectUri.trim().isEmpty) 'SSO_REDIRECT_URI',
    ];
    if (missing.isNotEmpty) {
      throw AuthException.configuration(
        message: 'Missing Cl@ve configuration: ${missing.join(', ')}.',
      );
    }

    final ssoBaseUri = Uri.tryParse(_config.ssoBaseUrl);
    if (ssoBaseUri == null ||
        !ssoBaseUri.hasScheme ||
        ssoBaseUri.host.isEmpty) {
      throw const AuthException.configuration(
        message: 'SSO_BASE_URL must be an absolute URL.',
      );
    }
    if (ssoBaseUri.scheme != 'https') {
      throw const AuthException.configuration(
        message: 'SSO_BASE_URL must use HTTPS.',
      );
    }

    final redirectUri = Uri.tryParse(_config.ssoRedirectUri);
    if (redirectUri == null || !redirectUri.hasScheme) {
      throw const AuthException.configuration(
        message: 'SSO_REDIRECT_URI must be an absolute URI.',
      );
    }
  }

  static void _requireNotBlank(
    final String value,
    final String parameterName,
  ) {
    if (value.trim().isEmpty) {
      throw AuthException.configuration(
        message: '$parameterName must not be empty.',
      );
    }
  }

  static String _appAuthErrorMessage(
    final FlutterAppAuthPlatformException error,
  ) {
    final details = error.platformErrorDetails;
    final description = details.errorDescription?.trim();
    if (description != null && description.isNotEmpty) {
      return 'Cl@ve authentication failed: $description';
    }

    final oauthError = details.error?.trim();
    if (oauthError != null && oauthError.isNotEmpty) {
      return 'Cl@ve authentication failed: $oauthError';
    }

    return 'Cl@ve authentication failed.';
  }
}
