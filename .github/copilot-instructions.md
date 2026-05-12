# Copilot repository conventions

## Preferred agents and skills
- Use `project-planner` when the user wants a project roadmap, epics, stories, risks, dependencies, and ticket-tree creation from specifications or repository documentation.
- Use `plan-manager` when the user wants coordinated backlog or plan execution across tickets, implementation, validation, and progressive branch integration.
- Use `implementer` for Flutter implementation, scaffolding, refactors, and architecture-sensitive work.
- Use `jira-progress-orchestrator` for Jira ticket administration (comments, transitions, syncing) scoped to project `JCCMEC`.
- If an implementation request references a ticket, keep code and Jira traceability synchronized by having `implementer` delegate Jira operations to `jira-progress-orchestrator`.

## Architecture source of truth
- The repository architecture source of truth is `documentation/ARCHITECTURE.md`.
- Read only the relevant sections of `documentation/ARCHITECTURE.md` for the area being changed.
- Default project structure:
  - `lib/core/` for global composition, bootstrap, shared infrastructure
  - `lib/features/` for business modules
  - `lib/l10n/` for localization assets
- Default feature structure:
  - `0_entity/`
  - `1_domain/`
  - `2_presentation/`
  - `3_data/`
- Default technology choices from the architecture guide:
  - Riverpod 3 with `@riverpod` and `Notifier` / `AsyncNotifier`
  - GoRouter for routing
  - Dio for networking
  - typed app configuration
  - localized user-facing strings
  - centralized design system and theme tokens
- Version policy for those default technology choices:
  - Use the latest stable versions that are compatible with the current Flutter/Dart SDK and the repository constraints.
  - Do not introduce or recommend old package versions when adding or updating dependencies just because they are familiar or previously used.
  - If the latest viable version cannot be used, document the concrete compatibility constraint or obtain explicit user approval for the exception.
- Forbidden architecture shortcuts:
  - global `lib/models`, `lib/screens`, `lib/services`, `lib/repositories`, `lib/widgets`, or `lib/utils.dart`
  - DTO leaks outside `3_data/`
  - `BuildContext` in domain or data
  - business logic in notifier constructors
  - raw backend or transport errors shown to the user
- Any meaningful exception to `documentation/ARCHITECTURE.md` requires an ADR or explicit user approval.

## Jira source of truth

Jira project **`JCCMEC`** (`https://hiberusmobile.atlassian.net/browse/JCCMEC`) is the single source of truth for all tickets.

- All ticket operations (comments, transitions, metadata updates) must go through `jira-progress-orchestrator`.
- `jira-progress-orchestrator` enforces the hard project scope `JCCMEC` and must be used for every Jira write.
- Ticket identifiers referenced in branch names, commit messages, and planning artifacts use the Jira key format `JCCMEC-{n}`.

## Managed branch naming
- Managed epic branches must be `epic/<EPIC-id>-<epic-slug>`.
- Managed ticket branches must be `ticket/<EPIC-id>-<epic-slug>/<TYPE-id>-<ticket-slug>`.
- Managed task branches must be `task/<EPIC-id>-<epic-slug>/<TYPE-id>-<ticket-slug>/<task-slug>`.
- Slugs must be lowercase, ASCII-only, and hyphen-separated.
