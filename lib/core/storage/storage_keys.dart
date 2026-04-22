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

  // ── Non-sensitive keys ────────────────────────────────────────────────────

  /// Whether the user has accepted the consent / terms screen.
  static const String consentAccepted = 'consent_accepted';

  /// The locale code last selected by the user (e.g. `'es'`).
  static const String selectedLocale = 'selected_locale';
}
