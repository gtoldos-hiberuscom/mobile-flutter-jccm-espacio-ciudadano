---
id: 67
jira_key:
type: Story
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
  - qa
  - accesibilidad
  - regresion-visual
  - preproduccion
  - validacion-final
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-08-25T12:00:00+02:00
due_date:
jira_url:
---
# [STORY-67] QA funcional, accesibilidad y regresión visual antes de entrega
## Functional Description
Planificar la validación funcional y no funcional final sobre los flujos clave y sus estados visuales, incluyendo accesibilidad, goldens o equivalentes y comprobaciones en preproducción sobre contratos o estados ambiguos.

## Acceptance Criteria
- [x] Se contempla matriz QA para login, home, agenda, expedientes, notificaciones, carnets, recomendaciones y soporte.
- [x] Se contemplan revisiones de accesibilidad, foco, contraste y labels.
- [x] Se contemplan goldens o equivalentes de estados críticos loading/empty/error/success.
- [x] Se contemplan validaciones manuales o automatizadas en preproducción para contratos ambiguos.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-64]
    - [STORY-65]
    - [STORY-66]
    - [TASK-70]
  - Blocks:
    - [STORY-68]
  - Related to:
    - [EPIC-10]
- QA scope:
  - Matriz funcional sobre los flujos clave de la aplicación.
  - Revisión de accesibilidad: foco, contraste, labels y navegación.
  - Regresión visual de estados críticos.
  - Validación preproductiva de contratos o respuestas ambiguas.
- Quality gates:
  - Se apoya en observabilidad, resiliencia y testing definidos aguas arriba.
  - Requiere budgets/performance acordados en [TASK-70] para la validación final.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §§23 y 26
  - PLANIFICACION_PROYECTO.md fase 8
  - image_references/*.png como referencia de estados/variantes
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-64], [STORY-65], [STORY-66] y [TASK-70].
  - Blocks [STORY-68].
  - Consolida la validación funcional y visual previa a la entrega.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 (SP-EC-APP-SQ2-07): To Do → In Progress → Done on `task/EPIC-10-quality-release/STORY-67-qa/qa-as-code`. Deliverables: `documentation/qa/accessibility-checklist.md`, `documentation/qa/STORY-67-regression-report.md`, `test/qa/accessibility_smoke_test.dart` (4 guideline matchers), `test/qa/landing_golden_test.dart` + baseline at `test/qa/goldens/landing_page_phone_portrait.png`, `test/integration/smoke_happy_path_test.dart`. Acceptance criteria all satisfied. Sprint 8 UAT closure expectations explicitly captured in regression report (additional goldens for Home/Recommendations/Carnet, dynamic-type tile fix, focus-order polish, device a11y traversal). Status → Done.

### Sprint 8 closure
- 2026-08-25T12:00:00+02:00 | by plan-manager | Sprint 8 (SP-EC-APP-SQ3-08) closure: UAT functional handoff consolidated.
  - Branches: `task/EPIC-10-quality-release/STORY-67-qa/sprint8-uat-handoff` (commit `bc7b3e9`) → `ticket/EPIC-10-quality-release/STORY-67-qa` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - Handoff document: `documentation/qa/STORY-67-uat-handoff-sprint8.md` (414 lines).
    - Verified surface table (one row per feature, columns: goldens / a11y / e2e / manual).
    - Consolidated regression with the Sprint 7 STORY-67 regression report.
    - Known limitations carried into UAT: recommendations Dio mock, Afirma URL pending, support backend pending (TASK-63), casework mock data, OfflineBanner ES-only copy.
    - UAT entry checklist cross-references sibling Sprint 8 deliverables (TASK-69 hardening report, TASK-70 perf verification, STORY-64 telemetry verification, STORY-65 resilience adopters, STORY-68 promotion runbook).
    - No UAT-blocking defects discovered.
  - Validation: `flutter analyze --no-fatal-infos` 0 errors / 1 pre-existing warning. No code touched.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 8 closure policy.
