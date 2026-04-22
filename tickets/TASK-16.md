---
id: 16
jira_key:
type: Task
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
  - foundation
  - api-contract
  - openapi
  - discovery
  - architecture
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T02:00:00+02:00
due_date:
jira_url:
---
# [TASK-16] Validar estrategia de adaptación del cliente OpenAPI y gaps de contrato base
## Functional Description
Cerrar la estrategia de wrappers, mapeo DTO->dominio y gestión de incoherencias del cliente generado antes de implementar features.

## Acceptance Criteria
- [ ] Se inventarian APIs y modelos clave por dominio.
- [ ] Se identifican respuestas string, modelos vacíos y contratos dudosos que requieren tickets de descubrimiento.
- [ ] Se define la regla de encapsulación del cliente generado dentro de 3_data/api.
- [ ] Se documentan dependencias con tickets de validación de notificaciones, SESCAM, carnets y procedimientos.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
  - Blocks:
    - [TASK-21]
    - [TASK-27]
    - [TASK-32]
    - [TASK-47]
    - [TASK-53]
    - [TASK-58]
  - Related to:
    - [EPIC-1]
    - [STORY-12]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - generated/dart_dio_client/README.md
  - PublicacionApi.md
  - ProcedimientoApi.md
  - SescamApi.md
  - CarnetDigitalApi.md
  - HechosVitalesApi.md
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md riesgos N4/N5/N8
- Provisional hierarchy:
  - Epic candidate: [EPIC-1]
- Dependency map:
  - Blocked by [STORY-12].
  - Blocks [TASK-21], [TASK-27], [TASK-32], [TASK-47], [TASK-53] y [TASK-58].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T02:00:00+02:00 | by plan-manager | Ticket moved to In Progress — Sprint 1 wave 2 execution started.
