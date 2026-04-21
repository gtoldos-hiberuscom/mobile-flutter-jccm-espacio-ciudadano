---
id: 40
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
  - discovery
  - api-contract
  - procedimientos
  - registro
  - expedientes
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [TASK-40] Validar flujo completo de procedimientos y evidencias de registro
## Functional Description
Cerrar el alcance real de los endpoints de procedimiento y registro presentes en la API pero todavía no asignados de forma concluyente en la documentación funcional de expedientes y aportación documental.

## Acceptance Criteria
- [ ] Se valida o aclara el uso de /procedimiento/inicproc, /procedimiento/miconfirmarproc, /procedimiento/miobtenerres y /procedimiento/subiradjuntosinfirma.
- [ ] Se valida el papel de /documentacion/registrarfichero, /publicacion/selectbynifexp, /publicacion/misexpedientes y /consulta/miconsultareq.
- [ ] Se define qué parte entra en esta fase y qué parte queda como follow-up explícito.
- [ ] Se documenta el impacto sobre expedientes, aportación y posibles justificantes.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
  - Blocks:
    - [STORY-38]
  - Related to:
    - [EPIC-5]
    - [STORY-35]
    - [STORY-37]
- Validation scope:
  - /procedimiento/inicproc
  - /procedimiento/miconfirmarproc
  - /procedimiento/miobtenerres
  - /procedimiento/subiradjuntosinfirma
  - /documentacion/registrarfichero
  - /publicacion/selectbynifexp
  - /publicacion/misexpedientes
  - /consulta/miconsultareq
- Expected outcome:
  - Delimitar qué endpoints soportan expedientes, aportación y justificantes en esta fase y qué queda como follow-up.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - ProcedimientoApi.md
  - DocumentacionApi.md
  - PublicacionApi.md
  - ConsultaApi.md
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N2/N8/N9
  - MAPEO_DETALLADO_ENDPOINTS.md R6
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [TASK-16].
  - Blocks [STORY-38].
  - Related to [STORY-35] y [STORY-37] por validar la base técnica de aportación y justificantes.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
