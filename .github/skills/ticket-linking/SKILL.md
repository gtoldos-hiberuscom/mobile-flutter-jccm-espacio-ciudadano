---
name: ticket-linking
description: Maintain epic, parent, blocked-by, blocks, and related links consistently across ticket frontmatter and body sections.
---

Use this skill when the task is to add or update ticket relationships.

## Canonical relationship mapping
- Resolve the target ticket from `id`, `jira_key`, or an explicit `tickets/TICKET-{id}.md` path, but edit only the canonical file named from `id`.
- Preserve the H1 as `# [<TYPE>-<id>] <Summary>`.
- `epic_link` stores an epic `jira_key`, not a numeric internal id.
- `parent` stores a parent `jira_key`, not a numeric internal id.
- `Blocked by`, `Blocks`, and `Related to` belong in `## Technical Details` -> `Dependencies`; do not create extra frontmatter keys for them.
- `## Traceability` mirrors Jira, epic, and parent identifiers; preserve all other schema fields unchanged.

## Relationship sources
Only use relationships explicitly present in the user input or existing source system data.
Do not invent links.

## Required synchronization
When a relationship changes:
- Update `epic_link` and/or `parent` in frontmatter when applicable.
- Update `## Technical Details` dependency bullets.
- Update `## Traceability` values.
- Update `updated_at`.
- Append a concise changelog entry under `## Notes` -> `### Change Log`.

## Supported relationships
- Epic
- Parent
- Blocked by
- Blocks
- Related to
