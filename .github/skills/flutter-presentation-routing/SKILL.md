---
name: flutter-presentation-routing
description: >-
  Implement Flutter presentation logic with Riverpod, explicit screen state,
  feature routing, localization, theming, accessibility, and UI performance
  rules from the canon. Use when changing controllers, providers, pages,
  widgets, routes, or app shell behavior.
---

Use this skill when the task affects controllers, notifiers, providers, screen state, pages, widgets, routes, app shell, localization, theming, accessibility, or UI performance.

## Canon sources
Read these sections first:
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_b.md` sections 14-17
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_c.md` sections 21-23 and 25
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_d.md` sections 31, 33, 34, 35, 36

## Riverpod rules
- Use `@riverpod` with code generation by default.
- Prefer `Notifier` for synchronous state and `AsyncNotifier` for asynchronous screen lifecycle work.
- Put initial logic in `build()`, never in the notifier constructor.
- Use `ref.watch()` for reactive dependencies and `ref.read()` for user actions and callbacks.
- External dependencies must be overrideable in tests.

## Screen-state rules
- Give each relevant screen an explicit and typed state model.
- Use `AsyncValue` only when loading/data/error is enough for the screen semantics.
- Avoid incoherent piles of booleans and magic strings for error handling.

## Routing rules
- Global routing lives in `lib/app/routing/`.
- Each feature may expose routes under `2_presentation/routes/`, but registration remains global.
- Prefer typed or centralized route names instead of scattered string literals.
- Controllers should emit navigation intent; widgets or a dedicated navigation service should perform the actual navigation when possible.

## UI contract
- User-facing strings must be localizable.
- Use theme or design-system tokens instead of inline colors or ad hoc `TextStyle`s.
- New UI must satisfy the minimum accessibility contract: semantics, focus order, touch targets, contrast, scalable text, and non-color-only feedback.
- Keep expensive work out of `build()` and avoid rebuild patterns that defeat Riverpod's state model.

## Done checklist
- The notifier/controller remains small and focused on orchestration.
- The screen state is explicit and coherent.
- Routes are registered in the correct place and avoid magic strings.
- Strings, semantics, and theme usage are compliant with the canon.
