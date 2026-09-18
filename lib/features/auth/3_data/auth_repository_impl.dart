import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';
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
          scopes: _effectiveScopes(scopes),
          // SÓLO `login`. El estándar permite combinar valores separados por
          // espacio, pero la extensión de Cerbero compara el parámetro entero
          // contra "login", así que `prompt=login select_account` no le casa y
          // la AuthnRequest hacia Cl@ve sale con ForceAuthn="false".
          // Comprobado en PRE el 18/09/2026 leyendo la SAMLRequest (#282296):
          //   prompt=login                 → ForceAuthn="true"
          //   prompt=login select_account  → ForceAuthn="false"
          // `select_account` no aportaba nada: Cerbero no tiene cuentas
          // múltiples. Se puede volver a añadir cuando soporten la combinación.
          promptValues: const [Prompt.login],
          additionalParameters: const {'max_age': '0'},
          // En iOS, SFSafariViewController: almacén propio de la app, aislado
          // de Safari pero compartido con las pestañas que abre la propia app
          // (`LaunchMode.inAppBrowserView`). Es lo que permite que los portales
          // de JCCM abran ya identificados sin exponer la sesión a Safari.
          //
          // Implica que el estado de Cl@ve sobrevive entre logins dentro de ese
          // almacén: lo que garantiza la reautenticación es el `ForceAuthn` que
          // Cerbero propaga desde `prompt=login`, no el aislamiento.
          //
          // Android ignora este argumento; macOS se comporta como
          // asWebAuthenticationSession.
          externalUserAgent: ExternalUserAgent.sfSafariViewController,
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
          scopes: _effectiveScopes(scopes),
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
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    _requireNotBlank(refreshToken, 'refreshToken');

    try {
      // Dio propio, no el cliente de la app: sus interceptores reaccionarían
      // al 401 intentando refrescar la misma sesión que estamos revocando.
      //
      // Lleva el logger del proyecto —sin él, revocar y no hacer nada se veían
      // exactamente igual en la traza— pero **sin `verboseBodies`**: el cuerpo
      // de esta petición es el propio offline token, y en desarrollo la
      // redacción está desactivada. Así queda constancia de la llamada y de su
      // resultado sin que la credencial de larga vida llegue nunca a un log.
      final revocationClient = Dio()..interceptors.add(EmojiDioLogger());
      await revocationClient.post<void>(
        _realmUri('protocol/openid-connect/logout'),
        data: {
          'client_id': _config.ssoClientId,
          'refresh_token': refreshToken,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          // Un 400 aquí suele significar «ese token ya no vale», que es
          // justamente el estado que buscábamos: no es un error que reportar.
          validateStatus: (final status) => status != null && status < 500,
        ),
      );
    } on Object catch (error, stackTrace) {
      Error.throwWithStackTrace(AuthException.unexpected(cause: error), stackTrace);
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
          // Igual que el login. Además evita el diálogo del sistema que
          // ASWebAuthenticationSession muestra al cerrar sesión, que hablaba de
          // «iniciar sesión» justo cuando el ciudadano está saliendo.
          externalUserAgent: ExternalUserAgent.sfSafariViewController,
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

  /// The caller's scopes plus `offline_access` when this environment's client
  /// has it assigned. Kept here, at the single point that talks to AppAuth, so
  /// login and refresh can never disagree about the granted scope.
  List<String> _effectiveScopes(final List<String> scopes) {
    if (!_config.ssoOfflineAccess || scopes.contains(offlineAccessScope)) {
      return scopes;
    }
    return [...scopes, offlineAccessScope];
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
