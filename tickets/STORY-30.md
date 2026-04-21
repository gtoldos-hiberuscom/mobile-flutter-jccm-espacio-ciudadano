---
id: 30
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
  - agenda
  - salud
  - event-detail
  - documents
  - error-handling
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-30] Detalle de cita, justificantes y estados de agenda
## Functional Description
Cubrir la expansión de eventos y la lectura de su detalle operativo, incluyendo justificantes y estados UX asociados.

## Acceptance Criteria
- [ ] Se contempla expand/collapse del detalle de cada cita o evento.
- [ ] Se contemplan descripciones largas, centro, profesional, tipo, fecha y hora.
- [ ] Se contempla acceso a justificante de asistencia cuando aplique.
- [ ] Se contemplan empty/error/parse-error/partial-data states de la agenda.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-29]
    - [TASK-32]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-4]
- UX and parsing considerations:
  - Expand/collapse por item con descripciones largas.
  - Estados de error recuperable, parse-error y datos parciales condicionados por [TASK-32].
  - Justificantes tratados como superficie documental de agenda.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Agenda.png
  - image_references/Agenda-2.png
  - image_references/Servicios - Mis citas médicas.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N4
- Provisional hierarchy:
  - Epic candidate: [EPIC-4]
- Dependency map:
  - Blocked by [STORY-29] y [TASK-32].
  - Depende del cierre de parseo real de payloads SESCAM para manejar detalle y justificantes.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
