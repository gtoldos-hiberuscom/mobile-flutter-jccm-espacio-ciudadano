---
name: ticket-create-update
description: Create or update a Jira-style Markdown ticket from raw input while preserving the required schema and formatting.
---

Use this skill when the task is to create, normalize, or update a ticket file from structured or semi-structured Jira-like data.

## Objective
Create or update exactly one Markdown file for a ticket using the repository ticket schema.

## Canonical identifier and field rules
- `id` is the numeric internal identifier and, together with `type`, drives the filename `tickets/<TYPE>-{id}.md`.
- `jira_key` is the external tracker key and may be used to locate an existing ticket, but it must not replace `id` in the filename.
- The visible ticket identifier in the H1 comes from `type + id`: `Epic->EPIC`, `Story->STORY`, `Task->TASK`, `Subtask->SUBTASK`, `Bug->BUG`, `Other->OTHER`.
- `summary` maps to the `# [<TYPE>-<id>] <Summary>` heading, not to a frontmatter key.
- `epic_link` and `parent` store related `jira_key` values, not numeric internal ids.
- `labels`, `fix_versions`, and `affected_versions` are YAML lists; use `[]` when they are empty.
- `story_points` is numeric when present; otherwise leave it empty.
- `created_at`, `updated_at`, and `due_date` use ISO8601 timestamps, with `due_date` allowed to be empty.
- Every epic, story, task, and subtask is its own file. Never write child tickets as inline subsections inside the target ticket.

## Workflow
1. Extract the ticket `id` and `type` from the input, or resolve them from an existing ticket file when the user only provides `jira_key`.
2. Target the path `tickets/<TYPE>-{id}.md`.
3. Read the existing file first if it already exists.
4. Use `ticket-template.md` from this skill directory as the canonical structure.
5. Preserve the frontmatter key order exactly.
6. Preserve source language for the ticket content.
7. Strip any leading `[<TYPE>-<id>]` token from the input summary before rebuilding the H1 so the prefix is never duplicated.
8. Normalize formatting only when meaning is unchanged.
9. Update `updated_at` on every mutation.
10. Keep `created_at` stable unless the user explicitly corrects it.

## Acceptance criteria derivation rules
- If explicit acceptance criteria exist, convert them into checkbox items.
- If there are no explicit acceptance criteria but the functional description clearly implies them, derive them conservatively.
- If there is no reliable basis, keep:
  - [ ] To be defined with Product Owner / Business.

## Relationship rules
When input contains epic, parent, blocked-by, blocks, or related references:
- Populate `epic_link` and `parent` in frontmatter when applicable.
- Reflect `blocked-by`, `blocks`, and `related` references under `## Technical Details` -> `Dependencies`.
- Reflect Jira, epic, and parent identifiers under `## Traceability`.
- Do not invent references.

## Missing-data behavior
If a new ticket does not provide `id` or `type`, stop and report the exact missing fields.
If the user only provides `jira_key`, resolve the existing ticket file before editing; if it cannot be resolved uniquely, stop and report the ambiguity.
If optional fields are missing, leave them empty while preserving the schema.

## Output rules
- If you are writing in the repository, modify only the target ticket file.
- If you are answering in chat-only mode, return only the final Markdown for that ticket.
