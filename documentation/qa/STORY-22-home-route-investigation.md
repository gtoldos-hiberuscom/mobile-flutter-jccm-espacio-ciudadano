# STORY-22 — Home route investigation (Sprint 9 carry-over)

## Summary

`Routes.home = '/home'` is declared and treated as the canonical authenticated
landing across the app, but **no `LoggedHomePage` (or equivalent) is wired to
that route on the current `develop` / `epic/EPIC-3-dashboard-domains` line**.
Any `context.go(Routes.home)` call hits the `GoRouter.errorBuilder` and renders
`NotFoundScreen`. STORY-22 is marked `Done`, but the actual page implementation
never landed on the integration line — only the route slug was reserved and
sibling features (sitemap, consent, profile drawer) routinely navigate to it.

This document records the gap, lists every concrete call-site, identifies the
short-term routing safety mitigation applied in Sprint 9, and recommends the
follow-up needed in Sprint 10+.

## Investigation evidence

### 1. The route slug exists, but no `GoRoute` binds it

* `lib/app/routing/route_registry.dart:31` declares
  `static const String home = '/home';` and `route_registry.dart:96` lists it
  in `_authenticated`.
* `lib/app/routing/app_router.dart` (entire file inspected) declares
  `GoRoute`s for `landing`, `maintenance`, legal pages, sitemap, help,
  consent, and the full authenticated `ShellRoute` (`education`, `employment`,
  `socialWelfare`, `stateAffairs`, `agenda`, `casework`, `notifications`,
  `cards`, `signatureInbox`, card detail pages, `profile`, `recommendations`,
  `support`, `preferencesConsent`). **There is no `GoRoute` whose `path` is
  `Routes.home`.**
* `app_router.dart:61` falls back to `NotFoundScreen` via `errorBuilder` when
  no match is found.

### 2. No `lib/features/home/` directory on this branch

* `ls lib/features/` returns: `agenda, auth, casework, consent, digital_cards,
  education, employment, external_links, help, landing, legal, maintenance,
  notifications, personalization, recommendations, signature, sitemap,
  social_welfare, state_affairs, user_profile`. **No `home/`.**
* `git grep -nE "LoggedHomePage|HomePage|home_page|features/home" lib/ test/`
  returns **zero matches** on
  `task/EPIC-3-dashboard-domains/STORY-22-home-dashboard/sprint9-home-route-investigation`
  (base epic/EPIC-3-dashboard-domains @ `54cb171`).

### 3. Implementation work exists on side branches but was never integrated

`git log --all --oneline --diff-filter=A -- 'lib/features/home/**'` shows two
historical creation commits that never reached `develop` /
`epic/EPIC-3-dashboard-domains`:

| Commit    | Branch (visible via `git branch -a`)                                                            | Subject |
|-----------|--------------------------------------------------------------------------------------------------|---------|
| `31ec297` | `task/EPIC-3-dashboard-domains/STORY-22-home-dashboard/implement-home-dashboard`                 | feat(dashboard-domains): authenticated home dashboard with thematic blocks |
| `02ab2cd` | (same line + `task/EPIC-3-home-dashboard/STORY-22-logged-home/implement-logged-home`)            | feat(dashboard-domains): CIP read-only card + reusable upcoming-events summary across home and agenda |

Neither branch is merged into `develop` (`develop`, `epic/EPIC-3-dashboard-domains`
and the investigation branch all point to `54cb171`, which does not contain
`lib/features/home/`). The ticket-level branch
`ticket/EPIC-3-dashboard-domains/STORY-22-home-dashboard` is at the same
`54cb171`, i.e. it never absorbed the implementation either.

> Sprint 9 deliberately does **not** cherry-pick or merge those branches
> upward; this investigation is scoped to documentation + routing safety.

### 4. What every active call-site does today (pre-mitigation)

| Caller                                                                                       | Code                                  | Pre-mitigation outcome |
|----------------------------------------------------------------------------------------------|---------------------------------------|------------------------|
| `lib/app/shell/app_scaffold.dart:30` (bottom-nav "Inicio")                                   | `context.go(Routes.home)` (via tab 0) | `NotFoundScreen` |
| `lib/features/sitemap/3_data/sitemap_repository_impl.dart:55` (sitemap entry "Inicio")       | `route: Routes.home`                  | `NotFoundScreen` when the citizen taps the "Inicio" entry in the sitemap. |
| `lib/features/consent/2_presentation/consent_page.dart:50`                                   | `context.go(Routes.home)`             | After accepting consent, the post-onboarding redirect lands on `NotFoundScreen`. |
| `lib/features/user_profile/2_presentation/widgets/user_drawer_menu.dart:59,70,81`            | `context.go(Routes.home)` (×3 entries) | Three drawer menu items bounce the citizen to `NotFoundScreen`. |

### 5. Sitemap is the de-facto post-login landing today

`Routes.sitemap` (`/sitemap`) is bound (`app_router.dart:96`) and the public
`LandingPage` CTA already routes there, which is why the sitemap page is the
pragmatic "where would a real citizen land right now" answer. It is also a
non-authenticated route, which means the safety redirect below works for both
authenticated and unauthenticated traversals through `/home`.

## Decision

**(c) — TRULY MISSING.** Per the investigation playbook, no `LoggedHomePage`
is wired or even present on the integration line, and Sprint 9 must not
implement a real home page. We:

1. **Document the gap** (this file).
2. **Apply a short-term routing safety mitigation**: bind `Routes.home` inside
   the same `ShellRoute` as the rest of the authenticated pages, and have it
   *redirect* to `Routes.sitemap`. This stops every existing caller from
   landing on `NotFoundScreen` while we wait for the real page.
3. **Recommend reopening STORY-22** (see below) so a real `LoggedHomePage`
   ships in Sprint 10+ with proper acceptance criteria. The implementation
   work that already exists on the side branches (`31ec297`, `02ab2cd`) is a
   strong starting point; whether to integrate it or reimplement is a
   STORY-22 reopen decision, not a Sprint 9 decision.

### Why redirect to `/sitemap` and not to a placeholder

* `/sitemap` already exists, is wired, is reachable from the authenticated
  shell footer, and is the page the public landing CTA already drops users
  on, so behavior is consistent with what the rest of the app already
  assumes.
* A placeholder would still need design + copy review, would be visible as
  a regression to QA, and would have to be removed once the real page lands.
  A pure redirect carries no UI surface and is trivially removed.
* The redirect lives **inside the same `ShellRoute`** so the bottom-nav and
  the authenticated footer stay consistent while the citizen is "on /home".

## Mitigation applied in this investigation

* `lib/app/routing/app_router.dart`: added a `GoRoute` for `Routes.home`
  inside the authenticated `ShellRoute`. Its `redirect:` always returns
  `Routes.sitemap`. A comment block above the route explains the carry-over
  and points back to this document.
* `test/app/routing/home_route_safety_redirect_test.dart`: a small
  `GoRouter`-driven widget test that pushes `/home`, pumps, and asserts the
  resulting `matchedLocation` is `/sitemap` (i.e. the `NotFoundScreen` is
  *not* reached).

The mitigation is intentionally a routing safety net, not a feature.

## Recommended next step (for plan-manager / backlog)

* **Reopen STORY-22** ("Portada logada con resumen ciudadano y accesos
  rápidos") in the next sprint with explicit acceptance criteria, e.g.:
  * `lib/features/home/` exists with the canonical `0_entity / 1_domain /
    2_presentation / 3_data` layout.
  * `Routes.home` is bound to a real `LoggedHomePage` inside the
    authenticated `ShellRoute` and the safety redirect introduced in Sprint 9
    is removed.
  * Bottom-nav tab 0, the sitemap "Inicio" entry, the consent post-accept
    redirect, and the three drawer menu entries land on the real page.
  * Decide explicitly whether to integrate `31ec297` / `02ab2cd` from the
    historical side branches or to reimplement; either way, the safety
    redirect must be deleted as part of that ticket.
* Until that ticket lands, **do not delete the safety redirect**: every
  current call-site assumes `/home` resolves to *something*, and removing it
  would re-introduce the `NotFoundScreen` regression.
