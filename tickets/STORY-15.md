---
id: 15
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 2
reporter:
assignee:
story_points:
labels:
  - foundation
  - ui-state
  - pagination
  - refresh
  - documents
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-04T12:00:00+02:00
due_date:
jira_url:
---
# [STORY-15] Estados compartidos de UI, paginación, refresh y acciones documentales
## Functional Description
Definir patrones reutilizables para loading, empty, error, partial-error, blocked, paginación, pull-to-refresh y acciones de documentos.

## Acceptance Criteria
- [x] Se contemplan componentes/contratos compartidos para loading, empty, error y blocked states.
- [x] Se contempla paginación reutilizable para listados largos del producto.
- [x] Se contempla pull-to-refresh y reintento en pantallas con actualización de datos.
- [x] Se contempla apertura/descarga/compartición de documentos y justificantes como capacidad transversal.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-14]
  - Blocks:
    - [STORY-22]
    - [STORY-29]
    - [STORY-34]
    - [STORY-41]
    - [STORY-48]
    - [STORY-59]
  - Related to:
    - [EPIC-1]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 1,2,3,5,6,13
  - image_references/Agenda.png
  - image_references/Expedientes - listado.png
  - image_references/Notificaciones - listado.png
  - image_references/Aportación - paso 4.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-1]
- Dependency map:
  - Blocked by [STORY-14].
  - Blocks [STORY-22], [STORY-29], [STORY-34], [STORY-41], [STORY-48] y [STORY-59].

## Notes
### Comments
- None yet.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Implementation merged to `develop`. Evidence under `lib/core/ui_states/`: `loading_state_widget.dart`, `empty_state_widget.dart`, `error_state_widget.dart`, `blocked_state_widget.dart` (shared loading/empty/error/blocked components), `paginated_list_view.dart` (reusable pagination with integrated `RefreshIndicator` for pull-to-refresh and retry), `document_action_bar.dart` (document open/download/share capability), and the `ui_states.dart` barrel. Implementing commit: `382bd1d`.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Sprint set to `Sprint 2`; status transitioned from `To Do` → `Done` after reconciling against merged implementation on `develop`.
