import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  /// [isolateBrowserSession] existe para los tests, que corren en el host.
  AuthRepositoryImpl({
    required final AppConfig config,
    final bool? isolateBrowserSession,
  }) : _config = config,
       _isolateBrowserSession = isolateBrowserSession ?? Platform.isAndroid;

  final AppConfig _config;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  /// Si el `/authorize` se abre en un contenedor **aislado**, que se destruye al
  /// terminar. Sólo Android.
  ///
  /// **Por qué.** Allí el canal TLS con el IdP de certificado vive en el perfil
  /// de Chrome, una capa por debajo de cookies y tokens, y no lo suelta nada de
  /// lo que la app puede hacer: medido el 29/09, cuatro ciclos
  /// `logout 204 → login` con `auth_time` nuevo cada vez —o sea, Cerbero cierra
  /// y Cl@ve reautentica de verdad— y el certificado **no se volvió a pedir en
  /// ninguno**, tampoco pasada la ventana de 60 minutos de Cl@ve. Lo único que
  /// lo libera es borrar los datos de Chrome, que no se le puede pedir a un
  /// ciudadano. Aislar el contenedor es la única palanca que llega ahí.
  ///
  /// **El precio, asumido:** en Android se pierde el SSO con Empleo y Educamos,
  /// que se sostenía justo sobre ese contenedor compartido. Escalado a JCCM; la
  /// salida de fondo es el puente SSO en Cerbero
  /// (`documentation/sso_portales_externos.md` §6, Opción 1).
  ///
  /// **iOS no**: allí el SSO funciona y el estado se suelta solo en ~30 s, así
  /// que el cambio costaría más de lo que arregla.
  final bool _isolateBrowserSession;

  /// El agente del **login**. Ver [_isolateBrowserSession].
  ///
  /// En Android, `ephemeralAsWebAuthenticationSession` es lo que el fork
  /// vendorizado traduce a una Custom Tab efímera; el plugin de serie lo ignora
  /// (el enum es «iOS y macOS»). De ahí que el fork esté pineado al índice de
  /// ese valor — lo guarda `external_user_agent_contract_test.dart`.
  ExternalUserAgent _authorizeAgent({required final bool isolateSession}) =>
      isolateSession && _isolateBrowserSession
      ? ExternalUserAgent.ephemeralAsWebAuthenticationSession
      : ExternalUserAgent.sfSafariViewController;

  @override
  Future<AuthorizationTokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool isolateSession = true,
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
          // Depende de la plataforma, y la diferencia importa: ver
          // [_isolateBrowserSession].
          //
          // En iOS es `SFSafariViewController`, almacén propio de la app,
          // aislado de Safari pero compartido con las pestañas que abre la
          // propia app (`LaunchMode.inAppBrowserView`). Es lo que permite que
          // los portales de JCCM abran ya identificados sin exponer la sesión a
          // Safari, y por eso allí NO se aísla: el estado de Cl@ve sobrevive
          // entre logins, pero la reautenticación la garantiza el `ForceAuthn`
          // que Cerbero propaga desde `prompt=login`.
          //
          // En Android es una Custom Tab **efímera**, que se destruye al
          // terminar. Es lo que devuelve la reelección de certificado, y cuesta
          // el SSO con los portales.
          externalUserAgent: _authorizeAgent(isolateSession: isolateSession),
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
          // **NO efímero, y en Android tampoco. No es un descuido.**
          //
          // El cierre tiene que correr por el contenedor COMPARTIDO, que es
          // donde vive la sesión que hay que invalidar. Si se aislara también,
          // se ejecutaría contra un contenedor recién creado y vacío —un no-op—
          // y la sesión anterior quedaría **viva e inalcanzable para la app**:
          // peor que no cerrar, porque nadie volvería a poder cerrarla. Importa
          // sobre todo a quien actualice desde una versión sin aislamiento
          // (`0.1.6+8`, `0.1.7+9`), que ya arrastra sesión en el perfil de
          // Chrome.
          //
          // El fork sólo reacciona a `ephemeralAsWebAuthenticationSession`, así
          // que dejar este valor basta para que el logout siga yendo por una
          // Custom Tab normal.
          //
          // En iOS, además, evita el diálogo del sistema que
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
  /// El código que emite el fork vendorizado
  /// (`FlutterAppauthPlugin.EPHEMERAL_BROWSING_UNAVAILABLE_ERROR_CODE`).
  static const String _ephemeralUnavailableCode = 'ephemeral_browsing_unavailable';

  static AuthException _mapPlatformException(
    final FlutterAppAuthPlatformException error,
  ) {
    // Lo lanza el fork de Android **antes de abrir ningún navegador** cuando se
    // pidió sesión aislada y el navegador del dispositivo no puede darla.
    // Tipado aparte para que el caso de uso pueda reintentar sin aislamiento y
    // avisar, en vez de tragárselo como un fallo genérico.
    if (error.code == _ephemeralUnavailableCode) {
      return AuthException.ephemeralUnavailable(cause: error);
    }

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
