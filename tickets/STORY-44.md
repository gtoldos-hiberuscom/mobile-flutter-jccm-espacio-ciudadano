---
id: 44
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
  - documentos
  - detalle
  - estados
  - descarga
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-44] Detalle de notificación aceptada, rechazada o caducada con documentos
## Functional Description
Cubrir las variantes no pendientes del detalle de notificación y el acceso a los documentos asociados, con reglas claras de lectura, retorno y manejo de indisponibilidades.

## Acceptance Criteria
- [ ] Se contemplan variantes aceptada, rechazada y caducada o expirada con su estado visible.
- [ ] Se contempla listado o descarga de documentos asociados.
- [ ] Se contemplan reglas de lectura y navegación de retorno.
- [ ] Se contemplan vacíos o errores y manejo de documentos no disponibles.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-41]
    - [STORY-43]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-6]
- Detail scope:
  - Variantes aceptada, rechazada y caducada con estado visible y reglas de solo lectura.
  - Acceso a listado o descarga de documentos asociados.
  - Manejo de vacíos, errores y documentos no disponibles.
- Endpoint note:
  - /publicacion/midocfirmados aparece como referencia a validar para asociación documental.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Notifiación aceptada - detalle.png
  - image_references/Notifiación rechazada - detalle.png
  - image_references/Notificaciones - listado.png
  - /publicacion/midocfirmados
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-41] y [STORY-43].
  - Sin descendientes explícitos en este corte.
  - Depende de la resolución previa de estados pendientes y asociación real de documentos.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
