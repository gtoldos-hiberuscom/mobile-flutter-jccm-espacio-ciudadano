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
AUDIT_LOG = LOG_DIR / "architecture-audit.jsonl"
ALLOWED_LIB_TOP_LEVEL = {"app", "core", "features", "l10n"}
ALLOWED_FEATURE_LAYERS = {"0_entity", "1_domain", "2_presentation", "3_data"}
BANNED_TOP_LEVEL_DIRS = {"models", "screens", "services", "repositories", "widgets"}
BANNED_TOP_LEVEL_FILES = {"utils.dart", "helpers.dart"}


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


def normalize_path(value: str) -> str:
    return value.replace("\\", "/").lstrip("./")


def validate_architecture_path_string(path_value: str) -> list[str]:
    normalized = normalize_path(path_value)
    if not normalized.startswith("lib/"):
        return []

    errors: list[str] = []
    rel = normalized[4:]
    parts = rel.split("/")
    head = parts[0]

    if head in BANNED_TOP_LEVEL_DIRS:
        errors.append(f"{normalized}: top-level lib/{head} is forbidden by the Flutter canon")

    if len(parts) == 1:
        basename = parts[0]
        if re.fullmatch(r"main(?:_[a-z0-9_]+)?\.dart", basename):
            return errors
        if basename in BANNED_TOP_LEVEL_FILES:
            errors.append(f"{normalized}: catch-all files such as {basename} are forbidden")
        else:
            errors.append(
                f"{normalized}: files under lib/ must live in app/, core/, features/, l10n/, or be main*.dart"
            )
        return errors

    if head not in ALLOWED_LIB_TOP_LEVEL and head not in BANNED_TOP_LEVEL_DIRS:
        errors.append(
            f"{normalized}: top-level lib/ path must be one of app/, core/, features/, or l10n/"
        )

    if head == "features" and len(parts) >= 4:
        layer = parts[2]
        if layer not in ALLOWED_FEATURE_LAYERS:
            errors.append(
                f"{normalized}: feature internals must live under 0_entity/, 1_domain/, 2_presentation/, or 3_data/"
            )

    return errors


def git_changed_dart_files() -> list[pathlib.Path]:
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
        normalized = normalize_path(path_part)
        if normalized.startswith("lib/") and normalized.endswith(".dart"):
            files.append(ROOT / normalized)

    unique: list[pathlib.Path] = []
    seen: set[str] = set()
    for item in files:
        key = str(item)
        if key not in seen:
            seen.add(key)
            unique.append(item)
    return unique


def collect_repo_architecture_issues() -> list[str]:
    issues: list[str] = []
    lib_dir = ROOT / "lib"
    if not lib_dir.exists():
        return issues

    for dirname in sorted(BANNED_TOP_LEVEL_DIRS):
        candidate = lib_dir / dirname
        if candidate.exists():
            issues.append(f"lib/{dirname}: forbidden top-level directory detected")

    for filename in sorted(BANNED_TOP_LEVEL_FILES):
        candidate = lib_dir / filename
        if candidate.exists():
            issues.append(f"lib/{filename}: forbidden catch-all file detected")

    return issues
