---
id: 59
jira_key: JCCMEC-58
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-31
parent: JCCMEC-31
sprint: Tablero Sprint 2
reporter:
assignee:
story_points:
labels:
  - ayuda
  - faq
  - guias
  - contacto
  - contenidos-estaticos
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:36:00+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-58
---
# [STORY-59] Centro de ayuda con FAQ, guías y contacto informativo
## Functional Description
Cubrir la pantalla de ayuda con preguntas frecuentes, guías y datos de contacto informativo, organizando los contenidos para consulta local y acceso a recursos externos de apoyo al ciudadano cuando aplique.

## Acceptance Criteria
- [x] Se contempla listado FAQ en formato acordeón con respuesta expandible.
- [x] Se contempla búsqueda local y organización temática de contenidos según documentación funcional.
- [x] Se contemplan secciones de guías de ayuda y datos de contacto administrativo.
- [x] Se contemplan enlaces a recursos externos como oficinas de información y registro o vídeos cuando apliquen.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-14]
    - [STORY-15]
  - Blocks:
    - [STORY-60]
  - Related to:
    - [EPIC-9]
- Help center scope:
  - FAQ en acordeón con expansión/colapso.
  - Búsqueda local y agrupación temática de contenidos.
  - Secciones informativas con teléfonos, correos o vías administrativas equivalentes.
  - Enlaces externos seguros a recursos complementarios.
- Content assumptions:
  - Parte del contenido puede venir empaquetado o precargado.
  - La estructura base de ayuda condiciona la coherencia del formulario posterior de [STORY-60].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Ayuda.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 11
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 11
- Provisional hierarchy:
  - Epic candidate: [EPIC-9]
- Dependency map:
  - Blocked by [STORY-14] y [STORY-15].
  - Blocks [STORY-60] al definir el contexto y la entrada a soporte técnico.
  - Forma parte del frente de ayuda y contenidos informativos del epic [EPIC-9].

## Notes
### Comments
- 2026-05-04T19:00:00+02:00 | by Copilot | Implemented help center under `lib/features/help/` with FAQ accordion, local search, guides and contacts. Wired `/help` route to `HelpPage`. Added `help_repository_test.dart` (4 tests, pass). `flutter analyze` 45 issues (baseline preserved). Offline-first: content bundled.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T19:00:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-04T19:00:00+02:00 | status | In Progress -> Done | by Copilot
- 2026-05-04T19:00:00+02:00 | sprint | (none) -> Sprint 2 | by Copilot
