# STORY-64 — Sprint 8 telemetry verification

| Field   | Value                                                                                        |
| ------- | -------------------------------------------------------------------------------------------- |
| Ticket  | STORY-64 (observability) — Epic EPIC-10 (quality & release)                                  |
| Sprint  | 8 (closure)                                                                                  |
| Date    | 2026-04-29                                                                                   |
| Branch  | `task/EPIC-10-quality-release/STORY-64-observability/sprint8-telemetry-verification`         |
| Base SHA| `79151ae` (worktree HEAD prior to this work)                                                 |
| Scope   | Read-only audit of analytics/logging code + 1 new spot-check test + this report              |

---

## 1. Events enumerated

All concrete `AnalyticsEvent` subclasses live in `lib/core/analytics/analytics_event.dart` (a sealed hierarchy). The table below cross-references each class with its emission sites and a per-class redaction classification.

| #  | Event class                  | File / line                                                      | Feature owner    | Fields                                                               | Emitted from                                                                                                                                                                                                                                          | Redaction status                  |
| -- | ---------------------------- | ---------------------------------------------------------------- | ---------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------- |
| 1  | `PageViewEvent`              | `core/analytics/analytics_event.dart:24`                         | core (navigation)| `pageName: String` (route slug), `parameters: Map<String,String>?`   | `app/observers/analytics_observer.dart:48` (NavigatorObserver — fed by `Route.settings.name`)                                                                                                                                                          | Safe by design (route-slug only)  |
| 2  | `DownloadEvent`              | `core/analytics/analytics_event.dart:40`                         | core (actions)   | `documentType: String`, `mimeType: String?`                          | *no current emitter* — defined for future use                                                                                                                                                                                                          | Safe by design (category labels)  |
| 3  | `HomeBlockNavigateEvent`     | `core/analytics/analytics_event.dart:55`                         | core (navigation)| `blockId: String`, `target: String?`                                 | *no current emitter* — defined for future home-block dashboards                                                                                                                                                                                        | Safe by design (stable IDs)       |
| 4  | `ExternalLinkEvent`          | `core/analytics/analytics_event.dart:69`                         | external_links   | `domain: String` (host only)                                         | `features/external_links/3_data/url_launcher_external_link_launcher.dart:85`                                                                                                                                                                           | Safe by design (host only, no URL)|
| 5  | `ExternalLinkOpenedEvent`    | `core/analytics/analytics_event.dart:85`                         | external_links   | `linkId: String`, `success: bool`                                    | `url_launcher_external_link_launcher.dart:82` (success), `:94` (failure)                                                                                                                                                                               | Safe by design (catalog ID)       |
| 6  | `ExternalLinkOpenFailedEvent`| `core/analytics/analytics_event.dart:105`                        | external_links   | `linkId: String`, `reason: String` (enum name)                       | `url_launcher_external_link_launcher.dart:95`                                                                                                                                                                                                           | Safe by design (catalog ID + enum)|
| 7  | `DomainLandingViewedEvent`   | `core/analytics/analytics_event.dart:127`                        | landings         | `domain: String` (stable id)                                         | `features/state_affairs/2_presentation/state_affairs_landing_page.dart:49`, `education_landing_page.dart:42`, `employment_landing_page.dart:43`, `social_welfare_landing_page.dart:46` (each with a hard-coded `_domainId` const)                       | Safe by design (compile-time const)|
| 8  | `AgendaPeriodChangedEvent`   | `core/analytics/analytics_event.dart:138`                        | agenda           | `periodId: String` (`AgendaPeriodFilter.name`)                       | `features/agenda/2_presentation/agenda_page.dart:145`                                                                                                                                                                                                  | Safe by design (enum name)        |
| 9  | `AgendaEventOpenedEvent`     | `core/analytics/analytics_event.dart:150`                        | agenda           | `eventId: String`, `category: String` (enum name)                    | `agenda_page.dart:127`, `:185`, `:252`                                                                                                                                                                                                                 | Safe by design (repo ID + enum)*  |
| 10 | `AppErrorEvent`              | `core/analytics/analytics_event.dart:167`                        | core (errors)    | `errorType: String` (runtime type name), `context: String?` (slug)   | *no current emitter* — defined for future error-pipeline integration                                                                                                                                                                                   | Safe by design (type name only)   |

\* `AgendaEventOpenedEvent.eventId` is the repository's stable identifier. Per the dartdoc "must not embed PII" — relies on the agenda repository contract, not on a redaction wrapper. Validated for the demo repository; flagged as a Sprint-9 follow-up (§8) for any future external feed.

There are **no other `AnalyticsEvent` subclasses** anywhere under `lib/`. Two unrelated `…Event` classes exist (`life_event.dart`, `agenda_event.dart`) but they are **domain entities**, not analytics events.

---

## 2. Wiring verification

| Sink / observer                                                | Mechanism                                                                                                            | Notes                                                                                                                                                  |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `AnalyticsObserver` (`lib/app/observers/analytics_observer.dart`) | `NavigatorObserver` registered in `app_router.dart`; emits `PageViewEvent` + `setCurrentScreen` on `didPush`/`didReplace` using `route.settings.name`. | Only emits `PageViewEvent`. All other events are emitted **directly from feature code** via `ref.read(analyticsServiceProvider).logEvent(…)` (bypasses the observer, but does *not* bypass any wrapper — there is no redaction wrapper in the pipeline). |
| `analyticsServiceProvider` (`core/analytics/analytics_provider.dart`) | Always returns `ConsoleAnalyticsService(logger: appLoggerProvider)`. Keep-alive.                                       | No environment-conditional override; identical pipeline in dev/preprod/prod.                                                                            |
| `ConsoleAnalyticsService.logEvent`                             | `_logger.debug('[Analytics] event: ${event.runtimeType} | $event')`                                                  | **No redaction wrapper.** No `toString()` overrides on any event subclass means `'$event'` resolves to `Instance of '<Type>'` — field values do not reach the rendered line. This is the de-facto field-level safeguard for the console sink today.      |
| `ConsoleAnalyticsService.setCurrentScreen`                     | `_logger.debug('[Analytics] screen: $screenName')`                                                                   | `screenName` is interpolated **verbatim**. Only caller is `AnalyticsObserver`, which sources it from `route.settings.name` (route slug). Trust-based.   |
| Release builds                                                 | Both `logEvent` and `setCurrentScreen` short-circuit on `kReleaseMode` (no-op).                                        | No analytics SDK is wired yet; replacement is a future sprint.                                                                                          |

**Conclusion.** Every emitted event reaches a single sink (`ConsoleAnalyticsService`) which delegates to a single `AppLogger`. There is no analytics-side redaction layer — redaction is achieved entirely by:
1. The **event-model contract** (only stable identifiers in fields).
2. The **default `Object.toString()`** suppressing field rendering on the console sink.
3. **`kReleaseMode` no-op** in release builds.

Item 2 is implicit and worth a contract guard, which the new test asserts.

---

## 3. Redaction spot-checks

New test: `test/qa/telemetry_redaction_test.dart` (5 tests, all passing).

| #  | Test case                                                                          | Sample input                                                                                                                                                          | Expected behaviour                                                                                                                                                  | Result |
| -- | ---------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| 1  | `PageViewEvent` with PII-like inputs does not leak field values to console sink    | `PageViewEvent('/profile/12345678Z', parameters: {nif: 12345678Z, email: ciudadano@example.com, phone: +34600000000})`                                                | Captured log line contains `'PageViewEvent'` (type name) but **none of** `12345678Z`, `ciudadano@example.com`, `+34600000000`.                                       | ✅     |
| 2  | Every concrete `AnalyticsEvent` subclass renders type-only output                  | All 10 subclasses constructed with abusive PII inputs (NIF, email, phone, full name, idAgente, DOB) injected into every string field.                                  | 10 log lines emitted; **none** contains any of the 6 PII samples.                                                                                                    | ✅     |
| 3  | `AnalyticsEvent` subclasses do not override `toString()` (contract guard)          | Each subclass instantiated with neutral data and asserted `toString().startsWith("Instance of '")`.                                                                    | All 10 subclasses inherit the default `Object.toString`. Future drift (someone adding a field-printing `toString`) will fail this test with an explicit explanation. | ✅     |
| 4  | `setCurrentScreen` is verbatim (documented leak surface)                            | `setCurrentScreen('/profile/12345678Z')`                                                                                                                              | Log line **contains** the raw NIF — verbatim by current contract. Documents the trust boundary so any future tightening is a deliberate change.                       | ✅     |
| 5  | `ConsoleLogger` redacts PII-keyed context map values                                | `info('login attempt', context: {agentId, userName, dni, sessionToken, plateNumber, safeKey})`                                                                         | All values for keys matching `_kPiiKeyFragments` (`token|id|name|dni|nss|plate|license|matricula`) are replaced with `[REDACTED]`. `safeKey` passes through untouched. | ✅     |

The test is intentionally **descriptive of the current contract** — it is not a wishful spec. If field-level redaction is added later (e.g. wrapping events through a sanitiser before emission), test #4 will fail and force a documentation update; that is the desired drift signal.

---

## 4. Product-perspective KPI mapping

| Event family                                                         | KPI fed                                              | Defensible reasoning                                                                                                                       |
| -------------------------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `PageViewEvent`                                                      | **Engagement** (sessions, screens/session, funnels)  | Standard route-tracking → DAU/MAU, screen depth, common entry/exit paths.                                                                  |
| `HomeBlockNavigateEvent`                                             | **Home-dashboard adoption** (block CTR)              | Stable block ID lets product compare which authenticated-home blocks drive traffic; not currently emitted, but defined for that KPI.        |
| `DomainLandingViewedEvent`                                           | **Thematic-domain reach** (first-touch per session)  | Captures which dashboard verticals (state affairs / education / employment / social welfare) are actually visited. Per-session de-dup is by design (only first view fires). |
| `AgendaPeriodChangedEvent`                                           | **Agenda filter usage**                              | Reveals whether users explore beyond default time window — input for agenda UX iteration.                                                  |
| `AgendaEventOpenedEvent`                                             | **Agenda content engagement** (click-through)        | Distribution by `category` (enum name) shows which event types matter most to citizens. `eventId` enables click-through-rate per event.     |
| `ExternalLinkEvent` + `ExternalLinkOpenedEvent` (success)            | **Outbound flow / referral volume**                  | Counts the *attempted exit* to partner sites and the *accepted launch*. Together they expose the launcher rejection rate.                  |
| `ExternalLinkOpenFailedEvent`                                        | **Outbound reliability** (per-link failure rate)     | `reason` is a coarse label (`platformRejected`, `invalidScheme`, `hostMismatch`, `unknown`) → directly actionable for catalog maintenance. |
| `DownloadEvent`                                                      | **Document adoption** (per `documentType`)           | Reserved for future download flows; defines the per-type download counter and PDF-vs-other split.                                          |
| `AppErrorEvent`                                                      | **Reliability** (per-error-type incidence by screen) | Pairs an `errorType` with an optional screen `context` to feed an error-rate dashboard. Reserved — no emitter yet.                          |

KPIs intentionally **not** claimed: conversion (no signature/transaction event currently exists), authentication funnel (no auth-step events), and time-to-task (no timing-bracket events). These would require new event classes; flagged in §8.

---

## 5. Sign-off note

The Sprint 8 telemetry pipeline is **safe to ship as-is** under the read-only audit performed here:

- All 10 `AnalyticsEvent` subclasses are PII-free at the API level (only stable identifiers, enum names, route slugs, and host-only domains accepted).
- The single sink (`ConsoleAnalyticsService` → `AppLogger`) renders only the runtime type name in the console; field values never reach the line because no subclass overrides `toString()`.
- A regression guard (test #3 in `telemetry_redaction_test.dart`) will catch any future `toString()` override that would change that property.
- `ConsoleLogger`'s context-map redaction (`_kPiiKeyFragments`) is independently verified (test #5).
- All emission sites in `lib/features/**` and `lib/app/observers/**` were reviewed; no callsite passes a literal PII value to any event constructor.
- Release builds short-circuit both analytics methods; no data leaves the device.

No changes were made to `lib/core/analytics/**` or `lib/core/logging/**`.

Verification command: `flutter test` → **445 passed, 1 skipped (perf opt-in)**.
Static analysis: `flutter analyze --no-fatal-infos` → **0 errors, 1 warning (pre-existing baseline)**, 0 new warnings/errors introduced by this work.

---

## 6. Sprint-9 carryover (recommendations only — no tickets created here)

These are recommendations for the Sprint-9 backlog. They are **not** blockers for shipping Sprint-8 closure.

1. **Field-level analytics redaction wrapper.** The current safety guarantee for the console sink rests on the implicit fact that no `AnalyticsEvent` overrides `toString()`. When the real SDK lands (e.g. Firebase Analytics), it will read fields **directly via reflection / explicit serialisation**, bypassing `toString` entirely. Before wiring any real SDK, introduce a `SanitisingAnalyticsService` decorator that:
   - Defines per-event explicit `Map<String, Object?> serialise()` methods, OR
   - Wraps `logEvent` with a key-allowlist filter analogous to `ConsoleLogger._redact`.
2. **`setCurrentScreen` allow-list.** Today the method is verbatim and trusts the caller. When the SDK is wired, replace the `String` argument with an enum or a validated route-slug type so a future caller cannot accidentally pass user content (e.g. a search query embedded in a URL).
3. **`AgendaEventOpenedEvent.eventId` audit when the agenda is fed by an external API.** Today's repository is local/demo data with stable opaque IDs. When STORY-29 (or successor) connects to a real backend, confirm that the backend's event IDs are not derived from PII (e.g. citizen-specific ICS UIDs).
4. **Missing event families for product KPIs.** Add (after product confirmation):
   - `SignatureCompletedEvent { processId, success }` for conversion KPI.
   - `AuthStepEvent { stepId, outcome }` for auth-funnel KPI (no PII; outcome is `succeeded|failed|cancelled`).
   - `TaskTimingEvent { taskId, bucketMs }` (bucketed, not raw) for performance KPI.
5. **CI guard.** Wire `test/qa/telemetry_redaction_test.dart` into the CI critical path (it is already picked up by `flutter test`, but call it out explicitly in `documentation/qa/test-plan-and-coverage.md` so it cannot be silently dropped from a smoke subset).
6. **Release-build sanity test.** Currently the `kReleaseMode` no-op is asserted only by the source. Consider a profile-mode integration check (or a `--dart-define=FORCE_RELEASE_NOOP`-gated test) to prove no analytics frame is emitted in release.

---

*End of report.*
