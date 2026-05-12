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

## Ticket repository conventions for Copilot

This repository stores Jira-style tickets as Markdown files.

## Ticket location and naming
- All tickets live under `tickets/`.
- Each ticket uses exactly one file.
- The filename must be derived from `type + id` using:
  - `Epic` -> `EPIC-{id}`
  - `Story` -> `STORY-{id}`
  - `Task` -> `TASK-{id}`
  - `Subtask` -> `SUBTASK-{id}`
  - `Bug` -> `BUG-{id}`
  - `Other` -> `OTHER-{id}`
- Every epic, story, task, and subtask must have its own file. Never store child tickets as inline pseudo-subtasks, ad hoc checklists, or child-ticket sections inside a parent ticket file.
- The H1 must be `# [<TYPE>-<id>] <Summary>`.
- Before reusing a summary to build a title or slug, strip any existing leading `[<TYPE>-<id>]` token to avoid duplicated prefixes.

## Mandatory schema
Every ticket file must preserve the exact YAML key order defined below:
1. `id`
2. `jira_key`
3. `type`
4. `status`
5. `priority`
6. `project`
7. `epic_link`
8. `parent`
9. `sprint`
10. `reporter`
11. `assignee`
12. `story_points`
13. `labels`
14. `fix_versions`
15. `affected_versions`
16. `created_at`
17. `updated_at`
18. `due_date`
19. `jira_url`

## Ticket identifier conventions
- `id` is the numeric internal identifier and is the source of truth for the numeric segment of the filename.
- The canonical filename is `tickets/<TYPE>-{id}.md`, where `<TYPE>` is derived from `type + id`.
- `jira_key` is the external tracker key, such as `NAVEMP-126`; it is not used as the filename.
- A user may refer to a ticket by `id`, `jira_key`, or file path, but repository edits must always target the canonical file resolved from `id`.
- The visible typed identifier in titles, branch names, and planning artifacts always comes from `type + id`, never from `jira_key`.

## Ticket field definitions
- `id`: numeric internal identifier, required, must match the numeric segment of the filename.
- `jira_key`: external issue key from the source system, or empty when unavailable.
- `type`: source-system or planning issue type label such as `Epic`, `Story`, `Task`, `Subtask`, or `Bug`.
- `status`: workflow state label.
- `priority`: priority label from the source system.
- `project`: stable project key or project identifier from the source system.
- `epic_link`: related epic `jira_key`, or empty.
- `parent`: parent `jira_key`, or empty.
- `sprint`: sprint name, or empty.
- `reporter`: reporter display name, or empty.
- `assignee`: assignee display name, or empty.
- `story_points`: numeric estimate, or empty.
- `labels`: YAML list of strings; use `[]` when empty.
- `fix_versions`: YAML list of version strings; use `[]` when empty.
- `affected_versions`: YAML list of version strings; use `[]` when empty.
- `created_at`: original creation timestamp in ISO8601.
- `updated_at`: last modification timestamp in ISO8601; update it on every mutation.
- `due_date`: due-date timestamp in ISO8601, or empty.
- `jira_url`: full tracker URL, or empty.
- `# [<TYPE>-<id>] <Summary>`: the human-readable ticket summary; this lives in the H1 heading, not in frontmatter.

Each file must also contain these required sections in this order:
- `# [<TYPE>-<id>] <Summary>`
- `## Functional Description`
- `## Acceptance Criteria`
- `## Technical Details`
- `## Traceability`
- `## Notes`

## Managed branch naming
- Managed epic branches must be `epic/<EPIC-id>-<epic-slug>`.
- Managed ticket branches must be `ticket/<EPIC-id>-<epic-slug>/<TYPE-id>-<ticket-slug>`.
- Managed task branches must be `task/<EPIC-id>-<epic-slug>/<TYPE-id>-<ticket-slug>/<task-slug>`.
- Slugs must be lowercase, ASCII-only, hyphen-separated, and derived from normalized title text without the visible `[<TYPE>-<id>]` prefix.
- `jira_key` remains tracker metadata only; it must not replace the visible typed identifier in branch names, task lineage, or planning headings.

## Notes conventions
Inside `## Notes`, prefer these optional subsections when relevant:
- `### Comments`
- `### Change Log`
- `### Decisions`

Append new comments and changes. Do not rewrite history unless explicitly asked.

## Management rules
- Preserve the original language of user-provided ticket content.
- Section headings remain in English.
- Never invent ticket relationships or metadata.
- Always update `updated_at` after any change.
- Keep `created_at` stable unless the user explicitly corrects it.
- Preserve list-typed fields as YAML lists instead of comma-separated strings or scalar placeholders.
