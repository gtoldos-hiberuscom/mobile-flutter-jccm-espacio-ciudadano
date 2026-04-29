#!/usr/bin/env bash
# bump_version.sh — Sprint 8 closure (STORY-68 / ADR-002 addendum AC3).
#
# Usage:
#   scripts/bump_version.sh [--dry-run] (major|minor|patch|X.Y.Z)
#
# Behaviour:
#   - Reads the current `version: X.Y.Z+B` (or `X.Y.Z`) line from pubspec.yaml.
#   - Computes the new semver based on the argument:
#       * major  → X+1.0.0   (build counter resets to 1)
#       * minor  → X.Y+1.0   (build counter +1)
#       * patch  → X.Y.Z+1   (build counter +1)
#       * X.Y.Z  → explicit semver (build counter +1, or 1 if absent)
#   - Rewrites the `version:` line in pubspec.yaml.
#   - Inserts a `## [X.Y.Z] - YYYY-MM-DD` section in CHANGELOG.md directly
#     under `## [Unreleased]`, leaving the Unreleased section empty above it
#     (Keep a Changelog convention).
#   - Prints the proposed git tag `vX.Y.Z` to stdout.
#
# Notes:
#   - `--dry-run` prints the intended changes without modifying any file.
#   - This script is the canonical mechanism for release version bumps. It is
#     intentionally invoked by humans on the release-window sprint, never by
#     CI on its own.

set -euo pipefail

DRY_RUN=0
ARG=""

for a in "$@"; do
  case "$a" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help)
      sed -n '2,25p' "$0"
      exit 0
      ;;
    *)
      if [ -z "$ARG" ]; then
        ARG="$a"
      else
        echo "ERROR: unexpected extra argument: $a" >&2
        exit 2
      fi
      ;;
  esac
done

if [ -z "$ARG" ]; then
  echo "ERROR: missing argument. Usage: $0 [--dry-run] (major|minor|patch|X.Y.Z)" >&2
  exit 2
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBSPEC="$REPO_ROOT/pubspec.yaml"
CHANGELOG="$REPO_ROOT/CHANGELOG.md"

if [ ! -f "$PUBSPEC" ]; then
  echo "ERROR: pubspec.yaml not found at $PUBSPEC" >&2
  exit 1
fi
if [ ! -f "$CHANGELOG" ]; then
  echo "ERROR: CHANGELOG.md not found at $CHANGELOG" >&2
  exit 1
fi

# Extract current version.
CURRENT_LINE="$(grep -E '^version:[[:space:]]*' "$PUBSPEC" | head -n1 || true)"
if [ -z "$CURRENT_LINE" ]; then
  echo "ERROR: no 'version:' line in pubspec.yaml" >&2
  exit 1
fi
CURRENT_VERSION="$(echo "$CURRENT_LINE" | awk '{print $2}' | tr -d '\r')"

CURRENT_SEMVER="${CURRENT_VERSION%%+*}"
if [ "$CURRENT_VERSION" = "$CURRENT_SEMVER" ]; then
  CURRENT_BUILD=0
else
  CURRENT_BUILD="${CURRENT_VERSION##*+}"
fi

if ! [[ "$CURRENT_SEMVER" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  echo "ERROR: current pubspec version '$CURRENT_VERSION' is not X.Y.Z[+B]" >&2
  exit 1
fi
CUR_MAJOR="${BASH_REMATCH[1]}"
CUR_MINOR="${BASH_REMATCH[2]}"
CUR_PATCH="${BASH_REMATCH[3]}"

case "$ARG" in
  major)
    NEW_MAJOR=$((CUR_MAJOR + 1))
    NEW_SEMVER="${NEW_MAJOR}.0.0"
    NEW_BUILD=1
    ;;
  minor)
    NEW_MINOR=$((CUR_MINOR + 1))
    NEW_SEMVER="${CUR_MAJOR}.${NEW_MINOR}.0"
    NEW_BUILD=$((CURRENT_BUILD + 1))
    ;;
  patch)
    NEW_PATCH=$((CUR_PATCH + 1))
    NEW_SEMVER="${CUR_MAJOR}.${CUR_MINOR}.${NEW_PATCH}"
    NEW_BUILD=$((CURRENT_BUILD + 1))
    ;;
  *)
    if [[ "$ARG" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      NEW_SEMVER="$ARG"
      NEW_BUILD=$((CURRENT_BUILD + 1))
      [ "$NEW_BUILD" -lt 1 ] && NEW_BUILD=1
    else
      echo "ERROR: invalid bump arg '$ARG' (expected major|minor|patch|X.Y.Z)" >&2
      exit 2
    fi
    ;;
esac

NEW_VERSION="${NEW_SEMVER}+${NEW_BUILD}"
NEW_TAG="v${NEW_SEMVER}"
TODAY="$(date -u +%Y-%m-%d)"

echo "current pubspec version : $CURRENT_VERSION"
echo "current semver / build  : $CURRENT_SEMVER / $CURRENT_BUILD"
echo "bump argument           : $ARG"
echo "new pubspec version     : $NEW_VERSION"
echo "new changelog section   : ## [$NEW_SEMVER] - $TODAY"
echo "proposed git tag        : $NEW_TAG"

if [ "$DRY_RUN" -eq 1 ]; then
  echo "(--dry-run set; no files modified)"
  echo "$NEW_TAG"
  exit 0
fi

# Rewrite pubspec.yaml `version:` line.
TMP_PUBSPEC="$(mktemp)"
awk -v new="version: ${NEW_VERSION}" '
  BEGIN { done = 0 }
  /^version:[[:space:]]/ && !done { print new; done = 1; next }
  { print }
' "$PUBSPEC" > "$TMP_PUBSPEC"
mv "$TMP_PUBSPEC" "$PUBSPEC"

# Insert new section into CHANGELOG.md directly under `## [Unreleased]`.
if ! grep -q '^## \[Unreleased\]' "$CHANGELOG"; then
  echo "ERROR: CHANGELOG.md is missing '## [Unreleased]' section" >&2
  exit 1
fi

TMP_CHANGELOG="$(mktemp)"
awk -v section="## [${NEW_SEMVER}] - ${TODAY}" '
  BEGIN { inserted = 0 }
  {
    print
    if (!inserted && $0 ~ /^## \[Unreleased\]/) {
      print ""
      print section
      print ""
      inserted = 1
    }
  }
' "$CHANGELOG" > "$TMP_CHANGELOG"
mv "$TMP_CHANGELOG" "$CHANGELOG"

echo "wrote: $PUBSPEC"
echo "wrote: $CHANGELOG"
echo "$NEW_TAG"
