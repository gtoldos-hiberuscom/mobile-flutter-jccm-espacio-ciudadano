#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path

from common import append_audit, parse_tool_args, read_stdin_json


def deny(reason: str) -> int:
    print(json.dumps({"permissionDecision": "deny", "permissionDecisionReason": reason}, ensure_ascii=False))
    return 0


def main() -> int:
    payload = read_stdin_json()
    tool_name = payload.get("toolName", "")
    tool_args = parse_tool_args(payload.get("toolArgs"))
    append_audit({"event": "preToolUse", "toolName": tool_name})

    if tool_name in {"edit", "create"}:
        path_value = str(tool_args.get("path", "") or "").replace("\\", "/")
        if path_value.startswith("tickets/"):
            basename = os.path.basename(path_value)
            if basename == "README.md":
                return 0
            if not re.fullmatch(r"(EPIC|STORY|TASK|SUBTASK|BUG|OTHER)-\d+\.md", basename):
                return deny(
                    "Ticket files under tickets/ must be named README.md or <TYPE>-{id}.md using EPIC, STORY, TASK, SUBTASK, BUG, or OTHER"
                )
            if not path_value.endswith(".md"):
                return deny("Ticket files under tickets/ must be Markdown files")

    if tool_name == "bash":
        command = str(tool_args.get("command", "") or "")
        dangerous_patterns = [
            r"rm\s+-rf\s+tickets(?:/|\s|$)",
            r"find\s+tickets\b.*-delete",
            r"mv\s+.+\s+tickets/[^\s]+\.md",
        ]
        for pattern in dangerous_patterns:
            if re.search(pattern, command):
                append_audit({"event": "policyDeny", "toolName": tool_name, "reason": "dangerous ticket command"})
                return deny("Potentially destructive ticket command blocked by ticket policy")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
