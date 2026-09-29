import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/elevate_authentication_level_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';

/// Apartados 4 y 5 del requisito de citas hospitalarias.
///
/// El mecanismo de elevación es repetir el login, que ya fuerza el desafío de
/// Cl@ve. Lo que se fija aquí es el reparto de desenlaces y, sobre todo, que
/// una identidad distinta **no se adopta** aunque su nivel baste.
void main() {
  const minimum = AuthenticationLevel.substantial;

  late _FakeAuthRepository repository;
  late List<String> events;

  ElevateAuthenticationLevelUseCase buildUseCase() => ElevateAuthenticationLevelUseCase(
    login: LoginUseCase(repository),
    endStaleBrowserSession: () async => events.add('endStaleBrowserSession'),
    stepUpParameters: const {'acr_values': 'substantial'},
  );

  setUp(() {
    events = <String>[];
    repository = _FakeAuthRepository(onLogin: () => events.add('authorize'));
  });

  test('cierra la sesión de navegador ANTES de autorizar', () async {
    // Si no, Cerbero puede cortocircuitar sobre la identificación de nivel bajo
    // que sigue viva y devolver el mismo nivel.
    repository.tokenFor = _token(_claimsToken(document: '99999999R', level: 'substantial'));

    await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(events, ['endStaleBrowserSession', 'authorize']);
  });

  test('traslada los parámetros de elevación al login', () async {
    repository.tokenFor = _token(_claimsToken(document: '99999999R', level: 'substantial'));

    await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(repository.lastExtraParameters, const {'acr_values': 'substantial'});
  });

  test('nivel suficiente y misma persona: elevación correcta', () async {
    repository.tokenFor = _token(_claimsToken(document: '99999999R', level: 'substantial'));

    final result = await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(result, isA<ElevationSucceeded>());
    expect((result as ElevationSucceeded).reading.meets(minimum), isTrue);
  });

  // Desenlace esperado, no error: con Permanente sin reforzar se vuelve igual.
  test('se reidentifica pero sigue sin bastar: insuficiente, y la sesión nueva se entrega', () async {
    repository.tokenFor = _token(_claimsToken(document: '99999999R', level: 'low'));

    final result = await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(result, isA<ElevationInsufficient>());
    // Es del mismo ciudadano y más reciente que la anterior, así que se adopta:
    // quien llama la necesita para no quedarse con tokens de una sesión que ya
    // se cerró en el navegador.
    expect((result as ElevationInsufficient).tokenResponse, isNotNull);
  });

  // El caso del móvil compartido, y el P1 abierto del proyecto.
  test('otro documento: mismatch, y no se adopta aunque el nivel baste', () async {
    repository.tokenFor = _token(_claimsToken(document: '00000000T', level: 'high'));

    final result = await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(result, isA<ElevationIdentityMismatch>());
  });

  // Elevar cambia de proveedor de identidad y con él el `sub`, así que comparar
  // por `sub` daría «otra persona» en el caso normal.
  test('mismo documento con sub distinto NO es un cambio de identidad', () async {
    repository.tokenFor = _token(_claimsToken(document: '99999999R', level: 'substantial', subject: 'afirma-subject'));

    final result = await buildUseCase()(
      minimum: minimum,
      currentClaims: _claims(document: '99999999R', level: 'low', subject: 'seg-social-subject'),
    );

    expect(result, isA<ElevationSucceeded>());
  });

  test('cancelación: desenlace propio, sin ruido de error', () async {
    repository.error = const AuthException.cancelled();

    final result = await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(result, isA<ElevationCancelled>());
  });

  test('cualquier otro fallo: elevación fallida', () async {
    repository.error = AuthException.unexpected(cause: StateError('boom'));

    final result = await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(result, isA<ElevationFailed>());
  });

  test('sin aislamiento disponible reintenta y lo marca, como el login normal', () async {
    repository
      ..failFirstWith = const AuthException.ephemeralUnavailable()
      ..tokenFor = _token(_claimsToken(document: '99999999R', level: 'substantial'));

    final result = await buildUseCase()(minimum: minimum, currentClaims: _claims(document: '99999999R', level: 'low'));

    expect(result, isA<ElevationSucceeded>());
    expect((result as ElevationSucceeded).sessionIsolationDegraded, isTrue);
  });
}

JwtClaims _claims({required final String document, required final String level, final String subject = 'subject'}) => JwtClaims(
  exp: 0,
  iat: 0,
  iss: 'issuer',
  aud: const [],
  sub: subject,
  personIdentifier: document,
  authNLevelRaw: level,
);

/// Token JWT sin firmar cuyo payload es lo único que el caso de uso lee.
String _claimsToken({required final String document, required final String level, final String subject = 'subject'}) {
  final payload = jsonEncode({'sub': subject, 'PersonIdentifier': document, 'authNLevel': level});
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
  _FakeAuthRepository({required this.onLogin});

  final void Function() onLogin;

  TokenResponse? tokenFor;
  AuthException? error;

  /// Falla el primer intento con esto y deja pasar el segundo, para el
  /// reintento degradado por falta de aislamiento.
  AuthException? failFirstWith;

  Map<String, String>? lastExtraParameters;
  int loginCalls = 0;

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool isolateSession = true,
    final Map<String, String> extraParameters = const <String, String>{},
  }) async {
    loginCalls++;
    lastExtraParameters = extraParameters;
    onLogin();
    if (loginCalls == 1 && failFirstWith != null) {
      throw failFirstWith!;
    }
    final pendingError = error;
    if (pendingError != null) {
      throw pendingError;
    }
    return tokenFor!;
  }

  @override
  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) => throw UnimplementedError();

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) => throw UnimplementedError();

  @override
  Future<void> logout({required final String idToken, final String? postLogoutRedirectUri}) => throw UnimplementedError();
}
