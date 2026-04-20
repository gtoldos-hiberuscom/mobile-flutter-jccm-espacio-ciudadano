#!/usr/bin/env python3
from __future__ import annotations

from common import append_audit, git_changed_ticket_files, read_stdin_json


def main() -> int:
    payload = read_stdin_json()
    append_audit(
        {
            "event": "sessionEnd",
            "reason": payload.get("reason"),
            "changedTickets": [p.as_posix() for p in git_changed_ticket_files()],
        }
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
