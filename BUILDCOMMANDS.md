# BUILDCOMMANDS — Generar IPA y AAB apuntando a PRE

Comandos para generar los artefactos de release contra **preproducción** (`config_preproduction.json`). Para otro entorno basta cambiar el fichero de config: `config_development.json` (UAT) o `config_production.json` (PRO).

> Atajo: `./build_full_runner.sh` hace todo esto de una vez (clean, pub get, codegen, pod install y los tres artefactos), preguntando el entorno. Este documento desglosa los pasos por si hace falta lanzarlos por separado.

## 0. Requisitos previos

- **Flutter 3.44.0 vía FVM** (`.fvmrc`). Todos los comandos usan `fvm flutter`; sin FVM, usar `flutter` plano con esa misma versión.
- **Android — keystore de release**: debe existir `android/key.properties` (gitignorado) apuntando al keystore. ⚠️ Si falta, el build **NO falla**: `android/app/build.gradle.kts` cae a la firma debug en silencio y Google Play rechaza ese artefacto. Comprobar SIEMPRE antes:

  ```bash
  test -f android/key.properties && echo "OK: keystore configurado" || echo "FALTA android/key.properties — el AAB saldría firmado con DEBUG"
  ```

- **iOS — firma**: firma automática con el team `C4GLV84757` (bundle `es.jccm.espaciociudadano`). Hace falta sesión de Xcode con una cuenta de ese team y CocoaPods instalado.
- **Versión**: la fija `version: X.Y.Z+B` de `pubspec.yaml` (alimenta `versionName`/`versionCode` en Android y `CFBundleShortVersionString`/`CFBundleVersion` en iOS). Si es una release nueva, subir la versión ahí antes de compilar.

## 1. Preparación (una vez por sesión de build)

```bash
fvm flutter clean
fvm flutter pub get

# Solo si se ha tocado el swagger / cliente generado:
cd generated/dart_dio_client && fvm dart run build_runner build --delete-conflicting-outputs && cd ../..

# iOS: refrescar pods (build_full_runner.sh borra antes ios/Pods y ios/Podfile.lock para un rebuild limpio)
cd ios && pod install && cd ..
```

## 2. Android — AAB (PRE)

```bash
fvm flutter build appbundle --release --dart-define-from-file=config_preproduction.json
```

- **Salida**: `build/app/outputs/bundle/release/app-release.aab`
- **Verificar la firma** (que NO sea la clave debug):

  ```bash
  keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab | head -5
  # El "Propietario/Owner" debe ser el certificado de release, nunca "CN=Android Debug"
  ```

Si además se quiere un APK instalable para pruebas directas en dispositivo:

```bash
fvm flutter build apk --release --dart-define-from-file=config_preproduction.json
# Salida: build/app/outputs/flutter-apk/app-release.apk
```

## 3. iOS — IPA (PRE)

```bash
fvm flutter build ipa --release --dart-define-from-file=config_preproduction.json
```

- **Salida**: `build/ios/ipa/*.ipa` (y el archive en `build/ios/archive/Runner.xcarchive`)
- El export method por defecto es **app-store**: el IPA vale para subir a TestFlight/App Store Connect (con Transporter o `xcrun altool`/`xcrun notarytool` según flujo). Para un IPA de instalación directa usar `--export-method ad-hoc`.

## 4. Comprobación rápida del entorno embebido

El entorno queda compilado dentro del binario (no hay flavors nativos): la única fuente es el `--dart-define-from-file` usado. Ante la duda de qué config lleva un artefacto, reconstruir; no hay forma fiable de inspeccionarlo a posteriori. En ejecución, la app de PRE se distingue por el `APP_NAME`/`APP_FLAVOR` del `config_preproduction.json`.
