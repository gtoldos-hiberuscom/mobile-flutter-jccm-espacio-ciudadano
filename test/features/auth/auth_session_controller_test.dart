import 'dart:async';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_refresh_status.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

/// In-memory [SecureStorage] fake.
final class FakeSecureStorage implements SecureStorage {
  final Map<String, String> store = {};

  @override
  Future<String?> read(final String key) async => store[key];

  @override
  Future<void> write(final String key, final String value) async => store[key] = value;

  @override
  Future<void> delete(final String key) async => store.remove(key);

  @override
  Future<void> clear() async => store.clear();
}

/// [AuthRepository] fake that counts refreshes, can be gated to force
/// concurrency, and can be made to throw a chosen [AuthException].
final class FakeAuthRepository implements AuthRepository {
  int refreshCount = 0;
  Completer<void>? gate;
  Exception? errorToThrow;
  TokenResponse Function(int count)? responseBuilder;

  @override
  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) async {
    refreshCount++;
    final currentGate = gate;
    if (currentGate != null) {
      await currentGate.future;
    }
    final error = errorToThrow;
    if (error != null) {
      throw error;
    }
    return responseBuilder?.call(refreshCount) ??
        TokenResponse(
          'new-access-$refreshCount',
          'new-refresh-$refreshCount',
          DateTime.now().add(const Duration(minutes: 5)),
          null,
          null,
          null,
          null,
        );
  }

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool ephemeralSession = true,
  }) => throw UnimplementedError();

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
    final bool ephemeralSession = true,
  }) => throw UnimplementedError();
}

TokenResponse tokenExpiringIn(final Duration ttl) => TokenResponse(
  'old-access',
  'old-refresh',
  DateTime.now().add(ttl),
  null,
  null,
  null,
  null,
);

void main() {
  late FakeAuthRepository repository;
  late FakeSecureStorage storage;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        secureStorageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    repository = FakeAuthRepository();
    storage = FakeSecureStorage();
  });

  group('AuthSessionController.refresh single-flight', () {
    test('concurrent refreshes share a single token() call', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: -1)));
      repository.gate = Completer<void>();

      final futures = List.generate(5, (_) => controller.refresh(force: true));
      repository.gate!.complete();
      final results = await Future.wait(futures);

      expect(repository.refreshCount, 1);
      expect(results, everyElement(isTrue));
    });
  });

  group('AuthSessionController.refresh error handling', () {
    test('remoteFailure (invalid_grant) clears the session', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: -1)));
      repository.errorToThrow = const AuthException.remoteFailure(message: 'invalid_grant');

      final refreshed = await controller.refresh(force: true);

      expect(refreshed, isFalse);
      expect(container.read(tokenResponseProvider), isNull);
    });

    test('transient error (unexpected) keeps the session', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: -1)));
      repository.errorToThrow = const AuthException.unexpected();

      final refreshed = await controller.refresh(force: true);

      expect(refreshed, isFalse);
      expect(container.read(tokenResponseProvider)?.accessToken, 'old-access');
    });

    test('missing refresh token clears the session', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      final refreshed = await controller.refresh(force: true);

      expect(refreshed, isFalse);
      expect(repository.refreshCount, 0);
      expect(container.read(tokenResponseProvider), isNull);
    });
  });

  group('AuthSessionController.refreshIfNeeded proactive threshold', () {
    test('refreshes when the token expires within the threshold', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: 30)));

      final status = await controller.refreshIfNeeded();

      expect(status, SessionRefreshStatus.valid);
      expect(repository.refreshCount, 1);
    });

    test('does not refresh when the token outlives the threshold', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(minutes: 5)));

      final status = await controller.refreshIfNeeded();

      expect(status, SessionRefreshStatus.valid);
      expect(repository.refreshCount, 0);
    });
  });

  group('AuthSessionController three-state refresh (C6)', () {
    test('a transient failure reports unknownTransient and keeps the persisted session', () async {
      storage.store[StorageKeys.accessToken] = 'old-access';
      storage.store[StorageKeys.refreshToken] = 'old-refresh';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: -1)));
      repository.errorToThrow = const AuthException.unexpected();

      final status = await controller.refreshIfNeeded();

      expect(status, SessionRefreshStatus.unknownTransient);
      expect(storage.store[StorageKeys.accessToken], 'old-access', reason: 'a network blip must never destroy the session');
    });

    test('a definitive rejection reports definitivelyInvalid and clears the session', () async {
      storage.store[StorageKeys.accessToken] = 'old-access';
      storage.store[StorageKeys.refreshToken] = 'old-refresh';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: -1)));
      repository.errorToThrow = const AuthException.remoteFailure(message: 'invalid_grant');

      final status = await controller.refreshIfNeeded();

      expect(status, SessionRefreshStatus.definitivelyInvalid);
      expect(storage.store[StorageKeys.accessToken], isNull);
    });

    test('a missing refresh token reports definitivelyInvalid', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      expect(await controller.refreshStatus(force: true), SessionRefreshStatus.definitivelyInvalid);
    });
  });

  group('AuthSessionController.refresh persistence', () {
    test('persisted session writes the rotated tokens to storage', () async {
      storage.store[StorageKeys.accessToken] = 'old-access';
      storage.store[StorageKeys.refreshToken] = 'old-refresh';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      final refreshed = await controller.refresh(force: true);

      expect(refreshed, isTrue);
      expect(storage.store[StorageKeys.accessToken], 'new-access-1');
      expect(storage.store[StorageKeys.refreshToken], 'new-refresh-1');
    });

    test('memory-only session does not touch storage', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: -1)));

      final refreshed = await controller.refresh(force: true);

      expect(refreshed, isTrue);
      expect(storage.store, isEmpty);
      expect(container.read(tokenResponseProvider)?.accessToken, 'new-access-1');
    });
  });

  group('AuthSessionController logout↔refresh race (AUTH-3)', () {
    test('a refresh completing after clear() does not resurrect the session', () async {
      storage.store[StorageKeys.accessToken] = 'old-access';
      storage.store[StorageKeys.refreshToken] = 'old-refresh';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)..startInMemory(tokenExpiringIn(const Duration(seconds: -1)));
      repository.gate = Completer<void>();

      final refreshFuture = controller.refresh(force: true);
      await controller.clear(); // logout lands while the refresh is in flight
      repository.gate!.complete();
      final refreshed = await refreshFuture;

      expect(refreshed, isFalse);
      expect(repository.refreshCount, 1, reason: 'the network refresh did run and complete');
      expect(container.read(tokenResponseProvider), isNull);
      expect(storage.store[StorageKeys.accessToken], isNull);
      expect(storage.store[StorageKeys.refreshToken], isNull);
    });
  });

  group('AuthSessionController sessionExpiresAt persistence', () {
    test('persist with an expiry writes it as ISO-8601', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);
      final expiresAt = DateTime.now().add(const Duration(minutes: 5));

      await controller.persist(tokenExpiringIn(const Duration(minutes: 5)));

      final stored = storage.store[StorageKeys.sessionExpiresAt];
      expect(stored, isNotNull);
      expect(DateTime.parse(stored!).difference(expiresAt).abs(), lessThan(const Duration(seconds: 5)));
    });

    test('persist without an expiry deletes the stale persisted instant', () async {
      storage.store[StorageKeys.sessionExpiresAt] = DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      await controller.persist(TokenResponse('new-access', 'new-refresh', null, null, null, null, null));

      expect(storage.store[StorageKeys.sessionExpiresAt], isNull, reason: 'hydrateFromStorage must not resurrect an expiry the session no longer has');
    });
  });

  group('AuthSessionController idToken persistence (F-23)', () {
    test('persist writes the idToken to secure storage', () async {
      storage.store[StorageKeys.accessToken] = 'old-access';
      storage.store[StorageKeys.refreshToken] = 'old-refresh';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);
      repository.responseBuilder = (final count) => TokenResponse(
        'new-access',
        'new-refresh',
        DateTime.now().add(const Duration(minutes: 5)),
        'id-token-xyz',
        null,
        null,
        null,
      );

      final refreshed = await controller.refresh(force: true);

      expect(refreshed, isTrue);
      expect(storage.store[StorageKeys.idToken], 'id-token-xyz');
    });

    test('hydrateFromStorage restores the persisted idToken', () async {
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      storage.store[StorageKeys.idToken] = 'id-token-xyz';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      final session = await controller.hydrateFromStorage();

      expect(session?.idToken, 'id-token-xyz');
    });

    test('clear removes the persisted idToken', () async {
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      storage.store[StorageKeys.idToken] = 'id-token-xyz';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      await controller.clear();

      expect(storage.store[StorageKeys.idToken], isNull);
    });
  });
}
