import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required final AppConfig config,
    required final Dio dio,
  }) : _config = config,
       _dio = dio;

  final AppConfig _config;
  final Dio _dio;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  @override
  Future<AuthorizationTokenResponse> login({
    final List<String> scopes = const ['openid'],
    final String? loginHint,
  }) async {
    try {
      return await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _config.ssoClientId,
          _config.ssoRedirectUri,
          discoveryUrl: _discoveryUrl,
          loginHint: loginHint,
          scopes: scopes,
        ),
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
  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = const ['openid'],
  }) async {
    _requireNotBlank(refreshToken, 'refreshToken');

    try {
      return await _appAuth.token(
        TokenRequest(
          _config.ssoClientId,
          _config.ssoRedirectUri,
          discoveryUrl: _discoveryUrl,
          refreshToken: refreshToken,
          scopes: scopes,
        ),
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
      await _appAuth.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: postLogoutRedirectUri ?? _config.ssoRedirectUri,
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
  Future<JwtClaims> fetchUserInfo({
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

      return JwtClaims.fromMap(data);
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
