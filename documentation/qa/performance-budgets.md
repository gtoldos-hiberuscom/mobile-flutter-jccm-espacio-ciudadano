# Performance budgets

Sprint: Sprint 7 (SP-EC-APP-SQ3-07) — TASK-70
Last updated: 2026-04-29

These budgets are the **Sprint 7 baseline**. They are tight enough to
flag a regression but loose enough to live with the current build
without requiring a tuning pass. Sprint 8 reserves a slot to verify
them under preproduction conditions, and Sprint 9 a follow-up tuning
window (see roadmap §SP-EC-APP-SQ3-08 / SQ3-09).

## Targets

| Surface / metric                                         | Budget                                | Source / measurement |
|----------------------------------------------------------|---------------------------------------|----------------------|
| Cold-start TTI (low-end device, e.g., Pixel 4a, release) | ≤ **2,500 ms** to first interactive frame | Manual profile in preproduction; tracked in regression report |
| Warm-start TTI (returning user, app already cached)      | ≤ **1,000 ms**                        | Same                 |
| First widget build of `LandingPage`                      | ≤ **120 ms** on test harness          | `test/performance/page_build_budgets_test.dart` |
| First widget build of `RecommendationsPage`              | ≤ **150 ms** on test harness          | Same                 |
| First widget build of `CaseworkWorkspacePage` (or equiv.)| ≤ **150 ms** on test harness          | Same                 |
| List scroll FPS (agenda, notifications, recommendations) | ≥ **55 FPS** sustained                | Manual `flutter run --profile` + DevTools timeline |
| Document download progress UX                            | First byte → first progress tick ≤ **400 ms** | Manual; STORY-50 already exposes a progress controller |
| Image cache size (decoded)                               | ≤ **75 MB**                           | `PaintingBinding.instance.imageCache.maximumSizeBytes` (default 100 MB — tightened) |

## Why these numbers

- **TTI 2.5 s** matches Google Play vitals "good" threshold for cold
  start on mid-range devices. Tighter is unrealistic given the OAuth
  bootstrap (`flutter_appauth`) and the AppConfig load pipeline.
- **Widget-build budgets** are derived from the harness measurements at
  the time of writing (50–90 ms for landing on a developer laptop).
  150 ms gives ~2× headroom for CI variance without masking real
  regressions.
- **Scroll 55 FPS** is the realistic ceiling for the current
  `PaginatedListView` implementation. 60 is theoretically possible but
  variance from `connectivity_plus` callbacks, banner reflow, and
  device throttling makes 55 the actionable threshold.
- **Image cache 75 MB** keeps the app comfortably under the 100 MB
  decoded image ceiling defined by Flutter, leaving 25 MB for transient
  large images (e.g., carnet photos).

## How to run the harness

The performance test suite is **opt-in**: it is tagged `performance`
and `dart_test.yaml` declares `skip:` for that tag, so it is excluded
from the default `flutter test` run. There are two ways to execute it:

```bash
# 1. Recommended — opt in for a one-off / CI / release verification.
#    The --run-skipped flag is required because dart_test.yaml marks
#    the 'performance' tag as skipped by default.
flutter test --tags performance --run-skipped

# 2. Same, scoped to a single file:
flutter test --tags performance --run-skipped test/performance/page_build_budgets_test.dart

# 3. Alternative for local tuning loops where you re-run the suite
#    many times in a row: temporarily comment out the `skip:` line in
#    `dart_test.yaml`. Do NOT commit that change.
```

### Why the tag is skipped by default

We want the default `flutter test` invocation to stay fast for the
edit/save/test dev loop. Wall-clock budget tests are fundamentally
sensitive to machine load and are most useful as a deliberate gate in
CI / pre-release verification, not as something every change re-runs.
Keeping them tag-skipped (rather than removed from discovery) means
they can still be opted into with a single flag, and they continue to
appear in the test inventory for tooling that lists tagged suites.

### Diagnostic output

Each performance test prints a single diagnostic line to test stdout
with the observed wall-clock time and the configured budget:

```
[perf] LandingPage first build: 42 ms (budget: 150 ms)
[perf] RecommendationsPage first build: 31 ms (budget: 150 ms)
[perf] CaseworkWorkspacePage first build: 28 ms (budget: 150 ms)
```

The assertions are unchanged — these prints are purely diagnostic so a
regression can be triaged from the test log without re-instrumenting
the harness.

## What the harness does

Each performance test:

1. Builds the page once to warm shaders and asset loaders.
2. Pumps the page within a `Stopwatch`-instrumented `WidgetTester`
   block.
3. Asserts that the elapsed wall-clock build time stays under the
   budget.

This is intentionally simpler than full timeline scraping. It catches
regression of the same order of magnitude (e.g., a O(N) → O(N²)
controller change), without depending on `dart:developer` timeline
APIs that are flaky in headless CI.

## Sprint 8 / 9 follow-ups

- [x] First-build harness coverage for `LandingPage`
      (Sprint 7 — initial harness).
- [x] First-build harness coverage for `RecommendationsPage` and
      `CaseworkWorkspacePage`
      (Sprint 9 — `sprint9-perf-harness-extension`).
- [x] Wall-clock diagnostic output (`[perf] <Page> first build: N ms`)
      on every harness test
      (Sprint 9 — `sprint9-perf-harness-extension`).
- [ ] Run the harness on a CI runner with consistent hardware and pin
      a per-runner budget (current local-laptop run is the proxy
      baseline).
- [ ] Add a profile-mode device benchmark for cold-start TTI (real
      measurement, not test-environment proxy).
- [ ] Tune image cache size after collecting decoded-byte telemetry
      from preproduction.
