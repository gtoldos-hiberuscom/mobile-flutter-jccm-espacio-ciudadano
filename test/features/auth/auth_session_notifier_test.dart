import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/auth.dart';

void main() {
  group('AuthSessionNotifier', () {
    test('starts UnauthenticatedSession when SecureStorage is empty', () async {
      final container = _buildContainer(
        repository: _StubAuthRepository(),
        storage: _InMemorySecureStorage(),
      );
      addTearDown(container.dispose);

      final state = await container.read(authSessionProvider.future);

      expect(state, isA<UnauthenticatedSession>());
      expect(container.read(currentIdAgenteProvider), isNull);
      expect(container.read(currentAuthSessionProvider), isNull);
      expect(container.read(currentAuthUserProvider), isNull);
    });

    test('signIn persists tokens, derives AuthUser and exposes idAgente', () async {
      const expectedNif = '12345678Z';
      final session = _makeSession(idToken: _makeIdToken(<String, dynamic>{
        'sub': 'sub-1',
        'nif': expectedNif,
        'given_name': 'Ada',
        'family_name': 'Lovelace',
        'email': 'ada@example.com',
      }));
      final repo = _StubAuthRepository(loginResult: session);
      final storage = _InMemorySecureStorage();
      final container = _buildContainer(repository: repo, storage: storage);
      addTearDown(container.dispose);

      // Materialize the initial state before invoking signIn.
      await container.read(authSessionProvider.future);

      final authenticated = await container.read(authSessionProvider.notifier).signIn();

      expect(authenticated.user.nif, expectedNif);
      expect(authenticated.user.idAgente, expectedNif);
      expect(authenticated.user.displayName, 'Ada Lovelace');

      // Convenience providers reflect the new session.
      expect(container.read(currentIdAgenteProvider), expectedNif);
      expect(container.read(currentAuthSessionProvider)?.accessToken, session.accessToken);
      expect(container.read(currentAuthUserProvider)?.email, 'ada@example.com');

      // SecureStorage is populated for cold-start rehydration.
      expect(await storage.read(StorageKeys.accessToken), session.accessToken);
      expect(await storage.read(StorageKeys.refreshToken), session.refreshToken);
      expect(await storage.read(StorageKeys.idToken), session.idToken);
      expect(await storage.read(StorageKeys.idAgente), expectedNif);
    });

    test('signOut clears SecureStorage and emits UnauthenticatedSession', () async {
      final session = _makeSession(idToken: _makeIdToken(<String, dynamic>{'sub': 's', 'nif': 'X'}));
      final repo = _StubAuthRepository(loginResult: session);
      final storage = _InMemorySecureStorage();
      final container = _buildContainer(repository: repo, storage: storage);
      addTearDown(container.dispose);

      await container.read(authSessionProvider.future);
      await container.read(authSessionProvider.notifier).signIn();

      await container.read(authSessionProvider.notifier).signOut();

      expect(container.read(authSessionProvider).value, isA<UnauthenticatedSession>());
      expect(await storage.read(StorageKeys.accessToken), isNull);
      expect(await storage.read(StorageKeys.idToken), isNull);
      expect(await storage.read(StorageKeys.idAgente), isNull);
      expect(repo.lastLogoutIdToken, session.idToken);
    });

    test('rehydrates an authenticated session from SecureStorage on cold start', () async {
      final idToken = _makeIdToken(<String, dynamic>{'sub': 's', 'nif': '00000000T'});
      final storage = _InMemorySecureStorage()
        ..writeSync(StorageKeys.accessToken, 'persisted-access')
        ..writeSync(StorageKeys.refreshToken, 'persisted-refresh')
        ..writeSync(StorageKeys.idToken, idToken)
        ..writeSync(StorageKeys.idAgente, '00000000T');
      final container = _buildContainer(
        repository: _StubAuthRepository(),
        storage: storage,
      );
      addTearDown(container.dispose);

      final state = await container.read(authSessionProvider.future);

      expect(state, isA<AuthenticatedSession>());
      expect(container.read(currentIdAgenteProvider), '00000000T');
      expect(container.read(currentAuthSessionProvider)?.accessToken, 'persisted-access');
    });
  });
}

ProviderContainer _buildContainer({
  required final AuthRepository repository,
  required final SecureStorage storage,
}) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repository),
      secureStorageProvider.overrideWithValue(storage),
    ],
  );
}

AuthSession _makeSession({required final String idToken}) {
  return AuthSession(
    accessToken: 'access-${idToken.hashCode}',
    refreshToken: 'refresh-${idToken.hashCode}',
    idToken: idToken,
    tokenType: 'Bearer',
    scopes: const ['openid'],
    accessTokenExpiresAt: DateTime.utc(2099, 1, 1),
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

class _StubAuthRepository implements AuthRepository {
  _StubAuthRepository({this.loginResult});

  final AuthSession? loginResult;
  String? lastLogoutIdToken;

  @override
  Future<AuthSession> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  }) async {
    if (loginResult == null) {
      throw const AuthException.unexpected();
    }
    return loginResult!;
  }

  @override
  Future<AuthSession> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) async {
    if (loginResult == null) {
      throw const AuthException.unexpected();
    }
    return loginResult!;
  }

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {
    lastLogoutIdToken = idToken;
  }

  @override
  Future<AuthUser> fetchUserInfo({required final String accessToken}) async {
    return const AuthUser(sub: 'unused');
  }

  @override
  AuthUser? decodeIdTokenUser(final String idToken) {
    // Delegate to the real implementation by reusing the data-layer impl
    // would re-introduce DTO leaks; instead we ship a small inline copy
    // mirroring `AuthRepositoryImpl.decodeIdTokenUser`.
    final parts = idToken.split('.');
    if (parts.length < 2) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final claims = json.decode(utf8.decode(base64Url.decode(normalized)));
      if (claims is! Map) return null;
      final sub = claims['sub'];
      if (sub is! String || sub.isEmpty) return null;
      return AuthUser(
        sub: sub,
        nif: claims['nif'] as String? ?? claims['idAgente'] as String?,
        givenName: claims['given_name'] as String?,
        familyName: claims['family_name'] as String?,
        email: claims['email'] as String?,
      );
    } on FormatException {
      return null;
    }
  }
}
