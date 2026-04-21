---
id: 42
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
  - notificaciones
  - contacto
  - onboarding
  - formulario
  - api-contract
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-42] Alta de datos de contacto para plataforma de notificación electrónica
## Functional Description
Cubrir el flujo previo de registro de teléfono móvil y correo electrónico necesario para operar con notificaciones electrónicas, aclarando además las dependencias de backend cuando el contrato no esté confirmado.

## Acceptance Criteria
- [ ] Se contempla formulario con teléfono móvil y correo electrónico, exigiendo al menos uno.
- [ ] Se contempla copy explicativa sobre el uso futuro de esos datos.
- [ ] Se contempla estado de éxito o alta completada y retorno al centro de notificaciones.
- [ ] Se explicitan dependencias de backend si no existe contrato confirmado en la API actual.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-41]
    - [TASK-47]
  - Blocks:
    - [STORY-43]
  - Related to:
    - [EPIC-6]
- Flow slices:
  - Formulario de alta con exigencia de al menos un canal de contacto.
  - Copy explicativa sobre uso futuro de móvil y correo.
  - Éxito de alta y retorno al centro de notificaciones.
  - Backlog condicionado por confirmación del backend real en [TASK-47].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Notificaciones - Alta.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N5
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 5
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-41] y [TASK-47].
  - Blocks [STORY-43].
  - Depende de validar si existe contrato backend real para el alta de contacto.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
