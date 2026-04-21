---
id: 54
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
  - hechos-vitales
  - preferencias
  - multi-select
  - idagente
  - persistencia
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-54] Selección y guardado de hechos vitales del ciudadano
## Functional Description
Cubrir la pantalla de selección múltiple de hechos vitales del ciudadano, su guardado explícito en backend y la capacidad de resetear preferencias para recalcular posteriormente las recomendaciones personalizadas.

## Acceptance Criteria
- [ ] Se contempla listado de hechos vitales seleccionables con checkboxes múltiples.
- [ ] Se contempla guardado explícito y feedback de persistencia.
- [ ] Se contempla borrado/reset de preferencias.
- [ ] Se contemplan estados inicial, cargando, error y guardado exitoso.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-18]
    - [TASK-21]
  - Blocks:
    - [STORY-56]
    - [STORY-57]
  - Related to:
    - [EPIC-8]
- Integration scope:
  - /hechos-vitales/hechos/{idAgente}
  - /hechos-vitales/hechos
  - /hechos-vitales/preferencias/{idAgente}
- Functional focus:
  - Selección múltiple mediante checkboxes.
  - Guardado explícito con feedback y reset de preferencias.
  - Dependencia de idAgente para carga y persistencia.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /hechos-vitales/hechos/{idAgente}, /hechos-vitales/hechos, /hechos-vitales/preferencias/{idAgente}
  - image_references/Proactividad - Mis hechos vitales.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 8
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [STORY-18] para sesión/claims y [TASK-21] para cierre de idAgente.
  - Blocks [STORY-56] y [STORY-57].
  - Alimenta la configuración base del ciudadano para recomendaciones posteriores.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
