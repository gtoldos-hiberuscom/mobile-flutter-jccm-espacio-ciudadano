---
id: 56
jira_key: JCCMEC-55
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-30
parent: JCCMEC-30
sprint: Sprint 6
reporter:
assignee:
story_points:
labels:
  - recomendaciones
  - segmentacion
  - hechos-vitales
  - filtros
  - listados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-55
---
# [STORY-56] Recomendaciones personalizadas con filtros y agrupación por hecho vital
## Functional Description
Cubrir el listado principal de recomendaciones del ciudadano basado en hechos vitales autorizados, incluyendo filtros/tabs de segmentación, agrupación o contextualización por hecho vital y navegación de listados extensos.

## Acceptance Criteria
- [x] Se contempla listado de trámites recomendados agrupados o contextualizados por hechos vitales seleccionados.
- [x] Se contemplan tabs/filtros Todos, Últimos días, Novedades y Tramitación inmediata.
- [x] Se contemplan datos de plazos, unidad responsable y contexto del hecho vital asociado.
- [x] Se contemplan paginación o navegación de listados largos.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-54]
    - [STORY-55]
    - [TASK-58]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-8]
- Integration scope:
  - /hechos-vitales/servicios/{idAgente}
  - /hechos-vitales/servicios/segmentacion/{idAgente}
- Functional focus:
  - Filtros Todos, Últimos días, Novedades y Tramitación inmediata.
  - Agrupación/contexto por hecho vital.
  - Visualización de plazos, unidad responsable y navegación en listados largos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /hechos-vitales/servicios/{idAgente}, /hechos-vitales/servicios/segmentacion/{idAgente}
  - image_references/Servicios recomendados.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 7
  - Tramite.md
  - TramitesPorHecho.md
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [STORY-54], [STORY-55] y [TASK-58].
  - Sin descendientes explícitos en este corte.
  - Depende de configuración previa del ciudadano y de la semántica final de segmentación.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Sprint 6: Recomendaciones list landed under `lib/features/recommendations/` with full canon layout. Plain Riverpod `AsyncNotifierProvider.family<…, RecommendationBucket>` controller; tolerant DTO + mock repo (14 fixtures, page size 6, cursor=offset) gated by `kRecommendationsLiveBackendEnabled = false`. `RecommendationsPage` binds 4 tabs (Todos / Últimos días / Novedades / Tramitación inmediata) per TASK-58 D1, with cards exposing título, plazo, unidad responsable y hecho vital + auto + manual paging ("Ver más" + scroll-end listener). `Routes.recommendations` now binds the real page. 14 l10n keys × 2 locales. Tests +28 → 302. Pendiente para STORY-57: variantes empty-state (unconfigured / unauthorised / configured-but-empty) y CTAs hacia `Routes.preferencesConsent`. Status → Done.
