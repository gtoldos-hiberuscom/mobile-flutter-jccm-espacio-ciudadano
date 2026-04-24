---
id: 41
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: 5
reporter:
assignee:
story_points:
labels:
  - notificaciones
  - listado
  - filtros
  - paginacion
  - estados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-24T11:37:52+00:00
due_date:
jira_url:
---
# [STORY-41] Centro de notificaciones con filtros por estado y paginación
## Functional Description
Cubrir el listado principal de notificaciones administrativas del ciudadano, con filtros por estado, navegación a detalle y base para una evolución futura más allá de la consulta manual.

## Acceptance Criteria
- [x] Se contempla listado de notificaciones con estados pendiente, aceptada, rechazada y caducada.
- [x] Se contemplan ordenación o paginación y filtros por estado.
- [x] Se contemplan indicadores visuales de estado y navegación a detalle.
- [x] Se contempla consulta manual como mecanismo principal de fase 1 y preparación para futura evolución a push.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-15]
    - [STORY-18]
    - [TASK-47]
  - Blocks:
    - [STORY-42]
    - [STORY-43]
    - [STORY-44]
  - Related to:
    - [EPIC-6]
- Functional scope:
  - Listado principal con filtros por estado, ordenación o paginación.
  - Indicadores visuales de estado y navegación al detalle.
  - Preparación para evolución futura a push manteniendo consulta manual como base de fase 1.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Notificaciones - listado.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N3/N5
  - MAPEO_DETALLADO_ENDPOINTS.md sección 5
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-15], [STORY-18] y [TASK-47].
  - Blocks [STORY-42], [STORY-43] y [STORY-44].
  - Depende del cierre del contrato real de notificaciones antes de fijar listado y estados.

## Notes
### Comments
- 2026-04-24T11:37:52+00:00 | by Copilot | Implementation technical notes:
  - Feature scaffold under `lib/features/notifications/{0_entity,1_domain,2_presentation,3_data}` per architecture canon v2.
  - Repository layer is mock-only (`NotificationsRepositoryImpl`, 18 deterministic items, pageSize-driven pagination, filter intersection, `forceErrorOnPage` / `forceEmpty` test hooks). Real Dio wiring against `ServicioApi.miDetalleOperation` is deferred — tracked by TASK-47 discovery.
  - Status enum follows the tolerant-parser strategy (`pendiente | aceptada | rechazada | caducada | unknown`) recommended by `documentation/discovery/TASK-47-notifications-contract-strategy.md`.
  - Routing wires `Routes.notifications` to `NotificationsCenterPage` and adds a child `Routes.notificationDetail = '/notifications/:id'` mapped to a placeholder page that STORY-44 will replace with the real detail.
  - Dependencies for downstream stories: STORY-42 (contact-data registration) is the gate that enables push evolution; STORY-44 owns the real detail screen that replaces `NotificationDetailPlaceholderPage`; STORY-43 will plug accept/reject actions into the same notifier surface.
  - Validation: `flutter analyze` reports 0 issues on `lib/features/notifications` and `test/features/notifications`; `flutter test` 165/165 tests pass (14 new under `test/features/notifications/`).

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T11:37:52+00:00 | by Copilot | Implementation completed on branch `task/EPIC-6-notifications/STORY-41-notifications-center/implement-notifications-center` at commit `99a8b4a`. Status transitioned To Do → Done; sprint set to 5; all four acceptance criteria checked. Notifications center delivered with mock-backed repository, status filters, pagination, visual indicators, navigation to detail placeholder, and base for future push evolution.
