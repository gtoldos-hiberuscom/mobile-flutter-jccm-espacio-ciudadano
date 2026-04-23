---
id: 20
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 2
reporter:
assignee:
story_points:
labels:
  - auth
  - shell
  - user-state
  - maintenance
  - navigation
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-04T12:00:00+02:00
due_date:
jira_url:
---
# [STORY-20] Estado de usuario logado, menú personal y mantenimiento bloqueante
## Functional Description
Contemplar las superficies de identidad del usuario autenticado y el estado de mantenimiento que bloquea temporalmente el acceso operativo.

## Acceptance Criteria
- [x] Se contempla header/área personal con saludo e identificador documental del ciudadano.
- [x] Se contempla menú lateral con accesos a áreas personales y acción de salir.
- [x] Se contempla estado de mantenimiento/bloqueo con mensaje y continuidad limitada.
- [x] Se contempla degradación visual cuando la sesión existe pero el sistema no está operativo.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-18]
  - Blocks:
    - [STORY-22]
    - [STORY-34]
    - [STORY-41]
    - [STORY-48]
  - Related to:
    - [EPIC-2]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Landing logado mobile.png
  - image_references/Landing logado mobile-2.png
  - image_references/Modal Carnet joven.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-2]
- Dependency map:
  - Blocked by [STORY-13] y [STORY-18].
  - Blocks [STORY-22], [STORY-34], [STORY-41] y [STORY-48].

## Notes
### Comments
- None yet.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Implementation merged to `develop`. Evidence: `lib/features/user_profile/` (entity, notifier, header widget with greeting + document id, drawer menu with logout, avatar widget) and `lib/features/maintenance/` (state, notifier, blocking page) cover personal header, lateral menu, maintenance blocking and degraded session state. Implementing commit: `cd15aea`.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Sprint set to `Sprint 2`; status transitioned from `To Do` → `Done` after reconciling against merged implementation on `develop`.
