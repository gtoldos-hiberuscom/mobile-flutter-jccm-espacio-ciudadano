---
id: 18
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
  - auth
  - session
  - clave
  - security
  - federation
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-18] Login Cl@ve, callback seguro y ciclo de vida de sesión
## Functional Description
Modelar la autenticación con Cl@ve y el ciclo de vida completo de la sesión para alimentar servicios federados y flujos protegidos.

## Acceptance Criteria
- [ ] Se contempla inicio de login con Cl@ve y retorno seguro a la app.
- [ ] Se contemplan persistencia segura, restauración de sesión, expiración, renovación y cierre de sesión.
- [ ] Se contempla inyección uniforme de claims/token en llamadas protegidas.
- [ ] Se contemplan errores 401/403, sesión caducada y pérdida de claims obligatorios.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
    - [STORY-13]
    - [STORY-17]
  - Blocks:
    - [STORY-20]
    - [STORY-22]
    - [STORY-29]
    - [STORY-34]
    - [STORY-41]
    - [STORY-45]
    - [STORY-48]
    - [STORY-54]
  - Related to:
    - [EPIC-2]
    - [TASK-21]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md S1/N10
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 12
  - PLANIFICACION_PROYECTO.md fase 1
  - annex_c §24
- Provisional hierarchy:
  - Epic candidate: [EPIC-2]
- Dependency map:
  - Blocked by [STORY-12], [STORY-13] y [STORY-17].
  - Blocks [STORY-20], [STORY-22], [STORY-29], [STORY-34], [STORY-41], [STORY-45], [STORY-48] y [STORY-54].
  - Related to [TASK-21].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
