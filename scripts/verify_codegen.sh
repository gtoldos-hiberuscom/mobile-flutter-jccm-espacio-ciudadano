#!/usr/bin/env bash
# verify_codegen.sh
# Local parity helper for the CI baseline (STORY-68 / Sprint 2).
# Runs pub get + build_runner and fails if generated files diverge from the working tree.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> flutter pub get"
flutter pub get

echo "==> dart run build_runner build --delete-conflicting-outputs"
dart run build_runner build --delete-conflicting-outputs

echo "==> git diff --exit-code (verifies no uncommitted codegen output)"
git diff --exit-code

echo "Codegen verification OK."
