# Release checklist — jccm_espacio_ciudadano

> **Status:** Sprint 2 baseline scaffold. Each section below is the minimum
> contract for the release-readiness flow and will be expanded in later sprints
> (STORY-66, STORY-67, TASK-69, TASK-70 and the post-baseline release tickets).

## 1. Pre-release verification

_Sprint 2 baseline — to be expanded in later sprints._

- [ ] `flutter analyze --no-fatal-infos` is green on the release commit.
- [ ] `flutter test` is green on the release commit.
- [ ] Codegen is clean: `scripts/verify_codegen.sh` exits 0 (no diff after
      `dart run build_runner build --delete-conflicting-outputs`).
- [ ] Localization ARBs are in sync: every key present in `lib/l10n/app_en.arb`
      has a translation in the rest of the catalog.
- [ ] No `TODO`, `FIXME` or `print(` left in the code paths touched by the release.

## 2. Environment promotion (development → preproduction → production)

_Closed in Sprint 8 (STORY-68 / ADR-002 addendum)._
**Runbook:** [`promotion-policy.md`](./promotion-policy.md).
**Workflow:** [`.github/workflows/promote.yml`](../../.github/workflows/promote.yml).

- [ ] Build with `main_development.dart` and smoke-test against `config_development.json`.
- [ ] Dispatch `Promote environment` with `from=development`, `to=preproduction`
      and obtain the required reviewer's approval on the `preproduction`
      GitHub environment.
- [ ] Re-validate against `config_preproduction.json`; sign the manual smoke
      checklist (login, home, perfil, ayuda, legal, mapa web).
- [ ] Dispatch `Promote environment` with `from=preproduction`, `to=production`
      and obtain release manager + tech lead approval on the `production`
      GitHub environment.
- [ ] Re-validate against `config_production.json`.
- [ ] Capture promotion evidence as listed in
      [`promotion-policy.md` §4](./promotion-policy.md#4-evidence-to-attach)
      and attach it to the release ticket.

## 3. Versioning

_Closed in Sprint 8 (STORY-68 / ADR-002 addendum)._
**Tooling:** [`scripts/bump_version.sh`](../../scripts/bump_version.sh).

- [ ] Decide the bump kind (`major` / `minor` / `patch` / explicit `X.Y.Z`).
- [ ] Run `bash scripts/bump_version.sh --dry-run <kind>` to preview the new
      version, build number and proposed `vX.Y.Z` tag.
- [ ] Run `bash scripts/bump_version.sh <kind>` to rewrite `pubspec.yaml`
      `version:` and insert the new CHANGELOG section.
- [ ] Land the bump commit through the standard PR flow (CI must be green).
- [ ] Create the git tag printed by the script (`git tag vX.Y.Z && git push --tags`).
- [ ] Confirm the release branch protection / approval was enforced before
      tagging.

## 4. Changelog

_Closed in Sprint 8 (STORY-68 / ADR-002 addendum)._
**Tooling:** [`scripts/bump_version.sh`](../../scripts/bump_version.sh) inserts
the new `## [X.Y.Z] - YYYY-MM-DD` section directly under `## [Unreleased]`,
preserving the Keep a Changelog convention.

- [ ] Move every relevant entry from `## [Unreleased]` into the freshly
      inserted `## [X.Y.Z]` section.
- [ ] Group entries by `Added` / `Changed` / `Fixed` / `Removed` /
      `Security` as applicable.
- [ ] Ensure each entry references the originating ticket id
      (`STORY-…`, `TASK-…`, `BUG-…`).
- [ ] Leave `## [Unreleased]` empty (or with only post-release work).
- [ ] Commit the curated CHANGELOG together with the version bump.

## 5. Release evidence

_Sprint 2 baseline — to be expanded in later sprints._

- [ ] Link to the green CI run (GitHub Actions URL) attached to the release ticket.
- [ ] Manual smoke checklist executed and signed (login, home, perfil, ayuda, legal, mapa web).
- [ ] PII / security checklist re-checked against the latest TASK-69 inventory.
- [ ] Performance budgets re-checked against the latest TASK-70 thresholds.
- [ ] Release ticket transitioned to Done with the evidence attached.

## 6. Rollback notes

_Added in Sprint 8 closure (STORY-68 / ADR-002 addendum)._
**Detailed runbook:** [`promotion-policy.md` §5](./promotion-policy.md#5-rollback-path).

- [ ] Identify the previous good tag: `git tag --list 'v*' --sort=-v:refname | head`.
- [ ] Redeploy the artifact attached to that tag's `Release` workflow run
      (APK/IPA preserved as a workflow artifact and on the GitHub Release).
- [ ] Revert any forward-only switches (feature flags, server-side toggles)
      tied to the broken release.
- [ ] Communicate in the release channel: tag rolled back, tag rolled to,
      one-line root cause, owner of the follow-up fix.
- [ ] Open a `BUG-…` ticket linking the failed release run.
- [ ] After the fix lands, run `bash scripts/bump_version.sh patch` and
      re-promote `development → preproduction → production`.
- [ ] **Never** delete or force-move the failed release tag; rollback is
      forward-only at the version level (a hotfix is a new patch tag).

---

### Deferred to later sprints

- Build artifact upload (APK / AAB / IPA) and store deploy automation.
- Signed builds and credential management.
- Integration / golden / e2e suites.
- Coverage report publishing and threshold enforcement.
- Automated changelog/tag generation from commits.

These items are tracked under STORY-66, STORY-67, TASK-69, TASK-70 and the
release-automation tickets that will be opened after the Sprint 2 baseline.

---

> **Sprint 8 closed:** sections §2 (environment promotion), §3 (versioning),
> §4 (changelog) and the new §6 (rollback) are no longer scaffold. Their
> canonical mechanisms are `.github/workflows/promote.yml`,
> `documentation/release/promotion-policy.md` and `scripts/bump_version.sh`.
> Any further automation lives behind the deferred items above.
