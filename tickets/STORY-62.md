---
id: 62
jira_key: JCCMEC-61
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
  - sitemap
  - footer
  - navegacion-global
  - menu
  - enlaces-externos
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:36:00+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-61
---
# [STORY-62] Mapa web y navegación global de footer
## Functional Description
Cubrir la página de mapa web y la consistencia de accesos globales desde footer/cabecera, asegurando que la jerarquía funcional visible en diseño se traduzca en un sitemap navegable y coherente con shell y menú lateral.

## Acceptance Criteria
- [x] Se contempla sitemap navegable con la jerarquía funcional visible en diseño.
- [x] Se contemplan accesos globales a ayuda, accesibilidad, aviso legal, protección de datos y mapa web.
- [x] Se contempla consistencia entre mapa web, shell y menú lateral.
- [x] Se contemplan enlaces internos y externos seguros.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-28]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-9]
- Navigation scope:
  - Sitemap navegable con jerarquía funcional reconocible.
  - Accesos globales desde footer/cabecera a ayuda y páginas legales.
  - Consistencia entre shell, menú lateral y mapa web.
  - Gestión segura de enlaces internos/externos.
- Cross-cutting considerations:
  - Debe servir de punto de entrada a [STORY-59] y [STORY-61].
  - La navegación global debe reflejar tanto contenido local como enlaces a recursos externos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Servicios - Mapa web.png
  - image_references/Landing sin logar.png
  - image_references/Ayuda.png
  - image_references/Modal Carnet joven.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-9]
- Dependency map:
  - Blocked by [STORY-13] y [STORY-28].
  - Sin descendientes explícitos en este corte.
  - Aporta la capa de navegación global y sitemap del epic [EPIC-9].

## Notes
### Comments
- 2026-05-04T20:00:00+02:00 | by Copilot | Implemented sitemap feature under `lib/features/sitemap/` (entity/domain/data/presentation). External nodes resolved via the STORY-28 `ExternalLinkCatalog` provider — no URLs hard-coded again. Wired `Routes.sitemap` to `SitemapPage`. Added authenticated-only footer in `lib/app/shell/app_scaffold.dart` linking Help, Sitemap and the four legal pages, each wrapped in `Semantics(button: true, label: ...)`. Footer lives inside the `ShellRoute` so unauthenticated landing/login keep their original chrome. Added `sitemap_repository_test.dart` (5 tests, pass). Analyze 47 issues (+2 vs Sprint-2 baseline, well within budget).

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T20:00:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-04T20:00:00+02:00 | status | In Progress -> Done | by Copilot
- 2026-05-04T20:00:00+02:00 | sprint | (none) -> Sprint 2 | by Copilot
