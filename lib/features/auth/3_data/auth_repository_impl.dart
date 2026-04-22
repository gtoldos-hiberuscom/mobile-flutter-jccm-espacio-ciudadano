import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:url_launcher/url_launcher.dart';

/// Concrete implementation of [AuthRepository].
///
/// ## Sprint 1 status
/// - [initiateClaveLogin]: opens Cl@ve URL via `url_launcher`.
/// - [handleCallback]: returns a **mock** session (real OIDC tracked in TASK-21).
/// - [restoreSession]: reads and reconstructs a [Session] from [SecureStorage].
/// - [refreshSession]: stub — refresh not implemented until Sprint 2 (TASK-21).
/// - [logout]: clears all tokens via [SecureStorage.clear].
///
/// ## PII policy
/// Token values and [StorageKeys.idAgente] are never written to logs.
/// All storage writes go through [SecureStorage], never plain SharedPreferences.
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._secureStorage);

  final SecureStorage _secureStorage;

  // ── initiateClaveLogin ─────────────────────────────────────────────────────

  /// Opens [claveLoginUrl] in the platform browser.
  ///
  /// Returns a [Failure] because the actual token is delivered asynchronously
  /// via the deep-link callback — it is NOT available at this point.
  @override
  Future<Result<Session>> initiateClaveLogin(
    final String claveLoginUrl,
  ) async {
    try {
      final uri = Uri.parse(claveLoginUrl);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        return const Failure(
          UnknownError(message: 'No se pudo abrir el portal Cl@ve.'),
        );
      }
      // Success means the browser opened. The session arrives via callback.
      return const Failure(
        UnknownError(
          message: 'Waiting for Cl@ve callback — token not yet available.',
        ),
      );
    } catch (_) {
      return const Failure(
        UnknownError(message: 'Error al abrir el portal Cl@ve.'),
      );
    }
  }

  // ── handleCallback ────────────────────────────────────────────────────────

  /// Processes the Cl@ve deep-link callback URI.
  ///
  /// Sprint 1: creates a **mock** session from the `code` parameter.
  /// Sprint 2 (TASK-21): replace with real OIDC `code → token` exchange and
  /// JWT claims validation.
  @override
  Future<Result<Session>> handleCallback(final Uri callbackUri) async {
    final code = callbackUri.queryParameters['code'];
    if (code == null || code.isEmpty) {
      return const Failure(
        UnknownError(message: 'Código de autorización ausente en el callback.'),
      );
    }

    // ── Sprint 1 mock session ─────────────────────────────────────────────
    // TASK-21 will replace this with real OIDC token exchange + JWT validation.
    final mockSession = Session(
      accessToken: 'mock-access-token-$code',
      refreshToken: null,
      idAgente: 'mock-user',
      displayName: 'Usuario Mock',
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
      claims: const ['openid', 'profile'],
    );

    await _persistSession(mockSession);
    return Success(mockSession);
  }

  // ── restoreSession ────────────────────────────────────────────────────────

  /// Reads token data from [SecureStorage] and reconstructs a [Session].
  ///
  /// Returns `Success(null)` if:
  /// - No tokens are stored.
  /// - The stored session is expired.
  @override
  Future<Result<Session?>> restoreSession() async {
    try {
      final accessToken = await _secureStorage.read(StorageKeys.accessToken);
      final idAgente = await _secureStorage.read(StorageKeys.idAgente);
      final expiresAtRaw =
          await _secureStorage.read(StorageKeys.sessionExpiresAt);

      if (accessToken == null || idAgente == null || expiresAtRaw == null) {
        return const Success(null);
      }

      final expiresAt = DateTime.tryParse(expiresAtRaw);
      if (expiresAt == null) {
        return const Success(null);
      }

      final refreshToken = await _secureStorage.read(StorageKeys.refreshToken);

      final session = Session(
        accessToken: accessToken,
        refreshToken: refreshToken,
        idAgente: idAgente,
        expiresAt: expiresAt,
        claims: const [],
      );

      if (session.isExpired) {
        return const Success(null);
      }

      return Success(session);
    } catch (_) {
      return const Success(null);
    }
  }

  // ── refreshSession ────────────────────────────────────────────────────────

  /// Silent token refresh — stub for Sprint 1.
  ///
  /// TASK-21 tracks the real implementation.
  @override
  Future<Result<void>> refreshSession(final Session session) async {
    return const Failure(
      UnknownError(message: 'Token refresh not implemented in Sprint 1.'),
    );
  }

  // ── logout ────────────────────────────────────────────────────────────────

  /// Removes all persisted tokens from [SecureStorage].
  @override
  Future<Result<void>> logout() async {
    try {
      await _secureStorage.clear();
      return const Success(null);
    } catch (_) {
      return const Failure(UnknownError(message: 'Error al cerrar sesión.'));
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<void> _persistSession(final Session session) async {
    await _secureStorage.write(StorageKeys.accessToken, session.accessToken);
    await _secureStorage.write(StorageKeys.idAgente, session.idAgente);
    await _secureStorage.write(
      StorageKeys.sessionExpiresAt,
      session.expiresAt.toIso8601String(),
    );
    if (session.refreshToken != null) {
      await _secureStorage.write(
        StorageKeys.refreshToken,
        session.refreshToken!,
      );
    }
  }
}
