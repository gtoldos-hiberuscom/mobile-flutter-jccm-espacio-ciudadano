---
id: 22
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 2
reporter:
assignee:
story_points:
labels:
  - dashboard
  - home
  - citizen-summary
  - widgets
  - partial-errors
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-04T15:00:00+02:00
due_date:
jira_url:
---
# [STORY-22] Portada logada con resumen ciudadano y accesos rápidos
## Functional Description
Diseñar la home autenticada con saludo, resumen temático, próximos eventos, accesos directos y degradación por errores parciales.

## Acceptance Criteria
- [x] Se contempla saludo personalizado e identificador del ciudadano.
- [x] Se contemplan bloques/resúmenes por áreas temáticas y navegación a sus landings.
- [x] Se contemplan widgets de próximos eventos, mis expedientes, mis notificaciones, mis carnets digitales y recomendaciones.
- [x] Se contemplan timestamps de actualización, estados vacíos y fallos parciales sin bloquear el resto de la home.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-14]
    - [STORY-15]
    - [STORY-18]
    - [STORY-20]
  - Blocks:
    - [STORY-23]
    - [STORY-24]
    - [STORY-25]
    - [STORY-26]
    - [STORY-29]
    - [STORY-31]
  - Related to:
    - [EPIC-3]
    - [STORY-28]
- Home composition:
  - Resúmenes por dominio con navegación a landings temáticas.
  - Widgets con comportamiento degradable por errores parciales.
  - Timestamp de actualización y empty states por bloque.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Landing logado - Educación.png
  - image_references/Landing logado - Otras temas de interés.png
  - image_references/Landing logado mobile.png
  - image_references/Landing logado mobile-2.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 1
- Provisional hierarchy:
  - Epic candidate: [EPIC-3]
- Dependency map:
  - Blocked by [STORY-13], [STORY-14], [STORY-15], [STORY-18] y [STORY-20].
  - Blocks [STORY-23], [STORY-24], [STORY-25], [STORY-26], [STORY-29] y [STORY-31].
  - Related to [STORY-28] para navegación saliente consistente.

## Notes
### Comments
- 2026-05-04T15:00:00+02:00 | author: Copilot | comment: Implementación end-to-end de la home autenticada bajo `lib/features/home/` (capas 0_entity → 3_data) con HomePage, HomeBlockCard, HomeDashboardNotifier y mock HomeDashboardRepositoryImpl que expone bloques en estado loaded / empty / partial-error. Routing reemplaza HomePlaceholder por HomePage y añade rutas autenticadas /education, /employment, /social-welfare y /state-affairs sobre DomainLandingPlaceholder pendientes de STORY-23/24/25/26. l10n añadida en `app_es.arb` y `app_en.arb` (`home_*`) y `AppLocalizations` regenerado. Evento analítico `HomeBlockNavigateEvent` PII-free al pulsar bloque. Validación: `flutter analyze` 44 issues (baseline 43, +1 informativo en `lib/features/user_profile/user_profile.dart`); `flutter test test/features/home/` 2/2 OK. Commits: `chore(tickets): [STORY-22] To Do -> In Progress` y `feat(dashboard-domains): [EPIC-3/STORY-22/implement-home-dashboard] authenticated home dashboard with thematic blocks`.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-04T15:00:00+02:00 | status | To Do -> In Progress | by Copilot
- 2026-05-04T15:00:00+02:00 | status | In Progress -> Done | by Copilot
- 2026-05-04T15:00:00+02:00 | sprint | (unset) -> Sprint 2 | by Copilot
- 2026-05-04T15:00:00+02:00 | acceptance_criteria | all four AC checked off as implemented | by Copilot
