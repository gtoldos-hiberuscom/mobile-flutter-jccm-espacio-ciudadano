import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/consent_revocation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

void main() {
  late _RecordingAuthRepository authRepository;
  late _FakeSecureStorage storage;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        secureStorageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  void startSession(final ProviderContainer container) {
    container
        .read(authSessionControllerProvider)
        .startInMemory(
          TokenResponse(
            'access',
            'refresh',
            DateTime.now().add(const Duration(minutes: 5)),
            'id-token',
            null,
            null,
            null,
          ),
        );
  }

  setUp(() {
    authRepository = _RecordingAuthRepository();
    storage = _FakeSecureStorage();
  });

  test('cierra la sesión federada y local, y avisa una sola vez', () async {
    final container = buildContainer();
    startSession(container);

    await container.read(consentRevocationProvider.notifier).signalRevoked();

    expect(authRepository.logoutIdTokens, ['id-token']);
    expect(container.read(tokenResponseProvider), isNull);
    expect(storage.deleted, containsAll([StorageKeys.accessToken, StorageKeys.refreshToken, StorageKeys.idToken]));
    expect(container.read(consentRevocationProvider), isTrue);
  });

  test('una sesión nueva rearma la detección: la segunda revocación también cierra', () async {
    final container = buildContainer();
    // El provider observa el estado, así que hay que tenerlo vivo desde el
    // principio para que su `listen` esté montado.
    expect(container.read(consentRevocationProvider), isFalse);
    startSession(container);

    await container.read(consentRevocationProvider.notifier).signalRevoked();
    expect(container.read(consentRevocationProvider), isTrue);
    expect(authRepository.logoutIdTokens, hasLength(1));

    // Vuelve a entrar en el mismo proceso: sin rearmar, el early-return daba
    // la segunda revocación por atendida y el ciudadano se quedaba dentro.
    startSession(container);
    await container.pump();
    expect(container.read(consentRevocationProvider), isFalse);

    await container.read(consentRevocationProvider.notifier).signalRevoked();

    expect(container.read(consentRevocationProvider), isTrue);
    expect(authRepository.logoutIdTokens, hasLength(2));
  });

  test('es idempotente: cuatro barridos en paralelo cierran la sesión una vez', () async {
    final container = buildContainer();
    startSession(container);

    final notifier = container.read(consentRevocationProvider.notifier);
    await Future.wait([
      notifier.signalRevoked(),
      notifier.signalRevoked(),
      notifier.signalRevoked(),
      notifier.signalRevoked(),
    ]);

    expect(authRepository.logoutIdTokens, hasLength(1));
  });

  test('un logout federado que falla no impide limpiar la sesión local', () async {
    authRepository.logoutError = Exception('sin red');
    final container = buildContainer();
    startSession(container);

    await container.read(consentRevocationProvider.notifier).signalRevoked();

    expect(container.read(tokenResponseProvider), isNull);
    expect(container.read(consentRevocationProvider), isTrue);
  });

  test('sin idToken no intenta el logout federado', () async {
    final container = buildContainer();
    container
        .read(authSessionControllerProvider)
        .startInMemory(
          TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), null, null, null, null),
        );

    await container.read(consentRevocationProvider.notifier).signalRevoked();

    expect(authRepository.logoutIdTokens, isEmpty);
    expect(container.read(consentRevocationProvider), isTrue);
  });
}

final class _RecordingAuthRepository implements AuthRepository {
  final List<String> logoutIdTokens = [];
  Exception? logoutError;

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri, final bool ephemeralSession = true}) async {
    logoutIdTokens.add(idToken);
    final pending = logoutError;
    if (pending != null) {
      throw pending;
    }
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeSecureStorage implements SecureStorage {
  final Map<String, String> values = {};
  final List<String> deleted = [];

  @override
  Future<String?> read(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async => values[key];

  @override
  Future<void> write(final String key, final String value, {final SecureStorageProtection protection = SecureStorageProtection.standard, final BiometricPromptCopy? prompt}) async {
    values[key] = value;
  }

  @override
  Future<void> delete(final String key, {final SecureStorageProtection protection = SecureStorageProtection.standard}) async {
    deleted.add(key);
    final _ = values.remove(key);
  }

  @override
  Future<void> clearBiometric() async {
    // El almacén protegido se vacía entero, no clave a clave, para no pedir
    // huella al cerrar sesión; el token de larga vida cae con él.
    deleted.add(StorageKeys.refreshToken);
    final _ = values.remove(StorageKeys.refreshToken);
  }


  @override
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
}
