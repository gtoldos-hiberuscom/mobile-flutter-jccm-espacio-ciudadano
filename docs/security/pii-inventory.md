# PII Field Inventory — Carpeta Ciudadana CLM (JCCM Espacio Ciudadano)

**Document version:** 1.0  
**Date:** 2025-07-14  
**Status:** Active  
**Owner:** Platform / Security team  

---

## 1. Purpose

This document catalogues every Personally Identifiable Information (PII) field handled by the
application, assigns a sensitivity classification, and defines the treatment rules that govern
logging, caching, storage, and analytics usage.

All development must be consistent with this inventory.  Any new field that qualifies as PII must
be added here before it appears in production code.

---

## 2. Classification levels

| Level | Label | Meaning |
|-------|-------|---------|
| 🔴 RED | Highly sensitive | Must never appear in logs, analytics events, crash reports, or local storage except `SecureStorage`. |
| 🟡 AMBER | Sensitive | May appear in structured logs only when explicitly redacted using the `[REDACTED]` placeholder. |
| 🟢 GREEN | Non-sensitive | Non-identifying metadata (e.g., generic error codes, timestamps). May appear in logs. |

---

## 3. PII field inventory by domain

### 3.1 Session / Authentication

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| `accessToken` | JWT string | 🔴 RED | Bearer token for API access. Never log, never persist outside `SecureStorage`. |
| `refreshToken` | JWT string | 🔴 RED | Used to renew `accessToken`. Same restrictions as `accessToken`. |
| `idAgente` | String (internal ID) | 🔴 RED | Unique agent identifier tied to authenticated citizen. |
| User display name | String | 🟡 AMBER | May be displayed in UI; must not appear in logs or analytics. |

### 3.2 Health — SESCAM

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| Patient ID / CIP | String | 🔴 RED | Personal health identifier. Never log, never cache outside session. |
| Medical history numbers | String | 🔴 RED | Links to clinical records. Never log or cache. |
| Appointment data | Structured object | 🔴 RED | Includes date, time, speciality, and clinician name. Never log full object. |
| Diagnostic / treatment data | Any | 🔴 RED | If ever surfaced, treat as RED. |

### 3.3 Catastro (Land Registry)

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| Cadastral reference | String | 🟡 AMBER | Identifies a specific property. Log as `[REDACTED]`. |
| Property assessed value | Decimal | 🟡 AMBER | Financial data. Log as `[REDACTED]`. |
| Property address | String | 🟡 AMBER | May reveal home address. Log as `[REDACTED]`. |

### 3.4 DGT (Traffic Authority)

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| Vehicle plate number | String | 🟡 AMBER | Linked to identity. Log as `[REDACTED]`. |
| Driving licence number | String | 🟡 AMBER | Linked to identity. Log as `[REDACTED]`. |
| Points balance | Integer | 🟡 AMBER | May reveal infraction history. Log as `[REDACTED]`. |

### 3.5 SEPE (State Employment Service)

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| Unemployment benefit amount | Decimal | 🟡 AMBER | Financial PII. Log as `[REDACTED]`. |
| Work history records | Structured object | 🟡 AMBER | Employment timeline. Log as `[REDACTED]`. |
| Social Security number | String | 🔴 RED | High-sensitivity national identifier. Never log or cache. |

### 3.6 INE Census

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| Census registration data | Structured object | 🟡 AMBER | Residential and household data. Log as `[REDACTED]`. |
| Household composition | Structured object | 🟡 AMBER | Family structure data. Log as `[REDACTED]`. |

### 3.7 Digital Cards

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| National ID number (DNI/NIE) | String | 🔴 RED | Primary national identifier. Never log or cache outside `SecureStorage`. |
| QR code payload | String | 🔴 RED | May encode national ID or medical data. Never log. |
| Card expiry date | Date | 🟡 AMBER | Indirectly linked to identity. Log as `[REDACTED]`. |

### 3.8 Life Events (Hechos Vitales)

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| Birth certificate data | Structured object | 🟡 AMBER | Name, date, place of birth. Log as `[REDACTED]`. |
| Death certificate data | Structured object | 🟡 AMBER | Name, date, place of death. Log as `[REDACTED]`. |
| Family registration data | Structured object | 🟡 AMBER | Household linkages. Log as `[REDACTED]`. |

### 3.9 Documents (Electronic Office)

| Field | Type | Classification | Notes |
|-------|------|---------------|-------|
| PDF document content | Binary / base64 | 🟡 AMBER | May contain any PII. Never log body — log only document ID and size. |
| Document metadata | Structured object | 🟡 AMBER | Document title, submission date, type. Log only `documentId` and `type`. |

---

## 4. Treatment rules

### 4.1 RED fields

- **Logging:** Must NOT appear in any log entry, Crashlytics breadcrumb, Firebase Analytics event,
  or HTTP request/response body logged by `LoggingInterceptor`.
- **Storage:** May only be stored in `SecureStorage` (FlutterSecureStorage with AES encryption).
  Never store in `AppStorage` (SharedPreferences) or in-memory state that survives session.
- **Network:** Transmitted only over HTTPS.  Authorization headers must be stripped from logs by
  `AuthInterceptor` before the log entry is written.
- **Analytics:** Never send RED fields as analytics event parameters.
- **Crash reports:** Strip or anonymise before attaching diagnostic data to crash reports.

### 4.2 AMBER fields

- **Logging:** Permitted in structured logs only when the field value is replaced with
  `[REDACTED]` before the log call.  Example:
  ```dart
  log.debug('Fetching catastral data for ref=[REDACTED]');
  ```
- **Storage:** Must not be written to `AppStorage`.  May be held in ephemeral in-memory state
  (Riverpod providers) within a session.  Cleared on logout.
- **Analytics:** Must not be sent as raw values.  Aggregate or anonymised metrics are acceptable.
- **Crash reports:** Include only anonymised identifiers, never raw field values.

### 4.3 GREEN fields

- No restrictions beyond standard engineering best practices.

---

## 5. Storage assignment rules

| Data | Storage mechanism | Rationale |
|------|-------------------|-----------|
| `accessToken` | `SecureStorage` | AES-encrypted Keychain / Keystore |
| `refreshToken` | `SecureStorage` | Same as `accessToken` |
| `idAgente` | `SecureStorage` | Tied to authenticated identity |
| User preferences (theme, language) | `AppStorage` (SharedPreferences) | Non-PII |
| Feature flags, last-viewed screen | `AppStorage` | Non-PII |
| Any health, financial, or census data | **Not persisted locally** | Session memory only |

**Rule:** No PII may be written to `AppStorage` under any circumstances.

---

## 6. Session lifecycle and data clearing

| Event | Required action |
|-------|----------------|
| Logout (user-initiated) | Call `SecureStorage.deleteAll()` AND clear user-context keys from `AppStorage`. |
| 401 Unauthorized from API | Trigger session expiry via `ErrorInterceptor`, redirect to landing screen. |
| App goes to background | No additional clearing required; OS protection is sufficient. |
| App foreground after long inactivity | Re-validate session via `refreshToken`; if expired, force logout. |

---

## 7. Responsibilities

| Role | Responsibility |
|------|---------------|
| Feature developer | Must classify any new field and add it to this document before merging. |
| Reviewer | Must verify PII classification and storage assignment in PR review. |
| Platform team | Owns this document and the security guidelines in `docs/security/security-hardening.md`. |

---

## 8. References

- [Security Hardening Guidelines](./security-hardening.md)
- [ADR-001 — Package version cohort](../adr/ADR-001-package-version-cohort.md)
- [ADR-003 — Generated client encapsulation](../adr/ADR-003-generated-client-encapsulation.md)
- Architecture canon: `documentation/architecture_canon_flutter_v2_docs/` — Annex C, section 24 (Security)
