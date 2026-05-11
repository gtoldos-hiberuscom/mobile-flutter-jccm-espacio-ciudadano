---
id: 70
jira_key: JCCMEC-69
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-32
parent: JCCMEC-32
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
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-69
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

### Sprint 8 closure
- 2026-08-25T12:00:00+02:00 | by plan-manager | Sprint 8 (SP-EC-APP-SQ3-08) closure: Performance budgets verified on UAT candidate.
  - Branches: `task/EPIC-10-quality-release/TASK-70-performance/sprint8-performance-verification` (commit `c00c4c0`) → `ticket/EPIC-10-quality-release/TASK-70-performance` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - Report: `documentation/qa/TASK-70-performance-verification-sprint8.md` (env, budgets, results, regressions, recommendations).
    - `RELEASES.md` — performance verification log entry per environment.
    - Harness invocation: `flutter test --tags performance --run-skipped` → +1 ~0 -0 (PASS). LandingPage first-build budget ≤150 ms held.
    - Default `flutter test` baseline preserved (440 + 1 perf skip).
    - Sprint-9 carryovers (recommendations only, no tickets): extend harness to RecommendationsPage and CaseworkWorkspacePage; add CI-runner-pinned budget; profile-mode device TTI; align performance-budgets.md invocation snippet with `--run-skipped` requirement.
  - Validation: `flutter analyze --no-fatal-infos` 0 errors / 1 pre-existing warning. Default `flutter test` 440 + 1 skip preserved.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 8 closure policy.

### Sprint 9 closure
- 2026-09-21T18:00:00+02:00 | by plan-manager | Sprint 9 (SP-EC-APP-SQ3-09) closure: performance harness extension (Deliverable D).
  - Branch: `task/EPIC-10-quality-release/TASK-70-performance/sprint9-perf-harness-extension` (commits `e25d196`, `3c2d68c`, `06fcb4b`) → `ticket/EPIC-10-quality-release/TASK-70-performance` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - `test/performance/page_build_budgets_test.dart` extended with `RecommendationsPage` and `CaseworkWorkspacePage` first-build budgets (≤150 ms each per `documentation/qa/performance-budgets.md`). Each test pumps minimal Riverpod overrides (`_EmptyRecommendationsRepo`, `_EmptyCaseworkRepo`) so the harness measures BUILD cost, not data assembly. All three tests print `[perf] <Page> first build: <N> ms (budget: <B> ms)` for diagnostic.
    - Captured numbers (this branch / dev laptop): `LandingPage 1 ms`, `RecommendationsPage 19 ms`, `CaseworkWorkspacePage 3 ms` — all comfortably under the 150 ms budget.
    - Default `flutter test` run remains fast: the new tests inherit `tags: ['performance']` and stay skipped via `dart_test.yaml`.
    - Documentation: `documentation/qa/performance-budgets.md` — "How to run the harness" rewritten to advertise `flutter test --tags performance --run-skipped` (clarifying the `--run-skipped` requirement caused by `dart_test.yaml`'s `skip:` clause), new "Why the tag is skipped by default" subsection capturing the rationale (default loop stays fast; perf is opt-in for CI / release verification), new "Diagnostic output" subsection documenting the `[perf]` log lines, and the Sprint-8/9 follow-up checklist updated (LandingPage / Recommendations / Casework first-build harness items ticked; cold-start TTI and image-cache tuning still open).
  - Decision: kept the `dart_test.yaml` `skip:` directive intact (more honest to "opt-in by default"); aligned the doc snippet to the actual invocation. Documented in commit body of #3.
  - Validation:
    - `flutter test --tags performance --run-skipped test/performance/` → 3 passed, 0 failed.
    - `flutter test` (default) → 448 passed + 3 skipped (= the perf trio) on this branch base. Default-suite count preserved as expected (perf still opt-in).
    - `flutter analyze --no-fatal-infos` — 0 errors / 1 pre-existing warning. The 3 analyzer infos that the new fakes initially introduced were cleaned up in commit `3c2d68c`.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 9 closure policy.
