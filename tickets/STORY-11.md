---
id: 11
jira_key:
type: Story
status: In Progress
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 1
reporter:
assignee:
story_points:
labels:
  - foundation
  - architecture
  - bootstrap
  - repo-structure
  - configuration
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T01:35:57+02:00
due_date:
jira_url:
---
# [STORY-11] Bootstrap del repositorio y entrypoints por entorno
## Functional Description
Definir la topología obligatoria del repo y los entrypoints de entorno para una app Flutter multi-entorno alineada con el canon.

## Acceptance Criteria
- [ ] lib/app, lib/core, lib/features y lib/l10n quedan contemplados como macrozonas obligatorias.
- [ ] Se define AppConfig tipado y estrategia de carga para development/preproduction/production.
- [ ] Se contemplan main_<env>.dart, bootstrap único y lectura de configuración compilada.
- [ ] Se identifican exclusiones explícitas de anti-patrones globales.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - None.
  - Blocks:
    - [STORY-12]
    - [STORY-13]
    - [STORY-14]
  - Related to:
    - [EPIC-1]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - architecture_canon_flutter_v2.md §§4-5
  - annex_a §§4-5
  - PLANIFICACION_PROYECTO.md fase 1
  - copilot-instructions architecture source-of-truth
- Provisional hierarchy:
  - Epic candidate: [EPIC-1]
- Dependency map:
  - Blocks [STORY-12], [STORY-13] y [STORY-14].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T01:35:57+02:00 | by plan-manager | Ticket moved to In Progress — Sprint 1 execution started.
