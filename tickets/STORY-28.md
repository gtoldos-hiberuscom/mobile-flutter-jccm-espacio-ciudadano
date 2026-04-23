---
id: 28
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: EPIC-3
parent:
sprint: Sprint 3
reporter:
assignee: Copilot
story_points:
labels:
  - external-links
  - navigation
  - accessibility
  - telemetry
  - security
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-04T17:00:00+02:00
due_date:
jira_url:
---
# [STORY-28] Enlaces externos y navegación saliente de dominios temáticos
## Functional Description
Definir la experiencia consistente de acceso a portales externos y enlaces de interés mostrados en portada, landings y sitemap.

## Acceptance Criteria
- [x] Se contempla apertura segura de enlaces externos con validación de URL.
- [x] Se inventarían y cubren enlaces como Educamos CLM, Carpeta Ciudadana AGE, Sede Electrónica DGT, Empleo CLM, Empleo público CLM, Historia social única e Infancia y familias.
- [x] Se contempla telemetría mínima y feedback de apertura fallida.
- [x] Se contemplan criterios de accesibilidad y retorno al flujo principal.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-14]
  - Blocks:
    - [STORY-23]
    - [STORY-24]
    - [STORY-25]
    - [STORY-26]
    - [STORY-62]
  - Related to:
    - [EPIC-3]
- Outbound navigation scope:
  - Validación de URL y hardening básico antes de abrir el portal externo.
  - Feedback de error y retorno al flujo principal.
  - Cobertura transversal para portada, landings y sitemap.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Landing Educación.png
  - image_references/Landing Bienestar social.png
  - image_references/Landing Empleo.png
  - image_references/Landing logado - Otras temas de interés.png
  - image_references/Servicios - Mapa web.png
  - annex_c §24
- Provisional hierarchy:
  - Epic candidate: [EPIC-3]
- Dependency map:
  - Blocked by [STORY-13] y [STORY-14].
  - Blocks [STORY-23], [STORY-24], [STORY-25], [STORY-26] y [STORY-62].

## Notes
### Comments
- 2026-05-04T17:00:00+02:00 | author: Copilot | comment: Foundational outbound-navigation feature shipped under `lib/features/external_links/`. Catalog hard-coded as security allow-list (7 destinations from AC). Launcher validates `https` scheme + host whitelist, returns sealed `ExternalLinkLaunchResult`, emits `ExternalLinkOpenedEvent` and `ExternalLinkOpenFailedEvent` (reason as short label, never full URL). Reusable `ExternalLinkButton` widget exposes `Semantics(button: true, link: true, hint: externalLinkA11yHint)` and shows a SnackBar on failure (returns user to the originating screen). Ready to be consumed by STORY-23/24/25/26 landings and STORY-62 sitemap; no routing changes shipped here on purpose.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T15:30:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-04T15:30:00+02:00 | sprint | (none) -> Sprint 3 | by Copilot
- 2026-05-04T15:30:00+02:00 | epic_link | (none) -> EPIC-3 | by Copilot
- 2026-05-04T15:30:00+02:00 | assignee | (none) -> Copilot | by Copilot
- 2026-05-04T17:00:00+02:00 | status | In Progress -> Done | by Copilot
- 2026-05-04T17:00:00+02:00 | acceptance_criteria | all 4 checked | by Copilot
