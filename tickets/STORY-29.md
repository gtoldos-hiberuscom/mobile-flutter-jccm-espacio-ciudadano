---
id: 29
jira_key:
type: Story
status: In Progress
priority:
project: Carpeta Ciudadana CLM
epic_link: EPIC-4
parent:
sprint:
reporter:
assignee:
story_points:
labels:
  - agenda
  - salud
  - calendar
  - filters
  - events
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-04T22:00:00+02:00
due_date:
jira_url:
---
# [STORY-29] Agenda con listado de eventos, calendario y filtros temporales
## Functional Description
Modelar la agenda del ciudadano con selector de periodo, vista calendario y listado navegable de eventos.

## Acceptance Criteria
- [ ] Se contempla listado de citas/eventos futuros y pasados.
- [ ] Se contempla selector de periodo con todos los periodos, próximos 7 días, 30 días y 365 días.
- [ ] Se contempla vista calendario mensual y timestamp de última actualización.
- [ ] Se contemplan paginación o navegación de listas largas y acceso a detalle expandible.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-15]
    - [STORY-18]
  - Blocks:
    - [STORY-30]
    - [STORY-31]
  - Related to:
    - [EPIC-4]
    - [STORY-22]
- Confirmed contracts:
  - /sescam/citas/{numDocumento}
  - /sescam/citas-pasadas/{numDocumento}
- Modeling considerations:
  - Filtros temporales y navegación entre periodos.
  - Vista calendario mensual y acceso a detalle expandible.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoint /sescam/citas/{numDocumento}
  - endpoint /sescam/citas-pasadas/{numDocumento}
  - image_references/Agenda.png
  - image_references/Agenda-1.png
  - image_references/Agenda-2.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 2
- Provisional hierarchy:
  - Epic candidate: [EPIC-4]
- Dependency map:
  - Blocked by [STORY-15] y [STORY-18].
  - Blocks [STORY-30] y [STORY-31].
  - Related to [STORY-22] por reutilización del resumen de próximos eventos.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T22:00:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-04T22:00:00+02:00 | epic_link | (none) -> EPIC-4 | by Copilot
