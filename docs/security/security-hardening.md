# Security Hardening Guidelines — Carpeta Ciudadana CLM (JCCM Espacio Ciudadano)

**Document version:** 1.0  
**Date:** 2025-07-14  
**Status:** Active  
**Owner:** Platform / Security team  

---

## 1. Purpose

This document defines the security hardening baseline for the JCCM Espacio Ciudadano Flutter
application.  Every developer working on the codebase must follow these guidelines.  Deviations
require an Architecture Decision Record (ADR).

---

## 2. Network security

### 2.1 Certificate pinning

- Certificate pinning policy is **deferred to production configuration** (TBD).
- When implemented, pinning must be configured at the `ApiClient` / `Dio` level via a custom
  `BadCertificateCallback` or a dedicated security interceptor.
- The decision to adopt or skip pinning for specific environments must be recorded in an ADR.

### 2.2 API call routing

- **All API calls must go through `ApiClient`** with its registered interceptors:
  - `AuthInterceptor` — attaches `Authorization: Bearer <token>` and handles token refresh.
  - `ErrorInterceptor` — normalises HTTP errors into `AppError` sealed class.
  - `LoggingInterceptor` — structured request/response logging with PII stripped.
- **Prohibited:** Creating a raw `Dio` instance outside `ApiClient`; bypassing
  `dio_client_provider`; calling HTTP libraries directly from feature code.

### 2.3 External URL policy

- External URLs opened from the app (e.g., via `url_launcher`) must be validated before opening.
- **Rule:** A URL must start with `https://` and match an allowlist of trusted domains before
  being launched.
- Deep links and redirect targets must be validated against the same allowlist.

---

## 3. Secure storage

### 3.1 What goes in SecureStorage

Use `lib/core/storage/secure_storage.dart` (backed by `flutter_secure_storage`) for:

| Data | Key constant (from `storage_keys.dart`) |
|------|-----------------------------------------|
| `accessToken` | `StorageKeys.accessToken` |
| `refreshToken` | `StorageKeys.refreshToken` |
| `idAgente` | `StorageKeys.idAgente` |
| Any 🔴 RED field (see PII inventory) | Define a new constant in `StorageKeys` |

### 3.2 Platform storage guarantees

| Platform | Mechanism | Access policy |
|----------|-----------|---------------|
| iOS | Keychain via `flutter_secure_storage` | `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` — data not accessible when device is locked; not migrated to new device via backup. |
| Android | EncryptedSharedPreferences backed by Android Keystore | AES-256 key generated in hardware-backed Keystore where available. |

### 3.3 What must NOT go in AppStorage

`AppStorage` (`lib/core/storage/app_storage.dart`) uses `SharedPreferences`, which is **not
encrypted**.  No PII of any classification (🔴 RED or 🟡 AMBER) may be written to `AppStorage`.

Acceptable content for `AppStorage`:

- User interface preferences (theme mode, language override).
- Non-identifying feature flags.
- Last-visited screen for UX restoration (no user-identifying data).

---

## 4. Session lifecycle

### 4.1 Login

1. After successful authentication, store `accessToken`, `refreshToken`, and `idAgente` in
   `SecureStorage`.
2. Transition `SessionStateNotifier` to `SessionState.authenticated`.
3. Navigate to the home shell.

### 4.2 Logout

1. Call `SecureStorage.deleteAll()` to wipe all sensitive keys.
2. Clear any user-context keys from `AppStorage` (e.g., last-fetched timestamp).
3. Transition `SessionStateNotifier` to `SessionState.unauthenticated`.
4. Navigate to the landing / login screen.
5. **Do not** retain any 🔴 RED or 🟡 AMBER in-memory data after step 1.

### 4.3 Token expiry / 401 Unauthorized

1. `ErrorInterceptor` detects a 401 response.
2. `AuthInterceptor` attempts a single token refresh using `refreshToken`.
3. If refresh succeeds, retry the original request transparently.
4. If refresh fails (expired or revoked), `ErrorInterceptor` emits a session-expiry signal.
5. `SessionStateNotifier` transitions to `SessionState.expired`.
6. The router redirects to the landing screen; `SecureStorage.deleteAll()` is called.

### 4.4 Session state in Widget tree

- **Do not** store session state in `StatefulWidget` state.
- Session state is owned exclusively by `SessionStateNotifier`
  (`lib/core/auth/session_state_provider.dart`).
- Widgets read session state via `ref.watch(sessionStateProvider)` only.

---

## 5. Logging security

### 5.1 Existing controls

`LoggingInterceptor` (`lib/core/network/network_interceptors.dart`) already:

- Strips the `Authorization` header from logged request headers.
- Logs request URL, method, and status code only.

### 5.2 Additional required rules

| Rule | Scope |
|------|-------|
| Never log request or response **body** in production builds. | All interceptors, all features. |
| Use `kDebugMode` guard for any body-level diagnostic logging. | `LoggingInterceptor`, debug helpers. |
| Never log a 🔴 RED field value. | All app code. |
| For 🟡 AMBER fields in log strings, use `[REDACTED]` placeholder. | All app code. |

### 5.3 PII redaction pattern

```dart
// ✅ Correct
logger.debug('Processing DGT request for plate=[REDACTED]');

// ❌ Wrong
logger.debug('Processing DGT request for plate=$vehiclePlate');
```

### 5.4 Crash reporting

- Before attaching any diagnostic context to crash reports (Crashlytics, Sentry, etc.), verify no
  🔴 RED or raw 🟡 AMBER values are included.
- Use anonymous identifiers (e.g., a hashed session ID) rather than real user identifiers.

---

## 6. Code security

### 6.1 Secrets management

| Rule | Detail |
|------|--------|
| No hardcoded secrets in source code. | No API keys, client secrets, or passwords in `.dart`, `.yaml`, or any tracked file. |
| Environment secrets live in `config_*.json` files. | `config_development.json`, `config_preproduction.json`, `config_production.json`. |
| `config_*.json` files containing real secrets must not be committed. | Add real-secret config files to `.gitignore`; commit only template / placeholder versions. |
| Use `AppConfig` typed wrapper. | Access all config values via the `AppConfig` class, never by reading raw JSON maps at runtime. |

### 6.2 Generated client encapsulation

See [ADR-003](../../documentation/architecture_canon_flutter_v2_docs/adr/ADR-003-generated-client-encapsulation.md).

- The `generated/` directory is read-only at development time — never edit generated files manually.
- No generated DTO may cross the `3_data/` boundary into `1_domain/` or `2_presentation/`.
- All feature `3_data/` layers must wrap generated models behind a `GeneratedApiWrapper` class.

### 6.3 Dependency hygiene

- Keep dependencies up to date; monitor advisories via `dart pub outdated` and GitHub Dependabot.
- Pinned version cohorts (see [ADR-001](../../documentation/architecture_canon_flutter_v2_docs/adr/ADR-001-package-version-cohort.md)) must be
  reviewed whenever a blocking constraint is resolved.
- Do not add transitive dependencies with known CVEs.

---

## 7. Data transmission

- All API communication uses HTTPS (enforced at the backend and by `ApiClient` base URL config).
- Any plaintext fallback (HTTP) must be explicitly disallowed in the `AndroidManifest.xml`
  `android:usesCleartextTraffic="false"` attribute and equivalent iOS ATS settings.
- File uploads and downloads follow the same interceptor pipeline as JSON requests.

---

## 8. Checklist for feature developers

Before raising a PR, verify:

- [ ] No new PII fields were introduced without updating `docs/security/pii-inventory.md`.
- [ ] No 🔴 RED field appears in any log call, analytics event, or crash breadcrumb.
- [ ] Any 🟡 AMBER field in a log call uses `[REDACTED]`.
- [ ] No secrets or API keys are hardcoded in Dart files or YAML.
- [ ] Auth tokens and sensitive IDs are stored only in `SecureStorage`.
- [ ] No PII is written to `AppStorage`.
- [ ] Logout path calls `SecureStorage.deleteAll()`.
- [ ] No raw `Dio` instance created outside `ApiClient`.
- [ ] No generated DTO exposed outside `3_data/`.

---

## 9. References

- [PII Inventory](./pii-inventory.md)
- [ADR-001 — Package version cohort](../../documentation/architecture_canon_flutter_v2_docs/adr/ADR-001-package-version-cohort.md)
- [ADR-004 — GoRouter provider](../../documentation/architecture_canon_flutter_v2_docs/adr/ADR-004-gorouter-provider-not-riverpod.md)
- [ADR-003 — Generated client encapsulation](../../documentation/architecture_canon_flutter_v2_docs/adr/ADR-003-generated-client-encapsulation.md)
- Architecture canon: `documentation/architecture_canon_flutter_v2_docs/` — Annex C, section 24 (Security)
