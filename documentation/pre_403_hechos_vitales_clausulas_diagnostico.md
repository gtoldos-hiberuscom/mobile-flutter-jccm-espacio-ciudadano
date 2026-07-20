# Diagnóstico: 403 en `hechos-vitales/clausulas` en PRE (funciona en UAT)

> **Fecha:** 2026-07-20 · **Estado:** causa raíz identificada — pendiente de acción del equipo de backend/SSO.
> Este documento contiene datos de **usuarios de prueba** (Eidas Certificado, NIF de test `99999999R`).
> No incluye tokens firmados completos; solo los *payloads* decodificados de tokens de prueba caducados.

## Resumen ejecutivo

Al arrancar la app en **PRE** (`preproduction`), la carga de clausulas falla siempre con **403**:

- `GET /api/v1/hechos-vitales/clausulas/{idAgente}` → 403
- `POST /api/v1/hechos-vitales/clausulas` → 403

En **UAT** (`development`) el mismo flujo (login Cl@ve → GET clausulas → POST aceptación) funciona.

**Causa raíz (confirmada al comparar los access tokens):** el access token de PRE **no contiene el rol de
realm `Ciudadano`** (`realm_access.roles`), que el token de UAT sí trae. El microservicio downstream
`hechos-vitales` autoriza por ese rol; sin él responde 403. El origen es de **backend/SSO de PRE**
(al usuario `PER2437238` no se le ha asignado el rol `Ciudadano`, o el cliente Keycloak de PRE no incluye
el *realm-roles mapper* que lo inserta en el access token). **No es un bug de la app.**

La app envía exactamente la misma petición en ambos entornos (solo cambian la URL base y el token del SSO
correspondiente). El cuerpo del error confirma que el fallo es downstream de la fachada:

```json
{
  "status": 403,
  "error": "Forbidden",
  "message": "Error al consultar clausulas: 403 Forbidden: [no body]",
  "path": "/api/v1/hechos-vitales/clausulas/PER2437238"
}
```

El texto `"Error al consultar clausulas: 403 Forbidden: [no body]"` es la **fachada de PRE reportando
que su propia llamada al microservicio downstream (`hechos-vitales`) devolvió 403 sin cuerpo**. Es decir:
el token supera la validación de la fachada (si no, sería 401), pero al propagar la petición al servicio
downstream de PRE, éste la rechaza. → **Problema de configuración de backend / infra / Keycloak en PRE.**

## Evidencia

### Configs (idénticas salvo host de API/SSO y nombre de flavor)

| Clave | UAT (`config_development.json`) | PRE (`config_preproduction.json`) |
|---|---|---|
| `APP_FLAVOR` | `development` | `preproduction` |
| `BASE_URL` | `https://fachada-sede-api-uat.cm-pre.jccm.es` | `https://fachada-sede-api-pre.cm-pre.jccm.es` |
| `SSO_BASE_URL` | `https://sso-cerbero-uat.cm-pre.jccm.es/auth` | `https://sso-cerbero-pre.cm-pre.jccm.es/auth` |
| `SSO_REALM` | `usuarios` | `usuarios` |
| `SSO_CLIENT_ID` | `add-espacio_ciudadano_mobile-fo` | `add-espacio_ciudadano_mobile-fo` |
| `SSO_REDIRECT_URI` | `es.jccm.espaciociudadano://auth/callback` | `es.jccm.espaciociudadano://auth/callback` |

Mismo realm, mismo `client_id`, mismo redirect. Solo difieren los hosts.

### `curl` reproducible (PRE)

```bash
curl -i \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer <ACCESS_TOKEN_PRE>" \
  "https://fachada-sede-api-pre.cm-pre.jccm.es/api/v1/hechos-vitales/clausulas/PER2437238"
# → HTTP/1.1 403 Forbidden
```

## Comparación de tokens (ambos son access tokens `typ: Bearer`)

Comparación cerrada con el **access token** de cada entorno (el que la app manda en `Authorization: Bearer`).
Nota: en una primera iteración se aportó por error el **ID token** de UAT (`typ: ID`, `aud` = el propio
cliente); no sirve para comparar audiencias/roles del recurso. Abajo ya está el access token correcto.

### PRE — access token (falla), usuario `PER2437238`

```json
{
  "iss": "https://sso-cerbero-pre.cm-pre.jccm.es/auth/realms/usuarios",
  "typ": "Bearer",
  "azp": "add-espacio_ciudadano_mobile-fo",
  "aud": ["add-indexa-api", "add-notifica3-api", "add-ventanilla-api",
          "Generador_Carnes", "add-repo_usu-api", "add-espacio_ciudadano-api"],
  "scope": "openid ext_profile profile",
  "idAgente": "PER2437238",
  "preferred_username": "per2437238",
  "PersonIdentifier": "99999999R",
  "clasificacionCertificado": "0"
}
```

### UAT — access token (funciona), usuario `PER9998003`

```json
{
  "iss": "https://sso-cerbero-uat.cm-pre.jccm.es/auth/realms/usuarios",
  "typ": "Bearer",
  "azp": "add-espacio_ciudadano_mobile-fo",
  "aud": ["add-indexa-api", "add-ventanilla-api", "add-repo_usu-api",
          "add-espacio_ciudadano-api", "add-notifica3-api", "Generador_Carnes"],
  "realm_access": { "roles": ["Ciudadano"] },
  "scope": "openid clave_representado ext_profile profile",
  "idAgente": "PER9998003",
  "preferred_username": "per9998003",
  "PersonIdentifier": "99999999R",
  "clasificacionCertificado": "0",
  "personIdentifierType": "NIF"
}
```

### Diferencias observadas (UAT funciona ↔ PRE falla)

| Claim | UAT (funciona) | PRE (falla) | ¿Sospechoso? |
|---|---|---|---|
| `aud` | mismas 6 APIs (incl. `add-espacio_ciudadano-api`) | mismas 6 APIs | No — idéntico |
| **`realm_access.roles`** | **`["Ciudadano"]`** | **ausente** | **SÍ — causa raíz probable** |
| `scope` | `openid clave_representado ext_profile profile` | `openid ext_profile profile` | Posible (falta `clave_representado`) |
| `personIdentifierType` | `NIF` | ausente | Secundario |
| `azp` / realm | `add-espacio_ciudadano_mobile-fo` / `usuarios` | igual | No |

**Conclusión:** la `aud` es idéntica, así que no es un problema de audiencia. La diferencia decisiva es que
el token de PRE **no incluye el rol de realm `Ciudadano`** (ni el scope `clave_representado`). El downstream
`hechos-vitales` autoriza por el rol `Ciudadano`; su ausencia produce el 403 `[no body]`.

## Por qué se descarta la app (referencias de código)

1. **El flavor no altera la request.** El único branch por flavor es `sedeBaseUrl`
   (`lib/core/config/app_config.dart:31-36`), una URL de sede para enlaces externos; no toca
   cabeceras/params/body de la API. Cliente Dio idéntico en todos los flavors
   (`lib/core/network/api_client.dart:13-24`).
2. **La request de clausulas solo lleva `Authorization: Bearer <token>` + `Content-Type/Accept: application/json`.**
   No hay api-key/app-key ni cabeceras `x-*` (`lib/core/network/network_interceptors.dart:23-38`;
   `lib/features/consent/3_data/repositories/consent_repository_impl.dart`). El `idAgente` del path y del
   body sale del claim `idAgente` del JWT.
3. **La app envía el access token, no el ID token** (correcto):
   `lib/core/network/api_client_provider.dart:12` → `tokenGetter: () => ref.read(tokenResponseProvider)?.accessToken`;
   claims decodificados también del access token (`lib/features/auth/1_domain/login_use_case.dart:43`).
   El log de PRE confirma que se envía un `typ: Bearer`.
4. **Lo único específico de entorno es `baseUrl` + el token del SSO.** No hay lógica condicional de negocio
   por entorno que pudiera cambiar el resultado.

## Prueba decisiva recomendada (barata, aísla la causa)

Hacer **login cruzado de usuario** para separar "problema de usuario" de "problema de entorno":

- **Login en PRE con el usuario que funciona en UAT (`PER9998003`)**:
  - Si **funciona** → el 403 es específico de `PER2437238` en PRE → **alta/permisos del usuario en `hechos-vitales` de PRE** (hipótesis 3).
  - Si **también falla** → es configuración transversal de PRE (Keycloak/servicio) → hipótesis 1/2.
- (Complementario) Login en UAT con `PER2437238`: si falla en UAT también, refuerza que el problema es del usuario.

## Acciones para el equipo de backend / SSO (PRE) — por prioridad

1. **Conseguir que el access token de PRE incluya el rol de realm `Ciudadano`** (`realm_access.roles`).
   Dos posibles causas a revisar en Keycloak (realm `usuarios`, PRE):
   - **Asignación de rol al usuario:** que `PER2437238` (y en general los usuarios que llegan por Cl@ve)
     tengan asignado el rol de realm `Ciudadano` — como sí lo tiene `PER9998003` en UAT. Puede requerir
     configurar `Ciudadano` como *default role* del realm, o el flujo/mapper que lo asigna al alta por Cl@ve.
   - **Mapper en el cliente/scope:** que el cliente `add-espacio_ciudadano_mobile-fo` (o un client scope que
     use) tenga habilitado el mapper de *realm roles* de forma que `Ciudadano` llegue al **access token**.
2. **Revisar el scope `clave_representado`**: en UAT está en el token y en PRE no. Confirmar si `hechos-vitales`
   lo necesita (probablemente secundario frente al rol, pero conviene alinearlo entre entornos).
3. **Confirmar que `hechos-vitales` de PRE autoriza por el rol `Ciudadano`** (revisar su config de seguridad):
   es lo que explica el 403 `[no body]` cuando el token no lo trae.

## Estado del diagnóstico

- ✅ **Cerrado del lado cliente.** Causa raíz identificada comparando ambos access tokens: el de PRE **carece
  del rol de realm `Ciudadano`** (y del scope `clave_representado`); el resto (`aud`, realm, `azp`) coincide.
- ⏭️ **Acción pendiente en backend/SSO de PRE** según la lista anterior. Verificación tras el cambio: repetir
  el `curl` de arriba con un token de PRE que ya incluya `realm_access.roles: ["Ciudadano"]` → debe devolver 200.

## Referencias cruzadas (contexto del proyecto)

- El login decodifica los claims del **access token local**, no de `/userinfo`; cada endpoint usa un id
  distinto (`idAgente` para clausulas). 
- El backend de la fachada lanza errores crudos (NPE/500/403) en vez de validar limpiamente.
- La cláusula 0 es el gate de consentimiento para *otros* endpoints; **aquí** el 403 es sobre el propio
  endpoint de clausulas (antes de aceptar nada), por lo que no es ese gate.
