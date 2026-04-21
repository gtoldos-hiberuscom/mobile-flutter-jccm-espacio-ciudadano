---
id: 31
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
  - salud
  - cip
  - dashboard
  - reuse
  - contract-gap
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-31] CIP y superficies de salud reutilizadas entre home y agenda
## Functional Description
Contemplar la tarjeta sanitaria/CIP y los accesos rápidos de salud reutilizados desde portada y agenda.

## Acceptance Criteria
- [ ] Se contempla visualización del CIP o tarjeta sanitaria como dato destacado de salud.
- [ ] Se contempla reutilización del resumen de próximos eventos desde la portada hacia la agenda completa.
- [ ] Se contempla integración con la sección de salud del dashboard y sus accesos.
- [ ] Se explicitan gaps de contrato para capacidades de salud visibles en diseño pero no confirmadas.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-22]
    - [STORY-29]
    - [TASK-27] (partial)
  - Blocks:
    - None.
  - Related to:
    - [EPIC-4]
    - [EPIC-3]
    - [TASK-32]
- Confirmed contracts:
  - /sescam/cip/{numDocumento}
- Contract-sensitive surfaces:
  - Mi salud digital y otras capacidades visibles en diseño quedan sujetas al cierre de [TASK-27].
  - Reutilización home/agenda coordinada con el resumen de próximos eventos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoint /sescam/cip/{numDocumento}
  - image_references/Servicios - Mis citas médicas.png
  - image_references/Landing logado - Educación.png
  - image_references/Servicios - Mapa web.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-4]
  - Cross-epic reuse with [EPIC-3]
- Dependency map:
  - Blocked by [STORY-22], [STORY-29] y parcialmente por [TASK-27].
  - Related to [TASK-32] para validar parsing/shape real del dato de salud.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
