import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_session_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/auth/auth.dart';

void main() {
  group('AuthSessionNotifier (expositor)', () {
    test('starts UnauthenticatedSession when SecureStorage is empty', () async {
      final container = _buildContainer();
      addTearDown(container.dispose);

      final state = await container.read(authSessionProvider.future);

      expect(state, isA<UnauthenticatedSession>());
      expect(container.read(currentIdAgenteProvider), isNull);
      expect(container.read(currentAuthSessionProvider), isNull);
      expect(container.read(currentAuthUserProvider), isNull);
    });

    test('rehydrates an authenticated session from SecureStorage on cold start', () async {
      final idToken = _makeIdToken(<String, dynamic>{'sub': 's', 'nif': '00000000T'});
      final storage = _InMemorySecureStorage()
        ..writeSync(StorageKeys.accessToken, 'persisted-access')
        ..writeSync(StorageKeys.refreshToken, 'persisted-refresh')
        ..writeSync(StorageKeys.idToken, idToken)
        ..writeSync(StorageKeys.idAgente, '00000000T');
      final container = _buildContainer(storage: storage);
      addTearDown(container.dispose);

      final state = await container.read(authSessionProvider.future);

      expect(state, isA<AuthenticatedSession>());
      expect(container.read(currentIdAgenteProvider), '00000000T');
      expect(container.read(currentAuthSessionProvider)?.accessToken, 'persisted-access');
    });

    test('reacts to AuthSessionRepository.save updates emitted via watch()', () async {
      final container = _buildContainer();
      addTearDown(container.dispose);

      // Materialize the initial state and subscribe via build().
      await container.read(authSessionProvider.future);

      final repo = container.read(authSessionRepositoryProvider);
      final idToken = _makeIdToken(<String, dynamic>{'sub': 's', 'nif': '11111111H'});
      await repo.save(AuthTokens(
        accessToken: 'a',
        refreshToken: 'r',
        idToken: idToken,
        tokenType: 'Bearer',
        scopes: const ['openid'],
      ));

      // Allow the broadcast stream listener to flush.
      await Future<void>.delayed(Duration.zero);

      expect(container.read(authSessionProvider).value, isA<AuthenticatedSession>());
      expect(container.read(currentIdAgenteProvider), '11111111H');
    });

    test('reacts to AuthSessionRepository.clear emitted via watch()', () async {
      final idToken = _makeIdToken(<String, dynamic>{'sub': 's', 'nif': '22222222J'});
      final storage = _InMemorySecureStorage()
        ..writeSync(StorageKeys.accessToken, 'a')
        ..writeSync(StorageKeys.idToken, idToken)
        ..writeSync(StorageKeys.idAgente, '22222222J');
      final container = _buildContainer(storage: storage);
      addTearDown(container.dispose);

      await container.read(authSessionProvider.future);
      expect(container.read(authSessionProvider).value, isA<AuthenticatedSession>());

      await container.read(authSessionRepositoryProvider).clear();
      await Future<void>.delayed(Duration.zero);

      expect(container.read(authSessionProvider).value, isA<UnauthenticatedSession>());
    });
  });

  group('AuthSessionRepositoryImpl', () {
    test('save persists tokens, derives AuthUser and emits new state', () async {
      final storage = _InMemorySecureStorage();
      final repo = AuthSessionRepositoryImpl(storage);
      final emissions = <AuthSessionState>[];
      final sub = repo.watch().listen(emissions.add);
      addTearDown(sub.cancel);

      final idToken = _makeIdToken(<String, dynamic>{
        'sub': 'sub-1',
        'nif': '12345678Z',
        'given_name': 'Ada',
        'family_name': 'Lovelace',
        'email': 'ada@example.com',
      });
      final result = await repo.save(AuthTokens(
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
        idToken: idToken,
        tokenType: 'Bearer',
        scopes: const ['openid'],
        accessTokenExpiresAt: DateTime.utc(2099),
      ));

      expect(result.user.idAgente, '12345678Z');
      expect(result.user.displayName, 'Ada Lovelace');
      expect(await storage.read(StorageKeys.accessToken), 'access-1');
      expect(await storage.read(StorageKeys.idAgente), '12345678Z');
      expect(await storage.read(StorageKeys.idToken), idToken);

      await Future<void>.delayed(Duration.zero);
      expect(emissions.single, isA<AuthenticatedSession>());
    });

    test('clear wipes SecureStorage and emits UnauthenticatedSession', () async {
      final storage = _InMemorySecureStorage()
        ..writeSync(StorageKeys.accessToken, 'a')
        ..writeSync(StorageKeys.refreshToken, 'r')
        ..writeSync(StorageKeys.idToken, 'i')
        ..writeSync(StorageKeys.idAgente, 'X')
        ..writeSync(StorageKeys.sessionExpiresAt, '2099-01-01T00:00:00.000Z');
      final repo = AuthSessionRepositoryImpl(storage);
      final emissions = <AuthSessionState>[];
      final sub = repo.watch().listen(emissions.add);
      addTearDown(sub.cancel);

      await repo.clear();

      expect(await storage.read(StorageKeys.accessToken), isNull);
      expect(await storage.read(StorageKeys.idAgente), isNull);
      expect(await storage.read(StorageKeys.sessionExpiresAt), isNull);
      await Future<void>.delayed(Duration.zero);
      expect(emissions.single, isA<UnauthenticatedSession>());
    });

    test('save throws StateError when id_token is missing', () async {
      final repo = AuthSessionRepositoryImpl(_InMemorySecureStorage());
      await expectLater(
        () => repo.save(const AuthTokens(accessToken: 'a', tokenType: 'Bearer', scopes: ['openid'])),
        throwsA(isA<StateError>()),
      );
    });

    test('read returns Unauthenticated when storage is empty', () async {
      final repo = AuthSessionRepositoryImpl(_InMemorySecureStorage());
      expect(await repo.read(), isA<UnauthenticatedSession>());
    });

    test('read wipes corrupt id_token and falls back to Unauthenticated', () async {
      final storage = _InMemorySecureStorage()
        ..writeSync(StorageKeys.accessToken, 'a')
        ..writeSync(StorageKeys.idToken, 'not-a-jwt');
      final repo = AuthSessionRepositoryImpl(storage);

      expect(await repo.read(), isA<UnauthenticatedSession>());
      expect(await storage.read(StorageKeys.accessToken), isNull);
    });
  });
}

ProviderContainer _buildContainer({final SecureStorage? storage}) {
  return ProviderContainer(
    overrides: [
      secureStorageProvider.overrideWithValue(storage ?? _InMemorySecureStorage()),
    ],
  );
}

String _makeIdToken(final Map<String, dynamic> payload) {
  String segment(final Map<String, dynamic> claims) {
    final encoded = base64Url.encode(utf8.encode(json.encode(claims)));
    return encoded.replaceAll('=', '');
  }
  final header = segment(<String, dynamic>{'alg': 'none', 'typ': 'JWT'});
  final body = segment(payload);
  return '$header.$body.signature-not-verified';
}

class _InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _store = <String, String>{};

  void writeSync(final String key, final String value) {
    _store[key] = value;
  }

  @override
  Future<String?> read(final String key) async => _store[key];

  @override
  Future<void> write(final String key, final String value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(final String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}
