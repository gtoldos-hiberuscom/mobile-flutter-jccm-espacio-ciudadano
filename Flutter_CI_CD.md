# Informe Generico de Stack Tecnologico y CI/CD Mobile

## Alcance

Este documento describe un stack tecnologico generico para una aplicacion mobile
Flutter con salida Android e iOS, y un flujo CI/CD separado por plataforma. El
contenido se limita a las fases necesarias para compilar, probar, firmar,
empaquetar y publicar.

El objetivo del flujo es cubrir:

- Preparacion de entorno.
- Resolucion de dependencias.
- Generacion de codigo si aplica.
- Tests.
- Build.
- Firma.
- Empaquetado.
- Publicacion interna o a stores.◊
- Publicacion de artifacts.

## 1. Stack Tecnologico Generico

### Base Cross-Platform

| Componente | Version recomendada | Uso |
|---|---:|---|
| Flutter | 3.44.x estable | Framework principal para Android e iOS. |
| Dart | 3.12.x | SDK incluido con Flutter 3.44.x. |
| Pub | Incluido con Dart | Gestor de dependencias Dart/Flutter. |
| Git | Version estable del runner | Checkout, versionado y tags. |
| CI/CD | GitLab CI/CD 19.x, GitHub Actions, Bitrise o Codemagic | Orquestacion del pipeline. |

Recomendacion practica:

- Fijar Flutter en el pipeline, no usar "latest" de forma implicita.
- Mantener el mismo SDK local y en CI.
- Versionar `pubspec.lock` en aplicaciones.
- Usar variables CI para `APP_VERSION`, `BUILD_NUMBER`, `FLAVOR` y entorno.

Ejemplo de variables genericas:

```sh
APP_VERSION=1.4.0
BUILD_NUMBER=${CI_PIPELINE_IID:-100}
FLAVOR=production
ENV_NAME=production
```

### Android

| Componente | Version recomendada | Uso |
|---|---:|---|
| JDK | 17 | JDK requerido por Android Gradle Plugin 9.x. |
| Android Gradle Plugin | 9.2.0 | Build Android moderno. |
| Gradle | 9.4.1 minimo para AGP 9.2; 9.5.1 si se valida compatibilidad | Build system Android. |
| Kotlin | 2.3.21 | Codigo nativo Android y plugins. |
| compileSdk | 36 / 36.1 | SDK de compilacion estable actual. |
| targetSdk | Igual que compileSdk, salvo restriccion de producto | Target Android para Play Store. |
| minSdk | 26+ recomendado | Minimo moderno razonable; ajustar por negocio. |
| Android App Bundle | AAB | Formato recomendado para Google Play. |
| Fastlane | 2.234.x | Automatizacion de subida a Google Play. |

Configuracion Gradle orientativa:

```kotlin
plugins {
    id("com.android.application") version "9.2.0" apply false
    id("org.jetbrains.kotlin.android") version "2.3.21" apply false
}
```

Wrapper Gradle:

```sh
gradle wrapper --gradle-version 9.4.1
```

O, si el proyecto ya valida correctamente Gradle actual:

```sh
gradle wrapper --gradle-version 9.5.1
```

### iOS

| Componente | Version recomendada | Uso |
|---|---:|---|
| macOS runner | macOS compatible con Xcode 26.5 | Compilacion iOS. |
| Xcode | 26.5 | Build, test, simuladores y export IPA. |
| Swift compiler | 6.3 | Incluido con Xcode 26.5. |
| Swift language mode | Swift 5 o Swift 6 | Swift 5 para compatibilidad, Swift 6 para proyectos nuevos preparados. |
| iOS deployment target | 15.0+ | Rango moderno soportado por Xcode 26.5. |
| Swift Package Manager | Recomendado para proyectos nuevos | Gestor nativo Apple. |
| CocoaPods | Opcional/legacy | El proyecto o plugins lo requieren. |
| Fastlane | 2.234.x | Automatizacion de TestFlight/App Store Connect. |
| Ruby | 3.4.x o superior compatible con Fastlane | Runtime para Fastlane/Bundler. |

Recomendacion practica:

- En proyectos Flutter modernos, preferir Swift Package Manager cuando sea
  viable.
- Mantener CocoaPods solo si dependencias concretas lo requieren.
- Versionar `Gemfile` y `Gemfile.lock` si se usa Fastlane.
- Usar App Store Connect API Key en CI para evitar sesiones interactivas.


## 2. Flujo CI/CD Android

### Resumen de stages Android

1. Preparar runner.
2. Resolver dependencias Flutter.
3. Generar codigo y recursos.
4. Ejecutar tests Flutter.
5. Ejecutar tests Android opcionales.
6. Construir AAB release.
7. Recoger artifacts.
8. Publicar artifact interno.
9. Subir a Google Play internal testing.

### 2.1 Preparar runner Android

Objetivo:

- Asegurar que el runner tiene Flutter, JDK, Android SDK y Gradle disponibles.
- Seleccionar una version reproducible del SDK.

Comandos:

```sh
flutter --version
dart --version
java -version
./gradlew --version
```

Si el runner instala SDKs dinamicamente:

```sh
sdkmanager --install \
  "platform-tools" \
  "platforms;android-36" \
  "build-tools;36.0.0"
```

Variables habituales:

```sh
export JAVA_HOME="$JDK_17_HOME"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
```

### 2.2 Resolver dependencias Flutter

Objetivo:

- Descargar dependencias Dart/Flutter.
- Validar que `pubspec.lock` es resoluble.

Comando:

```sh
flutter pub get
```

Artifact/cache recomendado:

- `.pub-cache`.
- `.dart_tool`.
- `pubspec.lock`.

### 2.3 Generar codigo y recursos

Objetivo:

- Generar codigo derivado antes de test/build.
- Aplica a proyectos con `build_runner`, mocks, freezed, json serializable,
  pigeon, localizaciones o recursos generados.

Comandos habituales:

```sh
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

Si el proyecto no usa generacion, esta fase puede omitirse.
Es posible que durante el proyecto identifiquemos otros puntos de generación, en principio estos son suficientes. 

### 2.4 Ejecutar tests Flutter

Objetivo:

- Ejecutar tests unitarios y de widgets.
- Generar cobertura si se desea publicar como artifact.

Comandos:

```sh
flutter test --coverage
```

Para separar resultados en maquina/CI:

```sh
flutter test --machine > build/test-results/flutter-tests.json
```

Artifacts recomendados:

- `coverage/lcov.info`.
- `build/test-results`.

### 2.5 Ejecutar integration tests Android

Objetivo:

- Levantar emulador Android.
- Ejecutar tests de integracion en dispositivo/emulador.

Crear AVD si el runner no lo trae preparado:

```sh
sdkmanager --install "system-images;android-36;google_apis;x86_64"
avdmanager create avd \
  --name ci_android \
  --package "system-images;android-36;google_apis;x86_64" \
  --device pixel
```

Arrancar emulador:

```sh
emulator -avd ci_android -no-window -no-audio -gpu swiftshader_indirect &
adb wait-for-device
adb shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done'
```

Ejecutar tests:

```sh
flutter test integration_test -d emulator-5554
```

Parar emulador:

```sh
adb -e emu kill
```

### 2.6 Ejecutar tests nativos Android opcionales (Por ahora saltamos esta fase)

Objetivo:

- Ejecutar tests JVM e instrumentados nativos si el proyecto tiene codigo Kotlin
  o Java propio. 

Comandos:

```sh
cd android
./gradlew testProductionDebugUnitTest
./gradlew connectedProductionDebugAndroidTest
cd ..
```

Si no hay flavors, usar tareas equivalentes:

```sh
cd android
./gradlew testDebugUnitTest
./gradlew connectedDebugAndroidTest
cd ..
```

### 2.7 Construir AAB release

Objetivo:

- Generar binario release para Google Play.
- Inyectar version, build number, flavor y variables de entorno.
- Generar symbols para trazabilidad de crashes si se usa obfuscacion.

Comando recomendado:

```sh
flutter build appbundle \
  --release \
  --flavor "$FLAVOR" \
  --dart-define=env="$ENV_NAME" \
  --build-name="$APP_VERSION" \
  --build-number="$BUILD_NUMBER" \
  --obfuscate \
  --split-debug-info=build/android-symbols
```

Salida habitual:

```text
build/app/outputs/bundle/<flavor>Release/app-<flavor>-release.aab
```

Para generar APK de distribucion interna no Play Store:

```sh
flutter build apk \
  --release \
  --flavor "$FLAVOR" \
  --dart-define=env="$ENV_NAME" \
  --build-name="$APP_VERSION" \
  --build-number="$BUILD_NUMBER"
```

### 2.8 Recoger artifacts Android

Objetivo:

- Guardar binarios y symbols para descarga, auditoria de release y debug.

Comandos:

```sh
mkdir -p build/ci-artifacts/android
cp build/app/outputs/bundle/"${FLAVOR}Release"/app-"${FLAVOR}"-release.aab \
  build/ci-artifacts/android/app-release.aab
cp -R build/android-symbols build/ci-artifacts/android/symbols
```

Artifacts recomendados:

- `app-release.aab`.
- `mapping.txt`, si R8 lo genera.
- `build/android-symbols`.
- APK opcional para QA.

### 2.9 Publicar artifact interno

Objetivo:

- Publicar el AAB/APK en el sistema de artifacts del CI.
- Permitir descarga por QA o por el job de deploy.

Comando generico:

```sh
tar -czf android-release-artifacts.tar.gz build/ci-artifacts/android
```

En GitLab, por ejemplo, el pipeline puede declarar esos paths como `artifacts`.
En GitHub Actions, se usaria `actions/upload-artifact`.

### 2.10 Subir a Google Play internal testing

Objetivo:

- Subir AAB firmado a Google Play.
- Publicarlo en track interno para QA.

Lane Fastlane orientativa:

```ruby
platform :android do
  desc "Upload Android release to internal testing"
  lane :internal do
    upload_to_play_store(
      track: "internal",
      release_status: "draft",
      aab: ENV.fetch("ANDROID_AAB_PATH"),
      package_name: ENV.fetch("ANDROID_PACKAGE_NAME"),
      json_key_data: ENV.fetch("GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"),
      skip_upload_apk: true,
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end
end
```

Comandos CI:

```sh
export ANDROID_AAB_PATH="build/ci-artifacts/android/app-release.aab"
bundle exec fastlane android internal
```

Regla habitual:

- Ejecutar automaticamente en ramas `release/*`, o manualmente desde tags.

## 3. Flujo CI/CD iOS

### Resumen de stages iOS

1. Preparar runner macOS.
2. Resolver dependencias Flutter.
3. Resolver dependencias iOS.
4. Generar codigo y recursos.
5. Ejecutar tests Flutter.
6. Ejecutar integration tests iOS.
7. Ejecutar tests nativos iOS opcionales.
8. Preparar firma.
9. Construir IPA release.
10. Recoger artifacts.
11. Publicar artifact interno.
12. Subir a TestFlight.

### 3.1 Preparar runner macOS

Objetivo:

- Seleccionar Xcode.
- Verificar Flutter, Dart, Xcode y simuladores.

Comandos:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcodebuild -version
xcrun simctl list devices available
flutter --version
dart --version
```

Variables habituales:

```sh
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
export FLUTTER_SUPPRESS_ANALYTICS=true
```

### 3.2 Resolver dependencias Flutter

Objetivo:

- Descargar dependencias Dart/Flutter.
- Preparar `.dart_tool`.

Comando:

```sh
flutter pub get
```

### 3.3 Resolver dependencias iOS

Objetivo:

- Resolver dependencias nativas iOS.
- En proyectos modernos, Flutter puede usar Swift Package Manager.
- En proyectos legacy, puede seguir siendo necesario CocoaPods.

Con Swift Package Manager, normalmente basta con:

```sh
flutter pub get
```

Si el proyecto usa CocoaPods:

```sh
cd ios
bundle exec pod install --repo-update
cd ..
```

Si no se versiona Bundler:

```sh
cd ios
pod install --repo-update
cd ..
```

### 3.4 Generar codigo y recursos

Objetivo:

- Generar codigo previo al build.
- Aplicable a `build_runner`, Pigeon, localizaciones o assets generados.

Comandos:

```sh
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### 3.5 Ejecutar tests Flutter

Objetivo:

- Ejecutar unit/widget tests compartidos.

Comandos:

```sh
flutter test --coverage
```

Salida recomendada:

- `coverage/lcov.info`.
- Resultados de test en carpeta de artifacts.

### 3.6 Ejecutar integration tests iOS

Objetivo:

- Bootear simulador iOS.
- Ejecutar tests de integracion Flutter.

Variables:

```sh
IOS_SIMULATOR_NAME="iPhone 16"
```

Arranque de simulador:

```sh
xcrun simctl boot "$IOS_SIMULATOR_NAME" || true
xcrun simctl bootstatus "$IOS_SIMULATOR_NAME" -b
```

Ejecucion:

```sh
flutter test integration_test -d "$IOS_SIMULATOR_NAME"
```

Parada:

```sh
xcrun simctl shutdown "$IOS_SIMULATOR_NAME" || true
```

### 3.7 Ejecutar tests nativos iOS opcionales (Por ahora saltamos esta fase)

Objetivo:

- Ejecutar tests XCTest si el proyecto contiene codigo Swift/Objective-C nativo.

Comando con workspace:

```sh
xcodebuild test \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -destination "platform=iOS Simulator,name=$IOS_SIMULATOR_NAME" \
  -enableCodeCoverage YES \
  -resultBundlePath build/ios-test-results/TestResult.xcresult
```

Comando con project, si no hay workspace:

```sh
xcodebuild test \
  -project ios/Runner.xcodeproj \
  -scheme Runner \
  -destination "platform=iOS Simulator,name=$IOS_SIMULATOR_NAME"
```

### 3.8 Preparar firma iOS

Objetivo:

- Instalar certificados y provisioning profiles.
- Preparar export options.
- Evitar prompts interactivos.

Opcion con Fastlane Match:

```sh
bundle exec fastlane match appstore --readonly
```

Opcion con certificados/profiles inyectados por CI:

```sh
security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
security import "$IOS_CERTIFICATE_P12" \
  -k build.keychain \
  -P "$IOS_CERTIFICATE_PASSWORD" \
  -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "$IOS_PROVISIONING_PROFILE" ~/Library/MobileDevice/Provisioning\ Profiles/
```

### 3.9 Construir IPA release

Objetivo:

- Generar IPA firmada para TestFlight/App Store Connect.
- Inyectar flavor, version y build number.
- Generar symbols si se usa obfuscacion.

Comando recomendado:

```sh
flutter build ipa \
  --release \
  --flavor "$FLAVOR" \
  --dart-define=env="$ENV_NAME" \
  --build-name="$APP_VERSION" \
  --build-number="$BUILD_NUMBER" \
  --export-options-plist=ios/ExportOptions.plist \
  --obfuscate \
  --split-debug-info=build/ios-symbols
```

Salida habitual:

```text
build/ios/ipa/*.ipa
```

### 3.10 Recoger artifacts iOS

Objetivo:

- Guardar IPA, dSYMs y symbols.

Comandos:

```sh
mkdir -p build/ci-artifacts/ios
cp build/ios/ipa/*.ipa build/ci-artifacts/ios/app-release.ipa
cp -R build/ios/archive/*.xcarchive/dSYMs build/ci-artifacts/ios/dSYMs || true
cp -R build/ios-symbols build/ci-artifacts/ios/symbols
```

Artifacts recomendados:

- `app-release.ipa`.
- `dSYMs`.
- `build/ios-symbols`.
- `ExportOptions.plist` usado en la build.

### 3.11 Publicar artifact interno

Objetivo:

- Permitir descarga del IPA por QA o por un job posterior de deploy.

Comando generico:

```sh
tar -czf ios-release-artifacts.tar.gz build/ci-artifacts/ios
```

### 3.12 Subir a TestFlight

Objetivo:

- Subir IPA a App Store Connect.
- Dejar build disponible en TestFlight.

Lane Fastlane orientativa:

```ruby
platform :ios do
  desc "Upload iOS release to TestFlight"
  lane :beta do
    app_store_connect_api_key(
      key_id: ENV.fetch("APP_STORE_CONNECT_KEY_ID"),
      issuer_id: ENV.fetch("APP_STORE_CONNECT_ISSUER_ID"),
      key_content: ENV.fetch("APP_STORE_CONNECT_API_KEY_P8")
    )

    upload_to_testflight(
      ipa: ENV.fetch("IOS_IPA_PATH"),
      skip_waiting_for_build_processing: true
    )
  end
end
```

Comandos CI:

```sh
export IOS_IPA_PATH="build/ci-artifacts/ios/app-release.ipa"
bundle exec fastlane ios beta
```

Regla habitual:

- Ejecutar manualmente desde tags.
- Ejecutar automaticamente en ramas `release/*` si el proceso de QA lo permite.

## 4. Orden Recomendado de Pipeline

### Android

```text
android_prepare
android_codegen
android_test
android_integration_test
android_build
android_package
android_deploy_internal
```

### iOS

```text
ios_prepare
ios_codegen
ios_test
ios_integration_test
ios_signing
ios_build
ios_package
ios_deploy_testflight
```

## 5. Variables CI Recomendadas

Esta es una propuesta inicial, como punto de partida, para ajustar a posteriori.

### Comunes◊

```sh
APP_VERSION=1.4.0◊
BUILD_NUMBER=123
FLAVOR=production
ENV_NAME=production
```

### Android

```sh
ANDROID_PACKAGE_NAME=com.company.app
ANDROID_AAB_PATH=build/ci-artifacts/android/app-release.aab
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON=<json>
```

### iOS

```sh
IOS_BUNDLE_ID=com.company.app
IOS_IPA_PATH=build/ci-artifacts/ios/app-release.ipa
APP_STORE_CONNECT_KEY_ID=<key_id>
APP_STORE_CONNECT_ISSUER_ID=<issuer_id>
APP_STORE_CONNECT_API_KEY_P8=<private_key>
```

## 6. Convenciones de Artifacts

### Android

```text
build/ci-artifacts/android/app-release.aab
build/ci-artifacts/android/app-release.apk
build/ci-artifacts/android/symbols/
build/ci-artifacts/android/mapping.txt
```

### iOS

```text
build/ci-artifacts/ios/app-release.ipa
build/ci-artifacts/ios/dSYMs/
build/ci-artifacts/ios/symbols/
```

## 7. Recomendaciones Practicas

- Usar AAB para Google Play; reservar APK para QA o distribucion interna.
- Usar IPA firmada para TestFlight.
- Separar jobs Android e iOS porque iOS requiere runner macOS.
- Fijar versiones de Flutter, Xcode, AGP, Gradle, Kotlin y Fastlane.
- Mantener Fastlane versionado con `Gemfile` y `Gemfile.lock`.
- Usar `--build-name` y `--build-number` desde variables CI.
- Generar artifacts antes de desplegar; el deploy debe consumir artifacts, no
  reconstruir.
- Mantener secrets fuera del repositorio y pasarlos por variables protegidas del
  CI.

## 8. Fuentes 

- Flutter release notes: https://docs.flutter.dev/release/release-notes
- Flutter SDK archive: https://docs.flutter.dev/install/archive
- Dart 3.12 announcement: https://dart.dev/blog/announcing-dart-3-12
- Android Gradle Plugin: https://developer.android.com/build/releases/about-agp
- Android Java/JDK builds: https://developer.android.com/build/jdks
- Gradle current release: https://services.gradle.org/versions/current
- Kotlin releases: https://github.com/JetBrains/kotlin/releases
- Xcode support matrix: https://developer.apple.com/support/xcode/
- Fastlane releases: https://github.com/fastlane/fastlane/releases
- GitLab release schedule: https://handbook.gitlab.com/handbook/engineering/releases/monthly-releases/
