---
id: 38
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
  - upload
  - documentos
  - hash
  - validacion
  - justificante
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-38] Subida de adjuntos con hash, validaciones y descarga de justificante
## Functional Description
Cubrir el pipeline operativo de aportación documental con selección de ficheros, validaciones previas, cálculo de hash, registro y descarga del justificante final.

## Acceptance Criteria
- [ ] Se contempla drag&drop o selección de ficheros y reglas de formatos admitidos.
- [ ] Se contemplan límite de 5 archivos, 50 MB por archivo y validaciones previas.
- [ ] Se contempla cálculo o visualización de algoritmo y huella antes del registro.
- [ ] Se contempla estado final con ficheros aportados y descarga de justificante.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-35]
    - [STORY-37]
    - [TASK-40]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-5]
- Endpoint coverage:
  - /procedimiento/obtenerhashdeadjunto
  - /procedimiento/subiradjunto
  - /procedimiento/subiradjuntosinfirma
- Operational constraints:
  - Requiere una vía de entrada habilitada desde detalle de expediente o flujo de terceros.
  - Límite de 5 archivos y 50 MB por archivo con validaciones previas de formato.
  - Justificante final dependiente de la validación real del circuito de procedimiento y registro en [TASK-40].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /procedimiento/obtenerhashdeadjunto
  - /procedimiento/subiradjunto
  - /procedimiento/subiradjuntosinfirma
  - image_references/Aportación - paso 2.png
  - image_references/Aportación - paso 3.png
  - image_references/Aportación - paso 4.png
  - image_references/Expediente - detalle.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Requiere [TASK-40] y una vía de entrada habilitada por [STORY-35] o [STORY-37].
  - Sin descendientes explícitos en este corte.
  - Cierra el tramo operativo de aportación y justificante del epic.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
