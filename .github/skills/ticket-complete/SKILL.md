---
name: ticket-complete
description: Close or resolve a ticket conservatively by checking evidence, updating status, and preserving traceability.
---

Use this skill when the task is to complete, close, resolve, or move a ticket to done.

## Schema preservation rules
- Resolve the target ticket from `id`, `jira_key`, or an explicit `tickets/TICKET-{id}.md` path, but edit only the canonical file named from `id`.
- Preserve all frontmatter keys, their order, and all required sections.
- Preserve the H1 as `# [<TYPE>-<id>] <Summary>`.
- Only mutate workflow- and completion-related content unless the user explicitly requests broader metadata changes.
- Do not rewrite unrelated fields such as `project`, `labels`, `fix_versions`, or `affected_versions`.

## Completion rules
- Read the ticket first.
- Review `## Acceptance Criteria`.
- Only mark criteria as completed when the user or repository evidence clearly supports it.
- If completion evidence is partial, prefer moving the ticket to `QA Testing` instead of `Done`.
- If evidence is insufficient, do not force completion.

## Required actions when closing
- Update `status`.
- Update `updated_at`.
- Mark completed acceptance criteria with `[x]` only when justified.
- Append a concise resolution note under `## Notes`.
- Append a changelog entry under `### Change Log`.

## Suggested resolution note
`- 2026-04-21T10:20:00Z | resolution: Ticket moved to Done after validating all listed acceptance criteria.`
