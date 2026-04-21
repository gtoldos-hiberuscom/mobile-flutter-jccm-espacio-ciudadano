---
id: 5
jira_key:
type: Epic
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
  - gestiones
  - expedientes
  - registro
  - aportacion-documental
  - documentos
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [EPIC-5] Gestiones, expedientes y aportación documental
## Functional Description
Cubrir los flujos de consulta de expedientes y registros, así como la aportación de documentos tanto desde el detalle de expediente como desde un flujo dedicado para terceros.

## Acceptance Criteria
- [ ] El epic cubre listados, detalles, búsqueda, aportación y justificantes.
- [ ] Se contemplan tabs de gestiones, wizard dedicado y validaciones de adjuntos.
- [ ] Se explicitan los endpoints de procedimiento aún por validar.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
    - [EPIC-2]
  - Blocks:
    - [STORY-34]
    - [STORY-35]
    - [STORY-36]
    - [STORY-37]
    - [STORY-38]
    - [STORY-39]
    - [TASK-40]
  - Related to:
    - [EPIC-6]
- Scope decomposition:
  - Workspace de Mis gestiones con tabs para expedientes, entradas y salidas.
  - Consulta de detalle de expediente y registros con navegación contextual.
  - Búsqueda específica por identificación, número de expediente o registro.
  - Aportación documental embebida en expediente y flujo dedicado para terceros.
  - Validación de adjuntos, cálculo de hash y justificante final.
- Endpoints and contracts pending validation:
  - Superficie de publicación para listados y detalle de expedientes/registros.
  - Superficie de procedimiento y registro asociada a aportación documental, condicionada por [TASK-40].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantallas 3 y 4
  - MAPEO_ENDPOINTS_PANTALLAS.md Mis Gestiones y Consulta de Expedientes
  - MAPEO_DETALLADO_ENDPOINTS.md secciones 3 y 4
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 3 y 4
  - image_references/Expedientes - listado.png
  - image_references/Expediente - detalle.png
  - image_references/Entradas registro - listado.png
  - image_references/Entrada registro - detalle.png
  - image_references/Aportación - paso 1.png
  - image_references/Aportación - paso 2.png
  - image_references/Aportación - paso 3.png
  - image_references/Aportación - paso 4.png
- Provisional hierarchy:
  - Children:
    - [STORY-34]
    - [STORY-35]
    - [STORY-36]
    - [STORY-37]
    - [STORY-38]
    - [STORY-39]
    - [TASK-40]
- Dependency map:
  - Blocked by [EPIC-1] y [EPIC-2].
  - Related to [EPIC-6] por continuidad entre aportación documental, notificaciones y firma.
  - Descompone el alcance en workspace, detalle, búsqueda, flujo de terceros y validación de endpoints.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
