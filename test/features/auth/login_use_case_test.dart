import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';

/// [AuthRepository] fake that counts login/logout calls and can be configured
/// to fail selectively per attempt.
///
/// El recuento importa: los casos de uso **no** reintentan ante un fallo. Un
/// error se devuelve como resultado sellado, nunca se enmascara con un segundo
/// intento.
///
/// La única excepción, deliberada, es no poder abrir sesión **aislada**: ahí sí
/// se reintenta sin aislamiento, porque lo contrario deja al ciudadano sin
/// poder entrar. Por eso se guarda también [isolateSessionCalls].
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

  /// El valor de `isolateSession` recibido en cada intento, en orden.
  final List<bool> isolateSessionCalls = [];

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool isolateSession = true,
    final Map<String, String> extraParameters = const <String, String>{},
  }) async {
    loginCalls++;
    isolateSessionCalls.add(isolateSession);
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

    test('siempre se pide aislamiento en el primer intento', () async {
      await loginUseCase.call();

      expect(repository.isolateSessionCalls, [true]);
    });

    test('si el navegador no puede aislar, se entra igual pero MARCADO', () async {
      // El fork aborta antes de abrir nada. Dejar al ciudadano sin acceder
      // sería peor; entrar sin avisar, también: en ese dispositivo su sesión de
      // Cl@ve puede quedar recordada, que es justo lo que el aislamiento evita.
      repository.loginErrors.add(const AuthException.ephemeralUnavailable());

      final result = await loginUseCase.call();

      expect(result, isA<LoginSuccess>());
      expect((result as LoginSuccess).sessionIsolationDegraded, isTrue);
      expect(
        repository.isolateSessionCalls,
        [true, false],
        reason: 'el reintento tiene que renunciar al aislamiento explícitamente',
      );
    });

    test('un login normal NO se marca como degradado', () async {
      final result = await loginUseCase.call();

      expect((result as LoginSuccess).sessionIsolationDegraded, isFalse);
    });

    test('si el reintento también falla, es un fallo y no un acceso degradado', () async {
      repository.loginErrors
        ..add(const AuthException.ephemeralUnavailable())
        ..add(const AuthException.cancelled());

      final result = await loginUseCase.call();

      expect(result, isA<LoginFailed>());
      expect(repository.loginCalls, 2);
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
