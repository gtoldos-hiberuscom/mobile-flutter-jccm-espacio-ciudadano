---
id: 34
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
  - gestiones
  - expedientes
  - registro
  - tabs
  - listados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T10:30:00+02:00
due_date:
jira_url:
---
# [STORY-34] Workspace de Mis gestiones con tabs de expedientes, entradas y salidas
## Functional Description
Modelar la pantalla principal de gestiones con cambio de contexto entre expedientes, entradas de registro y salidas de registro, reutilizando shell y patrones de listado compartidos.

## Acceptance Criteria
- [x] Se contemplan tabs o selector entre Mis expedientes, Mis entradas de registro y Mis salidas de registro.
- [x] Se contemplan listados paginados o navegables con breadcrumbs y cambio rápido de contexto.
- [x] Se contemplan estados vacíos, errores y datos parcialmente cargados.
- [x] Se contempla reutilización de la shell y patrones de listado compartidos.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-15]
    - [STORY-18]
  - Blocks:
    - [STORY-35]
    - [STORY-36]
    - [STORY-39]
  - Related to:
    - [EPIC-5]
- Functional slices:
  - Cambio de contexto entre expedientes, entradas y salidas sin romper navegación ni shell global.
  - Listados paginados o navegables con breadcrumbs y patrones compartidos de carga, vacío y error.
- Endpoint coverage:
  - /publicacion/selectbynif
  - /publicacion/selectbynifentrada
  - /publicacion/selectbynifsalida

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /publicacion/selectbynif
  - /publicacion/selectbynifentrada
  - /publicacion/selectbynifsalida
  - image_references/Expedientes - listado.png
  - image_references/Entradas registro - listado.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 3
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [STORY-15] y [STORY-18].
  - Blocks [STORY-35], [STORY-36] y [STORY-39].
  - Actúa como base de navegación para el resto del workspace de gestiones.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T10:25:00+02:00 | by Copilot | Status To Do → In Progress (Sprint 4) on branch `task/EPIC-5-casework/STORY-34-casework-workspace/implement-casework-workspace`.
- 2026-04-22T10:30:00+02:00 | by Copilot | Implementation complete on branch `task/EPIC-5-casework/STORY-34-casework-workspace/implement-casework-workspace`. New feature `lib/features/casework/` with strict `0_entity/1_domain/2_presentation/3_data` layout: `CaseworkItem`, `CaseworkTab`, `CaseworkSnapshot/Section`, abstract `CaseworkRepository`, `@riverpod` `CaseworkWorkspaceNotifier` (per-tab parallel load with independent error/empty/loaded sections + `selectTab`/`refresh`/`refreshTab`), mock `CaseworkRepositoryImpl` with `forceEmptyTab`/`forceErrorTab` flags, and `CaseworkWorkspacePage` (TabBar + TabBarView + breadcrumb + reused `core/ui_states/` widgets). Route `/casework` rewired to the real page in `lib/app/routing/app_router.dart` (placeholder retired). l10n keys with `casework*` prefix added to `app_es.arb` and `app_en.arb`. Deferred: real Dio integration against `/publicacion/selectbynif`, `/publicacion/selectbynifentrada`, `/publicacion/selectbynifsalida` is not part of this story; STORY-39 will extend this same scaffold with search in Sprint 4 and the data-layer wiring is owned by a follow-up task. Validation: `flutter analyze lib/features/casework/ test/features/casework/` → 0 issues; `flutter test test/features/casework/` → 9/9 passing.
