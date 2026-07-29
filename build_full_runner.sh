#!/bin/bash

# Salir si ocurre algún error
set -e

# --- Selección de entorno ---
echo "🌍 ¿Qué entorno quieres generar?"
echo "  1) uat  (development)"
echo "  2) pre  (preproduccion)"
echo "  3) pro  (production)"
read -r -p "Selecciona [1-3]: " ENV_CHOICE

case "$ENV_CHOICE" in
  1|uat|UAT|development) CONFIG="config_development.json";   ENV_NAME="uat (development)";;
  2|pre|PRE|preproduccion) CONFIG="config_preproduction.json"; ENV_NAME="pre (preproduccion)";;
  3|pro|PRO|production) CONFIG="config_production.json";     ENV_NAME="pro (production)";;
  *) echo "❌ Opción no válida. Usa 1 (uat), 2 (pre) o 3 (pro)."; exit 1;;
esac

echo "✅ Entorno seleccionado: $ENV_NAME  ($CONFIG)"

# --- Comandos de la toolchain (usa FVM si está disponible) ---
if command -v fvm >/dev/null 2>&1; then
  FLUTTER="fvm flutter"
  DART="fvm dart"
else
  FLUTTER="flutter"
  DART="dart"
fi

echo "🔄 Limpiando proyecto Flutter..."
$FLUTTER clean

echo "🗑️ Eliminando Pods y Podfile.lock..."
rm -rf ios/Pods
rm -f ios/Podfile.lock

echo "📦 Ejecutando flutter pub get..."
$FLUTTER pub get

echo "🏗️ Ejecutando build_runner (cliente OpenAPI generado)..."
cd generated/dart_dio_client
$DART run build_runner build --delete-conflicting-outputs
cd ../..

echo "📦 Instalando dependencias iOS (pod install)..."
cd ios && pod install && cd ..

echo "🤖 [Android] Generando App Bundle (release)..."
$FLUTTER build appbundle --release --dart-define-from-file="$CONFIG"

echo "🤖 [Android] Generando APK (release)..."
$FLUTTER build apk --release --dart-define-from-file="$CONFIG"

echo "🍏 [iOS] Generando IPA para TestFlight (App Store)..."
$FLUTTER build ipa --release --dart-define-from-file="$CONFIG"

echo ""
echo "✅ Proceso completado ($ENV_NAME). Artefactos generados:"
echo "   • App Bundle : build/app/outputs/bundle/release/app-release.aab"
echo "   • APK        : build/app/outputs/flutter-apk/app-release.apk"
echo "   • IPA        : build/ios/ipa/*.ipa"
