# Auditoría técnica del repositorio — `jccm_espacio_ciudadano`

**Fecha:** 2026-07-22 · **Rama auditada:** `feature/JCCMEC-5-Shell-global` (HEAD `d0ee162`, working tree limpio salvo este informe) · **Método:** verificación por ejecución (analyze, custom_lint, format, tests, build APK release + iOS sin firma, inspección del artefacto con apksigner/aapt2) + 5 análisis paralelos por área con agentes independientes + verificación adversarial de los hallazgos graves, incluida la **re-reproducción empírica del deadlock de red en un harness aislado**.

> Este informe **sustituye** al `REPOSITORY_AUDIT.md` del 2026-07-21 (rama `feature/JCCMEC-10-Login-Clave`). Todos los hallazgos de aquel informe han sido re-verificados contra el estado actual; se conservan sus identificadores `F-nn` para trazabilidad y se añaden `N-nn` para los nuevos.

---

## 1. Veredicto ejecutivo

### Clasificación de preparación para release: **APTO PARA QA CON BLOQUEOS CONOCIDOS**

La app compila en ambas plataformas, el análisis estático está limpio (1 warning) y los 84 tests pasan. Desde la auditoría de ayer se corrigieron 3 cosas (permiso `INTERNET` — verificado dentro del APK release —, el provider keep-alive de hechos vitales, y la descripción de fotos en iOS), pero **el commit de hoy `c82d431` ha empeorado el defecto de runtime más grave**: el deadlock del interceptor de refresh sigue presente (re-reproducido hoy: `TIMEOUT-DEADLOCK`, cola de errores envenenada para toda petición posterior que falle) y el cambio `refresh(force:true)` → `refresh()` convierte un escenario que antes era un logout limpio (sesión revocada en Keycloak) en un **detonante directo del cuelgue permanente**. Además ese mismo commit dejó commiteado `kVerboseNetworkLogging = true`, que activa el volcado curl con `Authorization: Bearer` **sin redacción** en cada petición (solo debug/profile), y el `pubspec.lock` degradado que el informe anterior advertía no commitear entró en `c3b09f8`.

| Severidad | Nº | Detalle |
|---|---|---|
| **BLOCKER** | 2 | applicationId/bundleId `com.example.*` en ambas plataformas; release Android firmado con claves debug (verificado en el artefacto: `CN=Android Debug`) y sin infraestructura de firma |
| **CRITICAL** | 2 | Deadlock del `AuthRefreshInterceptor` (re-reproducido hoy); regresión commiteada `refresh()` sin `force` que lo detona ante sesión revocada |
| **HIGH** | 13 | Errores de backend mostrados como "sin datos" (9 repos); crash por `state.extra!` en el router; sesión zombi tras logout (refresh en vuelo re-persiste tokens); pantalla simulada (ofertas de empleo); "demanda ACTIVA" fabricada; notificaciones sin detalle/comparecencia; `registrarfichero` sin validar contra UAT; onboarding inalcanzable; doble registro por doble tap; purga de tests (434→84) + CI sin tests + 0 widget/integración; `build_full_runner.sh` roto; `.fvm` roto commiteado; `android:label` técnico visible al usuario |
| **MEDIUM** | ~28 | Logging (curl sin redactar activado, DNI en logs y como clave de prefs, silenciado release solo implícito); biometría decorativa; sin FLAG_SECURE; shell sin estado entre pestañas ni back Android; ~90–208 cadenas ES hardcodeadas fuera de ARB con EN ofrecido; tab bar sin semántica; texto legal sin escalado de fuente; logout mudo ante cláusula nueva; gates de consentimiento que confunden error con "no autorizado"; NIF hardcodeado (rompe NIE); idToken no persistido; 412.00 solo en 1 de 5 páginas; captcha decorativo; lock degradado commiteado; sin flavors ni versionado; PrivacyInfo.xcprivacy ausente; deps muertas; 119 claves EN sin traducir… |
| **LOW / INFO** | ~25 | Código muerto (connectivity, sweep, rutas fantasma, barrels), formato (9 ficheros), taskAffinity, iconos legacy, docs obsoletas… |

### Las cinco decisiones más importantes

1. **Arreglar la capa de refresh de red antes de cualquier QA de sesión, y con más urgencia que ayer.** F-04 (deadlock) sigue intacto y F-05 quedó commiteado en su variante peligrosa: hoy, una sesión revocada en Keycloak, un reloj desajustado o cualquier fallo del reintento tras un 401 congela esa petición para siempre y envenena la cola de errores de toda la app. Ayer ese mismo escenario terminaba en un logout limpio. Es un cambio pequeño (Dio secundario para el retry + comparación de tokens o `force:true` condicionado) con test unitario posible.
2. **No distribuir ningún artefacto actual.** El APK release generado hoy está firmado con `CN=Android Debug` y empaquetado como `com.example.jccm_espacio_ciudadano` `versionCode=1` (verificado con apksigner/aapt2). Decidir el id definitivo (inmutable tras publicar), crear el keystore y cablearlo en Jenkins.
3. **Decidir qué hacer con la funcionalidad que aparenta estar terminada y no lo está** (sin cambios desde ayer): ofertas de empleo devuelve lista vacía hardcodeada, las notificaciones no se pueden abrir ni comparecer, el paso final de aportación documental nunca ha funcionado contra UAT según los comentarios del propio código, y el onboarding de hechos vitales es inalcanzable.
4. **Arreglar el patrón sistémico "error de backend → pantalla 'sin datos'"** en los 9 repositorios de lectura (sin cambios desde ayer): una caída del SESCAM se muestra al ciudadano como "no tienes citas"; una caída de familia numerosa, como "no tienes título".
5. **Cerrar la deuda de la propia rama Shell-global antes de su QA**: pérdida de estado y recargas de red en cada cambio de pestaña (`ShellRoute` sin `StatefulShellRoute`), back físico de Android que sale de la app, labels del tab bar y ~90–208 cadenas más hardcodeadas en español fuera de ARB (con `Locale('en')` ofrecido), y tab bar principal sin semántica de accesibilidad — relevante para una app de administración pública con compromiso WCAG declarado en su propio código.

**Lectura ejecutiva:** el diagnóstico global no ha cambiado desde ayer — el cuerpo de la app está bien construido y lo que falta es la configuración de release, un defecto crítico de red y un conjunto acotado de funcionalidades simuladas o desconectadas — pero la dirección del último día es mixta: se corrigieron 3 hallazgos (uno de ellos bloqueante) y a la vez se commiteó una regresión que agrava el defecto crítico, un flag de logging que no debía quedar activado y un lockfile degradado. La rama nueva (shell global) añade además deuda propia de i18n/accesibilidad/estado que conviene atajar antes de validar el shell.

---

## 2. Alcance y limitaciones

**Analizado:** la totalidad de `lib/` (303 ficheros Dart, 13 features + core), `test/` (20 ficheros), `integration_test/` (vacío), `android/`, `ios/` (incl. Podfile.lock y podspecs en pub-cache), `generated/dart_dio_client`, los 3 `config_*.json`, `pubspec.yaml/lock`, `analysis_options.yaml`, `dart_test.yaml`, `Jenkinsfile`, `gitlab-ci/`, scripts (`build_full_runner.sh`, `generate_api.sh`), documentación (`README`, `CHANGELOG`, `documentation/`, CLAUDE.md), historial de git (incluido `git log -L` de los cambios de hoy) y el swagger `fachada-sede-api-swagger.yaml`. Se re-verificó individualmente cada hallazgo BLOCKER/CRITICAL/HIGH del informe del 21-07 contra el árbol actual.

**Ejecutado:** `flutter pub get`, `flutter analyze`, `dart run custom_lint`, `dart format --set-exit-if-changed`, `flutter test` (+ tag performance), `flutter pub outdated`, `flutter build apk --release`, `flutter build ios --no-codesign`, `apksigner verify --print-certs` y `aapt2 dump badging` sobre el APK generado, y un **harness aislado de reproducción del deadlock** (dart + dio 5.9.2, adapter falso 401→500) en un directorio temporal fuera del repo.

**Limitaciones del entorno (idénticas a ayer):**
- Sin dispositivo físico ni backend UAT accesible: no se pudo validar el flujo Cl@ve real, `registrarfichero` contra UAT, la config del cliente Keycloak, ni el logcat de un build release en dispositivo.
- Sin acceso al Apple Developer Portal: titularidad del `DEVELOPMENT_TEAM 494UN8AR7S` no verificable.
- Los tests con tag `backend` requieren backend real… y no existe ninguno (tags muertos, verificado por ejecución y grep).

**Novedad resuelta:** los SDK efectivos de Android ya no son una incógnita — verificados en el artefacto y en el SDK de Flutter 3.41.7: **minSdk 24, targetSdk 36, compileSdk 36** (cumple los requisitos actuales de Play), y **minify/R8 + shrinkResources vienen activados por defecto** por el plugin Gradle de Flutter (refuta el hallazgo LOW "sin minify" del informe anterior).

---

## 3. Estado de compilación y pruebas

Todas las ejecuciones de hoy con FVM Flutter 3.41.7 / Dart 3.11.5 (coincide con `.fvmrc`).

| Comando | Resultado | Duración | Evidencia / interpretación |
|---|---|---|---|
| `fvm flutter pub get` | ✅ OK | — | Resuelve; aviso gen_l10n: **"en": 119 untranslated message(s)** (evidencia F-32 por ejecución) |
| `fvm flutter analyze` | ⚠️ 10 issues (9 info, 1 warning) | 9,9 s | Único warning: `unused_element_parameter` en `gestion_page.dart:128`. Sin errores |
| `fvm dart run custom_lint` | ✅ "No issues found!" | 2,0 s | riverpod_lint sin hallazgos |
| `fvm dart format --set-exit-if-changed lib test` | ⚠️ 9 ficheros sin formatear | 0,7 s | 5 de gestion, 1 my_data, 1 personalization, 2 tests (incluido el test nuevo de auth) |
| `fvm flutter test` | ✅ **84 tests, todos pasan** | 5,2 s | Tags `backend`/`performance` excluidos por `dart_test.yaml`. Los logs de test imprimen DNI en claro (`titular=03874761C`) — evidencia F-18 por ejecución |
| `fvm flutter test --tags performance` | ⚠️ "No tests ran" | — | La suite opt-in documentada no existe (F-14) |
| `fvm flutter build apk --release` (config dev) | ✅ OK (63,1 MB) | 12,8 s (caché) | Compila; artefacto no distribuible (ver siguiente fila) |
| `apksigner verify --print-certs` + `aapt2 dump badging` sobre el APK | ⚠️ | — | **`CN=Android Debug`** (F-03); **`package='com.example.jccm_espacio_ciudadano' versionCode='1'`** (F-02/F-31); `minSdk 24 / targetSdk 36`; permiso `INTERNET` presente (**F-01 corregido, verificado en artefacto**) |
| `fvm flutter build ios --no-codesign --debug` | ✅ OK | 57,7 s | Salida literal: `Building com.example.jccmEspacioCiudadano for device` (F-02) |
| `fvm flutter pub outdated` | ✅ | — | Solo minors/patches (riverpod 3.0.3→3.3.2, dio 5.9.2→5.10); único major connectivity_plus 6→7; `meta` retenido en 1.17.0 por el lock degradado (F-30) |
| Harness deadlock (dart standalone + dio 5.9.2) | 🔴 **Reproducido** | — | `[1] RESULT: TIMEOUT after 5007ms — DEADLOCK CONFIRMED`; `[2] error queue POISONED for all later failures`; control con retry→200: OK en 37 ms |

**Interpretación global:** el repositorio compila y su suite pasa — descarta "NO COMPILA". Pero la suite es la quinta parte de la que existió, ningún build release se ha probado en runtime, y el defecto de red crítico está demostrado empíricamente por segunda vez.

---

## 4. Bloqueos de publicación

### F-02 · BLOCKER · CONFIRMED (por ejecución) — Identificadores `com.example.*` en ambas plataformas
- **Evidencia de hoy:** `aapt2 dump badging` del APK release → `package='com.example.jccm_espacio_ciudadano'`; salida del build iOS → `Building com.example.jccmEspacioCiudadano for device`. Ficheros: `android/app/build.gradle.kts:9,24` (con el `// TODO: Specify your own unique Application ID` de plantilla intacto), `ios/Runner.xcodeproj/project.pbxproj:481,664,687` (+ RunnerTests 498/516/532), paquete Kotlin `com/example/jccm_espacio_ciudadano/MainActivity.kt`.
- **Escenario:** Google Play rechaza ids `com.example.*`; el id es inmutable tras publicar. Además los dos ids ni siquiera coinciden en estilo entre plataformas.
- **Fix:** decidir el id definitivo (p. ej. `es.jccm.espaciociudadano`), aplicarlo en gradle + paquete Kotlin + 6 build settings de iOS. **Verificación:** build ambas plataformas + subida a track interno de Play.

### F-03 · BLOCKER · CONFIRMED (por ejecución) — El release se firma con claves de debug; no existe infraestructura de firma
- **Evidencia de hoy:** `apksigner verify --print-certs` sobre el APK release recién construido → `Signer #1 certificate DN: C=US, O=Android, CN=Android Debug`. Fichero: `android/app/build.gradle.kts:36-40` (`release { signingConfig = signingConfigs.getByName("debug") }` con TODO de plantilla). `android/.gitignore` ignora `key.properties` pero nada lo consume. El `Jenkinsfile:97-109` construye y **archiva como artefacto** ese AAB/APK firmado en debug. iOS no tiene pipeline en absoluto.
- **Fix:** keystore de release (o Play App Signing con upload key) + bloque `signingConfigs.release` + credenciales en Jenkins; definir el proceso de firma/archivado iOS. **Verificación:** `apksigner verify --print-certs` del artefacto de CI.

*(F-01 — permiso INTERNET — era el tercer bloqueo del informe anterior. **CORREGIDO** en `c3b09f8` y verificado dentro del APK release.)*

---

## 5. Hallazgos priorizados (confirmados y de alta confianza)

> Todo hallazgo de esta sección está verificado por al menos dos vías independientes (dos agentes distintos, o agente + verificación directa/ejecución del orquestador). Los `F-nn` conservan el id del informe del 21-07; los `N-nn` son nuevos de hoy.

### CRITICAL

**F-04 — Deadlock permanente en `AuthRefreshInterceptor` cuando el reintento tras un 401 falla** · CONFIRMED (re-reproducido hoy)
- **Ficheros:** `lib/core/network/network_interceptors.dart:41-88` (`extends QueuedInterceptor`, `await _dio.fetch(retryOptions)` en línea 82 sobre el mismo Dio); `lib/core/network/api_client.dart:27`.
- **Evidencia:** intacto tras `c82d431` (ese commit solo tocó el flag de logging en este fichero). Mecanismo verificado contra el fuente de dio 5.9.2 (`dio_mixin.dart:503-507`, `interceptor.dart:439-469`: una sola `_errorQueue` por interceptor que solo avanza cuando el handler en curso completa). **Harness de hoy:** petición con 401→refresh→retry-500 hace timeout (`DEADLOCK CONFIRMED`); una segunda petición que falla también cuelga (`error queue POISONED`); el camino feliz (retry→200) funciona en 37 ms — por eso no se detecta en pruebas manuales. El `catch (retryError)` de la línea 84 **nunca se ejecuta**: el error del retry se encola a nivel de framework antes de aflorar. Matiz nuevo: un 401 en `/api/v1/soporte` (FormData ya finalizado) haría que `_dio.fetch` lance `StateError`, que también escapa del catch.
- **Escenario:** token caducado → 401 → refresh OK → el reintento recibe 403 downstream / 500 crudo (modos de fallo documentados de esta fachada) o un corte de red → spinner infinito en esa pantalla y en toda petición posterior que falle, hasta matar el proceso.
- **Fix mínimo:** ejecutar el reintento con un Dio secundario sin `AuthRefreshInterceptor` (mismas `BaseOptions` + `ErrorInterceptor`). **Verificación:** test unitario refresh-OK + retry-KO que asevere que el caller recibe el error (hoy haría timeout).

**F-05 — Regresión commiteada: `refresh()` sin `force` convierte la sesión revocada en detonante del deadlock** · CONFIRMED · AGRAVADO respecto a ayer
- **Ficheros:** `lib/core/network/api_client_provider.dart:17` (commit `c82d431`, hoy); `auth_session_controller.dart:88-91`.
- **Evidencia:** sin `force`, si `accessTokenExpirationDateTime` es futuro, `refresh()` devuelve `true` **sin tocar Keycloak**. El interceptor no compara el token nuevo con el que recibió el 401 (`network_interceptors.dart:66-70`, solo comprueba no-nulo) → reintenta el mismo Bearer → segundo 401 → entra en la `_errorQueue` bloqueada → **deadlock F-04**. Con el `force:true` anterior, este escenario terminaba en `invalid_grant` → `clear()` → logout limpio. El comentario que justifica el cambio ("aprovechar el refresh de un peer") solo contempla el caso en que un peer realmente renovó el token; no el caso "expiry local futuro + rechazo del servidor" (sesión revocada, clock skew, rechazo de la fachada). Los 7 tests nuevos usan todos `force:true` — el modo que el interceptor ya no usa — y no cubren este camino.
- **Fix:** en el interceptor, comparar el token que recibió el 401 con `_tokenGetter()` y, si es idéntico, `refresh(force: true)`. Con F-04 arreglado, el residuo de F-05 baja a MEDIUM (un reintento desperdiciado). El margen cero del short-circuit (línea 89, sin los 60 s de `refreshIfNeeded`) debería alinearse de paso.

### HIGH

**F-06 — Patrón sistémico: cuerpos de error HTTP parseados como datos → "sin datos" oficiales** · CONFIRMED (re-verificado hoy, 9/9 repos sin cambios)
- **Ficheros:** `my_data_{vehicles:70-84, education:82-129, health:66-82, housing:80-117, employment:70-79, social_welfare:148-160}_repository_impl.dart`, `agenda_repository_impl.dart:58-67`, `recommendations_repository_impl.dart:31-43`, `life_events_repository_impl.dart:128-138`.
- **Patrón:** `validateStatus < 500` y/o catch de `DioException` que devuelve `error.response?.data` como payload y solo relanza si no hay cuerpo. El sobre JSON de un 500/403 no contiene las claves esperadas → lista/entidad vacía → empty state ("no tienes citas", "no constan vehículos", "no tienes título de familia numerosa"). Matices: social_welfare sí distingue `412.00` y recommendations `404.01/412.00` — el resto de errores con cuerpo sigue degradando a vacío. Los estados de error/retry existen pero son inalcanzables por esta vía.
- **Escenario:** esta fachada emite 500 crudos (NPE) y 403 `[no body]` cuando cae su microservicio (comportamiento documentado del proyecto) → cualquier caída downstream se presenta como ausencia de datos oficiales.
- **Fix (repetible por plantilla):** relanzar si `statusCode >= 400` salvo 404 y códigos de negocio conocidos (412.00, 404.01), idealmente al centralizar los helpers duplicados (F-22). **Verificación:** 1 test de 500 crudo por repo (patrón ya existente en `gestion_notificaciones_repository_impl_test.dart:122-137`, el único que lo cubre).

**N-01 — Crash garantizado en el router: `state.extra! as (Registro, bool)`** · CONFIRMED (agente + lectura directa)
- **Fichero:** `lib/core/routing/app_router.dart:242`.
- **Evidencia:** único builder del router con `extra!` sin `is`-check (contraste: `gestionExpedienteDetalle:215-219` y `recommendationLifeEventFilters:370-376` sí tienen fallback).
- **Escenario:** cualquier navegación a `/gestion/registros/detail` sin extra (deep link con sesión activa, restauración de estado, `go()` futuro) → `null!` → excepción en el builder → pantalla de error del framework. **Fix:** `is`-check con redirect a la lista (patrón ya presente 30 líneas más arriba).

**AUTH-3 — Carrera logout↔refresh: un refresh en vuelo re-persiste tokens tras cerrar sesión** · CONFIRMED (elevado de MEDIUM ayer a HIGH tras verificación estructural)
- **Ficheros:** `auth_session_controller.dart:104-117` (`_doRefresh` captura `hasPersistedSession` al inicio y hace `persist(mergedSession)` al final) vs `:170-178` (`clear()` no cancela ni versiona `_inFlightRefresh`).
- **Escenario:** logout (preferences, menú de perfil, o borrado de cuenta) mientras un refresh está en vuelo → el refresh completa después y **re-escribe accessToken/refreshToken en secure storage y repuebla los providers** → sesión zombi que el guard considera válida. **Fix:** época/generación de sesión que invalide el resultado del refresh iniciado antes del `clear()`.

**F-07 — "Mis datos → Empleo → Inscripciones en ofertas": pantalla simulada** · CONFIRMED (sin cambios)
- `my_data_employment_offers_provider.dart:4-6`: `return const <EmploymentOfferRegistration>[];` — sin repositorio ni red. Alcanzable vía `my_data_employment_data_tab.dart:152` → `app_router.dart:272-273`. `obtenerOfertasEmpleoInscritas` del cliente generado: 0 usos. Un usuario con inscripciones reales ve siempre "sin inscripciones" como dato oficial. **Fix:** conectar o retirar la entrada.

**F-08 — Demanda de empleo: estado "ACTIVA" fabricado por defecto** · CONFIRMED (sin cambios)
- `my_data_employment_repository_impl.dart:201-204`: `_statusLabel` devuelve `'Activa'` con campo nulo/vacío; con `validateStatus < 500`, incluso un cuerpo de error 4xx parseable produce "DEMANDA DE EMPLEO — ACTIVA" para un no inscrito. **Fix:** sin campo reconocible → dato ausente.

**F-09 — Notificaciones: sin detalle ni comparecencia; cada tarjeta muere en "próximamente"** · CONFIRMED (sin cambios)
- `gestion_notificaciones_page.dart:110`: único `onTap` → snackbar `gestionSectionComingSoon`, con la tarjeta renderizada como botón. `obtenerNotificacion`, `transicionNotificacion`, `descargarDocumento`: 0 usos en `lib/`. Una notificación "Pendiente" próxima a caducar no puede atenderse desde la app; el efecto administrativo de su expiración es real. **Fix mínimo:** retirar los affordances de tap; decisión de producto explícita.

**F-10 — Aportación documental: `registrarfichero` nunca ha completado con éxito contra UAT** · CONFIRMED (sin cambios)
- `gestion_documento_repository_impl.dart:257-265` ("Historial contra UAT real: 5 iteraciones fallaron con el mismo 500 crudo… La 6ª iteración añade…"), `:209-212`, `:286-292`, `:357,376` ("pendiente de confirmar contra UAT real"); `gestion_aportar_documentacion_page.dart:41-46` ("ningún paso se ha podido probar contra un backend real"). **Fix:** sesión de validación dedicada contra UAT antes del release; registrar el resultado.

**F-11 — Onboarding de hechos vitales inalcanzable** · CONFIRMED (matizado)
- `Routes.lifeEventsOnboarding` (`route_registry.dart:79`): 0 referencias de navegación. `CheckLifeEventsOnboardingUsecase`: provider sin consumidores. El "mark-seen" de `consent_notifier.dart:204-217` (`_skipLifeEventsOnboardingIfClauseWasEnabledFromPreferences`) parece deliberado para el caso de preferencias; el problema de fondo es que el flujo entero no se muestra nunca. **Fix:** cablear la navegación tras el consentimiento inicial, o borrar el flujo.

**F-12 — Doble tap en "Registrar" lanza dos transacciones registrales completas** · CONFIRMED (sin cambios)
- `gestion_aportar_documentacion_page.dart:64,128,186-253`: el botón solo se deshabilita cuando algún archivo está `enviando`; entre el tap y el primer upload hay una fase async (`await expedienteDetailProvider` línea 221 + `iniciarProcedimiento` línea 234) sin guard; sin debounce en `AppButton`. Dos `inicproc` con `idunico` distintos + subidas duplicadas → asientos registrales duplicados. **Fix:** flag síncrono `_registrando` en la primera línea de `_registrar`.

**F-14 — Red de seguridad de tests purgada (434→84) con mensaje de commit engañoso; CI no ejecuta ni los que quedan** · CONFIRMED (re-verificado hoy)
- Commit `817a4ae` (2026-05-05, "Remove outdated accessibility and golden tests…"): **478 ficheros, 37.213 líneas borradas, 461 declaraciones `test(`/`testWidgets(` eliminadas**, incluyendo `auth_repository_impl_test`, tests del datasource Cl@ve, retry policy, offline banner, contract tests del cliente generado y **los dos únicos tests que protegían la redacción de PII en telemetría**. Hoy: `integration_test/` vacío, 0 `testWidgets`, tags `backend`/`performance` de `dart_test.yaml` sin ningún test (`--tags performance` → "No tests ran", verificado por ejecución), `Jenkinsfile:23` `RUN_TESTS defaultValue: false`, sin stage de analyze/lint.
- **Fix mínimo:** `RUN_TESTS=true` + stage `flutter analyze`; reponer tests de interceptor 401→refresh→retry (cazaría F-04/F-05), `auth_repository_impl` y un smoke de widget por página top-level.

**F-15 — `build_full_runner.sh` roto** · CONFIRMED (re-leído hoy, con agravante)
- Líneas 20-22: `cd generated` seguido de `cd` sin argumento (salta a `$HOME`) antes de `dart run build_runner build`; con `set -e` aborta tras haber borrado `Pods/` y `Podfile.lock`. Agravante nuevo: la línea 1 del fichero está vacía, así que el shebang de la línea 2 es un comentario inerte. **Fix:** `cd generated/dart_dio_client` + shebang en línea 1.

**F-16 — `.fvm/` commiteado con symlinks absolutos a la HOME de otro desarrollador** · CONFIRMED (re-verificado hoy)
- `git ls-files .fvm` → 5 entradas; `.fvm/flutter_sdk` y `.fvm/versions/3.41.7` → `/Users/pmiguel/fvm/versions/3.41.7` (roto en esta máquina y en CI; `/Users/pmiguel` no existe). Consecuencia ya materializada: el lock degradado F-30 entró al repo. **Fix:** `git rm -r --cached .fvm` + `.fvm/` en `.gitignore` (conservar `.fvmrc`).

**NAT-A3 — `android:label="jccm_espacio_ciudadano"` visible al usuario** · CONFIRMED (nuevo)
- `AndroidManifest.xml:6`. El usuario vería el nombre técnico bajo el icono. iOS tiene `CFBundleDisplayName` "Jccm Espacio Ciudadano" (capitalización defectuosa). **Fix:** nombre comercial definitivo en ambas plataformas (decisión de producto: "Carpeta Ciudadana CLM" según CLAUDE.md).

### MEDIUM (con impacto real; detalle en secciones 7-14)

| ID | Hallazgo | Evidencia clave | Estado |
|---|---|---|---|
| N-02 | `kVerboseNetworkLogging = true` commiteado en `c82d431` con doc-comment que dice "off by default"; activa además `CurlLoggerDioInterceptor(printOnSuccess:true)` que imprime curl con `Authorization: Bearer <token>` y body íntegro **sin redacción** en cada petición exitosa (verificado en el fuente del paquete 1.0.1, que además muta los FormData al loguear). No emite en release (assert del paquete `logger` + `dart:developer log`), pero cada sesión debug/QA con datos reales vuelca tokens vivos y PII reutilizable como curl | `network_interceptors.dart:152`, `api_client.dart:30` | NUEVO (hoy) |
| F-18 | DNI y datos de salud interpolados en logs (`[selectbynif] req numerodocumento=$documentNumber`, `titular=…`) que saltan la redacción del interceptor; visible en la propia salida de `flutter test`; `print()` crudo en external_links que SÍ emite en release; `_redact` no cubre nombre/apellidos/dirección/fechaNacimiento y no redacta bodies String | `gestion_expediente_repository_impl.dart:18,61,97`, `gestion_documento_repository_impl.dart:109,223`, `url_launcher_external_link_launcher.dart:65` | Sin cambios |
| F-18b | Silenciado de logs en release **implícito**: `Logger(level: Level.debug)` sin filtro propio; 0 usos de `kReleaseMode`/`kDebugMode` en `lib/`; `DEBUG_MODE` de config no gobierna nada; el test de redacción se borró en la purga | `logger.dart:7-10` | Sin cambios |
| N-03 | DNI/idAgente como **clave** de SharedPreferences en claro (`consent_accepted_<dni>`, `life_events_onboarding_seen_<dni>`…) | `storage_keys.dart:36-53`, `consent_repository_impl.dart:182-184` | NUEVO |
| F-13/F-19 | Biometría decorativa: el gate biométrico existe en el unlock de landing (`landing_notifier.dart:49-65`, corregido el 20-07) pero `SessionGuard → refreshIfNeeded() → hydrateFromStorage()` (`session_guard.dart:44` + `auth_session_controller.dart:76`) rehidrata la sesión persistida de **todos** los usuarios sin biometría; la sesión se persiste para todos al aceptar el consentimiento (`consent_page.dart:234`); `FlutterDeepLinkingEnabled` sigue sin desactivar en iOS; secure storage sin access-control biométrico; flag en prefs plano | ver ficheros citados | Parcialmente mitigado |
| F-21 | Sin FLAG_SECURE/protección de capturas en pantallas con datos de salud/expedientes (0 ocurrencias en lib/, android/, ios/) | grep | Sin cambios |
| F-23→AUTH-3d | `idToken` no se persiste (no existe `StorageKeys.idToken`) → tras reiniciar, logout omite `end_session`: la sesión SSO de Keycloak/Cl@ve sobrevive (mitigado por `prompt=login`, pero el refresh token server-side queda vivo); comportamiento no determinista si hubo un refresh real antes | `auth_session_controller.dart:144-152,60-68` | Sin cambios |
| F-25 | Gates que confunden error con "no autorizado": `CheckAcceptedConsentClauseFailed() => false` en `session_guard.dart:132`, `preferences_page.dart:42`, `recommendations_provider.dart:53`, `my_data_authorization_provider.dart:33` (digital_cards lo hace bien) | ver ficheros | Sin cambios |
| F-26 | `tipodoc: 'NIF'` hardcodeado en vehicles (`:56,64`) y education (`:79,95,105`) — usuarios NIE reciben error que F-06 convierte en "sin datos"; employment/housing/social_welfare sí detectan NIE. Ambos repos además con 0 tests | `my_data_vehicles_repository_impl.dart`, `my_data_education_repository_impl.dart` | Sin cambios |
| N-04 | Shell global con `ShellRoute` + `context.go` por pestaña (sin `StatefulShellRoute`): pérdida de estado y **recarga de red completa en cada cambio de tab** (Home además hace `ref.invalidate(digitalCardsProvider)` en cada `initState`); back físico Android sale de la app desde cualquier pestaña | `app_router.dart:164`, `main_sections_shell.dart:52-65`, `home_page.dart:165-166` | NUEVO (rama actual) |
| N-05 | ~90–208 cadenas en español hardcodeadas fuera de ARB en superficies visibles (labels del tab bar global, dashboard Home, diálogo de borrado de cuenta, formulario de soporte) con `Locale('en')` ofrecido en `app.dart:33-36` → UI mixta en dispositivos EN | `main_sections_shell.dart:17-21`, `home_page.dart`, `preferences_page.dart`, grep 89-208 según patrón | NUEVO |
| N-06 | `AppBottomTabBar` (navegación primaria) sin `Semantics`: sin estado seleccionado ni rol para TalkBack/VoiceOver; único indicador de selección es una barra de 4 px; trunca con textScale grande. El resto del design system sí declara Semantics | `app_navigation.dart:896-971` | NUEVO |
| N-07 | `RichText` sin `textScaler` (0 usos en lib/): el **cuerpo del texto legal del gate de consentimiento** ignora el tamaño de fuente del sistema (WCAG 1.4.4); landing con `NeverScrollableScrollPhysics` que oculta overflow | `privacy_page.dart:642,765`, `landing_page.dart:235,92-93` | NUEVO |
| N-08 | Cláusula nueva del backend → `clear()` de la sesión persistida y expulsión a landing **sin ningún mensaje** (parecerá bug de sesión en cada actualización legal) | `session_guard.dart:63-68`, `landing_notifier.dart:74-77` | NUEVO |
| N-09 | Notificaciones "Todo": dedupe por `id` con `idNotificacion ?? 0` colapsa items sin id (solo sobrevive el primero) y el resultado va sin ordenar por fecha (bloques por estado) | `gestion_notificaciones_repository_impl.dart:43,54,97,137` | NUEVO (orden verificado; colapso condicionado a que el backend omita ids) |
| N-10 | Añadir un fichero durante la subida en curso aborta el registro con diagnóstico falso (`a.hash!` sobre el fichero nuevo → `marcarErrorTodos()` aunque las subidas reales fueran bien) | `gestion_aportar_documentacion_page.dart:121,259-274` | NUEVO |
| N-11 | Filtro de Notificaciones desincronizado: volver de "Expiradas" con la flecha ← resalta "Aceptadas" mientras la lista sigue mostrando expiradas | `gestion_notificaciones_page.dart:154-178` | NUEVO |
| F-34 | Detalle interno en snackbar al eliminar cuenta: ya no es `e.toString()` directo en la página, pero los usecases de reset envían `e.toString()` como `message` y la página lo muestra — solo cambió la indirección | `reset_life_events_usecase.dart:34`, `reset_consent_clauses_usecase.dart:29`, `preferences_page.dart:327-334` | Persiste (movido) |
| F-36 | 412.00 (autorización requerida) solo distinguido en Familia Numerosa; las otras 4 páginas de bienestar social muestran error genérico con retry inútil pese a que el repo ya lanza `MyDataAuthorizationRequired` | `my_data_social_welfare_{disability,dependency,thermal_spa,parking}_page.dart:38` | Sin cambios |
| F-38 | Captcha del formulario público de soporte decorativo (se "verifica" al tocarlo) sobre endpoint real sin auth; agravante nuevo: el hint promete filtro de tipos de fichero que `openFile()` no aplica (solo tamaño) | `support_form_page.dart:91,477,134` | Sin cambios + agravante |
| N-12 | `WidgetRef` del `Consumer` del sheet de descarga de carnés usado tras cerrar el sheet (incl. `finally`): assert de Riverpod en debug, comportamiento indefinido en release, flag global de descarga puede quedar en true | `digital_card_download_sheet.dart:57-103` | NUEVO (antes anotado como LOW) |
| F-30 | `pubspec.lock` degradado (meta 1.18→1.17, test 1.31→1.30) **commiteado hoy** en `c3b09f8` — justo lo que el informe anterior pedía no commitear; causa raíz F-16 | `git show c3b09f8 -- pubspec.lock` | Empeorado (commiteado) |
| F-31 | Sin flavors/sufijos por entorno (imposible instalar dev/pre/prod en paralelo; riesgo de distribuir el entorno equivocado); versionCode fijo 1 sin `--build-number` en CI | build.gradle.kts, Jenkinsfile | Sin cambios |
| F-32 | 119 claves ARB sin traducir a EN con `Locale('en')` ofrecido (verificado por ejecución en `pub get`) — decidir: completar EN o retirar el locale (misma decisión que N-05) | `app_es.arb` vs `app_en.arb` | Sin cambios |
| F-33 | Deps muertas verificadas hoy: `crypto`, `built_value`, `freezed_annotation` 0 usos en lib/ (+ `freezed`/`json_serializable` que inducen a error sobre un codegen inexistente); README = stub de flutter create; CHANGELOG congelado reivindicando infra borrada | pubspec.yaml, README.md | Sin cambios |
| F-17 | `TokenResponse` de flutter_appauth como contrato en dominio/usecase/estado (3 capas); prohibido por ARCHITECTURE.md | `auth_repository.dart:11,16`, `login_use_case.dart:13`, `token_response_notifier.dart` | Sin cambios |
| F-22/F-28/F-29 | Duplicación masiva de helpers en 3_data (`_rawResponse` ×7, decodificadores ×8, `_documentNumber` ×10); dualidad usecase-sealed vs provider-StateError entre features; `ARCHITECTURE.md` aspiracional que no describe el código | ver §7 | Sin cambios |
| NAT-I2 | Sin `PrivacyInfo.xcprivacy` a nivel de app (los de los pods no cubren la declaración de la app) — requisito de App Store | `ios/Runner/` | NUEVO |
| F-37 | "Trámites sugeridos" enlazan a portadas genéricas (fallback autodocumentado "Pending product confirmation") | `external_link_catalog_impl.dart:60-68` | Sin cambios |
| F-39 | Módulo de conectividad decorativo: `OfflineBanner` + `connectivity_plus` con 0 consumidores | `lib/core/connectivity/` | Sin cambios |

### LOW / INFORMATIONAL (agrupados)

- **Corregidos desde ayer:** F-01 (INTERNET, verificado en APK), F-35 (`lifeEventsProvider` → `autoDispose` en `c3adc1e`), F-40 (NSPhotoLibraryUsageDescription añadida y suficiente; verificado además que NO hacen falta cámara/micrófono — ningún pod enlazado referencia esas APIs).
- **Refutados del informe anterior:** "sin minify/R8" (el plugin Gradle de Flutter 3.41.7 lo activa por defecto en release, verificado en el SDK); "cambio de scopes en c82d431" (cosmético: `['openid']` → constante idéntica).
- **Código muerto/scaffolding:** rutas fantasma (`/` sin GoRoute → NotFoundScreen, `/login` renderiza `DomainLandingPlaceholder('Login')` alcanzable, `maintenance`/`afirmaReturn` sin ruta), `sweepDigitalCardsTempCache` sin llamadas (hoy sin residuos que barrer: las descargas van vía `saveFile`), barrels/widgets/claves l10n sin uso, `tool/` y `lib/core/cicd/` vacíos.
- **Toolchain/higiene:** 9 ficheros sin `dart format`; `gitlab-ci/` mal nombrado (es la imagen Docker de Jenkins) + `docker.zip` binario commiteado; `generate_api.sh` requiere `rg` sin documentarlo; iconos `ic_launcher` legacy sin uso; Pods huérfanos de Firebase solo locales (gitignorados); `sed -i` GNU-only en Jenkinsfile (válido si el agente es el Docker Linux).
- **Hardening aplazable:** `taskAffinity=""`, `ITSAppUsesNonExemptEncryption=false`, secure storage sin `IOSOptions`/`userAuthenticationRequired`, ~9 páginas que puentean el allowlist de url_launcher (hoy todas con https hardcodeado, sin open redirect), cert pinning (no hay, tampoco bypasses), landscape permitido en iPhone (confirmar contra diseño), orientación `Jccm` en display name.
- **Detalles de runtime:** 0 `toLocal()` (riesgo UTC si el backend emite offsets), teléfono como int, fechas `fechareg` sin formatear, sin pull-to-refresh en varios listados, `StateError` con mensajes ES hardcodeados en providers, session guard fail-open por allowlist.

---

## 6. Hallazgos pendientes de validación (POSSIBLE)

| ID | Sospecha | Cómo validarla |
|---|---|---|
| P-02 | Vector deep link iOS (scheme registrado + FlutterDeepLinkingEnabled activo por defecto): `es.jccm.espaciociudadano://x/home` con sesión persistida rehidrata sin biometría | Dispositivo/simulador iOS con sesión persistida |
| P-03 | `personIdentifier` sin normalizar prefijos eIDAS (`ES/ES/`) en providers de my_data/gestion → 403 que F-06 convierte en "sin datos" | Login con cuenta Cl@ve real con formato prefijado |
| P-04 | Consentimiento con lista de cláusulas vacía (degradación de red) persistido sin cláusula 0 → 403 posteriores | Test de integración de `fetchClauses` fallido + aceptar |
| P-05 | Bytes 2xx de `registrarfichero` no validados como PDF (`%PDF`) → justificante corrupto con diálogo de éxito; el propio repo documenta 200-con-sobre-de-error | Check de magic bytes + prueba contra UAT (depende de F-10) |
| P-06 | Logcat real de un build release en dispositivo (los silenciamientos de N-02/F-18 son implícitos: assert del paquete `logger` + `dart:developer`) | Build release en dispositivo con `adb logcat` |
| P-07 | Fechas del backend con offset/Z mostradas en UTC (0 `toLocal()`) | Payloads reales de agenda/SESCAM |
| P-08 | GoRouter sin `refreshListenable`: sesión muerta no expulsa hasta la siguiente navegación | Test de widget router + `clear()` |
| P-09 | Titularidad del `DEVELOPMENT_TEAM 494UN8AR7S` | Apple Developer Portal |
| P-11 | Validación server-side de las subidas (la app valida extensión/tamaño por nombre; el form de soporte ni eso) | Equipo de backend |
| P-12 | Config del cliente Keycloak: `post_logout_redirect_uri` whitelisted, política de sesión idle (la motivación del ticket #272665) | Sesión con el equipo SSO |
| P-13 | `orElse: () => maps.first` en social_welfare podría fabricar entidad desde un mapa arbitrario del sobre si comparte claves | Payloads reales de error de la fachada |

*(P-01 del informe anterior — scope `offline_access` — queda retirado: la versión commiteada usa solo `['openid']`, verificado. P-10 — targetSdk — queda resuelto: targetSdk 36 verificado en el artefacto.)*

---

## 7. Arquitectura y coherencia técnica

Sin cambios sustantivos desde el informe del 21-07; re-verificado hoy el cumplimiento de las reglas mecánicas:

- **Arquitectura real:** monolito Flutter por features con 4 capas numeradas, Riverpod 3 puro, GoRouter centralizado (48 páginas importadas directamente; no existe el patrón route-providers del doc), Dio con interceptores centralizados, cliente OpenAPI aislado en `3_data`.
- **Reglas mecánicas estrictamente cumplidas (grep de hoy):** 0 imports de `espacio_ciudadano_api` fuera de `3_data`; presentación → data solo vía providers; `0_entity` puro; solo package imports; 0 TODO/FIXME/`Future.delayed` en lib/.
- **Desviaciones vigentes:** `TokenResponse` como contrato de dominio (F-17); dio en usecases; `core/network`/`core/routing` importan presentación de features; dualidad usecase-sealed (consent, personalization, preferences, agenda, auth, landing) vs provider+`StateError` (my_data, digital_cards, recommendations, external_links, 3/4 de gestion) (F-28); duplicación de helpers del sobre `Respuesta` (F-22); `ARCHITECTURE.md` aspiracional cuyos apartados "CRITICAL" no describen el código (F-29).
- **Novedad de la rama:** el shell global se implementó con `ShellRoute` simple (N-04) — la elección arquitectónica correcta para tabs con estado en go_router 17 es `StatefulShellRoute.indexedStack`; el coste de no usarla es funcional (pérdida de estado, recargas), no solo estilístico.

---

## 8. Cobertura funcional aparente

| Feature | Estado | Cambio desde ayer |
|---|---|---|
| consent | **COMPLETA** (reserva P-04) | = |
| digital_cards | **COMPLETA** | = (menor: N-12 ref-tras-dispose en el sheet) |
| preferences | **COMPLETA** | = (F-34 persiste vía usecases de reset) |
| legal, external_links | **COMPLETA** | = |
| gestion — expedientes y registros | **COMPLETA** | = (N-01: crash de router en detalle de registro vía extra) |
| landing/home | **COMPLETA** (reservas) | Shell nuevo: N-04/N-05/N-06 aplican aquí |
| agenda | **PARCIAL** (F-06) | = |
| my_data | **PARCIAL** — ofertas de empleo **SIMULADA** (F-07), "ACTIVA" fabricada (F-08), NIF hardcodeado (F-26), F-06 sistémico | = |
| recommendations | **PARCIAL** | F-35 corregido |
| personalization | **PARCIAL** — onboarding muerto (F-11) | = |
| gestion — notificaciones | **INCOMPLETA** (F-09; + N-09/N-11 en el listado) | = |
| gestion — aportación documental | **NO VERIFICABLE** e2e (F-10; + F-12/N-10 en cliente) | = |
| conectividad (transversal) | **DECORATIVA** (F-39) | = |

Positivo re-verificado hoy: no hay `Future.delayed` simulando red, ni `kDebugMode` sospechosos, ni listas demo hardcodeadas (la única simulación es F-07). El patrón de riesgo IA dominante sigue siendo **errores silenciados y subsistemas construidos pero nunca conectados**, más el nuevo ejemplar de "comentario que contradice al código" (N-02: "off by default" sobre un `true`).

---

## 9. Seguridad y privacidad

**Sin secretos en el repo ni en el historial** (re-verificado: configs solo con client_id público OAuth/PKCE, URLs https y timeouts; sin keystores/certificados; el único fichero histórico sospechoso contenía placeholders).

**Controles verificados presentes:** tokens exclusivamente en secure storage; PKCE S256 + `prompt=login`/`max_age=0`; `allowBackup=false`; permisos Android mínimos y correctos (verificado: el set INTERNET+USE_BIOMETRIC es exactamente lo que el plugin-set requiere); TLS sin bypasses, sin cleartext, sin excepciones ATS; sin WebViews; redacción por clave en el logger de red (diseño correcto, cobertura incompleta); allowlist de url_launcher en external_links; minify/R8 activo en release por defecto.

**Problemas concretos (detallados en §5):** N-02 (curl con Bearer sin redactar, activado por commit de hoy), F-18/F-18b (DNI en logs; silenciado release solo implícito; `print()` que sí emite en release), N-03 (DNI como clave de prefs en claro), F-13/F-19 (rehidratación sin gate biométrico pese a UI que sugiere lo contrario), F-21 (sin FLAG_SECURE con datos de salud en pantalla), F-38 (captcha decorativo sobre endpoint público + sin filtro de tipos), AUTH-3 (sesión zombi tras logout), F-23 (end_session omitido tras reinicio), y en el plano de proceso F-03 (cadena de firma inexistente) y NAT-I2 (privacy manifest de app ausente).

---

## 10. Calidad de las pruebas

Lo que existe es bueno pero estrecho, y el commit de hoy lo mejora un poco: los 84 tests actuales son mayoritariamente de repositorios `3_data` con **mocks notablemente fieles al backend real** (sobre `Respuesta`, `codigo-respuesta`, singleton-vs-lista, content-type text/plain con JSON), y el test nuevo de `auth_session_controller` (7 escenarios) protege bien la taxonomía del refresh (single-flight, invalid_grant vs transitorio, umbral, persistencia).

Lo que no cubre es exactamente donde están los defectos de esta auditoría: **todos los tests de refresh usan `force:true` — el modo que el interceptor ya no usa** (F-05); el `AuthRefreshInterceptor` tiene 0 tests (F-04); la carrera logout↔refresh, el idToken tras hydrate y el 401-con-token-válido no se prueban. El 500 crudo — el modo de fallo característico de esta fachada — solo se prueba en 1 fichero (`gestion_notificaciones`); education y vehicles (justo los repos con NIF hardcodeado) tienen 0 tests. 0 tests de widget/golden/integración/accesibilidad; tags `backend`/`performance` muertos; CI con `RUN_TESTS=false`.

**Conclusión:** 84 tests verdes sobreestiman gravemente la protección real. La purga `817a4ae` (461 tests, mensaje de commit engañoso) nunca se repuso.

---

## 11. Android

- **Bloqueos:** F-02 (applicationId), F-03 (firma) — ambos verificados por ejecución sobre el artefacto de hoy.
- **Correcto (verificado hoy):** permisos exactos (INTERNET añadido en `c3b09f8` + USE_BIOMETRIC; `ACCESS_NETWORK_STATE` llega por merge del AAR de connectivity_plus); `allowBackup=false` + `fullBackupContent=false`; cleartext deshabilitado por defecto; solo MainActivity exported (LAUNCHER); `queries` correctas para Custom Tabs/AppAuth; redirect scheme coherente con configs e iOS; **minSdk 24 / targetSdk 36 / compileSdk 36** (verificado en el APK); **minify/R8 + shrinkResources activos por defecto** en release (verificado en el SDK — corrige el informe anterior); AGP 8.11.1 + Kotlin 2.2.20 + Gradle 8.14 + Java 17 compatibles; `FlutterFragmentActivity` con `singleTop`; icono adaptativo y splash Android 12 completos y coherentes con sus YAML.
- **Relevantes:** NAT-A3 (label técnico, HIGH), F-31 (sin flavors, versionCode 1), taskAffinity sin fijar, iconos legacy.

## 12. iOS

- **Bloqueo:** F-02 (bundle id `com.example.*` en las 3 configuraciones + RunnerTests).
- **Correcto (verificado hoy):** `NSPhotoLibraryUsageDescription` añadida en `d0ee162` con texto específico — suficiente para ITMS-90683; **verificado que NO hacen falta cámara/micrófono** (grep de AVCaptureDevice/AVAudioSession en los pods DK = 0; solo se enlaza el subspec PhotoGallery); `NSFaceIDUsageDescription` presente; sin excepciones ATS; URL scheme coherente; deployment target 13.0 uniforme; Podfile estándar con `Manifest.lock` == `Podfile.lock`; AppDelegate con el patrón moderno de escenas; sin entitlements innecesarios; assets de icono/splash completos.
- **Relevantes:** NAT-I2 (sin `PrivacyInfo.xcprivacy` de app, MEDIUM), sin pipeline iOS (F-03), `DEVELOPMENT_TEAM` de titularidad no verificada (P-09), `FlutterDeepLinkingEnabled` sin desactivar (F-13/P-02), `ITSAppUsesNonExemptEncryption` ausente, display name "Jccm Espacio Ciudadano", landscape permitido, Pods huérfanos de Firebase solo locales.
- **Nota:** `file_picker` 11.0.2 permite excluir el módulo de fotos vía `PICKER_MEDIA=false` en el Podfile si se elimina la subida desde galería.

## 13. Web

No aplica: no existe `web/` (ni `macos/`/`windows/`/`linux/`) en el repositorio.

---

## 14. Dependencias y deuda técnica

**Estado de dependencias: bueno.** `pub outdated` de hoy: solo minors/patches (única major connectivity_plus 6→7, módulo decorativo); cliente generado **sincronizado** con el swagger v1.72.0 (último commit común `8937a20`, sin ediciones manuales posteriores — re-verificado).

**Deuda necesaria antes de producción:** F-30 (regenerar el lock con el SDK pinado y commitearlo bien — el degradado entró hoy), F-16 (.fvm), F-15 (script de rebuild), F-33 (deps muertas verificadas: `crypto`, `built_value`, `freezed_annotation`, más `freezed`/`json_serializable` que inducen a error), README/CHANGELOG honestos, documentar `rg` como prerequisito de `generate_api.sh`.

**Deuda aplazable:** consolidar file_picker/file_selector; centralizar helpers duplicados (F-22, junto a F-06); limpiar scaffolding muerto; alinear `ARCHITECTURE.md`; renombrar `gitlab-ci/` y borrar `docker.zip`/`FIGMA_NODES*`/`project-planner.agent.md`.

---

## 15. Aspectos correctamente implementados (verificados, sin cambios necesarios)

1. **Aislamiento del cliente generado**: 0 imports fuera de `3_data` (grep de hoy).
2. **Seam de DI** presentación→data solo vía providers, sin excepciones.
3. **Entidades puras** hechas a mano, consistentes.
4. **Manejo centralizado de errores** `ErrorInterceptor` → `AppError` sealed (excepción: F-34).
5. **Disciplina de ciclo de vida**: `ref.mounted`/`context.mounted` sistemáticos, dispose completo, `CancelToken` cancelados (excepción puntual: N-12).
6. **Seguridad de base**: sin secretos, PKCE + re-auth forzada, secure storage, TLS limpio, sin WebViews, permisos mínimos.
7. **Cliente generado sincronizado** con el swagger.
8. **Los tests que existen son de alta fidelidad** al backend real; el test nuevo de sesión es de calidad dentro de su alcance.
9. **Single-flight del refresh** correcto (verificado adversarialmente: asignación síncrona, sin carrera de registro).
10. **Los 3 arreglos de hoy están bien hechos**: INTERNET es exactamente el permiso que faltaba; la NSPhotoLibraryUsageDescription es suficiente y no faltan más claves; el `autoDispose` de life events elimina el estado entre usuarios.
11. **Android nativo moderno y coherente**: toolchain, targetSdk 36, R8 por defecto, icono/splash completos, manifest merge correcto.
12. **Pipeline Jenkins coherente** en lo que hace; su problema es lo que no hace (tests, firma, analyze).

---

## 16. Plan de estabilización

### P0 — Antes de continuar con QA

| Acción | Resuelve | Ficheros | Riesgo | Dependencias | Complejidad | Validación |
|---|---|---|---|---|---|---|
| Corregir deadlock del interceptor (Dio secundario para el retry) | F-04 | `network_interceptors.dart`, `api_client.dart` | Medio (corazón de la red) | — | **S-M** | Test unitario refresh-OK+retry-KO (hoy haría timeout) |
| Revertir/ajustar la regresión de refresh: comparar token del 401 con el actual y forzar refresh si es idéntico; revertir `kVerboseNetworkLogging` a `false` | F-05, N-02 | `api_client_provider.dart`, `network_interceptors.dart` | Bajo | F-04 | **S** | Ampliar `auth_session_controller_test` con el caso sesión-revocada |
| Guard del router: `is`-check en `gestionRegistrosDetail` | N-01 | `app_router.dart:242` | Nulo | — | **XS** | Navegación sin extra → redirect a lista |
| Fijar applicationId/bundleId definitivo | F-02 | gradle, Kotlin pkg, pbxproj | Bajo (requiere decisión JCCM) | Decisión de negocio | **S** | Build ambas + track interno Play |
| Keystore + firma release + firma en CI | F-03 | gradle, `key.properties` (fuera de repo), Jenkinsfile | Medio (secretos) | F-02 | **M** | `apksigner verify` del artefacto CI |
| Plantilla anti-"error→sin datos" en los 9 repos | F-06 | 9 `*_repository_impl.dart` | Medio | Idealmente con F-22 | **M** | 1 test de 500 crudo por repo |
| Decisión de producto sobre funcionalidad no terminada: conectar o retirar ofertas de empleo; quitar affordance o implementar detalle de notificaciones; validar `registrarfichero` contra UAT; cablear o borrar onboarding | F-07…F-11 | ver hallazgos | Medio | UAT disponible | **M-L** | Sesión UAT documentada; QA funcional |
| Guard síncrono anti doble-registro + bloquear añadir ficheros durante subida | F-12, N-10 | `gestion_aportar_documentacion_page.dart` | Bajo | — | **XS-S** | Test del notifier + prueba con red lenta |
| Época de sesión anti-carrera logout↔refresh | AUTH-3 | `auth_session_controller.dart` | Medio | — | **S** | Test `clear()` durante refresh en vuelo |
| CI: `RUN_TESTS=true` + stage analyze | F-14 (parte) | Jenkinsfile | Nulo | — | **XS** | Ejecución del pipeline |
| Sanear toolchain: destrackear `.fvm/`, regenerar lock con SDK pinado, arreglar `build_full_runner.sh` (cd + shebang) | F-15, F-16, F-30 | `.gitignore`, `.fvm`, script, lock | Nulo | — | **XS** | `pub get` limpio en otra máquina; lock sin downgrades |
| Label/display name definitivos | NAT-A3 | manifest, Info.plist | Nulo | Decisión de producto | **XS** | Inspección visual |

### P1 — Antes del piloto o publicación

| Acción | Resuelve | Riesgo | Complejidad | Validación |
|---|---|---|---|---|
| Shell con `StatefulShellRoute.indexedStack` + back handling Android | N-04 | Medio (núcleo de navegación) | **M** | Estado conservado entre tabs; back → Inicio → salir |
| Migrar cadenas hardcodeadas a ARB y resolver el locale EN (completar 119 claves o retirar `Locale('en')`) | N-05, F-32 | Bajo (volumen) | **M** | `gen-l10n` sin untranslated; smoke en dispositivo EN |
| Accesibilidad del shell: Semantics en `AppBottomTabBar`, `textScaler` en RichText del texto legal | N-06, N-07 | Bajo | **S** | TalkBack/VoiceOver + textScale 2.0 |
| Higiene de logs: quitar DNI de logs de repos, retirar/gatear CurlLogger, gate explícito `kReleaseMode`, ampliar `_sensitiveKeyFragments`, quitar `print()` de external_links | F-18, F-18b, N-02 (residuo) | Bajo | **S** | Logcat de release en dispositivo (P-06) + test de redacción |
| Postura de biometría: exigirla en la rehidratación del guard o documentarla como conveniencia; `FlutterDeepLinkingEnabled=false` | F-13/F-19, P-02 | Medio | **S-M** | Prueba en dispositivo iOS |
| FLAG_SECURE en rutas autenticadas | F-21 | Bajo | **S** | Captura bloqueada |
| Persistir `idToken`; recuperación tras fallo transitorio en landing | F-23, F-24 | Medio | **M** | Tests del controller |
| Gates de consentimiento: distinguir error de "no autorizado" (patrón digital_cards); mensaje al usuario en el logout por cláusula nueva | F-25, N-08 | Bajo | **S** | Tests de providers |
| `tipodoc` NIE en vehicles/education + tests de esos repos | F-26 | Bajo | **S** | Tests con documento X/Y/Z |
| 412.00 en las 4 páginas de bienestar restantes; orden + dedupe seguro en "Todo" de notificaciones; sincronizar filtro/pestaña | F-36, N-09, N-11 | Bajo | **S** | Tests por caso |
| Red mínima de tests: interceptor 401 (con F-04), `auth_repository_impl`, 1 caso 500 crudo por repo, 1 widget-smoke por página top-level | F-14 | Medio (esfuerzo) | **L** | Suite en CI |
| Flavors/sufijos por entorno + `--build-number` en CI | F-31 | Bajo | **M** | Instalación paralela dev/pre/prod |
| `PrivacyInfo.xcprivacy` de app + `ITSAppUsesNonExemptEncryption` + pipeline iOS | NAT-I2, F-03 (iOS) | Medio | **M-L** | Validación App Store Connect |
| Captcha/anti-abuso coordinado con backend + filtro real de tipos de fichero en soporte; URLs definitivas de trámites | F-38, F-37 | Bajo | **S-M** | Producto + backend |
| Fix ref-tras-dispose del sheet de carnés | N-12 | Bajo | **XS** | Cerrar sheet durante descarga |

### P2 — Mejora posterior

- Extraer `AuthSession` propio del dominio (F-17); sacar `AuthSessionController` de presentación; helper común del sobre `Respuesta` (F-22); unificar o documentar la dualidad usecase/provider (F-28); actualizar `ARCHITECTURE.md` (F-29).
- Limpieza de código muerto (connectivity F-39, sweep, rutas fantasma, barrels, deps muertas F-33), README/CHANGELOG, consolidar file_picker/file_selector, `refreshListenable` en GoRouter (P-08), `toLocal()` en mappers (P-07), pull-to-refresh, crash reporting/`runZonedGuarded` (sigue sin haber telemetría de errores), cert pinning, `taskAffinity=""`, check de drift del codegen en CI, denylist en `requiresAuth`, hash del idAgente en claves de prefs (N-03).

---

## 17. Evidencias y comandos ejecutados

Tabla principal en §3. Adicionales de hoy:

- `apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk` → `CN=Android Debug` (F-03); `aapt2 dump badging` → `package='com.example.jccm_espacio_ciudadano' versionCode='1'`, `minSdkVersion 24`, `targetSdkVersion 36`, `uses-permission INTERNET` (F-02/F-31/F-01-fixed).
- `git show c82d431` → `refresh(force: true)` → `refresh()` + `kVerboseNetworkLogging false→true`; `git show c3b09f8` → `+<uses-permission INTERNET>` **y** pubspec.lock con meta 1.18→1.17, test 1.31→1.30 (F-30 commiteado).
- Harness deadlock (scratchpad, fuera del repo; dart + dio 5.9.2, adapter 401→500): `[1] TIMEOUT after 5007ms — DEADLOCK CONFIRMED`, `[2] error queue POISONED`, control retry→200 OK en 37 ms (F-04). Mecanismo contrastado con `dio-5.9.2/lib/src/dio_mixin.dart:503-507` y `interceptor.dart:439-469`.
- `git ls-files .fvm` → 5 entradas; `readlink .fvm/flutter_sdk` → `/Users/pmiguel/fvm/versions/3.41.7` (F-16). `sed -n '1,30p' build_full_runner.sh` → `cd generated` + `cd` + shebang en línea 2 (F-15).
- `sed -n '15,35p' Jenkinsfile` → `RUN_TESTS defaultValue: false` (F-14).
- `grep -c` de cadenas con caracteres españoles fuera de `l10n.` → 89 (patrón estricto del orquestador) / 208 (patrón amplio del agente) (N-05); `grep -rn textScaler lib/` → 0 (N-07); `grep Semantics app_navigation.dart` → ausente en el rango de `AppBottomTabBar` (N-06).
- `grep -rl "package:crypto/\|package:built_value/\|package:freezed_annotation/" lib/` → 0 usos (F-33). `grep -rln espacio_ciudadano_api lib/ | grep -v 3_data` → vacío (regla de capas OK).
- Salida de `flutter test`: logs `[inicproc] req … titular=03874761C` (F-18 por ejecución). Salida de `pub get`: `"en": 119 untranslated message(s)` (F-32 por ejecución).
- Verificación en SDK Flutter 3.41.7: `FlutterExtension.kt` (compileSdk 36/minSdk 24/targetSdk 36) y `FlutterPlugin.kt:246-278` (minify+shrink por defecto en release).
- Pods DK: `grep -r "AVCaptureDevice\|AVAudioSession" ios/Pods/DKImagePickerController ios/Pods/DKPhotoGallery` → 0 (cierre de F-40).

---

## 18. Verificación independiente

Método: 5 agentes con contexto limpio (auth/red adversarial con harness; re-verificación adversarial de los 15 hallazgos funcionales del informe previo; caza libre sin lista previa; plataformas nativas; tests+seguridad) + verificación directa del orquestador por ejecución/lectura. Ningún hallazgo BLOCKER/CRITICAL/HIGH se reporta con una sola fuente:

- **Confirmados por reproducción empírica independiente:** F-04 (harness nuevo de hoy, distinto del de ayer, mismo resultado: deadlock + cola envenenada; contrastado además contra el código fuente de dio 5.9.2).
- **Confirmados por ejecución directa del orquestador:** F-02/F-03 (apksigner/aapt2/salida de build), F-01-fixed (permiso dentro del APK), F-14 (`--tags performance` vacío, Jenkinsfile), F-15/F-16 (lectura directa), F-30/N-02 (git show), F-32 (salida de pub get), F-18 (DNI en la salida de los tests).
- **Confirmados por agente + lectura directa del orquestador:** N-01 (`extra!`), N-04 (ShellRoute/context.go/sin PopScope), N-05 (labels y conteo propio), N-06 (grep de Semantics), N-07 (0 textScaler), N-08 (bloque del guard leído).
- **Re-verificación adversarial de los 15 hallazgos funcionales del 21-07:** 11 SIGUE_PRESENTE (F-06, F-07, F-08, F-09, F-10, F-12, F-25, F-26, F-36, F-38, F-39), 1 CORREGIDO (F-35), 3 MATIZADOS: F-11 (el mark-seen parece deliberado; el flujo inalcanzable es el defecto), F-13 (el gate biométrico del unlock de landing existe; la vía sin gate es el session guard), F-34 (el `toString()` se movió a los usecases de reset, no se eliminó). Varias referencias fichero:línea del informe anterior se corrigieron (support_form en `landing/`, sin subcarpeta `pages/` en gestion).
- **Elevados por la verificación:** F-05 (HIGH→CRITICAL: al commitearse sin la comparación de tokens, convierte el logout limpio ante sesión revocada en deadlock), AUTH-3/carrera logout↔refresh (MEDIUM→HIGH, verificación estructural completa), N-12 (LOW→MEDIUM).
- **Rebajados/refutados por la verificación:** "sin minify/R8" (refutado: activo por defecto, verificado en el SDK), "cambio de scopes en c82d431" (refutado: cosmético), F-40/NSPhotoLibrary (resuelto; verificado que no faltan más usage descriptions), "single-flight con carrera de registro" (refutado: asignación síncrona correcta), P-01/offline_access (retirado: nunca llegó a commitearse), exposición release de N-02 (matizada: doble mecanismo implícito la silencia en release; el riesgo real es debug/QA con datos reales).

---

## 19. Conclusión

**¿Está la aplicación realmente casi terminada?** El código de la app sí, con la misma salvedad que ayer: calidad y disciplina por encima de lo habitual en el cuerpo del producto, rodeadas de una configuración de release que sigue siendo la plantilla de `flutter create`, una red de seguridad de tests desmantelada y un conjunto acotado de funcionalidades que aparentan estar terminadas y no lo están.

**¿Qué impide considerarla terminada?** (1) Los 2 bloqueos de release (ids y firma — ambos demostrados hoy sobre el artefacto real); (2) el par F-04+F-05: el deadlock sigue y el commit de hoy lo hace alcanzable desde un escenario cotidiano (sesión revocada / rechazo del servidor con token localmente válido) que antes terminaba en logout limpio; (3) el patrón F-06 que convierte caídas del backend en "sin datos" oficiales; (4) las decisiones de producto pendientes sobre F-07…F-11; (5) para la rama actual en concreto, la deuda propia del shell (estado, back, i18n, accesibilidad) que conviene cerrar antes de validar el shell en QA.

**¿Riesgo de publicar en el estado actual?** No se puede publicar (Play rechazaría el paquete `com.example` firmado en debug). Si se corrigieran solo los bloqueos de plataforma y se publicara: congelaciones de app en cuanto un reintento post-401 falle o una sesión se revoque, datos administrativos falsos ("sin citas", "demanda ACTIVA", "sin título de familia numerosa" durante caídas), notificaciones administrativas que caducan sin poder atenderse, un flujo de aportación cuyo último paso nunca se ha visto funcionar, y una app cuya UI se mezclaría con inglés en dispositivos EN y cuyo tab bar es invisible para lectores de pantalla.

**Conjunto mínimo para avanzar con seguridad:** el bloque P0 — fix del deadlock + reversión de la regresión de refresh y del flag de logging (S), los 2 fixes de plataforma con sus decisiones (S/M), el `is`-check del router (XS), la plantilla anti-"sin datos" (M), los guards anti doble-registro y anti-carrera de logout (XS/S), tests en CI por defecto (XS) y saneo del toolchain (XS). Con eso, más las decisiones explícitas sobre las funcionalidades incompletas, el repositorio pasa de "APTO PARA QA CON BLOQUEOS CONOCIDOS" a candidato razonable a piloto controlado; P1 (shell/i18n/a11y, higiene de logs, biometría, red mínima de tests, flavors, pipeline iOS) queda como condición para publicación.
