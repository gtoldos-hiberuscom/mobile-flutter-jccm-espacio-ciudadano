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

  /// Whether biometric quick access has been explicitly enabled by the user.
  static const String biometricQuickAccessEnabled = 'biometric_quick_access_enabled';

  /// Whether the biometric quick-access prompt has already been shown.
  static const String biometricQuickAccessPromptSeen = 'biometric_quick_access_prompt_seen';

  /// Marker written after the app has completed its first boot for this install.
  static const String installBootstrapped = 'install_bootstrapped';

  /// Forces the next manual Cl@ve login to ask for credentials.
  static const String forceClaveLoginOnNextLogin = 'force_clave_login_on_next_login';

  /// Prefix for per-user life-events onboarding-seen flag.
  /// Full key = lifeEventsOnboardingSeenPrefix + idAgente
  static const String lifeEventsOnboardingSeenPrefix = 'life_events_onboarding_seen_';

  /// Prefix for per-user life-events last successful update timestamp.
  /// Full key = lifeEventsLastUpdatedAtPrefix + idAgente
  static const String lifeEventsLastUpdatedAtPrefix = 'life_events_last_updated_at_';

  /// Prefix for per-user legal-consent accepted flag.
  /// Full key = consentAcceptedPrefix + idAgente
  static const String consentAcceptedPrefix = 'consent_accepted_';

  /// Prefix for per-user accepted legal-clause ids.
  /// Full key = consentAcceptedClausesPrefix + idAgente
  static const String consentAcceptedClausesPrefix = 'consent_accepted_clauses_';
}
