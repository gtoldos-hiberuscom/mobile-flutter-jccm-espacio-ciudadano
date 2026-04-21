---
id: 9
jira_key:
type: Epic
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
  - ayuda
  - soporte
  - contenidos-estaticos
  - legal
  - sitemap
  - navegacion-global
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [EPIC-9] Ayuda, soporte y contenidos legales de la aplicación
## Functional Description
Cubrir la experiencia de ayuda al usuario, el soporte técnico y las páginas legales/estáticas visibles en navegación y footer, incluyendo FAQ, guías, sitemap y contenidos legales empaquetados, así como los gaps pendientes para integrar el formulario de soporte técnico.

## Acceptance Criteria
- [ ] El epic cubre FAQ/guías, soporte técnico, sitemap y páginas legales.
- [ ] Se reflejan contenidos estáticos empaquetados y los gaps de integración del formulario de soporte.
- [ ] Se contempla navegación global desde footer y menú.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
    - [EPIC-2]
  - Blocks:
    - [STORY-59]
    - [STORY-60]
    - [STORY-61]
    - [STORY-62]
    - [TASK-63]
  - Related to:
    - [EPIC-3]
- Scope decomposition:
  - Centro de ayuda con FAQ, guías y contacto informativo.
  - Formulario de soporte técnico con validaciones, adjuntos, consentimiento y captcha.
  - Páginas legales y estáticas enlazadas desde navegación global.
  - Sitemap y consistencia entre footer, shell y menú lateral.
- Integration gaps:
  - El circuito operativo real del soporte técnico queda pendiente de definición en [TASK-63].
  - Debe distinguirse contenido local empaquetado frente a enlaces externos o formularios dependientes de integración.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantallas 10 y 11
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 10, 11 y 13
  - image_references/Ayuda.png
  - image_references/Ayuda - Soporte.png
  - image_references/Servicios - Mapa web.png
  - image_references/Acceso - Condiciones-1.png
  - image_references/Acceso - Condiciones-2.png
- Provisional hierarchy:
  - Children:
    - [STORY-59]
    - [STORY-60]
    - [STORY-61]
    - [STORY-62]
    - [TASK-63]
- Dependency map:
  - Blocked by [EPIC-1] y [EPIC-2].
  - Related to [EPIC-3] por continuidad de navegación y contenidos transversales.
  - Descompone el trabajo en ayuda, soporte técnico, páginas legales y sitemap.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
