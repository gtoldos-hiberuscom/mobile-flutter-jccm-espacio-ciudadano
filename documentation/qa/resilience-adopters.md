# STORY-65 — Resilience adopters

Sprint: Sprint 7 (SP-EC-APP-SQ3-07)
Last updated: 2026-04-29

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

## Wiring matrix

| Feature             | Connectivity banner | TTL cache key prefix | Retry inherits | Status            |
|---------------------|---------------------|----------------------|----------------|-------------------|
| Agenda list         | ✅ adopted          | `agenda:`            | ✅             | Sprint 7 — wave 3 |
| Notifications inbox | ✅ adopted          | `notifications:`     | ✅             | Sprint 7 — wave 3 |
| Recommendations     | ✅ adopted          | `recommendations:`   | ✅             | Sprint 7 — wave 3 |
| Casework workspace  | ⏸ deferred          | `casework:` reserved | ✅ (Dio-level) | Opt-in pending — STORY-65 follow-up |
| Digital cards       | ⏸ deferred          | `cards:` reserved    | ✅ (Dio-level) | Already binary-cached on disk per STORY-50 |
| Help / static       | n/a                 | n/a                  | n/a            | Static content shipped offline by design |
| Signature           | ⏸ deferred          | n/a                  | ✅ (Dio-level) | Flow is short-lived; no list/feed |

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
