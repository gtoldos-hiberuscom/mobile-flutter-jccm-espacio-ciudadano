---
id: 65
jira_key: JCCMEC-64
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-32
parent: JCCMEC-32
sprint: Sprint 7
reporter:
assignee:
story_points:
labels:
  - cache
  - offline
  - conectividad
  - resiliencia
  - retry
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-64
---
# [STORY-65] Caché, offline, conectividad, retry y resiliencia de datos
## Functional Description
Definir la estrategia de resiliencia transversal para red inestable, datos estáticos y flujos con refresh, estableciendo políticas de caché, offline, retry y fallback diferenciadas según sensibilidad y volatilidad de la información.

## Acceptance Criteria
- [x] Se contempla caché razonable por módulos y contenido estático offline.
- [x] Se contemplan reintentos, pull-to-refresh y detección de conectividad.
- [x] Se contemplan políticas diferenciadas para datos sensibles y no sensibles.
- [x] Se contemplan fallback states para módulos con contratos externos inestables.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
    - [STORY-15]
    - [TASK-69]
  - Blocks:
    - [STORY-67]
  - Related to:
    - [EPIC-10]
- Resilience scope:
  - Estrategia de caché por módulo y disponibilidad offline de contenido estático.
  - Detección de conectividad, retry y pull-to-refresh.
  - Políticas diferenciadas para datos sensibles frente a datos consultivos.
  - Estados fallback para integraciones o contratos externos inestables.
- Security and data considerations:
  - Las restricciones de PII y almacenamiento seguro se coordinan con [TASK-69].
  - Debe contemplarse refresh y expiración adecuados según tipo de dato.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_b estrategia de datos/caché
  - annex_c §25
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 13
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md R4
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-12], [STORY-15] y [TASK-69].
  - Blocks [STORY-67].
  - Define la resiliencia transversal y disponibilidad degradada del epic [EPIC-10].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 (SP-EC-APP-SQ3-07): To Do → In Progress. Wave 1 — core resilience primitives landed on `task/EPIC-10-quality-release/STORY-65-resilience/core-primitives`: `lib/core/connectivity/connectivity_status.dart` (connectivity_plus 6.x stream), `lib/core/connectivity/offline_banner.dart`, `lib/core/network/retry_policy.dart` (exp-backoff + jitter, idempotent methods only, wired into `api_client.dart` behind `kResilienceLayerEnabled`), `lib/core/cache/ttl_cache.dart` + provider. Adopters matrix in `documentation/qa/resilience-adopters.md`. 14 unit tests added under `test/core/{cache,connectivity,network}`.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Wave 3 — feature adopters landed on `task/EPIC-10-quality-release/STORY-65-resilience/feature-adopters`: agenda, notifications and recommendations pages now wrap their body with `OfflineBanner`. All 149 existing feature tests still pass. Acceptance criteria satisfied: cache (TTL primitive + per-module key prefixes documented), retry (idempotent-only Dio interceptor; pull-to-refresh already present in adopters), políticas diferenciadas (cache memory-only by design; PII boundary documented; persistence deferred to TASK-69), fallback states (offline banner + each adopter keeps showing cached data). Status → Done. Follow-ups for Sprint 8/9 captured in resilience-adopters.md.

### Sprint 8 closure
- 2026-08-25T12:00:00+02:00 | by plan-manager | Sprint 8 (SP-EC-APP-SQ3-08) closure: Resilience adoption sweep across remaining repo-driven user-facing reads.
  - Branches: `task/EPIC-10-quality-release/STORY-65-resilience/sprint8-resilience-adoption-sweep` (commit `53fbbd9`) → `ticket/EPIC-10-quality-release/STORY-65-resilience` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - OfflineBanner adopted on: casework workspace + expediente detail; digital cards catalog + familia-numerosa, joven and discapacidad detail pages; signature inbox; help (FAQ).
    - Recommendations page already wrapped in Sprint 7 (verified, no edit).
    - Final adoption matrix in `documentation/qa/resilience-adopters.md` (Sprint 8 closure section).
    - Kill-switch validation: `test/integration/resilience_kill_switch_test.dart` exercises the connectivity-driven banner contract via Riverpod overrides (3 cases).
    - Defect surfaced (Sprint-9 carryover, recommendation only): `lib/features/home/` does not exist in the repo; `Routes.home` is unbound in `lib/app/routing/app_router.dart`. Wrapping deferred until that page lands.
  - Validation: `flutter analyze --no-fatal-infos` 0 errors / 1 pre-existing warning. `flutter test` 443 passing + 1 perf skip (440 baseline + 3 new kill-switch cases).
  - Status unchanged (Done). Ticket Notes-only update per Sprint 8 closure policy.

### Sprint 9 closure
- 2026-09-21T18:00:00+02:00 | by plan-manager | Sprint 9 (SP-EC-APP-SQ3-09) closure: resilience continuation (Deliverable E).
  - Branch: `task/EPIC-10-quality-release/STORY-65-resilience/sprint9-localize-and-wrap` (commits `9bb8b32`, `e9ec101`) → `ticket/EPIC-10-quality-release/STORY-65-resilience` → `epic/EPIC-10-quality-release` → `develop`.
  - Evidence:
    - OfflineBanner copy localized: new ARB key `offlineBannerMessage` added to `lib/l10n/app_es.arb` ("Sin conexión. Mostrando datos guardados.") and `lib/l10n/app_en.arb` ("Offline. Showing cached data.") with matching `@` description blocks. `flutter gen-l10n` regenerated `lib/l10n/app_localizations.dart` + `app_localizations_es.dart` + `app_localizations_en.dart` (checked in).
    - `lib/core/connectivity/offline_banner.dart` — fallback message now resolved from `Localizations.of<AppLocalizations>(context, AppLocalizations)?.offlineBannerMessage` with a defensive Spanish hard-coded fallback for the unlikely case the delegate is missing. The `message:` parameter override remains the highest-precedence path.
    - New widget test `test/core/connectivity/offline_banner_test.dart` — three cases: ES locale renders Spanish fallback, EN locale renders English fallback, `message:` override wins.
  - Home wrapping (Sprint-9 plan): DEFERRED. Per the cross-deliverable B finding, `Routes.home` is currently a safety redirect to `/sitemap` and there is no `LoggedHomePage`. Wrapping the home page with `OfflineBanner` is therefore deferred until STORY-22 reopens to implement the page; the deferral is recorded inline in the OfflineBanner doc comment and in `documentation/qa/STORY-65-home-wrapping-deferred.md` (cross-references `documentation/qa/STORY-22-home-route-investigation.md` which lives on the EPIC-3 branch family).
  - Validation:
    - `flutter analyze --no-fatal-infos` — 0 errors / 1 pre-existing warning (unchanged baseline).
    - `flutter test` — 451 passing + 1 perf skip on this branch base (3 new offline-banner cases over the 448+1 base).
    - `dart format --set-exit-if-changed` clean for touched files.
  - Status unchanged (Done). Ticket Notes-only update per Sprint 9 closure policy.
