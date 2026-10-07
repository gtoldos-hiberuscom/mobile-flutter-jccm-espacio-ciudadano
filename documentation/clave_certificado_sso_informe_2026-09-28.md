# Cl@ve, certificado y SSO — informe completo de la sesión del 28/09/2026

> **Para qué sirve este documento.** Traspaso de contexto autocontenido: todo lo averiguado en una
> sesión larga sobre por qué el certificado de Cl@ve «se queda pegado», qué se probó, qué se
> descartó y con qué evidencia. Escrito para que alguien que no estuvo pueda retomar sin
> reconstruir nada.
>
> **Regla de lectura:** aquí se distingue siempre entre **medido**, **deducido** y **supuesto**. Lo
> que no se midió está marcado como tal. En esta sesión, tres conclusiones que parecían firmes se
> cayeron al medirlas — conviene no repetir el error.
>
> Análisis de referencia, con más detalle por tema: `sso_portales_externos.md` §10.

---

> **Nota de estado (05/10/2026).** Este informe se escribió el 28/09 como traspaso, cuando la vía
> estaba abierta. **La decisión final fue conservar el SSO**: el login comparte el contenedor del
> navegador y no hay sesión efímera en ninguna plataforma. Las vías que aquí se exploran —fork,
> `oidc`, WebView— quedaron descartadas; lo que conserva su valor son las mediciones y el porqué de
> cada descarte. Ver `sso_portales_externos.md` §10.8 y §10.9 para lo medido después.


## 1. De dónde viene todo

**JCCMEC-224** (25/09, Android) y **JCCMEC-228** (28/09, iOS), reportados por J.C.J., son **el mismo
defecto**: al cambiar de ciudadano sin cerrar sesión, Cerbero corta con
`You are already authenticated as different user 'perXXXXXXX'. Please sign out first.`

JCCMEC-224 mezcla además un segundo asunto que **no es un defecto**: «Empleo y Educamos se abren
dentro de la app». Es deliberado (`c1bbe81`, 18/09) y es lo que da el SSO en iOS. Decisión de G.T.:
se queda.

### 1.1 El defecto de los tiques: causa y arreglo

**Causa.** La identificación no vive en la app, vive en el navegador, y sobrevive a que el ciudadano
mate la app. El `endSession` que la invalida (`auth_repository_impl.dart:151-164`) sólo colgaba del
botón «Cerrar sesión». Cuando el siguiente en entrar era otro ciudadano, Cl@ve lo autenticaba bien y
Cerbero cortaba al volver el assertion. **No es un bug de Cerbero ni de la app: es el hueco entre
las dos.**

**Arreglo** (commit `8d01a7c`, rama `fix/JCCMEC-224-cambio-de-usuario`, **sin pushear**), dos piezas:

1. `AuthSessionController.endStaleBrowserSession()` cierra esa sesión **antes** del `authorize`,
   reutilizando el `logout()` que ya existía. Lo dispara `LandingNotifier.login()`. Hay test que fija
   el **orden**: cerrar después del authorize no serviría de nada.
2. `persist()` pasa a guardar el `id_token` **también sin acceso rápido**. Antes esa rama no guardaba
   nada, y sin `id_token` no hay con qué cerrar. Sin esta pieza el arreglo dejaba fuera al ciudadano
   de móvil compartido, que es el del tique.

Más tarde se añadió `rememberBrowserSession()` (`fix/JCCMEC-224…` + commits posteriores): el
`id_token` se guarda **al iniciar sesión**, no en el `SessionGuard`, porque allí estaba condicionado
a que el gate de consentimiento respondiera bien — y si fallaba (*failing open*), no quedaba pista.
**Causa probable de una incidencia, no confirmada**: al habilitar los logs dejó de reproducirse.

**Estado:** validado en iOS (iPhone 16 / iOS 26.5, PRE) con y sin acceso rápido, y comprobado que
**el SSO sigue intacto**. **Sin probar en Android** — es lo único pendiente del encargo original.

---

## 2. El hallazgo principal: el certificado se queda pegado

Salió al ejecutar el UAT. **Es preexistente**, no lo introduce el arreglo.

### 2.1 Síntoma

Tras pulsar «Cerrar sesión» y volver a entrar:

- **sale** el selector de métodos de Cl@ve — el `ForceAuthn` funciona;
- pero al elegir **certificado**, entra **con el ciudadano anterior**, sin pedir nada.

Y un segundo síntoma, misma raíz y peor para el ciudadano: si al elegir certificado **se cancela**,
Cl@ve devuelve `003002 - Authentication Failed (no certificate has been submitted)` y **cada
reintento repite el error** sin volver a ofrecer la lista.

### 2.2 Demostrado preexistente

Contraste A/B: se compiló `develop` (`e9b02be`) **sin el arreglo** y se instaló **encima**,
conservando el estado del navegador. **Se comporta igual.** El arreglo queda descartado como causa —
y además, en ese camino su código ni se ejecuta, porque `clear()` ya borró el `id_token`.

### 2.3 No es la ventana de 60 minutos de Cl@ve

| Método tras cerrar sesión | Resultado |
|---|---|
| **Certificado** | Entra sin pedir nada |
| **Cl@ve PIN** | **Pide el flujo completo** y entra |
| Cl@ve Permanente | No probado: no carga con VPN en el móvil |

Si fuera la ventana de la pasarela, PIN tampoco habría pedido nada. Y cuando esa ventana actúa de
verdad, ni siquiera llega a salir el selector.

### 2.4 Dónde vive el estado, por plataforma — **la diferencia clave**

| | iOS | Android |
|---|---|---|
| Dónde vive la pestaña | `SFSafariViewController`, contenedor **de la app** | Custom Tab **dentro de Chrome** |
| ¿Muere al cerrar la app? | Sí | **No** — Chrome es otro proceso |
| ¿Se suelta esperando? | Sí, **~30 s** | **No** |
| ¿Se suelta matando la app? | Sí | **No** |
| Qué lo suelta | El tiempo | **Sólo `pm clear com.android.chrome`** |

**Consecuencia:** en iOS es una molestia de medio minuto; **en Android es un defecto persistente sin
salida razonable** — nadie va a borrar los datos de su navegador.

### 2.5 Por qué no se detectó antes

El retest del 18/09 (`../docs/auth/clave_forceauthn_retest_2026-09.md` §5) lo dejó **escrito**:

> La Build C cubre un escenario (logout y volver a entrar) con **un** método. Antes de quitar
> `packages/flutter_appauth` conviene repetir […] **el método de certificado/eIdentifier —que en
> agosto era el que sobrevivía—** y una pasada en dispositivo real.

El fork se retiró sin cerrar ese punto. **La validación no fue floja: fue consciente de su límite.**
Lo que faltó fue la comprobación pendiente, que es la que se hizo el 28/09.

### 2.6 Por qué «antes sí se podía elegir certificado»

Porque era cierto. Hasta el 18/09 el login corría en **contenedor efímero** (fork de Custom Tabs en
Android, sesión efímera en iOS), que se destruía al terminar: cada login empezaba de cero.

**Corte exacto:** `0.1.5+7` (11/09) y anteriores lo tenían; `0.1.6+8` y `0.1.7+9`, no. Explica que
un compañero pueda elegir certificado y otra no.

---

## 3. Vías exploradas — qué se descartó y con qué evidencia

Todo lo de esta sección está **medido**, no supuesto.

### 3.1 ❌ Vaciar el almacén (`clearWebsiteData`, iOS) — POC retirada

Se montó un canal nativo y se creyó que funcionaba. **Era el reloj**: el estado caduca en ~30 s y
entre el login y la comprobación mediaban compilaciones. Medido después con cronómetro: con el POC
puesto y sin margen, el certificado sigue pegado. Y con los logs delante,
`Browser website data cleared` **se ejecuta** y el bloqueo persiste.

**Retirada entera** (`083a8cb`). De paso invalidó 4 casos del UAT que se habían dado por buenos.

### 3.2 ❌ Recrear la instancia de `flutter_appauth`

No limpia nada, porque **ya se recrea**: `AppAuthIOSAuthorization.m:165-178` construye un agente
externo nuevo en cada llamada. El estado no vive en ese objeto sino en el proceso del sistema que lo
respalda.

### 3.3 ❌ Quitar `max_age=0` del authorize

Hipótesis razonable —en su día el fallo fue un parámetro mal parseado— pero **medida en Android**
(donde el reloj no puede falsear) con Chrome recién limpiado: el certificado sigue sin reelegirse.
Además, el retest del 18/09 confirma que `prompt=login` + `max_age=0` es exactamente lo que se envía
desde entonces: **no hay deriva**.

### 3.4 ⚠️ WebView con `flutter_inappwebview` — a medias

- ✅ **El desafío TLS llega al WebView**: `¡DESAFÍO DE CERTIFICADO! host=se-pasarela-ident.clave.gob.es`
- ❌ **Pero no se puede responder con el certificado del ciudadano**: `ClientCertResponse` exige un
  `certificatePath` (un `.p12` que la app tendría que poseer). No hay forma de delegar en el llavero
  del sistema.

Evidencia: `evidencia/poc_webview_20260928_desafio_certificado.png`.

### 3.5 ⚠️ `oidc` 4.0.0 y la «doble ruta» — funciona, pero tiene un agujero

**El hallazgo:** `oidc` (y `flutter_web_auth_2`) exponen **sesión efímera por llamada y también en
Android**, vía `CustomTabsIntent.EXTRA_ENABLE_EPHEMERAL_BROWSING` — API que no existía cuando se hizo
el fork. `flutter_appauth` sólo lo permite en iOS.

Medido en emulador Android:

| Ruta | `ephemeralBrowsing` | Resultado |
|---|---|---|
| «Acceder (SSO)» | `false` | No pide certificado — como hoy |
| «Otra identificación» | `true` | **Sí pide certificado** ✅ |

Y **el SSO se conserva**: Empleo abre identificado, Educamos refleja el ciudadano en curso.

**⚠️ PERO la ruta efímera reintroduce la fuga de identidad.** Medido: login con certificado → Educamos
muestra ese ciudadano; después «Otra identificación» con otra identidad → la app entra con el nuevo
pero **Educamos sigue mostrando al anterior**. El login efímero no toca Chrome, así que los portales
siguen viendo la sesión vieja. **Es peor que quedarse sin SSO: se ven datos de otro.**

**Arreglo propuesto, sin medir:** al usar esa ruta, hacer además un `endSession` **no efímero** con el
`id_token` del anterior para matar la sesión de Chrome.

**Además:** la doble ruta **no arregla la ruta normal** — la rodea. Depende de que el ciudadano
entienda que debe pulsar el otro botón.

### 3.6 ❌ Descartadas sin probar, con motivo

| Librería | Por qué no |
|---|---|
| `openidconnect` 3.0.0 | Abre el navegador entero con `url_launcher` — peor que hoy |
| `oauth_flutter` 0.0.13 | Es `flutter_web_auth_2` envuelto; v0.0.13 |
| `oauth2` 2.0.5 | No aporta agente de navegación |

**Criterio que las descarta:** el estado vive en Chrome, y ninguna cambia quién abre Chrome. Cambiar
la capa OIDC es irrelevante para esto.

---

## 4. La vía que queda abierta: WebView **nativo**

Es la única que puede dar **las dos cosas a la vez**, y estaba a medio medir al cerrar la sesión.

**Por qué puede funcionar:** con WebView propio controlas el TLS. En Android existe
`KeyChain.choosePrivateKeyAlias()`, que muestra el selector de certificados **del sistema** — lo que
`flutter_inappwebview` no hace — y `WebView.clearClientCertPreferences()` para olvidarlo. Si los
portales se abren en ese mismo WebView, comparten cookies ⇒ hay SSO.

**Lo que ya sabemos a favor:** Cl@ve **funciona dentro de un WebView** y el desafío de certificado
llega (§3.4). El bloqueo fue del plugin, no de la plataforma.

**✅ POC EJECUTADA — el login completo funciona (29/09, 00:36).** Con WebView nativo, el ciudadano
elige su certificado **del llavero del sistema** y Cl@ve completa la autenticación. Traza íntegra:

```
→ authorize
cargado: sso-cerbero-pre…/broker/clavesp-saml
cargado: se-pasarela.clave.gob.es/Proxy2/ServiceProvider
DESAFÍO DE CERTIFICADO: se-pasarela-ident.clave.gob.es
elegido: EIDAS_CERTIFICADO_PRUEBAS___…
certificado enviado
✓ CALLBACK recibido — login completado
```

Es lo que `flutter_inappwebview` no podía (§3.4): la diferencia es
`KeyChain.choosePrivateKeyAlias()`, que abre el selector del sistema en vez de exigir un `.p12`
propio.

**✅ Y las otras dos preguntas también salen que sí:**

| Pregunta | Resultado |
|---|---|
| ¿Elige certificado del llavero? | **Sí** — selector del sistema, login completo hasta el callback |
| ¿Se conserva el SSO? | **Sí** — Empleo abre ya identificado |
| ¿Se puede reelegir tras limpiar? | **Sí** — `clearClientCertPreferences()` + `removeAllCookies()`, **sin esperar** |

**Es la única vía medida que da SSO y reelección de certificado a la vez**, y encima en Android, que
es donde el problema no caduca. Lo que ninguna otra consiguió.

**El obstáculo que costó resolver, para quien retome esto:** la UI no se pintaba y no era el tema ni
el `weight` —tres intentos perdidos ahí—. Se encontró con `uiautomator dump`: los botones estaban en
`[0,0][703,126]` y la **action bar en `[0,142][1080,289]`**, dibujándose encima. Se arregló con
`Theme.Material.Light.NoActionBar` + `fitsSystemWindows = true`. **Mirar el árbol de vistas antes de
probar arreglos a ciegas.**

**Estado previo (histórico):** `ClaveWebViewActivity.kt` en
la rama `poc/webview-nativo`. **Compila, se instala y arranca** (la traza `listo. 1 Login · 2 Empleo
· 3 Limpiar` aparece en logcat con el tag `ClavePoc`), pero **la UI no se pinta**: sólo se ve la
barra de título y una franja gris de pocos píxeles donde debería estar el log. Los botones no son
alcanzables, así que **la pregunta sigue sin responder**.

Intentos hechos, ninguno lo resolvió: dar `weight` al WebView en vez de `match_parent`; forzar
colores explícitos por si el tema los dejaba invisibles; y asignar
`@android:style/Theme.Material.Light.DarkActionBar` a la Activity.

**Pistas para retomarlo** (es un fallo de layout, no del enfoque): probar con un layout XML en
`res/layout/` en vez de construirlo en código; o dar al WebView una altura fija para descartar que
se coma el espacio; o heredar de `AppCompatActivity` en lugar de `Activity`. Nada de esto afecta a
lo que la POC mide.

Se lanza sin pasar por Flutter:

```bash
adb shell am start -n es.jccm.espaciociudadano/.ClaveWebViewActivity
```

Tres botones: *1 Login* (authorize con los mismos parámetros que el real), *2 Empleo*, *3 Limpiar*.
Qué mirar: (1) ¿sale el selector de certificados del sistema?, (2) ¿Empleo abre identificado?,
(3) tras limpiar, ¿deja elegir sin esperar?

**Lo que esto NO resuelve, y es mucho — leer antes de entusiasmarse:**

- ~~Hay que reimplementar el flujo OAuth entero.~~ **CORREGIDO: no hace falta.** `TokenRequest`
  acepta `authorizationCode` y `codeVerifier` (`flutter_appauth_platform_interface-12.0.0/lib/src/
  token_request.dart:18-19,47-51`), así que **AppAuth puede canjear un código obtenido por fuera**.
  El reparto queda:

  | Pieza | Quién la hace |
  |---|---|
  | Abrir `/authorize`, certificado, capturar el `code` | **WebView nativo** (lo que causa el problema) |
  | Canje del código por tokens | `_appAuth.token(TokenRequest(authorizationCode:, codeVerifier:))` |
  | Refresco | AppAuth, como hoy |
  | Almacenamiento, biometría, consent gate | Intactos |

  **Lo que sí pasa a ser nuestro y hay que hacer con cuidado:** generar el PKCE (la POC ya lo hace) y
  **validar `state` y `nonce` al volver** — ahí es donde se cometen los fallos de seguridad. Y el
  **logout tiene que ir por el mismo WebView**: el `endSession` de AppAuth abre una Custom Tab y
  cerraría la sesión de Chrome, dejando viva la del WebView.

  Sigue siendo trabajo serio sobre la pieza más sensible de la app, pero **no es reescribir OAuth**.
- **iOS sigue sin respuesta** (ver abajo), y el problema allí dura 30 s, así que puede no compensar.
- **RFC 8252** no se arregla siendo nativo.

**Riesgos:**

- **iOS es dudoso**: `WKWebView` puede responder al reto, pero iOS no da a las apps las identidades
  del llavero como Android con KeyChain. Probablemente exigiría importar el `.p12` en la app, que no
  es viable para un ciudadano. **No prometer iOS.**
- **RFC 8252**: las credenciales de Cl@ve pasarían por la app. Ser nativo no lo arregla. Decisión de
  JCCM, registrada en contra en julio/2026.
- **Coste**: plugin nativo en dos plataformas, con manejo de certificados de cliente, a mantener.

---

## 5. El fondo del asunto, y la recomendación

Las cuatro opciones reales, con su precio:

| Vía | Certificado reelegible | SSO | Coste |
|---|---|---|---|
| **Hoy** (`flutter_appauth`) | ❌ en Android, persistente | ✅ | — |
| **Fork efímero** | ✅ | ❌ | **Una línea** (vendorizado) |
| **`oidc` doble ruta** | ✅ (sólo en la 2.ª ruta) | ✅ | Alto + agujero por cerrar |
| **WebView nativo** | ✅ | ✅ | Muy alto + RFC 8252 |

**La valoración de G.T., que comparto:** poder elegir certificado pesa **más** que el SSO. Sin
certificado el ciudadano **no puede entrar** —o entra como otro, que es peor—; sin SSO tiene que
identificarse otra vez en los portales. Un bloqueo sin salida pesa más que una molestia.

**Y un dato que conviene llevar a JCCM:** el SSO se pidió **sin saber lo que costaba**. Nadie sabía
que el precio era el certificado pegado, porque ese caso no se probó. La decisión del 18/09 se tomó
con información incompleta.

**Recomendación:** devolver la decisión a JCCM con los datos de ahora — *«pedisteis el SSO; esto es
lo que cuesta; ¿lo mantenéis?»*. Si dicen que el certificado pesa más, **la vuelta atrás es barata**:
el fork sigue vendorizado y es una línea.

---

## 6. Estado del repositorio

**Nada pusheado.** Todas las ramas son locales.

| Rama | Qué lleva |
|---|---|
| `fix/JCCMEC-224-cambio-de-usuario` | **El arreglo de los tiques** (`8d01a7c`). Lo único con valor de entrega |
| `poc/ios-clear-website-data` | UAT + hallazgos + POC de `clearWebsiteData` (**retirada**) + logger habilitado |
| `poc/webview-clave` | POC de WebView con `flutter_inappwebview` |
| `poc/oidc-doble-ruta` | POC de `oidc`. **Sin lint**: `custom_lint`/`riverpod_lint`/`json_serializable` apartados |
| `poc/webview-nativo` | POC de WebView nativo con KeyChain. **Sin resultado todavía** |

**Cambios temporales marcados en el código, a revertir:**

- `logger.dart`: `ProductionFilter()` para que emita fuera de debug.
- `app_router.dart`: `initialLocation` apunta a la POC en debug.
- `poc/oidc-doble-ruta`: tres `dev_dependencies` apartadas + `manifestPlaceholders["oidcRedirectScheme"]`.
- `poc/webview-nativo`: `ClaveWebViewActivity` registrada en el manifest.

**Entregable de QA:** `UAT_JCCMEC-224-228_Cambio_de_ciudadano.xlsx`, 30 casos (TC-503…TC-532),
mismas 21 columnas que el plan maestro. **14 OK, 1 bloqueado, resto pendiente** — cuatro se
reabrieron al descubrir que se habían validado sin cronómetro.

---

## 7. Hallazgo transversal: la app no escribe logs fuera de debug

**No es de este tema, y es importante.** El `Logger` no declara `filter`, así que usa el
`DevelopmentFilter` por defecto: **sólo emite si `kDebugMode`**. En una build *profile* o *release*
—PRE incluida— la app no escribe **ni una traza**. Y `DEBUG_MODE` de la config sólo gobierna el log
verboso de red, y encima combinado con `kDebugMode`.

Eso dejó ciega toda la primera mitad de la sesión. A QA y a soporte les pasará igual. Enlaza con el
P0 de observabilidad de la auditoría del 10/09. **Merece tarea propia.**

---

## 8. Cómo reproducir y medir

### Entorno Android (imprescindible, y no obvio)

```bash
# 1. El emulador NO hereda los resolvers de la VPN
emulator -avd Pixel_9 -dns-server 172.24.4.158

# 2. Android 17 además interfiere con su DNS privado — sin esto no resuelve PRE
adb shell settings put global private_dns_mode off

# 3. Comprobar antes de perder tiempo
adb shell ping -c 1 sso-cerbero-pre.cm-pre.jccm.es   # debe resolver a 172.24.4.209

# 4. Partir limpio (y única forma de soltar el certificado en Android)
adb shell pm clear com.android.chrome
```

### Trampas conocidas

- **Cl@ve Permanente no carga desde el móvil** con VPN: no resuelve los dominios de la Seguridad
  Social. PIN (AEAT) y certificado sí. No es bug de la app.
- **La pasarela de Cl@ve da lentitud y errores intermitentes.** Contraste del 18/09: si el mismo
  enlace va igual de lento en el navegador del dispositivo, es la red.
- **En iOS, usar build *profile* o *release***: en debug la app no arranca bien desde el icono, y
  relanzar desde el IDE reinstala y falsea la prueba.
- **`flutter run` puede fallar** con «expected app at build/ios/iphoneos/Runner.app not found» tras
  matar una build concurrente. El bundle existe en `build/ios/Profile-iphoneos/`; instalar con
  `xcrun devicectl device install app`.
- **VS Code reescribe `.dart_tool/package_config.json`** apuntando al Flutter del PATH si su servidor
  de lenguaje arrancó con otro SDK — incluso a mitad de compilación. Síntoma:
  `HitTestRequest isn't a type`. Arreglo: recargar la ventana de VS Code.

---

## 9. Lecciones de método

Las tres cosas que más tiempo costaron, y que se repitieron:

1. **Si el estado que investigas caduca, mide con cronómetro.** El estado del certificado dura ~30 s
   en iOS; entre compilar e instalar se colaban justo esos segundos. Así se dio por bueno un POC que
   no servía. **Android es mejor banco de pruebas: allí no caduca.**
2. **Prueba la combinación, no las piezas.** El retest del 18/09 validó «el certificado funciona» y
   «tras cerrar sesión se vuelve a desafiar» **por separado**, y el hueco estaba en juntarlas. Lo
   mismo pasó con la doble ruta de `oidc`: funcionaba hasta que se probó el escenario cruzado.
3. **Desconfía antes del propio arreglo que del entorno.** Durante un buen rato se atribuyó a la red
   lo que era un fallo de diseño, y al revés.

Y una de comunicación: **pedir «¿qué nombre aparece en pantalla?» en vez de «¿abre identificado?»**.
Las respuestas ambiguas costaron dos diagnósticos equivocados.
