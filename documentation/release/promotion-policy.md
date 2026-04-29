# Environment promotion policy — jccm_espacio_ciudadano

> **Status:** Sprint 8 closure (STORY-68 / ADR-002 addendum AC2).
> **Canonical workflow:** [`.github/workflows/promote.yml`](../../.github/workflows/promote.yml)
> **Related:** [`release_checklist.md`](./release_checklist.md), [`ADR-002`](../architecture_canon_flutter_v2_docs/adr/ADR-002-ci-baseline.md)

This document is the operational runbook for promoting a build between
environments. The `Promote environment` GitHub Actions workflow is the only
sanctioned mechanism; manual builds outside this flow do not constitute a
promotion.

## 1. Stage chain

Promotions follow a strict, linear chain:

```
development  →  preproduction  →  production
```

The workflow rejects any other transition (same-stage no-ops, skipping
preproduction, or going backwards). Reverting a stage is handled by the
rollback path in §5, not by `promote.yml`.

| From            | To             | Allowed |
| --------------- | -------------- | :-----: |
| development     | preproduction  | ✅      |
| preproduction   | production     | ✅      |
| development     | production     | ❌      |
| any → same      | —              | ❌      |
| backwards       | —              | ❌      |

## 2. Approval gates

`promote.yml` executes inside a GitHub `environment:` whose name matches the
`to` input (`preproduction` or `production`). Repository administrators
configure the protection rules on each environment:

- **preproduction**
  - Required reviewers: any member of the mobile team.
  - Deployment branches: `main`, `epic/*`, release branches.
  - Secrets: preproduction-only API keys.
- **production**
  - Required reviewers: at least one release manager + one technical lead.
  - Deployment branches: `main` only.
  - Secrets: production API keys, signing material.
  - Wait timer: optional (e.g. 5 min) so the approval can be cancelled if a
    new blocker appears.

The workflow itself does not bypass these gates. If the environment has no
protection rule configured, the run will proceed without approval — fixing
that is a repository-admin responsibility, not a workflow change.

## 3. Who can approve

| Role             | preproduction | production |
| ---------------- | :-----------: | :--------: |
| Mobile engineer  | ✅            | ❌         |
| Tech lead        | ✅            | ✅         |
| Release manager  | ✅            | ✅ (req.)  |
| Anyone else      | ❌            | ❌         |

Production requires **two** distinct approvers (release manager + tech lead),
configured at the GitHub environment level.

## 4. Evidence to attach

Each promotion run writes a structured summary to `$GITHUB_STEP_SUMMARY`
(from, to, sha, actor, run url, status). When promoting **to production**,
the release manager attaches the following evidence to the release ticket:

1. Link to the green `Promote environment` run (from the summary).
2. Link to the green `Release` workflow run that produced the artifact.
3. Manual smoke checklist (login, home, perfil, ayuda, legal, mapa web)
   signed against the preproduction build.
4. PII / security checklist re-checked against the latest TASK-69 inventory.
5. Performance budgets re-checked against the latest TASK-70 thresholds.
6. Git tag (`vX.Y.Z`) created via `scripts/bump_version.sh` on the release
   commit.
7. CHANGELOG.md section for `vX.Y.Z` populated and merged.

Promotions to **preproduction** require items 1–3 only.

## 5. Rollback path

If a production promotion exposes a regression, do **not** run
`promote.yml` backwards (it will refuse). Instead:

1. **Identify** the previous good tag (`git tag --list 'v*' --sort=-v:refname | head`).
2. **Redeploy** the artifact from that tag's `Release` workflow run
   (the APK/IPA is preserved as a workflow artifact and on the GitHub Release).
3. **Revert** any forward-only changes (feature flags, server-side toggles)
   driven by the broken release.
4. **Communicate** in the release channel with: tag rolled back, tag rolled
   to, root-cause one-liner, owner of the follow-up fix.
5. **Open a BUG** ticket linking the failed release run and capturing the
   regression for the next sprint.
6. After the fix lands, run `scripts/bump_version.sh patch`, merge the
   resulting CHANGELOG/pubspec change, and re-promote
   `development → preproduction → production`.

The release tag itself is **never** deleted or force-moved. Rollback is
forward-only at the version level (a hotfix is a new patch tag, not a
re-tag of the previous version).

## 6. Frequently asked

- **Can I promote a tag instead of `main`?** The workflow checks out the
  default branch by design. To promote a specific tag, dispatch the workflow
  from that tag using the GitHub UI's "Use workflow from" selector.
- **What if `verify_codegen.sh` fails on promotion?** Drift means the
  `main` branch already has uncommitted codegen output. Land a fixing PR
  before re-running the promotion; do not bypass the gate.
- **Can promotion run without a corresponding `Release` build?** No — the
  artifact promoted is the one produced by `release.yml` for the same SHA.
  If no release artifact exists for the current `main` SHA, dispatch
  `release.yml` first.
