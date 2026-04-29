---
id: 71
jira_key:
type: Task
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
  - portada-logada
  - mis-carnets-digitales
  - analisis-funcional
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T08:10:00+02:00
due_date:
jira_url:
---
# [TASK-71] Aclarar superficies adicionales de carnets mostradas en portada
## Functional Description
Validar y reconciliar con el alcance oficial las superficies de tarjeta sanitaria y tarjeta de biblioteca visibles en el widget de “Mis carnets digitales” de la portada logada. El objetivo es determinar si ambas superficies corresponden a carnets digitales reales, accesos rápidos a otros módulos o elementos descartados del MVP, y dejar documentada la decisión funcional, de producto y/o backend necesaria cuando no exista contrato o diseño detallado adicional.

## Acceptance Criteria
- [x] Se documenta si Tarjeta Sanitaria y Tarjeta Biblioteca son carnets digitales reales, accesos rápidos a otros módulos o elementos descartados del MVP.
- [x] Se define su relación con CIP/salud y con el catálogo de carnets del EPIC-7.
- [x] Se deja trazado el impacto sobre STORY-22, STORY-31 y STORY-48.
- [x] Se documenta la decisión de producto/backend necesaria si no existe contrato ni diseño detallado adicional.

## Technical Details
- Platform(s): Multi-platform
- Environment:
- Dependencies:
  - Blocked by:
    - [TASK-27]
  - Blocks:
  - Related to:
    - [EPIC-3]
    - [EPIC-4]
    - [EPIC-7]
    - [STORY-22]
    - [STORY-31]
    - [STORY-48]
- Scope notes:
  - Revisar la correspondencia entre las superficies visibles en portada y el alcance funcional oficial del módulo de carnets digitales.
  - Confirmar si Tarjeta Sanitaria y Tarjeta Biblioteca requieren contrato backend, definición de navegación o descarte explícito del MVP.

## Traceability
- Jira:
- Epic:
- Parent:
- Related:
  - [EPIC-3]
  - [EPIC-4]
  - [EPIC-7]
  - [STORY-22]
  - [STORY-31]
  - [STORY-48]
- References:
  - image_references/Landing logado mobile.png
  - image_references/Servicios - Mis carnets digitales.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md alcance funcional
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 2 y 6

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 — Initial file creation by Copilot.
- 2026-04-21T23:50:13+02:00 | by Copilot | Normalized dependency references after backlog audit.
- 2026-04-22T08:00:00+02:00 | by plan-manager | Sprint 4 start: To Do → In Progress; sprint set to Sprint 4.
- 2026-04-22T08:05:00+02:00 | by plan-manager | Discovery completed in `documentation/discovery/TASK-71-cards-surfaces-decision.md`. Decisions: Tarjeta Sanitaria → CIP_REUSE (no wallet semantics, owned by STORY-31, rendered as read-only mini-card in STORY-48 catalogue); Tarjeta de Biblioteca → OUT_OF_MVP (default omit; "Próximamente" placeholder only if product opts in). STORY-22 retro-confirmed as compatible (no code change). Open follow-ups for product on biblioteca scope and TASK-53 scheduling for full carnet payload binding.
- 2026-04-22T08:10:00+02:00 | by plan-manager | All AC satisfied; In Progress → Done. Task branch `task/EPIC-7-digital-cards-wallet/TASK-71-cards-surfaces-discovery/document-cards-surfaces` integrates upward via merge commits.
