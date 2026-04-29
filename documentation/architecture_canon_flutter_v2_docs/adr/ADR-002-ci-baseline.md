# ADR-002: CI baseline for Sprint 2

- Status: Accepted
- Date: 2026-05-04
- Related ticket: [STORY-68]
- Related canon: annex C §27 (testing / release), annex D §§32-34 y §36

## Context

The repository needs a deterministic continuous-integration entry point before
later sprints introduce store deploys, signed builds and richer quality gates.
STORY-68 is explicitly blocked by STORY-64 (observability), STORY-66, STORY-67,
TASK-69 (PII/security) and TASK-70 (performance budgets), so the full release
governance described in the canon cannot land in Sprint 2. We still need a
minimal pipeline so that every PR against `develop`/`main` is validated.

## Decision

Adopt a single-job CI workflow (`.github/workflows/ci.yml`) that runs on
`push` to `develop`/`main` and on `pull_request` targeting those branches:

1. Checkout (`actions/checkout@v4`).
2. Provision Flutter pinned to the version declared in `.fvmrc` (3.41.7,
   `stable` channel) via `subosito/flutter-action@v2`.
3. `flutter pub get`.
4. `dart run build_runner build --delete-conflicting-outputs` (codegen run).
5. `dart format --output=none --set-exit-if-changed lib test` (format gate).
6. `git diff --exit-code` (codegen-clean gate: fail if generators produced
   uncommitted output).
7. `flutter analyze --no-fatal-infos` (static analysis gate).
8. `flutter test` (unit/widget suites currently in the repo).

Concurrency is set per-branch with `cancel-in-progress: true` so superseded
runs free agents quickly.

A local parity helper (`scripts/verify_codegen.sh`) reproduces the codegen
gate on developer machines.

A scaffold release checklist (`documentation/release/release_checklist.md`)
captures the release-readiness flow with explicit "to be expanded in later
sprints" markers, and a top-level `CHANGELOG.md` (Keep a Changelog format)
hosts the running list of merged ticket-backed work.

## What is intentionally deferred

These items are explicitly **out of scope for the Sprint 2 baseline** and will
be added in later sprints together with their gating tickets:

- Build and upload artifacts (APK / AAB / IPA).
- Store deploys (Play Store, App Store) and any Fastlane / Codemagic plumbing.
- Signed builds, credential storage and provisioning profile management.
- Integration / e2e / golden suites.
- Coverage collection, publishing and threshold enforcement.
- Automated tagging / changelog generation from commits.
- PII/security and performance gating beyond what STORY-64/TASK-69/TASK-70
  already produce as instrumentation.

## Consequences

- Every PR to `develop`/`main` runs the same deterministic gate before merge,
  preventing regressions in static analysis, formatting, codegen freshness or
  the existing test suite.
- The pipeline is small enough to be cheap and predictable, and leaves room
  for later sprints to introduce platform builds and deploy stages without
  re-litigating the baseline.
- The release checklist and changelog give us a written contract for the
  release-readiness flow even before automation exists.

## References

- STORY-68 — CI/CD, verificación de codegen, entornos y checklist de release.
- STORY-64 — Observabilidad, analytics y logging con redacción de PII.
- STORY-66 — pending, environments / config promotion.
- STORY-67 — pending, secret / signing management.
- TASK-69 — Inventario PII, hardening de seguridad y ADRs de excepción.
- TASK-70 — pending, performance budgets and validations.

## Sprint 8 closure addendum

- Date: 2026-04-29
- Related ticket: [STORY-68], Sprint 8 (SP-EC-APP-SQ3-08).

This addendum closes the items the Sprint 2 baseline explicitly deferred and
that are now in scope for the Sprint 8 release-readiness window.

### AC2 — Environment promotion

Satisfied via:

- `.github/workflows/promote.yml` — `workflow_dispatch` workflow with `from`
  and `to` choice inputs. The job validates that the transition is one of
  `development → preproduction` or `preproduction → production`, runs under a
  GitHub `environment:` block matching the `to` input (so environment
  protection rules — required reviewers, secrets, deployment branches — gate
  the run), and runs `flutter pub get`, `bash scripts/verify_codegen.sh`,
  `flutter analyze --no-fatal-infos`, `flutter test`, then writes a structured
  promotion record (from, to, sha, actor, run url, status) to
  `$GITHUB_STEP_SUMMARY`.
- `documentation/release/promotion-policy.md` — operational runbook covering
  the stage chain, approval gates, who can approve, evidence to attach and
  the rollback path.
- `release_checklist.md` §2 now points to both artefacts and is no longer a
  Sprint 2 scaffold.

### AC3 — Versioning, tagging and changelog

Satisfied via:

- `scripts/bump_version.sh` — bash script (`set -euo pipefail`, executable)
  accepting `major | minor | patch | <X.Y.Z>` plus an optional `--dry-run`
  flag. It rewrites `pubspec.yaml`'s `version:` line, increments the build
  number (`+B → +B+1`, reset to `1` on `major`), inserts a new
  `## [X.Y.Z] - YYYY-MM-DD` section in `CHANGELOG.md` directly under
  `## [Unreleased]` (Keep a Changelog convention) and prints the proposed
  `vX.Y.Z` git tag to stdout.
- `release_checklist.md` §3 (versioning) and §4 (changelog) now point to the
  script as the canonical mechanism. A new §6 captures the rollback path that
  matches `promotion-policy.md` §5.
- The `Release` workflow gains a `Verify codegen (drift gate)` step
  (`bash scripts/verify_codegen.sh`) between `flutter pub get` and the
  analyze/test/build sequence so version-bump commits cannot ship with
  drifted generated output.

### Operational note

Real version bumps and tags are triggered **by humans** during the release
window sprint, not by CI. `scripts/bump_version.sh` is the canonical
mechanism — invoking it (and committing its output) is the only sanctioned
way to bump `pubspec.yaml` and `CHANGELOG.md` in lockstep. The script's
`--dry-run` mode is the recommended preview before the real bump.
