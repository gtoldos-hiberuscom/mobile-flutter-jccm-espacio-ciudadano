# Flutter Android CI image

Imagen Linux para los jobs Android de GitLab CI/CD del proyecto.

Incluye:

- Flutter `3.41.7`, alineado con `.fvmrc`.
- Dart incluido en ese SDK de Flutter.
- OpenJDK 17.
- Android SDK command-line tools `14742923`.
- Android platform `android-36`.
- Android build-tools `36.0.0`.
- Android emulator package.
- Ruby, Bundler y Fastlane `2.234.x`.

No cubre iOS: la compilacion iOS debe ejecutarse en un runner macOS con Xcode.

La imagen se construye como `linux/amd64` por defecto, tambien en maquinas
Apple Silicon. El paquete `emulator` del Android SDK no esta disponible para
Linux `arm64`.

## Build local

```sh
docker build \
  -t jccm-espacio-ciudadano/flutter-android-ci:3.41.7 \
  gitlab-ci/docker/flutter-android
```

Para una imagen preparada tambien para crear un AVD dentro del contenedor:

```sh
docker build \
  --build-arg INSTALL_ANDROID_SYSTEM_IMAGE=true \
  -t jccm-espacio-ciudadano/flutter-android-ci:3.41.7-emulator \
  gitlab-ci/docker/flutter-android
```

Esa variante es bastante mas grande; usala solo si el runner ejecutara
`flutter test integration_test` contra emulador Android dentro del contenedor.

## Smoke test local

```sh
docker run --rm \
  -v "$PWD:/workspace" \
  -w /workspace \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7 \
  ci-image-doctor
```

## Uso previsto en GitLab

```yaml
image: registry.gitlab.com/<grupo>/<proyecto>/flutter-android-ci:3.41.7
```

El pipeline debe usar el wrapper Gradle del repositorio (`android/gradlew`) y
las variables CI recomendadas en `Flutter_CI_CD.md`, por ejemplo
`APP_VERSION`, `BUILD_NUMBER`, `FLAVOR` y `ENV_NAME`.
