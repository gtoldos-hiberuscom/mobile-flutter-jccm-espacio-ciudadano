---
id: 39
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
  - expedientes
  - busqueda
  - registro
  - identificacion
  - navegacion
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T18:20:00+02:00
due_date:
jira_url:
---
# [STORY-39] Consulta de expedientes por identificación, número de expediente o registro
## Functional Description
Cubrir la pantalla de búsqueda específica de expedientes y registros, reutilizando capacidades de detalle y aportación documental a partir de los resultados obtenidos.

## Acceptance Criteria
- [x] Se contempla formulario con validación de inputs para identificación, número de expediente y número de registro.
- [x] Se contemplan resultados navegables y transición a detalle.
- [x] Se contempla reutilización de la aportación documental desde el resultado de búsqueda.
- [x] Se contemplan vacíos, errores y casos sin coincidencias.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-34]
    - [STORY-15]
  - Blocks:
    - [STORY-37]
  - Related to:
    - [EPIC-5]
    - [STORY-35]
    - [STORY-38]
- Endpoint coverage:
  - /publicacion/selectbynif
  - /publicacion/selectbynumexp
  - /publicacion/selectbynumreg
- Search scope:
  - Validación de entradas por identificación, número de expediente y número de registro.
  - Navegación a detalle y reutilización posterior de aportación documental.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /publicacion/selectbynif
  - /publicacion/selectbynumexp
  - /publicacion/selectbynumreg
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 4
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 4
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [STORY-34] y [STORY-15].
  - Blocks parcialmente [STORY-37] al poder reutilizar búsqueda y transición a detalle.
  - Related to [STORY-35] y [STORY-38] por reutilización de detalle y aportación.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T18:20:00+02:00 | by Copilot | Implemented casework search feature on branch `task/EPIC-5-casework/STORY-39-casework-search/implement-casework-search`. Added `casework_search_query` / `casework_search_result` entities with pure-Dart validation (NIF, NIE, pasaporte, expediente/registro alphabet) and at-least-one-required rule; extended `CaseworkRepository` with `searchByNif`, `searchByExpedienteNumber`, `searchByRegistroNumber` (mock returning 3 / 0 / error to exercise every UI state); introduced `CaseworkSearchNotifier` exposing `idle | searching | results | noResults | error`; new `CaseworkSearchPage` reuses `casework_item_tile`, `core/ui_states/`, design tokens and the design-system `AppButton`; routes `/casework/search` and stub `/casework/item/:id` registered, workspace AppBar gains a search action. l10n keys `caseworkSearch*` and `caseworkItemDetailPlaceholder*` added in ES / EN. Aportación documental and detail navigation are placeholders marked `// TODO(STORY-37)` and `// TODO(STORY-35)`. `flutter analyze lib/features/casework test/features/casework` clean (0 issues); `flutter test test/features/casework` 32/32 green.
