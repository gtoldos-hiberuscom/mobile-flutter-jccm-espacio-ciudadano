import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';

/// Comprueba, sobre el MethodChannel real, qué parámetros salen de verdad
/// hacia AppAuth y cómo se mapean sus errores de plataforma.
///
/// El test del `prompt` es el que cubre el bug de #282296: el valor exacto
/// decide si Cerbero propaga `ForceAuthn` a Cl@ve, y ningún fallo visible
/// avisaría de haberlo roto.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('crossingthestreams.io/flutter_appauth');

  const config = AppConfig.fromMap(<String, Object?>{
    'APP_FLAVOR': 'test',
    'APP_NAME': 'test',
    'BASE_URL': 'https://example.invalid',
    'TIMEOUT': '30',
    'DEBUG_MODE': 'false',
    'SSO_CLIENT_ID': 'test-client',
    'SSO_REDIRECT_URI': 'es.jccm.test://auth/callback',
    'SSO_REALM': 'test-realm',
    'SSO_BASE_URL': 'https://sso.example.invalid/auth',
    'SSO_OFFLINE_ACCESS': 'false',
  });

  late AuthRepositoryImpl repository;
  Map<Object?, Object?>? capturedArguments;

  setUp(() {
    repository = AuthRepositoryImpl(config: config);
    capturedArguments = null;
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  void mockChannelThrowing(final String errorCode) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (final call) async {
      capturedArguments = call.arguments as Map<Object?, Object?>;
      throw PlatformException(
        code: errorCode,
        message: 'mocked platform failure',
        // A non-null string map is required for the platform interface to
        // wrap the error as FlutterAppAuthPlatformException (it rethrows the
        // raw PlatformException when details are missing).
        details: <String, String>{'legacy_error_details': ''},
      );
    });
  }

  test('login sends prompt=login ALONE, or Cerbero drops ForceAuthn', () async {
    // #282296: la extensión de Cerbero compara el parámetro `prompt` entero
    // contra "login". Comprobado en PRE el 18/09/2026 leyendo la SAMLRequest
    // que el broker manda a Cl@ve:
    //   prompt=login                 → ForceAuthn="true"
    //   prompt=login select_account  → ForceAuthn="false"
    // Añadir cualquier otro valor aquí apaga la reautenticación en Cl@ve sin
    // que nada falle a la vista. Si Cerbero llega a soportar la combinación
    // del estándar, este test es el sitio donde consta el porqué.
    mockChannelThrowing('authorize_and_exchange_code_failed');

    await expectLater(repository.login(), throwsA(isA<AuthException>()));

    expect(capturedArguments?['promptValues'], <String>['login']);
    expect(capturedArguments?['additionalParameters'], containsPair('max_age', '0'));
  });

  test('other platform error codes keep the existing unexpected mapping', () async {
    mockChannelThrowing('authorize_and_exchange_code_failed');

    await expectLater(
      repository.login(),
      throwsA(
        isA<AuthException>().having(
          (final e) => e.reason,
          'reason',
          AuthFailureReason.unexpected,
        ),
      ),
    );
  });
}
