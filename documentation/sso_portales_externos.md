# SSO con portales externos desde la app (Empleo CLM, Educamos CLM, Carpeta Salud)

**Estado:** **resuelto y validado en las dos plataformas** (18/09/2026). Lo que sigue conserva el
análisis porque explica el porqué de cada decisión, pero ya no es una propuesta.
**Fecha:** 2026-09-18 (reescribe el análisis del 17/09) · **Tickets:** JCCMEC ·
gestproy #282847 (sesión de Cl@ve) y #282296 (causa real del bug de reautenticación).

> **Por qué se reescribió.** La primera versión partía de que el login de la app corría en una
> pestaña de navegador aislada en **las dos** plataformas, y de ahí concluía que no había nada
> que compartir con el navegador del sistema. El 18/09 se retiró el aislamiento de Android: el
> bug que lo motivaba tenía otra causa —la app enviaba `prompt=login select_account` y Cerbero
> sólo reconoce `prompt=login`, así que la `AuthnRequest` hacia Cl@ve salía con
> `ForceAuthn="false"`— y, corregida, dejó de hacer falta
> (`../docs/auth/clave_forceauthn_retest_2026-09.md`). Eso cambia el diagnóstico en Android y el
> coste de una de las opciones, así que el documento se rehace en vez de parchearse.

> ## ✅ Resultado, medido el 18/09/2026 en PRE
>
> **Android** — los dos portales abren ya identificados, sin tocar código. Actúan dos capas
> distintas: **Empleo** por el `check-sso` silencioso de Keycloak (su cliente vive en el realm
> `usuarios`, el mismo que la app — pregunta que estaba abierta y queda respondida), y **Educamos**
> por la ventana de 60 minutos de la pasarela Cl@ve, vía su `kc_idp_hint`.
>
> **iOS** — resuelto con la **Opción 2 bis** (§6): el login pasa a
> `ExternalUserAgent.sfSafariViewController` y los dos portales se abren con
> `LaunchMode.inAppBrowserView`, que comparten el almacén propio de la app. Validado en dispositivo,
> **incluido el método de certificado**. No hizo falta ningún fork: el agente lo trae la librería
> publicada.
>
> **Lo que se acepta a cambio**: iOS deja de tener sesión efímera y el estado de Cl@ve sobrevive
> entre logins dentro de ese almacén —igual que en Android—, porque quien garantiza la
> reautenticación es el `ForceAuthn` que Cerbero propaga desde `prompt=login`. A favor: ese almacén
> **no se mezcla con Safari** y en iOS 16+ se puede vaciar al cerrar sesión, cosa imposible en
> Android.
>
> **Nota de entorno**: durante las pruebas hubo lentitud y un error genérico de la pasarela
> («null»). No era del agente: el mismo enlace iba igual de lento en el Safari del dispositivo, y
> apunta al camino por VPN hacia Cl@ve. Conviene tenerlo presente al medir tiempos.

## 1. Qué reporta el cliente

Probando en PRE, el cliente observa que en la **web** de Espacio Ciudadano
(`espaciociudadano-pre.jccm.es`) los enlaces de interés a portales integrados con Cerbero abren el
destino **ya identificado**:

- Empleo CLM → `https://empleabilidad-pre.cm-pre.jccm.es/`
- Educamos CLM → authorize de Cerbero, realm `educacion`, cliente `edu-educamos-fo`,
  `kc_idp_hint=clavesp-saml`
- (En preparación) Carpeta Salud del SESCAM, con la misma intención de SSO.

En la **app**, esos mismos enlaces abren el portal **sin identificar**. El cliente sospecha que es
«porque se abre fuera de la APP, en el navegador, por lo que no tiene el contexto del token de
Cerbero».

El síntoma está bien diagnosticado. La causa es más específica, y condiciona la solución.

## 2. Causa raíz

### 2.1 Los enlaces salen al navegador del sistema, sin nada adjunto

`lib/features/external_links/3_data/url_launcher_external_link_launcher.dart` y
`lib/features/external_links/2_presentation/external_navigation_confirmation.dart` abren con
`LaunchMode.externalApplication`: sin token, sin cabecera, sin parámetro. Los tokens de la app
viven en `flutter_secure_storage` (`lib/core/storage/secure_storage.dart`), no en el navegador.

### 2.2 Una app no puede sembrar cookies en el navegador del sistema

Ni Android ni iOS exponen API para que una aplicación escriba en el almacén de cookies de
Chrome/Safari. **No es un defecto de la app: es una invariante de plataforma.** Cualquier app
nativa de cualquier proveedor se comporta igual.

### 2.3 Y la sesión con la que se identifica el ciudadano sólo sobrevive en Android

Aquí es donde cambió el análisis. La app pide sesión efímera al abrir el flujo OIDC
(`lib/features/auth/3_data/auth_repository_impl.dart`):

```dart
externalUserAgent: ExternalUserAgent.ephemeralAsWebAuthenticationSession,
```

- **iOS/macOS**: hasta el 18/09 era `ASWebAuthenticationSession` efímera, que no compartía nada con
  Safari — y por eso el SSO no era posible. **Hoy usa `SFSafariViewController`**
  (`ExternalUserAgent.sfSafariViewController`): sigue sin mezclarse con Safari, pero guarda en un
  almacén **propio de la app** que comparte con las pestañas que la propia app abre. Ahí está el
  SSO.
- **Android**: el plugin **ignora** ese argumento —no implementa navegación efímera—, así que el
  login abre una Custom Tab normal, contra el perfil de Chrome del ciudadano. Entre agosto y el
  18/09/2026 un fork vendorizado sí lo forzaba; se retiró (§5).

**Consecuencia, distinta por plataforma:**

| | ¿Dónde queda la sesión de Cerbero / Cl@ve tras el login? | ¿La ven los portales? |
|---|---|---|
| **iOS** | En el almacén **propio de la app** (`SFSafariViewController`), no en Safari | **Sí**, si se abren con `LaunchMode.inAppBrowserView` |
| **Android** | En el navegador del sistema, como cualquier web | **Sí** |

En iOS el aislamiento respecto de Safari se mantiene; lo que se comparte es sólo entre la app y las
pestañas que ella misma abre. En Android la sesión vive en el navegador del ciudadano.

## 3. Las tres sesiones que se confunden

Verificado contra el código a 18/09/2026.

### 3.1 La sesión web de identificación

La que ve Cl@ve y la que produciría el SSO. Su comportamiento por plataforma es el de §2.3.

> **Salvedad conocida (iOS):** con **Acceso Guiado** activo, `ASWebAuthenticationSession` no
> arranca —limitación de Apple, rdar://40809553— y el plugin cae **en silencio** a
> `SFSafariViewController`, que sí comparte datos con el contenedor de la app. Escenario poco
> común, pero es un hueco real del aislamiento de iOS.

### 3.2 Los tokens de la app — esto sí se almacena

En `lib/core/storage/secure_storage.dart`, con dos niveles de protección:

| Dato | Nivel | iOS | Android |
|---|---|---|---|
| access token, id token, caducidad | estándar | Keychain accesible con el dispositivo desbloqueado | almacén por defecto de la app |
| refresh token / offline token | **biométrico** | `biometryCurrentSet` + Secure Enclave | almacén aparte `jccm_secure_biometric` con `enforceBiometrics`, `strongBiometricOnly` y `migrateOnAlgorithmChange: false` |
| opt-in de acceso rápido | sin cifrar | SharedPreferences / UserDefaults, **por ciudadano** | idem |

Reglas de sesión vigentes:

- **Sin el opt-in de acceso rápido no se guarda nada, ni siquiera el access token**: matar la app
  termina la sesión. Con el opt-in, un access token vigente entra sin pedir nada y uno caducado
  pide huella y renueva.
- La escritura a disco está condicionada a haber pasado el **gate de consentimiento**
  (`lib/core/routing/session_guard.dart`).
- El logout revoca en Keycloak con el token en memoria y **no toca el almacén biométrico a
  propósito**: en Android cualquier operación sobre él lo inicializa, e inicializarlo autentica.
- `offline_access` sólo se solicita donde el cliente de Keycloak lo tiene asignado —hoy únicamente
  **PRE**—; el almacenamiento es idéntico, lo que cambia es cuánto aguanta la credencial.
- Pendiente conocido: en iOS ningún nivel fija `ThisDeviceOnly`, así que los elementos viajan en el
  backup cifrado a otro dispositivo (deuda ya registrada, ajena a este análisis).

Nada de esto es utilizable por un navegador: son tokens en el almacén seguro del sistema, no
cookies.

### 3.3 La sesión del navegador del sistema

La que abren los enlaces externos. En Android es, desde el 18/09, **la misma** en la que se
identificó el ciudadano al entrar en la app. En iOS es otra distinta.

## 4. El matiz que cambia la conversación: en web no hay *un* SSO, hay dos capas

| Destino | Realm / cliente | Qué produce el SSO en web |
|---|---|---|
| App Espacio Ciudadano | realm **`usuarios`**, cliente `add-espacio_ciudadano_mobile-fo` (`config_*.json`) | — |
| **Educamos CLM** | realm **`educacion`**, cliente `edu-educamos-fo`, `kc_idp_hint=clavesp-saml` (`lib/core/config/app_config.dart`) | **No es SSO de Cerbero**: las cookies de sesión de Keycloak son por realm, y `usuarios` ≠ `educacion`. Lo que lo hace fluido es la capa de abajo: la pasarela **Cl@ve**, que auto-identifica «si no han pasado más de 60 minutos desde su última identificación». |
| **Empleo CLM** | desconocido desde el repo; en PRO `/private/posicion-global` | Si su cliente vive en el realm `usuarios`, sí sería SSO real de Keycloak mientras viva la sesión SSO del realm. **A confirmar con JCCM.** |
| Carpeta Salud (SESCAM) | en construcción | Hoy en la app es API por gateway, no portal con sesión. |

Esto determina qué se puede prometer: la parte de Educamos que hoy funciona en web es un SSO **con
caducidad de 60 minutos**, apoyado en el estado de sesión de Cl@ve del navegador.

## 5. Lo que cambió con la retirada del aislamiento

El aislamiento efímero de Android se construyó en agosto porque, tras un logout, Cl@ve volvía a
identificar al ciudadano sin pedirle nada, y se atribuyó al **estado por-método** que sobrevivía en
el tarro de cookies compartido de Chrome. En septiembre se comprobó que la causa era otra: la app no
estaba pidiendo reautenticación de forma que Cerbero la reconociera, así que la orden (`ForceAuthn`)
nunca llegaba a la pasarela. Corregido el `prompt`, **Cl@ve vuelve a desafiar con el navegador
compartido**, y el fork se retiró.

Dos consecuencias para esta conversación:

1. **El conflicto de seguridad que bloqueaba la Opción 2 ya no existe en Android.** Lo que garantiza
   que el siguiente ciudadano no herede la identificación del anterior es el `ForceAuthn`, no el
   aislamiento del navegador. Compartir el tarro de cookies dejó de ser una regresión.
2. **En iOS no cambia nada.** Su sesión efímera es de serie en el plugin, no una decisión nuestra
   reversible con una línea, y ahí sigue sin haber nada que compartir.

Queda un matiz que conviene no ocultarse: el rastro que dejan los enlaces nunca dependió de esto. El
de Educamos lanza la identificación de Cl@ve **en el navegador del sistema** (§4), así que ese tarro
ya acumulaba estado de Cl@ve en cualquier caso.

## 6. Opciones

### Opción 1 — Puente SSO en Cerbero *(recomendada)*

Cerbero (o la fachada) expone un endpoint que acepta el token que la app **ya tiene** y devuelve una
**URL de un solo uso y vida corta**. La app abre esa URL en el navegador; Cerbero valida el ticket,
**crea allí** la sesión de navegador y redirige al portal destino.

Variantes de implementación para JCCM:
- *Token exchange* (RFC 8693) hacia el cliente destino, más un endpoint de entrada en cada portal
  que acepte el token y establezca la sesión.
- Un ticket propio emitido por Cerbero/fachada, canjeado en un endpoint de entrada de Cerbero.

- **Ventajas**: único mecanismo que da SSO **real y determinista**, **idéntico en Android y iOS** —y
  el único que resuelve iOS en absoluto—, y reutilizable tal cual para Carpeta Salud.
- **Coste**: trabajo de Cerbero y de cada portal. En la app sólo cambia la URL que se abre: encaja
  en el catálogo cerrado de `external_links` sin tocar arquitectura.

### Opción 2 — Aprovechar la sesión del navegador *(en Android ya es el estado de hecho)*

Desde el 18/09 el login de Android ocurre en el Chrome del ciudadano, así que la sesión de Cerbero
del realm `usuarios` y el estado de Cl@ve quedan ahí. Si el portal destino se conforma con eso, el
SSO se produce **sin escribir una línea**.

- **Ya no hay coste de seguridad que asumir**: la reautenticación la fuerza el `ForceAuthn` (§5).
- **Pero es SSO parcial y no determinista**: para Educamos son los 60 minutos de la pasarela Cl@ve;
  para Empleo depende de en qué realm viva su cliente; y no funciona en iOS de ninguna manera.
- **Está sin medir.** Es la comprobación más barata que hay pendiente (§8) y conviene hacerla antes
  de la llamada: cambia lo que se puede prometer.

### Opción 2 bis — SSO dentro del contenedor de la app *(**IMPLEMENTADA** para iOS, 18/09/2026)*

> **Validada en dispositivo**, incluido el método de **certificado**, que era el riesgo que tenía
> parada esta opción. Durante las pruebas apareció un error genérico de la pasarela («null») y
> lentitud de carga: no era del agente —el mismo enlace iba igual en Safari del dispositivo— sino
> del camino de red por VPN.
>
> Lo implementado: `ExternalUserAgent.sfSafariViewController` en login y logout
> (`lib/features/auth/3_data/auth_repository_impl.dart`) y `LaunchMode.inAppBrowserView` en los dos
> enlaces de portal (`my_data_education_page.dart`, `my_data_employment_services_tab.dart`), con el
> resto de enlaces abriendo como siempre. Test de intención en
> `test/features/auth/auth_repository_impl_request_test.dart`.

`SFSafariViewController` guarda sus datos en un almacén **propio de la aplicación**, separado del de
Safari. El plugin trae un agente basado en él, expuesto como
`ExternalUserAgent.sfSafariViewController` y hoy sin uso. Si el login se hiciera con ese agente y
los enlaces se abrieran con `LaunchMode.inAppBrowserView` —que en `url_launcher_ios` es exactamente
`SFSafariViewController`—, ambos compartirían ese almacén.

Lo que daría: **SSO entre la app y los portales** sin tocar Safari, **aislamiento** respecto del
navegador del sistema, y **borrado al cerrar sesión**
(`SFSafariViewControllerDataStore.clearWebsiteData`, iOS 16+, limpia «website data accrued from
browsing activity within your app… local storage, cached resources, and cookies»). Es conforme a RFC
8252: es una *in-app browser tab*, no un navegador embebido.

Lo que **no está verificado** y decide si la vía existe:

1. Que Cl@ve funcione dentro de `SFSafariViewController`, en particular el método de
   **certificado/DNIe**.
2. Que el borrado se lleve también el **estado por método** del lado Cl@ve y no sólo las cookies.
3. El mínimo de la app es **iOS 15** y la API de borrado es **iOS 16+**: en iOS 15 no habría
   limpieza.

### Opción 3 — WebView embebido usando el token de la app *(no funciona; además, descartada)*

Es la pregunta natural —«si abrimos el portal dentro de la app, ¿no podemos pasarle el token que ya
tenemos?»— y conviene responderla en el orden correcto, porque **aunque RFC 8252 no existiera,
seguiría sin funcionar**:

1. **El token no es la moneda que aceptan esos portales.** Son aplicaciones web con sesión de
   servidor: esperan **su** cookie, emitida por Cerbero al final de las redirecciones OIDC. No hay
   ningún punto del flujo donde encaje un `Authorization: Bearer`.
2. **Y aunque la aceptaran, nuestro token no les vale.** Lo emite el realm `usuarios` para el
   cliente `add-espacio_ciudadano_mobile-fo`, y `iss`, `aud` y `azp` viajan dentro. Educamos es
   realm `educacion`, cliente `edu-educamos-fo`: distinto emisor y distinta audiencia, así que lo
   rechazaría por diseño. Convertirlo en un token válido para ese cliente **es exactamente** *token
   exchange* en Cerbero, o sea la Opción 1 por otro camino.
3. **Inyectar la cookie tampoco.** `CookieManager.setCookie` existe, pero requiere el **valor** de
   una cookie de sesión válida para ese portal, que sólo Cerbero puede acuñar tras autenticar. Y las
   cabeceras de `loadRequest` se pierden en la primera redirección.

**Lo que un WebView sí haría** es que el ciudadano se identifique *dentro* de él, lo que es un
**segundo login** y mete la credencial de Cl@ve en un navegador embebido en nuestro código. Ahí
entra el veredicto ya tomado (`../docs/auth/clave_android_session_investigation.md`): RFC 8252 §4 y
§8.12 lo prohíben expresamente para apps nativas, ningún plugin Flutter expone perfiles de WebView
aislados, el certificado de cliente y el DNIe exigirían *plumbing* manual, y un IdP puede bloquear
WebViews unilateralmente.

**Corolario útil:** el WebView resuelve el *envoltorio*, no la *autenticación*. Si algún día existe
el puente de la Opción 1, su enlace de un solo uso se puede abrir dentro de un WebView y entonces sí
tendría sentido. Es **opcional después del puente, nunca sustituto del puente**.

### Opción 4 — Paliativo sin SSO

Pasar `login_hint` con el identificador del ciudadano (disponible en los claims del JWT) a los
*authorize* de los portales que lo acepten, y mantener el aviso explícito de salida de la app. No es
SSO: sólo ahorra tecleo. Barato y reversible.

### Opción 5 — Pestaña integrada *(mejora de experiencia, independiente del SSO)*

Si lo que incomoda es la sensación de «salir de la app», hay un intermedio que **no** es un WebView:
abrir con `LaunchMode.inAppBrowserView` en lugar de `LaunchMode.externalApplication` — Custom Tab en
Android, `SFSafariViewController` en iOS. El portal se ve dentro de la app, con su barra y su botón
de cerrar, y no es un navegador embebido, así que no tiene el problema de RFC 8252.

- **Ojo:** en Android una Custom Tab **sí** comparte el tarro de Chrome, así que este cambio es
  compatible con la Opción 2; en iOS `SFSafariViewController` está aislado por app, así que no da
  SSO salvo que se adopte también la Opción 2 bis.
- Arrastra una limpieza pendiente: hoy conviven **dos caminos de apertura**, el endurecido con
  allow-list (`url_launcher_external_link_launcher.dart`) y un helper sin validación de esquema ni
  host (`external_navigation_confirmation.dart`, usado por la mayoría de los «Enlaces de interés»).
  Cambiar el modo de apertura es el momento natural de unificarlos.

## 7. Recomendación

**Hecho: Opción 2 en Android (sin coste) y Opción 2 bis en iOS.** El ciudadano entra identificado en
Empleo y en Educamos desde las dos plataformas.

La **Opción 1 (puente en Cerbero) sigue siendo la recomendación de fondo**, y no por terquedad: lo
que hay hoy funciona apoyándose en sesiones de navegador con caducidades que no controlamos —los 60
minutos de la pasarela para Educamos— y que pueden cambiar sin avisarnos. El puente daría SSO
**determinista**, igual en las dos plataformas, y es la pieza que conviene incorporar al diseño de
**Carpeta Salud**, que se está construyendo ahora, en lugar de heredar el problema.

La **3** no es una alternativa a la 1: el token de la app no es válido para esos portales, así que
cualquier camino pasa por que Cerbero emita algo que el navegador entienda.

La **4** pierde sentido mientras el SSO funcione. La **5** quedó parcialmente adoptada: los dos
portales abren en pestaña integrada, el resto de enlaces no.

## 8. Qué queda por confirmar

**Medido y cerrado el 18/09/2026:**

- ✅ Android: Empleo y Educamos abren identificados.
- ✅ iOS: ídem, con `SFSafariViewController`, certificado incluido.
- ✅ Realm de Empleo: es `usuarios`, el mismo que la app — lo demuestra que su `check-sso`
  silencioso encuentre la sesión que deja el login. Ya no hace falta preguntarlo.

- ✅ **Reautenticación tras cerrar sesión en iOS.** Era la condición para que el cambio se quedara:
  al perder la sesión efímera, lo único que impide que el siguiente ciudadano herede la
  identificación es el `ForceAuthn`. Comprobado en dispositivo — login → cerrar sesión → login
  vuelve a desafiar.
- ✅ **Login con certificado dentro de `SFSafariViewController`**, dos veces. Era el riesgo que tenía
  parada esta opción desde agosto.

**Pendiente de validar en producto:**

1. El parque real de Android: el SSO exige que el login y los enlaces abran el mismo navegador. En
   emulador ambos son Chrome; con otro navegador por defecto puede no cumplirse.
2. **Hubo lentitud, resultó transitoria, y no era del código.** Durante parte del 18/09 la cadena de
   autorización se arrastraba en el iPhone; al final de la tarde el mismo teléfono, con la misma
   VPN, volvió a ir rápido. **Causa sin determinar.**

   Lo que sí quedó demostrado mientras duraba, y es lo que evita volver a sospechar del código:

   - Iba igual de lenta en el **Safari del propio teléfono**, fuera de la app.
   - El **emulador de Android** y el **simulador de iOS** —que salen por la red del Mac— iban
     rápidos **al mismo tiempo**, con el mismo `SFSafariViewController` en el caso de iOS.
   - La cadena completa medida desde el Mac con VPN tardaba **0,7 s** (discovery 0,17 · authorize
     0,08 · broker 0,17 · selector 0,26, 45 KB).

   O sea: el agente del navegador y el modo de compilación quedan descartados. Si reaparece, ese
   contraste de cinco minutos —emulador/simulador contra dispositivo— vuelve a ser lo primero que
   hay que hacer, y ya con números de referencia para comparar.

**No verificable desde el repo, sigue siendo para JCCM:**

3. Si al pinchar Educamos en web el ciudadano **ve** el selector de Cl@ve y se auto-identifica, o no
   ve nada — distingue SSO de Cerbero de la ventana de 60 minutos de Cl@ve.
4. Versión de Keycloak de Cerbero y disponibilidad de *token exchange* (para el puente).
5. Si los portales pueden implementar un endpoint de entrada por ticket, o debe resolverlo Cerbero.

## 9. Referencias

- `../docs/auth/clave_forceauthn_retest_2026-09.md` — la causa real del bug de reautenticación y la
  retirada del aislamiento de Android (#282296).
- `../docs/auth/clave_android_session_investigation.md` — investigación de las capas de sesión de
  Cl@ve; su análisis de plataforma sigue vigente, su conclusión sobre el aislamiento la superó el
  documento anterior.
- `../docs/auth/historico/` — diseño, POC y plan de mantenimiento del fork retirado.
- `appauth_clave_relogin_fix.md` — `prompt=login` + `max_age=0` (julio 2026), con su corrección.
- `../tickets/STORY-28.md` — catálogo cerrado de enlaces externos como allow-list.
