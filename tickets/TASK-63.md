---
id: 63
jira_key:
type: Task
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
  - soporte
  - discovery
  - backend
  - captcha
  - operaciones
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-29T14:34:17+00:00
due_date:
jira_url:
---
# [TASK-63] Definir integración operativa del soporte técnico y escalado de incidencias
## Functional Description
Aclarar cómo se implementa realmente el formulario de soporte técnico mostrado en diseño, incluyendo backend, captcha y circuito de atención, para dejar definido el canal operativo de recepción y seguimiento de incidencias.

## Acceptance Criteria
- [ ] Se identifica servicio/backend o canal operativo responsable de recibir incidencias.
- [ ] Se define tratamiento de adjuntos, confirmación por email y protección de datos.
- [ ] Se valida o selecciona mecanismo de captcha/antibot.
- [ ] Se documenta el impacto sobre [STORY-60] y la operación posterior.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
  - Blocks:
    - [STORY-60]
  - Related to:
    - [EPIC-9]
- Validation scope:
  - Canal/backend real de recepción de incidencias.
  - Política de adjuntos, límites y retención.
  - Confirmación por email y trazabilidad del caso.
  - Captcha o mecanismo antibot compatible con la operación.
- Expected outcome:
  - Criterios operativos mínimos para implementar [STORY-60].
  - Definición del circuito de escalado y tratamiento de datos del soporte técnico.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Ayuda - Soporte.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 11
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 11
- Provisional hierarchy:
  - Epic candidate: [EPIC-9]
- Dependency map:
  - Blocked by [TASK-16].
  - Blocks [STORY-60].
  - Reduce la incertidumbre operativa del formulario de soporte técnico.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 (SP-EC-APP-SQ3-07): To Do → In Progress. Discovery executed end-to-end on `task/EPIC-9-help-static/TASK-63-support-integration/discovery-doc`. Deliverable: `documentation/discovery/TASK-63-support-integration-strategy.md` (Track A `/soporte/incidencia` recommended; Track B `mailto:` fallback documented; Turnstile selected; SHA-256 attachment integrity; PII redaction extension to `LoggingInterceptor`; SLA proposal). All four ACs satisfied (see §7 of discovery doc). Four open questions escalated to Sprint 8. STORY-60 stays Done; wiring deferred. Status → Done.
