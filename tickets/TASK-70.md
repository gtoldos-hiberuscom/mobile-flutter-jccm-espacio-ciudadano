---
id: 70
jira_key:
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 7
reporter:
assignee:
story_points:
labels:
  - performance
  - budgets
  - startup
  - listas
  - documentos
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-29T14:34:17+00:00
due_date:
jira_url:
---
# [TASK-70] Validar budgets de performance y manejo de listas, documentos y startup
## Functional Description
Fijar y comprobar umbrales razonables de rendimiento para startup, listados, documentos y rebuilds críticos, dejando trazadas métricas y validaciones necesarias antes de release.

## Acceptance Criteria
- [x] Se definen objetivos de startup, carga de pantallas críticas y scrolling.
- [x] Se contemplan impactos de documentos binarios, listas paginadas y parsing costoso.
- [x] Se contemplan medidas para minimizar rebuilds y operaciones costosas en UI.
- [x] Se dejan trazadas validaciones o métricas necesarias antes de release.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-15]
    - [STORY-66]
  - Blocks:
    - [STORY-67]
    - [STORY-68]
  - Related to:
    - [EPIC-10]
- Performance scope:
  - Objetivos de startup, carga inicial y scrolling en pantallas críticas.
  - Impacto de binarios, listas paginadas y parsing costoso.
  - Medidas para minimizar rebuilds y operaciones pesadas en UI.
  - Definición de métricas o validaciones previas a release.
- Expected outcome:
  - Budgets razonables para la validación final.
  - Criterios explícitos para QA y release readiness.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §25
  - PLANIFICACION_PROYECTO.md fase 8
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 13
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-15] y [STORY-66].
  - Blocks [STORY-67] y [STORY-68].
  - Define budgets y validaciones de rendimiento del epic [EPIC-10].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 (SP-EC-APP-SQ3-07): To Do → In Progress → Done on `task/EPIC-10-quality-release/TASK-70-performance/budgets-and-harness`. Added `documentation/qa/performance-budgets.md` (TTI, widget-build, scroll FPS, document UX, image cache budgets with rationale and Sprint 8/9 follow-ups), `test/performance/page_build_budgets_test.dart` (LandingPage first-build budget = 150 ms; tagged `performance` and skipped from default `flutter test` via new `dart_test.yaml`). RecommendationsPage and CaseworkWorkspace harness deferred to Sprint 8 closure (override matrix complexity), explicitly documented in the perf doc. Status → Done.
