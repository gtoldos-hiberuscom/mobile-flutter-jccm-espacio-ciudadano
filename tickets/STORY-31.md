---
id: 31
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 4
reporter:
assignee:
story_points:
labels:
  - salud
  - cip
  - dashboard
  - reuse
  - contract-gap
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-24T11:00:12+02:00
due_date:
jira_url:
---
# [STORY-31] CIP y superficies de salud reutilizadas entre home y agenda
## Functional Description
Contemplar la tarjeta sanitaria/CIP y los accesos rápidos de salud reutilizados desde portada y agenda.

## Acceptance Criteria
- [x] Se contempla visualización del CIP o tarjeta sanitaria como dato destacado de salud.
- [x] Se contempla reutilización del resumen de próximos eventos desde la portada hacia la agenda completa.
- [x] Se contempla integración con la sección de salud del dashboard y sus accesos.
- [x] Se explicitan gaps de contrato para capacidades de salud visibles en diseño pero no confirmadas.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-22]
    - [STORY-29]
    - [TASK-27] (partial)
  - Blocks:
    - None.
  - Related to:
    - [EPIC-4]
    - [EPIC-3]
    - [TASK-32]
- Confirmed contracts:
  - /sescam/cip/{numDocumento}
- Contract-sensitive surfaces:
  - Mi salud digital y otras capacidades visibles en diseño quedan sujetas al cierre de [TASK-27].
  - Reutilización home/agenda coordinada con el resumen de próximos eventos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoint /sescam/cip/{numDocumento}
  - image_references/Servicios - Mis citas médicas.png
  - image_references/Landing logado - Educación.png
  - image_references/Servicios - Mapa web.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-4]
  - Cross-epic reuse with [EPIC-3]
- Dependency map:
  - Blocked by [STORY-22], [STORY-29] y parcialmente por [TASK-27].
  - Related to [TASK-32] para validar parsing/shape real del dato de salud.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T11:00:12+02:00 | by Copilot | To Do → In Progress (Sprint 4).
- 2026-04-24T11:00:12+02:00 | by Copilot | Implementation done. Added `CipSummary` entity + `CipRepository` (co-located in `lib/features/agenda/`) + `cipSummaryProvider` notifier and the read-only `CipCard` widget rendered both at the top of the agenda page and inside `lib/features/home/2_presentation/widgets/salud_surface_card.dart`. Added `UpcomingEventsSummary` widget consumed by both the agenda header and the home `upcomingEvents` block (AC2). Per the TASK-71 surface decision (CIP_REUSE) the CIP is rendered read-only with no PKPass / QR / PDF affordance and no wallet semantics. Per the TASK-32 SESCAM payload strategy the repository wraps `SescamCipParser`; the real network path is gated by `kSescamLiveParsingEnabled` (currently `false`) and short-circuits to a deterministic stub payload. Contract-gap caption (TASK-27 / TASK-32) is rendered inside the card. Added 4 new tests (cip_card widget loaded + parse-error, cip_summary_notifier loading→loaded + parse-error path + refresh, upcoming_events_summary top-3 ordered). `flutter analyze lib/features/agenda/ lib/features/home/ test/features/agenda/ test/features/home/` → 0 issues. `flutter test test/features/agenda/ test/features/home/` → 45 tests passed.
- 2026-04-24T11:00:12+02:00 | by Copilot | In Progress → Done.
