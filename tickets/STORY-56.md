---
id: 56
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
  - segmentacion
  - hechos-vitales
  - filtros
  - listados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-56] Recomendaciones personalizadas con filtros y agrupación por hecho vital
## Functional Description
Cubrir el listado principal de recomendaciones del ciudadano basado en hechos vitales autorizados, incluyendo filtros/tabs de segmentación, agrupación o contextualización por hecho vital y navegación de listados extensos.

## Acceptance Criteria
- [ ] Se contempla listado de trámites recomendados agrupados o contextualizados por hechos vitales seleccionados.
- [ ] Se contemplan tabs/filtros Todos, Últimos días, Novedades y Tramitación inmediata.
- [ ] Se contemplan datos de plazos, unidad responsable y contexto del hecho vital asociado.
- [ ] Se contemplan paginación o navegación de listados largos.

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
- Integration scope:
  - /hechos-vitales/servicios/{idAgente}
  - /hechos-vitales/servicios/segmentacion/{idAgente}
- Functional focus:
  - Filtros Todos, Últimos días, Novedades y Tramitación inmediata.
  - Agrupación/contexto por hecho vital.
  - Visualización de plazos, unidad responsable y navegación en listados largos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /hechos-vitales/servicios/{idAgente}, /hechos-vitales/servicios/segmentacion/{idAgente}
  - image_references/Servicios recomendados.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 7
  - Tramite.md
  - TramitesPorHecho.md
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [STORY-54], [STORY-55] y [TASK-58].
  - Sin descendientes explícitos en este corte.
  - Depende de configuración previa del ciudadano y de la semántica final de segmentación.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
