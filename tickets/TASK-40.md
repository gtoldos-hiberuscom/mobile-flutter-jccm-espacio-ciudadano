---
id: 40
jira_key:
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 5
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
updated_at: 2026-06-17T10:00:00+02:00
due_date:
jira_url:
---
# [TASK-40] Validar flujo completo de procedimientos y evidencias de registro
## Functional Description
Cerrar el alcance real de los endpoints de procedimiento y registro presentes en la API pero todavía no asignados de forma concluyente en la documentación funcional de expedientes y aportación documental.

## Acceptance Criteria
- [x] Se valida o aclara el uso de /procedimiento/inicproc, /procedimiento/miconfirmarproc, /procedimiento/miobtenerres y /procedimiento/subiradjuntosinfirma.
- [x] Se valida el papel de /documentacion/registrarfichero, /publicacion/selectbynifexp, /publicacion/misexpedientes y /consulta/miconsultareq.
- [x] Se define qué parte entra en esta fase y qué parte queda como follow-up explícito.
- [x] Se documenta el impacto sobre expedientes, aportación y posibles justificantes.

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

### Sprint 5 scope summary
- **In scope (STORY-35).** `selectbynumexp` cubre detalle, metadata y listado de ficheros asociados; estado abierto/cerrado se lee del propio response (pendiente confirmar valores canónicos con backend, Q1).
- **In scope (STORY-37).** Identificación + búsqueda por NIF / número de registro / número de expediente reusan `selectbynif`, `selectbynumreg`, `selectbynumexp`. No requiere endpoints adicionales de procedimiento.
- **In scope (STORY-38).** Pipeline de aportación con `obtenerhashdeadjunto` + `subiradjuntosinfirma`. Justificante usa `documentacion/registrarfichero` envuelto en un adaptador con estado `unavailable` por defecto hasta confirmar el builder de `RegistrarFicheroRequest` (Q3, Q4).
- **Follow-up explícito.** Flujo de tramitación (`inicproc` / `miconfirmarproc` / `miobtenerres`) queda fuera (R6, Q5); `selectbynifexp` y `misexpedientes` se reservan para A/B con backend (Q2); `consulta/miconsultareq` se reasigna a la épica de Consultas y Reclamaciones (Q6).
- **Variante firmada.** `subiradjunto` (firmada) queda detrás de `kCaseworkSignedUploadEnabled = false`; depende de la épica de Firma Digital, no entra en EPIC-5.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-06-17T10:00:00+02:00 | by plan-manager | TASK-40 discovery completed; decision artifact at documentation/discovery/TASK-40-procedimiento-evidence-strategy.md.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 closure annotation appended to discovery doc under STORY-67 QA-as-code; no decisions revised, no defects, no new tickets opened.
