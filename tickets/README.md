# Ticket storage convention

This folder stores Jira-style tickets as Markdown files.

## Rules
- One file per real ticket.
- Canonical ticket filenames are derived from `type + id`:
  - `EPIC-{id}.md`
  - `STORY-{id}.md`
  - `TASK-{id}.md`
  - `SUBTASK-{id}.md`
  - `BUG-{id}.md`
  - `OTHER-{id}.md`
- Visible title: `# [<TYPE>-<id>] <Summary>`.
- Do not use legacy filenames such as `TICKET-{id}.md`.
- Do not store child stories, tasks, or subtasks inline inside a parent ticket file. If the work needs tracking, create a dedicated ticket file.
- Keep the mandatory frontmatter and section order intact.
- Preserve the original language of user-provided ticket content.
- Store new comments in `## Notes` -> `### Comments`.
- Store operational history in `## Notes` -> `### Change Log`.

## Example comment entry
- `2026-04-21T10:15:00Z | author: Copilot | comment: Waiting for PO validation.`

## Example change-log entry
- `2026-04-21T10:16:00Z | status | To Do -> In Progress | by Copilot`
