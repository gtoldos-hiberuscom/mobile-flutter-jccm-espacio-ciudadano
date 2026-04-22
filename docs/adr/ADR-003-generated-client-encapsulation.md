# ADR-003 — Generated Dio client must be fully encapsulated in 3\_data/api layer

**Date:** 2025-07-14  
**Status:** Accepted  

---

## Context

The project uses an OpenAPI-generated Dio client (located in `generated/`) to communicate with the
JCCM Fachada Sede API.  A TASK-16 architecture audit of the generated client revealed:

- **Raw String endpoints** — path constants are untyped strings, making breaking API changes
  invisible to the compiler.
- **Dynamic models** — several response models use `dynamic` or `Object?` fields, providing no
  type safety at the boundary.
- **Dubious contracts** — some generated DTOs conflate multiple API response shapes, leading to
  nullable fields that are only valid for specific endpoints.
- **Regeneration volatility** — any schema change regenerates the entire client, potentially
  breaking code that depends directly on generated types.

If generated DTOs are allowed to cross the `3_data/` boundary into `1_domain/` or
`2_presentation/`, any regeneration breaks the entire vertical slice, not just the data layer.

---

## Decision

**No generated DTO or generated class may cross the `3_data/` boundary.**

All feature data layers must access the generated client through a hand-written wrapper class:

```
lib/features/<feature>/3_data/api/<feature>_api_wrapper.dart
```

The wrapper class:

1. Calls the generated client methods.
2. Maps generated DTOs to domain entities using a `<Feature>Mapper`.
3. Handles generated-client exceptions and converts them to `AppError` failures.
4. Returns `Either<AppError, DomainEntity>` (or equivalent) to the repository implementation.

The domain layer (`1_domain/`) and presentation layer (`2_presentation/`) see only domain entities
and `AppError`; they have zero import of anything from `generated/`.

```
generated/ (read-only, never edited by hand)
    └─ lib/...generated_client...
           ↓  imported only by
lib/features/<feature>/3_data/api/<feature>_api_wrapper.dart
           ↓  returns DomainEntity / AppError
lib/features/<feature>/3_data/repositories/<feature>_repository_impl.dart
           ↓
lib/features/<feature>/1_domain/ (no knowledge of generated/)
```

---

## Consequences

### Positive

- Regenerating the API client only breaks `3_data/api/` wrapper classes — never domain or
  presentation code.
- Each wrapper enforces typed, named mapping logic, eliminating `dynamic` propagation.
- Easier to test: domain tests mock the repository interface; `3_data/` tests mock the wrapper.
- Consistent with the architecture canon's layer boundary rules (Annex B, section 13).

### Negative / Trade-offs

- **Boilerplate:** Every feature that calls the API needs its own wrapper class and mapper.
  This is intentional — isolation is worth the additional files.
- Developers must remember to add the wrapper rather than calling the generated client directly.
  Code review and lints should enforce this.

### Enforcement

- Add a custom lint rule (or PR checklist item) that flags any import of `generated/` outside
  `lib/features/*/3_data/api/`.
- `generated/` directory is **read-only at development time** — never edit generated files
  manually; always regenerate from the OpenAPI spec.

---

## References

- TASK-16 — OpenAPI strategy and generated client audit
- Architecture canon: `documentation/architecture_canon_flutter_v2_docs/` — Annex B, section 13 (Data layer)
- [Security Hardening Guidelines](../security/security-hardening.md) — section 6.2
