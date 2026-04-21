---
id: 58
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
  - segmentacion
  - recomendaciones
  - hechos-vitales
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [TASK-58] Confirmar reglas de segmentación y contrato semántico de recomendaciones
## Functional Description
Validar la semántica real de los filtros de segmentación y la relación entre hechos vitales, trámites y plazos, dejando claro cómo se alimentan las recomendaciones y qué depende de idAgente y de las autorizaciones del usuario.

## Acceptance Criteria
- [ ] Se aclaran las operaciones de segmentación (ultimos_dias, novedades, inmediatos) y su efecto real.
- [ ] Se valida el modelo de agrupación por hecho vital y los campos de fechas/unidad responsable.
- [ ] Se documenta dependencia exacta con idAgente y autorizaciones.
- [ ] Se deja trazado el impacto sobre STORIES-56 y 57.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
    - [TASK-21]
  - Blocks:
    - [STORY-56]
    - [STORY-57]
  - Related to:
    - [EPIC-8]
- Validation scope:
  - Semántica de ultimos_dias, novedades e inmediatos.
  - Agrupación por hecho vital y campos de fechas/unidad responsable.
  - Dependencia de idAgente y autorizaciones activas.
- Expected outcome:
  - Contrato funcional mínimo para [STORY-56] y [STORY-57].
  - Trazabilidad explícita entre backend de segmentación, permisos y experiencia de usuario.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - HechosVitalesApi.md
  - Hecho.md
  - Tramite.md
  - TramitesPorHecho.md
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N6
  - MAPEO_DETALLADO_ENDPOINTS.md 7.1-8.6
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [TASK-16] y [TASK-21].
  - Blocks [STORY-56] y [STORY-57].
  - Reduce la incertidumbre semántica del módulo de recomendaciones personalizadas.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
