---
id: 57
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
  - recomendaciones
  - empty-state
  - onboarding
  - preferencias
  - permisos
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-57] Onboarding y estado vacío de recomendaciones cuando faltan permisos o hechos vitales
## Functional Description
Cubrir el caso en el que el usuario todavía no dispone de recomendaciones útiles o no ha completado la configuración previa, guiándolo desde el estado vacío hacia Mis preferencias y Mis hechos vitales hasta alcanzar un estado con datos.

## Acceptance Criteria
- [ ] Se contempla mensaje explicativo cuando todavía no hay hechos vitales o permisos suficientes.
- [ ] Se contempla CTA hacia Mis preferencias / Mis hechos vitales.
- [ ] Se contempla transición desde estado vacío a estado con datos una vez completada la configuración.
- [ ] Se contemplan casos de backend sin resultados aun teniendo permisos activos.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-54]
    - [STORY-55]
    - [TASK-58]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-8]
    - [STORY-56]
- Empty-state scope:
  - Mensajes explicativos cuando faltan hechos vitales o permisos.
  - CTA hacia Mis preferencias / Mis hechos vitales.
  - Reentrada al listado una vez completada la configuración.
- Backend considerations:
  - Distinguir ausencia de configuración frente a ausencia de resultados.
  - Mantener coherencia con filtros y recomendaciones de [STORY-56].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Servicios recomendados-1.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 7
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 7
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [STORY-54], [STORY-55] y [TASK-58].
  - Sin descendientes explícitos en este corte.
  - Related to [STORY-56] para asegurar coherencia entre empty state y listado con datos.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
