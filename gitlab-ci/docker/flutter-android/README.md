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
- Jenkins LTS con un job inicial `flutter-repo-job`.

No cubre iOS: la compilacion iOS debe ejecutarse en un runner macOS con Xcode.

La imagen se construye como `linux/amd64` por defecto, tambien en maquinas
Apple Silicon. El paquete `emulator` del Android SDK no esta disponible para
Linux `arm64`.

## Build local

Desde la raiz del repositorio:

```sh
docker build \
  -t jccm-espacio-ciudadano/flutter-android-ci:3.41.7 \
  gitlab-ci/docker/flutter-android
```

Si ya estas dentro de `gitlab-ci/docker/flutter-android`:

```sh
docker build \
  -t jccm-espacio-ciudadano/flutter-android-ci:3.41.7 \
  .
```

La imagen deja preconfigurado como repo por defecto el remoto SSH del proyecto:

```txt
git@github.com:gtoldos-hiberuscom/mobile-flutter-jccm-espacio-ciudadano.git
```

Si quieres fijar otro repositorio o rama en la imagen:

```sh
docker build \
  --build-arg JENKINS_DEFAULT_REPO_URL=git@github.com:org/repo.git \
  --build-arg JENKINS_DEFAULT_REPO_BRANCH=feature/cicd \
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

## Jenkins local

Arrancar Jenkins:

```sh
docker run --rm \
  -p 8080:8080 \
  -v jccm-jenkins-home:/var/lib/jenkins \
  -e JENKINS_ADMIN_USER=admin \
  -e JENKINS_ADMIN_PASSWORD=admin \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7
```

Abre `http://localhost:8080` y entra con el usuario configurado. El job
`flutter-repo-job` ya esta creado y acepta estos parametros:

- `REPO_URL`: URL git del repositorio; si queda vacio usa `JENKINS_JOB_REPO_URL`.
- `GIT_BRANCH`: rama a clonar; si queda vacio usa `JENKINS_JOB_BRANCH`.
- `JOB_COMMAND`: comando a ejecutar dentro del repo; por defecto `flutter pub get && flutter test`.
- `GIT_DEPTH`: profundidad del clone; usa `0` para clone completo.

Para un repo privado por SSH, la forma mas directa es pasar una clave por
variable:

```sh
docker run --rm \
  -p 8080:8080 \
  -v jccm-jenkins-home:/var/lib/jenkins \
  -e JENKINS_GIT_SSH_PRIVATE_KEY="$(cat ~/.ssh/id_ed25519)" \
  -e JENKINS_ADMIN_PASSWORD=admin \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7
```

Tambien puedes montar una carpeta `.ssh` ya preparada dentro del home de
Jenkins, siempre que sus permisos permitan lectura al usuario `jenkins` del
contenedor:

```sh
docker run --rm \
  -p 8080:8080 \
  -v jccm-jenkins-home:/var/lib/jenkins \
  -v "$HOME/.ssh:/var/lib/jenkins/.ssh:ro" \
  -e JENKINS_ADMIN_PASSWORD=admin \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7
```

La opcion mas robusta para Docker Desktop es montar una clave privada como
fichero y pasar su ruta:

```sh
docker run --rm \
  -p 8080:8080 \
  -v jccm-jenkins-home:/var/lib/jenkins \
  -v "$HOME/.ssh/jenkins_bitbucket_ed25519:/run/secrets/bitbucket_ssh_key:ro" \
  -e JENKINS_GIT_SSH_PRIVATE_KEY_FILE=/run/secrets/bitbucket_ssh_key \
  -e JENKINS_GIT_KNOWN_HOSTS="$(ssh-keyscan bitbucket.org 2>/dev/null)" \
  -e JENKINS_ADMIN_PASSWORD=admin \
  jccm-espacio-ciudadano/flutter-android-ci:3.41.7
```

Si la clave privada tiene passphrase, añade tambien:

```sh
-e JENKINS_GIT_SSH_PASSPHRASE='tu-passphrase'
```

Para CI suele ser mas simple usar una deploy key dedicada sin passphrase y con
permiso de solo lectura sobre el repositorio.

Importante: los ficheros de `${JENKINS_REF}` se copian a `${JENKINS_HOME}` solo
en el primer arranque de un `JENKINS_HOME` vacio. Si reconstruyes la imagen y
mantienes el volumen `jccm-jenkins-home`, los cambios del job semilla no se
aplican automaticamente. En ese caso:

- elimina el volumen local y recrea Jenkins, o
- actualiza el job manualmente en la UI o editando
  `${JENKINS_HOME}/jobs/flutter-repo-job/config.xml`.

Para comprobar que la clave montada es exactamente la misma que has subido a
Bitbucket, compara su fingerprint:

```sh
ssh-keygen -y -P 'tu-passphrase' -f ~/.ssh/jenkins_bitbucket_ci_ed25519 | ssh-keygen -lf -
```

El fingerprint debe coincidir con la clave publica registrada en `Repository
settings -> Access keys` del repositorio correcto.

## Uso previsto en GitLab

```yaml
image: registry.gitlab.com/<grupo>/<proyecto>/flutter-android-ci:3.41.7
```

El pipeline debe usar el wrapper Gradle del repositorio (`android/gradlew`) y
las variables CI recomendadas en `Flutter_CI_CD.md`, por ejemplo
`APP_VERSION`, `BUILD_NUMBER`, `FLAVOR` y `ENV_NAME`.
