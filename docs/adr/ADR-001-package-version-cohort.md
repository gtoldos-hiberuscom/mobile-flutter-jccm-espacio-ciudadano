# ADR-001 — Use riverpod_generator 3.x / freezed 3.2.x / analyzer 8.x cohort

**Date:** 2025-07-14  
**Status:** Accepted  

---

## Context

The project requires `riverpod_generator` for code-generation of Riverpod providers and `freezed`
for immutable data classes and sealed unions.  As of mid-2025 these two packages have an
incompatible dependency on the `analyzer` package:

- `riverpod_generator` **4.x** requires `analyzer` **≥ 10.0.0**.
- `freezed` **3.2.x** requires `analyzer` **≥ 8.0.0 < 10.0.0**.

Attempting to use `riverpod_generator 4.x` alongside `freezed 3.2.x` results in a `pub` dependency
resolution failure because no version of `analyzer` can satisfy both constraints simultaneously.

The conflict surfaces during `dart pub get` and blocks the build pipeline entirely.

---

## Decision

Pin the entire code-generation tooling to a compatible cohort that uses `analyzer 8.x`:

| Package | Version |
|---------|---------|
| `flutter_riverpod` | `3.0.3` |
| `riverpod_annotation` | `3.0.3` |
| `riverpod_generator` | `3.0.3` |
| `riverpod_lint` | `3.0.0` |
| `custom_lint` | `0.8.1` |
| `freezed` | `3.2.2` |
| `freezed_annotation` | `3.2.0` |

All packages in the cohort must be upgraded together in a single PR.  Partial upgrades are
prohibited because they will reintroduce the resolver conflict.

A `# TODO(ADR-001)` comment is placed adjacent to `riverpod_generator` in `pubspec.yaml` to make
the constraint visible to future maintainers.

---

## Consequences

### Positive

- `dart pub get` resolves successfully; CI pipeline is unblocked.
- Code generation (`build_runner`) works for both `riverpod_generator` and `freezed` in the same
  invocation.
- The constraint is self-documenting through the `TODO` comment and this ADR.

### Negative / Trade-offs

- The project cannot adopt features introduced in `riverpod_generator 4.x` (e.g., improved
  provider graph introspection) until `freezed` publishes a release compatible with `analyzer 10+`.
- All cohort packages must be upgraded together, which requires a coordinated bump PR and a full
  `build_runner` regeneration pass.

### Migration path

When `freezed` releases a version that declares `analyzer ≥ 10.0.0`, open a single PR that:

1. Upgrades all cohort packages to their latest compatible versions.
2. Removes or updates this ADR.
3. Removes the `# TODO(ADR-001)` comment from `pubspec.yaml`.
4. Runs `dart run build_runner build --delete-conflicting-outputs` and commits the regenerated
   files.

---

## References

- `pubspec.yaml` — cohort pins with `# TODO(ADR-001)` comment
- [riverpod_generator pub.dev](https://pub.dev/packages/riverpod_generator)
- [freezed pub.dev](https://pub.dev/packages/freezed)
