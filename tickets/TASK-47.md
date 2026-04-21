---
id: 47
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
  - notificaciones
  - documentos
  - backend
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [TASK-47] Confirmar contrato real de notificaciones y asociación de documentos
## Functional Description
Validar si /servicio/midetalle y /publicacion/midocfirmados cubren realmente el caso de uso de notificaciones, cómo se asocian los documentos y si existe backend para alta de contacto.

## Acceptance Criteria
- [ ] Se valida o corrige el endpoint de listado o detalle de notificaciones.
- [ ] Se documenta el modelo de estados de notificación y de asociación de documentos.
- [ ] Se aclara si existe backend para el alta de datos de contacto.
- [ ] Se deja trazado el impacto sobre [STORY-41], [STORY-42], [STORY-43] y [STORY-44].

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
  - Blocks:
    - [STORY-41]
    - [STORY-42]
    - [STORY-43]
  - Related to:
    - [EPIC-6]
    - [STORY-44]
- Validation scope:
  - /servicio/midetalle
  - /publicacion/midocfirmados
- Expected outcome:
  - Confirmar o corregir contrato de listado y detalle de notificaciones.
  - Documentar estados, asociación de documentos y backend de alta de contacto.
  - Dejar impacto explícito sobre el conjunto de historias de notificaciones.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - ServicioApi.md
  - PublicacionApi.md
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N5 y R2
  - MAPEO_DETALLADO_ENDPOINTS.md sección 5
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [TASK-16].
  - Blocks [STORY-41], [STORY-42] y [STORY-43].
  - Related to [STORY-44] por la asociación documental de las variantes no pendientes.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
