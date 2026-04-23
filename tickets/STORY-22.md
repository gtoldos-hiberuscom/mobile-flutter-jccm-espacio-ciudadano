---
id: 22
jira_key:
type: Story
status: In Progress
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
  - widgets
  - partial-errors
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-22] Portada logada con resumen ciudadano y accesos rápidos
## Functional Description
Diseñar la home autenticada con saludo, resumen temático, próximos eventos, accesos directos y degradación por errores parciales.

## Acceptance Criteria
- [ ] Se contempla saludo personalizado e identificador del ciudadano.
- [ ] Se contemplan bloques/resúmenes por áreas temáticas y navegación a sus landings.
- [ ] Se contemplan widgets de próximos eventos, mis expedientes, mis notificaciones, mis carnets digitales y recomendaciones.
- [ ] Se contemplan timestamps de actualización, estados vacíos y fallos parciales sin bloquear el resto de la home.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-14]
    - [STORY-15]
    - [STORY-18]
    - [STORY-20]
  - Blocks:
    - [STORY-23]
    - [STORY-24]
    - [STORY-25]
    - [STORY-26]
    - [STORY-29]
    - [STORY-31]
  - Related to:
    - [EPIC-3]
    - [STORY-28]
- Home composition:
  - Resúmenes por dominio con navegación a landings temáticas.
  - Widgets con comportamiento degradable por errores parciales.
  - Timestamp de actualización y empty states por bloque.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Landing logado - Educación.png
  - image_references/Landing logado - Otras temas de interés.png
  - image_references/Landing logado mobile.png
  - image_references/Landing logado mobile-2.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 1
- Provisional hierarchy:
  - Epic candidate: [EPIC-3]
- Dependency map:
  - Blocked by [STORY-13], [STORY-14], [STORY-15], [STORY-18] y [STORY-20].
  - Blocks [STORY-23], [STORY-24], [STORY-25], [STORY-26], [STORY-29] y [STORY-31].
  - Related to [STORY-28] para navegación saliente consistente.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T15:00:00+02:00 | status | To Do -> In Progress | by Copilot
