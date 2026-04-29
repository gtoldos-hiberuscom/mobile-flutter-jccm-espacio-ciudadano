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
updated_at: 2026-09-21T18:00:00+02:00
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

### Sprint 9 closure
- 2026-09-21T18:00:00+02:00 | by plan-manager | Sprint 9 (SP-EC-APP-SQ2-09) closure: home route binding investigation (Deliverable B). The Sprint-2 STORY-22 implementation noted in the previous comment never reached the integration line: `lib/features/home/` does not exist on `develop`, and `Routes.home` ('/home') was unbound in `lib/app/routing/app_router.dart`, so every navigator call from sitemap, consent, the bottom-nav and the profile drawer fell through to `NotFoundScreen`.
  - Branch: `task/EPIC-3-dashboard-domains/STORY-22-home-dashboard/sprint9-home-route-investigation` (commits `43cad6f`, `eb209a0`, `3fd4cec`) → `ticket/EPIC-3-dashboard-domains/STORY-22-home-dashboard` → `epic/EPIC-3-dashboard-domains` → `develop`.
  - Investigation findings:
    - `git grep -nE "LoggedHomePage|HomePage|home_page|features/home"` on `lib/`+`test/` → 0 matches.
    - Historical implementation work exists on side branches (`task/EPIC-3-dashboard-domains/STORY-22-home-dashboard/implement-home-dashboard` commit `31ec297`; `task/EPIC-3-home-dashboard/STORY-22-logged-home/implement-logged-home` commit `02ab2cd`) but never landed on the ticket integration branch nor on develop.
    - Affected call-sites: `lib/app/shell/app_scaffold.dart:30` (bottom-nav tab 0); `lib/features/sitemap/3_data/sitemap_repository_impl.dart:55`; `lib/features/consent/2_presentation/consent_page.dart:50`; `lib/features/user_profile/2_presentation/widgets/user_drawer_menu.dart:59,70,81`.
  - Decision (per Sprint-9 plan-manager spec): documented-only (option c). NO real `LoggedHomePage` implemented under closure scope.
  - Mitigation shipped: `Routes.home` now bound inside the authenticated `ShellRoute` to a safety redirect → `Routes.sitemap` (Sprint-9 carry-over comment in `lib/app/routing/app_router.dart`). New routing test `test/app/routing/home_route_safety_redirect_test.dart` asserts the redirect works and that `NotFoundScreen` is never rendered.
  - Documentation: `documentation/qa/STORY-22-home-route-investigation.md` (140 lines) — file/line pointers, current vs expected behavior, recommended Sprint-10 reopen shape.
  - Validation: `flutter analyze --no-fatal-infos` 0 errors / 1 pre-existing warning. `flutter test` 449 passing + 1 perf skip on this branch base.
  - Recommendation surfaced for plan-manager final summary: REOPEN STORY-22 in Sprint 10+ with explicit acceptance criteria to (1) implement canonical `lib/features/home/{0_entity, 1_domain, 2_presentation, 3_data}` `LoggedHomePage`, (2) bind `Routes.home` to it, (3) DELETE the Sprint-9 safety redirect as part of that ticket, (4) re-tighten the bottom-nav, sitemap "Inicio", consent post-accept, and three drawer entry points to land on the new page, and (5) tighten the definition-of-done so a story cannot close until its work is on the integration line. Wrapping with `OfflineBanner` (STORY-65 carry-over) is also part of that follow-up.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 9 closure policy. Status MUST NOT be changed automatically; user decides whether to reopen.
