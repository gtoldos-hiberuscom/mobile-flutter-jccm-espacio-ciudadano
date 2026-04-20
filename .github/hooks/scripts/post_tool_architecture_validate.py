#!/usr/bin/env python3
from __future__ import annotations

from architecture_common import (
    ROOT,
    append_audit,
    collect_repo_architecture_issues,
    git_changed_dart_files,
    read_stdin_json,
    validate_architecture_path_string,
)


def main() -> int:
    payload = read_stdin_json()
    tool_name = payload.get("toolName", "")

    if tool_name not in {"edit", "create", "bash"}:
        return 0

    changed = git_changed_dart_files()
    if not changed:
        return 0

    errors: list[str] = []
    for path in changed:
        rel = path.relative_to(ROOT).as_posix()
        errors.extend(validate_architecture_path_string(rel))

    errors.extend(collect_repo_architecture_issues())
    errors = sorted(set(errors))

    append_audit(
        {
            "event": "postToolUse",
            "toolName": tool_name,
            "changedDartFiles": [p.relative_to(ROOT).as_posix() for p in changed],
            "validationStatus": "ok" if not errors else "error",
            "errors": errors,
        }
    )

    for error in errors:
        print(f"[architecture hook] {error}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
