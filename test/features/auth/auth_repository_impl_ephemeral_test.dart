import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';

/// Exercises the real MethodChannel serialization path of the vendored
/// flutter_appauth fork contract:
///
/// 1. `externalUserAgent` travels as the enum index (1 = ephemeral, 0 = not).
/// 2. The fork's `ephemeral_browsing_unavailable` platform error is mapped to
///    [AuthException.ephemeralUnavailable] by the repository.
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

  test('login serialises the ephemeral external user agent as index 1', () async {
    mockChannelThrowing('ephemeral_browsing_unavailable');

    await expectLater(
      repository.login(),
      throwsA(
        isA<AuthException>().having(
          (final e) => e.reason,
          'reason',
          AuthFailureReason.ephemeralUnavailable,
        ),
      ),
    );
    expect(capturedArguments?['externalUserAgent'], 1);
  });

  test('login with ephemeralSession=false serialises index 0', () async {
    mockChannelThrowing('authorize_and_exchange_code_failed');

    await expectLater(
      repository.login(ephemeralSession: false),
      throwsA(isA<AuthException>()),
    );
    expect(capturedArguments?['externalUserAgent'], 0);
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

  test('logout maps ephemeral_browsing_unavailable and serialises index 1', () async {
    mockChannelThrowing('ephemeral_browsing_unavailable');

    await expectLater(
      repository.logout(idToken: 'fake-id-token'),
      throwsA(
        isA<AuthException>().having(
          (final e) => e.reason,
          'reason',
          AuthFailureReason.ephemeralUnavailable,
        ),
      ),
    );
    expect(capturedArguments?['externalUserAgent'], 1);
  });
}
