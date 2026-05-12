import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/check_life_events_onboarding_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/onboarding_preferences_usecase_providers.dart';

/// Route guard that enforces session validity before any authenticated route
/// is entered.
///
/// The guard is designed to be instantiated inside the `goRouterProvider`
/// factory so it captures the provider's `Ref` without relying on
/// `BuildContext`. This makes it unit-testable in isolation.
///
/// ## Decision flow
///
/// 1. If the target route does not require auth → pass through (`null`).
/// 2. Read the in-memory session from `tokenResponseProvider`.
///    If absent, fall back to `SecureStorage`.
///    - No access token in storage → clear session → redirect to landing.
/// 3. Check whether the token has expired.
///    - Not expired → pass through (`null`).
/// 4. Token expired → attempt silent refresh via `AuthRepository.refreshToken`.
///    - Refresh success → persist new tokens, update in-memory state → pass through.
///    - Refresh failure → clear session → redirect to landing.
///
/// No transport-level error details are surfaced to the user.
final class SessionGuard {
  const SessionGuard(this._ref);

  final Ref _ref;

  /// Returns the redirect target or `null` to allow navigation to proceed.
  Future<String?> redirect(final GoRouterState state) async {
    final String path = state.matchedLocation;

    // Public routes — always allow.
    if (!Routes.requiresAuth(path)) {
      return null;
    }

    final SecureStorage storage = _ref.read(secureStorageProvider);

    // ── Step 1: determine current expiry ─────────────────────────────────────

    DateTime? expiresAt;

    final TokenResponse? session = _ref.read(tokenResponseProvider);
    if (session != null) {
      // In-memory session is the fastest path.
      expiresAt = session.accessTokenExpirationDateTime;
    } else {
      // No in-memory token — fall back to SecureStorage.
      final String? storedToken = await storage.read(StorageKeys.accessToken);
      if (storedToken == null) {
        await _clearSession(storage);
        return Routes.landing;
      }

      final String? expiresAtStr = await storage.read(StorageKeys.sessionExpiresAt);
      expiresAt = expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;
    }

    // ── Step 2: expiry check ──────────────────────────────────────────────────

    final bool isExpired = expiresAt == null || expiresAt.isBefore(DateTime.now());
    if (!isExpired) {
      return _onboardingRedirect(path);
    }

    // ── Step 3: attempt silent refresh ───────────────────────────────────────

    final String? refreshResult = await _tryRefresh(storage);
    if (refreshResult != null) {
      return refreshResult;
    }
    return _onboardingRedirect(path);
  }

  /// Redirects to the life-events onboarding screen on first login.
  ///
  /// Returns [Routes.lifeEvents] if the citizen has not yet seen the screen,
  /// or `null` to allow navigation to proceed normally.
  Future<String?> _onboardingRedirect(final String path) async {
    if (path == Routes.lifeEvents) {
      return null;
    }
    final String idAgente =
        _ref.read(jwtClaimsProvider)?.idAgente ?? '';
    if (idAgente.isEmpty) {
      return null;
    }
    final result = await _ref
        .read(checkLifeEventsOnboardingUsecaseProvider)
        .execute(idAgente: idAgente);
    if (result is CheckLifeEventsOnboardingSuccess && !result.hasSeen) {
      return Routes.lifeEvents;
    }
    return null;
  }

  /// Attempts a silent token refresh.
  ///
  /// Returns `null` on success (navigation proceeds) or [Routes.landing] on
  /// any failure.
  Future<String?> _tryRefresh(final SecureStorage storage) async {
    final String? storedRefreshToken = await storage.read(StorageKeys.refreshToken);
    if (storedRefreshToken == null) {
      await _clearSession(storage);
      return Routes.landing;
    }

    try {
      final TokenResponse newSession = await _ref
          .read(authRepositoryProvider)
          .refreshToken(refreshToken: storedRefreshToken);

      // Persist the refreshed credentials.
      await Future.wait([
        if (newSession.accessToken != null)
          storage.write(StorageKeys.accessToken, newSession.accessToken!),
        if (newSession.refreshToken != null)
          storage.write(StorageKeys.refreshToken, newSession.refreshToken!),
        if (newSession.accessTokenExpirationDateTime != null)
          storage.write(
            StorageKeys.sessionExpiresAt,
            newSession.accessTokenExpirationDateTime!.toIso8601String(),
          ),
      ]);

      // Keep in-memory state consistent.
      _ref.read(tokenResponseProvider.notifier).update(newSession);

      return null; // allow navigation
    } catch (_) {
      // Refresh failed — treat as an expired / invalid session.
      await _clearSession(storage);
      _ref.read(tokenResponseProvider.notifier).update(null);
      return Routes.landing;
    }
  }

  /// Removes all token-related entries from [SecureStorage].
  Future<void> _clearSession(final SecureStorage storage) async {
    await Future.wait([
      storage.delete(StorageKeys.accessToken),
      storage.delete(StorageKeys.refreshToken),
      storage.delete(StorageKeys.sessionExpiresAt),
    ]);
  }
}
