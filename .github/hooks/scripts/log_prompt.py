#!/usr/bin/env python3
from __future__ import annotations

from common import append_audit, read_stdin_json


def main() -> int:
    payload = read_stdin_json()
    prompt = payload.get("prompt", "") or ""
    append_audit(
        {
            "event": "userPromptSubmitted",
            "cwd": payload.get("cwd"),
            "promptLength": len(prompt),
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
