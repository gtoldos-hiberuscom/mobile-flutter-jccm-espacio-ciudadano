import 'dart:convert';

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';

/// `tryRestoreSession` identifica al ciudadano decodificando el access token
/// guardado, así que el doble necesita un JWT de verdad —sin firma válida, que
/// no se comprueba— con el claim `sub_alt`.
const String _idAgente = 'PER1';

String _accessTokenFor(final String idAgente) {
  String segment(final Map<String, Object?> value) => base64Url.encode(utf8.encode(json.encode(value))).replaceAll('=', '');
  return '${segment(const {'alg': 'none'})}.${segment({'sub': 'sub-1', 'sub_alt': idAgente, 'exp': 9999999999})}.sig';
}

void main() {
  ProviderContainer buildContainer(
    final AuthRepository repository, {
    final _FakeSecureStorage? storage,
    final bool quickAccessEnabled = false,
    final _FakeBiometricAuthenticator? biometrics,
  }) {
    final container = ProviderContainer(
      overrides: [
        biometricAuthenticatorProvider.overrideWithValue(biometrics ?? _FakeBiometricAuthenticator()),
        loginUseCaseProvider.overrideWithValue(LoginUseCase(repository)),
        authRepositoryProvider.overrideWithValue(repository),
        secureStorageProvider.overrideWithValue(storage ?? _FakeSecureStorage()),
        appStorageProvider.overrideWithValue(
          _FakeAppStorage()..values['${StorageKeys.biometricQuickAccessEnabledPrefix}$_idAgente'] = quickAccessEnabled,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('LandingNotifier.login timeout', () {
    test('a login that never completes releases the CTA with a timeout error', () {
      fakeAsync((final async) {
        final container = buildContainer(_HangingAuthRepository());

        unawaited(container.read(landingProvider.notifier).login());
        async.flushMicrotasks();
        expect(container.read(landingProvider).isLoggingIn, isTrue);

        async.elapse(LandingNotifier.loginTimeout + const Duration(seconds: 1));

        final state = container.read(landingProvider);
        expect(state.isLoggingIn, isFalse, reason: 'the veil and the CTA must be released');
        expect(state.error?.cause, isA<TimeoutException>());
      });
    });
  });

  group('LandingNotifier.login cierra la sesión anterior (JCCMEC-224/228)', () {
    test('cierra la sesión que quedó abierta ANTES de mandar a Cl@ve', () async {
      // Si el cierre fuera después del authorize no serviría de nada: Cerbero
      // ya habría cortado con `already authenticated as different user`.
      final storage = _FakeSecureStorage()..store[StorageKeys.idToken] = 'id-del-ciudadano-anterior';
      final repository = _ImmediateAuthRepository();
      final container = buildContainer(repository, storage: storage);

      await container.read(landingProvider.notifier).login();

      expect(repository.logoutIdTokens, ['id-del-ciudadano-anterior']);
      expect(repository.calls, ['logout', 'login']);
    });

    test('un cierre de sesión en regla no hace pagar una pestaña de más', () async {
      final repository = _ImmediateAuthRepository();
      final container = buildContainer(repository);

      await container.read(landingProvider.notifier).login();

      expect(repository.calls, ['login']);
    });

    test('el login guarda la pista para cerrar la sesión, sin esperar al guard', () async {
      // El `SessionGuard` sólo persiste cuando el gate de consentimiento
      // responde que no hace falta consentimiento. Si ese gate falla y deja
      // pasar, no quedaba `id_token` guardado y el siguiente login se
      // encontraba la sesión anterior viva en el navegador. Por eso se guarda
      // aquí, en cuanto la sesión existe, y no más tarde.
      final storage = _FakeSecureStorage();
      final repository = _ImmediateAuthRepository()..idTokenToReturn = 'id-de-esta-sesion';
      final container = buildContainer(repository, storage: storage);

      await container.read(landingProvider.notifier).login();

      expect(storage.store[StorageKeys.idToken], 'id-de-esta-sesion');
    });

    test('sin idToken en la respuesta no se guarda nada', () async {
      final storage = _FakeSecureStorage();
      final repository = _ImmediateAuthRepository();
      final container = buildContainer(repository, storage: storage);

      await container.read(landingProvider.notifier).login();

      expect(storage.store.containsKey(StorageKeys.idToken), isFalse);
    });
  });

  group('LandingNotifier.tryRestoreSession', () {
    test('reanudar pide biometría al arrancar aunque el access token siga vivo', () async {
      // El diálogo se adelanta al arranque a propósito. Entrar sin pedir nada
      // y cobrar la huella cinco minutos después —al caducar el access token,
      // con el ciudadano ya leyendo algo— es la misma huella en peor momento;
      // y mientras tanto, quien cogiera el móvil desbloqueado entraba en la
      // sesión ajena sin autenticarse.
      final repository = _HangingAuthRepository();
      final storage = _FakeSecureStorage()
        ..store[StorageKeys.accessToken] = _accessTokenFor(_idAgente)
        ..store[StorageKeys.refreshToken] = 'guardado'
        ..store[StorageKeys.sessionExpiresAt] = DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
      final biometrics = _FakeBiometricAuthenticator();
      final container = buildContainer(repository, storage: storage, quickAccessEnabled: true, biometrics: biometrics);

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(container.read(landingProvider).loginSuccess, isTrue);
      expect(biometrics.prompts, 1, reason: 'el token guardado no se usa sin superar la huella');
      expect(biometrics.lastTitle, 't', reason: 'el diálogo lleva la copia de la landing');
      expect(
        repository.refreshAttempts,
        0,
        reason: 'el access token guardado sigue sirviendo: desbloquear no es motivo para salir a la red',
      );
    });

    test('cancelar la biometría al arrancar deja la sesión intacta y al ciudadano fuera', () async {
      // Cancelar no dice que la credencial esté muerta, así que no se borra
      // nada: el ciudadano se queda en la landing pública y puede reintentarlo
      // o entrar por Cl@ve.
      final storage = _FakeSecureStorage()
        ..store[StorageKeys.accessToken] = _accessTokenFor(_idAgente)
        ..store[StorageKeys.refreshToken] = 'guardado'
        ..store[StorageKeys.sessionExpiresAt] = DateTime.now().add(const Duration(minutes: 5)).toIso8601String();
      final container = buildContainer(_HangingAuthRepository(), storage: storage, quickAccessEnabled: true, biometrics: _FakeBiometricAuthenticator()..allow = false);

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(container.read(landingProvider).loginSuccess, isFalse);
      expect(
        container.read(landingProvider).sessionExpired,
        isFalse,
        reason: 'decirle que su sesión ha terminado sería mentirle: sigue guardada',
      );
      expect(storage.store[StorageKeys.refreshToken], 'guardado');
    });

    test('un access token al borde de caducar no se da por bueno', () async {
      // Entrar con 30 segundos de margen sería entrar para que la primera
      // petición se encuentre un 401.
      final repository = _HangingAuthRepository();
      final storage = _FakeSecureStorage()
        ..store[StorageKeys.accessToken] = _accessTokenFor(_idAgente)
        ..store[StorageKeys.refreshToken] = 'guardado'
        ..store[StorageKeys.sessionExpiresAt] = DateTime.now().add(const Duration(seconds: 30)).toIso8601String();
      final container = buildContainer(repository, storage: storage, quickAccessEnabled: true);

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(
        repository.refreshAttempts,
        1,
        reason: 'con 30 segundos de margen hay que renovar, no entrar para que la primera petición se encuentre un 401',
      );
      expect(container.read(landingProvider).loginSuccess, isFalse);
    });

    test('REGRESSION: con el access token caducado y sin acceso rápido, no se restaura', () async {
      // Si por cualquier motivo queda un token huérfano en el dispositivo, sin
      // este gate el acceso rápido seguiría funcionando pese a figurar como
      // desactivado.
      final storage = _FakeSecureStorage()
        ..store[StorageKeys.accessToken] = _accessTokenFor(_idAgente)
        ..store[StorageKeys.refreshToken] = 'huerfano';
      final container = buildContainer(_HangingAuthRepository(), storage: storage);

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(container.read(landingProvider).loginSuccess, isFalse);
    });

    test('REGRESSION: en un dispositivo compartido, el «sí» de un ciudadano no vale por otro', () async {
      // La preferencia era global y sobrevivía al logout: el segundo en entrar
      // veía su sesión guardada sin habérsele preguntado, protegida por las
      // huellas dadas de alta en el aparato, que pueden ser de otra persona.
      final storage = _FakeSecureStorage()
        ..store[StorageKeys.accessToken] = _accessTokenFor('OTRO-CIUDADANO')
        ..store[StorageKeys.refreshToken] = 'de-otro';
      // El acceso rápido está activado, pero para _idAgente, no para éste.
      final container = buildContainer(_HangingAuthRepository(), storage: storage, quickAccessEnabled: true);

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(
        container.read(landingProvider).loginSuccess,
        isFalse,
        reason: 'la preferencia es de quien la dio, no del dispositivo',
      );
    });

    test('si el servidor rechaza la credencial, se avisa de que la sesión terminó', () async {
      // El caso de volver tras dos semanas: la huella funciona, pero el token
      // ya caducó por inactividad. Antes se quedaba en la landing sin decir
      // nada, y desde fuera parecía que la app le hubiera echado sin motivo.
      final storage = _FakeSecureStorage()
        ..store[StorageKeys.accessToken] = _accessTokenFor(_idAgente)
        ..store[StorageKeys.refreshToken] = 'caducado'
        ..store[StorageKeys.sessionExpiresAt] = DateTime.now().subtract(const Duration(minutes: 1)).toIso8601String();
      final container = buildContainer(
        const _FailingAuthRepository(AuthException.remoteFailure(message: 'invalid_grant')),
        storage: storage,
        quickAccessEnabled: true,
      );

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(container.read(landingProvider).sessionExpired, isTrue);
    });

    test('si la biometría se cancela NO se dice que la sesión ha terminado', () async {
      // Cancelar no mata nada: el token sigue siendo bueno y al reintentar
      // entra. Avisar de lo contrario sería mentirle.
      final storage = _FakeSecureStorage()
        ..store[StorageKeys.accessToken] = _accessTokenFor(_idAgente)
        ..store[StorageKeys.refreshToken] = 'bueno'
        ..store[StorageKeys.sessionExpiresAt] = DateTime.now().subtract(const Duration(minutes: 1)).toIso8601String();
      final container = buildContainer(_HangingAuthRepository(), storage: storage, quickAccessEnabled: true, biometrics: _FakeBiometricAuthenticator()..allow = false);

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(container.read(landingProvider).sessionExpired, isFalse);
      expect(container.read(landingProvider).loginSuccess, isFalse);
    });

    test('sin sesión guardada no se intenta nada', () async {
      final container = buildContainer(_HangingAuthRepository(), quickAccessEnabled: true);

      await container.read(landingProvider.notifier).tryRestoreSession(
        localizedTitle: 't',
        localizedReason: 'r',
        localizedCancel: 'c',
      );

      expect(container.read(landingProvider).loginSuccess, isFalse);
    });
  });

  group('LandingNotifier.consumeLoginSuccess', () {
    test('clears the one-shot flag after a successful login', () async {
      final container = buildContainer(_ImmediateAuthRepository());
      final notifier = container.read(landingProvider.notifier);

      await notifier.login();
      expect(container.read(landingProvider).loginSuccess, isTrue);

      notifier.consumeLoginSuccess();
      expect(container.read(landingProvider).loginSuccess, isFalse);
    });

    test('does not disturb an unrelated state', () async {
      final container = buildContainer(_HangingAuthRepository());
      final notifier = container.read(landingProvider.notifier);

      unawaited(notifier.login());
      await Future<void>.delayed(Duration.zero);
      notifier.consumeLoginSuccess();

      expect(container.read(landingProvider).isLoggingIn, isTrue);
    });
  });
}

final class _HangingAuthRepository implements AuthRepository {
  final List<String> revokedTokens = [];

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    revokedTokens.add(refreshToken);
  }

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) => Completer<TokenResponse>().future;

  /// Veces que se pidió renovar contra el servidor. Distingue «entró con lo que
  /// ya tenía» de «tuvo que salir a la red».
  int refreshAttempts = 0;

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) {
    refreshAttempts++;
    throw UnimplementedError();
  }

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) => throw UnimplementedError();
}

final class _ImmediateAuthRepository implements AuthRepository {
  final List<String> revokedTokens = [];

  /// Orden en que se invocó cada operación. El arreglo de JCCMEC-224/228
  /// depende de que el cierre vaya **antes** del authorize: hacerlo después no
  /// sirve de nada.
  final List<String> calls = [];

  final List<String> logoutIdTokens = [];

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    revokedTokens.add(refreshToken);
  }

  String? idTokenToReturn;

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) async {
    calls.add('login');
    return TokenResponse(
      'not-a-real-jwt',
      'refresh',
      DateTime.now().add(const Duration(minutes: 5)),
      idTokenToReturn,
      null,
      null,
      null,
    );
  }

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) async {
    calls.add('logout');
    logoutIdTokens.add(idToken);
  }
}

final class _FakeAppStorage implements AppStorage {
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

final class _FakeBiometricAuthenticator implements BiometricAuthenticator {
  bool allow = true;
  int prompts = 0;
  String? lastTitle;

  @override
  Future<bool> canAuthenticateWithBiometrics() async => true;

  @override
  Future<bool> authenticateForSessionUnlock({required final String localizedReason, final String? title, final String? cancelLabel}) async {
    prompts++;
    lastTitle = title;
    return allow;
  }
}

final class _FakeSecureStorage implements SecureStorage {
  final Map<String, String> store = {};

  /// Claves leídas, en orden.
  final List<String> readKeys = [];

  @override
  Future<String?> read(final String key) async {
    readKeys.add(key);
    return store[key];
  }

  @override
  Future<void> write(final String key, final String value) async => store[key] = value;

  @override
  Future<void> delete(final String key) async => store.remove(key);


  @override
  Future<void> clear() async => store.clear();
}

/// Repositorio cuyo refresco siempre falla con la excepción dada.
final class _FailingAuthRepository implements AuthRepository {
  const _FailingAuthRepository(this.error);

  final AuthException error;

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {}

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) => throw UnimplementedError();

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw error;

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) async {}
}
