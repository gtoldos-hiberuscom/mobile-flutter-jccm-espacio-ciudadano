---
id: 51
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
  - carnets-digitales
  - discapacidad
  - pkpass
  - parsing
  - ui-state
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-51] Discapacidad, grado y manejo de carnet no vigente
## Functional Description
Cubrir el caso del carnet o acreditación de discapacidad incluyendo el grado cuando exista, la generación de pass asociado cuando proceda y el tratamiento explícito del estado no vigente o sin datos disponible en diseño.

## Acceptance Criteria
- [ ] Se contempla lectura del grado de discapacidad cuando exista.
- [ ] Se contempla PKPass/formatos asociados si el carnet está vigente.
- [ ] Se contempla estado no vigente o no disponible con mensaje explícito y sin acciones inválidas.
- [ ] Se contemplan errores de parsing para payloads string y casos sin datos.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-48]
    - [TASK-53]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-7]
    - [STORY-52]
- Integration scope:
  - /carnet-digital/grado-discapacidad/{dni}
  - /carnet-digital/discapacidad-pkpass/{dni}
- State considerations:
  - Mostrar grado cuando el backend lo provea.
  - Desactivar acciones en estado no vigente/no disponible.
  - Manejar parsing ambiguo cuando la respuesta llegue como string o payload no estructurado.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /carnet-digital/grado-discapacidad/{dni}, /carnet-digital/discapacidad-pkpass/{dni}
  - image_references/Servicios - Mis carnets digitales.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N4
- Provisional hierarchy:
  - Epic candidate: [EPIC-7]
- Dependency map:
  - Blocked by [STORY-48] y [TASK-53].
  - Sin descendientes explícitos en este corte.
  - Related to [STORY-52] por reutilización de gestión de pass/documentos.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
