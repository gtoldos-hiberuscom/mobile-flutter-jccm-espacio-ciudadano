# Fix OIDC/AppAuth con Cl@ve: reautenticación forzada y selector de método

> **Actualización 18/09/2026 (#282296).** Dos cosas de este documento quedaron
> superadas: (1) `promptValues: [Prompt.login, Prompt.selectAccount]` **rompía** la
> propagación del `ForceAuthn` —Cerbero compara el parámetro entero contra `"login"`—,
> hoy se envía `prompt=login` a secas; y (2) el `externalUserAgent` efímero ya sólo
> afecta a iOS: el fork de Android se retiró al corregir la causa real. El último punto
> del checklist de abajo (propagación de `prompt=login` hacia Cl@ve) está **resuelto y
> verificado**. Ver `../docs/auth/clave_forceauthn_retest_2026-09.md`.

**Rama:** `fix/appauth` · **Fecha:** 2026-07-07 · **Librería:** `flutter_appauth 12.0.0`

## Problema

Tras elegir **Cl@ve Permanente** con certificado/contraseña caducados y pulsar atrás,
la cookie de sesión del navegador del sistema (Chrome Custom Tabs en Android,
`ASWebAuthenticationSession` en iOS) recordaba el estado del broker (Keycloak
`sso-cerbero`). En el siguiente intento de login el broker saltaba directamente al
método anterior sin volver a mostrar el selector de método de autenticación.

Causa raíz en la app: `prompt=login` solo se enviaba cuando existía el flag local
`force_clave_login_on_next_login` (se activaba en logout o instalación limpia), pero
**no tras un intento fallido o cancelado**. Nunca se enviaba `max_age=0`. Además el
logout del menú de perfil solo borraba tokens locales sin invocar `end_session`, por
lo que la cookie SSO del broker sobrevivía al logout.

## Cambios aplicados

| Área | Cambio |
|---|---|
| `lib/features/auth/3_data/auth_repository_impl.dart` | `promptValues: [Prompt.login, Prompt.selectAccount]` y `additionalParameters: {'max_age': '0'}` **incondicionales** en cada login. `externalUserAgent: ephemeralAsWebAuthenticationSession` en login y `endSession` (solo afecta a iOS/macOS). Mapeo de `FlutterAppAuthPlatformException` distinguiendo error OAuth del servidor (`error`/`error_description`) de fallo técnico del SDK. |
| `lib/features/auth/1_domain/auth_repository.dart`, `login_use_case.dart` | Eliminado el parámetro `forceLogin` (muerto: ahora siempre se fuerza). |
| `lib/features/landing/2_presentation/landing_notifier.dart` | Eliminada la lectura/borrado del flag de forzado. |
| `lib/core/app/bootstrap.dart`, `lib/core/storage/storage_keys.dart` | Eliminado el flag `force_clave_login_on_next_login` (la limpieza de secure storage en instalación limpia se mantiene). |
| `lib/features/auth/2_presentation/widgets/authenticated_profile_menu.dart` | El logout ahora ejecuta **RP-initiated logout** (`endSession` con `id_token_hint` + `post_logout_redirect_uri`) cuando hay `id_token` en memoria, y siempre limpia la sesión local (patrón `try/finally`, igual que `consent_notifier.reject()`). |
| `lib/features/preferences/2_presentation/preferences_page.dart` | Ídem en el borrado de cuenta. |

### Lo que NO se ha hecho (deliberadamente)

- **Android:** no se implementa ninguna "limpieza" de cookies de Chrome Custom Tabs
  (imposible desde la app) ni se migra a WebView. La mitigación en Android es
  exclusivamente por protocolo: `prompt=login` + `max_age=0` en cada intento.
- No se envía ningún hint de selección de método. Verificado con grep en `lib/`:
  no existen `login_hint` (los callers no lo pasan), `acr_values`, `amr_values`,
  `idp_hint`, `kc_idp_hint`, `provider` ni `auth_method`.

## URL de autorización (anonimizada)

`state`, `nonce` y `code_challenge` los genera el SDK nativo de AppAuth **nuevos en
cada intento** (PKCE S256 automático); cada llamada a `login()` construye un
`AuthorizationTokenRequest` nuevo, nunca se reutiliza el anterior.

**Antes** (intento normal, sin flag de forzado):

```
https://<SSO_HOST>/auth/realms/usuarios/protocol/openid-connect/auth
  ?response_type=code
  &client_id=<CLIENT_ID_MOVIL>
  &redirect_uri=es.jccm.espaciociudadano%3A%2F%2Fauth%2Fcallback
  &scope=openid
  &state=<ALEATORIO>
  &nonce=<ALEATORIO>
  &code_challenge=<ALEATORIO>
  &code_challenge_method=S256
```

**Después** (todos los intentos):

```
https://<SSO_HOST>/auth/realms/usuarios/protocol/openid-connect/auth
  ?response_type=code
  &client_id=<CLIENT_ID_MOVIL>
  &redirect_uri=es.jccm.espaciociudadano%3A%2F%2Fauth%2Fcallback
  &scope=openid
  &state=<ALEATORIO>
  &nonce=<ALEATORIO>
  &code_challenge=<ALEATORIO>
  &code_challenge_method=S256
  &prompt=login          ← nuevo, siempre
  &max_age=0             ← nuevo, siempre
```

### Cómo capturar la URL real como evidencia

- **Android:** con el dispositivo conectado, lanzar el login y ejecutar:
  `adb logcat | grep -iE "openid-connect/auth|prompt|max_age"` — el intent de
  Custom Tabs incluye la URL completa. Alternativa: proxy (Charles/mitmproxy) o
  copiar la URL desde la barra del navegador manteniendo pulsado.
- **iOS:** ejecutar desde Xcode y observar la URL en la consola (AppAuth-iOS la
  traza al abrir `ASWebAuthenticationSession`), o usar un proxy.
- Anonimizar `state`, `nonce`, `code_challenge` antes de adjuntar.

## Guion de pruebas manuales (evidencias pendientes de ejecución en dispositivo)

### Android (escenario del bug)

1. Login → elegir **Cl@ve Permanente** con credencial caducada.
2. Pulsar **atrás** hasta volver a la app.
3. Cerrar la app por completo (swipe en recientes).
4. Reabrir la app.
5. Pulsar login.
6. **Esperado:** el broker muestra de nuevo el **selector de método** (evidencia:
   captura de pantalla). La URL del paso 5 contiene `prompt=login&max_age=0`.

### iOS

- Con `ephemeralAsWebAuthenticationSession` (estado actual del código): no aparece
  el aviso del sistema "…quiere usar sso-cerbero… para iniciar sesión", no se
  comparten cookies y el selector aparece siempre. Capturar.
- Sin efímera (revertir temporalmente a `asWebAuthenticationSession` para la
  evidencia comparativa): iOS muestra el diálogo de consentimiento del sistema y
  reutiliza cookies de sesiones anteriores; con `prompt=login` el broker debe
  reautenticar igualmente. Capturar ambas.

Nota de producto (iOS): la sesión efímera implica **no reutilizar SSO** entre la app
y Safari. Dado que el producto ya fuerza `prompt=login` en cada login (nunca se
aprovechaba el SSO), no hay pérdida funcional.

## Checklist a verificar con backend / equipo Keycloak (Cerbero)

- [ ] `client_id` móvil (`add-espacio_ciudadano_mobile-fo`) separado del cliente web. *(Ya parece serlo por el sufijo `mobile`; confirmar.)*
- [ ] `es.jccm.espaciociudadano://auth/callback` registrado como **redirect_uri** válido del cliente móvil.
- [ ] `es.jccm.espaciociudadano://auth/callback` registrado también como **post_logout_redirect_uri** válido (Keycloak: "Valid post logout redirect URIs"). Sin esto, `endSession` fallará (la app lo tolera y limpia la sesión local igualmente, pero la cookie SSO no se invalidaría).
- [ ] `end_session_endpoint` presente en `https://<SSO_HOST>/auth/realms/usuarios/.well-known/openid-configuration`.
- [ ] Los errores/cancelaciones de Cl@ve (certificado caducado, contraseña caducada, cancelar) **redirigen de vuelta a la app** vía `redirect_uri` con `error=...`, no dejan al usuario en la plataforma web de Cl@ve.
- [x] El broker **propaga `prompt=login` y `max_age=0`** hacia el IdP de Cl@ve — verificado 18/09/2026 leyendo la `SAMLRequest` (`ForceAuthn="true"`), siempre que el `prompt` sea exactamente `login` (Keycloak debe re-lanzar la autenticación en el identity provider, no servir la sesión del broker).
- [ ] El broker no persiste en cookie el último método de autenticación de forma no reseteable (o la ignora cuando llega `prompt=login`).

## Manejo de errores/cancelación (estado tras el fix)

- `FlutterAppAuthUserCancelledException` → `AuthException.cancelled` → la UI
  silencia el error y resetea `isLoggingIn` (el usuario cerró el navegador).
- `FlutterAppAuthPlatformException` con `error` OAuth del servidor →
  `AuthException.remoteFailure` con `error — error_description` (nunca se muestra
  el error crudo al usuario; ver `AppError`/`AuthException`).
- Resto (fallo técnico del SDK/red) → `AuthException.unexpected`.
- Cada intento crea un request nuevo (state/nonce/code_verifier frescos generados
  por el SDK nativo); no se cachea nada del intento anterior en la app.
