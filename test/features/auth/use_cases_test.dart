import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';

void main() {
  group('LoginUseCase', () {
    test('returns AuthSession from repository on success', () async {
      final session = _makeSession('my-token');
      final repo = _FakeAuthRepository(loginResult: session);

      final result = await LoginUseCase(repo)();

      expect(result.accessToken, 'my-token');
    });

    test('forwards custom loginHint and scopes to repository', () async {
      final repo = _FakeAuthRepository(loginResult: _makeSession('t'));

      await LoginUseCase(repo)(
        loginHint: '12345678Z',
        scopes: const ['openid', 'profile'],
      );

      expect(repo.lastLoginHint, '12345678Z');
      expect(repo.lastLoginScopes, const ['openid', 'profile']);
    });

    test('uses authDefaultScopes when scopes are omitted', () async {
      final repo = _FakeAuthRepository(loginResult: _makeSession('t'));

      await LoginUseCase(repo)();

      expect(repo.lastLoginScopes, authDefaultScopes);
    });

    test('propagates AuthException from repository', () {
      final repo = _FakeAuthRepository(
        loginError: const AuthException.cancelled(),
      );

      expect(
        () => LoginUseCase(repo)(),
        throwsA(
          isA<AuthException>().having(
            (final e) => e.reason,
            'reason',
            AuthFailureReason.cancelled,
          ),
        ),
      );
    });
  });

  group('LogoutUseCase', () {
    test('delegates idToken to repository', () async {
      final repo = _FakeAuthRepository();

      await LogoutUseCase(repo)(idToken: 'id-token');

      expect(repo.lastLogoutIdToken, 'id-token');
    });

    test('forwards optional postLogoutRedirectUri', () async {
      final repo = _FakeAuthRepository();

      await LogoutUseCase(repo)(
        idToken: 'id-token',
        postLogoutRedirectUri: 'myapp://redirect',
      );

      expect(repo.lastLogoutRedirectUri, 'myapp://redirect');
    });

    test('propagates AuthException from repository', () {
      final repo = _FakeAuthRepository(
        logoutError: const AuthException.remoteFailure(
          message: 'session end failed',
        ),
      );

      expect(
        () => LogoutUseCase(repo)(idToken: 'id-token'),
        throwsA(
          isA<AuthException>().having(
            (final e) => e.reason,
            'reason',
            AuthFailureReason.remoteFailure,
          ),
        ),
      );
    });
  });
}

AuthSession _makeSession(final String accessToken) {
  return AuthSession(
    accessToken: accessToken,
    tokenType: 'Bearer',
    scopes: authDefaultScopes,
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.loginResult,
    this.loginError,
    this.logoutError,
  });

  final AuthSession? loginResult;
  final Object? loginError;
  final Object? logoutError;

  String? lastLoginHint;
  List<String>? lastLoginScopes;
  String? lastLogoutIdToken;
  String? lastLogoutRedirectUri;

  @override
  Future<AuthSession> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
  }) async {
    lastLoginHint = loginHint;
    lastLoginScopes = scopes;
    if (loginError != null) throw loginError!;
    return loginResult!;
  }

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {
    lastLogoutIdToken = idToken;
    lastLogoutRedirectUri = postLogoutRedirectUri;
    if (logoutError != null) throw logoutError!;
  }

  @override
  Future<AuthSession> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) async {
    return loginResult!;
  }

  @override
  Future<AuthUser> fetchUserInfo({required final String accessToken}) async {
    return const AuthUser(sub: 'sub');
  }
}
