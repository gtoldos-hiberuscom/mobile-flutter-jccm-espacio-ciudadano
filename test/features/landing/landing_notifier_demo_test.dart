import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_mode_provider.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';

void main() {
  late _FakeSecureStorage storage;
  late _FakeAppStorage appStorage;
  late _UntouchableAuthRepository repository;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        secureStorageProvider.overrideWithValue(storage),
        appStorageProvider.overrideWithValue(appStorage),
        biometricAuthenticatorProvider.overrideWithValue(_UntouchableBiometrics()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    storage = _FakeSecureStorage();
    appStorage = _FakeAppStorage();
    repository = _UntouchableAuthRepository();
  });

  group('LandingNotifier.enterDemoMode', () {
    test('arranca la sesión demo en memoria sin tocar Cl@ve y señala la navegación', () async {
      final container = buildContainer();

      await container.read(landingProvider.notifier).enterDemoMode();

      expect(container.read(landingProvider).loginSuccess, isTrue);
      expect(DemoSession.isDemo(container.read(jwtClaimsProvider)), isTrue);
      expect(container.read(tokenResponseProvider)?.accessToken, isNotNull);
      expect(container.read(demoModeProvider), isTrue);
      expect(repository.calls, isEmpty, reason: 'ni login ni logout: la demo no pasa por el repositorio real');
    });

    test('no deja nada en el almacén seguro', () async {
      // Sin acceso rápido la sesión vive en memoria; sin id_token no hay pista
      // de navegador que guardar. Si algo quedara aquí, el siguiente arranque
      // real lo encontraría.
      final container = buildContainer();

      await container.read(landingProvider.notifier).enterDemoMode();

      expect(storage.store, isEmpty);
    });

    test('borra las trazas locales de una demostración anterior', () async {
      appStorage.values['${StorageKeys.consentAcceptedPrefix}${DemoSession.idAgente}'] = true;
      appStorage.values['${StorageKeys.lifeEventsOnboardingSeenPrefix}${DemoSession.idAgente}'] = true;
      final container = buildContainer();

      await container.read(landingProvider.notifier).enterDemoMode();

      expect(appStorage.values.keys.where((final key) => key.endsWith(DemoSession.idAgente)), isEmpty);
    });

    test('con una sesión real guardada no entra y avisa', () async {
      // El gate de consentimiento borraría esa sesión al ver «guardada +
      // consentimiento demo no aceptado». Antes de llegar ahí, se para.
      storage.store[StorageKeys.accessToken] = 'token-de-un-ciudadano-real';
      final container = buildContainer();

      await container.read(landingProvider.notifier).enterDemoMode();

      final state = container.read(landingProvider);
      expect(state.demoBlockedByPersistedSession, isTrue);
      expect(state.loginSuccess, isFalse);
      expect(container.read(jwtClaimsProvider), isNull);
      expect(container.read(demoModeProvider), isFalse);
      expect(storage.store[StorageKeys.accessToken], 'token-de-un-ciudadano-real', reason: 'la sesión del ciudadano sigue intacta');
    });

    test('con una sesión guardada y permiso para cerrarla: la cierra como «Cerrar sesión» y entra', () async {
      // Lo que `persist()` deja con el acceso rápido activado. El cierre debe
      // terminar la sesión en Cerbero con el id_token guardado (si no, el
      // siguiente login de Cl@ve se encuentra la sesión anterior en el
      // navegador) y no dejar nada en el almacén.
      storage.store[StorageKeys.accessToken] = 'token-de-un-ciudadano-real';
      storage.store[StorageKeys.idToken] = 'id-token-guardado';
      storage.store[StorageKeys.refreshToken] = 'larga-vida-guardado';
      final container = buildContainer();

      await container.read(landingProvider.notifier).enterDemoMode(closePersistedSession: true);

      expect(repository.calls, ['logout']);
      expect(repository.logoutIdTokens, ['id-token-guardado']);
      expect(storage.store, isEmpty, reason: 'la sesión guardada se cierra del todo antes de entrar');
      final state = container.read(landingProvider);
      expect(state.loginSuccess, isTrue);
      expect(state.demoBlockedByPersistedSession, isFalse);
      expect(DemoSession.isDemo(container.read(jwtClaimsProvider)), isTrue);
      expect(container.read(demoModeProvider), isTrue);
    });

    test('sin id_token guardado el cierre no llama a Cerbero, pero limpia y entra igual', () async {
      storage.store[StorageKeys.accessToken] = 'token-de-un-ciudadano-real';
      final container = buildContainer();

      await container.read(landingProvider.notifier).enterDemoMode(closePersistedSession: true);

      expect(repository.calls, isEmpty);
      expect(storage.store, isEmpty);
      expect(container.read(demoModeProvider), isTrue);
    });

    test('hasPersistedSession refleja el almacén seguro', () async {
      final container = buildContainer();
      expect(await container.read(landingProvider.notifier).hasPersistedSession(), isFalse);

      storage.store[StorageKeys.accessToken] = 'token';
      expect(await container.read(landingProvider.notifier).hasPersistedSession(), isTrue);
    });

    test('cerrar sesión apaga la demo sin más', () async {
      final container = buildContainer();
      await container.read(landingProvider.notifier).enterDemoMode();

      await container.read(authSessionControllerProvider).clear();

      expect(container.read(demoModeProvider), isFalse);
      expect(container.read(jwtClaimsProvider), isNull);
    });

    test('clearError consume la señal de bloqueo', () async {
      storage.store[StorageKeys.accessToken] = 'token';
      final container = buildContainer();
      await container.read(landingProvider.notifier).enterDemoMode();

      container.read(landingProvider.notifier).clearError();

      expect(container.read(landingProvider).demoBlockedByPersistedSession, isFalse);
    });
  });
}

final class _UntouchableAuthRepository implements AuthRepository {
  final calls = <String>[];
  final logoutIdTokens = <String>[];

  @override
  Future<TokenResponse> login({final List<String> scopes = authDefaultScopes, final String? loginHint, final Map<String, String> extraParameters = const {}}) async {
    calls.add('login');
    throw StateError('la demo no debe abrir Cl@ve');
  }

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) async {
    calls.add('refreshToken');
    throw StateError('la demo no debe renovar');
  }

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async => calls.add('revokeOfflineSession');

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) async {
    calls.add('logout');
    logoutIdTokens.add(idToken);
  }
}

final class _UntouchableBiometrics implements BiometricAuthenticator {
  @override
  Future<bool> canAuthenticateWithBiometrics() async => false;

  @override
  Future<bool> authenticateForSessionUnlock({required final String localizedReason, final String? title, final String? cancelLabel}) async => throw StateError('la demo no pide huella');
}

final class _FakeAppStorage implements AppStorage {
  final values = <String, Object>{};

  @override
  T? read<T>(final String key) => values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async => values.remove(key) != null;

  @override
  Future<bool> clear() async {
    values.clear();
    return true;
  }
}

final class _FakeSecureStorage implements SecureStorage {
  final store = <String, String>{};

  @override
  Future<String?> read(final String key) async => store[key];

  @override
  Future<void> write(final String key, final String value) async => store[key] = value;

  @override
  Future<void> delete(final String key) async => store.remove(key);

  @override
  Future<void> clear() async => store.clear();
}
