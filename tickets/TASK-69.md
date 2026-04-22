---
id: 69
jira_key:
type: Task
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
  - seguridad
  - pii
  - adr
  - hardening
  - cumplimiento
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T12:00:00+02:00
due_date:
jira_url:
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
