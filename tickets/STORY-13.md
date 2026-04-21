---
id: 13
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
  - foundation
  - routing
  - shell
  - deep-links
  - guards
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-13] Shell global, routing, guards y deep links
## Functional Description
Modelar el shell global y la navegación declarativa para áreas autenticadas, no autenticadas, legales y callbacks externos.

## Acceptance Criteria
- [ ] Se contempla GoRouter global con áreas pública y autenticada.
- [ ] Se cubren guards de sesión, rutas de mantenimiento/bloqueo y retorno desde Cl@ve/Afirma.
- [ ] Se refleja la navegación de cabecera, menú lateral y footer/sitemap inferida de las capturas.
- [ ] Se reserva soporte para deep links y redirecciones seguras.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-11]
  - Blocks:
    - [STORY-17]
    - [STORY-20]
    - [STORY-22]
    - [STORY-45]
    - [STORY-62]
  - Related to:
    - [EPIC-1]
    - [EPIC-2]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_a app/routing/shell
  - annex_b navegación/estado
  - image_references/Modal Carnet joven.png
  - image_references/Servicios - Mapa web.png
  - image_references/Landing logado - Educación.png
  - image_references/Landing sin logar.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-1]
- Dependency map:
  - Blocked by [STORY-11].
  - Blocks [STORY-17], [STORY-20], [STORY-22], [STORY-45] y [STORY-62].
  - Related to [EPIC-2].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
