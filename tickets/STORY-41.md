---
id: 41
jira_key:
type: Story
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
  - notificaciones
  - listado
  - filtros
  - paginacion
  - estados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-41] Centro de notificaciones con filtros por estado y paginación
## Functional Description
Cubrir el listado principal de notificaciones administrativas del ciudadano, con filtros por estado, navegación a detalle y base para una evolución futura más allá de la consulta manual.

## Acceptance Criteria
- [ ] Se contempla listado de notificaciones con estados pendiente, aceptada, rechazada y caducada.
- [ ] Se contemplan ordenación o paginación y filtros por estado.
- [ ] Se contemplan indicadores visuales de estado y navegación a detalle.
- [ ] Se contempla consulta manual como mecanismo principal de fase 1 y preparación para futura evolución a push.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-15]
    - [STORY-18]
    - [TASK-47]
  - Blocks:
    - [STORY-42]
    - [STORY-43]
    - [STORY-44]
  - Related to:
    - [EPIC-6]
- Functional scope:
  - Listado principal con filtros por estado, ordenación o paginación.
  - Indicadores visuales de estado y navegación al detalle.
  - Preparación para evolución futura a push manteniendo consulta manual como base de fase 1.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Notificaciones - listado.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N3/N5
  - MAPEO_DETALLADO_ENDPOINTS.md sección 5
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-15], [STORY-18] y [TASK-47].
  - Blocks [STORY-42], [STORY-43] y [STORY-44].
  - Depende del cierre del contrato real de notificaciones antes de fijar listado y estados.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
