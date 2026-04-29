#!/usr/bin/env bash
# verify_codegen_drift.sh
# Sprint 7 / STORY-66 — fail-fast detector for drift between the
# OpenAPI source spec and generated/dart_dio_client/.
#
# This is intentionally cheap: it computes a SHA-256 of the spec file
# and compares it against the value pinned in
# generated/dart_dio_client/.codegen-spec-sha256. If the spec changed
# without a regen step, the script exits non-zero so CI / local
# verification flags the drift before any PR lands.
#
# Update the pinned hash by running:
#   shasum -a 256 fachada-sede-api-swagger.yaml | awk '{print $1}' \
#       > generated/dart_dio_client/.codegen-spec-sha256
# and committing the new file alongside the regenerated client.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

SPEC_FILE="fachada-sede-api-swagger.yaml"
PIN_FILE="generated/dart_dio_client/.codegen-spec-sha256"

if [[ ! -f "$SPEC_FILE" ]]; then
  echo "❌ Spec file not found: $SPEC_FILE" >&2
  exit 2
fi

CURRENT_SHA="$(shasum -a 256 "$SPEC_FILE" | awk '{print $1}')"

if [[ ! -f "$PIN_FILE" ]]; then
  echo "ℹ️  No pinned hash yet — creating $PIN_FILE with current value."
  echo "$CURRENT_SHA" > "$PIN_FILE"
  echo "✅ Pinned hash initialised: $CURRENT_SHA"
  exit 0
fi

PINNED_SHA="$(tr -d '[:space:]' < "$PIN_FILE")"

if [[ "$CURRENT_SHA" != "$PINNED_SHA" ]]; then
  cat >&2 <<EOF
❌ Codegen drift detected.

  Spec file : $SPEC_FILE
  Current   : $CURRENT_SHA
  Pinned    : $PINNED_SHA

The OpenAPI spec changed but the generated client was not regenerated.
Run scripts/verify_codegen.sh to regenerate, then re-pin the hash:

  shasum -a 256 $SPEC_FILE | awk '{print \$1}' > $PIN_FILE
  git add $PIN_FILE generated/dart_dio_client/

EOF
  exit 1
fi

echo "✅ Generated client is in sync with $SPEC_FILE ($CURRENT_SHA)."
