import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
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
    'SSO_STEP_UP_PARAMS': '',
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

  // La elevación de nivel necesita justo la reautenticación que sostienen
  // `prompt` y `max_age`, así que un parámetro de elevación no debe poder
  // apagarla. Es el fallo que nadie vería: el login seguiría funcionando y
  // Cl@ve dejaría de desafiar.
  test('los parámetros de elevación NO pueden pisar prompt ni max_age', () async {
    mockChannelThrowing('authorize_and_exchange_code_failed');

    await expectLater(
      repository.login(
        extraParameters: const {
          'acr_values': 'substantial',
          // Los dos intentos de sabotaje, deliberados:
          'max_age': '86400',
          'prompt': 'none',
        },
      ),
      throwsA(isA<AuthException>()),
    );

    expect(capturedArguments?['promptValues'], <String>['login']);
    final additional = capturedArguments!['additionalParameters']! as Map<Object?, Object?>;
    expect(additional['max_age'], '0');
    expect(additional['acr_values'], 'substantial');
    // El `prompt` se descarta de la entrada, no solo se fusiona por debajo:
    // viaja además en `promptValues`, y duplicarlo en la URL no tiene un
    // ganador definido.
    expect(additional.containsKey('prompt'), isFalse);
  });

  test('login and logout ask for the SFSafariViewController agent', () async {
    // De ese agente depende el SSO con los portales de JCCM en iOS: guarda en
    // un almacén propio de la app, compartido con las pestañas que la app abre
    // con `LaunchMode.inAppBrowserView`. Con el agente efímero ese almacén se
    // destruye y los portales vuelven a abrir sin identificar, sin que nada
    // falle a la vista. Android ignora el argumento.
    mockChannelThrowing('authorize_and_exchange_code_failed');

    await expectLater(repository.login(), throwsA(isA<AuthException>()));
    expect(capturedArguments?['externalUserAgent'], ExternalUserAgent.sfSafariViewController.index);

    await expectLater(repository.logout(idToken: 'fake-id-token'), throwsA(isA<AuthException>()));
    expect(capturedArguments?['externalUserAgent'], ExternalUserAgent.sfSafariViewController.index);
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
