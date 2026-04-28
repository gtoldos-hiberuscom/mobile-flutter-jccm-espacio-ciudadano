import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';

const List<String> claveDefaultScopes = ['openid'];
typedef Clock = DateTime Function();

abstract interface class ClaveAppAuthClient {
  Future<AuthorizationTokenResponse> authorizeAndExchangeCode(final AuthorizationTokenRequest request);

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
    final List<String> scopes = claveDefaultScopes,
    final String? loginHint,
  });

  Future<ClaveTokenResponseDto> refreshToken({
    required final String refreshToken,
    final List<String> scopes = claveDefaultScopes,
  });

  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  });

  Future<ClaveUserInfoDto> fetchUserInfo({
    required final String accessToken,
  });
}

final class FlutterAppAuthClaveAuthRemoteDatasource implements ClaveAuthRemoteDatasource {
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
    final List<String> scopes = claveDefaultScopes,
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
        ClaveAuthException.cancelled(cause: error),
        stackTrace,
      );
    } on FlutterAppAuthPlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClaveAuthException.remoteFailure(
          message: _appAuthErrorMessage(error),
          cause: error,
        ),
        stackTrace,
      );
    } on ClaveAuthException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClaveAuthException.unexpected(cause: error),
        stackTrace,
      );
    }
  }

  @override
  Future<ClaveTokenResponseDto> refreshToken({
    required final String refreshToken,
    final List<String> scopes = claveDefaultScopes,
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
        ClaveAuthException.remoteFailure(
          message: _appAuthErrorMessage(error),
          cause: error,
        ),
        stackTrace,
      );
    } on ClaveAuthException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClaveAuthException.unexpected(cause: error),
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
        ClaveAuthException.remoteFailure(
          message: _appAuthErrorMessage(error),
          cause: error,
        ),
        stackTrace,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClaveAuthException.unexpected(cause: error),
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
        throw const ClaveAuthException.invalidResponse(
          message: 'Cl@ve userinfo response was empty.',
        );
      }

      return ClaveUserInfoDto.fromJson(data);
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClaveAuthException.remoteFailure(
          message: 'Unable to fetch Cl@ve user information.',
          cause: error,
        ),
        stackTrace,
      );
    } on ClaveAuthException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClaveAuthException.unexpected(cause: error),
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
      throw ClaveAuthException.configuration(
        message: 'Missing Cl@ve configuration: ${missing.join(', ')}.',
      );
    }

    final ssoBaseUri = Uri.tryParse(_config.ssoBaseUrl);
    if (ssoBaseUri == null || !ssoBaseUri.hasScheme || ssoBaseUri.host.isEmpty) {
      throw const ClaveAuthException.configuration(
        message: 'SSO_BASE_URL must be an absolute URL.',
      );
    }
    if (ssoBaseUri.scheme != 'https') {
      throw const ClaveAuthException.configuration(
        message: 'SSO_BASE_URL must use HTTPS.',
      );
    }

    final redirectUri = Uri.tryParse(_config.ssoRedirectUri);
    if (redirectUri == null || !redirectUri.hasScheme) {
      throw const ClaveAuthException.configuration(
        message: 'SSO_REDIRECT_URI must be an absolute URI.',
      );
    }
  }

  static void _requireNotBlank(final String value, final String parameterName) {
    if (value.trim().isEmpty) {
      throw ClaveAuthException.configuration(
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

enum ClaveAuthFailureReason {
  cancelled,
  configuration,
  invalidResponse,
  remoteFailure,
  unexpected,
}

final class ClaveAuthException implements Exception {
  const ClaveAuthException._({
    required this.reason,
    required this.message,
    this.cause,
  });

  const factory ClaveAuthException.cancelled({
    final Object? cause,
  }) = _ClaveAuthCancelledException;

  const factory ClaveAuthException.configuration({
    required final String message,
    final Object? cause,
  }) = _ClaveAuthConfigurationException;

  const factory ClaveAuthException.invalidResponse({
    required final String message,
    final Object? cause,
  }) = _ClaveAuthInvalidResponseException;

  const factory ClaveAuthException.remoteFailure({
    required final String message,
    final Object? cause,
  }) = _ClaveAuthRemoteFailureException;

  const factory ClaveAuthException.unexpected({
    final Object? cause,
  }) = _ClaveAuthUnexpectedException;

  final ClaveAuthFailureReason reason;
  final String message;
  final Object? cause;

  @override
  String toString() => 'ClaveAuthException($reason): $message';
}

final class _ClaveAuthCancelledException extends ClaveAuthException {
  const _ClaveAuthCancelledException({super.cause})
    : super._(
        reason: ClaveAuthFailureReason.cancelled,
        message: 'Cl@ve authentication was cancelled.',
      );
}

final class _ClaveAuthConfigurationException extends ClaveAuthException {
  const _ClaveAuthConfigurationException({
    required super.message,
    super.cause,
  }) : super._(reason: ClaveAuthFailureReason.configuration);
}

final class _ClaveAuthInvalidResponseException extends ClaveAuthException {
  const _ClaveAuthInvalidResponseException({
    required super.message,
    super.cause,
  }) : super._(reason: ClaveAuthFailureReason.invalidResponse);
}

final class _ClaveAuthRemoteFailureException extends ClaveAuthException {
  const _ClaveAuthRemoteFailureException({
    required super.message,
    super.cause,
  }) : super._(reason: ClaveAuthFailureReason.remoteFailure);
}

final class _ClaveAuthUnexpectedException extends ClaveAuthException {
  const _ClaveAuthUnexpectedException({super.cause})
    : super._(
        reason: ClaveAuthFailureReason.unexpected,
        message: 'Unexpected Cl@ve authentication failure.',
      );
}

final class ClaveTokenResponseDto {
  const ClaveTokenResponseDto({
    required this.accessToken,
    required this.tokenType,
    required this.scopes,
    required this.additionalParameters,
    this.refreshToken,
    this.idToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
  });

  factory ClaveTokenResponseDto.fromAppAuth(
    final TokenResponse response, {
    required final DateTime receivedAt,
  }) {
    final accessToken = _notBlank(response.accessToken, 'access_token');
    final additionalParameters = Map<String, dynamic>.unmodifiable(response.tokenAdditionalParameters ?? const {});
    final expiresIn = _int(additionalParameters['expires_in']);
    final refreshExpiresIn = _int(additionalParameters['refresh_expires_in']);

    return ClaveTokenResponseDto(
      accessToken: accessToken,
      refreshToken: _blankToNull(response.refreshToken),
      idToken: _blankToNull(response.idToken),
      tokenType: _blankToNull(response.tokenType) ?? 'Bearer',
      scopes: List<String>.unmodifiable(response.scopes ?? const []),
      accessTokenExpiresAt: response.accessTokenExpirationDateTime ?? _expiresAt(receivedAt, expiresIn),
      refreshTokenExpiresAt: _expiresAt(receivedAt, refreshExpiresIn),
      additionalParameters: additionalParameters,
    );
  }

  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final String tokenType;
  final DateTime? accessTokenExpiresAt;
  final DateTime? refreshTokenExpiresAt;
  final List<String> scopes;
  final Map<String, dynamic> additionalParameters;

  bool get hasRefreshToken => refreshToken != null;

  bool get hasIdToken => idToken != null;

  bool isAccessTokenExpired({
    final DateTime? now,
    final Duration clockSkew = const Duration(seconds: 30),
  }) {
    final expiry = accessTokenExpiresAt;
    if (expiry == null) {
      return true;
    }

    final effectiveNow = now ?? DateTime.now();
    return !expiry.isAfter(effectiveNow.add(clockSkew));
  }

  @override
  String toString() {
    return 'ClaveTokenResponseDto('
        'tokenType: $tokenType, '
        'accessTokenExpiresAt: $accessTokenExpiresAt, '
        'refreshTokenExpiresAt: $refreshTokenExpiresAt, '
        'scopes: $scopes, '
        'hasRefreshToken: $hasRefreshToken, '
        'hasIdToken: $hasIdToken'
        ')';
  }

  static String _notBlank(final String? value, final String fieldName) {
    final normalized = _blankToNull(value);
    if (normalized == null) {
      throw ClaveAuthException.invalidResponse(
        message: 'Cl@ve token response did not include $fieldName.',
      );
    }
    return normalized;
  }

  static String? _blankToNull(final String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static int? _int(final Object? value) {
    return switch (value) {
      final int intValue => intValue,
      final double doubleValue => doubleValue.toInt(),
      final String stringValue => int.tryParse(stringValue),
      _ => null,
    };
  }

  static DateTime? _expiresAt(final DateTime receivedAt, final int? seconds) {
    if (seconds == null || seconds <= 0) {
      return null;
    }
    return receivedAt.add(Duration(seconds: seconds));
  }
}

final class ClaveUserInfoDto {
  const ClaveUserInfoDto({
    required this.sub,
    required this.claims,
    this.nif,
    this.givenName,
    this.familyName,
    this.email,
  });

  factory ClaveUserInfoDto.fromJson(final Map<String, dynamic> json) {
    return ClaveUserInfoDto(
      sub: _string(json['sub']) ?? '',
      nif: _string(json['nif']) ?? _string(json['idAgente']),
      givenName: _string(json['given_name']),
      familyName: _string(json['family_name']),
      email: _string(json['email']),
      claims: Map<String, dynamic>.unmodifiable(json),
    );
  }

  final String sub;
  final String? nif;
  final String? givenName;
  final String? familyName;
  final String? email;
  final Map<String, dynamic> claims;

  String get idAgente => nif ?? sub;

  String? get displayName {
    final names = [
      givenName?.trim(),
      familyName?.trim(),
    ].whereType<String>().where((final value) => value.isNotEmpty);

    final displayName = names.join(' ');
    if (displayName.isEmpty) {
      return null;
    }
    return displayName;
  }

  @override
  String toString() {
    return 'ClaveUserInfoDto('
        'hasSub: ${sub.isNotEmpty}, '
        'hasNif: ${nif != null}, '
        'hasDisplayName: ${displayName != null}, '
        'hasEmail: ${email != null}'
        ')';
  }

  static String? _string(final Object? value) {
    if (value is! String) {
      return null;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
