# POC — Ephemeral Custom Tabs en `flutter_appauth` (Android): resultados

**Fecha:** 2026-08-31 · **Estado:** POC satisfactoria (ver límites en §8)
**Investigación asociada:** `docs/auth/clave_android_session_investigation.md`
**Diseño del fork:** `docs/auth/flutter_appauth_android_ephemeral_design.md`

## 1. Objetivo

Demostrar con código y ejecución real que un fork mínimo de `flutter_appauth`
(solo lado Android, sin tocar AppAuth-Android ni la API Dart) puede lanzar el
flujo de autorización OIDC en una **Ephemeral Custom Tab** cuyo cookie jar:

1. no hereda cookies del perfil normal de Chrome;
2. funciona con cookies dentro de la propia sesión (necesario para el
   handshake Keycloak/SAML);
3. se destruye al cerrar la pestaña (nada persiste entre dos sesiones);
4. no filtra cookies hacia el perfil normal de Chrome.

## 2. Entorno

| Componente | Valor |
|---|---|
| Host | macOS (Darwin 25.0.0), Flutter 3.41.7 (FVM), OpenJDK 21 |
| Dispositivo de prueba | Emulador Android 17 (SDK 37), Pixel 9 AVD |
| Navegador del dispositivo | Chrome `151.0.7922.174` (declara las categorías `EphemeralBrowsing` y `AuthTab` en su `CustomTabsService`, verificado con `dumpsys package`) |
| Contraste en dispositivo físico | Xiaomi (Android 13) con Chrome `151.0.7922.171`: declara las mismas categorías (solo se verificó la declaración, no se ejecutó la POC en él) |
| Base del fork | Clon de `MaikuB/flutter_appauth` master (commit `356a6ed`, release 12.1.0). El código Android del plugin es **byte-idéntico** al de la 12.0.0 publicada que usa el proyecto (verificado con `diff` contra `~/.pub-cache/hosted/pub.dev/flutter_appauth-12.0.0`) |
| Dependencias del fork | `net.openid:appauth:0.11.1` (sin cambios) + `androidx.browser:browser:1.10.0` (nueva) |
| App POC | Proyecto Flutter aislado (`poc_ephemeral_auth`, scheme propio `es.jccm.poc`) con dependencia por path al fork. **No se tocó la app real ni su configuración.** |

## 3. Diff aplicado

Diff completo: [`poc_evidence/fork_ephemeral.diff`](poc_evidence/fork_ephemeral.diff)
(2 ficheros, ~130 líneas añadidas). Resumen:

- `flutter_appauth/android/build.gradle`: `compileSdkVersion 35 → 36` (requisito
  de androidx.browser ≥ 1.9.0) y `implementation 'androidx.browser:browser:1.10.0'`.
- `FlutterAppauthPlugin.java`:
  - lee la clave `externalUserAgent` del map del MethodChannel (el platform
    interface **ya la envía** a todas las plataformas como índice del enum; el
    plugin Android estándar la ignora);
  - si vale `1` (`ExternalUserAgent.ephemeralAsWebAuthenticationSession`):
    comprueba soporte (`AuthorizationService.getBrowserDescriptor()` +
    `CustomTabsClient.isEphemeralBrowsingSupported(context, pkg)`), construye
    `createCustomTabsIntentBuilder(requestUri).setEphemeralBrowsingEnabled(true).build()`
    y lo pasa a los overloads públicos de AppAuth 0.11.1
    `getAuthorizationRequestIntent(request, customTabsIntent)` /
    `getEndSessionRequestIntent(request, customTabsIntent)`;
  - si se pidió efímero y el navegador **no** lo soporta → error controlado
    `ephemeral_browsing_unavailable` (nunca fallback silencioso);
  - método de canal adicional `isEphemeralBrowsingAvailable` (sonda de capacidad
    invocable desde Dart sin tocar el paquete Dart);
  - log diagnóstico (tag `FlutterAppauthEphemeral`): navegador, versión,
    `usesCustomTab`, `ephemeralSupported`. Sin URIs, tokens ni datos personales.

## 4. Comandos ejecutados (reproducibles)

```bash
# Fork (rama poc/android-ephemeral-cct sobre el clon de upstream master)
git checkout -b poc/android-ephemeral-cct && <aplicar diff>

# App POC
flutter create --platforms=android --org es.jccm.poc poc_ephemeral_auth
# pubspec: flutter_appauth -> path al fork
# build.gradle.kts: manifestPlaceholders["appAuthRedirectScheme"] = "es.jccm.poc"
flutter build apk --debug          # → BUILD OK (compila contra AppAuth 0.11.1 + browser 1.10.0)
adb install -r app-debug.apk

# Sonda y pruebas (drive por adb: input tap / am start con extras / screencap / logcat)
```

## 5. Resultados

### 5.1 Compilación — ✅

`flutter build apk --debug` compila sin errores: los overloads de dos argumentos
y `getBrowserDescriptor()` existen en AppAuth 0.11.1 y las APIs efímeras existen
en androidx.browser 1.10.0. Gradle resuelve `browser 1.3.0 → 1.10.0` sin
conflicto.

### 5.2 Sonda de capacidad — ✅ (OBSERVED)

```
POC_EPHEMERAL: probe: {browserVersion: 151.0.7922.174,
  ephemeralBrowsingSupported: true, browserPackage: com.android.chrome,
  usesCustomTab: true}
```

### 5.3 Launch real contra Keycloak UAT + Cl@ve — ✅ (OBSERVED)

`authorizeAndExchangeCode` con `externalUserAgent: ephemeralAsWebAuthenticationSession`
(discovery del realm UAT del proyecto, solo lectura, sin introducir credenciales):

```
FlutterAppauthEphemeral: ephemeralRequested=true browserPackage=com.android.chrome
  browserVersion=151.0.7922.174 usesCustomTab=true ephemeralSupported=true
```

La Custom Tab efímera abre, Keycloak redirige a la **pasarela real de Cl@ve**
(`pasarela.clave.gob.es`) y el selector de métodos (Cl@ve Móvil / eIdentifier /
Cl@ve Permanente) **renderiza correctamente** dentro del contexto efímero.
Captura: [`poc_evidence/poc_login_ephemeral.png`](poc_evidence/poc_login_ephemeral.png).
No se completó ninguna identificación (requiere credenciales reales → queda para
QA, ver §8).

### 5.4 Cancelación con Back (TEST F) — ✅ (OBSERVED)

```
POC_EPHEMERAL: login CANCELLED by user (clean callback)
```

Back cierra la pestaña efímera y la app recibe
`FlutterAppAuthUserCancelledException` — la semántica de cancelación de AppAuth
no cambia.

### 5.5 Aislamiento de cookies (httpbin.org como testigo) — ✅ (OBSERVED)

| # | Acción | Resultado | Captura |
|---|---|---|---|
| T1 | CCT **normal** → `/cookies/set?poc=persistente` | `{"poc": "persistente"}` — cookie viva en el perfil de Chrome | `t1_normal_set.png` |
| T2 | CCT **efímera** → `/cookies` | `{}` — **no hereda** la cookie del perfil (analogía TEST A/K) | `t2_ephemeral_read.png` |
| T3 | CCT **efímera** → `/cookies/set?poc=efimera` | `{"poc": "efimera"}` — las cookies funcionan **dentro** de la sesión | `t3_ephemeral_set.png` |
| T4 | cerrar y abrir **nueva** CCT efímera → `/cookies` | `{}` — la cookie efímera fue **destruida** al cerrar (analogía TEST B/E) | `t4_ephemeral_read2.png` |
| T5 | CCT **normal** → `/cookies` | `{"poc": "persistente"}` y **sin** `poc=efimera` — nada se filtró al perfil (analogía TEST C) | `t5_normal_read.png` |

### 5.6 El flag efímero surte efecto por el camino real de AppAuth — ✅ (OBSERVED)

Para descartar que el aislamiento solo se diera con un `CustomTabsIntent` crudo,
se repitió el cookie-echo **a través del fork** (AppAuth
`getAuthorizationRequestIntent`, apuntando `authorizationEndpoint` a
`https://httpbin.org/cookies` vía `serviceConfiguration`):

| Modo | Resultado | Captura |
|---|---|---|
| `asWebAuthenticationSession` (normal) | la pestaña **ve** `poc=persistente` → cookie jar compartido (comportamiento actual de la app, causa raíz del bug) | `t6_normal_appauth.png` |
| `ephemeralAsWebAuthenticationSession` | la pestaña ve `{}` → el extra efímero **se aplica** en el intent que construye AppAuth | `t6_ephemeral_appauth.png` |

## 6. Qué QUEDA demostrado

1. AppAuth-Android 0.11.1 acepta un `CustomTabsIntent` personalizado sin fork
   (overloads públicos) y el extra `ENABLE_EPHEMERAL_BROWSING` llega intacto al
   navegador (CONFIRMED en código + OBSERVED en runtime).
2. Chrome 151 estable soporta ephemeral browsing y lo declara de forma
   detectable (categoría de servicio), también en Android 13 (dispositivo físico).
3. El aislamiento de cookies es real y bidireccional, y la destrucción al cerrar
   la sesión es efectiva (base del "logout limpio").
4. La pasarela de Cl@ve carga y muestra el selector de métodos dentro de una
   CCT efímera.
5. El cambio no requiere tocar la API Dart ni el código de la app
   (`ExternalUserAgent.ephemeralAsWebAuthenticationSession` ya se envía hoy).
6. La cancelación (Back) conserva la semántica estándar del plugin.

## 7. Qué NO queda demostrado (UNVERIFIED)

1. **Identificación Cl@ve completa** dentro de la CCT efímera (Cl@ve Permanente,
   Cl@ve PIN/Móvil, certificado, DNIe): requiere credenciales reales y
   dispositivo con la app Cl@ve. No extrapolable entre métodos.
2. **Certificado electrónico en modo efímero**: si Chrome ofrece el KeyChain de
   Android dentro de un contexto efímero (y si el "túnel SSL recordado"
   documentado por terceros desaparece con la pestaña).
3. Comportamiento con **navegador por defecto distinto de Chrome** (Samsung
   Internet, Edge, Firefox): en los dispositivos de prueba solo había Chrome.
   El camino `ephemeral_browsing_unavailable` no se ejerció en runtime (sí está
   cubierto por diseño y es unit-testable).
4. **Process death / recreación de Activity** durante el flujo efímero (TEST G/H):
   no ejecutado en la POC; el fork no toca ese código (heredado de AppAuth).
5. El comportamiento equivalente en navegadores gestionados por MDM.

## 8. Artefactos

- Fork: clon local de `MaikuB/flutter_appauth`, rama `poc/android-ephemeral-cct`
  (scratchpad de la sesión; el diff está guardado en `poc_evidence/fork_ephemeral.diff`).
- App POC instalada en el emulador como `es.jccm.poc.poc_ephemeral_auth`
  (desinstalable con `adb uninstall es.jccm.poc.poc_ephemeral_auth`).
- Capturas y diff: `docs/auth/poc_evidence/`.
- La app real, sus configs y su Keycloak **no fueron modificados**.
