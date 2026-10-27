import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_elevation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

import 'auth_session_controller_test.dart' show FakeAppStorage, FakeSecureStorage;

/// Regresión del 29/09: **tras elevar el nivel, navegar echaba al landing
/// público.**
///
/// La elevación persistía la sesión por su cuenta, así que
/// `hasPersistedSession()` pasaba a ser `true` antes de que el gate de
/// consentimiento hubiera confirmado nada. En la siguiente navegación un
/// `ConsentRequired` tomaba la rama **destructiva** de `SessionGuard`
/// —`clear()` + rebote al landing— en lugar de la recuperable, que lleva al
/// gate legal.
///
/// Persistir es decisión del guard (`_persistSessionNowConsentIsOnRecord`), y
/// la elevación debe hacer lo mismo que `LandingNotifier.login`: memoria, pista
/// de navegador, y nada más — salvo que la sesión ya estuviera guardada, en
/// cuyo caso se reescribe con la elevada, como hace el refresco. Se comprueba sobre el almacén, no espiando
/// llamadas: lo que importa es que la sesión no quede persistida.
void main() {
  late FakeSecureStorage storage;
  late FakeAppStorage appStorage;

  setUp(() {
    storage = FakeSecureStorage();
    appStorage = FakeAppStorage();
  });

  late _FakeAuthRepository repository;

  ProviderContainer buildContainer(final TokenResponse elevated) {
    repository = _FakeAuthRepository(token: elevated);
    final container = ProviderContainer(
      retry: (final _, final _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        secureStorageProvider.overrideWithValue(storage),
        appStorageProvider.overrideWithValue(appStorage),
        // El caso de uso lee los parámetros de elevación de la configuración.
        appConfigProvider.overrideWithValue(const AppConfig.fromMap({'SSO_STEP_UP_PARAMS': ''})),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Sesión de partida con nivel bajo, adoptada como lo hace el login.
  void startLowLevelSession(final ProviderContainer container) {
    container.read(authSessionControllerProvider).startInMemory(
      _token(_claimsToken(level: 'low')),
      claims: JwtClaims.fromMap(JwtDecoder.decodePayload(_claimsToken(level: 'low'))),
    );
  }

  test('tras elevar, la sesión NO queda persistida', () async {
    final container = buildContainer(_token(_claimsToken(level: 'substantial')));
    startLowLevelSession(container);

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    expect(container.read(elevationProvider).outcome, ElevationOutcome.succeeded);
    // El acceso token en el almacén es lo que `hasPersistedSession()` mira, y
    // es lo que llevaba al guard a borrar la sesión y rebotar al landing.
    expect(await container.read(authSessionControllerProvider).hasPersistedSession(), isFalse);
    expect(storage.store.containsKey(StorageKeys.accessToken), isFalse);
  });

  // JCCMEC-278: con acceso rápido la sesión ya estaba en el almacén y el guard
  // no la reescribe; sin esto, al reabrir la app se hidrataba el token de
  // nivel bajo y el aviso volvía a salir.
  test('con la sesión ya persistida (acceso rápido), se guarda la elevada', () async {
    appStorage.values['${StorageKeys.biometricQuickAccessEnabledPrefix}PER1'] = true;
    storage.store[StorageKeys.accessToken] = 'access-token-de-nivel-bajo';
    storage.store[StorageKeys.refreshToken] = 'refresh-de-nivel-bajo';
    final elevated = _token(_claimsToken(level: 'substantial'), idToken: 'id-token-elevado');
    final container = buildContainer(elevated);
    startLowLevelSession(container);

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    expect(container.read(elevationProvider).outcome, ElevationOutcome.succeeded);
    expect(storage.store[StorageKeys.accessToken], elevated.accessToken);
    expect(storage.store[StorageKeys.refreshToken], elevated.refreshToken);
  });

  test('el nivel nuevo queda en memoria y la lectura lo refleja', () async {
    final container = buildContainer(_token(_claimsToken(level: 'substantial')));
    startLowLevelSession(container);

    expect(container.read(authenticationLevelProvider).meets(AuthenticationLevel.substantial), isFalse);

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    // Esto es lo que rehace el listado sin invalidar nada a mano.
    expect(container.read(authenticationLevelProvider).meets(AuthenticationLevel.substantial), isTrue);
  });

  test('vuelve insuficiente: se adopta la sesión pero tampoco se persiste', () async {
    final container = buildContainer(_token(_claimsToken(level: 'low')));
    startLowLevelSession(container);

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    expect(container.read(elevationProvider).outcome, ElevationOutcome.stillInsufficient);
    expect(await container.read(authSessionControllerProvider).hasPersistedSession(), isFalse);
  });

  // JCCMEC-278: como en la web, la sesión pasa a ser de quien se identificó.
  test('otra identidad: la sesión pasa a ser suya, como un login nuevo', () async {
    final switched = _token(_claimsToken(level: 'high', document: '00000000T'));
    final container = buildContainer(switched);
    startLowLevelSession(container);

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    expect(container.read(elevationProvider).outcome, ElevationOutcome.identitySwitched);
    expect(container.read(tokenResponseProvider)?.accessToken, switched.accessToken);
    expect(container.read(authenticationLevelProvider).meets(AuthenticationLevel.substantial), isTrue);
    // La sesión offline de la persona anterior se revoca: es la suya.
    expect(repository.revokedRefreshTokens, ['refresh']);
  });

  test('otra identidad con acceso rápido: no queda nada de la sesión anterior en el almacén', () async {
    appStorage.values['${StorageKeys.biometricQuickAccessEnabledPrefix}PER1'] = true;
    storage.store[StorageKeys.accessToken] = 'access-token-anterior';
    storage.store[StorageKeys.refreshToken] = 'refresh-anterior';
    storage.store[StorageKeys.sessionExpiresAt] = DateTime(2030).toIso8601String();
    final container = buildContainer(_token(_claimsToken(level: 'high', document: '00000000T', idAgente: 'PER2')));
    startLowLevelSession(container);

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    expect(container.read(elevationProvider).outcome, ElevationOutcome.identitySwitched);
    expect(storage.store.containsKey(StorageKeys.accessToken), isFalse);
    expect(storage.store.containsKey(StorageKeys.refreshToken), isFalse);
    expect(storage.store.containsKey(StorageKeys.sessionExpiresAt), isFalse);
  });

  // Regresión del 14/10: la cancelación dejaba el estado como si no hubiera
  // pasado nada, y la pantalla, al montarse de nuevo, relanzaba Cl@ve en bucle.
  test('cerrar Cl@ve sin identificarse es un desenlace propio, y no toca la sesión', () async {
    final container = buildContainer(_token(_claimsToken(level: 'substantial')));
    startLowLevelSession(container);
    repository.loginError = const AuthException.cancelled();

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    expect(container.read(elevationProvider).outcome, ElevationOutcome.cancelled);
    expect(container.read(elevationProvider).isElevating, isFalse);
    expect(container.read(authenticationLevelProvider).meets(AuthenticationLevel.substantial), isFalse);
  });

  // Desde JCCMEC-224/228 el login guarda el `id_token` para cerrar después la
  // sesión que abre en el navegador. La elevación abre una nueva, así que la
  // pista tiene que pasar a ser la suya.
  group('pista de cierre de la sesión de navegador', () {
    test('tras elevar, la pista es el id_token nuevo', () async {
      storage.store[StorageKeys.idToken] = 'id-token-previo';
      final container = buildContainer(_token(_claimsToken(level: 'substantial'), idToken: 'id-token-elevado'));
      startLowLevelSession(container);

      await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

      expect(storage.store[StorageKeys.idToken], 'id-token-elevado');
    });

    test('vuelve insuficiente: la pista también es la nueva', () async {
      storage.store[StorageKeys.idToken] = 'id-token-previo';
      final container = buildContainer(_token(_claimsToken(level: 'low'), idToken: 'id-token-elevado'));
      startLowLevelSession(container);

      await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

      expect(container.read(elevationProvider).outcome, ElevationOutcome.stillInsufficient);
      expect(storage.store[StorageKeys.idToken], 'id-token-elevado');
    });

    test('no cierra la sesión del navegador antes de elevar', () async {
      // Es el mismo ciudadano: cerrársela es lo que lo echaba al landing si
      // después cancelaba (29/09). `prompt=login` ya fuerza el desafío.
      storage.store[StorageKeys.idToken] = 'id-token-previo';
      final container = buildContainer(_token(_claimsToken(level: 'substantial'), idToken: 'id-token-elevado'));
      startLowLevelSession(container);

      await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

      expect(repository.logoutCalls, isEmpty);
    });

    test('otra identidad: la pista pasa a ser la de la persona nueva', () async {
      storage.store[StorageKeys.idToken] = 'id-token-previo';
      final container = buildContainer(_token(_claimsToken(level: 'high', document: '00000000T'), idToken: 'id-token-de-otra-persona'));
      startLowLevelSession(container);

      await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

      expect(container.read(elevationProvider).outcome, ElevationOutcome.identitySwitched);
      expect(storage.store[StorageKeys.idToken], 'id-token-de-otra-persona');
    });
  });
}

String _claimsToken({required final String level, final String document = '99999999R', final String idAgente = 'PER1'}) {
  final payload = jsonEncode({
    'sub': 'subject',
    'sub_alt': idAgente,
    'idAgente': idAgente,
    'PersonIdentifier': document,
    'authNLevel': level,
  });
  return 'header.${base64Url.encode(utf8.encode(payload))}.signature';
}

TokenResponse _token(final String accessToken, {final String idToken = 'id-token'}) => TokenResponse(
  accessToken,
  'refresh',
  DateTime(2030),
  idToken,
  'Bearer',
  const ['openid'],
  const <String, dynamic>{},
);

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.token});

  final TokenResponse token;

  /// Si está, `login` falla con él (p. ej. el ciudadano cierra Cl@ve).
  Object? loginError;

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) async {
    if (loginError case final error?) {
      // ignore: only_throw_errors — el error a simular lo elige el test.
      throw error;
    }
    return token;
  }

  @override
  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) => throw UnimplementedError();

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    revokedRefreshTokens.add(refreshToken);
  }

  final List<String> revokedRefreshTokens = [];

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) async {
    logoutCalls.add(idToken);
  }

  final List<String> logoutCalls = [];
}
