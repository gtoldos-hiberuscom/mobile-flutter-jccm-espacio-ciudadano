---
name: ticket-transition
description: Change a ticket workflow state, priority, sprint, due date, or other workflow-related metadata while preserving ticket history.
---

Use this skill when the task is to move a ticket through its workflow or adjust workflow-related metadata.

## Canonical workflow fields
- Resolve the target ticket from `id`, `jira_key`, or an explicit `tickets/<TYPE>-{id}.md` path, but edit only the canonical file named from `type + id`.
- The workflow-related frontmatter fields are `status`, `priority`, `sprint`, and `due_date`.
- Preserve all other frontmatter keys, their order, and all required sections.
- Preserve the H1 as `# [<TYPE>-<id>] <Summary>` and do not rewrite the visible typed prefix during a pure transition.
- Do not invent new workflow metadata fields outside the canonical schema.

## Status change workflow
Use the default workflow below unless the repository or user specifies a stricter one:
- `To Do` -> `In Progress`, `Blocked`, `Cancelled`
- `In Progress` -> `QA Testing`, `Blocked`, `To Do`
- `QA Testing` -> `Done`, `In Progress`, `Blocked`
- `Blocked` -> `In Progress`, `Cancelled`
- `Done` -> `Reopened`
- `Reopened` -> `In Progress`, `Blocked`

If the requested transition falls outside this workflow and there is no explicit user override, do not silently apply it.

## Required actions
- Read the current ticket file first.
- Update `status` and any related workflow fields explicitly requested.
- Update `updated_at`.
- Append a concise entry under `## Notes` -> `### Change Log` using ISO8601 time and old/new values.
- Do not delete previous changelog entries.

## Suggested changelog format
- `2026-04-21T10:12:00Z | status | To Do -> In Progress | by Copilot`
- `2026-04-21T10:13:00Z | priority | Medium -> High | by Copilot`
