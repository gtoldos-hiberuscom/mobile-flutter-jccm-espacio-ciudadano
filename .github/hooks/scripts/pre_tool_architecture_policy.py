#!/usr/bin/env python3
from __future__ import annotations

import json

from architecture_common import append_audit, parse_tool_args, read_stdin_json, validate_architecture_path_string


def deny(reason: str) -> int:
    print(json.dumps({"permissionDecision": "deny", "permissionDecisionReason": reason}, ensure_ascii=False))
    return 0


def main() -> int:
    payload = read_stdin_json()
    tool_name = payload.get("toolName", "")
    tool_args = parse_tool_args(payload.get("toolArgs"))
    append_audit({"event": "preToolUse", "toolName": tool_name})

    if tool_name in {"edit", "create"}:
        path_value = str(tool_args.get("path", "") or "")
        errors = validate_architecture_path_string(path_value)
        if errors:
            append_audit(
                {
                    "event": "policyDeny",
                    "toolName": tool_name,
                    "path": path_value,
                    "reason": errors[0],
                }
            )
            return deny(errors[0])

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
