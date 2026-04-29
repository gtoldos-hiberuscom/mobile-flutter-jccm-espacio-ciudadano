# STORY-67 — Recommendations focus-order remediation

**Sprint:** 9 (deliverable G)
**Owner:** STORY-67 QA
**Status:** Remediation deferred to Sprint 10 — see proposal below.
**Branch context:** documented from
`task/EPIC-10-quality-release/STORY-67-qa/sprint9-goldens-and-a11y`.

## Context

A Sprint 7 / Sprint 8 carry-over flagged that the focus traversal on
*Mis Recomendaciones* (`RecommendationsPage`) does not match the visual
reading order, breaking external-keyboard / TalkBack / VoiceOver
navigation expectations.

## Files involved

- `lib/features/recommendations/2_presentation/recommendations_page.dart`
  - `RecommendationsPage.build` (lines ~42–109): builds a
    `DefaultTabController` → `Scaffold` → `AppBar(bottom: TabBar)` +
    `TabBarView(children: [RecommendationsBucketView, …])`.
  - `RecommendationsBucketView` / `_RecommendationsBucketViewState`
    (lines ~127–218): each tab body is a `ConsumerStatefulWidget` mixed
    with `AutomaticKeepAliveClientMixin` (`wantKeepAlive => true`) so
    scroll position and per-bucket pagination state survive tab swipes.
- `lib/features/recommendations/2_presentation/widgets/recommendation_card.dart`
  - Each card is an `InkWell` inside a `Card` (focusable, semantics
    `header: true` on the title).

## Current observed traversal

With a physical keyboard cycling `TAB`:

1. Tab 1 (`Todos`)
2. Tab 2 (`Últimos días`)
3. Tab 3 (`Novedades`)
4. Tab 4 (`Tramitación inmediata`)
5. **First card of the *active* tab** ✅
6. **First card of every *inactive* tab** ❌ — because
   `AutomaticKeepAliveClientMixin` keeps the inactive
   `RecommendationsBucketView` widgets mounted, their `InkWell`
   children remain in the focus tree even though they are off-screen
   inside the inactive `TabBarView` page.
7. Load-more `TextButton` of the active tab — interleaved with the
   load-more buttons of the inactive tabs.
8. Eventually wraps back to Tab 1.

This produces a confusing experience for assistive-technology users:
focus seems to "jump out" of the visible tab into invisible siblings
and only after several tabs returns to the visible content.

## Expected traversal

1. TabBar tabs in visual order (1 → 4).
2. Cards of the **currently active** tab in list order.
3. Load-more `TextButton` of the active tab (when present).
4. Wrap back to Tab 1.

Inactive tabs must be excluded from the focus tree while remaining
mounted (to keep their scroll position / pagination state).

## Why we are not fixing it inline

The minimal fix is a structural change in
`_RecommendationsBucketViewState.build` (or a wrapper inserted by
`RecommendationsPage` around each `RecommendationsBucketView` child of
the `TabBarView`):

- Wrap each tab body in `ExcludeFocus`/`ExcludeSemantics` whose
  `excluding` flag is bound to `DefaultTabController.of(context).index
  != widget.bucketIndex`. This requires either:
  - threading the bucket *index* down (currently the view only knows
    its `RecommendationBucket`), or
  - having the bucket view watch the `TabController` and rebuild on
    index change (introduces a new listener and lifecycle).
- Alternative: replace `TabBarView` with a custom `IndexedStack` +
  `Offstage` wrapper that drives focus exclusion per child. This
  changes swipe behaviour and would need a controlled regression pass
  (gesture tests, page-build budget, golden re-shoot).

Either path touches the page's controller wiring and the
keep-alive contract. Per the Sprint 9 G scope ("if it requires
structural changes, do not change the code"), this is documented
instead of patched.

## Proposed Sprint 10 fix shape

1. Inject the active-tab index into each `RecommendationsBucketView`
   via the existing `DefaultTabController` (e.g. add a
   `_ActiveTabScope` `InheritedWidget` set by `RecommendationsPage`
   that exposes `int activeIndex` and rebuilds children on change).
2. In `_RecommendationsBucketViewState.build`, wrap the returned
   subtree in:

   ```dart
   ExcludeFocus(
     excluding: !isActive,
     child: ExcludeSemantics(
       excluding: !isActive,
       child: subtree,
     ),
   )
   ```

   while keeping `wantKeepAlive => true` so scroll/pagination state
   survives tab switches.
3. Add a focused widget test under
   `test/features/recommendations/recommendations_focus_order_test.dart`
   that:
   - pumps `RecommendationsPage` with a fake repo serving deterministic
     non-empty buckets for *Todos* and *Últimos días*,
   - calls `Focus.of(primaryFocusContext).nextFocus()` in a loop, and
   - asserts that focus visits the 4 tabs and then **only** the active
     tab's cards before wrapping.

## Cross-references

- Sprint 7 STORY-67 regression report:
  `documentation/qa/STORY-67-regression-report.md`.
- a11y matrix entries on focus order:
  `documentation/qa/accessibility-checklist.md`.
- Architecture canon §23 (accessibility) and §27 (testing pyramid).

## Recommendation

Open a Sprint-10 sub-task under STORY-67 (or successor a11y story) to
implement the structural fix above and the associated regression test.
No new ticket created from this branch — surface as a Sprint 9 closure
note for plan-manager triage.
