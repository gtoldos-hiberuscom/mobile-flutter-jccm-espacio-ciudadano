import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
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

    // El refresh token se deja fuera a propósito: está protegido con
    // biometría, así que leerlo aquí levantaría el prompt en cada arranque —
    // incluso teniendo un access token todavía válido, que es justo el caso
    // en que el ciudadano no debe tener que autenticarse. Se lee más tarde,
    // solo si hace falta refrescar (ver [_doRefresh]).
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

  /// Abre el almacén protegido y deja la credencial de larga vida en memoria.
  ///
  /// La lectura **es** la comprobación biométrica, así que llamar a esto es
  /// pedirle la huella al ciudadano. Se hace al arrancar, a propósito: con la
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
      // El almacén protegido ni se toca: en Android rozarlo lo inicializa, y
      // eso ya autentica.
      return false;
    }
    final String? refreshToken;
    try {
      refreshToken = await _storage.read(
        StorageKeys.refreshToken,
        protection: SecureStorageProtection.biometric,
        prompt: prompt ?? _ref.read(biometricPromptCopyProvider),
      );
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
    // Esta lectura ES la comprobación biométrica: el almacén guardó el token
    // exigiendo autenticación, así que la plataforma levanta aquí el prompt.
    // Solo ocurre cuando de verdad hace falta refrescar, nunca al arrancar.
    final String? refreshToken;
    try {
      final inMemory = _ref.read(tokenResponseProvider)?.refreshToken;
      if (inMemory != null && inMemory.isNotEmpty) {
        refreshToken = inMemory;
      } else if (!biometricQuickAccessEnabled) {
        // Sin acceso rápido no hay nada guardado, y el almacén protegido ni se
        // toca: en Android basta con rozarlo para inicializarlo, y eso
        // autentica. Intentar leer de un almacén vacío le sacaría un diálogo
        // de huella a quien precisamente dijo que no quería ninguno.
        await clear();
        return SessionRefreshStatus.definitivelyInvalid;
      } else {
        refreshToken = await _storage.read(
          StorageKeys.refreshToken,
          protection: SecureStorageProtection.biometric,
          // Sin copia explícita Android saca su texto genérico, y los dos
          // caminos que llegan aquí sin ella —el guard de rutas y el
          // interceptor— son los que pillan al ciudadano ya dentro de la app.
          prompt: prompt ?? _ref.read(biometricPromptCopyProvider),
        );
      }
    } on Object catch (error, stackTrace) {
      // La plataforma rechaza la lectura si el ciudadano cancela el prompt,
      // falla la biometría, o si el juego de huellas cambió e invalidó la
      // entrada. Ninguna de esas cosas dice que el token esté muerto, así que
      // no se destruye la sesión: se informa de que no se pudo abrir y quien
      // llama decide (reintentar el prompt u ofrecer Cl@ve).
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
  /// No toca el estado en memoria ni el almacén protegido: hace falta saber
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

  Future<void> _deleteRefreshToken() async {
    try {
      await _storage.clearBiometric();
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
      // «no activado» signifique de verdad «nada guardado». El almacén
      // protegido no se toca: en Android rozarlo lo inicializa y eso pide
      // huella; de esa entrada se ocupa quien revoca la preferencia.
      await Future.wait([
        _storage.delete(StorageKeys.accessToken),
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

  /// Guarda el token de larga vida exigiendo biometría, si el ciudadano ha
  /// activado el acceso rápido y el dispositivo puede ofrecerla.
  ///
  /// Es un opt-in explícito: sin él, este token mantendría la sesión abierta
  /// durante semanas detrás de una huella que nadie ha autorizado. Cuando está
  /// desactivado no se guarda nada, y la sesión deja de existir al cerrar la
  /// app — el comportamiento de siempre.
  ///
  /// El almacén va con `enforceBiometrics`, así que en un terminal sin
  /// biometría dada de alta la escritura falla en vez de degradar a una clave
  /// sin autenticación. Esa es la política correcta, pero no puede tumbar la
  /// navegación: se registra y se sigue.
  Future<bool> _persistRefreshToken(final String? refreshToken) async {
    if (refreshToken == null) {
      return false;
    }
    if (!biometricQuickAccessEnabled) {
      // Sin acceso rápido no hay nada que guardar, y tampoco se limpia aquí:
      // en Android tocar el almacén protegido lo crea, y crearlo arrastra un
      // diálogo de huella. Quien de verdad tiene algo que borrar es quien
      // desactiva la preferencia, y de eso se ocupa
      // [applyBiometricQuickAccessChange].
      return false;
    }
    try {
      // Se borra antes de escribir, y no es redundante: el Keychain no deja
      // cambiar el control de acceso con `SecItemUpdate`, y el plugin sólo
      // aplica el ACL en la rama `SecItemAdd`. Si la entrada ya existía —y
      // existe en cualquier instalación anterior a esto, creada sin
      // protección— una escritura normal se limitaría a sustituir el valor y
      // el token de larga vida se quedaría legible sin biometría, en silencio.
      // Borrar fuerza el alta, y con ella el ACL.
      await _storage.delete(
        StorageKeys.refreshToken,
        protection: SecureStorageProtection.biometric,
      );
      await _storage.write(
        StorageKeys.refreshToken,
        refreshToken,
        protection: SecureStorageProtection.biometric,
      );
      return true;
    } on Object catch (error, stackTrace) {
      logger.w('Offline token not persisted: this device cannot protect it with biometrics', error: error, stackTrace: stackTrace);
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
      // El almacén protegido NO se toca aquí, y no es un olvido. En Android
      // cualquier operación sobre él lo inicializa, y la inicialización
      // autentica: medido con `delete` y con `deleteAll`, y también con la
      // migración desactivada —entonces entra por `resetOnError` y acaba en
      // «Reinitializing... Biometric authentication succeeded»—. Cerrar sesión
      // pedía huella, incluso a quien nunca activó el acceso rápido.
      //
      // Dejar ahí el token no lo hace utilizable: se acaba de revocar en
      // Keycloak, el access token —que es lo que identifica la sesión guardada
      // y dispara la restauración— sí se borra justo debajo, y el siguiente
      // login lo sobrescribe. Quien revoca el acceso rápido a propósito sí lo
      // borra, desde [applyBiometricQuickAccessChange], y ahí la huella sí
      // tiene sentido.
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
