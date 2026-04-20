#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path

from common import ROOT, git_changed_ticket_files, validate_ticket_file


def discover_all_ticket_files() -> list[Path]:
    tickets_dir = ROOT / "tickets"
    if not tickets_dir.exists():
        return []
    return sorted(tickets_dir.rglob("TICKET-*.md"))


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate Jira-style ticket markdown files")
    parser.add_argument("--changed-only", action="store_true", help="Validate only changed ticket files")
    args = parser.parse_args()

    files = git_changed_ticket_files() if args.changed_only else discover_all_ticket_files()
    errors: list[str] = []
    for path in files:
        errors.extend(validate_ticket_file(path))

    result = {
        "validated": [p.relative_to(ROOT).as_posix() for p in files],
        "ok": not errors,
        "errors": errors,
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if not errors else 1


if __name__ == "__main__":
    raise SystemExit(main())
