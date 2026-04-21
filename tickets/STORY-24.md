---
id: 24
jira_key:
type: Story
status: To Do
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
reporter:
assignee:
story_points:
labels:
  - empleo
  - dashboard
  - landing
  - external-links
  - api-validation
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-24] Dominio Empleo con estado de demandante e inscripciones en ofertas
## Functional Description
Cubrir la experiencia de empleo incluyendo estado actual, inscripciones y enlaces a portales externos.

## Acceptance Criteria
- [ ] Se contempla landing de Empleo con accesos a información relevante y enlaces.
- [ ] Se contempla pantalla de demandante de empleo con inscripción y fecha de continuidad.
- [ ] Se contempla pantalla de inscripciones en ofertas con listado y estado de candidatura, aunque el contrato requiera validación.
- [ ] Se contemplan enlaces a Empleo CLM y Empleo público CLM y estados vacíos/error.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-22]
    - [TASK-27] (partial)
  - Blocks:
    - None.
  - Related to:
    - [EPIC-3]
    - [STORY-28]
- Confirmed contracts:
  - /sepe/demandante-empleo-fecha-actual/{numDocumento}
- Contract-sensitive surfaces:
  - Inscripciones en ofertas visibles en diseño y pendientes de validación contractual.
  - Portales externos coordinados con navegación saliente consistente.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoint /sepe/demandante-empleo-fecha-actual/{numDocumento}
  - image_references/Landing Empleo.png
  - image_references/Servicios - Demandante de empleo.png
  - image_references/Servicios - Demandante de empleo-1.png
  - image_references/Servicios - Mapa web.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N1
- Provisional hierarchy:
  - Epic candidate: [EPIC-3]
- Dependency map:
  - Blocked by [STORY-22] y parcialmente por [TASK-27].
  - Related to [STORY-28] para Empleo CLM y Empleo público CLM.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
