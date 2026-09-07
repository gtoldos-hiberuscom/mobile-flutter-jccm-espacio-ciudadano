# Diseño — Fork mínimo de `flutter_appauth`: Ephemeral Custom Tabs en Android

> **IMPLEMENTADO** el 2026-08-31: fork vendorizado en `packages/flutter_appauth`
> (base 12.0.0, ver su `CHANGELOG_JCCM.md`) + política de degradación con aviso
> en la capa Dart (`LoginUseCase`/`LogoutUseCase`, reintento no-efímero ante
> `AuthException.ephemeralUnavailable`; aviso `loginIsolationDegradedWarning`
> en la landing). Pin exacto de `flutter_appauth_platform_interface: 12.0.0` y
> tests de contrato en `test/features/auth/` (índice del enum, mapeo del error,
> degradación). Pendiente: prueba real con identificación Cl@ve en dispositivo.

**Fecha:** 2026-08-31 · **POC validada:** `flutter_appauth_android_ephemeral_poc_results.md`
**Ámbito:** SOLO el lado Android del paquete `flutter_appauth`. AppAuth-Android,
el platform interface Dart, la implementación iOS/macOS y la app quedan intactos.

## 1. Arquitectura

```
Flutter (app, SIN cambios: ya envía ExternalUserAgent.ephemeralAsWebAuthenticationSession)
   │  MethodChannel 'crossingthestreams.io/flutter_appauth'
   │  (el platform interface 12.x YA serializa 'externalUserAgent': index a TODAS las plataformas)
   ▼
FORK flutter_appauth — FlutterAppauthPlugin.java            ← ÚNICO punto de cambio
   │  lee 'externalUserAgent'; si == 1 (ephemeral…):
   │    1. BrowserDescriptor b = authorizationService.getBrowserDescriptor()
   │    2. supported = b.useCustomTab && CustomTabsClient.isEphemeralBrowsingSupported(ctx, b.packageName)
   │    3a. supported  → cti = createCustomTabsIntentBuilder(requestUri)
   │                             .setEphemeralBrowsingEnabled(true).build()
   │                      intent = getAuthorizationRequestIntent(request, cti)   ← overload público AppAuth 0.11.1
   │    3b. !supported → error 'ephemeral_browsing_unavailable' (SIN fallback silencioso)
   ▼
AppAuth-Android 0.11.1 oficial (sin fork)
   │  prepareAuthorizationRequestIntent: si useCustomTab, usa customTabsIntent.intent
   │  (los extras del intent — incl. ENABLE_EPHEMERAL_BROWSING — pasan INTACTOS;
   │   setPackage(browser) + setData(requestUri)); AuthorizationManagementActivity
   │   y RedirectUriReceiverActivity sin cambios → PKCE/state/nonce/redirect intactos
   ▼
Chrome ≥ 136 → Ephemeral Custom Tab (cookie jar propio, destruido al cerrar)
```

Los mismos pasos aplican a `endSession` con `getEndSessionRequestIntent(request, cti)`.

## 2. API Dart

**Decisión: cero cambios en Dart.** Fundamento (verificado en código):

- `flutter_appauth_platform_interface` 12.0.0/12.1.0,
  `lib/src/method_channel_mappers.dart` líneas 36 y 102: el map del canal ya
  incluye `'externalUserAgent': externalUserAgent?.index` en authorize **y** en
  endSession, en todas las plataformas.
- `FlutterAppauthPlugin.java` estándar nunca lee esa clave → leerla en el fork
  es un cambio **aditivo y no-breaking**: las apps que no piden efímero
  (índice ≠ 1 o null) conservan el comportamiento actual byte a byte.
- La app JCCMEC ya pasa `ExternalUserAgent.ephemeralAsWebAuthenticationSession`
  en login y endSession desde julio de 2026 (`auth_repository_impl.dart:37,109`)
  → **al adoptar el fork no hay que tocar ni una línea de la app** (salvo,
  opcionalmente, manejar el nuevo código de error).

Semántica resultante del enum en Android (documentar en el README del fork):

| Valor (índice) | iOS/macOS (sin cambios) | Android fork |
|---|---|---|
| `asWebAuthenticationSession` (0) | ASWebAuthenticationSession | Custom Tab normal (= comportamiento actual) |
| `ephemeralAsWebAuthenticationSession` (1) | ASWebAuthenticationSession efímera | **Ephemeral Custom Tab; error si no hay soporte** |
| `sfSafariViewController` (2) y `customBrowser*` (3–6) | según upstream | Custom Tab normal (ignorado, como hoy) |

### Sonda de capacidad (opcional pero recomendada)

Nuevo método de canal `isEphemeralBrowsingAvailable` →
`{browserPackage, browserVersion, usesCustomTab, ephemeralBrowsingSupported}`.
La app puede invocarlo **sin fork del paquete Dart**:

```dart
const MethodChannel('crossingthestreams.io/flutter_appauth')
    .invokeMethod<Object?>('isEphemeralBrowsingAvailable');
```

Uso: decidir ANTES del login qué política aplicar y qué avisar al usuario
(p. ej. dispositivo sin Chrome moderno → mensaje "actualiza Chrome" o degradar
con aviso explícito). También sirve de telemetría (% de parque con soporte).

Matices del revisor adversarial (asumidos):

- **Pin exacto** de `flutter_appauth_platform_interface` en la app + test CI
  `ExternalUserAgent.ephemeralAsWebAuthenticationSession.index == 1`: si
  upstream reordenase el enum, el fork abriría CCT normal **sin error** (fuga
  silenciosa). El pin y el test lo hacen imposible.
- Invocar el canal por nombre desde la app funciona pero se acopla a un interno:
  si el fork se consolida, exponer la sonda como método Dart del fork.
- La app DEBE añadir manejo de `ephemeral_browsing_unavailable` en
  `_mapPlatformException` antes del rollout (hoy caería en
  `AuthException.unexpected`): es la rama donde vive la política de degradación.

## 3. Cambios exactos (fichero → clase → método → cambio)

Diff real completo: `docs/auth/poc_evidence/fork_ephemeral.diff` (~130 líneas).

### 3.1 `flutter_appauth/android/build.gradle`

| Cambio | Motivo |
|---|---|
| `compileSdkVersion 35` → `36` | aar-metadata de androidx.browser 1.9.0+ exige `minCompileSdk=36` |
| + `implementation 'androidx.browser:browser:1.10.0'` | APIs `setEphemeralBrowsingEnabled` / `isEphemeralBrowsingSupported` (estables desde 1.9.0; 1.10.0 es la estable actual, 2026-03-25). AppAuth declara `browser:1.3.0` (api) → Gradle resuelve al mayor sin conflicto. El host debe usar AGP ≥ 8.9.1 (el proyecto usa 8.11.1) |

### 3.2 `FlutterAppauthPlugin.java` (clase `FlutterAppauthPlugin`)

| Método | Cambio |
|---|---|
| (campos) | + `private Integer externalUserAgent;` (mismo patrón que el campo `clientSecret` existente) + constantes `EPHEMERAL_EXTERNAL_USER_AGENT = 1`, `EPHEMERAL_BROWSING_UNAVAILABLE_ERROR_CODE` |
| `processAuthorizationTokenRequestArguments` | + `externalUserAgent = (Integer) arguments.get("externalUserAgent");` |
| `processEndSessionRequestArguments` | ídem |
| `onMethodCall` | + case `isEphemeralBrowsingAvailable` (síncrono, no usa `pendingOperation`) |
| **nuevo** `createEphemeralCustomTabsIntentIfRequested(AuthorizationService, Uri)` | núcleo: devuelve `null` si no se pidió efímero; detecta soporte; construye el `CustomTabsIntent` efímero con el builder de AppAuth (sesión warmed-up incluida); si se pidió y no hay soporte → `finishWithError(ephemeral_browsing_unavailable)` + excepción interna para abortar el launch. Log diagnóstico sin datos sensibles |
| `performAuthorization` | usa el helper; si devuelve intent → overload `getAuthorizationRequestIntent(request, cti)`; si `null` → camino actual sin cambios |
| `performEndSessionRequest` | ídem con `getEndSessionRequestIntent(request, cti)` |
| **nuevo** `getEphemeralBrowsingAvailability()` | implementación de la sonda |

Pseudodiff del punto crítico (idéntico al diff real):

```java
 AuthorizationService authorizationService = getAuthorizationService();
 try {
+  AuthorizationRequest authRequest = authRequestBuilder.build();
+  CustomTabsIntent ephemeralCustomTabsIntent =
+      createEphemeralCustomTabsIntentIfRequested(authorizationService, authRequest.toUri());
   Intent authIntent =
-      authorizationService.getAuthorizationRequestIntent(authRequestBuilder.build());
+      ephemeralCustomTabsIntent != null
+          ? authorizationService.getAuthorizationRequestIntent(authRequest, ephemeralCustomTabsIntent)
+          : authorizationService.getAuthorizationRequestIntent(authRequest);
   mainActivity.startActivityForResult(authIntent, exchangeCode ? RC_AUTH_EXCHANGE_CODE : RC_AUTH);
+} catch (EphemeralBrowsingUnavailableException ex) {
+  // finishWithError ya emitido con ephemeral_browsing_unavailable
 } catch (ActivityNotFoundException ex) { ...
```

## 4. Detección de capacidad del navegador

- `AuthorizationService.getBrowserDescriptor()` (público en AppAuth 0.11.1,
  `AuthorizationService.java:129`) expone **el navegador que AppAuth va a usar**
  (mismo `BrowserSelector.select()` determinista: primero el navegador por
  defecto con soporte Custom Tabs). No hay carrera probe/launch porque la
  detección se hace **dentro del mismo `AuthorizationService`** justo antes de
  construir el intent, no en un paso separado.
- `CustomTabsClient.isEphemeralBrowsingSupported(context, pkg)`
  (androidx.browser 1.10.0, `CustomTabsClient.java:702`): consulta por
  `PackageManager` si el `CustomTabsService` del navegador declara la categoría
  `androidx.browser.customtabs.category.EphemeralBrowsing`. Sin conexión al
  servicio. La visibilidad de paquetes (Android 11+) ya está cubierta por el
  `<queries>` del manifest de la app real (acción
  `android.support.customtabs.action.CustomTabsService`).
- Guardas adicionales: `browser == null` (sin navegador) y
  `useCustomTab == false` (navegador standalone vía `ACTION_VIEW`, donde el
  extra se perdería) cuentan como **no soportado** → error, nunca degradación
  silenciosa.

## 5. Política de fallback

| Política | Comportamiento | Decisión |
|---|---|---|
| Preferred (efímero si se puede, normal si no) | reintroduce silenciosamente el bug exacto que se quiere matar | ❌ descartada como default |
| **Required (elegida, en el plugin)** | efímero o error `ephemeral_browsing_unavailable`; **la política de degradación vive en Dart** (la app decide) | ✅ |
| Required con degradación en la app | al capturar el error, la app puede reintentar con `asWebAuthenticationSession` mostrando un aviso ("no se puede garantizar sesión limpia") o bloquear con "actualiza Chrome" | recomendación de producto, fuera del fork |

El fork implementa exclusivamente el **mecanismo** (required + error tipado +
sonda); la **política** queda en la capa Dart de la app, donde ya existe el
mapeo de `FlutterAppAuthPlatformException` (`auth_repository_impl._mapPlatformException`).

**Caso "navegador por defecto sin soporte con Chrome instalado"** (Samsung
Internet/Firefox como default): AppAuth elige el navegador por defecto del
usuario, así que la política required fallaría aunque Chrome esté disponible.
Dos resoluciones posibles, a decidir con datos de telemetría: (a) fallback en
Dart (aviso + reintento normal), o (b) ampliación opcional del fork con un
`BrowserMatcher`/`BrowserAllowList` de AppAuth que priorice navegadores con la
categoría EphemeralBrowsing cuando se pide efímero (AppAuth lo soporta vía
`AppAuthConfiguration.setBrowserMatcher`; cambio igualmente localizado).

## 6. Errores

| Código | Cuándo | Tratamiento sugerido en la app |
|---|---|---|
| `ephemeral_browsing_unavailable` (nuevo) | efímero pedido y navegador sin soporte / sin navegador CCT / standalone | nueva variante de `AuthException` → o degradar con aviso o pedir actualizar Chrome |
| resto (`authorize_and_exchange_code_failed`, `null_intent`, `user_cancelled`…) | sin cambios | sin cambios |

## 7. Compatibilidad

| Requisito | Valor | Fuente |
|---|---|---|
| androidx.browser | ≥ 1.9.0 (API efímera estable); fork usa 1.10.0 | release notes androidx + fuentes 1.10.0 |
| compileSdk del plugin | 36 | aar-metadata browser 1.9.0/1.10.0 |
| AGP del host | ≥ 8.9.1 (proyecto: 8.11.1 ✓) | aar-metadata |
| minSdk | sin cambio (plugin 24; browser exige 23) | manifests |
| Navegador | Chrome ≥ 136 (feature) / ≥ 137 (declaración detectable); otros navegadores: sin soporte conocido a fecha de hoy → caerán en el error controlado | guía Chrome + dumpsys en dispositivos |
| iOS/macOS | sin cambios (el fork no toca `ios/`/`macos/`) | diff |
| flutter_appauth base | 12.0.0 y 12.1.0 tienen el MISMO código Android (diff byte a byte) → el fork basado en 12.1.0 sirve para ambos | verificado |

## 8. Testing

**Unit (Android, Robolectric o instrumented):**
- `externalUserAgent` null / 0 / 2..6 → se usa el overload de 1 argumento (sin extra).
- `externalUserAgent == 1` + navegador con categoría → intent con
  `EXTRA_ENABLE_EPHEMERAL_BROWSING == true` y paquete correcto.
- `externalUserAgent == 1` + sin categoría / sin navegador / `useCustomTab=false`
  → `ephemeral_browsing_unavailable`, `pendingOperation` liberado y relanzable.
- `isEphemeralBrowsingAvailable` → map correcto en los cuatro escenarios.

**Dart (sin cambios de código, tests de contrato):**
- serialización del request (ya cubierta upstream), mapeo del nuevo código de
  error a `AuthException`.

**Regresión manual (matriz mínima):** authorize / authorizeAndExchangeCode /
token / refresh / endSession en (a) modo normal, (b) modo efímero, (c) iOS.

**QA con Cl@ve real (pendiente, ver POC §7):** los TESTS A–K del plan de
investigación, por método de Cl@ve (Permanente, PIN/Móvil, certificado, DNIe).

## 9. Estrategia upstream

- Issue relacionado abierto sin respuesta: MaikuB/flutter_appauth#668 (Auth Tab).
  Precedente directo #387 ("disable persist cookies on Android") cerrado en 2023
  porque el SDK nativo no lo permitía **entonces** — hoy sí (androidx.browser 1.9+).
- Propuesta de PR upstream: misma mecánica del fork, pero probablemente con
  política **preferred** por defecto o un flag explícito
  (`AndroidEphemeralBrowsingPolicy { disabled, preferred, required }`) para no
  cambiar el comportamiento de apps existentes que ya envían el valor efímero
  pensando solo en iOS. Ese matiz (breaking-change potencial) es la única
  diferencia esperable entre nuestro fork y lo aceptable upstream.
- Mientras tanto: fork con diff mínimo → rebase trivial (ver
  `flutter_appauth_fork_maintenance_plan.md`).
