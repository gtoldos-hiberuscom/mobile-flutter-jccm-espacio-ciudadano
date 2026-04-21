---
name: ticket-reassign
description: Change the assignee or unassign a ticket while recording the change in the ticket history.
---

Use this skill when the task is to assign, reassign, or unassign a ticket.

## Schema preservation rules
- Resolve the target ticket from `id`, `jira_key`, or an explicit `tickets/<TYPE>-{id}.md` path, but edit only the canonical file named from `type + id`.
- Preserve all frontmatter keys, their order, and all required sections.
- Preserve the H1 as `# [<TYPE>-<id>] <Summary>`.
- Only mutate `assignee` and `updated_at` unless the user explicitly requests additional field changes.
- Keep list-typed fields such as `labels`, `fix_versions`, and `affected_versions` untouched.

## Rules
- Read the current ticket file first.
- Update the `assignee` field only.
- Preserve all other metadata unless explicitly asked to change it.
- Update `updated_at`.
- Append a changelog entry under `## Notes` -> `### Change Log`.

## Changelog format
- `2026-04-21T10:16:00Z | assignee | Daniel Lostao Bono -> María Pérez | by Copilot`
- `2026-04-21T10:17:00Z | assignee | María Pérez -> <empty> | by Copilot`
