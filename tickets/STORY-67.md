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
updated_at: 2026-09-21T18:00:00+02:00
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

### Sprint 9 closure
- 2026-09-21T18:00:00+02:00 | by plan-manager | Sprint 9 (SP-EC-APP-SQ2-09 / SP-EC-APP-SQ3-09) closure: defect-closure & QA continuation. STORY-67 received two Sprint-9 task lineages (defect closure A + QA continuation G).
  - Branches:
    - Deliverable A — landing PII leak (HIGH, surfaced by Sprint 8 hardening report): `task/EPIC-10-quality-release/STORY-67-qa/sprint9-landing-pii-leak` (commits `ca2b161`, `e401c90`) → `ticket/EPIC-10-quality-release/STORY-67-qa` → `epic/EPIC-10-quality-release` → `develop`.
    - Deliverable G — goldens & a11y polish: `task/EPIC-10-quality-release/STORY-67-qa/sprint9-goldens-and-a11y` (commits `1609c30`, `f86a7b9`, `6d65798`) → same upward path.
  - Evidence (A):
    - `lib/features/landing/2_presentation/landing_page.dart` — `print('Login successful: $session')` replaced with `ref.read(appLoggerProvider).info('Login successful', context: {'sessionType': session.runtimeType.toString()})`. Session is no longer interpolated into the message; only the runtime type appears in context.
    - `test/features/landing/landing_login_logging_test.dart` — capturing fake AppLogger + stubbed login use case returning a session with realistic PII fields (`nif: 12345678Z`, `idAgente: AGT-1`, token-shaped string); asserts no PII substring leaks in the captured message + JSON-encoded context, and that `_kPiiKeyFragments` redaction also passes when re-emitted through `ConsoleLogger`.
  - Evidence (G):
    - Goldens added: `test/qa/goldens/recommendations_list_golden_test.dart` (Todos tab, deterministic 2-item bucket via repository override) + baseline `recommendations_page_todos.png`; `test/qa/goldens/familia_numerosa_detail_golden_test.dart` (deterministic Sample Holder, fixed expiry) + baseline `familia_numerosa_detail_phone_portrait.png`. Run with `flutter test test/qa/goldens/`.
    - Home golden DEFERRED to STORY-22 reopen — scaffold `test/qa/goldens/logged_home_golden_test.dart` shipped with `skip: true` and a TODO pointing at `documentation/qa/STORY-22-home-route-investigation.md`.
    - Agenda dynamic-type fix: `lib/features/agenda/2_presentation/widgets/agenda_event_tile.dart` — title + subtitle gain `maxLines: 2, overflow: TextOverflow.ellipsis`. New `test/features/agenda/agenda_tile_dynamic_type_test.dart` reproduces the original `RenderFlex overflowed by 1040 pixels` at `TextScaler.linear(2.0)` and asserts the fixed tree raises no exception.
    - Recommendations focus order: DOCUMENTED, not patched — `documentation/qa/STORY-67-recommendations-focus-order.md` traces the root cause (`AutomaticKeepAliveClientMixin` keeping inactive bucket cards in the focus tree) and proposes a Sprint-10 follow-up shape. Code change rejected as exceeding the "minimal fix" gate.
  - Validation:
    - `flutter analyze --no-fatal-infos` — 0 errors / 1 pre-existing warning (unchanged baseline at `test/features/recommendations/recommendations_page_widget_test.dart:16` `unused_element_parameter`).
    - `flutter test` — 453 passing + 2 skipped (perf opt-in + deferred home golden). Default-suite delta from Sprint-8 baseline: +A's 1 + G's 4 = +5 (G adds 1 recommendations golden + 1 familia golden + 2 agenda dynamic-type cases; +1 deferred home skip).
  - Status unchanged (Done). Ticket Notes-only update per Sprint 9 closure policy. Recommendation surfaced for plan-manager final summary: reopen STORY-22 to implement `LoggedHomePage` and remove the `/home → /sitemap` safety redirect introduced under deliverable B.
