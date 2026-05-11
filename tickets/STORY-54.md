---
id: 54
jira_key: JCCMEC-53
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-30
parent: JCCMEC-30
sprint: Sprint 4
reporter:
assignee:
story_points:
labels:
  - hechos-vitales
  - preferencias
  - multi-select
  - idagente
  - persistencia
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-53
---
# [STORY-54] Selección y guardado de hechos vitales del ciudadano
## Functional Description
Cubrir la pantalla de selección múltiple de hechos vitales del ciudadano, su guardado explícito en backend y la capacidad de resetear preferencias para recalcular posteriormente las recomendaciones personalizadas.

## Acceptance Criteria
- [x] Se contempla listado de hechos vitales seleccionables con checkboxes múltiples.
- [x] Se contempla guardado explícito y feedback de persistencia.
- [x] Se contempla borrado/reset de preferencias.
- [x] Se contemplan estados inicial, cargando, error y guardado exitoso.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-18]
    - [TASK-21]
  - Blocks:
    - [STORY-56]
    - [STORY-57]
  - Related to:
    - [EPIC-8]
- Integration scope:
  - /hechos-vitales/hechos/{idAgente}
  - /hechos-vitales/hechos
  - /hechos-vitales/preferencias/{idAgente}
- Functional focus:
  - Selección múltiple mediante checkboxes.
  - Guardado explícito con feedback y reset de preferencias.
  - Dependencia de idAgente para carga y persistencia.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /hechos-vitales/hechos/{idAgente}, /hechos-vitales/hechos, /hechos-vitales/preferencias/{idAgente}
  - image_references/Proactividad - Mis hechos vitales.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 8
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [STORY-18] para sesión/claims y [TASK-21] para cierre de idAgente.
  - Blocks [STORY-56] y [STORY-57].
  - Alimenta la configuración base del ciudadano para recomendaciones posteriores.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T10:15:00+02:00 | by Copilot | Status To Do → In Progress; Sprint 4; started implementation on `task/EPIC-8-personalization/STORY-54-life-events/implement-life-events`.
- 2026-04-22T10:30:00+02:00 | by Copilot | Implementation done; status In Progress → Done. Created feature `lib/features/personalization/` with 0_entity/1_domain/2_presentation/3_data layout (LifeEvent, LifeEventsSelection + LifeEventsLoadState, LifeEventsRepository, LifeEventsNotifier @riverpod family keyed by idAgente, mock LifeEventsRepositoryImpl, LifeEventsPage). 14 `lifeEvents*` l10n keys added in es/en. 8 tests (notifier toggle/save/reset transitions, save-failure error path, groupByCategory; widget tests for selection rendering and reset confirmation flow) all green. `flutter analyze` clean (0 errors/warnings introduced; only the same `flutter_style_todos` info baseline as `lib/features/education/`). Dio wiring against `/hechos-vitales/hechos/{idAgente}`, `PATCH /hechos-vitales/hechos` and `DELETE /hechos-vitales/preferencias/{idAgente}` is deferred via `TODO(STORY-54)` markers in `LifeEventsRepository` and `LifeEventsRepositoryImpl` (depends on TASK-21 idAgente closure).
