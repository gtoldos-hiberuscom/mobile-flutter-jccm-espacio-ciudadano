import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart' show AppError;
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session.dart';

/// Sealed hierarchy representing every possible state of the authentication
/// lifecycle.
///
/// Pure Dart — no Flutter, Riverpod, or infrastructure imports allowed.
///
/// States:
/// - [AuthUnauthenticated] — no active session (initial / post-logout state).
/// - [AuthLoading]         — an async auth operation is in progress.
/// - [AuthAuthenticated]   — a valid [Session] is held.
/// - [AuthExpired]         — the session token has expired and could not be
///                          refreshed silently.
/// - [AuthError]           — an unrecoverable auth error occurred.
sealed class AuthState {
  const AuthState();
}

/// The user has no active session.
///
/// This is the initial state before login and the state after successful
/// logout.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An authentication operation (login, restore, refresh) is in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// The user is authenticated and holds a valid [session].
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.session);

  /// The active session. Never null when in this state.
  final Session session;
}

/// The session has expired and silent renewal failed.
///
/// The UI should prompt the user to re-authenticate.
final class AuthExpired extends AuthState {
  const AuthExpired();
}

/// An unrecoverable authentication error occurred.
///
/// [message] comes from the [AppError] sealed class — never from a raw
/// exception message.
final class AuthError extends AuthState {
  const AuthError(this.message);

  /// Human-readable error description. Must not contain PII.
  final String message;
}
