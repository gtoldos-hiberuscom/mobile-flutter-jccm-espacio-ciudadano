---
id: 23
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
  - educacion
  - dashboard
  - landing
  - titulos
  - external-links
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-23] Dominio Educación con landing, títulos y enlaces de interés
## Functional Description
Cubrir la experiencia de educación desde la landing hasta el detalle de títulos y enlaces relacionados.

## Acceptance Criteria
- [ ] Se contempla landing de Educación con información relevante, trámites sugeridos y enlaces.
- [ ] Se contemplan listados/detalles de títulos universitarios y no universitarios con campos específicos.
- [ ] Se contempla la condición de becado como capacidad explícita del diseño, aunque pueda requerir validación adicional de contrato.
- [ ] Se contemplan enlaces externos como Educamos CLM y surfaces de empty/error.

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
  - /educacion/titulos-universitarios/{numDocumento}
  - /educacion/titulos-no-universitarios/{numDocumento}
- Contract-sensitive surfaces:
  - Condición de becado visible en diseño y sujeta a validación adicional.
  - Enlaces externos y fallback de error/empty coordinados con [STORY-28].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoint /educacion/titulos-universitarios/{numDocumento}
  - endpoint /educacion/titulos-no-universitarios/{numDocumento}
  - image_references/Landing Educación.png
  - image_references/Landing Educación-1.png
  - image_references/Servicios - Ttítulos universitarios.png
  - image_references/Servicios - Ttítulos no universitarios.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 1
- Provisional hierarchy:
  - Epic candidate: [EPIC-3]
- Dependency map:
  - Blocked by [STORY-22] y parcialmente por [TASK-27].
  - Related to [STORY-28] para navegación saliente y enlaces de interés.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
