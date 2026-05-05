import 'dart:async';

import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session_state.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_tokens.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/id_token_decoder.dart';

/// `SecureStorage`-backed implementation of [AuthSessionRepository].
///
/// Owns the only piece of code in the app that decodes the OIDC `id_token`
/// to derive an [AuthUser], and the only writer of the auth-related
/// `StorageKeys.*` entries.
final class AuthSessionRepositoryImpl implements AuthSessionRepository {
  AuthSessionRepositoryImpl(this._secureStorage);

  final SecureStorage _secureStorage;
  final StreamController<AuthSessionState> _controller = StreamController<AuthSessionState>.broadcast();

  @override
  Stream<AuthSessionState> watch() => _controller.stream;

  @override
  Future<AuthSessionState> read() async {
    try {
      final accessToken = await _secureStorage.read(StorageKeys.accessToken);
      final idToken = await _secureStorage.read(StorageKeys.idToken);
      if (accessToken == null || accessToken.isEmpty || idToken == null || idToken.isEmpty) {
        return const UnauthenticatedSession();
      }

      final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);
      final expiresAtRaw = await _secureStorage.read(StorageKeys.sessionExpiresAt);
      final expiresAt = expiresAtRaw == null ? null : DateTime.tryParse(expiresAtRaw);

      final user = _decodeUser(idToken);
      if (user == null) {
        await _wipe();
        return const UnauthenticatedSession();
      }

      final session = AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        idToken: idToken,
        tokenType: 'Bearer',
        scopes: authDefaultScopes,
        accessTokenExpiresAt: expiresAt,
      );
      return AuthenticatedSession(session: session, user: user);
    } on FormatException {
      // Persisted state is corrupt — fall back to a clean slate.
      await _wipe();
      return const UnauthenticatedSession();
    }
  }

  @override
  Future<AuthenticatedSession> save(final AuthTokens session) async {
    final idToken = session.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw StateError('AuthSession is missing the id_token.');
    }
    final user = _decodeUser(idToken);
    if (user == null) {
      throw StateError('AuthSession id_token does not yield a usable AuthUser.');
    }

    await Future.wait<void>(<Future<void>>[
      _secureStorage.write(StorageKeys.accessToken, session.accessToken),
      if (session.refreshToken != null) _secureStorage.write(StorageKeys.refreshToken, session.refreshToken!) else _secureStorage.delete(StorageKeys.refreshToken),
      _secureStorage.write(StorageKeys.idToken, idToken),
      _secureStorage.write(StorageKeys.idAgente, user.idAgente),
      if (session.accessTokenExpiresAt != null)
        _secureStorage.write(
          StorageKeys.sessionExpiresAt,
          session.accessTokenExpiresAt!.toIso8601String(),
        )
      else
        _secureStorage.delete(StorageKeys.sessionExpiresAt),
    ]);

    final authenticated = AuthenticatedSession(session: session, user: user);
    _emit(authenticated);
    return authenticated;
  }

  @override
  Future<void> clear() async {
    await _wipe();
    _emit(const UnauthenticatedSession());
  }

  // ── internal ──────────────────────────────────────────────────────────────

  AuthUser? _decodeUser(final String idToken) {
    final claims = decodeIdTokenPayload(idToken);
    if (claims == null) {
      return null;
    }
    final sub = _string(claims['sub']);
    if (sub == null) {
      return null;
    }
    return AuthUser(
      sub: sub,
      nif: _string(claims['nif']) ?? _string(claims['idAgente']) ?? _string(claims['document_number']),
      givenName: _string(claims['given_name']) ?? _string(claims['name']),
      familyName: _string(claims['family_name']),
      email: _string(claims['email']),
    );
  }

  Future<void> _wipe() {
    return Future.wait<void>(<Future<void>>[
      _secureStorage.delete(StorageKeys.accessToken),
      _secureStorage.delete(StorageKeys.refreshToken),
      _secureStorage.delete(StorageKeys.idToken),
      _secureStorage.delete(StorageKeys.idAgente),
      _secureStorage.delete(StorageKeys.sessionExpiresAt),
    ]);
  }

  void _emit(final AuthSessionState state) {
    if (!_controller.isClosed) {
      _controller.add(state);
    }
  }

  static String? _string(final Object? value) {
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
