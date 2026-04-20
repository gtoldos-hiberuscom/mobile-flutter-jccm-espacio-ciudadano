#!/usr/bin/env python3
from __future__ import annotations

from common import append_audit, git_changed_ticket_files, parse_tool_args, read_stdin_json, validate_ticket_file


def main() -> int:
    payload = read_stdin_json()
    tool_name = payload.get("toolName", "")
    parse_tool_args(payload.get("toolArgs"))

    if tool_name not in {"edit", "create", "bash"}:
        return 0

    changed = git_changed_ticket_files()
    if not changed:
        return 0

    errors: list[str] = []
    for path in changed:
        errors.extend(validate_ticket_file(path))

    append_audit(
        {
            "event": "postToolUse",
            "toolName": tool_name,
            "changedTickets": [p.as_posix() for p in changed],
            "validationStatus": "ok" if not errors else "error",
            "errors": errors,
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
