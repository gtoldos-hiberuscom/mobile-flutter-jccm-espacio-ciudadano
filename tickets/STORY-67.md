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
updated_at: 2026-04-29T14:34:17+00:00
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
