# Accessibility checklist

Sprint: Sprint 7 (SP-EC-APP-SQ2-07) — STORY-67
Last updated: 2026-04-29

This is the canonical checklist used for accessibility verification of
Carpeta Ciudadana. It is intentionally **WCAG 2.2 AA-shaped** and
focused on what Flutter widget code can guarantee — anything beyond
that lives in the regression report (`STORY-67-regression-report.md`).

Per surface, evidence is one of:
- ✅ automated (`flutter_test` semantics finder under
  `test/qa/accessibility_smoke_test.dart`)
- 👁  visual / manual verification (logged in regression report)
- ⏸ deferred (with reason)

## Per-surface matrix

| Surface                 | Tap target ≥ 48dp | Sufficient contrast | Semantics labels | Focus order | Dynamic type ≥ 200% |
|-------------------------|-------------------|---------------------|------------------|-------------|---------------------|
| Landing                 | ✅                 | 👁                  | ✅                | 👁           | 👁                  |
| Login (Cl@ve handoff)   | 👁                 | 👁                  | ✅                | 👁           | 👁                  |
| Home                    | ✅                 | 👁                  | ✅                | 👁           | 👁                  |
| Agenda list             | ✅                 | 👁                  | ✅                | 👁           | 👁                  |
| Notifications inbox     | ✅                 | 👁                  | ✅                | 👁           | 👁                  |
| Recommendations         | ✅                 | 👁                  | ✅                | 👁           | 👁                  |
| Casework workspace      | ✅                 | 👁                  | ✅                | 👁           | 👁                  |
| Carnet digital          | ✅                 | 👁                  | ✅                | 👁           | 👁                  |
| Support form            | ✅                 | 👁                  | ✅                | 👁           | 👁                  |

## Automated checks shipped in Sprint 7

`test/qa/accessibility_smoke_test.dart`:

1. **Semantics labels present** — every key call-to-action button on
   `LandingPage` has a non-empty `Semantics.label` (so screen readers
   announce something other than “button”).
2. **Tap target sizes** — guarded by Flutter's
   `meetsGuideline(androidTapTargetGuideline)` matcher on the highest-
   traffic surfaces (currently Landing).
3. **Text contrast** — guarded by
   `meetsGuideline(textContrastGuideline)` so a regression in token
   palette is caught at test time.

## Manual checks tracked outside this checklist

- Dynamic type at 200% on iOS / 1.3× on Android: visual review on
  device per release; logged in the regression report.
- Focus traversal with TalkBack / VoiceOver: device walkthrough per
  release; logged in the regression report.
- Color blindness simulation (deuteranopia / protanopia): screenshots
  reviewed during goldens update.

## Known accessibility debt (carried forward)

- **Cl@ve OAuth web view**: opens in `flutter_appauth`; we cannot
  enforce semantics inside the external surface. Tracked as a known
  limitation; no app-side action.
- **Captcha mock in support form** (STORY-60 / TASK-63): the real
  captcha provider (Turnstile) decision lands as part of the support
  wiring; accessibility of its widget is out of scope until then.
