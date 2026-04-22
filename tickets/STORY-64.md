---
id: 64
jira_key:
type: Story
status: In Progress
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
updated_at: 2026-04-22T01:35:57+02:00
due_date:
jira_url:
---
# [STORY-64] Observabilidad, analytics y logging con redacción de PII
## Functional Description
Definir la base de analítica, trazas y monitoring sin exponer datos sensibles del ciudadano, contemplando eventos clave de navegación, errores relevantes, descargas y enlaces externos, junto con una política explícita de redacción de PII.

## Acceptance Criteria
- [ ] Se contempla logging estructurado y redactado.
- [ ] Se contemplan eventos/telemetría para navegación principal, descargas, enlaces externos y errores relevantes.
- [ ] Se contempla monitoring/crash reporting sin fuga de PII.
- [ ] Se contempla preparación operativa para evolución futura, incluidas capacidades de notificación/push cuando proceda.

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

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T01:35:57+02:00 | by plan-manager | Ticket moved to In Progress — Sprint 1 execution started.
