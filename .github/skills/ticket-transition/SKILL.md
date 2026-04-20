---
name: ticket-transition
description: Change a ticket workflow state, priority, sprint, due date, or other workflow-related metadata while preserving ticket history.
argument-hint: When asking to transition a ticket, provide as much context as possible about the relevant ticket, the desired status or metadata change, and the expected outcome. For example:
Move ticket NAVEMP-126 from "To Do" to "In Progress". Make sure to read the existing ticket file first, verify that the transition follows the defined workflow, update the "status" field accordingly, update the "updated_at" field, and append a concise changelog entry under "## Notes" -> "### Change Log" with the format: "- 2026-04-21T10:12:00Z | status | To Do -> In Progress | by Copilot". If the transition is outside the default workflow, do not apply it unless there is an explicit user override.
target: github-copilot
---

Use this skill when the task is to move a ticket through its workflow or adjust workflow-related metadata.

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
