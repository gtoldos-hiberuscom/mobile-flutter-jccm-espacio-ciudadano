import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_refresh_status.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_token_diagnostics.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/biometric_prompt_copy_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

final authSessionControllerProvider = Provider<AuthSessionController>(
  (final ref) => AuthSessionController(
    ref: ref,
    repository: ref.watch(authRepositoryProvider),
    storage: ref.watch(secureStorageProvider),
  ),
);

final class AuthSessionController {
  AuthSessionController({
    required final Ref ref,
    required final AuthRepository repository,
    required final SecureStorage storage,
  }) : _ref = ref,
       _repository = repository,
       _storage = storage;

  final Ref _ref;
  final AuthRepository _repository;
  final SecureStorage _storage;

  /// Small skew applied to the synchronous validity short-circuit in [refresh]
  /// so a token on the edge of expiry is renewed rather than reused.
  /// Deliberately smaller than the 60s proactive threshold of
  /// [refreshIfNeeded]: the guard renews early on navigation, while this
  /// last-resort check only blocks reuse of a token about to expire mid-request.
  static const Duration _refreshSkew = Duration(seconds: 30);

  /// Techo para el cierre de la sesión de navegador previa a un login
  /// ([endStaleBrowserSession]). Va por delante del flujo de Cl@ve, así que un
  /// cierre que no resuelve retrasaría la pantalla de identificación sin que el
  /// ciudadano entienda por qué. Pasado este tiempo se sigue adelante: perder
  /// la limpieza es peor que perder el login.
  static const Duration _staleSessionCloseTimeout = Duration(seconds: 15);

  /// Monotonic session generation. Every [clear] (logout) bumps it; an in-flight
  /// [_doRefresh] captures it at start and discards its result if it changed —
  /// preventing a refresh that completes after logout from resurrecting tokens.
  int _sessionGeneration = 0;

  /// Single-flight guard: while a refresh is in progress, concurrent callers
  /// (the `SessionGuard` plus every 401 that hits `AuthRefreshInterceptor`)
  /// share this same [Future] instead of each firing an independent
  /// `token()` call. That prevents two requests from racing on the same
  /// refresh token — which, with Keycloak refresh-token rotation enabled,
  /// would make the loser fail with `invalid_grant` and wipe the session.
  Future<SessionRefreshStatus>? _inFlightRefresh;

  JwtClaims? get currentClaims => _ref.read(jwtClaimsProvider);

  Future<bool> hasPersistedSession() async {
    final accessToken = await _storage.read(StorageKeys.accessToken);
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<TokenResponse?> hydrateFromStorage() async {
    final accessToken = await _storage.read(StorageKeys.accessToken);
    if (accessToken == null || accessToken.isEmpty) {
      await clear();
      return null;
    }

    // El refresh token se deja fuera a propósito: sólo se carga después de
    // la huella (ver [unlockPersistedSession]).
    final idToken = await _storage.read(StorageKeys.idToken);
    final expiresAtValue = await _storage.read(StorageKeys.sessionExpiresAt);
    final expiresAt = expiresAtValue == null ? null : DateTime.tryParse(expiresAtValue);
    final session = TokenResponse(
      accessToken,
      null,
      expiresAt,
      idToken,
      null,
      null,
      null,
    );
    _updateMemory(session);
    return session;
  }

  /// Pide la huella y, si la supera, deja la credencial de larga vida en
  /// memoria.
  ///
  /// La huella es la puerta: el token se guarda en el almacén seguro normal
  /// —cifrado por el sistema, pero legible sin interacción— y la app sólo lo
  /// usa después de que el ciudadano se autentique. Se guardaba en el almacén
  /// biométrico de `flutter_secure_storage`, y en Android éste pide la huella
  /// en la primera operación de cada proceso, escritura incluida: tras cerrar
  /// sesión y matar la app, la pedía justo después de entrar con Cl@ve; y si
  /// se cancelaba, el plugin no respondía y la app se quedaba colgada.
  ///
  /// Se hace al arrancar, a propósito: con la
  /// credencial ya en memoria, ninguna renovación posterior necesita volver al
  /// almacén, y la sesión transcurre entera sin más diálogos.
  ///
  /// La alternativa —abrirlo sólo cuando hiciera falta renovar— dejaba entrar
  /// sin pedir nada y cobraba la huella cinco minutos después, en mitad de lo
  /// que el ciudadano estuviera haciendo. Misma huella, peor momento; y por el
  /// camino, quien cogiera el móvil desbloqueado entraba en la sesión ajena
  /// sin autenticarse.
  ///
  /// Devuelve `false` si no hay nada que abrir o si el ciudadano no supera el
  /// diálogo. Nunca destruye la sesión guardada: cancelar no dice que la
  /// credencial esté muerta.
  Future<bool> unlockPersistedSession({final BiometricPromptCopy? prompt}) async {
    if (!biometricQuickAccessEnabled) {
      // Sin acceso rápido no hay nada que abrir: ni se pide la huella.
      return false;
    }
    final BiometricPromptCopy copy = prompt ?? _ref.read(biometricPromptCopyProvider);
    final authenticated = await _ref
        .read(biometricAuthenticatorProvider)
        .authenticateForSessionUnlock(
          localizedReason: copy.subtitle,
          title: copy.title,
          cancelLabel: copy.cancelLabel,
        );
    if (!authenticated) {
      return false;
    }
    final String? refreshToken;
    try {
      refreshToken = await _storage.read(StorageKeys.refreshToken);
    } on Object catch (error, stackTrace) {
      logger.w('Persisted session not unlocked', error: error, stackTrace: stackTrace);
      return false;
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    _updateMemory(
      _mergeWithCurrentSession(
        TokenResponse(null, refreshToken, null, null, null, null, null),
      ),
    );
    return true;
  }

  /// [prompt] es la copia del diálogo biométrico de Android, que solo la capa
  /// de presentación puede traducir. Sin ella el sistema usa su texto propio.
  Future<SessionRefreshStatus> refreshIfNeeded({
    final Duration threshold = const Duration(seconds: 60),
    final BiometricPromptCopy? prompt,
  }) async {
    final session = _ref.read(tokenResponseProvider) ?? await hydrateFromStorage();
    final expiresAt = session?.accessTokenExpirationDateTime;
    if (session?.accessToken != null && expiresAt != null && expiresAt.isAfter(DateTime.now().add(threshold))) {
      return SessionRefreshStatus.valid;
    }
    return refreshStatus(force: true, prompt: prompt);
  }

  /// Compat bool para quien solo necesita "¿hay token utilizable?" (el
  /// `AuthRefreshInterceptor`): allí un transitorio y un rechazo definitivo
  /// terminan igual — sin token nuevo, el 401 original se propaga.
  Future<bool> refresh({final bool force = false}) async => await refreshStatus(force: force) == SessionRefreshStatus.valid;

  Future<SessionRefreshStatus> refreshStatus({
    final bool force = false,
    final BiometricPromptCopy? prompt,
  }) {
    // Validity short-circuit — synchronous, so it runs before we touch the
    // single-flight guard: a caller with a still-valid token never joins (or
    // starts) a refresh.
    final currentExpiry = _ref.read(tokenResponseProvider)?.accessTokenExpirationDateTime;
    if (!force && currentExpiry != null && currentExpiry.isAfter(DateTime.now().add(_refreshSkew))) {
      return Future<SessionRefreshStatus>.value(SessionRefreshStatus.valid);
    }

    final inFlight = _inFlightRefresh;
    if (inFlight != null) {
      return inFlight;
    }

    final future = _doRefresh(prompt);
    _inFlightRefresh = future;
    return future.whenComplete(() => _inFlightRefresh = null);
  }

  Future<SessionRefreshStatus> _doRefresh(final BiometricPromptCopy? prompt) async {
    final generation = _sessionGeneration;
    final persistedAccessToken = await _storage.read(StorageKeys.accessToken);
    final hasPersistedSession = persistedAccessToken != null && persistedAccessToken.isNotEmpty;
    final String? refreshToken;
    try {
      final inMemory = _ref.read(tokenResponseProvider)?.refreshToken;
      if (inMemory != null && inMemory.isNotEmpty) {
        refreshToken = inMemory;
      } else if (!biometricQuickAccessEnabled) {
        // Sin acceso rápido no hay nada guardado, y no se le pide huella a
        // quien precisamente dijo que no quería ninguna.
        await clear();
        return SessionRefreshStatus.definitivelyInvalid;
      } else if (await unlockPersistedSession(prompt: prompt)) {
        // El token guardado nunca se usa sin la huella. Sin copia explícita
        // se usa la de [biometricPromptCopyProvider]: los dos caminos que
        // llegan aquí sin ella —el guard de rutas y el interceptor— son los
        // que pillan al ciudadano ya dentro de la app.
        refreshToken = _ref.read(tokenResponseProvider)?.refreshToken;
      } else {
        // Cancelar o fallar la huella no dice que el token esté muerto, así
        // que no se destruye la sesión: se informa de que no se pudo abrir y
        // quien llama decide (reintentar u ofrecer Cl@ve).
        logger.w('Refresh token not unlocked: biometric check not passed');
        return SessionRefreshStatus.unknownTransient;
      }
    } on Object catch (error, stackTrace) {
      logger.w('Refresh token unavailable behind the biometric gate', error: error, stackTrace: stackTrace);
      return SessionRefreshStatus.unknownTransient;
    }
    if (refreshToken == null || refreshToken.isEmpty) {
      // No refresh token at all — nothing can renew this session.
      await clear();
      return SessionRefreshStatus.definitivelyInvalid;
    }

    try {
      final newSession = await _repository.refreshToken(refreshToken: refreshToken);
      if (generation != _sessionGeneration) {
        // A logout (clear()) landed while this refresh was in flight. Drop the
        // rotated tokens instead of re-persisting a session the user just ended.
        return SessionRefreshStatus.definitivelyInvalid;
      }
      final mergedSession = _mergeWithCurrentSession(newSession);
      if (hasPersistedSession) {
        await persist(mergedSession);
      } else {
        _updateMemory(mergedSession);
      }
      return SessionRefreshStatus.valid;
    } on AuthException catch (error, stackTrace) {
      // Only a definitive rejection from the authorization server
      // (`invalid_grant` and friends → `remoteFailure`) means the refresh
      // token is dead: clear so the user re-authenticates. A transient
      // failure (timeout/network → `unexpected`, or a misconfig →
      // `configuration`) keeps the session so a later attempt can renew.
      logger.e('Failed to refresh session', error: error, stackTrace: stackTrace);
      if (error.reason == AuthFailureReason.remoteFailure) {
        await clear();
        return SessionRefreshStatus.definitivelyInvalid;
      }
      return SessionRefreshStatus.unknownTransient;
    } on Object catch (error, stackTrace) {
      // Unexpected non-auth error — treat as transient, keep the session.
      logger.e('Failed to refresh session', error: error, stackTrace: stackTrace);
      return SessionRefreshStatus.unknownTransient;
    }
  }

  /// Si el ciudadano de la sesión en curso tiene activado el acceso rápido.
  ///
  /// Se lee en cada uso en vez de cachearse: el interruptor de Preferencias
  /// puede cambiarlo en cualquier momento y la sesión en curso debe respetarlo
  /// sin esperar a un reinicio.
  bool get biometricQuickAccessEnabled {
    final idAgente = _ref.read(citizenEndpointIdsProvider).idAgente;
    return idAgente != null && biometricQuickAccessEnabledFor(idAgente);
  }

  /// La misma preferencia para un ciudadano concreto, sin depender de que su
  /// sesión esté cargada en memoria. La usa la landing, que debe decidir si
  /// reanudar **antes** de hidratar nada.
  bool biometricQuickAccessEnabledFor(final String idAgente) =>
      _ref.read(appStorageProvider).read<bool>('${StorageKeys.biometricQuickAccessEnabledPrefix}$idAgente') ?? false;

  /// El `idAgente` de la sesión guardada, leído del access token del almacén.
  ///
  /// No toca el estado en memoria ni el token de larga vida: hace falta saber
  /// *de quién* es la sesión guardada para consultar su preferencia, y eso
  /// tiene que poder hacerse sin cargarla ni levantar el prompt biométrico.
  Future<String?> persistedIdAgente() async {
    final accessToken = await _storage.read(StorageKeys.accessToken);
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }
    final subAlt = JwtDecoder.decode(accessToken).subAlt?.trim();
    return (subAlt == null || subAlt.isEmpty) ? null : subAlt;
  }

  /// Aplica un cambio del interruptor de acceso rápido a la sesión en curso.
  ///
  /// Al activarlo se guarda el token que ya está en memoria —si no, el acceso
  /// rápido no funcionaría hasta el siguiente login— y al desactivarlo se
  /// borra del dispositivo inmediatamente.
  /// Devuelve `false` si el acceso rápido se pidió activar pero el token no
  /// llegó a guardarse —biometría cancelada, sin hardware, un fallo del
  /// almacén—. Quien llama debe entonces revertir la preferencia: dejarla en
  /// «activado» sin token detrás prometería algo que no se va a cumplir.
  Future<bool> applyBiometricQuickAccessChange() async {
    if (!biometricQuickAccessEnabled) {
      await _deleteRefreshToken();
      return true;
    }
    // Se guarda la sesión ENTERA, no sólo la credencial de larga vida. El
    // guard persiste antes de que el ciudadano conteste el diálogo, y en ese
    // momento la preferencia todavía está desactivada, así que no llegó a
    // escribir nada: guardar aquí sólo el token de larga vida dejaba la sesión
    // sin access token, y la reanudación —que empieza identificando al
    // ciudadano por él— no encontraba nada y mandaba a Cl@ve.
    final session = _ref.read(tokenResponseProvider);
    if (session == null) {
      return false;
    }
    return persist(session, claims: currentClaims);
  }

  /// Revoca en Keycloak la sesión offline de la sesión en curso.
  ///
  /// Usa **solo** el token que ya está en memoria: leerlo del almacén
  /// protegido levantaría el diálogo biométrico, y pedir la huella para cerrar
  /// sesión es justo lo que se quiso evitar. Eso deja fuera las sesiones
  /// restauradas que se cierran sin haber refrescado nunca — se registra para
  /// que quede constancia, y caducarán solas por el idle del realm.
  ///
  /// Nunca propaga: si la revocación falla, el cierre de sesión local debe
  /// completarse igual.
  Future<void> revokeCurrentOfflineSession() async {
    final refreshToken = _ref.read(tokenResponseProvider)?.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      logger.i('Offline session not revoked: no credential in memory to revoke with');
      return;
    }
    try {
      await _repository.revokeOfflineSession(refreshToken: refreshToken);
      // Se deja constancia del caso bueno a propósito: la llamada va por un
      // Dio desnudo, sin el interceptor de trazas, así que sin esto revocar
      // sería indistinguible de no hacer nada — y es justo lo que hay que
      // poder verificar contra las sesiones offline de Keycloak.
      logger.i('Offline session revoked in Keycloak');
    } on Object catch (error, stackTrace) {
      logger.w('Could not revoke the offline session in Keycloak', error: error, stackTrace: stackTrace);
    }
  }

  /// Recuerda qué sesión de navegador hay que cerrar después, guardando el
  /// `id_token` en cuanto el ciudadano se identifica.
  ///
  /// Se separa a propósito de [persist]: aquello persiste **la sesión del
  /// ciudadano** y por eso el `SessionGuard` lo condiciona a que el
  /// consentimiento conste (`session_guard.dart`, rama `ConsentNotRequired`).
  /// Esto es otra cosa — no guarda una credencial de acceso, guarda la pista
  /// para poder cerrar lo que la propia app acaba de abrir en el navegador — y
  /// atarla al gate de consentimiento la hacía depender de que un servicio
  /// remoto respondiera bien: si el gate falla y deja pasar, no quedaba pista, y
  /// el siguiente login se encontraba la sesión anterior viva.
  ///
  /// El `id_token` no autoriza nada contra el gateway y [clear] lo borra, así
  /// que quien sale no deja nada detrás.
  Future<void> rememberBrowserSession(final String? idToken) async {
    if (idToken == null || idToken.isEmpty) {
      return;
    }
    await _storage.write(StorageKeys.idToken, idToken);
  }

  /// Cierra en Cerbero la sesión de navegador que dejó abierta un login
  /// anterior, antes de arrancar uno nuevo.
  ///
  /// El caso que arregla (JCCMEC-224 / JCCMEC-228): la identificación no vive
  /// en la app, vive en el navegador —Custom Tab en Android, el almacén de
  /// `SFSafariViewController` en iOS—, y ahí sobrevive a que el ciudadano mate
  /// la app. Es justo lo que hace funcionar el SSO con Empleo y Educamos
  /// (`documentation/sso_portales_externos.md`), pero si quien entra después es
  /// **otro** ciudadano, Cerbero encuentra la identidad anterior en esa sesión
  /// y corta con `already authenticated as different user`. Reautenticar no
  /// basta: Cl@ve identifica bien al nuevo, y el corte llega al volver.
  ///
  /// Sólo hay algo que cerrar si el login anterior no terminó en un cierre de
  /// sesión en regla: [clear] borra el `id_token` (así que tras pulsar «Cerrar
  /// sesión» esto no hace nada, y no hay pestaña de más), y [persist] escribe
  /// el nuevo. De ahí que no se borre aquí: si el cierre falla, la pista debe
  /// seguir estando para el siguiente intento, y cerrar una sesión ya cerrada
  /// es inocuo.
  ///
  /// Nunca propaga ni bloquea: entrar con un posible corte de Cerbero por
  /// delante es mejor que no poder entrar por un fallo de red.
  Future<void> endStaleBrowserSession() async {
    final String? idToken = await _storage.read(StorageKeys.idToken);
    if (idToken == null || idToken.isEmpty) {
      return;
    }
    try {
      await _repository.logout(idToken: idToken).timeout(_staleSessionCloseTimeout);
      logger.i('Closed the browser session left open by a previous login');
    } on Object catch (error, stackTrace) {
      logger.w('Could not close the browser session left open by a previous login', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _deleteRefreshToken() async {
    try {
      await _storage.delete(StorageKeys.refreshToken);
    } on Object catch (error, stackTrace) {
      logger.w('Could not remove the stored offline token', error: error, stackTrace: stackTrace);
    }
  }

  /// Devuelve `true` si la credencial de larga vida quedó guardada, que es lo
  /// único que hace reanudable una sesión. Guardar sólo lo demás no sirve.
  Future<bool> persist(
    final TokenResponse session, {
    final JwtClaims? claims,
  }) async {
    // La memoria se actualiza ANTES de decidir nada, y el orden importa: la
    // preferencia de acceso rápido va por ciudadano y se resuelve con los
    // claims, así que hay que saber de quién es la sesión antes de saber si
    // debe guardarse.
    _updateMemory(session, claims: claims);

    if (!biometricQuickAccessEnabled) {
      // Sin acceso rápido la sesión no se reanuda al reabrir la app —no habría
      // con qué sostenerla más allá de los minutos del access token—, así que
      // guardarle credenciales no le sirve a nadie: sólo dejaría un access
      // token huérfano en el dispositivo. Su sesión vive en memoria mientras
      // la app esté abierta, que es exactamente lo que aceptó.
      //
      // Se limpia además lo que hubiera de una activación anterior, para que
      // «no activado» signifique de verdad «nada guardado».
      //
      // La excepción es el `id_token`, y no contradice lo anterior: **no es
      // una credencial de acceso**. No autoriza nada contra el gateway, sólo
      // acredita quién fue el titular, y es lo único con lo que se puede
      // cerrar después la sesión que este login deja abierta en el navegador
      // (JCCMEC-224 / JCCMEC-228, ver [endStaleBrowserSession]). Sin esto el
      // arreglo dejaría fuera justo a quien más lo necesita: el ciudadano de
      // un móvil compartido, que es el que no activa el acceso rápido.
      await Future.wait([
        _storage.delete(StorageKeys.accessToken),
        _storage.delete(StorageKeys.refreshToken),
        if (session.idToken != null)
          _storage.write(StorageKeys.idToken, session.idToken!)
        else
          _storage.delete(StorageKeys.idToken),
        _storage.delete(StorageKeys.sessionExpiresAt),
      ]);
      return false;
    }

    await Future.wait([
      if (session.accessToken != null) _storage.write(StorageKeys.accessToken, session.accessToken!),
      if (session.idToken != null) _storage.write(StorageKeys.idToken, session.idToken!),
      if (session.accessTokenExpirationDateTime != null)
        _storage.write(
          StorageKeys.sessionExpiresAt,
          session.accessTokenExpirationDateTime!.toIso8601String(),
        )
      else
        // A session without an expiry must not inherit the previous one from
        // storage: hydrateFromStorage would treat the stale instant as
        // authoritative after a restart.
        _storage.delete(StorageKeys.sessionExpiresAt),
    ]);
    return _persistRefreshToken(session.refreshToken);
  }

  /// Guarda el token de larga vida, si el ciudadano ha activado el acceso
  /// rápido. Guardar no pide huella: se pide al usarlo
  /// ([unlockPersistedSession]).
  ///
  /// Es un opt-in explícito: sin él, este token mantendría la sesión abierta
  /// durante semanas detrás de una huella que nadie ha autorizado. Cuando está
  /// desactivado no se guarda nada, y la sesión deja de existir al cerrar la
  /// app — el comportamiento de siempre.
  ///
  /// Si la escritura falla no puede tumbar la navegación: se registra y se
  /// sigue.
  Future<bool> _persistRefreshToken(final String? refreshToken) async {
    if (refreshToken == null) {
      return false;
    }
    if (!biometricQuickAccessEnabled) {
      // Sin acceso rápido no hay nada que guardar; de borrar lo que hubiera se
      // ocupa [persist] en esa misma rama.
      return false;
    }
    try {
      await _storage.write(StorageKeys.refreshToken, refreshToken);
      return true;
    } on Object catch (error, stackTrace) {
      logger.w('Offline token not persisted', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  void startInMemory(
    final TokenResponse session, {
    final JwtClaims? claims,
  }) => _updateMemory(session, claims: claims);

  Future<bool> persistCurrentSession() async {
    final session = _ref.read(tokenResponseProvider);
    if (session == null) {
      return false;
    }
    await persist(session, claims: _ref.read(jwtClaimsProvider));
    return true;
  }

  Future<void> clear() async {
    // Bump first, synchronously, so any refresh already awaiting the network
    // sees a changed generation and discards its result (see [_doRefresh]).
    _sessionGeneration++;
    await Future.wait([
      _storage.delete(StorageKeys.accessToken),
      // También el token de larga vida: borrar no pide huella, y dejarlo
      // —aunque esté revocado— sería guardar una credencial que ya no sirve.
      _storage.delete(StorageKeys.refreshToken),
      _storage.delete(StorageKeys.idToken),
      _storage.delete(StorageKeys.sessionExpiresAt),
    ]);
    _ref.read(tokenResponseProvider.notifier).update(null);
    _ref.read(jwtClaimsProvider.notifier).update(null);
  }

  void _updateMemory(
    final TokenResponse session, {
    final JwtClaims? claims,
  }) {
    _logSessionLifetimes(session);
    _ref.read(tokenResponseProvider.notifier).update(session);
    if (claims != null) {
      _ref.read(jwtClaimsProvider.notifier).update(claims.sub.isNotEmpty ? claims : null);
      return;
    }
    final accessToken = session.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      _ref.read(jwtClaimsProvider.notifier).update(null);
      return;
    }
    final decodedClaims = JwtDecoder.decode(accessToken);
    _ref.read(jwtClaimsProvider.notifier).update(decodedClaims.sub.isNotEmpty ? decodedClaims : null);
  }

  /// Traza los lifetimes que Keycloak concedió a esta sesión.
  ///
  /// Es el único sitio por el que pasan las tres entradas de sesión —login
  /// (`startInMemory`), refresco (`persist`) y arranque (`hydrateFromStorage`)—
  /// así que basta una llamada para verlas todas. Solo imprime metadatos
  /// derivados (instantes, duraciones, `typ` y scope): nunca material de
  /// token, de ahí que no dependa de la redacción.
  void _logSessionLifetimes(final TokenResponse session) => logger.i({
    'session-lifetimes': SessionTokenDiagnostics.describe(
      now: DateTime.now(),
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      tokenAdditionalParameters: session.tokenAdditionalParameters,
    ),
  });

  TokenResponse _mergeWithCurrentSession(final TokenResponse newSession) {
    final current = _ref.read(tokenResponseProvider);
    return TokenResponse(
      newSession.accessToken ?? current?.accessToken,
      newSession.refreshToken ?? current?.refreshToken,
      newSession.accessTokenExpirationDateTime ?? current?.accessTokenExpirationDateTime,
      newSession.idToken ?? current?.idToken,
      newSession.tokenType ?? current?.tokenType,
      newSession.scopes ?? current?.scopes,
      newSession.tokenAdditionalParameters ?? current?.tokenAdditionalParameters,
    );
  }
}
