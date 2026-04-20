#!/usr/bin/env python3
from __future__ import annotations

from common import append_audit, ensure_log_dir, read_stdin_json


def main() -> int:
    ensure_log_dir()
    payload = read_stdin_json()
    append_audit(
        {
            "event": "sessionStart",
            "source": payload.get("source"),
            "cwd": payload.get("cwd"),
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
