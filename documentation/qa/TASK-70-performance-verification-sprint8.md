# TASK-70 — Performance verification (Sprint 8 closure)

| Field            | Value |
|------------------|-------|
| Ticket           | TASK-70 (parent EPIC-10) |
| Sprint           | Sprint 8 closure (UAT candidate) |
| Branch           | `task/EPIC-10-quality-release/TASK-70-performance/sprint8-performance-verification` |
| Commit (HEAD)    | `79151ae561da7c2e0304551ccaf7acd189046406` |
| Run date (UTC)   | 2026-04-29T15:20:13Z |
| Verifier         | Implementer agent (automated harness run) |

This document records the Sprint 8 closure verification of the
performance budgets defined in
[`documentation/qa/performance-budgets.md`](performance-budgets.md)
against the UAT candidate build.

## Environment

```
Flutter 3.41.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision cc0734ac71 (13 days ago) • 2026-04-15 21:21:08 -0700
Engine • hash 7a53c052bc4b472cf780b199087e1368e4a9aa8c (revision 59aa584fdf) (13 days ago) • 2026-04-16 02:32:16.000Z
Tools • Dart 3.11.5 • DevTools 2.54.2
```

```
Darwin HL-K27X07C7C1.local 25.2.0 Darwin Kernel Version 25.2.0:
Tue Nov 18 21:07:05 PST 2025; root:xnu-12377.61.12~1/RELEASE_ARM64_T6020 arm64
```

Host class: developer laptop, Apple Silicon (arm64). The harness runs
in headless test mode (no profile-mode device measurement). Numbers
should be read as a **relative regression detector**, not as
device-class TTI numbers — see Recommendations.

## How the harness was run

The `performance` tag is configured in `dart_test.yaml` with a default
`skip:` directive so it does not slow the dev loop. The harness was
explicitly opted in for this verification:

```bash
flutter pub get
flutter test --tags performance --run-skipped --reporter expanded \
    test/performance/page_build_budgets_test.dart
```

`--run-skipped` is required in addition to `--tags performance` because
the per-tag `skip:` in `dart_test.yaml` would otherwise short-circuit
the run (observed first attempt: `+0 ~1: All tests skipped.`). The
harness file itself is unchanged — only the invocation differs from
the doc snippet in `performance-budgets.md`. A follow-up note has been
added to Recommendations to align the doc snippet with the actual
required invocation, but the doc itself is **not modified** under this
ticket's owned scope.

Exit code: `0`. Summary line: `+1 ~0 -0` (`All tests passed!`).

## Pages measured

| Page                    | Status this sprint | Disposition |
|-------------------------|--------------------|-------------|
| `LandingPage`           | **Measured**       | Harness asserts ≤ 150 ms first build (baseline 120 ms + variance per `performance-budgets.md`). |
| `RecommendationsPage`   | **Deferred**       | Sprint-9 candidate. Per the in-source note in `test/performance/page_build_budgets_test.dart`, instantiating this page in the harness requires a non-trivial Riverpod override matrix (config provider, repository provider, contract gate). Deferral is **accepted** for Sprint 8 closure since the LandingPage signal is sufficient to detect cross-cutting regressions (theme, l10n, Riverpod scope). |
| `CaseworkWorkspacePage` | **Deferred**       | Sprint-9 candidate. Same rationale as `RecommendationsPage`. Deferral accepted for Sprint 8 closure. |

## Results

| Page          | Metric                       | Budget    | Observed                                   | Pass/Fail |
|---------------|------------------------------|-----------|--------------------------------------------|-----------|
| `LandingPage` | First widget build (ms)      | ≤ 150 ms  | Within budget (assertion passed; harness does not log the wall-clock value, only enforces the bound) | **PASS** |
| `RecommendationsPage` | First widget build (ms) | ≤ 150 ms  | Not measured (deferred — see above)        | n/a       |
| `CaseworkWorkspacePage` | First widget build (ms) | ≤ 150 ms  | Not measured (deferred — see above)        | n/a       |

Other budgets in `performance-budgets.md` (cold/warm-start TTI, scroll
FPS, document download first-progress-tick, image cache size) are
**not** covered by the automated harness — they are manual /
DevTools / profile-mode measurements and out of scope for this Sprint
8 closure run. They remain Sprint-9 follow-ups (already noted in the
"Sprint 8 / 9 follow-ups" section of `performance-budgets.md`).

## Pass/fail summary

- Automated harness (1 test): **PASS** (`+1 ~0 -0`, exit 0).
- Default `flutter test` baseline: **440 passed + 1 skipped** —
  unchanged from Sprint 7. Confirms the perf-tagged test stays
  excluded from the default dev loop.
- `flutter analyze --no-fatal-infos`: **0 errors / 1 warning** —
  unchanged from Sprint 7 baseline. No `lib/` code was touched in this
  ticket.

**Sprint 8 closure verification: PASS.** The UAT candidate at SHA
`79151ae5` meets the LandingPage first-build budget on the developer
laptop reference host.

## Regressions identified

None. The LandingPage budget assertion held on the first attempt.

## Notes on environmental noise

No environmental noise observed. No font-shaping warnings, no golden
diffs (goldens are exercised in the default suite, not in the perf
harness), no `connectivity_plus` callbacks. The harness builds the
page without real repositories, so its variance source is essentially
the host scheduler.

If a future run fails:

- **Real regression** — the build path for the page changed (added a
  synchronous heavy widget, an `O(N²)` controller pass, a large image
  decoded eagerly, etc.). The fix lives in `lib/`, not in the budget.
- **Infrastructure noise** — host under thermal throttling, parallel
  CI tenant, font cache cold. Mitigation: re-run; if persistently
  flapping, pin a per-runner budget as called out in the Sprint 9
  follow-up of `performance-budgets.md`.

## Recommendations & carryover

The following are **recommendations only** — no tickets are created
under this ticket's scope.

1. **Sprint 9 — extend harness coverage** to `RecommendationsPage` and
   `CaseworkWorkspacePage` once a shared override matrix (config,
   repository, contract gate) is factored out of the existing widget
   tests. This is the explicit deferral noted in the harness source
   and in the Sprint 7 TASK-70 closure notes.
2. **Sprint 9 — CI runner pinning.** Move the perf harness to a
   dedicated CI runner with a fixed budget per the
   "Sprint 8 / 9 follow-ups" section of `performance-budgets.md`. The
   current local-laptop reference is acceptable for closure but
   provides no cross-developer baseline.
3. **Sprint 9 — profile-mode TTI measurement.** Cold-start and
   warm-start TTI (2.5 s / 1.0 s) are not exercised by the test
   harness; they require `flutter run --profile` on a low-end device.
   Recommend scheduling a one-off measurement window during Sprint 9
   so the budgets in `performance-budgets.md` carry empirical numbers.
4. **Sprint 9 — log observed ms.** The current harness asserts the
   bound but does not surface the observed wall-clock build time.
   Adding a `print`/`debugPrint` (or a `TestOn` reporter) would let
   trend analysis happen across runs without re-instrumenting. Out of
   scope here because the harness is a forbidden path under this
   ticket.
5. **Sprint 9 — doc fix.** Align the run snippet in
   `documentation/qa/performance-budgets.md` to include `--run-skipped`
   (or remove the `skip:` from `dart_test.yaml` for the `performance`
   tag and rely on `--exclude-tags performance` in the default flow).
   Also forbidden under this ticket; recorded here for traceability.

## Traceability

- Budgets source: [`documentation/qa/performance-budgets.md`](performance-budgets.md)
- Harness source: `test/performance/page_build_budgets_test.dart`
- Release log entry: [`RELEASES.md`](../../RELEASES.md)
