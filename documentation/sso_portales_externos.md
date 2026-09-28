# SSO con portales externos desde la app (Empleo CLM, Educamos CLM, Carpeta Salud)

**Estado:** el **SSO sigue resuelto y validado en las dos plataformas** (18/09/2026). El efecto
secundario que la validación no cubrió —**cambiar de ciudadano sin cerrar sesión quedaba
bloqueado**, JCCMEC-224 / JCCMEC-228— está **arreglado y validado en iOS el 28/09**, con el SSO
comprobado intacto; falta el mismo contraste en Android (§8).
Lo que sigue conserva el análisis porque explica el porqué de cada decisión.
**Fecha:** 2026-09-18 (reescribe el análisis del 17/09), ampliado el 2026-09-28 con §8 ·
**Tickets:** JCCMEC-224, JCCMEC-228 · gestproy #282847 (sesión de Cl@ve) y #282296 (causa real
del bug de reautenticación).

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
- **Está sin medir.** Es la comprobación más barata que hay pendiente (§9) y conviene hacerla antes
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

## 8. El hueco: cambiar de ciudadano sin cerrar sesión (JCCMEC-224 / JCCMEC-228)

> Añadido el 28/09/2026. **No invalida nada de lo anterior**: el SSO con los portales sigue
> funcionando como se midió el 18/09. Lo que documenta esta sección es un efecto secundario del
> mismo cambio, que la validación de aquel día no llegó a cubrir.

### 8.1 Qué reporta el cliente

Los dos tiques son el mismo defecto visto en plataformas distintas:

| | JCCMEC-224 (25/09) | JCCMEC-228 (28/09) |
|---|---|---|
| Plataforma de la captura | Android (Custom Tab, `cm-pre.jccm.es`) | iOS (`SFSafariViewController`, `sso-cerbero-pre.cm-pre.jccm.es`) |
| Mensaje | `You are already authenticated as different user 'per9999927' in this session. Please sign out first.` | Idéntico, usuario `per2446221` |

El error lo pinta **Cerbero dentro del navegador**, durante el `authorize`: la app no llega a
recibir ningún token. Las salidas que encuentra el ciudadano son entrar con el usuario anterior y
cerrar sesión, o desinstalar la app.

JCCMEC-224 incluye además un punto distinto —«Empleo y Educamos se abren dentro de la app, deberían
abrirse en navegador»— que **no es un defecto**: es la Opción 2 bis de §6, deliberada, y es lo que
da el SSO en iOS. Decisión de G.T. el 28/09: se queda como está.

### 8.2 Causa raíz

La retirada del aislamiento (§5) dejó que la **cookie de sesión de Cerbero del realm `usuarios`
sobreviva en el navegador compartido**: Chrome/Custom Tab en Android, almacén de
`SFSafariViewController` en iOS. Eso es precisamente lo que hace posible el SSO con los portales.

Lo que invalida esa cookie es el RP-initiated logout —`_appAuth.endSession`,
`lib/features/auth/3_data/auth_repository_impl.dart:151-164`—, y **sólo se dispara desde dos
sitios**: el botón «Cerrar sesión» del menú de perfil
(`lib/features/auth/2_presentation/widgets/authenticated_profile_menu.dart:89`) y la revocación de
consentimiento (`lib/features/auth/2_presentation/providers/consent_revocation_notifier.dart:56`).
**No hay nada equivalente en el arranque de un login.**

Con eso, la secuencia del tique es:

1. El ciudadano A entra y **mata la app sin cerrar sesión** → la cookie de Cerbero sigue viva.
2. El ciudadano B pulsa Acceder → `prompt=login` → `ForceAuthn=true` → Cl@ve **autentica bien a B**.
3. El assertion SAML vuelve a Cerbero, que encuentra en esa sesión de navegador la identidad A y
   corta con `already authenticated as different user`.

Es el comportamiento estándar de Keycloak con brokering de identidad. **No es un defecto de Cerbero
ni de la app: es el hueco entre las dos**, y aparece porque hoy nadie cierra la sesión del navegador
salvo que el ciudadano pulse explícitamente «Cerrar sesión».

### 8.3 Por qué no lo detectó la validación del 18/09

Aquel día se midió *login → **cerrar sesión** → login vuelve a desafiar* (§9). Ese camino pasa por
`endSession` y limpia la cookie, así que funciona. El caso *login → **matar la app** → login con
otro ciudadano* no se probó. Conviene incorporarlo al plan de pruebas como escenario propio.

### 8.4 Agravante: la vuelta a la app

El enlace «Volver a la aplicación» de esa página de error lo emite **Cerbero**, y apunta al cliente
**web** de Espacio Ciudadano, no a la app. Desde el punto de vista del ciudadano no hay salida:
tendría que adivinar quién era el usuario anterior. Esa parte no se arregla desde el repo.

### 8.5 El arreglo (**IMPLEMENTADO y validado en iOS, con y sin acceso rápido**, 28/09/2026)

> **Medido en dispositivo el 28/09** — iPhone 16 con iOS 26.5, build *profile* contra **PRE**.
> Entrada con **certificado** y **acceso rápido activado**, app matada desde el selector sin cerrar
> sesión, y segundo login con
> **otro ciudadano**: entra sin el corte de Cerbero, y se ve la pestaña del cierre abrirse y
> cerrarse un instante antes de la de Cl@ve. **El SSO sigue intacto**: Empleo CLM y Educamos CLM
> abren ya identificados con el ciudadano en curso — que era el riesgo de regresión de todo esto.
>
> **Pieza 2 validada por separado**, y hacía falta: el escenario de arriba no la ejercita, porque
> con el opt-in activo el `id_token` ya se guardaba antes. Se repitió **desinstalando la app**
> —en iOS es lo único que limpia el almacén del navegador—, entrando con un ciudadano que
> **rechaza el acceso rápido**, matando la app y entrando con otro: **entra sin el corte**. Cl@ve
> pidió el certificado, que es lo correcto: el `ForceAuthn` que propaga `prompt=login` sigue
> haciendo su trabajo y nadie hereda la identificación del anterior.
>
> **Sin medir:** Android, y que un cierre de sesión en regla no haga pagar la pestaña de más.

Dos piezas. Sin la segunda, el arreglo dejaría fuera justo al perfil del tique.

**1. Cerrar la sesión del navegador antes de un login nuevo.**
`AuthSessionController.endStaleBrowserSession()` — si al iniciar sesión queda un `id_token` de un
login anterior, cierra esa sesión en Cerbero reutilizando el `logout()` que ya existía
(`auth_repository_impl.dart:144-178`) y sólo después arranca el `authorize`. Lo dispara
`LandingNotifier.login()` antes del caso de uso. Nunca propaga ni bloquea: entrar con un posible
corte de Cerbero por delante es mejor que no poder entrar por un fallo de red, y por eso tampoco
borra el `id_token` — si el cierre falla, la pista sigue ahí para el siguiente intento, y cerrar
una sesión ya cerrada es inocuo. El caso normal no paga nada: tras un cierre de sesión en regla
`clear()` ya borró el `id_token`, así que no hay pestaña de más. Techo de 15 s para que un cierre
que no resuelve no retrase la pantalla de Cl@ve.

**2. Guardar el `id_token` también sin acceso rápido.** `persist()` no guardaba **nada** en disco
sin biometría —razonado en su día: *«sólo dejaría un access token huérfano»*— y eso arrastraba al
`id_token`, que no es una credencial de acceso: no autoriza nada contra el gateway, sólo acredita
quién fue el titular. Ahora se escribe siempre. Sin esto el arreglo no sirve a quien no activa el
acceso rápido, que es precisamente el ciudadano de un móvil compartido. Decisión de G.T., 28/09.

Ficheros: `auth_session_controller.dart` (las dos piezas), `landing_notifier.dart` (el disparo).
Tests nuevos en `auth_session_controller_test.dart` y `landing_notifier_test.dart`, incluido uno que
fija el **orden** —cerrar después del `authorize` no serviría de nada—. Suite en verde (1.100) y
`custom_lint` limpio.

**Lo que queda por medir**, y es lo único que puede cambiar el diseño: si el cierre
puede hacerse **por detrás** (petición HTTP con Dio, invisible) en lugar de por el navegador. Hoy va
por el navegador, que es el camino garantizado —el mismo que ya funciona al pulsar «Cerrar
sesión»— a costa de que el ciudadano vea abrirse dos pestañas seguidas cuando hay algo que cerrar.

**Descartada de momento:** `SFSafariViewControllerDataStore.clearWebsiteData` (iOS 16+, §6 Opción
2 bis). El mínimo de la app es iOS 15, no lo expone `flutter_appauth` —exigiría un canal nativo— y
en Android no hay equivalente, así que no resolvería el caso en las dos plataformas.

**Sigue en pie, y no depende de nosotros:** que Cerbero restituya en esa pantalla la opción de
cerrar la sesión anterior y continuar (§8.4). Resolvería el caso sin app de por medio.

### 8.6 Hallazgo colateral: identidad cruzada en disco

Salió al analizar el escenario y es **independiente** del bloqueo anterior —ocurre después, si el
ciudadano llega a entrar—. Verificado en código:

- `lib/core/routing/session_guard.dart:149` llama a `hasPersistedSession()`
  (`auth_session_controller.dart:62-65`), que sólo pregunta *«¿hay algún access token en disco?»*,
  **no de quién**. Con el token de A en disco, la sesión de B **nunca se persiste** y la de A
  **nunca se borra**.
- `clear()` (`auth_session_controller.dart:460-484`) no toca el almacén biométrico, y está
  justificado por escrito — pero esa justificación («se acaba de revocar en Keycloak y el siguiente
  login lo sobrescribe») **asume que hubo logout explícito**. En este escenario no lo hay.
- La clave del offline token es `'refresh_token'` (`storage_keys.dart:13`), **sin sufijo de
  ciudadano**, mientras que todas las claves de `SharedPreferences` sí llevan `+ idAgente`
  (`storage_keys.dart:25-57`).

**No está demostrado que se haya manifestado** en lo que reporta el cliente: su bloqueo ocurre
antes, en el navegador. Pero explica por qué «desinstalar» aparece como una de las salidas, y
merece tique propio.

## 9. Qué queda por confirmar

**Medido y cerrado el 18/09/2026:**

- ✅ Android: Empleo y Educamos abren identificados.
- ✅ iOS: ídem, con `SFSafariViewController`, certificado incluido.
- ✅ Realm de Empleo: es `usuarios`, el mismo que la app — lo demuestra que su `check-sso`
  silencioso encuentre la sesión que deja el login. Ya no hace falta preguntarlo.

- ⚠️ **Reautenticación tras cerrar sesión en iOS — se midió a medias.** Era la condición para que el
  cambio se quedara: al perder la sesión efímera, lo único que impide que el siguiente ciudadano
  herede la identificación es el `ForceAuthn`. Se comprobó que *login → cerrar sesión → login vuelve
  a desafiar*, y así quedó escrito — pero **«desafiar» se leyó como «sale el selector de Cl@ve»**.
  El 28/09 se comprobó que el selector sale y, aun así, **elegir certificado entra con el ciudadano
  anterior sin pedir nada** (§10). El `ForceAuthn` gobierna el selector, no el estado del método.
  El retest de aquel día ya avisaba de que faltaba probar **ese** método en concreto: la laguna
  estaba identificada, no se cerró antes de retirar el fork.
- ✅ **Login con certificado dentro de `SFSafariViewController`**, dos veces. Era el riesgo que tenía
  parada esta opción desde agosto.

**Lo que aquella validación NO cubrió (28/09/2026):**

- ❌ **Cambio de ciudadano sin cerrar sesión.** Se midió *login → cerrar sesión → login*, que pasa
  por `endSession` y limpia la cookie. **Falta** *login → matar la app → login con otro ciudadano*,
  que es justo lo que está roto (§8, JCCMEC-224 / JCCMEC-228). Debe entrar en el plan de pruebas
  como escenario propio, no como variante del anterior.

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

## 10. Hallazgo del 28/09: el estado por método sobrevive al cierre de sesión (iOS)

> **Es un defecto preexistente, no una regresión**, y está hoy en PRE. Salió al ejecutar el UAT de
> §8 y **es más grave que el defecto de JCCMEC-224/228**. Necesita tique propio.

### 10.1 Síntoma

En iOS, tras pulsar «Cerrar sesión» y volver a Acceder:

- **sale** el selector de métodos de Cl@ve — el `ForceAuthn` funciona;
- pero al elegir **certificado**, entra **con el ciudadano anterior**, sin pedir el certificado ni
  preguntar qué usuario se quiere usar.

En un dispositivo compartido eso significa que el siguiente ciudadano hereda la identificación del
anterior: exactamente lo que JCCM pidió evitar en agosto.

### 10.2 Contraste A/B que lo demuestra preexistente

Medido el 28/09 en iPhone 16 / iOS 26.5 contra PRE. Se compiló **`develop` (`e9b02be`), sin el
arreglo de §8**, y se instaló **encima** de la otra build para conservar el estado del navegador:
**se comporta igual**. El arreglo de JCCMEC-224/228 queda descartado como causa — y además, en ese
camino su código ni se ejecuta, porque `clear()` ya borró el `id_token` al cerrar sesión.

### 10.3 Qué es, en realidad

El mismo **estado por método** que se diagnosticó el **07/09**: *«el selector SÍ salía pero
eIdentifier NO volvía a pedir el certificado»*. Lo que sobrevive no es la sesión de Cerbero —esa sí
se cierra— sino el **túnel TLS del IdP de certificado** dentro del almacén del navegador.

Lo mataba el **aislamiento efímero**, retirado el 18/09 al concluir que bastaba `prompt=login`.
Y basta… **para que salga el selector**. No para invalidar el estado del método.

**Y esto estaba previsto por escrito.** El propio retest del 18/09 lo dejó anotado antes de retirar
el fork (`../docs/auth/clave_forceauthn_retest_2026-09.md`, §5):

> La Build C cubre un escenario (logout y volver a entrar) con **un** método. Antes de quitar
> `packages/flutter_appauth` conviene repetir con el `prompt` corregido: el Caso A (cancelar
> Permanente y reintentar, que era el del ticket), **el método de certificado/eIdentifier —que en
> agosto era el que sobrevivía—** y una pasada en dispositivo real.

El fork se retiró sin cerrar ese punto. La validación no fue floja: fue consciente de su límite y
lo dejó escrito. Lo que faltó fue la comprobación pendiente, que es la que se hizo el 28/09 — con
el resultado que aquel documento temía. El fork sigue vendorizado y sin usar: volver a él era, según
ese mismo documento, **una línea**.

### 10.4 No es la ventana de 60 minutos: es el método, sólo el certificado, y caduca solo

Medido el 28/09, misma sesión, build de `develop`. Tras cerrar sesión y volver a Acceder:

| Método elegido en el selector | Resultado |
|---|---|
| **Certificado** | Entra **sin pedir nada**, con el ciudadano anterior |
| **Cl@ve PIN** | **Pide el flujo completo** (app de Cl@ve incluida) y entra |
| Cl@ve Permanente | No se pudo probar: no carga desde el móvil por la VPN (dominios de la Seguridad Social) |

La ventana de 60 minutos de la pasarela queda **descartada como causa**: opera sobre la pasarela
entera, así que habría auto-identificado también con PIN. Y cuando actúa de verdad ni siquiera
llega a mostrarse el selector — que es lo que se vio en el primer intento del día, un caso
distinto.

Lo que sobrevive es el estado del **IdP de certificado** dentro del almacén del navegador.

**Pero caduca solo, y muy rápido: unos 30 segundos.** Medido el 28/09 cronómetro en mano, después de
estimarlo primero en «minutos» y luego en «un minuto». No es un estado pegado: es una conexión
ociosa que se cierra sola.

Eso acota el riesgo sin eliminarlo: el peligro existe **si el segundo ciudadano entra poco después
del primero**, que es justamente el caso realista de un móvil compartido o un mostrador de
atención. Y refuerza el POC de §10.6: con el borrado explícito, el resultado deja de depender de
cuánto haya esperado nadie.

**Esto acota el impacto:** quien se identifica con Cl@ve PIN no está afectado. El riesgo se
circunscribe al certificado — que en la Administración no es precisamente minoritario, pero
tampoco es todo el mundo.

### 10.4 bis El camino importa: falla al cerrar sesión, no al matar la app

Contrastado el 28/09 en **dos dispositivos distintos** —el de pruebas y el de un compañero, con
versiones probablemente distintas— y el patrón es el mismo:

| Camino | ¿Cl@ve pide el certificado? |
|---|---|
| Matar la app sin cerrar sesión → entrar | **Sí** |
| «Cerrar sesión» en el menú → entrar | **No** |

Es contraintuitivo: el camino que **más** limpia es el que peor se comporta. Matar la app no abre
ningún navegador y el método vuelve a pedirse; cerrar sesión sí abre uno —el `endSession` navega a
Cerbero y vuelve— y tras esa navegación el certificado ya no se revalida.

Afina el diagnóstico: no es que el estado del método sobreviva siempre, es que **el camino del
cierre de sesión lo deja reutilizable**. Y explica por qué el POC de §10.6 funciona: ataca
exactamente ese punto, vaciando el almacén justo después de ese cierre.

**Explicación:** hay **dos** estados distintos, no uno — una primera redacción de esta sección los
unificó en «todo es la conexión TLS» y la medición lo desmintió (§10.4 ter). Lo que comparten es que
ambos mueren al cerrar la app: las cookies se guardan en disco y sobreviven, las conexiones
abiertas no.

| Secuencia | Conexión TLS | ¿Pide certificado? |
|---|---|---|
| Cerrar sesión, volver a entrar | viva | **No** |
| Cerrar sesión, **matar la app**, entrar | destruida | **Sí** |
| Matar la app sin cerrar sesión, entrar | destruida | **Sí** |

Encaja con todo lo demás: con que el estado **caduque en minutos** (es el *keep-alive* de una
conexión ociosa) y con que vaciar el almacén lo resuelva en iOS.

> **Apaño inmediato, sin esperar a ningún arreglo:** cerrar sesión **y cerrar la app**. Sirve para
> QA y para el ciudadano de un dispositivo compartido.

**Segundo síntoma, misma raíz — y peor para el ciudadano (28/09).** Si al elegir certificado se
**cancela** la selección, Cl@ve devuelve `003002 - Authentication Failed (no certificate has been
submitted)` y, a partir de ahí, **cada reintento devuelve lo mismo sin volver a ofrecer la lista de
certificados**, hasta matar la app. La conexión queda negociada **sin** certificado y se reutiliza.
Evidencia: `evidencia/uat_20260928_cancelar_certificado_bloquea.png`.

Es peor que el caso anterior porque le ocurre a **cualquiera que se equivoque al elegir**, no solo
en dispositivos compartidos, y la única salida —cerrar la app— no la deduce nadie.

**Vida del estado, medida:** vuelve a funcionar solo pasados **menos de cinco minutos**, que es el
orden de un *keep-alive* de conexión ociosa. Coherente con el diagnóstico.

> ⚠️ **Predicción para Android, sin comprobar:** allí la pestaña corre dentro de **Chrome**, un
> proceso aparte que **no muere** al matar la app. Si la explicación es correcta, el apaño **no
> funcionará en Android**. Comprobarlo antes de darlo por bueno a nadie.

### 10.4 ter Dos estados, no uno: qué alcanza el borrado y qué no

Medido el 28/09 en el simulador de iPhone, **con los logs a la vista** — y desmiente la explicación
unificada que esta sección daba antes:

| Síntoma | ¿Lo arregla vaciar el almacén? | Dónde vive el estado |
|---|---|---|
| Tras **cerrar sesión**, el certificado no se puede reelegir | **Sí** | Datos del sitio (cookies) |
| Tras **cancelar** la selección, `003002` en bucle | **No** | La conexión, fuera de `clearWebsiteData` |

Cómo se midió el segundo: se añadió el borrado también en la rama de login fallido y se leyó el
log del simulador. La línea `Browser website data cleared` **se ejecuta** — y el bloqueo persiste
igual. El cambio se retiró: dejaba código que aparentaba arreglar algo que no arregla.

Consecuencia práctica: el POC de §10.6 resuelve el primer síntoma, **no el segundo**. Para el
segundo, desde la app **no hay arreglo**; solo lo sueltan matar la app o esperar a que caduque
(menos de cinco minutos). Es un comportamiento del IdP de Cl@ve: cachear una negociación fallida de
forma que impida reintentar no debería ocurrir, y eso hay que reportárselo a ellos.

### 10.4 quater Android es peor: ahí no se suelta

Medido el 28/09 en emulador Pixel 9 (Android 17) contra PRE, y **contradice la conclusión
tranquilizadora de iOS**:

| | iOS | Android |
|---|---|---|
| Dónde vive la pestaña | `SFSafariViewController`, contenedor **de la app** | Custom Tab **dentro de Chrome** |
| ¿Muere al cerrar la app? | Sí | **No** — Chrome es otro proceso |
| ¿Se suelta esperando? | Sí, ~30 s | **No**, ni tras varios minutos |
| ¿Se suelta matando la app? | Sí | **No** |
| Qué lo suelta | El tiempo | **Sólo borrar los datos de Chrome** |

Comprobado por contraste: con el certificado pegado y sin soltarse ni esperando ni matando la app,
un `pm clear com.android.chrome` lo libera de inmediato. El estado vive en Chrome.

**Consecuencia:** en Android esto **no es una molestia pasajera, es persistente**. El ciudadano no
tiene forma razonable de salir — nadie va a ir a borrar los datos de su navegador — y el apaño de
«cerrar la app» que sirve en iOS **aquí no funciona**.

### 10.5 Cuánto importa, de verdad

Con el TTL medido en **~30 segundos**, la valoración baja mucho respecto a la primera impresión.
Conviene dejarlo escrito con precisión, porque de esto depende cómo se prioriza y cómo se cuenta:

| | JCCMEC-224/228 | Este hallazgo |
|---|---|---|
| Efecto | El ciudadano **no puede** entrar | Reeligiendo certificado, entra como el anterior |
| Persistencia | **Permanente** hasta cerrar sesión | **Se suelta solo en ~30 s** |
| Visibilidad | Se ve y molesta | Silencioso |
| Alcance | Cualquier método | Sólo certificado |
| Plataformas | Ambas | Medido en iOS; Android sin medir |

Para que alguien heredase la identificación de otro **en iOS** haría falta coger el dispositivo y
entrar **en menos de medio minuto**. Existe, pero no es el escenario de un móvil compartido normal.

**En Android no hay tal ventana: el estado no caduca** (§10.4 quater). Ahí sí es un defecto
persistente, y la tabla de arriba —escrita con los datos de iOS— **no le aplica**. Cualquier
priorización tiene que separar las dos plataformas.

> Esta sección ha cambiado dos veces según se afinaba la medición: primero decía que el hallazgo era
> «más grave» que el defecto de §8, luego que el TTL era de minutos. Con 30 segundos medidos, **ni
> es más grave ni es urgente**. Se deja la traza del cambio a propósito: la primera impresión sobre
> un estado que caduca solo casi siempre exagera.

**Donde sí muerde de verdad es en las pruebas.** Quien valide cambiando de usuario en segundos lo
verá constantemente — y, peor, puede *creer que ha arreglado algo* cuando lo único que ha pasado es
que se ha entretenido 30 segundos. Ocurrió durante este UAT y costó un POC entero (§10.4 ter).

### 10.6 Cómo se arregla

**Lo primero: probablemente no hace falta arreglarlo desde la app.** Con ~30 segundos de vida, el
estado se suelta solo antes de que casi nadie lo note. El POC que se escribió para atacarlo
—vaciar el almacén con `clearWebsiteData` vía canal nativo— **se midió y no servía** (§10.4 ter), y
se retiró.

Si aun así se quisiera cerrar del todo:

**1. Reportarlo a Cl@ve.** Es lo que corresponde. Dos comportamientos de su IdP: que no revalide el
certificado cuando le llega `ForceAuthn`, y que una negociación **cancelada** deje bloqueados los
reintentos durante esos segundos (`003002`). Hay evidencia medida para pedirlo.

**2. Volver al aislamiento** (`ephemeralAsWebAuthenticationSession` en iOS; en Android el fork, que
sigue vendorizado y a una línea). Lo mata de raíz, pero **cuesta el SSO con Empleo y Educamos**. Por
30 segundos, no compensa.

**3. El puente SSO en Cerbero** (Opción 1 de §6), que sigue pendiente desde septiembre. Deshace el
nudo: con enlaces de un solo uso, el SSO deja de necesitar el almacén compartido y se puede aislar
sin perder nada. Su justificación no es este hallazgo — es el diseño correcto — pero encaja.

**Apaño mientras tanto, para QA y para el ciudadano:** cerrar sesión **y cerrar la app**. O
simplemente esperar medio minuto.

**Vías descartadas, para no volver a recorrerlas:**

- **Recrear la instancia de `FlutterAppAuth`** no limpia nada. Comprobado en el plugin
  (`flutter_appauth-12.0.0/ios/.../AppAuthIOSAuthorization.m:165-178`): **ya se construye un agente
  externo nuevo en cada llamada** (`[[OIDExternalUserAgentIOSSafariViewController alloc] init…]`), y
  el estado sobrevive igual. No vive en ese objeto ni en la instancia Dart, sino en el proceso del
  sistema que lo respalda y en la caché de red de la app, donde no llega ninguna API pública.
- **Vaciar el almacén** (`clearWebsiteData`): medido, se ejecuta y no lo suelta (§10.4 ter).
- **Un punto medio entre compartir y aislar** no existe: el plugin sólo ofrece tres agentes —el
  efímero (`OIDExternalUserAgentIOSNoSSO`, que aísla y mata el SSO), el `SFSafariViewController` que
  usamos, y el `ASWebAuthenticationSession` por defecto—. O se comparte contenedor, o no.

### 10.7 Además: la identidad sobrevive en Educamos

Medido en la misma sesión. Tras cambiar de ciudadano en la app, **Empleo CLM** abre con el ciudadano
nuevo —su realm es `usuarios`, el que la app cierra— pero **Educamos CLM sigue mostrando al
anterior**: vive en el realm `educacion`, que no cierra nadie, ni el arreglo ni el botón «Cerrar
sesión». Mismo riesgo de privacidad, y con datos educativos de por medio. Es independiente de §10.1
y también preexistente: el logout en regla tampoco lo cierra.

## 11. Referencias

- `../docs/auth/clave_forceauthn_retest_2026-09.md` — la causa real del bug de reautenticación y la
  retirada del aislamiento de Android (#282296).
- `../docs/auth/clave_android_session_investigation.md` — investigación de las capas de sesión de
  Cl@ve; su análisis de plataforma sigue vigente, su conclusión sobre el aislamiento la superó el
  documento anterior.
- `../docs/auth/historico/` — diseño, POC y plan de mantenimiento del fork retirado.
- `appauth_clave_relogin_fix.md` — `prompt=login` + `max_age=0` (julio 2026), con su corrección.
- `../tickets/STORY-28.md` — catálogo cerrado de enlaces externos como allow-list.
