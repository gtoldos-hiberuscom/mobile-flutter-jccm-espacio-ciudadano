---
id: 21
jira_key:
type: Task
status: To Do
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
reporter:
assignee:
story_points:
labels:
  - auth
  - jwt
  - federation
  - discovery
  - api-contract
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [TASK-21] Validar claims JWT, idAgente y parámetros federados obligatorios
## Functional Description
Obtener o formalizar la matriz real de claims/parámetros necesarios para Cl@ve, servicios federados, hechos vitales y firma.

## Acceptance Criteria
- [ ] Se documentan claims necesarios para servicios federados, firma e idAgente.
- [ ] Se identifican faltantes, fallback y comportamiento cuando el token no contiene datos esperados.
- [ ] Se dejan trazadas las dependencias bloqueadas por falta de formalización.
- [ ] Se vincula el resultado con recomendaciones, hechos vitales y firma.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
    - [STORY-18]
  - Blocks:
    - [STORY-45]
    - [STORY-54]
    - [STORY-56]
  - Related to:
    - [EPIC-2]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md S2/N6 y S1/N10
  - MAPEO_ENDPOINTS_PANTALLAS.md integración Cl@ve
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 12
- Provisional hierarchy:
  - Epic candidate: [EPIC-2]
- Dependency map:
  - Blocked by [TASK-16] y [STORY-18].
  - Blocks [STORY-45], [STORY-54] y [STORY-56].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
