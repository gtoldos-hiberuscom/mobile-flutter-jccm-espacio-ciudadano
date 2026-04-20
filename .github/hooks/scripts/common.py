#!/usr/bin/env python3
from __future__ import annotations

import json
import os
import pathlib
import re
import subprocess
import sys
from datetime import datetime, timezone
from typing import Any

ROOT = pathlib.Path.cwd()
LOG_DIR = ROOT / ".github" / "hooks" / "logs"
AUDIT_LOG = LOG_DIR / "ticket-audit.jsonl"
REQUIRED_FRONTMATTER_KEYS = [
    "id",
    "jira_key",
    "type",
    "status",
    "priority",
    "project",
    "epic_link",
    "parent",
    "sprint",
    "reporter",
    "assignee",
    "story_points",
    "labels",
    "fix_versions",
    "affected_versions",
    "created_at",
    "updated_at",
    "due_date",
    "jira_url",
]
REQUIRED_SECTIONS = [
    "## Functional Description",
    "## Acceptance Criteria",
    "## Technical Details",
    "## Traceability",
    "## Notes",
]
TICKET_PATH_RE = re.compile(r"(^|/)tickets/TICKET-(\d+)\.md$")


def ensure_log_dir() -> None:
    LOG_DIR.mkdir(parents=True, exist_ok=True)


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def read_stdin_json() -> dict[str, Any]:
    raw = sys.stdin.read().strip()
    if not raw:
        return {}
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return {"raw": raw}


def append_audit(event: dict[str, Any]) -> None:
    ensure_log_dir()
    payload = {"ts": utc_now(), **event}
    with AUDIT_LOG.open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(payload, ensure_ascii=False) + "\n")


def parse_tool_args(raw: str | None) -> dict[str, Any]:
    if not raw:
        return {}
    try:
        value = json.loads(raw)
        if isinstance(value, dict):
            return value
    except json.JSONDecodeError:
        return {"raw": raw}
    return {}


def git_changed_ticket_files() -> list[pathlib.Path]:
    try:
        proc = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=ROOT,
            capture_output=True,
            text=True,
            check=False,
        )
    except FileNotFoundError:
        return []
    if proc.returncode != 0:
        return []

    files: list[pathlib.Path] = []
    for line in proc.stdout.splitlines():
        if not line.strip():
            continue
        path_part = line[3:]
        if " -> " in path_part:
            path_part = path_part.split(" -> ", 1)[1]
        path = pathlib.Path(path_part)
        normalized = path.as_posix()
        if TICKET_PATH_RE.search(normalized):
            files.append(ROOT / path)
    unique: list[pathlib.Path] = []
    seen: set[str] = set()
    for item in files:
        key = str(item)
        if key not in seen:
            seen.add(key)
            unique.append(item)
    return unique


def validate_ticket_file(path: pathlib.Path) -> list[str]:
    errors: list[str] = []
    rel = path.relative_to(ROOT).as_posix() if path.is_absolute() else path.as_posix()

    if not path.exists():
        errors.append(f"{rel}: file does not exist")
        return errors

    name_match = re.match(r"TICKET-(\d+)\.md$", path.name)
    if not name_match:
        errors.append(f"{rel}: invalid filename; expected TICKET-{{id}}.md")
        return errors

    content = path.read_text(encoding="utf-8")
    if not content.startswith("---\n"):
        errors.append(f"{rel}: missing opening frontmatter delimiter")
        return errors

    parts = content.split("\n---\n", 1)
    if len(parts) != 2:
        errors.append(f"{rel}: missing closing frontmatter delimiter")
        return errors

    frontmatter_raw = parts[0][4:]
    body = parts[1]

    keys_in_order = []
    key_values: dict[str, str] = {}
    for line in frontmatter_raw.splitlines():
        match = re.match(r"^([a-z_]+):\s*(.*)$", line)
        if match:
            key = match.group(1)
            value = match.group(2)
            keys_in_order.append(key)
            key_values[key] = value

    if keys_in_order != REQUIRED_FRONTMATTER_KEYS:
        errors.append(
            f"{rel}: frontmatter key order mismatch; expected {', '.join(REQUIRED_FRONTMATTER_KEYS)}"
        )

    ticket_id = key_values.get("id", "")
    if not ticket_id.isdigit():
        errors.append(f"{rel}: id must be numeric")
    elif ticket_id != name_match.group(1):
        errors.append(f"{rel}: file name id does not match frontmatter id")

    if not re.search(r"^#\s+.+", body, flags=re.MULTILINE):
        errors.append(f"{rel}: missing level-1 summary heading")

    for section in REQUIRED_SECTIONS:
        if section not in body:
            errors.append(f"{rel}: missing required section '{section}'")

    return errors
