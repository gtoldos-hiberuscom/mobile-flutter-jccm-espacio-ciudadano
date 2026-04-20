#!/usr/bin/env python3
from __future__ import annotations

from common import append_audit, read_stdin_json


def main() -> int:
    payload = read_stdin_json()
    append_audit(
        {
            "event": "errorOccurred",
            "error": payload.get("error") or payload.get("message") or "unknown",
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
