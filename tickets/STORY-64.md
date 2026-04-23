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
updated_at: 2026-05-04T12:00:00+02:00
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
