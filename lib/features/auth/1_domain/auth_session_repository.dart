import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session_state.dart';

/// Domain contract responsible for the user's authentication session
/// **lifecycle on the device**: persisting tokens, deriving identity claims
/// from the OIDC `id_token`, exposing the current session state and clearing
/// it on logout.
///
/// Stays decoupled from `AuthRepository` (which only knows how to talk to
/// Cl@ve). `LoginUseCase` orchestrates both:
///   1. `AuthRepository.login()` → `AuthSession`
///   2. `AuthSessionRepository.save(session)` → `AuthenticatedSession`
abstract interface class AuthSessionRepository {
  /// Returns the persisted session state, rehydrating it on cold start.
  /// Returns [UnauthenticatedSession] when nothing is stored or the data
  /// cannot be decoded.
  Future<AuthSessionState> read();

  /// Persists [session] (encrypted at rest) and derives the matching
  /// [AuthUser] from the `id_token` claims. Emits the new state through
  /// [watch] and returns the resulting [AuthenticatedSession].
  ///
  /// Throws [StateError] when the session cannot be assembled (missing or
  /// undecodable `id_token`).
  Future<AuthenticatedSession> save(final AuthSession session);

  /// Wipes the persisted session and emits [UnauthenticatedSession] through
  /// [watch].
  Future<void> clear();

  /// Broadcasts every transition of the persisted session state. Notifiers
  /// subscribe to react to login/logout without performing any I/O of their
  /// own.
  Stream<AuthSessionState> watch();
}
