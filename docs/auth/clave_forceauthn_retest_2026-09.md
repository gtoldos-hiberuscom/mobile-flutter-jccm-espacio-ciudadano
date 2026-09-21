# Reprueba de la sesión Cl@ve en Android tras el `ForceAuthn` de Cerbero

**Fecha:** 2026-09-18 · **Ticket:** gestproy Task #282296 · **Entorno:** PRE
(`sso-cerbero-pre.cm-pre.jccm.es`, realm `usuarios`) · **Rama:**
`fix/clave-forceauthn-retest-282296`

> **Resumen para quien llegue de nuevas:** la app enviaba `prompt=login select_account`
> y la extensión de Cerbero compara ese parámetro entero contra `"login"`, así que la
> `AuthnRequest` hacia Cl@ve salía con `ForceAuthn="false"`. Corregido a `prompt=login`,
> Cl@ve vuelve a desafiar **sin necesidad del fork** (§3.4 y §4). Las secciones 2 y 3
> describen las mediciones hechas *antes* de saberlo: se conservan porque son el camino
> que llevó hasta aquí, pero hay que leerlas con eso en mente.

## 1. Qué se probaba y por qué

En la nota #6 del Task #282296, Cerbero informa de que la propagación de
`prompt=login` → `ForceAuthn="true"` en la `AuthnRequest` SAML hacia Cl@ve está
desplegada **hasta producción**. Era el punto pendiente del checklist de
`documentation/appauth_clave_relogin_fix.md` y el motivo por el que en agosto se
vendorizó el fork de `flutter_appauth` con Ephemeral Custom Tabs
(`packages/flutter_appauth`, ver `clave_android_session_investigation.md`).

Hipótesis a medir: **con el `ForceAuthn` desplegado, el aislamiento del navegador
sobra y se puede volver a la librería publicada.**

## 2. Montaje

Una sola variable entre las dos builds: la dependencia.

| | Build A | Build B |
|---|---|---|
| `flutter_appauth` | `^12.0.0` de pub.dev | fork `12.0.0+jccm.1` (`packages/flutter_appauth`) |
| Custom Tabs en Android | normales (el plugin de serie **ignora** `externalUserAgent`) | **efímeras** |
| Todo lo demás | idéntico | idéntico |

`prompt` y `max_age=0` se envían **incondicionalmente en los dos casos**:
`lib/features/auth/3_data/auth_repository_impl.dart`. No se tocó ese fichero en
ninguna de las dos builds. **Ojo:** en estas dos builds el valor era
`prompt=login select_account`, que es justamente lo que anulaba el `ForceAuthn`
(§4). Los resultados del §3 hay que leerlos sabiendo eso.

Dispositivo: emulador Android 17 (`emulator-5554`), arm64-v8a, **Chrome 145**
(≥136, o sea con soporte de navegación efímera). Instalación limpia
(`adb uninstall` + `install`, nunca `install -r`). Config
`config_preproduction.json`, con `SSO_OFFLINE_ACCESS: "true"`.

Para medir sin depender de lo que se ve en pantalla se añadió `auth_time` al
arnés de diagnóstico de sesión (`SessionTokenDiagnostics`, commit `705c45d`): es
el instante en que Keycloak dice que el ciudadano autenticó por última vez.

## 3. Resultados

### 3.1 Caso A — cancelar Cl@ve Permanente y reintentar (Build A, sin efímeras)

Login → Cl@ve Permanente → atrás → cerrar la app → login otra vez.

**Resultado: ❌.** Entra **directamente a Cl@ve Permanente, sin pasar por el
selector de métodos.** Sin identificación previa en los 60 minutos anteriores, o
sea que no es la auto-identificación declarada por la pasarela.

Esto es **peor que la línea base de agosto**, donde el selector sí aparecía en
cada intento (contraste A/B del 07/09/2026).

### 3.2 Caso B — login completo, logout y login inmediato

Mismo guion en las dos builds, dentro de la ventana de 60 minutos de la pasarela
y con el cookie jar de Chrome sucio a propósito (identificación real previa).

**Build A — librería de serie:**

| Hora | Evento | `auth_time` |
|---|---|---|
| 11:08:38 | Login 1, identificación real en Cl@ve | `1789722518` |
| 11:08:52 | Logout del menú de perfil → `POST /logout` → **204** («Offline session revoked in Keycloak») | — |
| 11:08:59 | Login 2 — **no se pide absolutamente nada**: ni selector, ni credencial | `1789722539` |

**Build B — fork con Custom Tabs efímeras:**

| Hora | Evento | `auth_time` |
|---|---|---|
| 11:15:27 | Login 1, identificación real en Cl@ve | `1789722927` |
| 11:15:48 | Logout → `POST /logout` → **204** | — |
| 11:15:49+ | Login 2 — **Cl@ve vuelve a pedir autenticación** ✅ | — (no se completó) |

### 3.3 Matriz

| Caso | Build A (de serie) | Build B (fork efímero) |
|---|---|---|
| Sale el selector de métodos | ❌ (Caso A: va directo a Permanente) | ✅ |
| Re-desafía credencial tras logout | ❌ entra en silencio | ✅ pide autenticar |
| Sesión de Keycloak cerrada | ✅ `204` | ✅ `204` |
| `auth_time` nuevo en el 2.º login | ✅ (+21 s) | n/a |

### 3.4 Build C — `prompt=login` a secas **y sin** efímeras (la que importa)

Tras el aviso de Cerbero y el arreglo del §4, mismo emulador y mismo guion, con la
librería de serie de pub.dev (sin fork, Custom Tabs normales):

| Hora | Evento |
|---|---|
| 13:59:10 | Login 1, identificación real en Cl@ve (`auth_time` `1789732750`) |
| 13:59:21 | Logout → `POST /logout` → **204** |
| 13:59:2x | Login 2 — **Cl@ve pide autenticar** ✅ |

**Con `prompt=login` a secas, la librería de serie se comporta como el fork.** El
aislamiento del navegador deja de ser necesario para este escenario.

Verificado que la build era la correcta, y no de oídas:

- El APK instalado es **bit a bit** el compilado (`md5` idéntico entre
  `/data/app/…/base.apk` y `build/app/outputs/flutter-apk/app-debug.apk`).
- Sus DEX **no contienen** ningún marcador del fork (`ephemeral_browsing_unavailable`,
  `isEphemeralBrowsingAvailable`, `FlutterAppauthEphemeral`), con control positivo: 148
  referencias a `net/openid/appauth`, o sea que la búsqueda sí encuentra lo que hay.
- Y la URL real, leída del propio dispositivo con
  `adb shell dumpsys activity activities`: el Custom Tab abierto durante la prueba se
  lanzó con **`prompt=login`**, mientras que en la misma tarea sobrevive el registro de
  las builds anteriores con **`prompt=login%20select_account`**. Las dos, una al lado de
  la otra, en el mismo emulador.

## 4. La causa real: `prompt=login select_account` apaga el `ForceAuthn`

> **Corrección.** La primera versión de esta sección concluía que la
> `AuthnRequest` llevaba `ForceAuthn="true"` y que, por tanto, el eslabón que
> fallaba era la pasarela. **Era un error de método**: la URL que se probó con
> `curl` llevaba `prompt=login` a secas, y la app envía
> `prompt=login select_account`. Se midió una petición que la app no hace.

El 18/09, antes de que respondiéramos al ticket, Cerbero avisó de que en sus logs
de PRE ven llegar `prompt=login select_account` y que **su extensión compara el
parámetro entero contra `"login"`**, así que esa combinación no le casa. El
estándar permite combinar valores separados por espacio (RFC/OIDC Core 3.1.2.1),
pero su implementación aún no.

Verificado leyendo la `SAMLRequest` que el broker manda a Cl@ve, cuatro
variantes del mismo flujo contra PRE con el `client_id` móvil:

| `prompt` enviado | `ForceAuthn` en el SAML saliente |
|---|---|
| `login select_account` ← **lo que enviaba la app** | **`false`** |
| `login` | **`true`** |
| `select_account login` | `false` |
| (sin `prompt`) | `false` |

Es decir: **durante todo este tiempo las peticiones reales de la app han llegado a
Cl@ve con `ForceAuthn="false"`.** No es que la pasarela ignorase la orden: es que
nunca se la dimos. Y explica de paso por qué al técnico de Cerbero «sí le
funcionaba» en el navegador: sus pruebas iban con `prompt=login` a secas.

`select_account` no aportaba nada —Cerbero no tiene cuentas múltiples— y venía del
fix de julio (`documentation/appauth_relogin_fix.md`).

**Arreglo:** `promptValues: const [Prompt.login]` en
`lib/features/auth/3_data/auth_repository_impl.dart`, con test de regresión en
`test/features/auth/auth_repository_impl_ephemeral_test.dart` que asserta la
serialización exacta — si alguien vuelve a añadir un valor, el `ForceAuthn` se
caería en silencio otra vez.

## 5. Conclusión

1. La app enviaba `prompt=login select_account`. **CONFIRMED** (código).
2. Con ese valor, el SAML hacia Cl@ve sale con `ForceAuthn="false"`; con
   `prompt=login` sale `"true"`. **CONFIRMED** (XML decodificado, tabla arriba).
3. Con `ForceAuthn="false"`, la pasarela aplica su ventana de auto-identificación
   de 60 minutos y no desafía. **OBSERVED** (Build A del §3).
4. El aislamiento del navegador lo evitaba porque la pestaña efímera no hereda la
   sesión de Cl@ve, no porque arreglase la reautenticación. **OBSERVED**
   (Build B del §3).

5. Con el `prompt` corregido y **sin** fork, Cl@ve vuelve a desafiar. **OBSERVED**
   (Build C, §3.4).

O sea que el problema era nuestro y se arregla con una línea. La pasarela sí respeta
el `ForceAuthn` cuando le llega: nunca le había llegado.

**Qué queda antes de retirar el fork.** La Build C cubre un escenario (logout y
volver a entrar) con un método. Antes de quitar `packages/flutter_appauth` conviene
repetir con el `prompt` corregido: el Caso A (cancelar Permanente y reintentar, que
era el del ticket), el método de certificado/eIdentifier —que en agosto era el que
sobrevivía— y una pasada en dispositivo real. Mientras tanto la rama se queda con
la librería de serie: el fork sigue vendorizado, sin usar, y volver a él es una
línea.

## 6. Reproducir

```bash
git switch fix/clave-forceauthn-retest-282296
# Build B (fork, estado actual de la rama)
fvm flutter run --dart-define-from-file=config_preproduction.json -d emulator-5554
# Build A: en pubspec.yaml, sustituir el bloque del fork por `flutter_appauth: ^12.0.0`
```

El emulador necesita la VPN del Mac y arrancar con `-dns-server <DNS corporativo>`:
`se-pasarela.clave.gob.es` resuelve a una privada alcanzable sólo por el túnel.
Los dos logins de cada caso deben ir **dentro de 60 minutos**, y conviene dejar el
jar de Chrome sucio a propósito: si no, Cl@ve pide credenciales de todas formas y
el verde es falso.

Logs completos de ambas ejecuciones: en el scratchpad de la sesión
(`run_upstream_282296.log`); el `auth_time` sale en las líneas `session-lifetimes`.

### 6.1 Releer la `AuthnRequest` sin gastar una identificación

No hace falta ni dispositivo ni credenciales: sólo VPN.

```bash
U='https://sso-cerbero-pre.cm-pre.jccm.es/auth/realms/usuarios/protocol/openid-connect/auth?client_id=add-espacio_ciudadano_mobile-fo&redirect_uri=es.jccm.espaciociudadano%3A%2F%2Fauth%2Fcallback&response_type=code&scope=openid&code_challenge=<S256>&code_challenge_method=S256&state=diag&nonce=diag&prompt=login&max_age=0'
R=$(curl -s -c cj.txt -o /dev/null -w '%{redirect_url}' "$U")   # 303 al broker clavesp-saml
curl -s -b cj.txt -c cj.txt -o broker.html "$R"                  # form de auto-envío
# extraer el value de SAMLRequest, base64-decode (binding POST: sin deflate) y leer
# los atributos de <saml2p:AuthnRequest>
```

Variando sólo el `prompt` se obtiene la tabla del §4: `login` → `true`;
`login%20select_account`, `select_account%20login` o sin parámetro → `false`.

## 7. Relacionado

- `clave_android_session_investigation.md` — las capas de sesión y por qué el
  «Modelo B» (borrar cookies en el logout) es inviable en Android.
- `historico/flutter_appauth_android_ephemeral_design.md` y `..._poc_results.md` — el fork.
- `historico/flutter_appauth_fork_maintenance_plan.md` — mantenimiento y vuelta a upstream.
- `../../documentation/appauth_clave_relogin_fix.md` — el fix por protocolo de
  julio y el checklist que Cerbero cerró con la nota #6.
