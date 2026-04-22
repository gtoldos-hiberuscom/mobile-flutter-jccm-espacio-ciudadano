import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session.dart';

/// Domain contract for all Cl@ve authentication operations.
///
/// Implementations live in `3_data/`. This interface must not import any
/// Flutter, Riverpod, Dio, or concrete storage class — only entities and
/// [Result].
///
/// All methods return [Result] values instead of throwing so that callers
/// in `1_domain/` can pattern-match failures without catching exceptions.
abstract interface class AuthRepository {
  /// Opens the Cl@ve login portal URL in the platform browser.
  ///
  /// Returns a [Failure] because the token is not available synchronously;
  /// the real session arrives via [handleCallback] after the Cl@ve redirect.
  Future<Result<Session>> initiateClaveLogin(final String claveLoginUrl);

  /// Processes the deep-link [callbackUri] received from Cl@ve.
  ///
  /// Extracts the `code` query parameter, exchanges it for tokens (Sprint 2),
  /// persists the resulting [Session], and returns it.
  ///
  /// In Sprint 1 this returns a mock session — real OIDC exchange is tracked
  /// by TASK-21.
  Future<Result<Session>> handleCallback(final Uri callbackUri);

  /// Reads a previously persisted [Session] from secure storage.
  ///
  /// Returns `Success(null)` when no stored session exists or when the stored
  /// session is expired. Returns `Failure` only on storage read errors.
  Future<Result<Session?>> restoreSession();

  /// Silently renews the access token using the [session]'s refresh token.
  ///
  /// Returns a [Failure] in Sprint 1 — real refresh is tracked by TASK-21.
  Future<Result<void>> refreshSession(final Session session);

  /// Clears all persisted tokens and terminates the active session.
  Future<Result<void>> logout();
}
