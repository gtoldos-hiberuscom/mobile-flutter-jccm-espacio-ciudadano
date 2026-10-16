import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_mode_provider.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/demo_auth_repository.dart';

/// El modo demo se deriva de los claims de la sesión: estos tests comprueban
/// que las dos piezas que cambian de implementación —transporte y repositorio
/// de autenticación— lo hacen al entrar y vuelven a la real al cerrar sesión,
/// y que un login real no las toca.
void main() {
  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(const AppConfig.fromMap({'BASE_URL': 'https://gateway.invalid', 'TIMEOUT': '30', 'DEBUG_MODE': 'false'})),
        appStorageProvider.overrideWithValue(_FakeAppStorage()),
        secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('sin sesión: transporte real y AuthRepositoryImpl', () {
    final container = buildContainer();

    expect(container.read(demoModeProvider), isFalse);
    expect(container.read(dioProvider).httpClientAdapter, isNot(isA<DemoHttpClientAdapter>()));
    expect(container.read(authRepositoryProvider), isA<AuthRepositoryImpl>());
  });

  test('un login real no cambia nada', () {
    final container = buildContainer();
    final realAdapter = container.read(dioProvider).httpClientAdapter;

    container
        .read(authSessionControllerProvider)
        .startInMemory(
          TokenResponse('access', 'refresh', DateTime.now().add(const Duration(minutes: 5)), null, null, null, null),
          claims: const JwtClaims(exp: 9999999999, iat: 0, iss: 'https://cerbero.invalid/realms/x', aud: ['app'], sub: 'sub-1', subAlt: 'PER1'),
        );

    expect(container.read(demoModeProvider), isFalse);
    expect(container.read(dioProvider).httpClientAdapter, same(realAdapter), reason: 'el Dio no debe reconstruirse en un login real');
    expect(container.read(authRepositoryProvider), isA<AuthRepositoryImpl>());
  });

  test('al entrar en la demo el transporte y el repositorio pasan a los ficticios; al cerrar sesión vuelven', () async {
    final container = buildContainer();

    container.read(authSessionControllerProvider).startInMemory(DemoSession.tokenResponse(), claims: DemoSession.claims());

    expect(container.read(demoModeProvider), isTrue);
    expect(container.read(dioProvider).httpClientAdapter, isA<DemoHttpClientAdapter>());
    expect(container.read(authRepositoryProvider), isA<DemoAuthRepository>());

    await container.read(authSessionControllerProvider).clear();

    expect(container.read(demoModeProvider), isFalse);
    expect(container.read(dioProvider).httpClientAdapter, isNot(isA<DemoHttpClientAdapter>()));
    expect(container.read(authRepositoryProvider), isA<AuthRepositoryImpl>());
  });

  test('una sesión demo reanudada del almacén (sin claims explícitos) también activa la demo', () async {
    // Tras un reinicio con acceso rápido, `hydrateFromStorage` decodifica el
    // access token guardado: el `iss` del JWT demo basta para derivar el modo.
    final storage = _FakeSecureStorage()..store['access_token'] = DemoSession.buildAccessToken();
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(const AppConfig.fromMap({'BASE_URL': 'https://gateway.invalid', 'TIMEOUT': '30', 'DEBUG_MODE': 'false'})),
        appStorageProvider.overrideWithValue(_FakeAppStorage()),
        secureStorageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);

    await container.read(authSessionControllerProvider).hydrateFromStorage();

    expect(container.read(demoModeProvider), isTrue);
    expect(container.read(dioProvider).httpClientAdapter, isA<DemoHttpClientAdapter>());
  });
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
