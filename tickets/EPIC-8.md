---
id: 8
jira_key: JCCMEC-30
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
  - proactividad
  - hechos-vitales
  - recomendaciones
  - consentimiento
  - segmentacion
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-30
---
# [EPIC-8] Hechos vitales, autorizaciones y recomendaciones personalizadas
## Functional Description
Cubrir la configuración proactiva del ciudadano y la entrega de recomendaciones personalizadas basadas en hechos vitales, autorizaciones de uso de datos y reglas de segmentación soportadas por backend.

## Acceptance Criteria
- [ ] El epic cubre selección de hechos, autorizaciones, borrado de preferencias y recomendaciones.
- [ ] Se reflejan filtros/segmentación y empty states observados en diseño.
- [ ] Se explicita la dependencia con idAgente y con reglas de segmentación de backend.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
    - [EPIC-2]
  - Blocks:
    - [STORY-54]
    - [STORY-55]
    - [STORY-56]
    - [STORY-57]
    - [TASK-58]
  - Related to:
    - [EPIC-3]
- Scope decomposition:
  - Selección y persistencia de hechos vitales del ciudadano.
  - Gestión de autorizaciones, revocación y preferencias de uso de datos.
  - Recomendaciones personalizadas con filtros, agrupación y empty states.
- Technical uncertainty:
  - Dependencia explícita de idAgente para preferencias y recomendaciones.
  - Reglas reales de segmentación de backend pendientes de confirmación en [TASK-58].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantallas 7 y 8
  - MAPEO_ENDPOINTS_PANTALLAS.md Mis Recomendaciones y Mis Hechos Vitales
  - MAPEO_DETALLADO_ENDPOINTS.md secciones 7 y 8
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 7 y 8
  - image_references/Proactividad - Mis hechos vitales.png
  - Proactividad - Mis uso de datos.png
  - Servicios recomendados.png
  - Servicios recomendados-1.png
- Provisional hierarchy:
  - Children:
    - [STORY-54]
    - [STORY-55]
    - [STORY-56]
    - [STORY-57]
    - [TASK-58]
- Dependency map:
  - Blocked by [EPIC-1] y [EPIC-2].
  - Related to [EPIC-3] por continuidad del espacio de servicios y personalización.
  - Se descompone en preferencias, autorizaciones y consumo de recomendaciones segmentadas.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
