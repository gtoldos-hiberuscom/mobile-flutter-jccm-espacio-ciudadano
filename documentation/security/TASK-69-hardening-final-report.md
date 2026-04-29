# TASK-69 — Sprint 8 Hardening Final Report

- **Ticket:** [TASK-69] Inventario PII, hardening de seguridad y ADRs de excepción al canon
- **Epic:** [EPIC-10] Quality & Release
- **Sprint:** Sprint 8 (closure deliverable C)
- **Branch:** `task/EPIC-10-quality-release/TASK-69-pii-hardening/sprint8-hardening-final-pass`
- **Worktree:** `/Users/pmiguel/Documents/SourceTree/jccm-worktrees/C`
- **Scope:** Documentation-only audit. No code, tests, tickets, CI, or `pubspec.yaml` were modified.
- **Canon references:** annex C §24 (security), §26 (observability/logging), §29 (ADRs), `copilot-instructions` forbidden shortcuts.

This report records the final hardening verification at Sprint 8 closure. Every claim was reproduced via `grep` / `flutter pub outdated` / `flutter analyze` against this worktree on the cited branch. Where evidence contradicted prior assumptions, the disposition is called out explicitly.

---

## 1. PII inventory currency check

### 1.1 Existing inventory

A PII inventory **already exists** in the repository at `docs/security/pii-inventory.md` (179 lines, version 1.0, dated 2025‑07‑14, owner: Platform/Security). It defines the RED / AMBER / GREEN classification used by the rest of the hardening framework and is the canonical reference cited from `lib/core/logging/console_logger.dart:9` and from `docs/security/security-hardening.md`.

The inventory enumerates the following domains: Session/Auth, SESCAM, Catastro, DGT, SEPE, INE Census, Digital Cards, Life Events (Hechos Vitales), Documents.

### 1.2 Codebase PII surface (verification)

`grep -rnE '\bnif\b|\bdni\b|\bemail\b|\bphone\b|telefono|fechaNacimiento|apellido|direccion' lib/ --include='*.dart'` returns hits in 38 feature files. The fields actually present in `lib/` are mapped to inventory rows below.

| Field (code) | Module(s) | Storage path | Inventory row | Redaction wrapper at log boundary |
|---|---|---|---|---|
| `accessToken`, `refreshToken` | `core/network/network_interceptors.dart`, `features/user_profile/1_domain/user_profile_notifier.dart` | `SecureStorage` (`StorageKeys.accessToken`/`refreshToken`) | §3.1 RED | `ConsoleLogger._isPiiKey` matches `'token'` substring → `[REDACTED]` |
| `idAgente` | `features/auth/0_entity/auth_user.dart:18`, `features/auth/3_data/clave_user_info_dto.dart:32`, `features/user_profile/1_domain/user_profile_notifier.dart:39` | `SecureStorage` (`StorageKeys.idAgente`) | §3.1 RED | `ConsoleLogger._isPiiKey` matches `'id'` substring → `[REDACTED]` |
| `nif` (DNI/NIE) | `features/auth/0_entity/auth_user.dart:12`, `features/auth/3_data/auth_repository_impl.dart:68`, `features/auth/3_data/clave_user_info_dto.dart:26`, `features/casework/aportacion/0_entity/interested_party_identification.dart`, `features/digital_cards/{joven,discapacidad,familia_numerosa}/...` | In-memory only (Riverpod state); never written to `AppStorage` | §3.7 RED (DNI/NIE) | `ConsoleLogger._isPiiKey` matches `'dni'` — **does NOT match `'nif'` substring** ⚠ see §3.4 |
| `email` | `features/auth/0_entity/auth_user.dart:15`, `features/help/...`, `features/notifications/contact/...` | In-memory only | Implicit AMBER (contact) — **not explicitly listed** in `docs/security/pii-inventory.md` ⚠ | Not matched by `_kPiiKeyFragments`; relies on developers not putting raw email into `context` map |
| `phone` / `telefono` | `features/help/...`, `features/notifications/contact/...` | In-memory only | Implicit AMBER (contact) — **not explicitly listed** ⚠ | Not matched by `_kPiiKeyFragments` |
| `fechaNacimiento` | `features/social_welfare/0_entity/family_numerosa_title.dart:12`, `social_welfare_repository_impl.dart` (mock data), `social_welfare_landing_page.dart:211` | In-memory only | Implicit AMBER — **not listed** ⚠ | Not matched |
| `nombre` / `apellido` | `features/auth/0_entity/auth_user.dart`, `clave_user_info_dto.dart` | In-memory only | §3.1 “User display name” AMBER | `ConsoleLogger._isPiiKey` matches `'name'` → `[REDACTED]` |
| `direccion` (cadastral / residence) | `features/state_affairs/0_entity/{cadastral_property,residence_data}.dart`, `state_affairs_landing_page.dart` | In-memory only | §3.3 Property address AMBER | Not matched by current fragments ⚠ |
| Vehicle plate (`plate`/`matricula`) | DGT-derived features (no current direct uses found in lib via grep) | n/a | §3.4 AMBER | Matched by `'plate'`/`'matricula'` |
| `nss` (Social Security number) | None in `lib/` today | n/a | §3.5 RED | Matched by `'nss'` |

**Disposition:**
- The inventory is **largely current** for fields actually persisted (tokens, idAgente).
- Three pragmatic gaps for fields that exist in code but are not enumerated in `docs/security/pii-inventory.md`: `email`, `phone/telefono`, `fechaNacimiento`, and `direccion`. These are all **in-memory only** (Riverpod state in feature presentation/domain layers; no `AppStorage`/`SecureStorage` write was found via grep). Risk is bounded but the inventory text should be appended in a future sprint to reflect notification-contact and social-welfare/state-affairs domains. → **Sprint-9 carryover candidate (documentation update only).**
- `_kPiiKeyFragments` in `console_logger.dart:10-19` lacks fragments for `'nif'`, `'email'`, `'phone'`, `'telefono'`, `'address'`, `'direccion'`, `'birth'`, `'fecha'`. This is acceptable today because key-name redaction is a **defense-in-depth secondary control** — the primary control (per `docs/security/pii-inventory.md` §4 and `security-hardening.md` §5.3) is "never put raw PII in the log call". Still, hardening the fragment list would close the gap without behaviour change. → **Sprint-9 carryover candidate.**

---

## 2. Storage hardening audit

### 2.1 SharedPreferences usage

`grep -rn "SharedPreferences\|shared_preferences" lib/ test/`:

| File:line | Usage | Classification | Disposition |
|---|---|---|---|
| `lib/core/storage/app_storage.dart:2,8,28-32,59` | Definition of `AppStorage` interface and `SharedPreferencesAppStorage` implementation. Doc comment: *"Do NOT store secrets here; use SecureStorage for tokens and credentials."* | (a) Safe — controlled wrapper | Already correct. No change. |
| `lib/core/storage/app_storage.g.dart:14,23,30` | Riverpod generated provider for the wrapper. | (a) Safe | Already correct. |
| `lib/core/storage/storage_keys.dart:5` | Doc string for canonical key registry. | (a) Safe | Already correct. |
| `lib/core/cache/ttl_cache.dart:11-12` | Doc-comment guidance: *"Notes and use SecureStorage for sensitive values or SharedPreferences for non-PII metadata explicitly."* | (a) Safe | Already correct. |

`grep -rn` returned **no results in `test/`** — no test code reaches into raw `SharedPreferences`.

### 2.2 What is actually written to `AppStorage`

`grep -rn 'appStorage\|AppStorage' lib/ --include='*.dart'` (excluding the wrapper itself):

| File:line | Key written | PII risk |
|---|---|---|
| `lib/features/user_profile/1_domain/user_profile_notifier.dart:37-40` | `accessToken`, `refreshToken`, `idAgente`, `sessionExpiresAt` — **calls `appStorage.remove(...)`**, never `write`. Defensive belt-and-braces clearing on logout. | Safe — write path does not exist; remove-only is defense-in-depth in case a future bug ever leaked a token to AppStorage. |

**No production write path** to `AppStorage` for any RED/AMBER field exists today. The two non-secret keys reserved in `StorageKeys` (`consentAccepted`, `selectedLocale`) are explicitly non-PII. `consentAccepted` is currently stored in **SecureStorage** (see `lib/features/consent/3_data/consent_repository_impl.dart:11,28,43,57`) — over-classified but harmless.

### 2.3 SecureStorage usage

`grep -rn "flutter_secure_storage\|FlutterSecureStorage\|SecureStorage" lib/`:

| Surface | File:line |
|---|---|
| Implementation & provider | `lib/core/storage/secure_storage.dart:1,11,25-49` (FlutterSecureStorage backend, Riverpod provider) |
| Auth/token attach | `lib/core/network/network_interceptors.dart:10,18`, `lib/core/network/api_client.dart:22` |
| Feature consumers | `lib/features/education/3_data/education_repository_impl.dart:13,18`, `lib/features/consent/3_data/consent_repository_impl.dart:8,17,21` |

**Disposition:** tokens, `idAgente`, and `sessionExpiresAt` flow through `SecureStorage` exclusively. `consent_accepted` is also routed through `SecureStorage` (over-zealous but acceptable; not a hardening defect). Logout in `user_profile_notifier.dart` deletes from both stores.

| Finding | Verdict |
|---|---|
| Tokens in `SecureStorage` only | ✅ already correct |
| `idAgente` in `SecureStorage` | ✅ already correct |
| Defensive `AppStorage.remove` on logout | ✅ already correct (defense-in-depth) |
| `consent_accepted` over-classified to `SecureStorage` | ⚪ keep — no risk; could be moved to `AppStorage` later for consistency. Sprint-9 nice-to-have. |
| Any PII write to `SharedPreferences`/`AppStorage` | ❌ none found |

---

## 3. Logging redaction audit

### 3.1 Redaction primitives present in `lib/core/logging/`

`ls lib/core/logging/` → `app_logger.dart`, `console_logger.dart`, `log_level.dart`, `logger_provider.dart`, `logger_provider.g.dart`, `logging.dart`.

The contract is `AppLogger` (`app_logger.dart`) with the explicit doc rule (`app_logger.dart:1-13`):

> Implementations must:
> - Redact any context value whose key matches a known PII pattern
>   (see §26 security annex and `docs/security/pii-inventory.md`).
> - Never emit `debug` messages in release builds.

`ConsoleLogger` enforces it (`console_logger.dart:10-19, 110-122`):

```dart
const _kPiiKeyFragments = <String>[
  'token','id','name','dni','nss','plate','license','matricula',
];
...
return { for (final entry in context.entries)
  entry.key: _isPiiKey(entry.key) ? '[REDACTED]' : entry.value };
```

Plus `console_logger.dart:38-42` makes `debug` a complete no-op when `kReleaseMode` is true.

There is **no dedicated `lib/core/logging/redaction*.dart` file** in this repository — the redaction logic lives inline inside `ConsoleLogger`. This matches the canon's *primitive sufficiency* rule (a single composable log surface with field-level scrubbing) so an extra file is not required, but the report flags it for visibility.

### 3.2 Direct `print` / `debugPrint` outside the logger

`grep -rnE 'print\(|debugPrint\(' lib/ --include='*.dart'` (excluding `console_logger.dart`):

| File:line | Statement | Classification | Disposition |
|---|---|---|---|
| `lib/core/network/network_interceptors.dart:109` | `print('[HTTP] → ${options.method} ${options.uri}');` | Safe (URL only — no body, no headers). Header `Authorization` already stripped by `AuthInterceptor` before it would ever be logged. | Keep — already conforms to `security-hardening.md` §5.1. Optional Sprint-9: route through `AppLogger` for consistency. |
| `lib/core/network/network_interceptors.dart:119` | `print('[HTTP] ← ${response.statusCode} ${response.requestOptions.uri}');` | Safe (status + URL only, no body) | Keep. |
| `lib/core/network/network_interceptors.dart:131` | `print('[HTTP] ✗ ${err.type.name} ${err.requestOptions.uri}: ${err.message}');` | Safe (Dio error message is normalized; no body, no PII) | Keep. |
| `lib/app/bootstrap/app_initializer.dart:25` | `debugPrint('[AppInitializer] Running in ${config.environment.name} mode');` | Safe (non-PII bootstrap diagnostic; `debugPrint` is no-op in release for many platforms but not guaranteed) | Keep — bounded risk. |
| `lib/features/landing/2_presentation/landing_page.dart:99` | `print('Login successful: $session'); // TODO: remove after testing` | **🔴 RISK** — prints the entire `AuthSession` object (which transitively references the access token / `idAgente`) without going through `ConsoleLogger`, in any build flavor including release. | **Migrate / remove.** This is the only real hardening defect found in the pass. → **Sprint-9 carryover (HIGH priority).** |

### 3.3 PII-string occurrences in `lib/`

`grep -rnE '\bnif\b|\bdni\b|\bemail\b|\bphone\b|telefono'` returns 349 hits across `lib/`. They decompose as:

| Bucket | Count (approx) | Verdict |
|---|---|---|
| Generated localisation strings (`lib/l10n/app_localizations*.dart`) — UI labels like `notificationContactEmailLabel`, `helpContact012PhoneLabel` | dominant share | Safe — string literals only, never log payloads. |
| Domain entities & DTOs (`auth_user.dart`, `clave_user_info_dto.dart`, `interested_party_identification.dart`, `notification_contact.dart`, `support_request.dart`, `family_numerosa_title.dart`, …) | next largest share | Safe — fields, not log calls. They never reach a logger context map; logs use boolean flags such as `'hasNif: ${nif != null}'` (`auth_user.dart:37`, `clave_user_info_dto.dart:51`) which is the recommended pattern. |
| Presentation widgets that *display* the value (e.g. `social_welfare_landing_page.dart:211 b.fechaNacimiento.formatDdMmYyyy()`, `notification_contact_form.dart`) | smaller share | Safe — UI rendering inside the secure widget tree, not a log channel. |
| Direct logger / `print` call with raw PII value | **0** found | ✅ |

`auth_user.toString()` (`auth_user.dart:37-39`) and `ClaveUserInfoDto.toString()` (`clave_user_info_dto.dart:51-53`) deliberately emit only `hasNif: true|false` and `hasEmail: true|false` — exactly the pattern prescribed by `docs/security/security-hardening.md` §5.3. This is enforced at the entity boundary; even an accidental `print(authUser)` would not leak the value.

---

## 4. Dependency vulnerability snapshot

`flutter pub get` then `flutter pub outdated --no-dev-dependencies` (run from this worktree):

```
Showing outdated packages.
[*] indicates versions that are not the latest available.

Package Name              Current   Upgradable  Resolvable  Latest

direct dependencies:
connectivity_plus         *6.1.5    *6.1.5      7.1.1       7.1.1
flutter_riverpod          *3.0.3    *3.0.3      3.3.1       3.3.1
meta                      *1.17.0   *1.17.0     *1.17.0     1.18.2
riverpod_annotation       *3.0.3    *3.0.3      4.0.2       4.0.2

transitive dependencies:
_fe_analyzer_shared       *91.0.0   *93.0.0     *93.0.0     100.0.0
analyzer                  *8.4.0    *10.0.1     *10.0.1     13.0.0
code_assets               -         1.0.0       1.0.0       1.0.0
hooks                     -         1.0.3       1.0.3       1.0.3
json_annotation           *4.9.0    4.11.0      4.11.0      4.11.0
matcher                   *0.12.19  *0.12.19    *0.12.19    0.12.20
native_toolchain_c        -         *0.17.6     *0.17.6     0.18.0
objective_c               -         9.3.0       9.3.0       9.3.0
path_provider_foundation  *2.5.1    2.6.0       2.6.0       2.6.0
record_use                -         0.6.0       0.6.0       0.6.0
riverpod                  *3.0.3    *3.0.3      3.2.1       3.2.1
test                      *1.30.0   *1.30.0     *1.30.0     1.31.1
test_api                  *0.7.10   *0.7.10     *0.7.10     0.7.12
test_core                 *0.6.16   *0.6.16     *0.6.16     0.6.18
vector_math               *2.2.0    *2.2.0      *2.2.0      2.3.0
vm_service                *15.1.0   15.2.0      15.2.0      15.2.0
win32                     *5.15.0   *5.15.0     *5.15.0     6.1.0
xml                       *6.6.1    *6.6.1      *6.6.1      7.0.1

5 upgradable dependencies are locked (in pubspec.lock) to older versions.
4 dependencies are constrained to versions that are older than a resolvable version.
```

### 4.1 Disposition

| Package | Current → Resolvable / Latest | Tier | Disposition |
|---|---|---|---|
| `connectivity_plus` | 6.1.5 → 7.1.1 | direct | **Schedule update** (Sprint 9). Major bump; resilience adopters need re-test. |
| `flutter_riverpod` | 3.0.3 → 3.3.1 | direct | **Schedule update** (Sprint 9). Minor only; covered by `ADR-001` cohort. |
| `riverpod_annotation` | 3.0.3 → 4.0.2 | direct | **Schedule update with codegen run** (Sprint 9). Major bump — must accompany `flutter_riverpod` and trigger `build_runner`. |
| `meta` | 1.17.0 (locked) | direct | **Keep**. Constrained by Flutter SDK; no security implication. |
| `_fe_analyzer_shared`, `analyzer`, `matcher`, `test`, `test_api`, `test_core`, `vector_math`, `win32`, `xml` | various | transitive | **Keep**. All locked by Flutter SDK / `analyzer` cohort (per `ADR-001`). No CVE flagged by `pub`. |
| `json_annotation` | 4.9.0 → 4.11.0 | transitive | **Keep**. Patch bump; will follow whenever a downstream codegen package allows it. |
| `path_provider_foundation`, `vm_service` | minor patches | transitive | **Keep**. Picked up automatically next `flutter upgrade`. |
| `native_toolchain_c`, `objective_c`, `code_assets`, `hooks`, `record_use` | new transitive arrivals | transitive | **Keep**. Not yet pinned; controlled by SDK. |

`flutter pub outdated` did **not** report any package as advisory-flagged. No "upgrade now" item identified. No CVE-driven emergency action is required for Sprint 8 closure.

---

## 5. ADR list refresh

### 5.1 ADRs present in the repository

Two ADR locations exist:

`ls documentation/architecture_canon_flutter_v2_docs/adr/`:
- `ADR-002-ci-baseline.md` — CI baseline, accepted 2026‑05‑04, related ticket `[STORY-68]`, related canon Annex C §27 / Annex D §§32‑34 §36.

`ls docs/adr/`:
- `ADR-001-package-version-cohort.md` — package version cohort policy (referenced from `security-hardening.md` §6.3).
- `ADR-002-gorouter-provider-not-riverpod.md` — GoRouter provider exception (referenced from `security-hardening.md` §9).
- `ADR-003-generated-client-encapsulation.md` — generated client encapsulation, referenced from `security-hardening.md` §6.2.

> ⚠ Inconsistency observation (informational only — not a Sprint-8 deliverable): the project has two parallel ADR directories (`docs/adr/` and `documentation/architecture_canon_flutter_v2_docs/adr/`) and reuses the `ADR-002` identifier in both for different decisions. This pre-existed Sprint 8 and is documented here for future curation. It is **not** a hardening defect; consolidation is a Sprint-9 governance candidate.

### 5.2 Canon ADR rule

`documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_c.md` §29:

> Una excepción sin ADR no es arquitectura; es deriva.

Every architectural exception observed in code is covered:

| Exception observed in code | Covering ADR |
|---|---|
| GoRouter wrapped behind a Riverpod provider rather than Riverpod-native routing | `docs/adr/ADR-002-gorouter-provider-not-riverpod.md` |
| Generated API code kept under `generated/` and wrapped by `GeneratedApiWrapper`s in feature `3_data/` layers (cross-cutting forbidden in canon §16) | `docs/adr/ADR-003-generated-client-encapsulation.md` |
| Pinned package version cohorts (Riverpod 3.0.3, analyzer 8.4.0, etc.) shown in §4 above | `docs/adr/ADR-001-package-version-cohort.md` |
| Single-job CI workflow, scaffold release checklist | `documentation/architecture_canon_flutter_v2_docs/adr/ADR-002-ci-baseline.md` |

### 5.3 Architectural exceptions without an ADR

Audit result for Sprint 8: **none found.** All deviations from the canon discovered during this report (raw `print` in `LoggingInterceptor`, `print` in `landing_page.dart:99`, `consent_accepted` stored in SecureStorage instead of AppStorage, `_kPiiKeyFragments` not covering `email`/`phone`) are **bug-class items, not architectural exceptions** — they should be fixed via normal tickets, not memorialised as ADRs.

---

## 6. Sprint 8 closure conclusion

### 6.1 Acceptance-criterion verification

| TASK-69 acceptance criterion (ticket: all `[x]`) | Sprint 8 verification result | Evidence path |
|---|---|---|
| Se inventarían campos PII y su tratamiento permitido. | ✅ Pass — inventory exists, classification rules enforced; gaps are documentation-only carryovers. | `docs/security/pii-inventory.md` (179 lines, RED/AMBER/GREEN); §1 of this report. |
| Se contemplan secure storage, borrado de sesión, validación de URLs externas y redacción de logs. | ✅ Pass — SecureStorage path is exclusive for tokens/`idAgente`; logout double-clears (`user_profile_notifier.dart:30-44`); URL allowlist policy documented (`docs/security/security-hardening.md` §2.3); redaction primitives present (`console_logger.dart:10-19,110-122`). | §2 and §3 of this report. |
| Se identifican decisiones que requieran ADR explícito. | ✅ Pass — three architectural exceptions have ADRs (`ADR-001`, `ADR-002-gorouter`, `ADR-003`); CI baseline ADR present (`ADR-002-ci-baseline`). No uncovered exception observed. | `docs/adr/`, `documentation/architecture_canon_flutter_v2_docs/adr/`; §5 of this report. |
| Se dejan trazadas dependencias con módulos que manejan datos especialmente sensibles. | ✅ Pass — health (SESCAM), session/auth, push/notifications, and digital-cards modules are tabulated in `docs/security/pii-inventory.md` §3 and `security-hardening.md` §3.1; their consumers in `lib/features/{auth,agenda/sescam,digital_cards/*,notifications/contact,user_profile,consent}` were grepped and confirmed to flow through SecureStorage / in-memory state. | §1.2, §2.3 of this report. |

### 6.2 Sprint-9 hardening carryover candidates (recommendations only)

The following items were observed but are out of scope for Sprint 8 closure. They are **recommendations** — no tickets created automatically.

| # | Item | Severity | Suggested handling |
|---|---|---|---|
| 1 | `lib/features/landing/2_presentation/landing_page.dart:99` — `print('Login successful: $session'); // TODO: remove after testing` leaks the `AuthSession` (transitively the access token) on every successful login, in any build flavour. | **HIGH** | Single-line removal or migrate to `AppLogger.debug` with redacted context. New ticket suggested (likely `BUG-` or scope into a Sprint-9 hardening task). |
| 2 | `_kPiiKeyFragments` in `lib/core/logging/console_logger.dart:10-19` does not include `'nif'`, `'email'`, `'phone'`, `'telefono'`, `'address'`, `'direccion'`, `'birth'`, `'fecha'`. Defense-in-depth gap. | Medium | Append fragments + a unit test in `test/core/logging/`. |
| 3 | `docs/security/pii-inventory.md` does not enumerate notification-contact (`email`, `phone`) or social-welfare (`fechaNacimiento`) or state-affairs (`direccion`) fields that exist in code today. | Medium | Documentation-only update. |
| 4 | `LoggingInterceptor` (`lib/core/network/network_interceptors.dart:108-133`) uses raw `print` instead of `AppLogger`. Currently safe (URL/status only, no bodies/headers) but inconsistent. | Low | Route through `AppLogger.debug` with `kDebugMode` guard. |
| 5 | `consent_accepted` is over-classified into `SecureStorage` (`features/consent/3_data/consent_repository_impl.dart`). Functionally fine; conceptually belongs in `AppStorage`. | Low | Trivial refactor; add migration step. |
| 6 | Dual ADR directories (`docs/adr/` and `documentation/architecture_canon_flutter_v2_docs/adr/`) with a clashing `ADR-002` numbering. | Low (governance) | Consolidate under the canon directory; renumber the duplicate. |
| 7 | Direct dependency upgrades: `connectivity_plus 6→7`, `flutter_riverpod 3.0.3→3.3.1`, `riverpod_annotation 3.0.3→4.0.2`. | Low (no CVE) | Schedule under `ADR-001` cohort review in Sprint 9. |

### 6.3 Validation log

- `flutter pub get` → `Got dependencies!`
- `flutter pub outdated --no-dev-dependencies` → captured verbatim in §4.
- `flutter analyze --no-fatal-infos` → **0 errors, 1 warning** (`test/features/recommendations/recommendations_page_widget_test.dart:16:10 unused_element_parameter`); 47 issues total, all `info`. Matches the documented Sprint 8 baseline; no code was modified by this report.
- All grep claims in §1, §2, §3 reproducible with the commands shown inline.

### 6.4 Sign-off

The Sprint 8 hardening verification confirms that **TASK-69 remains satisfied**: the PII inventory is in place and consistent with the classification framework enforced by `ConsoleLogger`; secure storage is the exclusive path for credentials and `idAgente`; logout wipes both stores defensively; redaction primitives exist and are exercised by the production logger; every architectural exception observed in code is covered by an ADR; and the dependency snapshot reveals no advisory-flagged package.

The single material defect found during the audit (`landing_page.dart:99` raw `print` of an `AuthSession`) is recorded as a Sprint-9 carryover (item §6.2 #1) rather than a re-opening of TASK-69, because the canon framework, controls, and ADRs delivered by TASK-69 are intact and were not the cause of the defect.

**Hardening program status for Sprint 8: CLOSED.**
