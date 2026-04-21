#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path

from common import ROOT, git_changed_ticket_files, parse_ticket_filename, validate_ticket_file


def discover_all_ticket_files() -> list[Path]:
    tickets_dir = ROOT / "tickets"
    if not tickets_dir.exists():
        return []
    return sorted(
        path for path in tickets_dir.rglob("*.md") if path.name != "README.md"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate Jira-style ticket markdown files")
    parser.add_argument("--changed-only", action="store_true", help="Validate only changed ticket files")
    args = parser.parse_args()

    files = git_changed_ticket_files() if args.changed_only else discover_all_ticket_files()
    errors: list[str] = []
    ids_to_paths: dict[str, list[Path]] = {}
    for path in files:
        errors.extend(validate_ticket_file(path))
        parsed_name = parse_ticket_filename(path)
        if parsed_name is None:
            continue
        _, ticket_id = parsed_name
        ids_to_paths.setdefault(ticket_id, []).append(path)

    for ticket_id, paths in ids_to_paths.items():
        if len(paths) > 1:
            rel_paths = ", ".join(sorted(p.relative_to(ROOT).as_posix() for p in paths))
            errors.append(f"ticket id {ticket_id}: duplicate canonical files detected ({rel_paths})")

    result = {
        "validated": [p.relative_to(ROOT).as_posix() for p in files],
        "ok": not errors,
        "errors": errors,
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if not errors else 1


if __name__ == "__main__":
    raise SystemExit(main())
