#!/usr/bin/env python3
from __future__ import annotations

import json
import pathlib
import re
import subprocess
import sys
from datetime import datetime, timezone
from typing import Any

ROOT = pathlib.Path.cwd()
LOG_DIR = ROOT / ".github" / "hooks" / "logs"
AUDIT_LOG = LOG_DIR / "ticket-audit.jsonl"
VISIBLE_ID_PREFIX_BY_TYPE = {
    "Epic": "EPIC",
    "Story": "STORY",
    "Task": "TASK",
    "Subtask": "SUBTASK",
    "Bug": "BUG",
    "Other": "OTHER",
}
VISIBLE_ID_PREFIX_RE = re.compile(r"^\[(EPIC|STORY|TASK|SUBTASK|BUG|OTHER)-\d+\]\s+")
CANONICAL_TICKET_NAME_RE = re.compile(r"^(EPIC|STORY|TASK|SUBTASK|BUG|OTHER)-(\d+)\.md$")
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
TICKET_PATH_RE = re.compile(r"(^|/)tickets/(EPIC|STORY|TASK|SUBTASK|BUG|OTHER|TICKET)-(\d+)\.md$")
FORBIDDEN_CHILD_SECTION_RE = re.compile(
    r"^#{2,6}\s+(Child Tickets|Child Stories|Child Tasks|Subtasks|Sub-tasks|Subtickets|Sub-tickets)\b",
    flags=re.IGNORECASE | re.MULTILINE,
)


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


def ticket_path_from_id(ticket_id: str) -> pathlib.Path | None:
    matches = [
        ROOT / "tickets" / f"{prefix}-{ticket_id}.md"
        for prefix in VISIBLE_ID_PREFIX_BY_TYPE.values()
        if (ROOT / "tickets" / f"{prefix}-{ticket_id}.md").exists()
    ]
    if len(matches) != 1:
        return None
    return matches[0]


def parse_ticket_filename(path: pathlib.Path) -> tuple[str, str] | None:
    match = CANONICAL_TICKET_NAME_RE.fullmatch(path.name)
    if match is None:
        return None
    return match.group(1), match.group(2)


def ticket_type_to_visible_prefix(ticket_type: str) -> str | None:
    return VISIBLE_ID_PREFIX_BY_TYPE.get(ticket_type.strip())


def strip_visible_ticket_prefix(summary: str) -> str:
    return VISIBLE_ID_PREFIX_RE.sub("", summary, count=1).strip()


def parse_ticket_content(content: str) -> tuple[list[str], dict[str, str], str] | None:
    if not content.startswith("---\n"):
        return None

    parts = content.split("\n---\n", 1)
    if len(parts) != 2:
        return None

    frontmatter_raw = parts[0][4:]
    body = parts[1]

    keys_in_order: list[str] = []
    key_values: dict[str, str] = {}
    for line in frontmatter_raw.splitlines():
        match = re.match(r"^([a-z_]+):\s*(.*)$", line)
        if match:
            key = match.group(1)
            value = match.group(2)
            keys_in_order.append(key)
            key_values[key] = value

    return keys_in_order, key_values, body


def read_ticket_frontmatter(ticket_id: str) -> dict[str, str] | None:
    path = ticket_path_from_id(ticket_id)
    if path is None or not path.exists():
        return None

    parsed = parse_ticket_content(path.read_text(encoding="utf-8"))
    if parsed is None:
        return None

    _, key_values, _ = parsed
    return key_values


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

    parsed_name = parse_ticket_filename(path)
    if parsed_name is None:
        errors.append(
            f"{rel}: invalid filename; expected <TYPE>-{{id}}.md using EPIC, STORY, TASK, SUBTASK, BUG, or OTHER"
        )
        return errors
    filename_prefix, filename_id = parsed_name

    content = path.read_text(encoding="utf-8")
    if not content.startswith("---\n"):
        errors.append(f"{rel}: missing opening frontmatter delimiter")
        return errors
    if content.split("\n---\n", 1) == [content]:
        errors.append(f"{rel}: missing closing frontmatter delimiter")
        return errors

    parsed = parse_ticket_content(content)
    if parsed is None:
        errors.append(f"{rel}: invalid ticket frontmatter structure")
        return errors

    keys_in_order, key_values, body = parsed

    if keys_in_order != REQUIRED_FRONTMATTER_KEYS:
        errors.append(
            f"{rel}: frontmatter key order mismatch; expected {', '.join(REQUIRED_FRONTMATTER_KEYS)}"
        )

    ticket_id = key_values.get("id", "")
    if not ticket_id.isdigit():
        errors.append(f"{rel}: id must be numeric")
    elif ticket_id != filename_id:
        errors.append(f"{rel}: file name id does not match frontmatter id")

    heading_match = re.search(r"^#\s+(.+)$", body, flags=re.MULTILINE)
    if not heading_match:
        errors.append(f"{rel}: missing level-1 summary heading")
    else:
        ticket_type = key_values.get("type", "")
        visible_prefix = ticket_type_to_visible_prefix(ticket_type)
        if visible_prefix is None:
            errors.append(
                f"{rel}: type '{ticket_type}' cannot be converted to a visible ticket identifier"
            )
        elif visible_prefix != filename_prefix:
            errors.append(
                f"{rel}: filename prefix '{filename_prefix}' does not match ticket type '{ticket_type}' "
                f"(expected {visible_prefix}-{ticket_id}.md)"
            )
        elif not re.fullmatch(
            rf"\[{visible_prefix}-{ticket_id}\]\s+.+",
            heading_match.group(1).strip(),
        ):
            errors.append(
                f"{rel}: summary heading must be '# [{visible_prefix}-{ticket_id}] <Summary>'"
            )

    for section in REQUIRED_SECTIONS:
        if section not in body:
            errors.append(f"{rel}: missing required section '{section}'")

    forbidden_child_section = FORBIDDEN_CHILD_SECTION_RE.search(body)
    if forbidden_child_section is not None:
        errors.append(
            f"{rel}: child-ticket sections are forbidden; create separate ticket files instead of a '{forbidden_child_section.group(1)}' heading"
        )

    return errors
