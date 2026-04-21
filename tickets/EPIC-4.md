---
id: 4
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
  - agenda
  - salud
  - sescam
  - cip
  - calendar
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [EPIC-4] Agenda y servicios de salud del ciudadano
## Functional Description
Construir la experiencia de agenda/salud con citas, calendario, CIP y reutilización de eventos en la portada.

## Acceptance Criteria
- [ ] El epic cubre eventos futuros y pasados, calendario, detalle, CIP y justificantes.
- [ ] Se refleja la dependencia de respuestas string del backend y su validación explícita.
- [ ] Se contemplan empty, error y last-update states.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
    - [EPIC-2]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-3]
    - [STORY-29]
    - [STORY-30]
    - [STORY-31]
    - [TASK-32]
- Confirmed health scope:
  - Agenda con citas futuras y pasadas.
  - Vista calendario y detalle expandible.
  - CIP/tarjeta sanitaria y justificantes cuando aplique.
- Technical risk:
  - Payloads SESCAM tipados como string y sujetos a parseo/validación explícitos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 2
  - MAPEO_ENDPOINTS_PANTALLAS.md Mi Agenda
  - MAPEO_DETALLADO_ENDPOINTS.md Mi Agenda
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 2
  - image_references/Agenda*.png
  - image_references/Servicios - Mis citas médicas.png
- Provisional hierarchy:
  - Children:
    - [STORY-29]
    - [STORY-30]
    - [STORY-31]
    - [TASK-32]
- Dependency map:
  - Blocked by [EPIC-1] y [EPIC-2].
  - Related to [EPIC-3] por reutilización de próximos eventos y accesos desde portada.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
