import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required final AppConfig config,
  }) : _config = config;

  final AppConfig _config;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  @override
  Future<AuthorizationTokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  }) async {
    try {
      // `prompt=login` and `max_age=0` are sent on every attempt so the
      // Keycloak/Cl@ve broker always re-runs authentication and re-shows the
      // method selector, even when a browser cookie remembers a previous
      // (possibly failed) Cl@ve Permanente attempt. AppAuth generates a fresh
      // state, nonce and PKCE (S256) code_verifier per request.
      return await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _config.ssoClientId,
          _config.ssoRedirectUri,
          discoveryUrl: _discoveryUrl,
          loginHint: loginHint,
          scopes: scopes,
          promptValues: const [Prompt.login, Prompt.selectAccount],
          additionalParameters: const {'max_age': '0'},
          // iOS/macOS only: ephemeral ASWebAuthenticationSession so no SSO
          // cookies are shared with (or persisted between) login attempts.
          // Android (Custom Tabs) ignores this value.
          externalUserAgent: ExternalUserAgent.ephemeralAsWebAuthenticationSession,
        ),
      );
    } on FlutterAppAuthUserCancelledException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.cancelled(cause: error),
        stackTrace,
      );
    } on FlutterAppAuthPlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        _mapPlatformException(error),
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
    final List<String> scopes = authDefaultScopes,
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
        _mapPlatformException(error),
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
          // Match the login flow: ephemeral session on iOS/macOS.
          externalUserAgent: ExternalUserAgent.ephemeralAsWebAuthenticationSession,
        ),
      );
    } on FlutterAppAuthUserCancelledException {
      return;
    } on FlutterAppAuthPlatformException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        _mapPlatformException(error),
        stackTrace,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        AuthException.unexpected(cause: error),
        stackTrace,
      );
    }
  }

  String get _discoveryUrl => _realmUri('.well-known/openid-configuration');

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

  /// Maps a plugin platform exception to a domain [AuthException],
  /// distinguishing an OAuth error returned by the authorization server
  /// (`error`/`error_description` per RFC 6749) from a technical failure in
  /// the AppAuth SDK or the browser session.
  static AuthException _mapPlatformException(
    final FlutterAppAuthPlatformException error,
  ) {
    final details = error.platformErrorDetails;
    final oauthError = details.error?.trim();
    final description = details.errorDescription?.trim();

    if (oauthError != null && oauthError.isNotEmpty) {
      final suffix = (description != null && description.isNotEmpty) ? '$oauthError — $description' : oauthError;
      return AuthException.remoteFailure(
        message: 'Cl@ve authentication failed: $suffix',
        cause: error,
      );
    }

    return AuthException.unexpected(cause: error);
  }
}
