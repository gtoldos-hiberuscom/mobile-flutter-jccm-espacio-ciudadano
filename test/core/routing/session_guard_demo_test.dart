import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/routing/session_guard.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_repository_provider.dart';

final _guardProvider = Provider<SessionGuard>(SessionGuard.new);

/// El guard de sesión con la demo **de verdad**: sin dobles de consentimiento.
/// `consentRepositoryProvider` es el `ConsentRepositoryImpl` real, que habla
/// con el `dioProvider` demo y, por tanto, con el backend ficticio. Es la
/// prueba de que el revisor pasa por el mismo gate legal que un ciudadano y de
/// que un reinicio con acceso rápido no le cierra la sesión.
void main() {
  late _FakeSecureStorage storage;
  late _FakeAppStorage appStorage;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        appConfigProvider.overrideWithValue(const AppConfig.fromMap({'BASE_URL': 'https://gateway.invalid', 'TIMEOUT': '30', 'DEBUG_MODE': 'false', 'DEMO_MODE_ENABLED': 'true'})),
        appStorageProvider.overrideWithValue(appStorage),
        secureStorageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    storage = _FakeSecureStorage();
    appStorage = _FakeAppStorage();
  });

  test('primera entrada: el gate legal real pide la cláusula obligatoria', () async {
    final container = buildContainer();
    container.read(authSessionControllerProvider).startInMemory(DemoSession.tokenResponse(), claims: DemoSession.claims());

    expect(await container.read(_guardProvider).redirectPath(Routes.home), Routes.legalPrivacy);
    // Las páginas del propio gate no se redirigen a sí mismas.
    expect(await container.read(_guardProvider).redirectPath(Routes.legalPrivacy), isNull);
    expect(await container.read(_guardProvider).redirectPath(Routes.consent), isNull);
    // La sesión demo no se persiste: nada en el almacén seguro.
    expect(storage.store, isEmpty);
  });

  test('tras aceptar por el repositorio real, el guard deja pasar; una cláusula opcional pendiente desvía a preferencias', () async {
    final container = buildContainer();
    container.read(authSessionControllerProvider).startInMemory(DemoSession.tokenResponse(), claims: DemoSession.claims());
    final repository = container.read(consentRepositoryProvider);

    final clauses = await repository.fetchClauses(idAgente: DemoSession.idAgente);
    expect(clauses.map((final clause) => clause.id), contains(requiredConsentClauseId));
    await repository.markConsentAccepted(
      idAgente: DemoSession.idAgente,
      clauses: [for (final clause in clauses) clause.copyWith(isSelected: clause.id == requiredConsentClauseId, isPending: false)],
    );

    expect(await container.read(_guardProvider).redirectPath(Routes.home), isNull);
    expect(await container.read(_guardProvider).redirectPath(Routes.gestionNotificaciones), isNull);

    final optionalRedirect = await container.read(_guardProvider).redirectPath(Routes.myDataSocialWelfareFamily);
    expect(optionalRedirect, isNotNull);
    final redirectUri = Uri.parse(optionalRedirect!);
    expect(redirectUri.path, Routes.consent);
    expect(redirectUri.queryParameters['mode'], 'preferences');
    expect(redirectUri.queryParameters['returnTo'], Routes.myDataSocialWelfareFamily);
  });

  test('reinicio con acceso rápido: la sesión demo guardada y el consentimiento en caché no rebotan', () async {
    // Lo que `ConsentRepositoryImpl` deja en el almacén tras una aceptación
    // confirmada, y lo que `persist()` deja en el almacén seguro con el acceso
    // rápido activado. El backend demo renace al arrancar: si no leyera la
    // semilla, el guard vería «sesión guardada + consentimiento no aceptado»
    // y borraría la sesión.
    appStorage.values['${StorageKeys.consentAcceptedPrefix}${DemoSession.idAgente}'] = true;
    appStorage.values['${StorageKeys.consentAcceptedClausesPrefix}${DemoSession.idAgente}'] = <String>['$requiredConsentClauseId'];
    appStorage.values['${StorageKeys.biometricQuickAccessEnabledPrefix}${DemoSession.idAgente}'] = true;
    storage.store[StorageKeys.accessToken] = DemoSession.buildAccessToken();
    storage.store[StorageKeys.sessionExpiresAt] = DateTime.now().add(DemoSession.lifetime).toIso8601String();
    final container = buildContainer();

    await container.read(authSessionControllerProvider).hydrateFromStorage();

    expect(await container.read(_guardProvider).redirectPath(Routes.home), isNull);
    expect(storage.store[StorageKeys.accessToken], isNotNull, reason: 'la sesión guardada debe seguir ahí');
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
