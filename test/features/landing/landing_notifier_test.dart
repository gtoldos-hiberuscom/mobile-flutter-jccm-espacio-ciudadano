import 'dart:convert';

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
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
  }) {
    final container = ProviderContainer(
      overrides: [
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

  group('LandingNotifier.tryRestoreSession', () {
    test('REGRESSION: con el acceso rápido desactivado no se restaura, aunque quede token guardado', () async {
      // Revocar en Android exige autenticar para borrar, y el ciudadano puede
      // cancelarlo: entonces la entrada sigue en el dispositivo. Sin este gate
      // el acceso rápido seguiría funcionando pese a figurar como desactivado.
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
  Future<TokenResponse> login({final List<String> scopes = authDefaultScopes, final String? loginHint, final bool ephemeralSession = true}) => Completer<TokenResponse>().future;

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri, final bool ephemeralSession = true}) => throw UnimplementedError();
}

final class _ImmediateAuthRepository implements AuthRepository {
  final List<String> revokedTokens = [];

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    revokedTokens.add(refreshToken);
  }

  @override
  Future<TokenResponse> login({final List<String> scopes = authDefaultScopes, final String? loginHint, final bool ephemeralSession = true}) async => TokenResponse(
    'not-a-real-jwt',
    'refresh',
    DateTime.now().add(const Duration(minutes: 5)),
    null,
    null,
    null,
    null,
  );

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri, final bool ephemeralSession = true}) => throw UnimplementedError();
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

final class _FakeSecureStorage implements SecureStorage {
  final Map<String, String> store = {};

  @override
  Future<String?> read(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async => store[key];

  @override
  Future<void> write(final String key, final String value, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async => store[key] = value;

  @override
  Future<void> delete(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard}) async => store.remove(key);

  @override
  Future<void> clearBiometric() async => store.remove(StorageKeys.refreshToken);

  @override
  Future<void> clear({final bool includeBiometric = true}) async => store.clear();
}
