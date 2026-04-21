#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import shlex

from common import append_audit, parse_tool_args, read_stdin_json, read_ticket_frontmatter, ticket_type_to_visible_prefix

SLUG_RE = r"[a-z0-9]+(?:-[a-z0-9]+)*"
EPIC_SEGMENT_RE = re.compile(rf"^(EPIC)-(\d+)-({SLUG_RE})$")
TYPED_SEGMENT_RE = re.compile(rf"^(EPIC|STORY|TASK|SUBTASK|BUG|OTHER)-(\d+)-({SLUG_RE})$")
TASK_SLUG_RE = re.compile(rf"^{SLUG_RE}$")
COMMAND_SPLIT_RE = re.compile(r"(?:&&|\|\||;|\n)")


def deny(reason: str) -> int:
    print(json.dumps({"permissionDecision": "deny", "permissionDecisionReason": reason}, ensure_ascii=False))
    return 0


def split_command_segments(command: str) -> list[str]:
    return [segment.strip() for segment in COMMAND_SPLIT_RE.split(command) if segment.strip()]


def extract_created_branch_names(command: str) -> list[str]:
    branch_names: list[str] = []
    for segment in split_command_segments(command):
        try:
            tokens = shlex.split(segment)
        except ValueError:
            continue
        if len(tokens) < 3 or tokens[0] != "git":
            continue

        subcommand = tokens[1]
        if subcommand == "checkout" and "-b" in tokens:
            index = tokens.index("-b")
            if index + 1 < len(tokens):
                branch_names.append(tokens[index + 1])
        elif subcommand == "switch" and "-c" in tokens:
            index = tokens.index("-c")
            if index + 1 < len(tokens):
                branch_names.append(tokens[index + 1])
        elif subcommand == "branch":
            branch_name = extract_git_branch_target(tokens[2:])
            if branch_name is not None:
                branch_names.append(branch_name)
    return branch_names


def extract_git_branch_target(args: list[str]) -> str | None:
    if not args:
        return None
    if args[0].startswith("-"):
        return None
    return args[0]


def validate_ticket_type_token(segment: str) -> str | None:
    match = TYPED_SEGMENT_RE.fullmatch(segment)
    if match is None:
        return f"Managed branch segment '{segment}' must match <TYPE-id>-<slug> using uppercase TYPE and lowercase slug"

    prefix, ticket_id, _ = match.groups()
    ticket = read_ticket_frontmatter(ticket_id)
    if ticket is None:
        return None

    expected_prefix = ticket_type_to_visible_prefix(ticket.get("type", ""))
    if expected_prefix is None:
        return None
    if prefix != expected_prefix:
        return (
            f"Managed branch segment '{segment}' does not match canonical ticket type for id {ticket_id} "
            f"type '{ticket.get('type', '')}' (expected prefix {expected_prefix})"
        )
    return None


def validate_epic_segment(segment: str) -> str | None:
    match = EPIC_SEGMENT_RE.fullmatch(segment)
    if match is None:
        return "Epic branches must match epic/EPIC-<id>-<epic-slug> with an uppercase EPIC token and lowercase slug"

    _, ticket_id, _ = match.groups()
    ticket = read_ticket_frontmatter(ticket_id)
    if ticket is None:
        return None

    expected_prefix = ticket_type_to_visible_prefix(ticket.get("type", ""))
    if expected_prefix == "EPIC":
        return None
    return (
        f"Epic branch segment '{segment}' does not match canonical epic ticket type for id {ticket_id} "
        f"type '{ticket.get('type', '')}' (expected prefix EPIC)"
    )


def validate_managed_branch_name(branch_name: str) -> str | None:
    parts = branch_name.split("/")
    if not parts:
        return None

    kind = parts[0]
    if kind == "epic":
        if len(parts) != 2:
            return "Managed epic branches must look like epic/EPIC-<id>-<epic-slug>"
        return validate_epic_segment(parts[1])

    if kind == "ticket":
        if len(parts) != 3:
            return "Managed ticket branches must look like ticket/EPIC-<id>-<epic-slug>/<TYPE-id>-<ticket-slug>"
        epic_error = validate_epic_segment(parts[1])
        if epic_error:
            return epic_error
        return validate_ticket_type_token(parts[2])

    if kind == "task":
        if len(parts) != 4:
            return "Managed task branches must look like task/EPIC-<id>-<epic-slug>/<TYPE-id>-<ticket-slug>/<task-slug>"
        epic_error = validate_epic_segment(parts[1])
        if epic_error:
            return epic_error
        ticket_error = validate_ticket_type_token(parts[2])
        if ticket_error:
            return ticket_error
        if not TASK_SLUG_RE.fullmatch(parts[3]):
            return "Task branch slugs must be lowercase ASCII and hyphen-separated"
        return None

    return None


def main() -> int:
    payload = read_stdin_json()
    tool_name = payload.get("toolName", "")
    tool_args = parse_tool_args(payload.get("toolArgs"))
    append_audit({"event": "preToolUse", "toolName": tool_name})

    if tool_name != "bash":
        return 0

    command = str(tool_args.get("command", "") or "")
    if not command:
        return 0

    for branch_name in extract_created_branch_names(command):
        error = validate_managed_branch_name(branch_name)
        if error is not None:
            append_audit(
                {
                    "event": "policyDeny",
                    "toolName": tool_name,
                    "branchName": branch_name,
                    "reason": error,
                }
            )
            return deny(error)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
