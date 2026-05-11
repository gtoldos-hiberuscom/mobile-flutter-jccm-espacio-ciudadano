---
id: 19
jira_key: JCCMEC-11
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-8
parent: JCCMEC-8
sprint: Tablero Sprint 1
reporter:
assignee:
story_points:
labels:
  - auth
  - consent
  - privacy
  - legal
  - preferences
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:25:30+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-11 Aceptación inicial de condiciones de uso y protección de datos
## Functional Description
Cubrir el flujo obligatorio de aceptación/rechazo de autorizaciones y consulta de la información ampliada de protección de datos.

## Acceptance Criteria
- [x] Se contempla pantalla/modal inicial de condiciones de uso y autorizaciones antes del acceso funcional.
- [x] Se contempla navegación hacia información ampliada de protección de datos.
- [x] Se contempla rechazo y salida, así como aceptación y continuación.
- [x] Se contempla persistencia/versionado de consentimientos y su reutilización posterior en preferencias.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-17]
    - [STORY-18]
  - Blocks:
    - [STORY-55]
    - [STORY-61]
  - Related to:
    - [EPIC-2]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Acceso - Condiciones.png
  - image_references/Acceso - Condiciones-1.png
  - image_references/Acceso - Condiciones-2.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md S1/N10
  - Proactividad - Mis uso de datos.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-2]
- Dependency map:
  - Blocked by [STORY-17] y [STORY-18].
  - Blocks [STORY-55] y [STORY-61].

## Notes
### Comments
- None yet.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Implementation merged to `develop`. Evidence under `lib/features/consent/` (entity, domain notifier, repository, presentation page) covering accept/reject flow, persistence and reuse. Implementing commits: `21a23b1`, `3131064`, `1cae757`, `84b9272`.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T02:00:00+02:00 | by plan-manager | Ticket moved to In Progress — Sprint 1 wave 2 execution started.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Status transitioned from `In Progress` → `Done` after reconciling against merged implementation on `develop`.
