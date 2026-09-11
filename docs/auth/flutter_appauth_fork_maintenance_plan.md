# Plan de mantenimiento — fork de `flutter_appauth` (Android ephemeral CCT)

**Fecha:** 2026-08-31 · **Diseño:** `flutter_appauth_android_ephemeral_design.md`

## 1. Origen upstream y estrategia de branch

- Upstream: `https://github.com/MaikuB/flutter_appauth` (monorepo con
  `flutter_appauth` y `flutter_appauth_platform_interface`).
- Base del fork: tag `flutter_appauth-v12.1.0` (última estable, 2026-08-29).
  El código Android es idéntico al de la 12.0.0 que hoy usa el proyecto, así que
  basar en 12.1.0 no añade riesgo y deja el fork alineado con upstream.
- Fork Git en la organización (p. ej. `hiberus/flutter_appauth` o el remoto
  corporativo de JCCM — **decisión de equipo**; el código corporativo no debe
  quedar en cuentas personales).
- Ramas:
  - `main` → espejo de upstream master (solo fast-forward, sin commits propios).
  - `jccm/ephemeral-cct` → rama de release del fork: SIEMPRE = tag upstream +
    los ~2 commits propios encima. Nunca merge commits: **rebase**.

## 2. Dependencia en el proyecto

Opción elegida: **dependencia Git por tag** en `pubspec.yaml` (evita publicar
en pub.dev y evita paths locales frágiles):

```yaml
dependencies:
  flutter_appauth:
    git:
      url: <URL del fork corporativo>
      ref: jccm-ephemeral-v12.1.0+1        # tag propio, inmutable
      path: flutter_appauth               # monorepo: subdirectorio del paquete
```

`flutter_appauth_platform_interface` se mantiene el publicado de pub.dev
(el fork no lo toca), pero **con pin exacto** (`12.1.0`, sin caret) en la app:
el fork asume el índice del enum y un upgrade automático del platform_interface
no debe poder cambiarlo sin pasar por el test de CI del §6. Alternativas descartadas: path local (no reproducible en
CI), `dependency_overrides` (enmascara el árbol real), publicar en pub.dev con
otro nombre (coste de naming/soporte sin beneficio).

## 3. Versionado y tagging

- Esquema: `jccm-ephemeral-v<upstream>+<n>` (p. ej. `jccm-ephemeral-v12.1.0+1`).
  El `+n` sube con cada iteración propia sin cambio de base upstream.
- Cada tag es inmutable; el `pubspec.lock` del proyecto ancla además el commit.
- CHANGELOG propio en la raíz del fork (`CHANGELOG_JCCM.md`) con una línea por
  tag: base upstream, diff propio, motivo.

## 4. CI del fork

Pipeline mínimo (GitHub Actions o Jenkins corporativo) en cada push a
`jccm/ephemeral-cct`:

1. `flutter analyze` + `dart format --set-exit-if-changed` (paquete Dart intacto,
   detecta drift accidental).
2. Build Android del example app del propio fork
   (`flutter build apk --debug` en `flutter_appauth/example`) → garantiza que el
   Java compila contra AppAuth 0.11.1 + androidx.browser 1.10.0.
3. Tests unit Android del plugin (los cuatro escenarios de
   `flutter_appauth_android_ephemeral_design.md` §8) con Robolectric.
4. Build iOS del example (sin firma) → garantiza no-regresión iOS.

En el proyecto app, el Jenkinsfile actual ya compila con la dependencia
resuelta; no necesita cambios (la dependencia Git se resuelve en `pub get`).

## 5. Rutina de actualización upstream

Disparador: release upstream nuevo (vigilar con GitHub Watch → Releases).

```bash
git fetch upstream --tags
git checkout jccm/ephemeral-cct
git rebase flutter_appauth-vX.Y.Z          # rebase de los ~2 commits propios
# resolver conflictos (ver §6), correr CI, taggear jccm-ephemeral-vX.Y.Z+1
```

Puntos de conflicto esperables y su resolución:

| Fichero | Riesgo | Nota |
|---|---|---|
| `FlutterAppauthPlugin.java` | MEDIO — es el fichero que upstream toca cuando cambia Android (histórico: pocas veces al año; 12.0.0→12.1.0 = cero cambios) | el diff propio está encapsulado en 2 métodos nuevos + 6 inserciones de una línea; conflictos triviales |
| `android/build.gradle` | BAJO | 2 líneas propias |
| Enum Dart `ExternalUserAgent` | **CRÍTICO de revisar en cada rebase**: el fork asume índice 1 = `ephemeralAsWebAuthenticationSession`. Upstream ha añadido valores solo AL FINAL (12.1.0), pero un reorden lo rompería en silencio | añadir al fork un test Dart que fije `ExternalUserAgent.ephemeralAsWebAuthenticationSession.index == 1` y falle el CI si upstream reordena |

## 6. Tests que protegen el rebase

- El test de índice del enum (§5) — la única suposición inter-paquete del fork.
- Los unit tests Android del §4.3 — protegen la mecánica.
- Smoke manual post-rebase: login efímero en emulador (probe + launch + back).

## 7. Estrategia de PR upstream

1. Abrir issue en MaikuB/flutter_appauth referenciando #387 (cerrado en 2023
   por imposibilidad técnica de entonces) y #668, explicando que androidx.browser
   1.9.0+/Chrome 136+ ya soportan ephemeral CCT, con la evidencia de la POC.
2. Ofrecer PR con la variante upstream-friendly (política explícita
   `disabled|preferred|required` con default `disabled`/`preferred`, para no
   cambiar el comportamiento de apps que ya envían el valor efímero pensando en
   iOS) + tests + doc.
3. Si upstream lo acepta: migrar el proyecto al paquete publicado, borrar el
   fork (el tag del fork queda como histórico), y si la API upstream difiere de
   la del fork, adaptar solo `auth_repository_impl.dart` (una línea) y el mapeo
   del error.
4. Si upstream no responde (precedente: #668 sin respuesta desde 2026-07):
   mantener el fork con la rutina del §5 — coste estimado: minutos por release
   upstream, con CI automatizando la validación.

## 8. Rollback

- El fork es **aditivo y opt-in por valor de enum**: volver al comportamiento
  de serie = volver a `flutter_appauth: ^12.x` en `pubspec.yaml` (una línea).
  La app seguiría compilando sin cambios (el valor efímero vuelve a ser ignorado
  en Android, como hoy).
- Si el error `ephemeral_browsing_unavailable` diera problemas de parque
  inesperados en producción: la app puede degradar por código (capturar y
  reintentar en modo normal con aviso) sin tocar el fork — la política vive en Dart.
- Plan de contingencia mayor (Cl@ve incompatible con CCT efímera en algún
  método, ver investigación §Unknowns): revertir dependencia y reevaluar
  Plan B (WebView con perfil aislado) — documentado en la investigación, no
  implementado deliberadamente.
