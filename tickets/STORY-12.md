---
id: 12
jira_key: JCCMEC-2
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Tablero Sprint 1
reporter:
assignee:
story_points:
labels:
  - foundation
  - architecture
  - networking
  - storage
  - error-handling
  - auth
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:25:30+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-2 Red, almacenamiento seguro y estrategia de errores compartida
## Functional Description
Definir la infraestructura transversal de red, auth-ready client, storage sensible/no sensible y mapping de errores para todas las features.

## Acceptance Criteria
- [x] Se contempla cliente Dio común con interceptores, timeouts, cancelación y headers de autorización.
- [x] Tokens y secretos se almacenan en secure storage y datos no sensibles en storage no seguro.
- [x] Existe estrategia común de errores técnicos -> fallos de dominio -> mensajes de usuario localizados.
- [x] Los clientes OpenAPI generados se encapsulan como detalle de infraestructura en 3_data/api.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-11]
  - Blocks:
    - [STORY-18]
    - [STORY-29]
    - [STORY-34]
    - [STORY-41]
    - [STORY-48]
    - [STORY-54]
    - [STORY-64]
  - Related to:
    - [EPIC-1]
    - [TASK-16]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - architecture_canon_flutter_v2.md §§2,5
  - annex_a core/network/auth
  - annex_b §13
  - annex_c §§21,24,26
  - generated/dart_dio_client/README.md
- Provisional hierarchy:
  - Epic candidate: [EPIC-1]
- Dependency map:
  - Blocked by [STORY-11].
  - Blocks [STORY-18], [STORY-29], [STORY-34], [STORY-41], [STORY-48], [STORY-54] y [STORY-64].
  - Related to [TASK-16].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T12:00:00+02:00 | status | In Progress -> Done | by Copilot
