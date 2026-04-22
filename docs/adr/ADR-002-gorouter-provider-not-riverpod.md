# ADR-002 — GoRouter instantiated as Provider\<GoRouter\>, not @riverpod

**Date:** 2025-07-14  
**Status:** Accepted  

---

## Context

The application uses **GoRouter** for declarative navigation and **Riverpod** for state management.
A natural question arises: should `GoRouter` be declared with `@riverpod` code generation (like
most other providers) or as a manual `Provider<GoRouter>`?

GoRouter is not a plain data/state object — it holds internal navigation state, a URL parsing
engine, and a listener registration mechanism (`RouterNotifier`).  When Riverpod recreates a
provider (e.g., because a watched dependency changes), any `@riverpod`-annotated provider is
replaced with a fresh instance.  Replacing the `GoRouter` instance mid-session:

- Loses the current navigation stack.
- Triggers a full widget subtree rebuild of the `MaterialApp.router` host.
- May cause race conditions between the old and new router during animated transitions.

The official GoRouter documentation and the GoRouter + Riverpod community guidance both recommend
keeping the router as a stable, long-lived object that is notified of auth-state changes through
a `RouterNotifier` / `ChangeNotifier`, rather than being recreated on state change.

---

## Decision

Declare the GoRouter instance as a **manual Riverpod `Provider<GoRouter>`** (not `@riverpod`
codegen):

```dart
// lib/app/router/app_router.dart
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);
  return GoRouter(
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: AppRoutes.routes,
  );
});
```

This provider:

- Is created exactly once per `ProviderContainer` lifetime.
- Is NOT annotated with `@riverpod` and therefore NOT code-generated.
- Receives auth-state changes through `RouterNotifier`, which implements `ChangeNotifier` and is
  watched by GoRouter's `refreshListenable`.

---

## Consequences

### Positive

- The `GoRouter` instance is stable across auth-state transitions; the navigation stack is
  preserved where appropriate.
- No unexpected widget subtree rebuild caused by router recreation.
- Consistent with GoRouter's official Riverpod integration pattern.

### Negative / Trade-offs

- `goRouterProvider` cannot use `@riverpod` code generation, which breaks the uniform code-gen
  convention used by other providers.  This exception is intentional and documented here.
- Developers unfamiliar with this ADR may attempt to convert it to `@riverpod`; the ADR comment
  in source and this document serve as the guard.

### Guidance for maintainers

- Do NOT convert `goRouterProvider` to `@riverpod` without first understanding the consequences
  described above and confirming that GoRouter has changed its lifecycle contract.
- If GoRouter introduces first-class Riverpod codegen support in the future, revisit this decision
  and update or supersede this ADR.

---

## References

- [GoRouter + Riverpod integration guide](https://pub.dev/documentation/go_router/latest/topics/Integration-riverpod.html)
- [GoRouter pub.dev](https://pub.dev/packages/go_router)
- Architecture canon: `documentation/architecture_canon_flutter_v2_docs/` — Annex B, section 16 (Routing)
