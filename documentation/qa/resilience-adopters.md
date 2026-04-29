# STORY-65 — Resilience adopters

Sprint: Sprint 8 closure (SP-EC-APP-SQ3-08)
Last updated: 2026-05-08

The resilience layer (cache, retry, connectivity) is **opt-in**. This
file is the single source of truth for which features have adopted and
which have explicitly deferred adoption.

Kill-switch: `lib/core/feature_flags/resilience_flag.dart` →
`kResilienceLayerEnabled = true`.

## Primitives shipped in Sprint 7

| Primitive                                       | Path                                                 |
|-------------------------------------------------|------------------------------------------------------|
| Connectivity status (Riverpod stream)           | `lib/core/connectivity/connectivity_status.dart`     |
| Offline banner widget                           | `lib/core/connectivity/offline_banner.dart`          |
| Retry interceptor (idempotent GET/HEAD/OPTIONS) | `lib/core/network/retry_policy.dart`                 |
| TTL key/value cache                             | `lib/core/cache/ttl_cache.dart`                      |
| Shared cache provider                           | `lib/core/cache/ttl_cache_provider.dart`             |

## Sprint 8 closure

Sprint 7 shipped the resilience primitives and adopted them on three
list-style surfaces (agenda, notifications, recommendations). Sprint 8
closes STORY-65 by extending `OfflineBanner` adoption to every remaining
authenticated read-style surface that benefits from a stale-but-useful
indicator, and by locking in a single integration test that exercises
the kill-switch path.

### Surfaces adopted in Sprint 8

| Surface                              | File                                                                                              |
|--------------------------------------|---------------------------------------------------------------------------------------------------|
| Casework workspace (Mis gestiones)   | `lib/features/casework/2_presentation/casework_workspace_page.dart`                               |
| Expediente detail                    | `lib/features/casework/detail/2_presentation/expediente_detail_page.dart`                         |
| Digital cards catalog                | `lib/features/digital_cards/2_presentation/digital_cards_catalog_page.dart`                       |
| Carnet familia numerosa detail       | `lib/features/digital_cards/familia_numerosa/2_presentation/familia_numerosa_detail_page.dart`    |
| Carnet joven detail (full page)      | `lib/features/digital_cards/joven/2_presentation/joven_detail_page.dart`                          |
| Carnet discapacidad detail           | `lib/features/digital_cards/discapacidad/2_presentation/discapacidad_detail_page.dart`            |
| Signature inbox                      | `lib/features/signature/2_presentation/signature_inbox_page.dart`                                 |
| Help center (FAQ list)               | `lib/features/help/2_presentation/help_page.dart`                                                 |

### Surfaces verified (no edit) in Sprint 8

| Surface           | File                                                                          |
|-------------------|-------------------------------------------------------------------------------|
| Agenda list       | `lib/features/agenda/2_presentation/agenda_page.dart` (Sprint 7)              |
| Notifications     | `lib/features/notifications/2_presentation/notifications_center_page.dart` (Sprint 7) |
| Recommendations   | `lib/features/recommendations/2_presentation/recommendations_page.dart` (Sprint 7) |

### Out-of-scope surfaces (and why)

| Surface                                        | Reason for exclusion                                                                                       |
|------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| Authenticated home dashboard                   | No real `lib/features/home/` exists yet — `Routes.home` is reserved but unbound (see `lib/app/routing/route_registry.dart`). Adoption deferred until the home page is implemented (carryover for Sprint 9 — see "Carryover"). |
| Carnet joven modal (`JovenDetailModal`)        | Not a `Scaffold`-rooted page; renders via modal. Banner only fits page-rooted surfaces.                    |
| Static legal pages (terms, privacy, accessibility, legal notice) | Content is bundled and read-only; no network call, banner adds no signal. |
| Sitemap, support form, afirma return, aportación wizard, casework search, registro detail, upload-evidence | Short-lived flows or wizards driven by user input — banner is advisory for cached lists, not for action surfaces. |
| Auth / landing / onboarding                    | Pre-authentication surfaces; the connectivity stream is wired inside the authenticated shell. |

### Kill-switch contract

`kResilienceLayerEnabled` (`lib/core/feature_flags/resilience_flag.dart`)
is a `const bool` evaluated by `OfflineBanner.build`. When `false`, the
banner short-circuits to `child` and renders no extra chrome — adopters
collapse to a transparent pass-through. The flag is the single point of
disablement for every adopter listed in the matrix; no adopter performs
its own gating. Flipping the constant to `false` and rebuilding produces
a binary in which all adopter sites behave as if the resilience layer
were absent (the banner cannot render even when offline).

### Integration test

`test/integration/resilience_kill_switch_test.dart` pumps a minimal page
wrapped in `OfflineBanner` and asserts:

1. `kResilienceLayerEnabled` defaults to `true` (the kill-switch is
   shipped enabled).
2. With connectivity overridden to `online`, the banner does NOT render
   the `cloud_off` indicator and the wrapped child remains visible.
3. With connectivity overridden to `offline`, the banner DOES render
   the `cloud_off` indicator and the wrapped child remains visible
   (banner is advisory, never replaces cached content).

If the kill-switch is ever made overridable at runtime, this test must
gain a third case that flips the flag and asserts the banner stays
hidden while offline.

### Carryover for Sprint 9

- **Authenticated home page**: when `lib/features/home/` materializes,
  add `OfflineBanner` to its top-level `Scaffold.body` and update the
  matrix. The route registry currently lists `Routes.home = '/home'`
  but no `GoRoute` is bound — see `lib/app/routing/app_router.dart`.
- **Banner copy l10n migration**: the banner message is still
  hard-coded ES (Sprint 7 carryover). When ARB keys are introduced,
  delete the inline default in `OfflineBanner.build` and supply the
  l10n key via the `message:` parameter at each adopter site.

## Wiring matrix

| Feature             | Connectivity banner | TTL cache key prefix | Retry inherits | Status            |
|---------------------|---------------------|----------------------|----------------|-------------------|
| Agenda list         | ✅ adopted          | `agenda:`            | ✅             | Sprint 7 — wave 3 |
| Notifications inbox | ✅ adopted          | `notifications:`     | ✅             | Sprint 7 — wave 3 |
| Recommendations     | ✅ adopted          | `recommendations:`   | ✅             | Sprint 7 — wave 3 |
| Casework workspace  | ✅ adopted          | `casework:` reserved | ✅ (Dio-level) | Sprint 8 closure  |
| Expediente detail   | ✅ adopted          | `casework:` reserved | ✅ (Dio-level) | Sprint 8 closure  |
| Digital cards catalog | ✅ adopted        | `cards:` reserved    | ✅ (Dio-level) | Sprint 8 closure  |
| Carnet familia numerosa | ✅ adopted      | `cards:` reserved    | ✅ (Dio-level) | Sprint 8 closure  |
| Carnet joven (full page) | ✅ adopted     | `cards:` reserved    | ✅ (Dio-level) | Sprint 8 closure  |
| Carnet discapacidad | ✅ adopted          | `cards:` reserved    | ✅ (Dio-level) | Sprint 8 closure  |
| Signature inbox     | ✅ adopted          | n/a                  | ✅ (Dio-level) | Sprint 8 closure  |
| Help (FAQ list)     | ✅ adopted          | n/a                  | n/a            | Sprint 8 closure (banner only — content bundled) |
| Authenticated home  | ⏸ deferred          | n/a                  | n/a            | Page does not exist yet — Sprint 9 carryover |
| Static legal pages  | n/a                 | n/a                  | n/a            | Static content shipped offline by design |

The retry interceptor is installed once at the Dio client level
(`lib/core/network/api_client.dart`), so every feature inherits it for
free on idempotent reads. Adopters of cache + offline banner are the
list-style surfaces where stale-but-useful data > nothing.

## Cache TTL policy (initial)

| Key prefix         | TTL    | Justification                                  |
|--------------------|--------|------------------------------------------------|
| `agenda:list`      | 5 min  | Citizen-facing planning data, low volatility   |
| `notifications:inbox` | 2 min | Higher volatility, must reflect new arrivals  |
| `recommendations:list` | 30 min | Curated content, very low volatility       |

PII boundary: the TTL cache is **memory only**. Anything PII (e.g., NIF,
expediente number, attachment bytes) MUST NOT cross to disk. See
TASK-69 for the persistent-cache decision when that ticket is reopened.

## Operational notes

- Banner copy is hard-coded ES today; l10n key migration is tracked as a
  Sprint 8 follow-up (no new ticket created — handled inside STORY-65
  closure work in Sprint 8).
- The retry interceptor never retries POST/PUT/PATCH/DELETE. Endpoints
  that need server-side idempotency (e.g., the future
  `/soporte/incidencia` from TASK-63) will need explicit
  `Idempotency-Key` headers and a separate adopter ticket.
