import 'dart:async';
import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session_refresh_status.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

/// In-memory [AppStorage] fake — sostiene la preferencia de acceso rápido,
/// de la que ahora depende que el offline token llegue a guardarse.
final class FakeAppStorage implements AppStorage {
  final Map<String, Object> values = {};

  @override
  T? read<T>(final String key) => values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    values.clear();
    return true;
  }
}

/// In-memory [SecureStorage] fake.
///
/// Records the protection each key was written with, and which keys were read,
/// so the tests can assert *where* the biometric gate sits: on a real device a
/// read of a biometric key raises the platform prompt.
final class FakeSecureStorage implements SecureStorage {
  final Map<String, String> store = {};
  final Map<String, SecureStorageProtection> writtenWith = {};
  final List<String> readKeys = [];

  /// Operaciones en orden, como `'delete:clave'` / `'write:clave'`.
  final List<String> operations = [];

  /// Keys whose read fails, simulating a cancelled or failed biometric check.
  final Set<String> unreadableKeys = {};

  /// Keys whose write fails, simulating a device with no biometrics enrolled
  /// (the store refuses rather than degrading to an unauthenticated key).
  final Set<String> unwritableKeys = {};

  @override
  Future<String?> read(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async {
    readKeys.add(key);
    if (unreadableKeys.contains(key)) {
      throw StateError('biometric check rejected for $key');
    }
    return store[key];
  }

  @override
  Future<void> write(final String key, final String value, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async {
    if (unwritableKeys.contains(key)) {
      throw StateError('no biometric hardware available for $key');
    }
    operations.add('write:$key');
    writtenWith[key] = protection;
    store[key] = value;
  }

  @override
  Future<void> delete(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard}) async {
    operations.add('delete:$key');
    store.remove(key);
  }

  @override
  /// Si el último [clear] alcanzó al almacén protegido.
  bool clearedBiometric = false;

  @override
  Future<void> clearBiometric() async {
    clearedBiometric = true;
    store.remove(StorageKeys.refreshToken);
  }

  @override
  Future<void> clear({final bool includeBiometric = true}) async {
    clearedBiometric = includeBiometric;
    store.remove(StorageKeys.accessToken);
    store.remove(StorageKeys.idToken);
    store.remove(StorageKeys.sessionExpiresAt);
    if (includeBiometric) {
      store.remove(StorageKeys.refreshToken);
    }
    writtenWith.clear();
  }
}

/// [AuthRepository] fake that counts refreshes, can be gated to force
/// concurrency, and can be made to throw a chosen [AuthException].
final class FakeAuthRepository implements AuthRepository {
  final List<String> revokedTokens = [];

  @override
  Exception? revokeError;

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    final error = revokeError;
    if (error != null) {
      throw error;
    }
    revokedTokens.add(refreshToken);
  }

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

/// La preferencia de acceso rápido va por ciudadano, y el `idAgente` sale del
/// claim `subAlt`: las sesiones de estos tests tienen que declararlo.
const String _idAgente = 'PER1';
const String _quickAccessKey = '${StorageKeys.biometricQuickAccessEnabledPrefix}$_idAgente';
/// Access token con forma de JWT y el claim `sub_alt`. Los de Cerbero lo son,
/// y el controlador re-decodifica el access token en cada refresco para
/// refrescar la identidad: con una cadena cualquiera la perdería.
String _accessTokenFor(final String tag) {
  String segment(final Map<String, Object?> value) => base64Url.encode(utf8.encode(json.encode(value))).replaceAll('=', '');
  return '${segment(const {'alg': 'none'})}.${segment({'sub': 'sub-1', 'sub_alt': _idAgente, 'tag': tag, 'exp': 9999999999})}.sig';
}

const JwtClaims _claims = JwtClaims(exp: 9999999999, iat: 0, iss: 'test', aud: ['app'], sub: 'sub-1', subAlt: _idAgente);

void main() {
  late FakeAuthRepository repository;
  late FakeSecureStorage storage;
  late FakeAppStorage appStorage;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        secureStorageProvider.overrideWithValue(storage),
        appStorageProvider.overrideWithValue(appStorage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    repository = FakeAuthRepository();
    storage = FakeSecureStorage();
    appStorage = FakeAppStorage()
      // El grueso de los tests ejercita la sesión persistida, que ahora exige
      // el opt-in; los que comprueban lo contrario lo apagan explícitamente.
      ..values[_quickAccessKey] = true;
  });

  group('AuthSessionController.revokeCurrentOfflineSession', () {
    test('revoca con el token en memoria', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)
        ..startInMemory(TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null), claims: _claims);

      await controller.revokeCurrentOfflineSession();

      expect(repository.revokedTokens, ['refresh']);
    });

    test('sin token en memoria no intenta nada, y no lee el almacén protegido', () async {
      // Leerlo levantaría el diálogo biométrico, y pedir la huella para cerrar
      // sesión es justo lo que se quiso evitar.
      storage.store[StorageKeys.refreshToken] = 'guardado';
      final container = buildContainer();

      await container.read(authSessionControllerProvider).revokeCurrentOfflineSession();

      expect(repository.revokedTokens, isEmpty);
      expect(storage.readKeys, isNot(contains(StorageKeys.refreshToken)));
    });

    test('un fallo de revocación no impide cerrar sesión', () async {
      repository.revokeError = Exception('servidor caído');
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)
        ..startInMemory(TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null), claims: _claims);

      await expectLater(controller.revokeCurrentOfflineSession(), completes);
    });
  });

  group('AuthSessionController biometric protection of the offline token', () {
    test('only the refresh token is stored behind the biometric gate', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      await controller.persist(
        TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null),
        claims: _claims,
      );

      expect(storage.writtenWith[StorageKeys.refreshToken], SecureStorageProtection.biometric);
      expect(
        storage.writtenWith[StorageKeys.accessToken],
        SecureStorageProtection.standard,
        reason: 'the access token must stay readable without a prompt, or "if there is an access token you can enter" is impossible',
      );
      expect(storage.writtenWith[StorageKeys.idToken], SecureStorageProtection.standard);
    });

    test('a device that cannot protect the token keeps working instead of crashing', () async {
      // `enforceBiometrics` makes the write fail rather than silently storing
      // the token unprotected. Correct policy — but it must not take the
      // navigation down with it: the session just does not survive a restart,
      // exactly as it behaved before any of this existed.
      storage.unwritableKeys.add(StorageKeys.refreshToken);
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      await expectLater(
        controller.persist(
          TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null),
          claims: _claims,
        ),
        completes,
      );

      expect(storage.store[StorageKeys.accessToken], 'access');
      expect(storage.store[StorageKeys.refreshToken], isNull, reason: 'never stored unprotected');
    });

    test('REGRESSION: the offline token is deleted before being written, so the access control is really applied', () async {
      // El Keychain no permite cambiar el ACL con SecItemUpdate, y el plugin
      // sólo lo aplica en SecItemAdd. Sin el borrado previo, una entrada
      // preexistente —creada sin protección por cualquier build anterior—
      // conservaría su ACL viejo y el token quedaría legible sin biometría.
      storage.store[StorageKeys.refreshToken] = 'token-de-una-build-anterior';
      final container = buildContainer();

      await container.read(authSessionControllerProvider).persist(
        TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null),
        claims: _claims,
      );

      expect(
        storage.operations,
        containsAllInOrder(<String>['delete:${StorageKeys.refreshToken}', 'write:${StorageKeys.refreshToken}']),
      );
      expect(storage.writtenWith[StorageKeys.refreshToken], SecureStorageProtection.biometric);
    });

    test('REGRESSION: el borrado de instalación limpia puede dejar fuera el almacén biométrico', () async {
      // En Android tocar ese almacén lo CREA, y crearlo dispara una migración
      // que exige autenticar: el ciudadano veía un diálogo de huella nada más
      // instalar, antes de hacer nada. La rutina de arranque existe por iOS,
      // donde el Keychain sobrevive a la desinstalación.
      storage.store[StorageKeys.accessToken] = 'viejo';
      storage.store[StorageKeys.refreshToken] = 'viejo-offline';

      await storage.clear(includeBiometric: false);

      expect(storage.store[StorageKeys.accessToken], isNull);
      expect(storage.clearedBiometric, isFalse, reason: 'no debe tocarse el almacén protegido');
    });

    test('sin el opt-in activado no se guarda NADA, ni siquiera el access token', () async {
      // Sin acceso rápido la sesión no se reanuda al reabrir la app, así que
      // guardar credenciales no sirve a nadie: sólo dejaría un access token
      // huérfano. Su sesión vive en memoria mientras la app esté abierta, que
      // es lo que el ciudadano aceptó.
      appStorage.values[_quickAccessKey] = false;
      final container = buildContainer();

      await container.read(authSessionControllerProvider).persist(
        TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null),
        claims: _claims,
      );

      expect(storage.store, isEmpty);
    });

    test('desactivar limpia lo que hubiera guardado de una activación anterior', () async {
      storage.store[StorageKeys.accessToken] = 'de-cuando-estaba-activado';
      storage.store[StorageKeys.idToken] = 'id-viejo';
      appStorage.values[_quickAccessKey] = false;
      final container = buildContainer();

      await container.read(authSessionControllerProvider).persist(
        TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null),
        claims: _claims,
      );

      expect(storage.store[StorageKeys.accessToken], isNull, reason: '«no activado» debe significar «nada guardado»');
      expect(storage.store[StorageKeys.idToken], isNull);
    });

    test('desactivar el opt-in borra del dispositivo el token ya guardado', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)
        ..startInMemory(TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null), claims: _claims);
      await controller.persist(
        TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null),
        claims: _claims,
      );
      expect(storage.store[StorageKeys.refreshToken], 'refresh');

      appStorage.values[_quickAccessKey] = false;
      await controller.applyBiometricQuickAccessChange();

      expect(storage.store[StorageKeys.refreshToken], isNull, reason: 'revocar el acceso rápido no puede dejar el token en el dispositivo');
    });

    test('activar el opt-in guarda el token de la sesión en curso, sin esperar al siguiente login', () async {
      appStorage.values[_quickAccessKey] = false;
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)
        ..startInMemory(TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), 'id', null, null, null), claims: _claims);

      appStorage.values[_quickAccessKey] = true;
      await controller.applyBiometricQuickAccessChange();

      expect(storage.store[StorageKeys.refreshToken], 'refresh');
      expect(storage.writtenWith[StorageKeys.refreshToken], SecureStorageProtection.biometric);
    });

    test('hydrating on start-up never touches the refresh token, so no prompt is raised', () async {
      storage.store[StorageKeys.accessToken] = 'access';
      storage.store[StorageKeys.refreshToken] = 'refresh';
      storage.store[StorageKeys.sessionExpiresAt] = DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
      final container = buildContainer();

      final session = await container.read(authSessionControllerProvider).hydrateFromStorage();

      expect(session?.accessToken, 'access');
      expect(
        storage.readKeys,
        isNot(contains(StorageKeys.refreshToken)),
        reason: 'reading it would raise the biometric prompt on every cold start, even with a valid access token',
      );
    });

    test('a rejected biometric check keeps the session instead of destroying it', () async {
      storage.store[StorageKeys.accessToken] = 'persisted-access';
      storage.store[StorageKeys.refreshToken] = 'persisted-refresh';
      storage.unreadableKeys.add(StorageKeys.refreshToken);
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)
        // Estado de una sesión hidratada: identidad y access token caducado en
        // memoria, refresh no. La identidad hace falta porque la preferencia
        // de acceso rápido va por ciudadano, y sin ella ni se intenta leer el
        // almacén protegido.
        ..startInMemory(
          TokenResponse('persisted-access', null, DateTime.now().subtract(const Duration(minutes: 1)), null, null, null, null),
          claims: _claims,
        );

      final status = await controller.refreshStatus(force: true);

      expect(status, SessionRefreshStatus.unknownTransient);
      expect(
        storage.store[StorageKeys.accessToken],
        'persisted-access',
        reason: 'cancelling the prompt says nothing about the token being dead — nothing may be wiped',
      );
    });
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
      final controller = container.read(authSessionControllerProvider)
        // Estado idéntico al que deja `hydrateFromStorage`: identidad y access
        // token en memoria, refresh no —vive en el almacén protegido—. Hace
        // falta la identidad porque la preferencia de acceso rápido va por
        // ciudadano.
        ..startInMemory(
          TokenResponse('old-access', null, DateTime.now().subtract(const Duration(minutes: 1)), null, null, null, null),
          claims: _claims,
        );

      repository.responseBuilder = (final count) => TokenResponse(
        _accessTokenFor('new-access-$count'),
        'new-refresh-$count',
        DateTime.now().add(const Duration(minutes: 5)),
        null,
        null,
        null,
        null,
      );

      final refreshed = await controller.refresh(force: true);

      expect(refreshed, isTrue);
      expect(storage.store[StorageKeys.accessToken], _accessTokenFor('new-access-1'));
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
      // El refresh token sobrevive al logout a propósito: tocar el almacén
      // protegido en Android lo inicializa, y eso autentica —pedía huella para
      // cerrar sesión—. Lo que importa aquí es que la sesión no resucite, y sin
      // access token no hay nada que restaurar.
    });
  });

  group('AuthSessionController sessionExpiresAt persistence', () {
    test('persist with an expiry writes it as ISO-8601', () async {
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);
      final expiresAt = DateTime.now().add(const Duration(minutes: 5));

      await controller.persist(tokenExpiringIn(const Duration(minutes: 5)), claims: _claims);

      final stored = storage.store[StorageKeys.sessionExpiresAt];
      expect(stored, isNotNull);
      expect(DateTime.parse(stored!).difference(expiresAt).abs(), lessThan(const Duration(seconds: 5)));
    });

    test('persist without an expiry deletes the stale persisted instant', () async {
      storage.store[StorageKeys.sessionExpiresAt] = DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider);

      await controller.persist(TokenResponse('new-access', 'new-refresh', null, null, null, null, null), claims: _claims);

      expect(storage.store[StorageKeys.sessionExpiresAt], isNull, reason: 'hydrateFromStorage must not resurrect an expiry the session no longer has');
    });
  });

  group('AuthSessionController idToken persistence (F-23)', () {
    test('persist writes the idToken to secure storage', () async {
      storage.store[StorageKeys.accessToken] = 'old-access';
      storage.store[StorageKeys.refreshToken] = 'old-refresh';
      final container = buildContainer();
      final controller = container.read(authSessionControllerProvider)
        ..startInMemory(
          TokenResponse('old-access', null, DateTime.now().subtract(const Duration(minutes: 1)), null, null, null, null),
          claims: _claims,
        );
      // Access token con forma de JWT: el controlador lo re-decodifica en cada
      // refresco para refrescar la identidad, y con una cadena cualquiera la
      // perdería — y sin identidad no se resuelve la preferencia.
      repository.responseBuilder = (final count) => TokenResponse(
        _accessTokenFor('new-access'),
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
