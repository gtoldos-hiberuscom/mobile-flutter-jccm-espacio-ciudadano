---
id: 27
jira_key:
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 3
reporter:
assignee:
story_points:
labels:
  - discovery
  - api-contract
  - dashboard
  - gaps
  - backend-alignment
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-04T22:30:00+02:00
due_date:
jira_url:
---
# [TASK-27] Validar contratos ausentes o ambiguos de bloques visibles en dashboard
## Functional Description
Cerrar los gaps de contrato para capacidades presentes en documentación visual pero no cubiertas claramente por la API actual.

## Acceptance Criteria
- [x] Se inventarían los bloques con diseño visible y contrato ausente o insuficiente: condición de becado, termalismo, tarjeta de estacionamiento, atención a la dependencia, inscripciones en ofertas, mi salud digital.
- [x] Se decide para cada bloque si entra con API real, enlace externo, placeholder controlado o scope posterior.
- [x] Se deja trazado el impacto sobre historias funcionales afectadas.
- [x] Se documentan dependencias con backend/producto.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
  - Blocks:
    - [STORY-23]
    - [STORY-24]
    - [STORY-25]
    - [STORY-31]
  - Related to:
    - [EPIC-3]
    - [EPIC-4]
- Discovery scope:
  - Condición de becado.
  - Termalismo/balnearios.
  - Tarjeta de estacionamiento.
  - Atención a la dependencia.
  - Inscripciones en ofertas.
  - Mi salud digital.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N1 y N8
  - MAPEO_ENDPOINTS_PANTALLAS.md servicios dashboard sin API
  - image_references/Landing Educación.png
  - image_references/Landing Bienestar social.png
  - image_references/Servicios - Demandante de empleo-1.png
  - image_references/Servicios - Atención a la dependencia.png
- Provisional hierarchy:
  - Cross-epic task for [EPIC-3] and health/dashboard reuse in [EPIC-4]
- Dependency map:
  - Blocked by [TASK-16].
  - Blocks [STORY-23], [STORY-24], [STORY-25] y [STORY-31].
  - Cierra decisiones de producto/backend para superficies visibles sin contrato confirmado.

## Notes
### Comments
- 2026-05-04T22:30:00+02:00 | author: Copilot | comment: Discovery completed. Decision matrix per visible-but-uncontracted block — condición de becado: PLACEHOLDER_CONTROLLED; termalismo/balnearios: EXTERNAL_LINK; tarjeta de estacionamiento: EXTERNAL_LINK; atención a la dependencia: EXTERNAL_LINK; inscripciones en ofertas: EXTERNAL_LINK; mi salud digital: DEFERRED to STORY-31 sprint. Full reasoning, swagger evidence, AC-level impact on STORY-23/24/25 and backend follow-ups in `documentation/discovery/TASK-27-dashboard-contract-gaps.md`.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T22:30:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-04T22:30:00+02:00 | status | In Progress -> Done | by Copilot
