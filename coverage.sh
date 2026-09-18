#!/usr/bin/env bash
#
# Runs the full test suite with coverage and builds the HTML report.
#
# Two corrections over a plain `flutter test --coverage`:
#
#   1. Flutter only instruments libraries that some test imports, so a file no
#      test touches is *absent* from the tracefile instead of counting as 0%,
#      which inflates the percentage. A throwaway helper importing every file
#      under lib/ forces full instrumentation; it is deleted on exit.
#   2. lib/l10n/app_localizations*.dart is generated code (~3k lines of string
#      getters). It is filtered out so the number reflects hand-written code.
#      Use --include-generated to keep it.
#
# Prerequisites:
#   brew install lcov        # provides lcov and genhtml
#
# Usage:
#   ./coverage.sh                      # tests + filtered tracefile + HTML report
#   ./coverage.sh --open               # ...and open the report in the browser
#   ./coverage.sh --no-html            # tracefiles only (skips genhtml)
#   ./coverage.sh --include-generated  # report generated l10n too
#   ./coverage.sh --no-test            # re-report from the existing lcov.info

set -euo pipefail

cd "$(dirname "$0")"

COVERAGE_DIR="coverage"
RAW_INFO="$COVERAGE_DIR/lcov.info"
FILTERED_INFO="$COVERAGE_DIR/lcov_filtered.info"
HTML_DIR="$COVERAGE_DIR/html"
HELPER="test/zz_coverage_helper_test.dart"
GENERATED_PATTERNS=('lib/l10n/app_localizations*.dart')

RUN_TESTS=true
BUILD_HTML=true
OPEN_HTML=false
INCLUDE_GENERATED=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --open) OPEN_HTML=true;;
    --no-html) BUILD_HTML=false;;
    --include-generated) INCLUDE_GENERATED=true;;
    --no-test) RUN_TESTS=false;;
    -h|--help) sed -n '3,23p' "$0"; exit 0;;
    *) echo "❌ Opción no reconocida: $1 (usa --help)"; exit 1;;
  esac
  shift
done

# --- Toolchain (use FVM when available, as the rest of the scripts do) ---
if command -v fvm >/dev/null 2>&1; then
  FLUTTER="fvm flutter"
else
  FLUTTER="flutter"
fi

if ! command -v lcov >/dev/null 2>&1; then
  echo "❌ Falta lcov. Instálalo con: brew install lcov"
  exit 1
fi

# The helper is a build artefact, never a committed test: drop it whatever happens.
cleanup() { rm -f "$HELPER"; }
trap cleanup EXIT

if [[ "$RUN_TESTS" == true ]]; then
  echo "🧪 Generando helper de instrumentación ($HELPER)..."
  {
    echo "// GENERADO POR coverage.sh — NO COMMITEAR."
    echo "//"
    echo "// Importa todo lib/ para que flutter test --coverage instrumente también"
    echo "// los ficheros que ningún test toca, y cuenten como 0% en vez de faltar."
    echo "// ignore_for_file: unused_import, directives_ordering"
    echo
    find lib -name '*.dart' | sort | sed "s|^lib/|import 'package:jccm_espacio_ciudadano/|; s|\$|';|"
    echo
    echo "void main() {}"
  } > "$HELPER"

  echo "🧪 Ejecutando la suite completa con cobertura..."
  $FLUTTER test --coverage
  cleanup
fi

if [[ ! -f "$RAW_INFO" ]]; then
  echo "❌ No existe $RAW_INFO. Lanza el script sin --no-test."
  exit 1
fi

# --- Tracefile that feeds the report ---
if [[ "$INCLUDE_GENERATED" == true ]]; then
  REPORT_INFO="$RAW_INFO"
else
  echo "🧹 Filtrando código generado del informe..."
  lcov --remove "$RAW_INFO" "${GENERATED_PATTERNS[@]}" \
    --output-file "$FILTERED_INFO" \
    --ignore-errors unused >/dev/null
  REPORT_INFO="$FILTERED_INFO"
fi

# --- Per-file data: <path> <lines> <hit>, paths normalised to lib/... ---
PER_FILE="$(mktemp)"
trap 'cleanup; rm -f "$PER_FILE"' EXIT
awk -F: '
  /^SF:/ { f = substr($0, 4); sub(/^.*\/lib\//, "lib/", f) }
  /^LF:/ { lf = $2 }
  /^LH:/ { print f "\t" lf "\t" $2 }
' "$REPORT_INFO" > "$PER_FILE"

if [[ "$BUILD_HTML" == true ]]; then
  if ! command -v genhtml >/dev/null 2>&1; then
    echo "⚠️  genhtml no está disponible; se omite el informe HTML."
    BUILD_HTML=false
  else
    echo "📊 Generando informe HTML..."
    rm -rf "$HTML_DIR"
    genhtml "$REPORT_INFO" \
      --output-directory "$HTML_DIR" \
      --title "Carpeta Ciudadana CLM — cobertura" \
      --legend --show-details \
      --ignore-errors unmapped,inconsistent,category >/dev/null
  fi
fi

# --- Summary ---
echo
echo "════════ COBERTURA ════════"
awk -F'\t' '{ lf += $2; lh += $3 }
  END { printf "TOTAL  %.1f%%  (%d/%d líneas, %d ficheros)\n", (lf ? 100*lh/lf : 0), lh, lf, NR }' "$PER_FILE"
[[ "$INCLUDE_GENERATED" == true ]] && echo "(incluye el l10n generado)" || echo "(excluye el l10n generado)"

echo
echo "── Por capa (features/*/N_capa) ──"
awk -F'\t' '$1 ~ /^lib\/features\// {
    split($1, p, "/"); c = p[4]
    if (c ~ /^[0-9]_/) { lf[c] += $2; lh[c] += $3 }
  }
  END { for (k in lf) printf "%6.1f%%  %5d/%-5d  %s\n", 100*lh[k]/lf[k], lh[k], lf[k], k }' "$PER_FILE" | sort -n

echo
echo "── Por módulo ──"
awk -F'\t' '{
    split($1, p, "/")
    k = (p[2] == "features" || p[2] == "core") ? p[2] "/" p[3] : p[2]
    lf[k] += $2; lh[k] += $3
  }
  END { for (k in lf) printf "%6.1f%%  %5d/%-5d  %s\n", (lf[k] ? 100*lh[k]/lf[k] : 0), lh[k], lf[k], k }' "$PER_FILE" | sort -n

echo
echo "── 10 ficheros con más líneas sin cubrir ──"
awk -F'\t' '{ printf "%5d sin cubrir  %5.1f%%  %s\n", $2-$3, ($2 ? 100*$3/$2 : 0), $1 }' "$PER_FILE" | sort -rn | awk 'NR <= 10'

echo
echo "✅ Listo. Salida en $COVERAGE_DIR/ (ignorado por git):"
echo "   • Tracefile crudo   : $RAW_INFO"
if [[ "$INCLUDE_GENERATED" == false ]]; then echo "   • Tracefile filtrado: $FILTERED_INFO"; fi
if [[ "$BUILD_HTML" == true ]]; then echo "   • Informe HTML      : $HTML_DIR/index.html"; fi

if [[ "$OPEN_HTML" == true && "$BUILD_HTML" == true ]]; then
  open "$HTML_DIR/index.html"
fi
