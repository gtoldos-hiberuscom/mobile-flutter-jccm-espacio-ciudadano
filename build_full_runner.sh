
#!/bin/bash

# Salir si ocurre algún error
set -e

echo "🔄 Limpiando proyecto Flutter..."
flutter clean

echo "🗑️ Eliminando Pods y Podfile.lock..."
rm -rf ios/Pods
rm -f ios/Podfile.lock

echo "📦 Ejecutando flutter pub get..."
flutter pub get

echo "📦 Instalando dependencias iOS (pod install)..."
cd ios && pod install && cd ..

echo "🏗️ Ejecutando build_runner..."
cd generated
cd
dart run build_runner build --delete-conflicting-outputs

echo "✅ Proceso completado."
