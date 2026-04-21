---
name: flutter-ticket-sync
description: >-
  Keep implementation work synchronized with the repository ticket flow by
  delegating ticket administration to ticket-manager or the ticket skills. Use
  when a code change is driven by a ticket, Jira key, or acceptance criteria
  that must be reflected back into tracking.
---

Use this skill when an implementation task comes from a ticket or when completion evidence should be written back to ticket tracking.

## Coordination rule
The canonical ticket-administration agent is `ticket-manager`. Use it for structural ticket updates or when several ticket fields must change together.

## Ticket schema conventions
- `id` is the numeric internal identifier and defines the canonical filename `tickets/TICKET-{id}.md`.
- `jira_key` is the external tracker key and may be used as lookup context, but not as the filename.
- The visible ticket identifier in titles and branch lineage comes from `type + id`: `Epic->EPIC`, `Story->STORY`, `Task->TASK`, `Subtask->SUBTASK`, `Bug->BUG`, `Other->OTHER`.
- Ticket H1 headings must be `# [<TYPE>-<id>] <Summary>`.
- The canonical frontmatter fields are the ones defined in `copilot-instructions.md`; preserve them exactly, including key order.
- `labels`, `fix_versions`, and `affected_versions` are YAML lists.
- `epic_link` and `parent` store `jira_key` values; `blocked-by`, `blocks`, and `related` belong in `## Technical Details` -> `Dependencies`.

When a direct operation is enough, use the existing ticket skills:
- `ticket-create-update`
- `ticket-transition`
- `ticket-comment`
- `ticket-reassign`
- `ticket-linking`
- `ticket-complete`

## Workflow
1. Resolve the ticket context from the user request, a Jira key, or an existing `tickets/TICKET-{id}.md`.
2. Read the ticket before implementing when the file exists.
3. Align the code change with the ticket acceptance criteria and technical notes.
4. After implementation, report progress or evidence through `ticket-manager` or the right ticket skill.
5. Move status conservatively:
   - use `ticket-comment` for progress and implementation notes;
   - use `ticket-transition` for workflow changes;
   - use `ticket-complete` only when the listed acceptance criteria are demonstrably satisfied;
   - use `ticket-linking` if the work reveals blockers, dependencies, or ADR traceability.

## Guardrails
- Never invent ticket ids, dates, assignees, relationships, or acceptance criteria.
- Never bypass the ticket schema with ad hoc edits when a ticket skill or `ticket-manager` should handle the change.
- If no ticket context exists, say ticket synchronization is not applicable.
