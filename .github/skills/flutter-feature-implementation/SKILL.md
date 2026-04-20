---
name: flutter-feature-implementation
description: Implement or refactor a Flutter feature according to the canon: 0_entity, 1_domain, 2_presentation, 3_data, with explicit entities, use cases, repositories, DTOs, mappers, and ownership boundaries. Use when adding a feature or touching feature internals.
argument-hint: When asking to implement a change, provide as much context as possible about the affected area, the relevant ticket if any, and the expected outcome. For example:
Implement the new navigation menu design according to the mockups provided by the design team. The change should follow the architecture canon v2 and be traceable to the existing ticket NAVEMP-126. Make sure to consult the relevant sections of the canon for guidance on repository topology, feature structure, and implementation rules. Use the appropriate architecture skills for scaffolding, UI composition, and ticket synchronization. Validate tests and confirm that the implementation aligns with the acceptance criteria in the ticket.
target: github-copilot  

---

Use this skill when the task adds or restructures a feature, or when it touches entities, use cases, repositories, datasources, DTOs, mappers, or feature boundaries.

## Canon sources
Read these sections first:
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_a.md` sections 6-7
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_b.md` sections 11-13 and 18-20 when networking or cache is involved
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_d.md` sections 30-36

## Feature contract
Every feature follows this structure:
- `0_entity/` for stable business language, enums, and value objects.
- `1_domain/` for repository abstractions, use cases, domain services, and failures.
- `2_presentation/` for controllers, providers, routes, pages, widgets, and screen state.
- `3_data/` for API wrappers, datasources, DTOs, mappers, and concrete repositories.

## Layer rules
- `0_entity/` stays pure: no Flutter, Riverpod, Dio, `BuildContext`, or infrastructure dependencies.
- DTOs are never reused as domain entities for convenience unless there is an explicit ADR.
- Use cases represent a single clear behavior with explicit inputs and outputs.
- Pick one result strategy for the repo and keep it uniform.
- `3_data/` owns remote/local access, mapping, offline strategy, and conversion from technical exceptions to domain failures.
- Mappers stay explicit and get tests when they are not trivial.

## Ownership and dependency rules
- `2_presentation -> 1_domain -> 0_entity`
- `3_data -> 1_domain -> 0_entity`
- Pages, widgets, and controllers do not import concrete `3_data/` implementations.
- `2_presentation/providers/` is the only allowed DI composition point that may wire `3_data/` to `1_domain/`.
- A feature may depend on `core/` and approved public contracts from another feature, never on another feature's internals.

## Anti-patterns to reject
- DTO leak outside `3_data/`
- `BuildContext` inside domain or data
- manual singleton or hidden service locator
- feature god object
- raw backend or transport errors shown to the user
- `utils.dart` as a catch-all ownership sink

## Done checklist
- The feature keeps the 0/1/2/3 contract intact.
- Entities, use cases, repositories, datasources, and mappers have clear ownership.
- No forbidden imports or DTO leaks were introduced.
- Naming stays consistent with the canon: `snake_case.dart`, `PascalCase`, `camelCase`, `*Provider`, `*UseCase`, `*RepositoryImpl`, `*State`.
