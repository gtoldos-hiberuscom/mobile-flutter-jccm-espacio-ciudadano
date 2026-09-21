import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';

/// [AuthRepository] fake that counts login/logout calls and can be configured
/// to fail selectively per attempt.
///
/// El recuento importa: los dos casos de uso **no** reintentan. Un fallo se
/// devuelve como resultado sellado, nunca se enmascara con un segundo intento.
final class FakeAuthRepository implements AuthRepository {
  final List<String> revokedTokens = [];

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    revokedTokens.add(refreshToken);
  }

  /// Número de llamadas a login, en orden.
  int loginCalls = 0;

  /// Número de llamadas a logout, en orden.
  int logoutCalls = 0;

  /// Errors to throw for login attempts, consumed in order. A `null` entry
  /// (or an exhausted list) means the attempt succeeds.
  final List<Exception?> loginErrors = [];

  /// Same for logout attempts.
  final List<Exception?> logoutErrors = [];

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  }) async {
    loginCalls++;
    final error = loginCalls <= loginErrors.length ? loginErrors[loginCalls - 1] : null;
    if (error != null) {
      throw error;
    }
    return TokenResponse(
      'fake-access-token',
      'fake-refresh-token',
      DateTime.now().add(const Duration(minutes: 5)),
      null,
      null,
      null,
      null,
    );
  }

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {
    logoutCalls++;
    final error = logoutCalls <= logoutErrors.length ? logoutErrors[logoutCalls - 1] : null;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) => throw UnimplementedError();
}

void main() {
  late FakeAuthRepository repository;
  late LoginUseCase loginUseCase;
  late LogoutUseCase logoutUseCase;

  setUp(() {
    repository = FakeAuthRepository();
    loginUseCase = LoginUseCase(repository);
    logoutUseCase = LogoutUseCase(repository);
  });

  group('LoginUseCase', () {
    test('a successful login is returned as LoginSuccess, with a single attempt', () async {
      final result = await loginUseCase.call();

      expect(result, isA<LoginSuccess>());
      expect(repository.loginCalls, 1);
    });

    test('an AuthException surfaces as LoginFailed without retrying', () async {
      repository.loginErrors.add(const AuthException.cancelled());

      final result = await loginUseCase.call();

      expect(result, isA<LoginFailed>());
      expect((result as LoginFailed).cause, isA<AuthException>());
      expect(repository.loginCalls, 1);
    });
  });

  group('LogoutUseCase', () {
    test('a successful logout is returned as LogoutSuccess, with a single attempt', () async {
      final result = await logoutUseCase.call(idToken: 'fake-id-token');

      expect(result, isA<LogoutSuccess>());
      expect(repository.logoutCalls, 1);
    });

    test('an error surfaces as LogoutFailed without retrying', () async {
      repository.logoutErrors.add(const AuthException.unexpected());

      final result = await logoutUseCase.call(idToken: 'fake-id-token');

      expect(result, isA<LogoutFailed>());
      expect(repository.logoutCalls, 1);
    });
  });
}
