import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';

/// Top-level state of the user's authentication session.
///
/// Owned by `AuthSessionNotifier` and exposed through `authSessionProvider`.
/// Pure Dart entity — no Flutter, no Riverpod, no infrastructure imports.
sealed class AuthSessionState {
  const AuthSessionState();

  /// `true` when there is a valid signed-in user with an active access token.
  bool get isAuthenticated => this is AuthenticatedSession;

  /// Convenience accessor: returns the [AuthSession] when authenticated.
  AuthSession? get sessionOrNull => switch (this) {
        AuthenticatedSession(:final session) => session,
        _ => null,
      };

  /// Convenience accessor: returns the [AuthUser] when authenticated.
  AuthUser? get userOrNull => switch (this) {
        AuthenticatedSession(:final user) => user,
        _ => null,
      };

  /// Convenience accessor: returns the citizen's `idAgente` (NIF / sub) when
  /// authenticated, otherwise `null`. Use this from feature code that needs
  /// the document identifier (e.g. recommendations, hechos vitales, firma).
  String? get idAgente => userOrNull?.idAgente;
}

/// No active session. Either the user has never signed in, has signed out,
/// or the previously stored session expired and could not be refreshed.
final class UnauthenticatedSession extends AuthSessionState {
  const UnauthenticatedSession();

  @override
  String toString() => 'UnauthenticatedSession()';
}

/// Active session: a non-expired [AuthSession] paired with the [AuthUser]
/// derived from the OIDC `id_token`.
final class AuthenticatedSession extends AuthSessionState {
  const AuthenticatedSession({
    required this.session,
    required this.user,
  });

  final AuthSession session;
  final AuthUser user;

  AuthenticatedSession copyWith({
    final AuthSession? session,
    final AuthUser? user,
  }) {
    return AuthenticatedSession(
      session: session ?? this.session,
      user: user ?? this.user,
    );
  }

  @override
  String toString() => 'AuthenticatedSession(user: $user, session: $session)';
}
