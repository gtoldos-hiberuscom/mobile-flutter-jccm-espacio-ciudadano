---
name: ticket-comment
description: Append human-readable comments to a ticket without overwriting existing comments or history.
---

Use this skill when the task is to add a comment to a ticket file.

## Schema preservation rules
- Resolve the target ticket from `id`, `jira_key`, or an explicit `tickets/<TYPE>-{id}.md` path, but edit only the canonical file named from `type + id`.
- Preserve all frontmatter keys, their order, and all required sections.
- Preserve the H1 as `# [<TYPE>-<id>] <Summary>`.
- Only mutate `updated_at` in frontmatter for a pure comment operation.
- Do not rewrite `labels`, `fix_versions`, or `affected_versions`; keep their existing YAML-list shape.

## Rules
- Read the current ticket file first.
- Append new comments under `## Notes` -> `### Comments`.
- Never replace or delete existing comments unless explicitly requested.
- Keep comments in the original language requested by the user.
- Update `updated_at`.
- Add a concise changelog entry if the comment represents a significant ticket action.

## Comment format
Use a single bullet per comment:
- `2026-04-21T10:15:00Z | author: Copilot | comment: Waiting for PO validation.`

If the subsection does not exist, create it inside `## Notes`.
