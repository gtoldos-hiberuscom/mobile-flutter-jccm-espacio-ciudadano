# Ticket storage convention

This folder stores Jira-style tickets as Markdown files.

## Rules
- One file per ticket.
- Filename: `TICKET-{id}.md`.
- Keep the mandatory frontmatter and section order intact.
- Preserve the original language of user-provided ticket content.
- Store new comments in `## Notes` -> `### Comments`.
- Store operational history in `## Notes` -> `### Change Log`.

## Example comment entry
- `2026-04-21T10:15:00Z | author: Copilot | comment: Waiting for PO validation.`

## Example change-log entry
- `2026-04-21T10:16:00Z | status | To Do -> In Progress | by Copilot`
