# STORY-65 — Home page OfflineBanner wrapping deferred

**Sprint:** 9
**Branch:** `task/EPIC-10-quality-release/STORY-65-resilience/sprint9-localize-and-wrap`
**Owning ticket:** STORY-65 (resilience)
**Hand-off ticket:** STORY-22 (home dashboard)

## Decision

Wrapping the logged-in home page with `OfflineBanner` is **deferred**. No
home-related code is modified by this Sprint 9 deliverable.

## Rationale

The Sprint 9 home-route investigation (deliverable B, executed on the
EPIC-3 / STORY-22 branch family — see
`documentation/qa/STORY-22-home-route-investigation.md` once that branch
merges) concluded:

> documented-only — `Routes.home` redirects to `/sitemap`, no
> `LoggedHomePage` exists.

Since no `LoggedHomePage` widget exists today, there is nothing on the
authenticated home surface to wrap. Adding a placeholder wrapper would:

- create code that is dead until STORY-22 reopens, and
- bind `OfflineBanner` to the safety redirect target (`/sitemap`), which
  already shows cached navigation tiles and is not the intended adoption
  point.

## Hand-off

When STORY-22 reopens to implement the real `LoggedHomePage`, that
ticket is responsible for wrapping the new page body with
`OfflineBanner` (see `lib/core/connectivity/offline_banner.dart`). The
banner copy is now fully localized via `offlineBannerMessage`, so the
adopter only needs to wrap the page subtree — no string plumbing
required.

## Scope of this deliverable

Sprint 9 deliverable E (this branch) only:

- Localized the `OfflineBanner` default copy (es/en).
- Regenerated `AppLocalizations` bindings.
- Added widget coverage under `test/core/connectivity/offline_banner_test.dart`.
- Recorded this deferral note.
