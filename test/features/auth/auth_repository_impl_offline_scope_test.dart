import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';

/// `offline_access` is what turns the issued refresh token into an offline
/// token, and it is per-environment: PRE has the scope assigned to the client,
/// UAT rejects the whole authorization request with `invalid_scope`, and the
/// client does not exist yet in production. These tests pin that login and
/// refresh both honour `SSO_OFFLINE_ACCESS` — asking for it where it is not
/// assigned breaks authentication outright.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('crossingthestreams.io/flutter_appauth');

  AppConfig configWithOfflineAccess({required final bool enabled}) => AppConfig.fromMap(<String, Object?>{
    'APP_FLAVOR': 'test',
    'APP_NAME': 'test',
    'BASE_URL': 'https://example.invalid',
    'TIMEOUT': '30',
    'DEBUG_MODE': 'false',
    'SSO_CLIENT_ID': 'test-client',
    'SSO_REDIRECT_URI': 'es.jccm.test://auth/callback',
    'SSO_REALM': 'test-realm',
    'SSO_BASE_URL': 'https://sso.example.invalid/auth',
    'SSO_OFFLINE_ACCESS': enabled.toString(),
  });

  Map<Object?, Object?>? capturedArguments;

  setUp(() {
    capturedArguments = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (final call) async {
      capturedArguments = call.arguments as Map<Object?, Object?>;
      throw PlatformException(
        code: 'authorize_and_exchange_code_failed',
        message: 'mocked platform failure',
        details: <String, String>{'legacy_error_details': ''},
      );
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('login requests offline_access where the client has it assigned', () async {
    final repository = AuthRepositoryImpl(config: configWithOfflineAccess(enabled: true));

    await expectLater(repository.login(), throwsA(isA<AuthException>()));

    expect(capturedArguments?['scopes'], <String>['openid', 'offline_access']);
  });

  test('login never requests offline_access where the client lacks it', () async {
    final repository = AuthRepositoryImpl(config: configWithOfflineAccess(enabled: false));

    await expectLater(repository.login(), throwsA(isA<AuthException>()));

    expect(capturedArguments?['scopes'], <String>['openid']);
  });

  test('refresh asks for the same scope as login, so the grant never narrows', () async {
    final repository = AuthRepositoryImpl(config: configWithOfflineAccess(enabled: true));

    await expectLater(
      repository.refreshToken(refreshToken: 'stored-refresh-token'),
      throwsA(isA<AuthException>()),
    );

    expect(capturedArguments?['scopes'], <String>['openid', 'offline_access']);
  });

  test('an explicit offline_access scope is not duplicated', () async {
    final repository = AuthRepositoryImpl(config: configWithOfflineAccess(enabled: true));

    await expectLater(
      repository.login(scopes: const ['openid', 'offline_access']),
      throwsA(isA<AuthException>()),
    );

    expect(capturedArguments?['scopes'], <String>['openid', 'offline_access']);
  });
}
