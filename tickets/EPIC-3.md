---
id: 3
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
  - dashboard
  - home
  - citizen-summary
  - thematic-domains
  - discovery
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [EPIC-3] Portada, dashboard y dominios informativos del ciudadano
## Functional Description
Construir la portada logada y los dominios temáticos que agregan y muestran información de educación, empleo, bienestar social, salud y otros temas de interés/estado.

## Acceptance Criteria
- [ ] El epic cubre portada logada, landings temáticas, detalles de datos y enlaces externos.
- [ ] Se reflejan servicios confirmados y servicios mostrados en diseño pero sin contrato aún.
- [ ] El epic contempla errores parciales, estados vacíos y navegación desde dashboard a detalle.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
    - [EPIC-2]
  - Blocks:
    - [EPIC-4] (partial)
    - [EPIC-7] (partial)
    - [EPIC-8] (partial)
  - Related to:
    - [STORY-22]
    - [STORY-23]
    - [STORY-24]
    - [STORY-25]
    - [STORY-26]
    - [STORY-28]
    - [TASK-27]
- Confirmed scope surfaces:
  - Portada logada con resúmenes temáticos y accesos a detalle.
  - Landings de Educación, Empleo, Bienestar social y Otros temas de interés/Estado.
  - Navegación saliente a portales externos relevantes.
- Design-visible / contract-sensitive surfaces:
  - Bloques con contrato por validar o parcial: condición de becado, inscripciones en ofertas, termalismo, tarjeta de estacionamiento, atención a la dependencia y superficies de salud reutilizadas en portada.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md mapa de pantallas
  - MAPEO_ENDPOINTS_PANTALLAS.md dashboard
  - MAPEO_DETALLADO_ENDPOINTS.md secciones dashboard
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 1 y 13
  - image_references/Landing logado - Educación.png
  - image_references/Landing logado - Otras temas de interés.png
  - image_references/Landing Educación.png
  - image_references/Landing Bienestar social.png
  - image_references/Landing Empleo.png
  - image_references/Administración general del Estado _*.png
  - image_references/Servicios - *.png
- Provisional hierarchy:
  - Children:
    - [STORY-22]
    - [STORY-23]
    - [STORY-24]
    - [STORY-25]
    - [STORY-26]
    - [STORY-28]
    - [TASK-27]
- Dependency map:
  - Blocked by [EPIC-1] y [EPIC-2].
  - Blocks parcialmente [EPIC-4], [EPIC-7] y [EPIC-8].
  - Se apoya en [TASK-27] para cerrar gaps de contrato visibles en dashboard.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
