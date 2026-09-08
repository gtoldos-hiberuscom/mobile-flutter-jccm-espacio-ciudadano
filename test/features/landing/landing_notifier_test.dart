import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';

void main() {
  ProviderContainer buildContainer(final AuthRepository repository) {
    final container = ProviderContainer(
      overrides: [
        loginUseCaseProvider.overrideWithValue(LoginUseCase(repository)),
        authRepositoryProvider.overrideWithValue(repository),
        secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
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
  @override
  Future<TokenResponse> login({final List<String> scopes = authDefaultScopes, final String? loginHint, final bool ephemeralSession = true}) => Completer<TokenResponse>().future;

  @override
  Future<TokenResponse> refreshToken({required final String refreshToken, final List<String> scopes = authDefaultScopes}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri, final bool ephemeralSession = true}) => throw UnimplementedError();
}

final class _ImmediateAuthRepository implements AuthRepository {
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

final class _FakeSecureStorage implements SecureStorage {
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
