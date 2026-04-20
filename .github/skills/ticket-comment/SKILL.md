---
name: ticket-comment
description: Append human-readable comments to a ticket without overwriting existing comments or history.
argument-hint: When asking to add a comment, provide as much context as possible about the relevant ticket, the comment author, and the content of the comment. For example:
Add a comment to ticket NAVEMP-126 from author "Copilot" with the content "Waiting for PO validation." Make sure to read the existing ticket file first, append the comment under the "## Notes" -> "### Comments" section, and update the "updated_at" field. If the "### Comments" subsection does not exist, create it inside "## Notes". Follow the required comment format: "- 2026-04-21T10:15:00Z | author: Copilot | comment: Waiting for PO validation."
target: github-copilot
---

Use this skill when the task is to add a comment to a ticket file.

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
