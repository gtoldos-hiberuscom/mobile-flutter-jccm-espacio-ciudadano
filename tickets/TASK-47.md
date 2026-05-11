---
id: 47
jira_key: JCCMEC-46
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-28
parent: JCCMEC-28
sprint: Sprint 5
reporter:
assignee:
story_points:
labels:
  - discovery
  - api-contract
  - notificaciones
  - documentos
  - backend
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-46
---
# [TASK-47] Confirmar contrato real de notificaciones y asociación de documentos
## Functional Description
Validar si /servicio/midetalle y /publicacion/midocfirmados cubren realmente el caso de uso de notificaciones, cómo se asocian los documentos y si existe backend para alta de contacto.

## Acceptance Criteria
- [x] Se valida o corrige el endpoint de listado o detalle de notificaciones.
- [x] Se documenta el modelo de estados de notificación y de asociación de documentos.
- [x] Se aclara si existe backend para el alta de datos de contacto.
- [x] Se deja trazado el impacto sobre [STORY-41], [STORY-42], [STORY-43] y [STORY-44].

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
  - Blocks:
    - [STORY-41]
    - [STORY-42]
    - [STORY-43]
  - Related to:
    - [EPIC-6]
    - [STORY-44]
- Validation scope:
  - /servicio/midetalle
  - /publicacion/midocfirmados
- Expected outcome:
  - Confirmar o corregir contrato de listado y detalle de notificaciones.
  - Documentar estados, asociación de documentos y backend de alta de contacto.
  - Dejar impacto explícito sobre el conjunto de historias de notificaciones.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - ServicioApi.md
  - PublicacionApi.md
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N5 y R2
  - MAPEO_DETALLADO_ENDPOINTS.md sección 5
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [TASK-16].
  - Blocks [STORY-41], [STORY-42] y [STORY-43].
  - Related to [STORY-44] por la asociación documental de las variantes no pendientes.

## Notes
### Comments
- None yet.

### Impact Summary
- Discovery deliverable: `documentation/discovery/TASK-47-notifications-contract-strategy.md`.
- `POST /servicio/midetalle` (`ServicioApi.miDetalleOperation`) and `POST /publicacion/midocfirmados` (`PublicacionApi.miDocsfirmados`) confirmed at wire-shape level against the generated Dio client; `estado` value-set remains R2-open and is absorbed by a tolerant placeholder enum.
- STORY-41: unblocked — bind listing to `miDetalleOperation`, map `ZCSSTPUBPORTAL` → `Notification`, render four canonical states, paginate/order client-side.
- STORY-42: unblocked **mock-only** — no contact-registration endpoint exists in the API; ship form + success state behind `kNotificationContactLiveBackendEnabled = false` with a follow-up ticket reserved for real wiring.
- STORY-43: partially unblocked — accept/reject **actions** also lack a backend operation; same mock-with-deferred-wiring pattern (`kNotificationActionsLiveBackendEnabled`); confirmation step is client-side.
- STORY-44: unblocked — variants share the `estado` enum; documents fetched via `miDocsfirmados` using `ipejeexp` + `ipnumexp` from the listing item; download URL strategy deferred (open question).
- Open backend questions: `estado` value-set, `ipclase` semantics, accept/reject operation, contact-registration operation, document download URL.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T13:04:14+02:00 | by plan-manager | TASK-47 closed: discovery doc `documentation/discovery/TASK-47-notifications-contract-strategy.md` added; AC 1–4 satisfied; status → Done; sprint → Sprint 5.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 closure annotation appended to discovery doc under STORY-67 QA-as-code; no decisions revised, no defects, no new tickets opened.
