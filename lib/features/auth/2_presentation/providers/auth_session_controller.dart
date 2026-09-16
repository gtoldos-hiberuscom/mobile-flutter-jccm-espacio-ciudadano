import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_refresh_status.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_token_diagnostics.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
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
      refreshToken =
          _ref.read(tokenResponseProvider)?.refreshToken ??
          await _storage.read(
            StorageKeys.refreshToken,
            protection: SecureStorageProtection.biometric,
            prompt: prompt,
          );
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

  Future<void> persist(
    final TokenResponse session, {
    final JwtClaims? claims,
  }) async {
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
    await _persistRefreshToken(session.refreshToken);
    _updateMemory(session, claims: claims);
  }

  /// Guarda el token de larga vida exigiendo biometría, y sigue adelante si el
  /// dispositivo no puede ofrecerla.
  ///
  /// El almacén está configurado con `enforceBiometrics`, así que en un
  /// terminal sin biometría dada de alta la escritura falla en vez de degradar
  /// a una clave sin autenticación. Esa es la política correcta —este token
  /// abre la sesión durante semanas y nunca debe quedar sin proteger—, pero no
  /// puede tumbar la navegación: sin él la sesión simplemente no sobrevive al
  /// cierre de la app, que es exactamente como se comportaba hasta ahora.
  Future<void> _persistRefreshToken(final String? refreshToken) async {
    if (refreshToken == null) {
      return;
    }
    try {
      await _storage.write(
        StorageKeys.refreshToken,
        refreshToken,
        protection: SecureStorageProtection.biometric,
      );
    } on Object catch (error, stackTrace) {
      logger.w('Offline token not persisted: this device cannot protect it with biometrics', error: error, stackTrace: stackTrace);
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
      _storage.delete(StorageKeys.refreshToken, protection: SecureStorageProtection.biometric),
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
