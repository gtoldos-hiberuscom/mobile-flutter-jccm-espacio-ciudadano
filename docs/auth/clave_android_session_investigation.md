# Investigación — Aislamiento de la sesión web de Cl@ve en Android

**Fecha:** 2026-08-31 · **Alcance:** Android (iOS ya usa sesión efímera desde 2026-07)
**Documentos hermanos:**
[diseño del fork](historico/flutter_appauth_android_ephemeral_design.md) ·
[resultados de la POC](historico/flutter_appauth_android_ephemeral_poc_results.md) ·
[plan de mantenimiento](historico/flutter_appauth_fork_maintenance_plan.md) ·
antecedente: `documentation/appauth_clave_relogin_fix.md` (fix de julio 2026)

Etiquetas de evidencia: **CONFIRMED** (código/doc oficial/ejecución verificada) ·
**OBSERVED** (comportamiento visto en prueba) · **INFERRED** (deducción razonable) ·
**UNVERIFIED** (sin demostrar).

> **Actualización 2026-09-18 (#282296):** repetida la medición en PRE con el
> `ForceAuthn` de Cerbero ya desplegado. La conclusión de este documento se
> **revisada el mismo día**: la causa era que la app enviaba `prompt=login select_account`
> y Cerbero sólo reconoce `prompt=login`, así que el `ForceAuthn` salía en `false`.
> Corregido el parámetro, Cl@ve desafía **sin** aislamiento del navegador. Ver
> `clave_forceauthn_retest_2026-09.md`.

---

## Executive conclusion

- **Solución recomendada:** fork mínimo de `flutter_appauth` (2 ficheros, solo
  Android) que, cuando la app pide `ExternalUserAgent.ephemeralAsWebAuthenticationSession`
  (valor que la app **ya envía** hoy), lanza el flujo OAuth en una **Ephemeral
  Custom Tab** (androidx.browser 1.10.0 + Chrome ≥ 136) a través de los overloads
  públicos de AppAuth-Android 0.11.1 — sin fork de AppAuth, sin WebView, sin
  tocar la API Dart ni el código de la app.
- **Viabilidad:** ALTA. POC compilada y ejecutada: el aislamiento y la
  destrucción del cookie jar quedaron **OBSERVED** en runtime (Chrome 151,
  Android 17), incluida la prueba a través del camino real de AppAuth, y la
  pasarela de Cl@ve renderiza dentro de la pestaña efímera.
- **Principal evidencia:** AppAuth 0.11.1 expone `getAuthorizationRequestIntent(request,
  customTabsIntent)` y `getBrowserDescriptor()` (CONFIRMED en fuentes); el extra
  efímero llega intacto al navegador (CONFIRMED + OBSERVED); Chrome 151 estable
  lo soporta y lo declara de forma detectable incluso en Android 13 (OBSERVED).
- **Principal limitación:** hoy solo Chrome ofrece ephemeral CCT (otros
  navegadores: sin soporte conocido → error controlado y política de degradación
  en la app), y la identificación Cl@ve **completa** dentro del contexto efímero
  queda pendiente de QA con credenciales reales (UNVERIFIED, por método).
- **Riesgo:** bajo en código (diff aditivo, opt-in, rollback de una línea);
  medio en producto (pérdida deliberada de SSO — que este producto nunca
  aprovechó — y dependencia del parque de Chrome ≥ 136).

---

## Current implementation (repo, CONFIRMED)

Flujo real trazado en código:

```
Usuario → LandingPage → LoginUseCase → AuthRepositoryImpl.login()
  (lib/features/auth/3_data/auth_repository_impl.dart:25)
  · authorizeAndExchangeCode(AuthorizationTokenRequest(...))
  · promptValues: [login, select_account] + max_age=0 SIEMPRE (fix 2026-07)
  · externalUserAgent: ephemeralAsWebAuthenticationSession (efectivo SOLO en iOS)
        ↓ MethodChannel 'crossingthestreams.io/flutter_appauth'
flutter_appauth 12.0.0 → FlutterAppauthPlugin.java (Android)
  · performAuthorization → authorizationService.getAuthorizationRequestIntent(request)   ← SIN CustomTabsIntent (línea 468)
  · la clave 'externalUserAgent' del canal NUNCA se lee en Android
        ↓
AppAuth-Android 0.11.1
  · AuthorizationService (BrowserSelector.select → Chrome) → CustomTabsIntent por defecto
  · AuthorizationManagementActivity → startActivity(Custom Tab NORMAL, perfil de Chrome)
        ↓
Keycloak (realm 'usuarios', descubierto vía SSO_BASE_URL/SSO_REALM de config_*.json)
  → broker → pasarela Cl@ve (se-pasarela.clave.gob.es) → método (AEAT/GISS/certificado)
        ↓ redirect es.jccm.espaciociudadano://auth/callback
RedirectUriReceiverActivity (AppAuth, manifest del plugin con appAuthRedirectScheme)
  → onActivityResult → token exchange (PKCE S256) → tokens en flutter_secure_storage
```

Logout actual: `LogoutUseCase` → `AuthRepositoryImpl.logout()` → `endSession`
(RP-initiated logout con `id_token_hint` + `post_logout_redirect_uri`, también en
Custom Tab normal) y `AuthSessionController.clear()` (borra access/refresh/id
token y expiración de secure storage; generación monotónica anti-resurrección).
Guard de rutas: `lib/core/routing/session_guard.dart`.

## Root cause (por qué sobreviven las cookies)

1. Las Custom Tabs **comparten el perfil y el cookie jar de Chrome** (CONFIRMED,
   doc oficial de Custom Tabs). Todo cookie que la pasarela Cl@ve o sus IdPs de
   método pongan durante el login vive en el perfil de Chrome del dispositivo.
2. El logout de la app borra **su** estado (tokens) e invoca el end-session de
   **Keycloak**; ninguna de las dos cosas alcanza a las cookies de
   `*.clave.gob.es` / AEAT / GISS en Chrome (CONFIRMED por spec: RP-Initiated
   Logout no dice nada de IdPs upstream; ver Logout semantics).
3. La app no puede borrarlas: **no existe API** para que una app toque el
   almacén de cookies de Chrome (CONFIRMED; no confundir con
   `android.webkit.CookieManager`, que gobierna las WebViews de la propia app,
   un almacén distinto). El "Modelo B" (conservar y borrar después) es
   **inviable** en Android con Custom Tabs.
4. `prompt=login` + `max_age=0` (fix de julio) obligan a Keycloak a re-autenticar
   y, con Keycloak ≥ 24, se propagan como `ForceAuthn` SAML a Cl@ve — pero el
   **estado por-método** del lado Cl@ve (p. ej. el túnel SSL del IdP de
   certificados, la sesión AEAT/GISS) puede seguir "recordando" al usuario
   anterior y degradar la re-autenticación a una reconfirmación (CONFIRMED la
   mecánica del túnel de certificados por documentación de terceros —
   Gobierno de Canarias/Platino—; el detalle exacto por método: UNVERIFIED).

Conclusión: **Modelo A (contexto efímero desde el principio)** es el único
modelo técnicamente completo en Android. Modelo B queda descartado con evidencia.

## Dependency inventory (CONFIRMED)

| Componente | Declarado | Resuelto real |
|---|---|---|
| Flutter | `.fvmrc` 3.44.0 (local instalada: 3.41.7; ojo, la 3.44.0 no está en esta máquina) | — |
| flutter_appauth | `^12.0.0` | **12.0.0** (`pubspec.lock`); upstream estable: **12.1.0** (2026-08-29), Android idéntico |
| flutter_appauth_platform_interface | transitiva | 12.0.0 |
| net.openid:appauth | 0.11.1 (build.gradle del plugin) | **0.11.1** (`:app:dependencies`) — última release upstream, proyecto AppAuth-Android estancado |
| androidx.browser | 1.3.0 (POM de appauth) | **1.9.0** (otra dependencia del grafo la eleva; verificado con `./gradlew :app:dependencies` → `androidx.browser:browser:1.3.0 -> 1.9.0`). Las APIs efímeras YA están en el classpath del app; nadie las invoca |
| AGP / Gradle / Kotlin | 8.11.1 / 8.14 / 2.2.20 | cumplen los requisitos del fork (AGP ≥ 8.9.1, compileSdk 36) |
| compileSdk / minSdk | flutter defaults: 36 / 24 | — |
| Redirect | scheme `es.jccm.espaciociudadano` (manifestPlaceholder), custom scheme (no App Links) | — |

## flutter_appauth investigation (CONFIRMED, fuentes: pub.dev + GitHub)

- Proyecto: 12.0.0. Upstream: **12.1.0** (2026-08-29). Diferencias 12.0.0→12.1.0:
  solo iOS (custom browsers, SPM, AppAuth-iOS 2.1.0). Código Android **idéntico**.
- `preferEphemeralSession` **ya no existe**: eliminado en 8.0.0 y sustituido por
  el enum `ExternalUserAgent` (7 valores en 12.1.0, todos documentados como
  iOS/macOS). El README de upstream aún muestra la API antigua (desactualizado).
- El platform interface serializa `'externalUserAgent': index` **a todas las
  plataformas** (method_channel_mappers.dart:36,102); el plugin Android nunca lee
  la clave → hueco perfecto para un fork sin cambios Dart.
- Upstream **no tiene** soporte ni roadmap de ephemeral Android: ningún PR
  (abierto o cerrado) lo implementa; #668 (Auth Tab, 2026-07) sin respuesta;
  precedente #387 ("disable persist cookies on Android") cerrado en 2023 por el
  mantenedor: "el plugin está limitado por los SDKs nativos… sospecho que no es
  posible" — argumento hoy obsoleto (androidx.browser 1.9.0+).

## AppAuth Android investigation (CONFIRMED, fuentes 0.11.1 descargadas de Maven Central)

APIs que hacen viable el fork **sin tocar AppAuth**:

| API | Ubicación | Uso |
|---|---|---|
| `getBrowserDescriptor()` | `AuthorizationService.java:129` | saber QUÉ navegador usará AppAuth (packageName, version, useCustomTab) |
| `createCustomTabsIntentBuilder(Uri...)` | `AuthorizationService.java:137` | builder ligado a la sesión warmed-up del CustomTabManager |
| `getAuthorizationRequestIntent(request, customTabsIntent)` | `AuthorizationService.java:386` | overload que acepta nuestro intent efímero |
| `getEndSessionRequestIntent(request, customTabsIntent)` | `AuthorizationService.java:444` | ídem para logout |
| `prepareAuthorizationRequestIntent` | `AuthorizationService.java:549-577` | **clave**: si `useCustomTab`, usa `customTabsIntent.intent` tal cual (extras intactos) + `setPackage(browser)` + `setData(uri)`; si NO (`ACTION_VIEW`), los extras se PIERDEN → hay que tratar standalone como "sin soporte" |

PKCE, `state`, `nonce`, `AuthorizationManagementActivity`,
`RedirectUriReceiverActivity` y el token exchange no se tocan.

## AndroidX Browser investigation (CONFIRMED, fuentes 1.10.0 + release notes)

- Última estable: **1.10.0** (2026-03-25). API efímera **estable desde 1.9.0**
  (2025-07-30; experimental desde 1.9.0-alpha01, ene-2025).
- `CustomTabsIntent.Builder.setEphemeralBrowsingEnabled(boolean)`
  (`CustomTabsIntent.java:1651`) → extra
  `androidx.browser.customtabs.extra.ENABLE_EPHEMERAL_BROWSING`. Sin
  `@RequiresApi` en la variante CCT (verificado en fuentes 1.10.0).
- Detección: `CustomTabsClient.isEphemeralBrowsingSupported(context, provider)`
  (`CustomTabsClient.java:702`) — consulta PackageManager por la categoría
  `androidx.browser.customtabs.category.EphemeralBrowsing` del CustomTabsService
  del navegador. Existe también la variante de sesión
  (`CustomTabsSession#isEphemeralBrowsingSupported`).
- Requisitos de build: aar-metadata exige **compileSdk 36 + AGP 8.9.1** (1.9.0 y
  1.10.0); minSdk 23.
- **Fallback silencioso**: si el navegador no soporta el extra, abre una Custom
  Tab NORMAL sin error (javadoc: "si… y el navegador lo soporta"; guía oficial
  recomienda detectar y ofrecer fallback propio). Por eso el fork usa política
  "required + error".
- **Auth Tab** (`AuthTabIntent`, también estable en 1.9.0, con
  `setEphemeralBrowsingEnabled`): descartado como vía principal porque su
  redirect vuelve por **Activity Result API** (el navegador captura el redirect
  y lo devuelve como resultado), incompatible con la maquinaria
  AuthorizationManagementActivity/RedirectUriReceiverActivity de AppAuth →
  adoptarlo exige reimplementar el transporte de autorización fuera de AppAuth
  (implementación OAuth paralela) y en Chrome < 137 degrada devolviendo
  RESULT_CANCELED sin redirect. Beneficio marginal frente a CCT efímera
  (quita el botón minimizar/PiP); coste arquitectónico alto. (CONFIRMED fuentes
  + guía; la evaluación es INFERRED.)

## Browser selection (CONFIRMED, fuentes AppAuth 0.11.1)

`BrowserSelector.select()` (`browser/BrowserSelector.java:152`): recorre los
navegadores instalados **con el navegador por defecto primero**; devuelve el
primer match del `BrowserMatcher` con `useCustomTab=true` (si el matcher lo
permite), si no el primer full-browser. Determinista para un estado dado del
dispositivo. El fork consulta `getBrowserDescriptor()` **del mismo
`AuthorizationService`** justo antes de construir el intent (sin carrera
probe/launch). `AppAuthConfiguration.setBrowserMatcher` permitiría allowlist
(p. ej. solo navegadores con ephemeral) — no necesario en el diseño actual.

## Cookie/session semantics (qué aísla ephemeral)

Según la guía oficial de Chrome (CONFIRMED, citas literales) y verificado en
POC (OBSERVED):

- "cookies, cached files, history, credentials and other data exist only in the
  scope of the session's instance" — no comparte NADA con el perfil normal, ni
  hereda cookies existentes (OBSERVED: T2 de la POC).
- "When the Custom Tab Activity is closed, the data is deleted without a trace"
  (OBSERVED: T4 — cookie creada en sesión efímera desaparece en la siguiente).
- Dos sesiones efímeras consecutivas no comparten estado (INFERRED de lo
  anterior + OBSERVED T4).
- Reverse isolation: lo hecho en la tab efímera no contamina Chrome
  (OBSERVED: T5).
- Autofill/gestor de contraseñas dentro de la sesión efímera: detalle no
  documentado (la guía cita "credentials" como aislados) — **UNVERIFIED** si el
  usuario puede usar contraseñas guardadas de Chrome dentro de la tab efímera
  (impacto UX para Cl@ve Permanente).
- Cierre por Back / redirect / recreación: la destrucción se liga al cierre de
  la Activity de la tab (CONFIRMED doc); process-death a mitad de flujo:
  UNVERIFIED (no probado), aunque cualquier residuo moriría con el proceso de
  Chrome al no persistirse en disco (INFERRED).

## Cl@ve analysis

- Infraestructura (CONFIRMED por fuentes públicas): pasarela
  `se-pasarela.clave.gob.es` (selector de métodos), IdP de certificados
  `se-pasarela-ident.clave.gob.es`, IdPs de método: AEAT (Cl@ve PIN/Móvil),
  Seguridad Social/GISS (Cl@ve Permanente), @firma (certificados), eIDAS.
- La pasarela mantiene **sesión SSO propia** reutilizable entre organismos salvo
  `ForceAuthn` (CONFIRMED en doc RedIRIS/SIR2; vigencia exacta del doc: 2016,
  comportamiento actual de Cl@ve 2: parcialmente UNVERIFIED — el manual oficial
  de integración, CTT iniciativa 766, resultó inaccesible desde esta red).
- **Estado por-método**: documentado por el Gobierno de Canarias (Platino) que el
  logout de pasarela NO cierra el túnel SSL del IdP de certificados y "si se
  vuelve a elegir certificado se toma automáticamente el que ya se tenía"
  (CONFIRMED la cita; es exactamente la familia de bug observada).
- Logout de pasarela: existe `…/Proxy/LogoutAction` pero es SAML perfil STORK
  no estándar, **solo invocable por el SP (Keycloak) con petición firmada** —
  fuera del alcance de la app; interoperabilidad del SLO de Keycloak con ese
  perfil: dudosa (INFERRED). 
- Cl@ve Móvil: el navegador espera/consulta (QR + push a la app Cl@ve); no hay
  deep link de retorno documentado (CONFIRMED ayuda AEAT). En CCT efímera
  debería comportarse igual (misma página web) — UNVERIFIED empíricamente.
- Restricciones de user-agent (¿bloquea WebViews? ¿soporta CCT?): la POC
  demuestra que la pasarela **renderiza el selector en CCT efímera** (OBSERVED);
  bloqueo de WebViews: UNVERIFIED (sin documentación pública).
- La POC llegó hasta el selector real; **ninguna identificación se completó**
  (ver Unknowns).

## Logout semantics (mapa completo)

| Mecanismo | Qué cierra | Estado en la app | Con login efímero |
|---|---|---|---|
| LOCAL LOGOUT (`clear()`) | tokens/estado en secure storage | ✅ implementado | igual: **sigue siendo necesario** |
| TOKEN REVOCATION | refresh/access token en el AS (realm expone `revocation_endpoint`, CONFIRMED discovery) | ❌ no implementado (mitigado: el refresh muere con la sesión SSO de Keycloak) | recomendable como refuerzo, opcional |
| RP-INITIATED LOGOUT (`endSession`) | **solo** la sesión SSO del OP (Keycloak); nada upstream (CONFIRMED spec) | ✅ implementado (id_token_hint + post_logout_redirect_uri) | ver nota ↓ |
| BROWSER SESSION LOGOUT (cookies Cl@ve en Chrome) | — | ❌ **imposible desde la app** (CONFIRMED) | innecesario: nunca existieron en el perfil |
| EPHEMERAL SESSION DESTRUCTION | todo el estado web del flujo | — | ✅ automático al cerrar la tab |

**Nota sobre `endSession()` con login efímero:** la cookie de sesión de Keycloak
del login efímero murió con la pestaña, así que un `endSession` posterior en
OTRO contexto efímero abre un navegador sin esa cookie: cerraría "nada" en
términos de cookie de navegador. Ahora bien, Keycloak mantiene además la sesión
**server-side** (visible en admin console, ligada al refresh token): el
`id_token_hint` permite a Keycloak cerrarla aunque no haya cookie (INFERRED del
funcionamiento de Keycloak; matiz no crítico). Recomendación: con login efímero,
sustituir el `endSession` por navegador por **revocación del refresh token**
(`revocation_endpoint`, llamada HTTP directa sin navegador) + `clear()` local —
mejor UX (sin flash de navegador en logout) y mismo efecto server-side.
Decisión de producto; el fork soporta ambas.

## SSO impact

- Escenario A (hoy, roto): compartir cookie jar con Chrome = SSO accidental
  entre logins y con la web → el bug.
- Escenario B (recomendado): cada login = contexto virgen. **Se pierde el SSO**…
  que este producto **ya renunció a usar**: desde julio 2026 fuerza
  `prompt=login`+`max_age=0` en cada login (CONFIRMED código y doc del fix), e
  iOS ya es efímero. Pérdida funcional real: cero; coste: el usuario teclea
  credenciales en cada login (estado actual de facto).
- Escenario C (mantener SSO hasta logout y entonces destruir sesión web):
  **técnicamente imposible** en Android/CCT (no hay API para borrar cookies de
  Chrome; el logout de pasarela Cl@ve no es invocable por la app) — CONFIRMED.

## Compatibility

| Dimensión | Estado | Evidencia |
|---|---|---|
| Android 12–16+ | la feature depende del navegador, no del OS: Chrome 151 declara ephemeral en Android 13 físico y Android 17 emulador (OBSERVED). minSdk del proyecto (24) sin cambios | dumpsys en ambos |
| Chrome | feature desde 136 (2025); detección declarada desde 137; estable actual 151 ✓ | guía oficial + dumpsys |
| Samsung Internet / Edge / Firefox / Brave | **sin soporte conocido** de ephemeral CCT ni Auth Tab a fecha de hoy; caerán en `ephemeral_browsing_unavailable` | UNVERIFIED (ausencia de evidencia de soporte; detección en runtime lo resuelve por dispositivo) |
| Navegador standalone (useCustomTab=false) | extras se pierden con ACTION_VIEW → tratado como sin soporte (error controlado) | CONFIRMED fuentes AppAuth |
| iOS/macOS | sin cambios (ephemeral ASWebAuthenticationSession ya activo) | diff del fork |

## Enterprise devices (MDM)

- Navegador impuesto/Chrome deshabilitado: si el navegador elegido por AppAuth
  no declara la categoría → error controlado; la app decide (aviso "se requiere
  Chrome actualizado" o degradación explícita). Sin navegador CCT: ya hoy sería
  `no_browser_available`.
- Chrome gestionado (Chrome Enterprise): existen políticas que restringen
  incognito (`IncognitoModeAvailability`); si alguna bloquea también el modo
  efímero de CCT: **UNVERIFIED** (no encontrada documentación específica).
  Mitigación: la sonda `isEphemeralBrowsingAvailable` detecta la *declaración*,
  no la *política* → el plan de QA debe incluir un dispositivo gestionado.
- Work Profile: Chrome del perfil de trabajo es otra instancia con su propio
  estado; la mecánica es la misma (INFERRED).
- Recomendación operativa: registrar (telemetría) browser/version/supported en
  cada login para dimensionar el parque real antes del rollout.

## WebView fallback (PLAN B, no implementar salvo bloqueo)

- Técnicamente existe: androidx.webkit **ProfileStore/Profile** (multi-perfil,
  estable desde webkit 1.9.0, nov-2023): perfil `clave_auth` dedicado,
  `WebViewCompat.setProfile()` antes de la primera carga y
  `ProfileStore.deleteProfile()` en logout (borra cookies/storage/SW del perfil;
  gateado por `WebViewFeature.MULTI_PROFILE`). CONFIRMED en fuentes androidx.
- Pero: (1) **ningún plugin Flutter lo expone** (webview_flutter 4.14.x y
  flutter_inappwebview 6.x verificados: sin ProfileStore; el "incognito" de
  inappwebview borra cookies GLOBALES de la app — no aísla); habría que escribir
  plugin nativo propio; (2) **RFC 8252 §4/§8.12: "native apps MUST NOT use
  embedded user-agents"** — la app vería la credencial Cl@ve completa
  (keystrokes, cookies), inaceptable para una credencial gubernamental;
  (3) certificado cliente requiere `onReceivedClientCertRequest` manual, DNIe
  y apps externas requieren plumbing manual (`shouldOverrideUrlLoading`);
  (4) un IdP puede bloquear WebViews unilateralmente (precedente Google 2021,
  `disallowed_useragent`); Cl@ve hoy: UNVERIFIED.
- Veredicto: documentado como contingencia; **no** es el camino.

## Alternative protocol solutions

- `prompt=login` + `max_age=0`: **ya implementados** (julio 2026). CONFIRMED que
  Keycloak ≥ 24.0.0 los propaga como `ForceAuthn="true"` al broker SAML
  (PR keycloak#25983, milestone 24.0.0; antes, activar la opción estática
  "Force authentication" del IdP SAML en el admin console). **Acción para
  backend/Cerbero:** verificar versión de Keycloak y/o activar el flag estático
  — refuerza la re-autenticación aunque NO sustituye al aislamiento (el estado
  por-método de Cl@ve sobrevive a ForceAuthn; ver Root cause #4).
- `prompt=select_account`: sin efecto conocido en Cl@ve (no es un OP multi-cuenta). INFERRED.
  **Corregido 18/09/2026 (#282296): no era inocuo.** La extensión de Cerbero compara el
  parámetro `prompt` **entero** contra `"login"`, así que enviar `login select_account`
  hacía que la `AuthnRequest` saliera con `ForceAuthn="false"`. Con `prompt=login` a
  secas, Cl@ve vuelve a desafiar **sin** aislamiento del navegador — lo que invalida la
  conclusión de más abajo sobre que ninguna solución de protocolo basta. Ver
  `clave_forceauthn_retest_2026-09.md`.
- RP-Initiated Logout / revocación: cierran Keycloak, no Cl@ve (CONFIRMED spec).
- SLO SAML hacia Cl@ve desde Keycloak: perfil no estándar (STORK), solo SP
  firmado, interoperabilidad dudosa y aunque funcionara no limpia el estado
  por-método (certificados) — CONFIRMED/INFERRED.
- **Ninguna solución de protocolo elimina la cookie/estado de Cl@ve en el
  navegador compartido** → el aislamiento del user-agent es la única vía
  completa del lado app.

## Decision matrix (1–5, más alto = mejor)

| Opción | Control sesión | Seguridad OAuth | Compat. Cl@ve | Compat. Android | Esfuerzo | Mantenim. | Riesgo | UX | Testing | Upstream | Nota |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1. CCT actual (statu quo) | 1 | 5 | 5 | 5 | 5 | 5 | 2 | 3 | 5 | 5 | el bug persiste |
| 2. CCT + prompt/max_age (actual) | 2 | 5 | 4 | 5 | 5 | 5 | 3 | 3 | 4 | 5 | ya hecho; insuficiente (estado por-método) |
| **3. AppAuth + Ephemeral CCT (fork)** | **5** | **5** | **4** (selector OBSERVED; métodos UNVERIFIED) | **4** (Chrome ≥136) | **4** (~130 líneas) | **4** | **4** | **4** | **4** | **4** (#387/#668 reabribles) | **recomendada** |
| 4. AppAuth + Auth Tab | 5 | 4 | 3 | 3 (Chrome ≥137) | 2 (reimplementa transporte) | 2 | 2 | 4 | 3 | 3 | redirect incompatible con AppAuth |
| 5. Fork flutter_appauth (= mecánica de 3) | — | — | — | — | — | — | — | — | — | — | es el vehículo de la opción 3 |
| 6. Fork AppAuth-Android | 5 | 4 | 4 | 4 | 1 | 1 | 2 | 4 | 3 | 1 | innecesario: overloads públicos existen |
| 7. WebView normal | 4 | 1 | 2 | 4 | 2 | 2 | 1 | 2 | 3 | 1 | MUST NOT (RFC 8252) |
| 8. WebView perfil aislado | 5 | 1 | 2 | 3 | 1 (plugin propio) | 1 | 1 | 2 | 2 | 1 | plan B documentado |
| 9. Solo OIDC logout/revocación | 1 | 5 | 3 | 5 | 5 | 5 | 2 | 3 | 4 | 5 | no alcanza a Cl@ve |

## Recommendation

**Opción 3**: fork mínimo de `flutter_appauth` según
`historico/flutter_appauth_android_ephemeral_design.md`, con política *required* + error
tipado + sonda de capacidad, degradación decidida en Dart, y plan de PR
upstream. En paralelo (independiente del fork): pedir a backend la verificación
de versión de Keycloak / flag "Force authentication" del broker SAML de Cl@ve.

**Condiciones de despliegue** (del revisor adversarial, asumidas): (1) rama Dart
que maneje `ephemeral_browsing_unavailable` con decisión de producto (degradar
con aviso vs bloquear); (2) pin exacto del platform_interface + test del índice
del enum; (3) QA end-to-end con cada método de Cl@ve en CCT efímera (crítico:
Cl@ve Móvil con salto a app externa); (4) prueba en dispositivo con Chrome
gestionado por política; (5) issue/PR upstream para que el fork tenga fecha de
caducidad; (6) decidir respuesta al parque con navegador por defecto sin soporte
(telemetría → fallback Dart o `BrowserAllowList` en el fork).

## Verificación independiente (revisor adversarial, contexto fresco)

Mandato: refutar la propuesta. Veredicto global: **se sostiene técnicamente; sin
BLOCKERs de implementación** (todas las firmas de API verificadas contra las
fuentes reales; process-death cubierto porque `AuthorizationManagementActivity`
parcela el Intent completo con el extra dentro; sin carreras probe/launch; sin
fallbacks silenciosos dentro del diff). Hallazgos que SÍ cambian el plan:

| Severidad | Hallazgo | Acción |
|---|---|---|
| **BLOCKER de despliegue** (no del fork) | la app no maneja `ephemeral_browsing_unavailable`: hoy caería en `AuthException.unexpected` genérico → en dispositivos sin soporte el login quedaría roto sin mensaje ni alternativa | añadir rama Dart de fallback + decisión de producto ANTES del rollout (el código de error llega distinguible en `FlutterAppAuthPlatformException.code`) |
| MAJOR | acople al índice del enum (1): si upstream reordenase valores, se pediría efímero con otro índice y se abriría CCT **normal sin error** | pin **exacto** de `flutter_appauth_platform_interface` + test CI `ephemeralAsWebAuthenticationSession.index == 1` (recogido en el plan de mantenimiento) |
| MAJOR | AppAuth elige el navegador **por defecto del usuario**: con Samsung Internet/Firefox por defecto (CCT sí, ephemeral no) el login required falla siempre **aunque Chrome esté instalado** — relevante en parque Samsung España | dimensionar con telemetría; valorar ampliar el fork con `BrowserAllowList` que priorice navegadores con soporte ephemeral, o resolverlo como fallback en Dart |
| MAJOR | hueco de evidencia: ningún login Cl@ve completado end-to-end; el mayor riesgo es Cl@ve Móvil (salto a app externa: el estado efímero vive en memoria de Chrome; si el sistema mata su Activity durante el salto, el login se rompe a mitad) | plan de QA por método (ver Unknowns) |
| UNVERIFIED | la categoría EphemeralBrowsing es estática en el manifest del navegador; una política enterprise (p. ej. `IncognitoModeAvailability=disabled`) podría deshabilitar la función con la categoría aún declarada, y **no existe señal runtime post-lanzamiento** que confirme que la tab es efímera | prueba en dispositivo gestionado antes de asumir garantía en flotas MDM |
| MINOR | Chrome 136 exacto: feature sí, categoría no (llega en 137) → error required innecesario en ese único tramo | asumible |
| MINOR | transición: el primer logout efímero no limpia las cookies Cl@ve *antiguas* del perfil normal (quedan hasta expirar; ya no reutilizables por logins efímeros) | documentar |
| MINOR | el fork basado en 12.1.0 arrastra el upgrade iOS (AppAuth-iOS 2.0→2.1, custom browsers): retest humo iOS o rebasar el parche sobre el tag v12.0.0 | elegir en la adopción |
| MINOR | invocar el MethodChannel por nombre desde la app (sonda) se acopla a un interno sin contrato | preferible exponer la sonda en el Dart del fork |

## Unknowns (lo que sigue sin demostrar)

1. Identificación Cl@ve **completa** en CCT efímera, por método: Cl@ve
   Permanente, Cl@ve PIN/Móvil (QR/push), certificado, DNIe. → QA manual con
   credenciales de prueba (TESTS A–K del plan, ejecutar por método).
2. Certificado cliente (KeyChain) dentro del contexto efímero de Chrome.
3. Comportamiento con Chrome gestionado por MDM (políticas incognito) y parque
   real de versiones de Chrome de los ciudadanos.
4. Vigencia exacta del manual de integración Cl@ve v2.8.4 (ForceAuthn/SLO):
   descargarlo desde red española (CTT, iniciativa 766) y confirmarlo con el
   equipo de Cerbero.
5. Autofill/contraseñas guardadas de Chrome dentro de la sesión efímera (UX de
   Cl@ve Permanente).
6. Process death / recreación de Activity durante el flujo efímero (TEST G/H)
   — nota: el extra sí sobrevive a la recreación (Intent parcelado, CONFIRMED
   por el revisor); lo no probado es el comportamiento end-to-end.
7. Cuota real de dispositivos con navegador por defecto ≠ Chrome (Samsung
   Internet/Firefox) en el parque de usuarios de la app → dimensiona el impacto
   de la política *required*.
8. `endSession` efímero end-to-end (mecánicamente idéntico al login; sin
   ejecutar en la POC).
