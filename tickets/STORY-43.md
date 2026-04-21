---
id: 43
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
  - aceptacion
  - rechazo
  - confirmacion
  - detalle
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-43] Notificación pendiente con aceptación, rechazo y confirmación de rechazo
## Functional Description
Cubrir el detalle operativo de una notificación pendiente y las decisiones del ciudadano sobre aceptar o rechazar, incluyendo confirmación explícita antes del rechazo definitivo.

## Acceptance Criteria
- [ ] Se contempla detalle con datos del expediente o notificación.
- [ ] Se contemplan acciones de aceptar y rechazar.
- [ ] Se contempla confirmación explícita antes de rechazar definitivamente.
- [ ] Se contemplan estados resultantes y retorno coherente al detalle o listado.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-41]
    - [STORY-42]
    - [TASK-47]
  - Blocks:
    - [STORY-44]
  - Related to:
    - [EPIC-6]
- Detail operations:
  - Detalle de notificación pendiente con datos relevantes del expediente o la comunicación.
  - Acciones de aceptación o rechazo con confirmación previa al rechazo definitivo.
  - Gestión de estados resultantes y retorno coherente a listado o detalle.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Notifiación pendiente - detalle.png
  - image_references/Notifiación pendiente - confirmación.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 5
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-41], [STORY-42] y [TASK-47].
  - Blocks [STORY-44].
  - Requiere contrato confirmado de estados y, si aplica, alta de contacto previa.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
