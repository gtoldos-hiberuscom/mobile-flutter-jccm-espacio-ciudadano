/// Canonical keys used across `SecureStorage` and `AppStorage`.
///
/// All keys are `const` strings to avoid typos and enable refactoring safety.
/// Secure keys (tokens) must ONLY be written to `SecureStorage`;
/// non-sensitive keys may use `AppStorage` backed by SharedPreferences.
abstract final class StorageKeys {
  // ── Secure keys (tokens) ──────────────────────────────────────────────────

  /// JWT access token for API authorisation.
  static const String accessToken = 'access_token';

  /// JWT refresh token for silent re-authentication.
  static const String refreshToken = 'refresh_token';

  /// Federated user identifier from the Cl@ve identity assertion (DNI / NIE).
  static const String idAgente = 'id_agente';

  /// ISO-8601 string of the access-token expiry instant.
  static const String sessionExpiresAt = 'session_expires_at';

  // ── Non-sensitive keys ────────────────────────────────────────────────────

  /// Whether the user has accepted the consent / terms screen.
  static const String consentAccepted = 'consent_accepted';

  /// The locale code last selected by the user (e.g. `'es'`).
  static const String selectedLocale = 'selected_locale';

  /// Prefix for per-user life-events onboarding-seen flag.
  /// Full key = lifeEventsOnboardingSeenPrefix + idAgente
  static const String lifeEventsOnboardingSeenPrefix =
      'life_events_onboarding_seen_';
}
