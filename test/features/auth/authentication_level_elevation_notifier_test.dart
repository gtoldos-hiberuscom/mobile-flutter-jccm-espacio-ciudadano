import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
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
/// de navegador, y nada más. Se comprueba sobre el almacén, no espiando
/// llamadas: lo que importa es que la sesión no quede persistida.
void main() {
  late FakeSecureStorage storage;
  late FakeAppStorage appStorage;

  setUp(() {
    storage = FakeSecureStorage();
    appStorage = FakeAppStorage();
  });

  ProviderContainer buildContainer(final TokenResponse elevated) {
    final container = ProviderContainer(
      retry: (final _, final _) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository(token: elevated)),
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

  test('otra identidad: se cierra la sesión y no se adopta el token nuevo', () async {
    final container = buildContainer(_token(_claimsToken(level: 'high', document: '00000000T')));
    startLowLevelSession(container);

    await container.read(elevationProvider.notifier).elevate(minimum: AuthenticationLevel.substantial);

    expect(container.read(elevationProvider).outcome, ElevationOutcome.identityChanged);
    expect(container.read(tokenResponseProvider), isNull);
  });
}

String _claimsToken({required final String level, final String document = '99999999R'}) {
  final payload = jsonEncode({
    'sub': 'subject',
    'sub_alt': 'PER1',
    'idAgente': 'PER1',
    'PersonIdentifier': document,
    'authNLevel': level,
  });
  return 'header.${base64Url.encode(utf8.encode(payload))}.signature';
}

TokenResponse _token(final String accessToken) => TokenResponse(
  accessToken,
  'refresh',
  DateTime(2030),
  'id-token',
  'Bearer',
  const ['openid'],
  const <String, dynamic>{},
);

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.token});

  final TokenResponse token;

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) async => token;

  @override
  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) => throw UnimplementedError();

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) async {}
}
