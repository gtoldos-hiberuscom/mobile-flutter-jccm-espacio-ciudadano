#!/usr/bin/env bash
#
# Regenerates the Dart API client from the OpenAPI contract using openapi-generator.
#
# Prerequisites:
#   brew install openapi-generator
#
# Usage:
#   ./generate_api.sh

set -euo pipefail

SPEC="fachada-sede-api-swagger.yaml"
OUT="generated/dart_dio_client"
PACKAGE_NAME="espacio_ciudadano_api"
PACKAGE_VERSION="0.1.0"

fix_body_param_collisions() {
  local api_dir="$1/lib/src/api"

  if [[ ! -d "$api_dir" ]]; then
    echo "Skipping body-param collision fix: $api_dir does not exist"
    return
  fi

  echo "Fixing generated body parameter/type name collisions..."

  find "$api_dir" -name '*.dart' -print0 | while IFS= read -r -d '' file; do
    perl -0pi -e '
      sub body_name {
        my ($name) = @_;
        my $base = ($name eq uc($name)) ? lc($name) : lcfirst($name);
        return "${base}Body";
      }

      s/\brequired ([A-Z][A-Za-z0-9_]*) \1,/"required $1 ".body_name($1).","/ge;
      s/_serializers\.serialize\(([A-Z][A-Za-z0-9_]*)\, specifiedType: _type\)/"_serializers.serialize(".body_name($1).", specifiedType: _type)"/ge;
    ' "$file"
  done
}

cleanup_generated_api_imports() {
  local api_dir="$1/lib/src/api"

  if [[ ! -d "$api_dir" ]]; then
    echo "Skipping generated import cleanup: $api_dir does not exist"
    return
  fi

  echo "Cleaning duplicated and unused generated imports..."

  find "$api_dir" -name '*.dart' -print0 | while IFS= read -r -d '' file; do
    perl -0pi -e 'my %seen; s{^(import .+\n)}{$seen{$1}++ ? q{} : $1}gme;' "$file"

    if ! rg -q '\bJsonObject\b' "$file"; then
      perl -0pi -e "s@^import 'package:built_value/json_object\\.dart';\\n@@m" "$file"
    fi

    if ! rg -q '\bRespuesta\b' "$file"; then
      perl -0pi -e "s@^import 'package:espacio_ciudadano_api/src/model/respuesta\\.dart';\\n@@m" "$file"
    fi
  done
}

fix_serializer_generics() {
  local serializers_file="$1/lib/src/serializers.dart"

  if [[ ! -f "$serializers_file" ]]; then
    echo "Skipping serializer generic fix: $serializers_file does not exist"
    return
  fi

  echo "Fixing generated serializer generic types..."

  perl -0pi -e 's/MapBuilder<String, BuiltMap>\(\)/MapBuilder<String, BuiltMap<String, Link>>()/' "$serializers_file"
}

echo "Generating Dart client from $SPEC..."

rm -rf "$OUT"

openapi-generator generate \
  --input-spec "$SPEC" \
  --generator-name dart-dio \
  --output "$OUT" \
  --additional-properties=pubName="$PACKAGE_NAME",pubVersion="$PACKAGE_VERSION",pubDescription="JCCM Espacio Ciudadano API client",serializationLibrary=built_value,sourceFolder=src

fix_body_param_collisions "$OUT"
cleanup_generated_api_imports "$OUT"
fix_serializer_generics "$OUT"

echo "Done. Files written to $OUT"
echo "Next steps:"
echo "  cd $OUT"
echo "  dart pub get"
echo "  dart run build_runner build --delete-conflicting-outputs"
