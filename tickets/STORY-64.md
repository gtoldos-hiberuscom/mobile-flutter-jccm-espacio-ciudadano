---
id: 64
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 1
reporter:
assignee:
story_points:
labels:
  - observabilidad
  - analytics
  - logging
  - pii
  - monitoring
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-09-21T18:00:00+02:00
due_date:
jira_url:
---
# [STORY-64] Observabilidad, analytics y logging con redacción de PII
## Functional Description
Definir la base de analítica, trazas y monitoring sin exponer datos sensibles del ciudadano, contemplando eventos clave de navegación, errores relevantes, descargas y enlaces externos, junto con una política explícita de redacción de PII.

## Acceptance Criteria
- [x] Se contempla logging estructurado y redactado.
- [x] Se contemplan eventos/telemetría para navegación principal, descargas, enlaces externos y errores relevantes.
- [x] Se contempla monitoring/crash reporting sin fuga de PII.
- [x] Se contempla preparación operativa para evolución futura, incluidas capacidades de notificación/push cuando proceda.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
    - [STORY-14]
    - [TASK-69]
  - Blocks:
    - [STORY-67]
    - [STORY-68]
  - Related to:
    - [EPIC-10]
- Observability scope:
  - Logging estructurado con redacción de identificadores o datos sensibles.
  - Telemetría de navegación principal, descargas, errores y enlaces externos.
  - Crash reporting/monitoring con exclusión de PII.
  - Preparación de eventos reutilizables para evolución operativa futura.
- Security considerations:
  - La política de PII y hardening se alinea con [TASK-69].
  - Debe evitarse fuga de datos en eventos, breadcrumbs o payloads de error.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §§24 y 26
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 13
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N3
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-12], [STORY-14] y [TASK-69].
  - Blocks [STORY-67] y [STORY-68].
  - Aporta la base de observabilidad transversal del epic [EPIC-10].

## Notes
### Comments
- None yet.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Formalizing Done status: STORY-64 was already internally marked Done in the change log of an earlier draft; this entry reconciles the ticket against the merged implementation on `develop`. Evidence: `lib/core/logging/` (`app_logger.dart`, `console_logger.dart`, `log_level.dart`, `logger_provider.dart`) provides structured PII-redacted logging; `lib/core/analytics/` (`analytics_service.dart`, `analytics_event.dart`, `console_analytics_service.dart`, `analytics_provider.dart`) provides navigation/error/external-link telemetry events and the crash-reporting hook readiness for future evolution; `lib/app/observers/analytics_observer.dart` wires navigation telemetry into the app shell. Implementing commit: `9ba4b8d`.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T01:35:57+02:00 | by plan-manager | Ticket moved to In Progress — Sprint 1 execution started.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Status transitioned from `In Progress` → `Done` after reconciling against merged implementation on `develop`.

### Sprint 8 closure
- 2026-08-25T12:00:00+02:00 | by plan-manager | Sprint 8 (SP-EC-APP-SQ3-08) closure: Telemetry verification with PII-redaction spot-check.
  - Branches: `task/EPIC-10-quality-release/STORY-64-observability/sprint8-telemetry-verification` (commit `cea4295`) → `ticket/EPIC-10-quality-release/STORY-64-observability` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - Report: `documentation/qa/STORY-64-telemetry-verification-sprint8.md` (10 AnalyticsEvent subclasses enumerated; emission sites mapped to AnalyticsObserver; KPI mapping per event family).
    - New regression test: `test/qa/telemetry_redaction_test.dart` (5 cases: emission ×2, contract guard against future toString overrides, setCurrentScreen trust boundary, ConsoleLogger context-map redaction).
    - Finding: telemetry safety today rests on three implicit properties — events carry only stable identifiers (no PII fields), no subclass overrides toString (so console emission renders 'Instance of <Type>'), and kReleaseMode short-circuits emission. ConsoleLogger._redact is the only active redaction path and applies to structured logs, not analytics payloads.
    - Sprint-9 carryovers (recommendations only, no tickets): field-level analytics redaction wrapper before wiring real SDK (Firebase Analytics reads fields directly, bypassing toString); replace setCurrentScreen String arg with allow-listed slug enum; pin telemetry_redaction_test.dart in CI critical path; add release-mode no-op assertion test.
  - Validation: `flutter analyze --no-fatal-infos` 0 errors / 1 pre-existing warning. `flutter test` 445 passing + 1 perf skip (440 baseline + 5 new telemetry cases).
  - Status unchanged (Done). Ticket Notes-only update per Sprint 8 closure policy.

### Sprint 9 closure
- 2026-09-21T18:00:00+02:00 | by plan-manager | Sprint 9 (SP-EC-APP-SQ3-09) closure: telemetry continuation (Deliverable F).
  - Branch: `task/EPIC-10-quality-release/STORY-64-observability/sprint9-screen-enum-and-redaction-wrapper` (commits `bf9a515`, `275e146`, `4283a0a`) → `ticket/EPIC-10-quality-release/STORY-64-observability` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence — Field-level analytics redaction wrapper (Sprint-8 carryover #1):
    - `lib/core/security/pii_key_fragments.dart` (new) — single source of truth for `piiKeyFragments`, `redactedMarker` and the `redactFields(Map)` helper. `lib/core/logging/console_logger.dart` now delegates its redaction to the new module (no behavioural change to existing logs).
    - `lib/core/analytics/redacted_analytics_service.dart` (new) — decorator wrapping any `AnalyticsService`. Adapters that, in the future, read `AnalyticsEvent` fields directly (e.g., a Firebase Analytics adapter that bypasses `toString()`) MUST go through this wrapper. Default `AnalyticsEventFieldExtractor` is a no-op shield (returns `const {}`); custom extractors get their output redacted via `redactFields` before reaching the wrapped service.
    - Test `test/core/analytics/redacted_analytics_service_test.dart` (3 cases): no-op default, custom extractor with PII keys (`userDni`, `idAgente`) redacted to `[REDACTED]` while benign `screen` field passes through, and screen forwarding.
  - Evidence — Allow-listed screen slug enum (Sprint-8 carryover #2):
    - `lib/core/analytics/analytics_screen.dart` (new) — sealed enum mirroring `Routes` 1:1 with an `unknown` sentinel. `AnalyticsScreen.fromRoute(String? routeName)` returns `unknown` for any unrecognised path.
    - `AnalyticsService.setCurrentScreen` signature changed from `String` to `AnalyticsScreen`. `ConsoleAnalyticsService`, `AnalyticsObserver`, and the `_RecordingAnalytics` test stub in `test/features/external_links/external_link_launcher_test.dart` updated. `AnalyticsObserver` now takes an `AppLogger` dependency and emits a `warning` (then skips the call) for unknown routes — never pollutes the backend.
    - `test/qa/telemetry_redaction_test.dart` Line ~140 leak-surface case rewritten as a positive compile-time-guard assertion: `AnalyticsScreen.fromRoute('/profile/<NIF>')` returns `unknown`; the API can no longer accept a free-form string.
  - Evidence — Release-mode no-op assertion (Sprint-8 carryover #4):
    - `ConsoleAnalyticsService` now accepts an injected `bool releaseMode = kReleaseMode` for testability.
    - Test `test/core/analytics/analytics_observer_release_noop_test.dart` (2 cases) uses a strict logger that fails on any emission to assert zero log calls when `releaseMode: true`; complementary debug-mode case confirms the control path still emits.
  - Cross-deliverable note (NIF/CIF/NIE coverage): the implementer of F intentionally restricted PII-key examples to `userDni` (matches `dni`) and `idAgente` (matches `id`) because the fragment list at the time was unchanged. Sprint-9 deliverable C (TASK-69) extended `_kPiiKeyFragments` with `nif`, `email`, `phone`, `telefono`, `address`, `direccion`, `birth`, `nacimiento`. Once both task branches integrate via the epic branch, the F redaction wrapper automatically picks up the extended fragment list (single source of truth in `lib/core/security/pii_key_fragments.dart`). The merge of C and F at the epic level produced a structural conflict in the fragment list / `console_logger.dart` that the plan-manager resolved by keeping F's extracted module structure with the union of both fragment sets.
  - Validation:
    - `flutter analyze --no-fatal-infos` — 0 errors / 1 pre-existing warning (unchanged baseline).
    - `flutter test` — 453 passing + 1 perf skip on this branch base (5 new analytics cases over the 448+1 base).
    - `dart format --set-exit-if-changed` clean for touched files.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 9 closure policy.
