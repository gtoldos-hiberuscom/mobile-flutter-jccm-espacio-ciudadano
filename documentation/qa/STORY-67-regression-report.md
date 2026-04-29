# STORY-67 — Regression report

Sprint: Sprint 7 (SP-EC-APP-SQ2-07)
Owner: plan-manager (proxy for Squad 2 QA)
Last updated: 2026-04-29

This is the verification log produced during the Sprint 7 QA-as-code
pass. It complements the automated checks shipped under
`test/qa/` and `test/integration/` and records what was reviewed, what
gaps remain, and what should be picked up at Sprint 8 UAT closure.

## Surfaces verified

| Surface             | Build | Visual review | A11y matrix | Goldens | E2E smoke | Notes |
|---------------------|-------|---------------|-------------|---------|-----------|-------|
| Landing             | ✅     | ✅             | ✅ automated | ✅ baseline | ✅ | All STORY-67 ACs covered. |
| Login (Cl@ve)       | ✅     | 👁 device      | ✅ semantics labels reviewed | ⏸ | ⏸ | OAuth WebView opaque to widget tests. |
| Home                | ✅     | ✅             | 👁 manual    | ⏸ Sprint 8 | ⏸ Sprint 8 | Goldens deferred — depends on dynamic content. |
| Agenda              | ✅     | ✅             | 👁 manual    | ⏸ Sprint 8 | covered by `test/features/agenda/` happy paths | OfflineBanner adopted. |
| Notifications       | ✅     | ✅             | 👁 manual    | ⏸ Sprint 8 | covered by `test/features/notifications/` | OfflineBanner adopted. |
| Recommendations     | ✅     | ✅             | 👁 manual    | ⏸ Sprint 8 | covered by `test/features/recommendations/` | OfflineBanner adopted. |
| Casework            | ✅     | ✅             | 👁 manual    | ⏸ Sprint 8 | covered by `test/features/casework/` | Mock data only (real Dio wiring future). |
| Carnet digital      | ✅     | ✅             | 👁 manual    | ⏸ Sprint 8 | covered by `test/features/digital_cards/` | |
| Support form        | ✅     | ✅             | 👁 manual    | ⏸          | covered by `test/features/help/support_form_page_test.dart` | Captcha is mock; final wiring tracked in TASK-63. |

Legend:
- ✅ green
- 👁 manually reviewed (no defect)
- ⏸ deferred to a documented sprint

## Gaps found (non-blocking)

1. **Home page golden** — the home content depends on the citizen
   profile and the personalization config; producing a stable golden
   requires a deterministic provider override that is not in scope this
   sprint. **Action**: add a golden under STORY-67 closure in Sprint 8.
2. **Casework workspace deep e2e** — the workspace lacks a fully
   wired Dio adapter; e2e against the mock would not catch real
   regressions. **Action**: revisit when CaseworkRepositoryImpl wires
   to `/publicacion/select*` (out of Sprint 7 scope).
3. **Dynamic type at 200%** — visual regression on agenda's two-line
   tile titles when text scale > 1.6×; truncation happens before
   ellipsis. **Action**: tracked as a polish defect for Sprint 8 UAT
   closure (no new ticket per the Sprint 7 operational note).
4. **Recommendations card focus order** — when traversing with
   keyboard, the load-more button is visited before the last card's
   "open" affordance. **Action**: minor focus fix for Sprint 8.

None of the above blocks UAT entry. They are normal polish items.

## Defects discovered

None ticket-worthy at the time of writing. Two cosmetic items
(items 3 and 4 above) are noted in this report and explicitly deferred
to Sprint 8 UAT closure rather than reopening Done tickets.

## Sprint-7 STORY-67 deliverables

- `documentation/qa/accessibility-checklist.md` — per-surface a11y
  matrix and what is automated vs manual.
- `test/qa/accessibility_smoke_test.dart` — 4 automated guideline
  matchers on LandingPage.
- `test/qa/landing_golden_test.dart` + baseline under
  `test/qa/goldens/landing_page_phone_portrait.png`.
- `test/integration/smoke_happy_path_test.dart` — landing-level smoke.
- This report.

## Sprint 8 UAT closure expectations

Per roadmap §SP-EC-APP-SQ2-08:
- Add Home + Recommendations + Carnet goldens (deterministic states).
- Address gaps 3 (dynamic type) and 4 (focus order) as polish.
- Run device-level a11y traversal with TalkBack and VoiceOver.
- Sign off the final UAT matrix and produce the release-ready report.
