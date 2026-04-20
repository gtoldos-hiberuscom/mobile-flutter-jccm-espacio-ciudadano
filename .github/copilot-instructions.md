# Copilot repository conventions

## Preferred agents and skills
- Use `implementer` for Flutter implementation, scaffolding, refactors, and architecture-sensitive work.
- Use `ticket-manager` for ticket administration in `tickets/`.
- If an implementation request references a ticket, keep code and ticket traceability synchronized through `ticket-manager` or the ticket skills.

## Architecture source of truth
- The repository architecture source of truth is `documentation/architecture_canon_flutter_v2_docs/`.
- Read `architecture_canon_flutter_v2_index.md` first, then the relevant annex for the area being changed.
- Default project structure:
  - `lib/app/` for global composition and bootstrap
  - `lib/core/` for shared infrastructure
  - `lib/features/` for business modules
  - `lib/l10n/` for localization assets
- Default feature structure:
  - `0_entity/`
  - `1_domain/`
  - `2_presentation/`
  - `3_data/`
- Default technology choices from the canon:
  - Riverpod with `@riverpod` and `Notifier` / `AsyncNotifier`
  - GoRouter for routing
  - Dio for networking
  - typed app configuration
  - localized user-facing strings
  - centralized design system and theme tokens
- Forbidden architecture shortcuts:
  - global `lib/models`, `lib/screens`, `lib/services`, `lib/repositories`, `lib/widgets`, or `lib/utils.dart`
  - DTO leaks outside `3_data/`
  - `BuildContext` in domain or data
  - business logic in notifier constructors
  - raw backend or transport errors shown to the user
- Any meaningful exception to the canon requires an ADR or explicit user approval.

## Ticket repository conventions for Copilot

This repository stores Jira-style tickets as Markdown files.

## Ticket location and naming
- All tickets live under `tickets/`.
- Each ticket uses exactly one file.
- The filename must be `TICKET-{id}.md`.

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

Each file must also contain these required sections in this order:
- `# <Summary>`
- `## Functional Description`
- `## Acceptance Criteria`
- `## Technical Details`
- `## Traceability`
- `## Notes`

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
