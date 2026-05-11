---
id: 69
jira_key: JCCMEC-68
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-32
parent: JCCMEC-32
sprint: Tablero Sprint 1
reporter:
assignee:
story_points:
labels:
  - seguridad
  - pii
  - adr
  - hardening
  - cumplimiento
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:25:30+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-68
---
# [TASK-69] Inventario PII, hardening de seguridad y ADRs de excepción al canon
## Functional Description
Cerrar el marco de seguridad del proyecto y cualquier excepción arquitectónica necesaria, inventariando PII, reglas de tratamiento permitido y decisiones explícitas de hardening o ADR cuando el canon requiera una excepción documentada.

## Acceptance Criteria
- [x] Se inventarían campos PII y su tratamiento permitido.
- [x] Se contemplan secure storage, borrado de sesión, validación de URLs externas y redacción de logs.
- [x] Se identifican decisiones que requieran ADR explícito.
- [x] Se dejan trazadas dependencias con módulos que manejan datos especialmente sensibles.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
    - [STORY-19]
  - Blocks:
    - [STORY-64]
    - [STORY-65]
    - [STORY-68]
  - Related to:
    - [EPIC-10]
- Security scope:
  - Inventario de PII y reglas de tratamiento permitido.
  - Secure storage, borrado de sesión y validación de URLs externas.
  - Redacción de logs y límites de exposición en observabilidad.
  - Identificación de decisiones que requieran ADR.
- Expected outcome:
  - Base de gobierno para observabilidad, resiliencia y release.
  - Dependencias claras con módulos que manejan datos sanitarios, sesión o push.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §24
  - copilot-instructions forbidden shortcuts
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md datos sanitarios/sesión/push
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-12] y [STORY-19].
  - Blocks [STORY-64], [STORY-65] y [STORY-68].
  - Fija el marco de seguridad y excepciones del epic [EPIC-10].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T12:00:00+02:00 | status | In Progress -> Done | by Copilot

### Sprint 8 closure
- 2026-08-25T12:00:00+02:00 | by plan-manager | Sprint 8 (SP-EC-APP-SQ3-08) closure: Hardening program final pass — PII inventory, storage, logging, dependencies, ADRs.
  - Branches: `task/EPIC-10-quality-release/TASK-69-pii-hardening/sprint8-hardening-final-pass` (commit `1132853`) → `ticket/EPIC-10-quality-release/TASK-69-pii-hardening` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - Report: `documentation/security/TASK-69-hardening-final-report.md` (281 lines, evidence-based).
    - PII inventory (`docs/security/pii-inventory.md`) confirmed current vs implemented features.
    - Storage audit: `flutter_secure_storage` used for tokens/idAgente/sessionExpiresAt; `SharedPreferences` carries no PII.
    - Logging redaction: `ConsoleLogger._redact` substring-matches PII fragments (`token|id|name|dni|nss|plate|license|matricula`); `debug` is no-op in release.
    - Dependency snapshot via `flutter pub outdated --no-dev-dependencies` captured; no CVEs; 3 direct-dep major bumps queued for Sprint 9.
    - ADR list refreshed; every architectural exception has an ADR.
    - Sprint-9 carryover (recommendation, no ticket): HIGH-severity `print('Login successful: $session')` at `lib/features/landing/2_presentation/landing_page.dart:99` leaks the AuthSession object to stdout in debug mode.
  - Validation: `flutter analyze --no-fatal-infos` 0 errors / 1 pre-existing warning. No code touched.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 8 closure policy.

### Sprint 9 closure
- 2026-09-21T18:00:00+02:00 | by plan-manager | Sprint 9 (SP-EC-APP-SQ3-09) closure: hardening continuation (Deliverable C).
  - Branch: `task/EPIC-10-quality-release/TASK-69-pii-hardening/sprint9-pii-and-adr-consolidation` (commits `9b6546e`, `f518a70`, `9dea57b`) → `ticket/EPIC-10-quality-release/TASK-69-pii-hardening` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - `lib/core/network/network_interceptors.dart` — `LoggingInterceptor` no longer `const`; takes injected `AppLogger`; `print(...)` calls replaced with `info` / `warning` carrying URL/method/status as `context` map values (existing redaction layer applies).
    - `lib/core/network/api_client.dart` + `api_client_provider.dart` — `buildDioClient` now requires `AppLogger`; the Riverpod `dioProvider` resolves `appLoggerProvider` and forwards it.
    - `lib/core/logging/console_logger.dart` — `_kPiiKeyFragments` extended (per Sprint-9 brief): added `nif`, `email`, `phone`, `telefono`, `address`, `direccion`, `birth`, `nacimiento`. Bucketed comments updated.
    - `docs/security/pii-inventory.md` — added `nif` and `email` rows in §3.1, `fechaNacimiento` row in §3.8, new sections §3.10 (notifications/contact) and §3.11 (state affairs/cadastral residence).
    - ADR consolidation: three legacy ADRs in `docs/adr/` migrated under canon path `documentation/architecture_canon_flutter_v2_docs/adr/` via `git mv` (history preserved). The gorouter ADR was renamed to `ADR-004-gorouter-provider-not-riverpod.md` to avoid the numbering collision with the existing canon `ADR-002-ci-baseline.md`. Stub `docs/adr/README.md` now points to the canon location; new minimal `documentation/architecture_canon_flutter_v2_docs/adr/README.md` index added. Inbound links in `docs/security/` rewritten.
    - Decisions documented in commit bodies: (1) security docs left at `docs/security/` because the canon index is silent on a mandated path; the historical Sprint-8 hardening report under `documentation/security/` was kept as a fixed-point artefact and intentionally not rewritten. (2) ADR-002 numbering collision resolved by renumbering the moved gorouter ADR to ADR-004.
  - Validation:
    - `flutter analyze --no-fatal-infos` — 0 errors / 1 pre-existing warning (unchanged baseline).
    - `flutter test` — 448 + 1 perf skip on this branch base; targeted `test/qa/telemetry_redaction_test.dart` 5/5 passing (extended fragment list does not break the redaction contract).
    - `dart format --set-exit-if-changed` clean for touched files.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 9 closure policy.
