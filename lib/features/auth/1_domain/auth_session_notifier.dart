import 'package:jccm_espacio_ciudadano/core/logging/logger_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session_state.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_notifier.g.dart';

/// Owns the user's authentication session in memory and synchronises it with
/// `SecureStorage` (encrypted at rest).
///
/// - `build()` rehydrates the session from `SecureStorage` on cold start.
/// - [signIn] runs the Cl@ve login flow, derives the [AuthUser] from the
///   `id_token`, persists tokens, and emits `AuthenticatedSession`.
/// - [signOut] revokes at the OIDC end-session endpoint, wipes
///   `SecureStorage`, and emits `UnauthenticatedSession`.
///
/// Feature code that needs the citizen document (DNI / NIE) reads
/// `currentIdAgenteProvider`; transversal flows that need the access token
/// (e.g. Dio auth interceptor) can watch `currentAuthSessionProvider`.
@Riverpod(keepAlive: true)
class AuthSessionNotifier extends _$AuthSessionNotifier {
  static const String _logTag = 'AuthSessionNotifier';

  @override
  Future<AuthSessionState> build() async {
    return _rehydrate();
  }

  /// Authenticates the user via Cl@ve, persists the resulting session and
  /// derives [AuthUser] from the `id_token` claims. Returns the new session
  /// state, throwing the original `AuthException` on failure (the notifier
  /// state stays `UnauthenticatedSession` in that case).
  Future<AuthenticatedSession> signIn({
    final String? loginHint,
    final List<String> scopes = authDefaultScopes,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    final logger = ref.read(appLoggerProvider);

    state = const AsyncValue<AuthSessionState>.loading();
    try {
      final session = await repository.login(loginHint: loginHint, scopes: scopes);
      final idToken = session.idToken;
      if (idToken == null) {
        throw const _SessionAssemblyException(
          'Cl@ve session did not include an id_token.',
        );
      }
      final user = repository.decodeIdTokenUser(idToken);
      if (user == null) {
        throw const _SessionAssemblyException(
          'Could not derive AuthUser from the Cl@ve id_token.',
        );
      }

      await _persist(session: session);

      final authenticated = AuthenticatedSession(session: session, user: user);
      state = AsyncValue<AuthSessionState>.data(authenticated);
      logger.info(
        '$_logTag: sign-in succeeded',
        context: <String, Object?>{
          'hasRefreshToken': session.hasRefreshToken,
          'expiresAt': session.accessTokenExpiresAt?.toIso8601String(),
        },
      );
      return authenticated;
    } catch (error, stackTrace) {
      state = const AsyncValue<AuthSessionState>.data(UnauthenticatedSession());
      logger.error(
        '$_logTag: sign-in failed',
        exception: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Terminates the session: best-effort end-session call to the OIDC
  /// provider, then unconditional wipe of `SecureStorage` and transition to
  /// [UnauthenticatedSession]. Errors from the remote call are logged and
  /// swallowed — local state is the source of truth for "logged out".
  Future<void> signOut({final String? postLogoutRedirectUri}) async {
    final repository = ref.read(authRepositoryProvider);
    final logger = ref.read(appLoggerProvider);
    final currentIdToken = state.value?.sessionOrNull?.idToken;

    if (currentIdToken != null) {
      try {
        await repository.logout(
          idToken: currentIdToken,
          postLogoutRedirectUri: postLogoutRedirectUri,
        );
      } catch (error, stackTrace) {
        logger.warning(
          '$_logTag: end-session call failed; clearing local session anyway',
          context: <String, Object?>{
            'error': error.toString(),
            'stackTrace': stackTrace.toString(),
          },
        );
      }
    }

    await _clearStorage();
    state = const AsyncValue<AuthSessionState>.data(UnauthenticatedSession());
  }

  /// Forces an immediate rehydration from `SecureStorage`. Useful after
  /// out-of-band token refresh paths.
  Future<void> reload() async {
    state = const AsyncValue<AuthSessionState>.loading();
    state = AsyncValue<AuthSessionState>.data(await _rehydrate());
  }

  // ── internal ──────────────────────────────────────────────────────────────

  Future<AuthSessionState> _rehydrate() async {
    final secure = ref.read(secureStorageProvider);
    final logger = ref.read(appLoggerProvider);

    try {
      final accessToken = await secure.read(StorageKeys.accessToken);
      final idToken = await secure.read(StorageKeys.idToken);
      if (accessToken == null || accessToken.isEmpty || idToken == null || idToken.isEmpty) {
        return const UnauthenticatedSession();
      }

      final refreshToken = await secure.read(StorageKeys.refreshToken);
      final expiresAtRaw = await secure.read(StorageKeys.sessionExpiresAt);
      final expiresAt = expiresAtRaw == null ? null : DateTime.tryParse(expiresAtRaw);

      final session = AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        idToken: idToken,
        tokenType: 'Bearer',
        scopes: authDefaultScopes,
        accessTokenExpiresAt: expiresAt,
      );

      // Cold-start access-token expiry: leave to the auth interceptor /
      // refresh flow; we still surface the session so the UI shell can
      // attempt a silent refresh instead of forcing landing.
      final repository = ref.read(authRepositoryProvider);
      final user = repository.decodeIdTokenUser(idToken);
      if (user == null) {
        await _clearStorage();
        return const UnauthenticatedSession();
      }

      return AuthenticatedSession(session: session, user: user);
    } catch (error, stackTrace) {
      logger.warning(
        '$_logTag: rehydrate failed; defaulting to UnauthenticatedSession',
        context: <String, Object?>{
          'error': error.toString(),
          'stackTrace': stackTrace.toString(),
        },
      );
      return const UnauthenticatedSession();
    }
  }

  Future<void> _persist({required final AuthSession session}) async {
    final secure = ref.read(secureStorageProvider);
    final user = ref.read(authRepositoryProvider).decodeIdTokenUser(session.idToken ?? '');

    await Future.wait<void>(<Future<void>>[
      secure.write(StorageKeys.accessToken, session.accessToken),
      if (session.refreshToken != null)
        secure.write(StorageKeys.refreshToken, session.refreshToken!)
      else
        secure.delete(StorageKeys.refreshToken),
      if (session.idToken != null) secure.write(StorageKeys.idToken, session.idToken!),
      if (user != null) secure.write(StorageKeys.idAgente, user.idAgente),
      if (session.accessTokenExpiresAt != null)
        secure.write(
          StorageKeys.sessionExpiresAt,
          session.accessTokenExpiresAt!.toIso8601String(),
        )
      else
        secure.delete(StorageKeys.sessionExpiresAt),
    ]);
  }

  Future<void> _clearStorage() async {
    final secure = ref.read(secureStorageProvider);
    await Future.wait<void>(<Future<void>>[
      secure.delete(StorageKeys.accessToken),
      secure.delete(StorageKeys.refreshToken),
      secure.delete(StorageKeys.idToken),
      secure.delete(StorageKeys.idAgente),
      secure.delete(StorageKeys.sessionExpiresAt),
    ]);
  }
}

/// Convenience: returns the active [AuthSession] or `null`.
@Riverpod(keepAlive: true)
AuthSession? currentAuthSession(final Ref ref) {
  return ref.watch(authSessionProvider).value?.sessionOrNull;
}

/// Convenience: returns the active [AuthUser] or `null`.
@Riverpod(keepAlive: true)
AuthUser? currentAuthUser(final Ref ref) {
  return ref.watch(authSessionProvider).value?.userOrNull;
}

/// Convenience: returns the citizen's `idAgente` (NIF / sub) or `null`.
///
/// This is the canonical entry point for feature code that needs the
/// document identifier — recommendations, hechos vitales, firma, etc.
@Riverpod(keepAlive: true)
String? currentIdAgente(final Ref ref) {
  return ref.watch(authSessionProvider).value?.idAgente;
}

class _SessionAssemblyException implements Exception {
  const _SessionAssemblyException(this.message);

  final String message;

  @override
  String toString() => 'SessionAssemblyException($message)';
}
