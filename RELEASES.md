# Releases — Performance verification log

This file records performance-budget verification runs against
release-candidate builds. The authoritative budgets live in
[`documentation/qa/performance-budgets.md`](documentation/qa/performance-budgets.md);
each entry below points at the verification report for that run.

A note on environment scope: the perf harness
(`test/performance/page_build_budgets_test.dart`) runs in Flutter test
mode and does not consume an environment-specific binary or backend.
It is **environment-agnostic** in its current form: a pass on the
`development` flavor build is assumed to apply to the same source
tree built for `preproduction` and `production`, because the measured
surface (first widget build time) does not depend on backend URLs,
config payloads, or release-mode AOT compilation. Cells marked
`(n/a — not run; same binary)` reflect this. A profile-mode,
device-class TTI measurement would change that and is tracked as a
Sprint 9 follow-up.

## Sprint 8 closure (UAT candidate, 2026-04-29)

- Commit (HEAD): `79151ae561da7c2e0304551ccaf7acd189046406`
- Branch: `task/EPIC-10-quality-release/TASK-70-performance/sprint8-performance-verification`
- Verification report: [`documentation/qa/TASK-70-performance-verification-sprint8.md`](documentation/qa/TASK-70-performance-verification-sprint8.md)
- Default test baseline preserved: 440 passed + 1 skipped.
- Analyzer baseline preserved: 0 errors / 1 warning.

| Environment   | Perf harness pages              | Pass/fail | Notes |
|---------------|---------------------------------|-----------|-------|
| development   | LandingPage                     | PASS      | UAT candidate at SHA `79151ae5`. Harness summary: `+1 ~0 -0` (exit 0). |
| preproduction | (n/a — not run; same binary)    | n/a       | Promotion not yet executed. Harness is environment-agnostic in its current form (see note above). |
| production    | (n/a — not run; same binary)    | n/a       | Promotion not yet executed. |

Deferred pages (Sprint 9 candidates, accepted deferral for Sprint 8
closure): `RecommendationsPage`, `CaseworkWorkspacePage`. See the
verification report for rationale and recommended follow-ups.
