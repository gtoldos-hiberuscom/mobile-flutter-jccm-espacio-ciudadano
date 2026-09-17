import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';

/// [AuthRepository] fake that records every login/logout attempt and can be
/// configured to fail selectively per attempt.
final class FakeAuthRepository implements AuthRepository {
  final List<String> revokedTokens = [];

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {
    revokedTokens.add(refreshToken);
  }

  /// `ephemeralSession` value of each login call, in order.
  final List<bool> loginAttempts = [];

  /// `ephemeralSession` value of each logout call, in order.
  final List<bool> logoutAttempts = [];

  /// Errors to throw for login attempts, consumed in order. A `null` entry
  /// (or an exhausted list) means the attempt succeeds.
  final List<Exception?> loginErrors = [];

  /// Same for logout attempts.
  final List<Exception?> logoutErrors = [];

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final bool ephemeralSession = true,
  }) async {
    loginAttempts.add(ephemeralSession);
    final error = loginAttempts.length <= loginErrors.length ? loginErrors[loginAttempts.length - 1] : null;
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
    final bool ephemeralSession = true,
  }) async {
    logoutAttempts.add(ephemeralSession);
    final error = logoutAttempts.length <= logoutErrors.length ? logoutErrors[logoutAttempts.length - 1] : null;
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

  group('LoginUseCase ephemeral degradation', () {
    test('successful ephemeral login is not flagged as degraded', () async {
      final result = await loginUseCase.call();

      expect(result, isA<LoginSuccess>());
      expect((result as LoginSuccess).sessionIsolationDegraded, isFalse);
      expect(repository.loginAttempts, [true]);
    });

    test('ephemeralUnavailable triggers a single non-ephemeral retry flagged as degraded', () async {
      repository.loginErrors.add(const AuthException.ephemeralUnavailable());

      final result = await loginUseCase.call();

      expect(result, isA<LoginSuccess>());
      expect((result as LoginSuccess).sessionIsolationDegraded, isTrue);
      expect(repository.loginAttempts, [true, false]);
    });

    test('other AuthExceptions fail without retrying', () async {
      repository.loginErrors.add(const AuthException.cancelled());

      final result = await loginUseCase.call();

      expect(result, isA<LoginFailed>());
      expect((result as LoginFailed).cause, isA<AuthException>());
      expect(repository.loginAttempts, [true]);
    });

    test('failure on the degraded retry surfaces as LoginFailed', () async {
      repository.loginErrors.addAll([
        const AuthException.ephemeralUnavailable(),
        const AuthException.unexpected(),
      ]);

      final result = await loginUseCase.call();

      expect(result, isA<LoginFailed>());
      expect(repository.loginAttempts, [true, false]);
    });
  });

  group('LogoutUseCase ephemeral degradation', () {
    test('successful ephemeral logout does not retry', () async {
      final result = await logoutUseCase.call(idToken: 'fake-id-token');

      expect(result, isA<LogoutSuccess>());
      expect(repository.logoutAttempts, [true]);
    });

    test('ephemeralUnavailable retries silently without an ephemeral session', () async {
      repository.logoutErrors.add(const AuthException.ephemeralUnavailable());

      final result = await logoutUseCase.call(idToken: 'fake-id-token');

      expect(result, isA<LogoutSuccess>());
      expect(repository.logoutAttempts, [true, false]);
    });

    test('other errors surface as LogoutFailed without retrying', () async {
      repository.logoutErrors.add(const AuthException.unexpected());

      final result = await logoutUseCase.call(idToken: 'fake-id-token');

      expect(result, isA<LogoutFailed>());
      expect(repository.logoutAttempts, [true]);
    });
  });
}
