import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_tokens.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session_state.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';

void main() {
  group('LoginUseCase', () {
    test('persists Cl@ve session via AuthSessionRepository on success', () async {
      final session = _makeSession('my-token');
      final authRepo = _FakeAuthRepository(loginResult: session);
      final sessionRepo = _FakeSessionRepository();

      final result = await LoginUseCase(authRepo, sessionRepo)();

      expect(result, isA<AuthenticatedSession>());
      expect(result.session.accessToken, 'my-token');
      expect(sessionRepo.lastSaved?.accessToken, 'my-token');
    });

    test('forwards custom loginHint and scopes to repository', () async {
      final authRepo = _FakeAuthRepository(loginResult: _makeSession('t'));

      await LoginUseCase(authRepo, _FakeSessionRepository())(
        loginHint: '12345678Z',
        scopes: const ['openid', 'profile'],
      );

      expect(authRepo.lastLoginHint, '12345678Z');
      expect(authRepo.lastLoginScopes, const ['openid', 'profile']);
    });

    test('uses authDefaultScopes when scopes are omitted', () async {
      final authRepo = _FakeAuthRepository(loginResult: _makeSession('t'));

      await LoginUseCase(authRepo, _FakeSessionRepository())();

      expect(authRepo.lastLoginScopes, authDefaultScopes);
    });

    test('propagates AuthException from repository and does not persist', () async {
      final authRepo = _FakeAuthRepository(
        loginError: const AuthException.cancelled(),
      );
      final sessionRepo = _FakeSessionRepository();

      await expectLater(
        () => LoginUseCase(authRepo, sessionRepo)(),
        throwsA(
          isA<AuthException>().having((final e) => e.reason, 'reason', AuthFailureReason.cancelled),
        ),
      );
      expect(sessionRepo.lastSaved, isNull);
    });
  });

  group('LogoutUseCase', () {
    test('terminates Cl@ve session and clears local state', () async {
      final authRepo = _FakeAuthRepository();
      final sessionRepo = _FakeSessionRepository();

      await LogoutUseCase(authRepo, sessionRepo)(idToken: 'id-token');

      expect(authRepo.lastLogoutIdToken, 'id-token');
      expect(sessionRepo.cleared, isTrue);
    });

    test('forwards optional postLogoutRedirectUri', () async {
      final authRepo = _FakeAuthRepository();

      await LogoutUseCase(authRepo, _FakeSessionRepository())(
        idToken: 'id-token',
        postLogoutRedirectUri: 'myapp://redirect',
      );

      expect(authRepo.lastLogoutRedirectUri, 'myapp://redirect');
    });

    test('clears local state even when remote logout fails', () async {
      final authRepo = _FakeAuthRepository(
        logoutError: const AuthException.remoteFailure(message: 'session end failed'),
      );
      final sessionRepo = _FakeSessionRepository();

      await LogoutUseCase(authRepo, sessionRepo)(idToken: 'id-token');

      expect(sessionRepo.cleared, isTrue);
    });
  });
}

AuthTokens _makeSession(final String accessToken) {
  return AuthTokens(
    accessToken: accessToken,
    idToken: 'fake-id-token',
    tokenType: 'Bearer',
    scopes: authDefaultScopes,
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.loginResult, this.loginError, this.logoutError});

  final AuthTokens? loginResult;
  final Object? loginError;
  final Object? logoutError;

  String? lastLoginHint;
  List<String>? lastLoginScopes;
  String? lastLogoutIdToken;
  String? lastLogoutRedirectUri;

  @override
  Future<AuthTokens> login({
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
  Future<AuthTokens> refreshToken({
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

final class _FakeSessionRepository implements AuthSessionRepository {
  AuthTokens? lastSaved;
  bool cleared = false;
  AuthSessionState _state = const UnauthenticatedSession();
  final StreamController<AuthSessionState> _controller =
      StreamController<AuthSessionState>.broadcast();

  @override
  Future<AuthSessionState> read() async => _state;

  @override
  Future<AuthenticatedSession> save(final AuthTokens session) async {
    lastSaved = session;
    final authenticated = AuthenticatedSession(
      session: session,
      user: const AuthUser(sub: 'sub'),
    );
    _state = authenticated;
    _controller.add(authenticated);
    return authenticated;
  }

  @override
  Future<void> clear() async {
    cleared = true;
    _state = const UnauthenticatedSession();
    _controller.add(_state);
  }

  @override
  Stream<AuthSessionState> watch() => _controller.stream;
}
