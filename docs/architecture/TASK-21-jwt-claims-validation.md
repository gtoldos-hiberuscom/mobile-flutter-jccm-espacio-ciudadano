# TASK-21 — JWT Claims Validation: Contract Document

**Epic:** EPIC-2 — Identity & Session  
**Task:** TASK-21 — Validar claims JWT, `idAgente` y parámetros federados  
**Status:** Discovery / Documentation (Sprint 2 gate)  
**Last updated:** 2026-05-01

---

## 1. Purpose

This document formalises the JWT claims contract required by the Cl@ve OIDC integration in `jccm_espacio_ciudadano`.  
It is the single source of truth for:

- which claims must be present in the **id\_token** returned by Cl@ve,
- how those claims map to the `Session` entity and `JwtClaims` helper,
- what happens when a claim is absent or the token is invalid, and
- what prerequisite confirmations must be obtained before implementing real OIDC token exchange.

---

## 2. Cl@ve OIDC Context

Cl@ve is the Spanish national electronic identity federation operated by SGAD (Secretaría General de Administración Digital).  
The app integrates with Cl@ve via the standard **OpenID Connect Authorization Code flow**:

```
User → App (initiateClaveLogin) → Browser → Cl@ve IdP
         ← deep-link callback (code param) ← Cl@ve IdP
App → POST /token (code) → Cl@ve token endpoint
         ← { id_token, access_token, [refresh_token] }
App decodes id_token → JwtClaims → Session
```

The Sprint 1 implementation in `AuthRepositoryImpl.handleCallback()` returns a **mock session**.  
This document defines what the real Sprint 2 implementation must validate.

---

## 3. Required Cl@ve OIDC Claims

### 3.1 Mandatory claims (validation gate — reject token if absent/invalid)

| Claim | Type | Source (JWT section) | Description |
|---|---|---|---|
| `sub` | `String` | id\_token payload | Subject — opaque user identifier assigned by Cl@ve |
| `iss` | `String` | id\_token payload | Issuer URL of the Cl@ve IdP; must match discovery endpoint's `issuer` field |
| `aud` | `String` or `List<String>` | id\_token payload | Audience; **must contain the app's registered `client_id`** |
| `exp` | `int` (Unix epoch) | id\_token payload | Expiry timestamp; token is invalid if `now > exp` |
| `iat` | `int` (Unix epoch) | id\_token payload | Issued-at timestamp; used for clock-skew validation |

### 3.2 Identity claims (required for `Session` construction)

| Claim | Type | Required? | Maps to |
|---|---|---|---|
| `nif` | `String` | Preferred (may be `idAgente`) | `Session.idAgente` (primary) |
| `idAgente` | `String` | Fallback if `nif` absent | `Session.idAgente` (secondary) |
| `given_name` | `String` | Preferred | `Session.displayName` (prefix) |
| `family_name` | `String` | Preferred | `Session.displayName` (suffix) |
| `cn` | `String` | Fallback display name | `Session.displayName` when given/family absent |
| `email` | `String` | Optional | `Session` extension field (future use) |

> **Note on `nif` vs `idAgente`:** Cl@ve documentation refers to the national identity number  
> using the claim name `nif` in test environments and `idAgente` in some federation profiles.  
> The exact claim name **must be confirmed** against the Cl@ve sandbox metadata  
> (see Section 5 — Validation Checklist).

---

## 4. Claims Mapping to `Session` Entity

```
id_token payload  →  JwtClaims  →  Session
─────────────────────────────────────────────────────
sub               →  sub         →  idAgente (fallback only)
nif / idAgente    →  nif         →  Session.idAgente  (primary)
  fallback: if nif == null → use sub
given_name +
family_name       →  givenName,
                     familyName  →  Session.displayName
  fallback: if both null → use cn ?? sub
exp               →  exp         →  Session.expiresAt
                                    (DateTime.fromMillisecondsSinceEpoch(exp * 1000))
aud               →  aud         →  validateAudience(appClientId) gate
```

### 4.1 `JwtClaims` helper (see `lib/core/auth/jwt_claims.dart`)

```dart
final claims = JwtDecoder.decode(idToken);

// Audience gate — reject if false
if (!claims.validateAudience(appClientId)) { /* reject */ }

// Expiry gate — reject if true
if (claims.isExpired) { /* reject */ }

// Map to Session
final session = Session(
  accessToken:  accessToken,       // from token endpoint response
  refreshToken: refreshToken,      // optional from response
  idAgente:     claims.idAgente,   // nif ?? sub
  displayName:  claims.displayName,// givenName + familyName, or cn, or sub
  expiresAt:    DateTime.fromMillisecondsSinceEpoch(claims.exp * 1000, isUtc: true),
  claims:       claims.aud,        // or extract scope list from access_token
);
```

---

## 5. Missing / Ambiguous Claims — Fallback Strategy

| Scenario | Fallback Behaviour | Risk |
|---|---|---|
| `nif` claim absent | Use `sub` as `idAgente` | Sub is opaque; downstream services expecting NIF will fail silently |
| `given_name` absent | Use `cn` if present, else `sub` as display name | Poor UX; `sub` is meaningless to user |
| `family_name` absent but `given_name` present | Display `given_name` only | Acceptable |
| `exp` field missing or non-integer | Treat token as immediately expired → reject | Hard failure; user must re-authenticate |
| `aud` missing or does not contain `client_id` | Reject token | Hard failure; possible wrong IdP endpoint |
| Token body not valid JSON | `JwtDecoder.decode()` returns `JwtClaims` with all-null optional fields | Hard failure at audience/expiry gate |
| JWT signature invalid | **Not validated client-side** (by design). Server must validate. See Section 7. | Architecture decision — document as ADR if needed |

---

## 6. Validation Checklist (Sprint 2 Implementation Gate)

The following items **must be confirmed** before replacing the mock session with real OIDC exchange:

- [ ] **Cl@ve OIDC discovery endpoint URL confirmed**  
  Expected: `https://clave-dninbid.gob.es/clave2/.well-known/openid-configuration` (sandbox)  
  Action: fetch and validate `issuer`, `token_endpoint`, `jwks_uri` fields.

- [ ] **Client ID and redirect URI registered in Cl@ve sandbox**  
  Action: confirm registration with SGAD; record `client_id` in `AppConfig` (not hardcoded).

- [ ] **`nif` / `idAgente` claim name confirmed by Cl@ve IdP documentation**  
  Action: obtain sandbox id\_token, inspect payload, confirm exact field name.  
  Update `JwtClaims.fromMap()` accordingly.

- [ ] **JWT signature verification algorithm confirmed (RS256 expected)**  
  Action: fetch `jwks_uri` from discovery doc, confirm `alg: RS256` in JWKS.  
  Note: client-side signature verification is intentionally deferred to backend proxy.

- [ ] **Token exchange endpoint URL confirmed (`code` → `access_token` + `id_token`)**  
  Action: confirm `token_endpoint` URL and required POST parameters (`grant_type`,  
  `code`, `client_id`, `client_secret` or PKCE `code_verifier`, `redirect_uri`).

- [ ] **`AppConfig` has `claveClientId` and `claveTokenEndpoint` fields**  
  Action: add to `config_development.json`, `config_preproduction.json`,  
  `config_production.json` and the `AppConfig` class.

---

## 7. Architecture Decisions

### 7.1 Client-side JWT signature verification

**Decision:** The app does **not** verify JWT signatures client-side.  
**Rationale:**  
- Cl@ve tokens are transmitted over HTTPS; transport integrity is assured.  
- The JWKS public-key rotation lookup adds latency and complexity.  
- The backend API proxy already validates tokens server-side before responding.  
- `JwtDecoder` exists to *extract* claims for display and routing, not for security enforcement.

**Risk:** A locally modified id\_token could be decoded without rejection.  
**Mitigation:** All sensitive operations are gated by backend validation; the app never  
trusts client-decoded claims for authorisation decisions beyond UI routing.

---

## 8. Dependent Stories Unblocked by TASK-21

| Story | Title | Blocking claim |
|---|---|---|
| **STORY-18** | Final Cl@ve integration (real OIDC exchange) | All Section 5 checklist items |
| **STORY-45** | Afirma / firma electrónica | `idAgente` (NIF) required as signer identifier |
| **STORY-54** | Hechos vitales — datos personales | `given_name`, `family_name`, `nif` |
| **STORY-56** | Recomendaciones personalizadas | `sub` or `nif` for profile lookup |

---

## 9. Related Artefacts

| Artefact | Location |
|---|---|
| `JwtClaims` helper | `lib/core/auth/jwt_claims.dart` |
| `JwtDecoder` utility | `lib/core/auth/jwt_decoder.dart` |
| Mock session (Sprint 1) | `lib/features/auth/3_data/auth_repository_impl.dart` → `handleCallback()` |
| `Session` entity | `lib/features/auth/0_entity/session.dart` |
| TASK-16 OpenAPI strategy | `docs/architecture/TASK-16-openapi-adaptation-strategy.md` |
| TASK-21 ticket | `tickets/TASK-21.md` |
