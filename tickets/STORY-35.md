---
id: 35
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
  - expedientes
  - detalle
  - documentos
  - aportacion-documental
  - metadata
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-35] Detalle de expediente con metadata y ficheros asociados
## Functional Description
Cubrir la lectura del detalle de expediente, su metadata operativa y la zona de trabajo para consultar ficheros ya asociados o preparar la aportación desde el propio detalle.

## Acceptance Criteria
- [ ] Se contemplan campos de detalle como consejería, oficina tramitadora, procedimiento, código del asunto, fechas y estado.
- [ ] Se contempla listado de ficheros ya asociados al expediente.
- [ ] Se contempla zona para añadir ficheros sobre el expediente desde el propio detalle.
- [ ] Se contemplan estados de expediente abierto o cerrado y restricciones operativas.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-34]
  - Blocks:
    - [STORY-38]
  - Related to:
    - [EPIC-5]
- Endpoint coverage:
  - /publicacion/selectbynumexp
- Detail and operations:
  - Metadata funcional del expediente con formato consistente de fechas y estados.
  - Listado de ficheros ya asociados como base para la trazabilidad documental.
  - Zona operativa de aportación condicionada al estado abierto o cerrado del expediente.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /publicacion/selectbynumexp
  - image_references/Expediente - detalle.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 3
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [STORY-34].
  - Blocks [STORY-38].
  - Reutiliza el workspace de gestiones y habilita la vía embebida de aportación documental.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
