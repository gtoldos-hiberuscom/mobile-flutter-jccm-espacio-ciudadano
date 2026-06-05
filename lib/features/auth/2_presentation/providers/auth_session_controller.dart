import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
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
  const AuthSessionController({
    required final Ref ref,
    required final AuthRepository repository,
    required final SecureStorage storage,
  }) : _ref = ref,
       _repository = repository,
       _storage = storage;

  final Ref _ref;
  final AuthRepository _repository;
  final SecureStorage _storage;

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

    final refreshToken = await _storage.read(StorageKeys.refreshToken);
    final expiresAtValue = await _storage.read(StorageKeys.sessionExpiresAt);
    final expiresAt = expiresAtValue == null ? null : DateTime.tryParse(expiresAtValue);
    final session = TokenResponse(
      accessToken,
      refreshToken,
      expiresAt,
      null,
      null,
      null,
      null,
    );
    _updateMemory(session);
    return session;
  }

  Future<bool> refreshIfNeeded({
    final Duration threshold = Duration.zero,
  }) async {
    final session = _ref.read(tokenResponseProvider) ?? await hydrateFromStorage();
    final expiresAt = session?.accessTokenExpirationDateTime;
    if (session?.accessToken != null && expiresAt != null && expiresAt.isAfter(DateTime.now().add(threshold))) {
      return true;
    }
    return refresh(force: true);
  }

  Future<bool> refresh({final bool force = false}) async {
    final currentExpiry = _ref.read(tokenResponseProvider)?.accessTokenExpirationDateTime;
    if (!force && currentExpiry != null && currentExpiry.isAfter(DateTime.now())) {
      return true;
    }

    final persistedAccessToken = await _storage.read(StorageKeys.accessToken);
    final hasPersistedSession = persistedAccessToken != null && persistedAccessToken.isNotEmpty;
    final refreshToken = _ref.read(tokenResponseProvider)?.refreshToken ?? await _storage.read(StorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      await clear();
      return false;
    }

    try {
      final newSession = await _repository.refreshToken(refreshToken: refreshToken);
      final mergedSession = _mergeWithCurrentSession(newSession);
      if (hasPersistedSession) {
        await persist(mergedSession);
      } else {
        _updateMemory(mergedSession);
      }
      return true;
    } on Object {
      await clear();
      return false;
    }
  }

  Future<void> persist(
    final TokenResponse session, {
    final JwtClaims? claims,
  }) async {
    await Future.wait([
      if (session.accessToken != null) _storage.write(StorageKeys.accessToken, session.accessToken!),
      if (session.refreshToken != null) _storage.write(StorageKeys.refreshToken, session.refreshToken!),
      if (session.accessTokenExpirationDateTime != null)
        _storage.write(
          StorageKeys.sessionExpiresAt,
          session.accessTokenExpirationDateTime!.toIso8601String(),
        ),
    ]);
    _updateMemory(session, claims: claims);
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
    await Future.wait([
      _storage.delete(StorageKeys.accessToken),
      _storage.delete(StorageKeys.refreshToken),
      _storage.delete(StorageKeys.sessionExpiresAt),
    ]);
    _ref.read(tokenResponseProvider.notifier).update(null);
    _ref.read(jwtClaimsProvider.notifier).update(null);
  }

  void _updateMemory(
    final TokenResponse session, {
    final JwtClaims? claims,
  }) {
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
