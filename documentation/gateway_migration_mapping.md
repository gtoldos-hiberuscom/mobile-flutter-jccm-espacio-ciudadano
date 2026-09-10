# Migración al API Gateway de Espacio Ciudadano — mapeo de endpoints

Documento de trabajo. Recoge la correspondencia entre los endpoints que la app
consume hoy contra la fachada y los que expone el nuevo gateway de integración,
según la documentación funcional facilitada por el cliente.

Estado: migradas **cláusulas, hechos vitales y preferencias, recomendaciones,
educación, salud, bienestar social, empleo, vivienda y vehículos**. Quedan
agenda, carnets digitales, gestión y contacto de notificaciones. Soporte con
sesión ya va por `/ciudadanos/{idAgente}/soporte`; sin sesión sigue en
`/api/v1/soporte`, que el gateway no sirve (404).
Las citas hospitalarias están ocultas tras un flag, pendientes de validar diseño.

> **Corrección importante (revisada con el OpenAPI de UAT).** Las rutas nuevas
> `/api/v1/ciudadanos/{...}/...` **ya existen en la fachada**: no hacía falta el
> gateway para migrar. Lo que provocaba el 403 no era una ruta inexistente, sino
> el identificador equivocado en la ruta. Ver *El identificador depende de la
> operación*.

## Modelo de integración

La app dejará de llamar a la fachada directamente. El gateway expone el API
público, oculta los endpoints internos y aplica seguridad, rate limit y
filtrado. El enrutado interno (`/api/v1/{idAgente}/operacion` hacia la fachada)
es transparente para la app.

Consecuencias de diseño:

- Las rutas pasan de estar orientadas a dominio/verbo (`/hechos-vitales/...`,
  `/sescam/...`, `/educacion/...`) a estar orientadas al recurso ciudadano:
  `/api/v1/ciudadanos/{sid}/...`.
- `{sid}` es el claim **`sub_alt`** del token ("identificador del usuario que se
  obtuvo del token"). El gateway lo traduce internamente a `idAgente`.
  Verificado contra UAT: Cerbero lo emite y es un UUID, por ejemplo
  `f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6`.
- El sobre de respuesta se mantiene: `{ body, timestamp, mensaje-respuesta,
  codigo-respuesta, info-error }`, con los datos en `body`. El interceptor de
  compatibilidad (`generatedApiUnwrapBodyExtraKey`) sigue sirviendo.

## El gateway (UAT)

```
https://gateway-espacio-ciudadano-uat.cm-pre.jccm.es
```

No publica OpenAPI (`/v3/api-docs` responde 404), pero su superficie se puede
mapear sin credenciales: las rutas existentes responden **401** y las
inexistentes **404**. Comprobado el 2026-08-19:

| Rutas | Respuesta |
| --- | --- |
| `/api/v1/ciudadanos/{id}/` + clausulas, hechos, preferencias, recomendaciones, contacto, notificaciones, expedientes, registros, soporte | 401 (existen) |
| `/api/v1/ciudadanos/{id}/salud/*`, `/educacion/*`, `/eventos/*` | 401 (existen) |
| `/api/v1/hechos-vitales/clausulas/{id}`, `/api/v1/sescam/*`, `/api/v1/educacion/*/{id}`, `/api/v1/soporte`, `/api/v1/agenda/*` | **404 (no existen)** |

**El gateway sólo sirve la superficie nueva.** No hay convivencia: apuntar
`BASE_URL` al gateway rompe de golpe todas las features que aún usan rutas
antiguas. Es un corte duro.

**Matiz sobre el sondeo (2026-08-20): discrimina el prefijo, no la operación.**
`/api/v1/ciudadanos/**` devuelve 401 entero, incluso para rutas inventadas
(`/api/v1/ciudadanos/ID/empleo/inventada-xyz` → 401). El gateway rechaza por
autenticación antes de resolver el segmento final, así que el sondeo **no sirve
para confirmar el nombre de una operación concreta**; sólo que la familia
`/ciudadanos/...` está enrutada y las antiguas no.

### Estrategia recomendada

Migrar contra **la fachada**, que expone las dos superficies, y dejar el cambio
de host para el final:

1. `BASE_URL` sigue en la fachada mientras dura la migración.
2. Se migra feature a feature a las rutas `/ciudadanos/{...}/...`, que ya existen
   allí (99 rutas en su OpenAPI).
3. Cuando no quede ninguna ruta antigua en uso, se cambian `BASE_URL` y
   `CIUDADANOS_ID_STRATEGY` a `subAlt`, y el gateway funciona sin más cambios.

Hacerlo al revés —apuntar al gateway y migrar desde ahí— deja la app inutilizable
durante toda la migración, empezando por el login: el guard consulta cláusulas
nada más autenticar.

## El OpenAPI de UAT es la fuente de verdad

Se descarga sin autenticación y contiene 99 rutas, incluida toda la superficie
nueva orientada a recurso:

```
https://fachada-sede-api-uat.cm-pre.jccm.es/v3/api-docs
```

El `fachada-sede-api-swagger.yaml` del repo, del que se genera
`generated/dart_dio_client`, está desactualizado respecto a esto: no incluye
ninguna ruta `/ciudadanos/{...}/salud/...`. Conviene regenerarlo desde esa URL
antes de migrar más secciones.

## El identificador depende de la operación

La fachada **no usa un identificador único** en `/api/v1/ciudadanos/{...}`. Cada
operación declara el suyo:

| Segmento | Familias de operaciones |
| --- | --- |
| `{numDocumento}` | salud (CIP y primaria), educacion, vehiculos, vivienda, empleo, bienestar-social |
| `{idAgente}` | salud (hospitalaria), clausulas, hechos, preferencias, recomendaciones, eventos, expedientes, registros, soporte, empleo, bienestar-social |
| `{dni}` | carnet-digital |
| `{id}` | contacto, notificaciones, contacto-registro-poblacional, bienestar-social |

Dentro de una misma pantalla puede haber los dos: en Salud, CIP y primaria van por
documento y hospitalaria por `idAgente`.

Enviar el que no toca devuelve **403, no 404**: la fachada valida el identificador
contra el token antes de resolver la operación. Ese fue el origen del 403 que se
diagnosticó mal al principio como "la ruta no existe".

`citizenEndpointIdsProvider` resuelve ambos valores desde el token y expone
`requireNumDocumento()` / `requireIdAgente()`, para que cada llamada use el que
declara su ruta.

## Decisiones tomadas

1. **Un único `BASE_URL`.** No se añade una segunda clave de configuración ni un
   segundo cliente Dio. Las rutas nuevas ya funcionan contra la fachada, así que
   la migración puede avanzar sección a sección sin esperar al gateway; cuando
   éste se ponga delante sólo cambia el host.

2. **Con el gateway, el identificador pasa a ser `sub_alt` para todo.** Poner
   `CIUDADANOS_ID_STRATEGY` a `subAlt` hace que `citizenEndpointIdsProvider`
   devuelva ese claim en ambos campos, así que el corte es un cambio de
   configuración, sin tocar código.

3. **Cliente escrito a mano para las rutas nuevas.** El `fachada-sede-api-swagger.yaml`
   del repo no las incluye, así que `3_data/api/salud_api.dart` envuelve Dio
   directamente. Al regenerar el cliente desde `/v3/api-docs` este wrapper se
   puede sustituir.

### El claim del token

`JwtClaims` expone `subAlt` (claim `sub_alt`), que es lo que pedirá el gateway.
Atención: el claim `sid` que también parseamos es el *session state* de Keycloak,
no el ciudadano. La documentación del gateway llama `{sid}` al segmento de ruta
pero en sus tablas de parámetros lo describe como `sub_alt`; quien coja el claim
`sid` literalmente enviará el identificador de sesión y recibirá un 403.

`ciudadanosEndpointIdProvider` sigue sirviendo a los endpoints `{id}` heredados
(contacto, notificaciones) y acepta ya el valor `subAlt` de configuración.

## Cláusulas y hechos vitales

| Operación | Hoy (fachada) | Gateway |
| --- | --- | --- |
| Consultar cláusulas | `GET /api/v1/hechos-vitales/clausulas/{idAgente}` | `GET /api/v1/ciudadanos/{sid}/clausulas` |
| Alta inicial de cláusulas | `POST /api/v1/hechos-vitales/clausulas` | `POST /api/v1/ciudadanos/{sid}/clausulas` |
| Actualización de cláusulas | `PATCH /api/v1/hechos-vitales/clausulas` | `PATCH /api/v1/ciudadanos/{sid}/clausulas` |
| Lista de hechos vitales | `GET /api/v1/hechos-vitales/hechos/{idAgente}` | `GET /api/v1/ciudadanos/{sid}/hechos` |
| Grabar selección de hechos | `PATCH /api/v1/hechos-vitales/hechos` | `PATCH /api/v1/ciudadanos/{sid}/hechos` |
| Eliminar preferencias | `DELETE /api/v1/hechos-vitales/preferencias/{idAgente}` | `DELETE /api/v1/ciudadanos/{sid}/preferencias` |

Cuerpos y respuestas se mantienen (`ClausulasAgente`, `ListaHechosAgente`,
`Respuesta<Boolean>`, `Respuesta<TextosClausulasAgente>`,
`Respuesta<ListaHechosAgente>`).

Semántica funcional documentada que la app ya asume: en primer acceso sin datos
previos se informa el identificador especial `000000` y las cláusulas vienen con
`seleccionado=false`.

### Qué cláusula exige cada consulta

Los números que cita la documentación del gateway son los `idClausula` del API
(empiezan en 0), no la numeración 1-4 que usaba
`consent_clause_access_matrix.md`, ya corregida.

| Consulta | Cláusula según la documentación | ¿Coincide con la app? |
| --- | --- | --- |
| Salud | 1 · JCCM | Sí |
| Educación | 2 · AGE | Sí |
| Bienestar social | 3 · Recomendaciones | **No: la app exige la 1 · JCCM** |

La discrepancia de bienestar social parece una errata de la documentación.
Contradice el texto de la propia cláusula 1 que devuelve el API —"...en materia
de **Bienestar social**, Empleo, Educación y Salud"— y dejaría la tarjeta de
discapacidad o el título de familia numerosa detrás del consentimiento de
recomendaciones, que no tiene relación. **No se ha cambiado**: pendiente de
confirmar con el cliente.

### Estado

**Cláusulas: migrado.** `consent/3_data/api/clausulas_api.dart` (GET/POST/PATCH
sobre `/api/v1/ciudadanos/{id}/clausulas`) sustituye a `HechosVitalesApi`, y el
repositorio ya no depende del cliente generado ni del interceptor de
compatibilidad. Los identificadores de consentimiento pasan por
`citizenEndpointIdsProvider` en `session_guard`, `landing_notifier`,
`consent_page`, `privacy_page` y `my_data_authorization_provider`.

**Hechos vitales y preferencias: migrado.**
`personalization/3_data/api/hechos_api.dart` cubre `GET`/`PATCH
.../hechos` y `DELETE .../preferencias`. Los identificadores de
`life_events_page` y `preferences_page` pasan por `citizenEndpointIdsProvider`.

El desempaquetado del sobre, que estaba duplicado en tres clientes, vive ahora en
`core/network/api_envelope.dart` (`decodeApiEnvelope`).

Recomendaciones, que cerraba este bloque, está migrado — ver su propia sección.

## Educación

| Operación | Hoy | Gateway |
| --- | --- | --- |
| Títulos universitarios | `POST /api/v1/educacion/titulos-universitarios/{numDocumento}` | `POST /api/v1/ciudadanos/{sid}/educacion/titulos-universitarios` |
| Títulos no universitarios | `POST /api/v1/educacion/titulos-no-universitarios/{numDocumento}` | `POST /api/v1/ciudadanos/{sid}/educacion/titulos-no-universitarios` |

El verbo y el cuerpo no cambian: ya enviamos `DTEDUTUOREQ` / `DTEDUTNUREQ` con
`docu` y `tipodoc`. Sólo desaparece el documento del path.

Requiere la cláusula 2 autorizada.

### Estado: migrado

`my_data/3_data/api/educacion_api.dart` cubre las dos operaciones. El cuerpo
(`tipodoc` + `docu`) no cambia respecto a lo que ya se enviaba; sólo la ruta y el
identificador, que se separa del documento igual que en bienestar social.

**Bug corregido de paso**: `tipodoc` estaba fijado a `'NIF'`. Se disimulaba porque
el backend resolvía al ciudadano por el path; en cuanto el cuerpo pasó a ser la
única fuente del documento, cualquier NIE o CIF habría fallado. Ahora se deduce
del número en `my_data/3_data/document_type.dart`, compartido con bienestar
social, que además distingue CIF (letra inicial A-W) — la versión anterior sólo
contemplaba NIF y NIE.

## Salud (SESCAM)

| Operación | Hoy | Gateway |
| --- | --- | --- |
| CIP | `GET /api/v1/sescam/cip/{numDocumento}` | `GET /api/v1/ciudadanos/{sid}/salud/cip` |
| Citas primaria pendientes | `GET /api/v1/sescam/citas/{numDocumento}` | `GET /api/v1/ciudadanos/{sid}/salud/primaria-citas-pendientes` |
| Citas primaria pasadas | `GET /api/v1/sescam/citas-pasadas/{numDocumento}` | `GET /api/v1/ciudadanos/{sid}/salud/primaria-citas-pasadas` (query `pagina`, opcional, por defecto 0) |
| Citas hospitalarias pendientes | — no se consumía | `GET /api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pendientes` |
| Citas hospitalarias pasadas | — no se consumía | `GET /api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pasadas` |

Tipos de respuesta: `CipResponse`, `DatosCentroCitFutSescam`,
`DatosCentroCitPasSescam`, `List<CitaHospitalariaDetalleSescam>`.

Las dos operaciones hospitalarias son **funcionalidad nueva**, no un renombrado.
Además la paginación de citas pasadas de primaria no existe hoy en ninguna capa.

### Contrato de citas de primaria

`body` informa el centro una sola vez (`nombreCentro`, `dirCentro`,
`municipioCentro`) y las citas en `body.listaCitas[]`, con `fecha`, `hora`,
`nomProfesionalRealizador`, `nomTvisita` y `nomModoVisita`. El frontal web
presenta profesional, tipo, modo, fecha y hora.

### Contrato de citas hospitalarias

`body` es un array (no el objeto con `listaCitas` de primaria). Campos por cita:

| Campo | Tipo | Notas |
| --- | --- | --- |
| `servicio` | String | Servicio médico, p. ej. `TRAUMATOLOGIA` |
| `prestacion` | String | Tipo de prestación, p. ej. `CONSULTA SUCESIVA` |
| `sala` | String | Sala o ubicación |
| `estadoCita` | String | p. ej. `PENDIENTE` |
| `centro.nombre` | String | **Anidado**. Nombre del hospital |
| `agenda.codigo` | String | **Anidado** |
| `agenda.descripcion` | String | **Anidado**. Agenda/profesional |
| `fecha` | String | Formato `dd/MM/yyyy` |
| `hora` | String | Formato `HH:mm` |
| `nhc` | String | Número de historia clínica |
| `id` | String | Identificador interno de cita |

Campos que el frontal web presenta: `servicio`, `prestacion`, `sala`,
`centro.nombre`, `agenda.descripcion`, `fecha`, `hora`. Deja fuera `estadoCita`,
`nhc`, `id` y `agenda.codigo`.

### Implementación (hecha)

- `0_entity/hospital_appointment.dart` — entidad propia para hospitalaria.
- `3_data/api/salud_gateway_api.dart` — las cinco operaciones del gateway.
- `3_data/mappers/hospital_appointment_mapper.dart` — mapeo estricto del array
  `body`, con `centro` y `agenda` anidados.
- `3_data/mappers/sescam_date.dart` — parseo de `fecha`/`hora` (`dd/MM/yyyy`,
  `HH:mm`, e ISO por tolerancia histórica).
- `3_data/my_data_health_repository_impl.dart` — reescrito contra el gateway; ya
  no depende del cliente generado ni del interceptor de compatibilidad.
- `1_domain/repositories/my_data_health_repository.dart` — `HealthAppointmentScope`
  (primaria/hospitalaria), `loadPrimaryCareAppointments` con `page`,
  `loadHospitalAppointments`, y `citizenId` en lugar de `documentNumber`.
- `2_presentation/providers/my_data_health_provider.dart` — CIP, primaria y
  hospitalaria en tres providers independientes, para que el fallo de uno no
  vacíe los demás.
- `2_presentation/controllers/past_primary_care_appointments_notifier.dart` —
  acumulación de páginas para el scroll infinito de primaria pasadas.
- `2_presentation/my_data_health_page.dart` — segundo selector de ámbito, tarjeta
  de cita hospitalaria, agrupación por año/mes compartida y scroll infinito.
- `auth/0_entity/jwt_claims.dart` — claim `sub_alt`.
- `auth/2_presentation/providers/gateway_citizen_id_provider.dart` — nuevo.

Se eliminó el recolector recursivo de mapas que servía de fallback en primaria:
con contrato documentado, devolver vacío cuando falta `body.listaCitas` es más
predecible que rebuscar en la respuesta.

### Impacto en la app (resuelto)

El parser anterior no servía para hospitalarias:

- `_appointmentMaps` espera `body.listaCitas` con los datos del centro al mismo
  nivel y los fusiona en cada cita. Con un `body` que es array, cae al fallback
  `_collectMaps`, un recolector recursivo de mapas.
- `_firstString` sólo mira claves de primer nivel, así que **no encuentra**
  `centro.nombre` ni `agenda.descripcion`.
- Resultado si se hubiera reutilizado: tarjetas con fecha y hora correctas pero
  sin centro, sin profesional y con la descripción por defecto
  `'Cita sanitaria'`. Degradación silenciosa, no error.

La entidad `HealthAppointment` (`dateTime`, `professional`, `description`,
`channel`, `modality`, `center`) no tenía hueco para `servicio`, `sala`,
`estadoCita`, `nhc`, `id` ni `agenda.codigo`, y sus `channel`/`modality` no
aplican, de ahí la entidad separada.

El eje de filtrado del dominio se desdobló: al `HealthAppointmentFilter
{ pending, past }` temporal se suma `HealthAppointmentScope
{ primaryCare, hospital }`. En pantalla son dos selectores apilados, y la
paginación de primaria pasadas está resuelta con scroll infinito.

### Citas hospitalarias ocultas tras un flag

`kHospitalAppointmentsEnabled` en `my_data_health_page.dart` está a `false`. Con
el flag apagado no se pinta el selector de ámbito, así que el ámbito es siempre
primaria y la pantalla queda como antes de la migración.

Motivo original: se creía que sus rutas sólo existían en el gateway. Con el
OpenAPI de UAT se confirma que **ya existen en la fachada**
(`/api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-*`), así que el flag se
puede encender en cuanto se valide el diseño de cómo conviven primaria y
hospitalaria en la pantalla.

Se eligió un flag en vez de comentar el código para que la capa de datos, el
mapeo y sus tests sigan compilando y ejecutándose. Reactivarlo es poner el flag a
`true`; no hay nada más que revertir.

### Paginación de citas pasadas de primaria

Es el único listado paginado: `pagina` sólo existe en esa operación. Resuelto con
un `Notifier` que acumula páginas
(`PastPrimaryCareAppointmentsNotifier`), no con un `FutureProvider`.

Detalles que conviene conocer:

- **Fin de la paginación por inferencia.** La respuesta no informa total ni número
  de páginas, así que la única señal de fin es que una página venga vacía. Eso
  implica una petición extra al llegar al final.
- **Reordenación del acumulado.** El repositorio ordena cada página por separado;
  el notifier reordena el conjunto tras cada append porque no está garantizado que
  el backend devuelva las páginas en orden cronológico entre sí.
- **Sin deduplicación.** Las citas de primaria no traen identificador, así que no
  hay clave estable con la que descartar solapamientos entre páginas. Si el
  backend repitiera elementos, se verían duplicados.
- **Fallo en una página intermedia.** Se conserva lo ya cargado y se corta la
  paginación, en vez de vaciar el listado.
- **Botón "Cargar más citas" siempre visible mientras queden páginas**, además del
  disparo por scroll. Es el único camino accesible por teclado y lector de
  pantalla, y rescata el caso en el que el filtro de fechas deja la lista tan
  corta que no hay scroll que disparar. Mientras queden páginas no se muestra el
  mensaje de "no hemos encontrado citas": afirmarlo sería falso si sólo falta
  cargar.

Pendiente de confirmar con el backend el tamaño de página que aplica.

### Códigos de respuesta del gateway

El diagrama de secuencia de la documentación fija tres rechazos que el gateway
resuelve antes de reenviar a la fachada: **401** token inválido, **403** sin
autorización y **429** límite de peticiones superado. `SaludGatewayApi` los trata
así:

| Código | Tratamiento |
| --- | --- |
| 2xx/3xx | Respuesta normal |
| 403 | `MyDataAuthorizationRequired` → la pantalla ofrece autorizar |
| 404 | Ausencia de datos → listado vacío |
| 401 | Se deja fallar: es lo que dispara `AuthRefreshInterceptor` |
| 429 y 5xx | Se dejan fallar → error de servicio reintentable |

El 403 reutiliza `MyDataAuthorizationRequired`, la misma excepción de `0_entity`
que bienestar social ya usaba para el `codigo-respuesta` `412.00`, y la pantalla
muestra `MyDataAuthorizationContextualHelper` con acceso a las autorizaciones. Sin
esa distinción, un rechazo por falta de consentimiento se presentaba como "no
tienes citas": información falsa y sin la acción que lo resuelve.

El **401 no puede aceptarse como respuesta válida**. `AuthRefreshInterceptor`
actúa en `onError`, así que un `validateStatus` que admita el 401 impide que Dio
lance la excepción y desactiva en silencio el refresco de sesión y el reintento.
De ahí que `_isHandledStatus` acepte sólo `< 400`, `403` y `404`.

El **429 es un riesgo real en este flujo concreto**, no teórico: el scroll
infinito encadena peticiones. Si llega un 429 durante la paginación, el notifier
conserva lo cargado y pone `hasMore` a `false`, con lo que deja de pedir páginas;
en los listados no paginados se muestra el error de servicio con reintento.

Dos caveats sobre el 403:

- Mientras `BASE_URL` apunte a la fachada, estas rutas también devuelven 403
  —la fachada rechaza un `{id}` que no coincide con el documento del token— así
  que la pantalla mostrará el aviso de autorización aunque la causa real sea el
  host.
- El diagrama describe el 403 como "sin autorización para la operación", que no
  necesariamente es la cláusula. Si el gateway lo usara también para permisos de
  cliente o scope, el aviso de autorizar la cláusula sería engañoso. Conviene
  confirmar con integración si distinguen ambos casos.

## Bienestar social

| Operación | Antes | Ahora |
| --- | --- | --- |
| Familia numerosa | `POST /api/v1/intermediacion/familia-numerosa/datos` | `POST /api/v1/ciudadanos/{id}/bienestar-social/familia-numerosa` |
| Discapacidad | `.../intermediacion/discapacidad/datos` | `.../bienestar-social/discapacidad` |
| Termalismo | `.../intermediacion/termalismo/datos` | `.../bienestar-social/termalismo` |
| Atención a la dependencia | `.../intermediacion/atencion-dependencia/datos` | `.../bienestar-social/atencion-dependencia` |
| Tarjeta de estacionamiento | `.../intermediacion/tarjeta-estacionamiento/datos` | `.../bienestar-social/tarjeta-estacionamiento` |

Dos cosas cambian además de la ruta:

**El cuerpo crece.** El contrato del gateway exige `tipo`, `idaut` y `proc` además
de `tipodoc` y `docu`. La app enviaba sólo los dos últimos porque la fachada
resolvía el resto internamente; el OpenAPI de la fachada, de hecho, ni declara
esos tres campos en `BaseRequestIntermediacion`. Se envían como constantes de
consulta iniciada por el ciudadano (`A`, `ESP-CIUDADANO`, `JCCMEC`), tomadas del
ejemplo de la documentación: **conviene confirmar su significado con integración**.
Los campos de funcionario se omiten porque aquí nunca hay uno detrás.

**El identificador de ruta se separa del documento consultado.** Antes eran el
mismo valor; ahora la interfaz de dominio recibe `citizenId` (segmento de ruta) y
`documentNumber` (campo `docu` del cuerpo). Contra el gateway el primero es
`sub_alt` y el segundo sigue siendo el NIF. Contra la fachada, familia numerosa
declara `{numDocumento}` y las otras cuatro `{idAgente}`, así que cada provider
pide el suyo.

### El 401 tenía que llegar al refresco de sesión (corregido)

El patrón `validateStatus: status < 500` estaba repetido en 16 llamadas de
`my_data` y `digital_cards`. Aceptar los 4xx es deliberado —hace falta el sobre
para detectar `412.00` o el error `3034`— pero arrastraba que **el 401 tampoco
lanzaba excepción y por tanto no llegaba a `AuthRefreshInterceptor`**, que actúa
en `onError`. Con ello la sesión no se refrescaba ni se reintentaba: la pantalla
mostraba "sin datos".

Gravedad real: el token de Cerbero en UAT **vive 300 segundos**. Pasados cinco
minutos de sesión, todas esas pantallas fallaban en silencio.

Corregido acotando el predicado a `status < 500 && status != 401`, que conserva
la lectura de los errores de negocio y devuelve el 401 al interceptor.

### El token no lleva audiencia del gateway

Claims del token de UAT (cliente `add-espacio_ciudadano_mobile-fo`):

- `aud`: `add-indexa-api`, `add-ventanilla-api`, `add-repo_usu-api`,
  `add-espacio_ciudadano-api`, `add-notifica3-api`, `Generador_Carnes`
- `realm_access.roles`: `["Ciudadano"]`
- `scope`: `openid clave_representado ext_profile profile`

Ninguna audiencia corresponde al gateway: el token está emitido para la API de la
fachada.

**Resuelto (2026-08-20).** Durante un tiempo el gateway devolvía 401 sin token y
403 con éste —autenticaba pero denegaba—, y se atribuyó a configuración de
Cerbero o del gateway. Ya no ocurre: las peticiones pasan y llegan a la fachada
(ver *El gateway es un proxy fino* en Empleo). No hizo falta ningún cambio en la
app, así que efectivamente era configuración del lado servidor.

### Privacidad

`nhc` (número de historia clínica) y los datos de cita son categoría especial
RGPD. Al añadir estas rutas **no** deben incluirse en la lista blanca de volcado
de cuerpos de respuesta de `lib/core/network/network_interceptors.dart`.

## Empleo

| Operación | Antes | Ahora |
| --- | --- | --- |
| Demandante de empleo a fecha actual | `POST /api/v1/sepe/demandante-empleo-fecha-actual/{numDocumento}` | `POST /api/v1/ciudadanos/{sid}/empleo/demandante-empleo-fecha-actual` |
| Ofertas de empleo inscritas | `POST /api/v1/intermediacion/empleo/ofertas-inscritas` | `POST /api/v1/ciudadanos/{sid}/empleo/ofertas` |

Con esto quedan **sin usar** `SepeApi` e `IntermediacionApi` del cliente generado:
empleo era el último consumidor de ambos.

### El gateway es un proxy fino: sólo reescribe el identificador

Ésta es la observación más útil de todo el bloque, y sale de un 404 (2026-08-20):

```
POST .../api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/empleo/ofertas-empleo
404 {"status":404,"error":"Not Found",
     "path":"/api/v1/ciudadanos/PER9998003/empleo/ofertas-empleo"}
```

Se leen tres cosas:

1. **El gateway ya autoriza.** Ni 401 ni 403: autenticó el token y lo dejó pasar.
   El bloqueo que teníamos anotado como pendiente de Cerbero está resuelto.
2. **Traduce `sub_alt` a `idAgente`.** El `path` del error trae `PER9998003`
   donde enviamos el UUID. La traducción que describía la documentación es real y
   ocurre en el gateway.
3. **No toca el resto del path.** El 404 lo produce la fachada, con
   `ofertas-empleo` intacto. Es decir, el segmento correcto es `ofertas`.

De ahí la regla que se aplica al resto del bloque: **donde la documentación del
gateway y el OpenAPI de la fachada discrepen, manda la fachada**, cuyo contrato
está generado desde el código. Corolario práctico: la distinción
`requireNumDocumento()` / `requireIdAgente()` es irrelevante contra el gateway,
porque sustituye el identificador venga el que venga.

### El nombre de la operación de ofertas no coincidía entre fuentes

| Fuente | Segmento |
| --- | --- |
| Documentación del gateway | `empleo/ofertas-empleo` |
| OpenAPI de la fachada UAT | `empleo/ofertas` ← **el bueno** |

Resuelto por la prueba de arriba. El segmento vive en
`EmpleoApi.jobOffersOperation`.

### Los identificadores de las dos operaciones no son el mismo contra la fachada

Como en bienestar social, cada operación declara el suyo en el OpenAPI de la
fachada: `{idAgente}` en ofertas y `{numDocumento}` en demandante. Cada provider
pide el que le toca a `citizenEndpointIdsProvider`; con
`CIUDADANOS_ID_STRATEGY=subAlt` ambos devuelven `sub_alt` y el gateway funciona
sin tocar código.

### Cuerpos

**Ofertas** usa `BaseRequestIntermediacion`, exactamente el mismo cuerpo que
bienestar social (`tipo`, `idaut`, `proc`, `tipodoc`, `docu`). Estaba duplicado,
así que se ha extraído a `3_data/intermediacion_request.dart`, compartido por las
seis llamadas.

**Demandante** usa `DTSEPESVDIDEFAREQ` y aquí el contrato **sí crece**: además de
`tipodoc` y `docu` pide `nombre_titular` y `apellido1_titular` como obligatorios,
y `apellido2_titular` opcional. Se toman de los claims `given_name`,
`first_surname` y `second_surname`, los mismos que ya usa
`gestion_aportar_documentacion_page`. No lleva `tipo`/`idaut`/`proc`.

Dos cautelas sobre este cuerpo:

- **Los nombres de campo tampoco coinciden entre fuentes.** La documentación del
  gateway usa `nombre_titular` / `apellido1_titular` / `apellido2_titular`; el
  esquema de la fachada serializa `nombretitular` / `apellido1TITULAR` /
  `apellido2TITULAR`. **Se sigue la fachada**, por la misma regla que resolvió el
  segmento de ofertas: es quien vincula el cuerpo. Si estuviera al revés el fallo
  sería silencioso —los campos se ignoran, que es lo que pasaba antes de
  migrar—, no un error, así que conviene verificarlo contra datos reales.
  Curiosamente en `BaseRequestIntermediacion` sí coinciden (`doc_funcionario`,
  `nombre_funcionario`), lo que sugiere que la discrepancia es sólo de este DTO.
- **Se omiten cuando el token no los informa**, en vez de viajar vacíos. Son
  obligatorios según el contrato, pero el único origen posible es el token y no
  hay garantía de que Cl@ve los emita siempre; un campo ausente se diagnostica
  mejor que uno en blanco, y el comportamiento degradado es exactamente el de
  antes de migrar, que no los enviaba.

### Bug corregido de paso

`_documentType` sólo distinguía NIF y NIE. Se sustituye por `documentTypeOf`
(`3_data/document_type.dart`), compartido con educación y bienestar social, que
además reconoce CIF por la letra inicial A-W. Igual que en educación, el fallo
estaba oculto mientras el documento viajaba en la ruta.

### Autorización

Ambas consultas exigen la cláusula 1 · JCCM, que las pantallas ya comprueban por
adelantado con `jccmDataAuthorizationProvider`. No se ha añadido la traducción de
`412.00`/`3034` a `MyDataAuthorizationRequired` que sí hacen bienestar social y
salud: las pantallas de empleo no renderizan ese estado todavía.

## Vivienda y vehículos

| Operación | Antes | Ahora |
| --- | --- | --- |
| Datos de residencia (padrón, INE) | `POST /api/v1/ine/datos-residencia/{numDocumento}` | `POST /api/v1/ciudadanos/{sid}/vivienda/datos-residencia` |
| Datos catastrales | `POST /api/v1/catastro/datos-catastrales/{numDocumento}` | `POST /api/v1/ciudadanos/{sid}/vivienda/datos-catastrales` |
| Listado de vehículos (DGT) | `POST /api/v1/dgt/lista-vehiculos/{numDocumento}` | `POST /api/v1/ciudadanos/{sid}/vehiculos` |

Las tres exigen la cláusula 2 · AGE, que las pantallas ya comprueban. Con esto
quedan sin usar `IneApi`, `CatastroApi` y `DgtApi` del cliente generado.

### Dos discrepancias más de la documentación, resueltas contra el OpenAPI

Aplicando la regla del bloque de empleo —contrastar antes de escribir— aparecen
otras dos:

| Qué | Documentación del gateway | OpenAPI de la fachada | Elegido |
| --- | --- | --- | --- |
| Ruta de vehículos | `ciudadanos/{sid}/vehiculos/listado` | `ciudadanos/{numDocumento}/vehiculos` | fachada |
| Campo de tipo de documento en catastro | `tipodoc` | `tipdoc` | fachada |

Lo segundo merece una nota, porque parece una errata de la app y no lo es:
**`DTCTROCDATREQ` usa `tipdoc`, sin la `o`**, a diferencia de `DTINECDRFREQ` y
`DTDGTLISTADOVEHICULOSREQ`, que usan `tipodoc`. Es una inconsistencia del backend,
está así en el esquema generado desde el código, y la app ya lo enviaba bien. Se
conserva, con un comentario en el sitio para que nadie lo "arregle".

La ruta de vehículos está en `VehiculosApi.operationPath` por si hubiera que
volver a `vehiculos/listado`.

### Bug corregido de paso

Vehículos fijaba `tipodoc` a `'NIF'` literal —tercera aparición del mismo fallo,
tras educación y empleo—. Ahora usa `documentTypeOf`. Vivienda ya lo deducía,
aunque sólo distinguía NIF y NIE; con el helper compartido reconoce también CIF.

Se añade `my_data_vehicles_repository_impl_test.dart`, que no existía: cubre la
ruta, el cuerpo, la deducción del tipo de documento y el listado vacío.

## Recomendaciones

| Operación | Antes | Ahora |
| --- | --- | --- |
| Todos los trámites | `GET /api/v1/hechos-vitales/servicios/{idAgente}` | `GET /api/v1/ciudadanos/{sid}/recomendaciones?operacion=todo` |
| Más próximos a vencer | `GET /api/v1/hechos-vitales/servicios/segmentacion/{idAgente}?operacion=ut` | `GET /api/v1/ciudadanos/{sid}/recomendaciones?operacion=ut` |
| Novedades | `...?operacion=no` | `...recomendaciones?operacion=no` |
| Tramitación inmediata | `...?operacion=ti` | `...recomendaciones?operacion=ti` |

**Dos rutas se funden en una.** Lo que las distinguía era la ruta; ahora es el
query `operacion`. Requiere la cláusula 3 · Recomendaciones. La ruta unificada
se consume vía `HechosVitalesApi.getServiciosSegmentados1` del cliente generado.

### La causa real del 403 de esta pantalla no era la ruta

`recommendationsProvider` leía `idAgente` **directamente del token**, saltándose
`citizenEndpointIdsProvider`. Contra el gateway eso mandaba `PER9998003` en la
ruta mientras el resto de la app mandaba `sub_alt`, y las **tres** llamadas de la
pantalla —comprobar cláusula, cargar hechos y cargar recomendaciones— respondían
403:

```
GET .../api/v1/ciudadanos/PER9998003/hechos → 403
```

Corregido pasando por el provider. Quedan otros dos sitios con la misma lectura
directa, pendientes de migrar sus bloques (agenda ya migrado): `agenda_appointments_provider.dart` (hecho) y
`digital_cards_provider.dart`. **Al migrarlos hay que arreglarlo también**, o
darán el mismo 403.

### "Todos" va con `operacion=todo`

La documentación del gateway escribe `operacion=todos` y la descripción del
OpenAPI cita `'todo'` en singular. Aunque el contrato declara el parámetro como
opcional, **contra el gateway UAT omitirlo devuelve vacío** (la pantalla salía
sin recomendaciones en todos los segmentos), así que se envía siempre con el
valor del OpenAPI: `todo`.

### `hechosvitales` NO se envía (revertido tras probar con datos reales)

El contrato declara un query `hechosvitales` con los identificadores de hechos
vitales por los que segmentar. Se probó a enviarlo y **con él el backend
devuelve vacío en todos los segmentos** incluso con hechos configurados, dejando
la pantalla sin recomendaciones. Se revierte al comportamiento original: la
lista se calcula sólo para cortar la llamada si está vacía, y el filtrado por
hechos se hace en presentación.

Además, el wrapper `RecomendacionesApi` pasa a envolver
`HechosVitalesApi.getServiciosSegmentados1` del cliente generado (el endpoint
existe en el OpenAPI desde la 1.86), en lugar de construir la ruta a mano.

### Forma de la respuesta

`body` es una **lista plana** de trámites, cada uno con su propio array
`hechosVitales` — no viene agrupada por hecho. El parser ya lo soportaba
(`_normaliseGroups` envuelve la lista y `_mapGroup` lee `hechosVitales` de cada
trámite), así que no ha hecho falta tocarlo.

## Otros puntos a revisar

- `network_interceptors.dart` tiene rutas literales para logging y para el
  multipart de soporte (`/api/v1/soporte`, `/api/v1/intermediacion/...`,
  `/api/v1/agenda/`, `/api/v1/ccaa/familia-numerosa/`). Hay que actualizarlas al
  renombrar.
- `features/gestion/3_data/repositories/` construye rutas a mano
  (`/api/v1/procedimiento/inicproc`, `/api/v1/documentacion/registrarfichero`,
  `/api/v1/ciudadanos/{id}/notificaciones`).
- Lo que ya cuelga de `/api/v1/ciudadanos/{id}/...` (contacto, notificaciones)
  encaja sin cambio de forma, sólo cambia el valor del identificador.
- Agenda migrada: `agenda/{idAgente}/eventos/{periodo}` →
  `GET /api/v1/ciudadanos/{sid}/eventos/{PERIODO}` (TODOS|SEMANA|MES|ANIO, en
  mayúsculas) y `GET /api/v1/ciudadanos/{sid}/eventos/refrescar` (conectado al
  botón de actualizar de la pantalla).
- Sin equivalente conocido todavía en el gateway:
  `carnet-digital/*`, `intermediacion/*` (queda lo que no es empleo ni bienestar
  social), `ccaa`,
  `servicio/midetalle`, `soporte`.
- Aportar documentación migrado. El segmento `{idExpediente}` de las tres rutas
  es decorativo (el backend opera con el cuerpo) y los números de expediente
  llevan barras que romperían la ruta, así que se cubre con el `idunico` de la
  transacción, que es path-safe:
  - `procedimiento/subiradjuntosinfirma` →
    `POST /ciudadanos/{sid}/expedientes/{idunico}/ficheros`
  - `procedimiento/inicproc` →
    `POST /ciudadanos/{sid}/expedientes/{idunico}/ficheros/iniciar`
  - `documentacion/registrarfichero` →
    `POST /ciudadanos/{sid}/expedientes/{idunico}/ficheros/registrar`
- Publicación (expedientes/registros) migrada. Nota clave: el path lleva el
  `sub_alt` del autenticado y el cuerpo SOAP lleva el NIF real — dos valores
  distintos que los repos reciben por separado (`citizenId` + `documentNumber`).
  - `publicacion/selectbynifexp` → `POST /ciudadanos/{sid}/expedientes`
  - `publicacion/selectbynumexp` → `POST /ciudadanos/{sid}/expedientes/detalle`
    (el segmento `{idExpediente}` de la fachada va fijo a `detalle`, como
    documenta el gateway: los números de expediente llevan barras y romperían la
    ruta; el backend identifica por el `pnumexp` del cuerpo)
  - `publicacion/selectbynifentrada|salida` →
    `POST /ciudadanos/{sid}/expedientes/listado-registro-entrada|salida`
  - `publicacion/selectbynumreg` → `POST /ciudadanos/{sid}/registros/{idRegistro}`

## Pendiente de confirmar

Bloqueante para escribir código:

1. Host de UAT resuelto: `gateway-espacio-ciudadano-uat.cm-pre.jccm.es`. El
   `gw-api` de la documentación era un placeholder. Faltan los de preproducción
   y producción.
2. **¿Existe un OpenAPI del gateway?** El de la fachada UAT está en `/v3/api-docs`
   y ya sirve para migrar.
3. En UAT el token emite `sub_alt` (UUID) — verificado. Falta confirmar PRE y
   producción.
4. ¿El gateway requiere cabeceras adicionales (apikey, credenciales de cliente)
   además del `Bearer`?
5. **Empleo — los campos del titular.** ¿`nombre_titular` / `apellido1_titular`
   (gateway) o `nombretitular` / `apellido1TITULAR` (fachada)? Implementado el
   segundo, por analogía con el segmento de ofertas, pero sin prueba directa: si
   fuera al revés se ignorarían en silencio. ¿Y qué hace el servicio si no
   llegan, dado que hasta ahora nunca se enviaban?
6. **Recomendaciones — el query `hechosvitales` vacía la respuesta.** Se probó a
   enviarlo y el backend devolvió vacío en todos los segmentos, así que se ha
   revertido y vuelve a omitirse. Queda confirmar con backend si es un bug suyo
   o si el parámetro espera otro formato. Ver la sección.
7. **¿La discrepancia de nombres afecta a más secciones?** La documentación del
   gateway ha fallado ya en un segmento de ruta y probablemente en tres campos.
   Conviene contrastar cada bloque restante contra `/v3/api-docs` antes de
   escribirlo, no después.

No bloqueante pero necesario para cerrar alcance:

8. Las citas hospitalarias están implementadas con UI (segundo selector
   Primaria/Hospitalaria) pero apagadas por flag hasta tener el gateway. Falta
   validar ese diseño con el cliente antes de publicarlas.
9. Paginación de citas pasadas resuelta con scroll infinito. Falta saber el
   tamaño de página que aplica el backend, y si alguna vez devuelve una página
   corta sin estar vacía (rompería la inferencia de fin de listado).
10. ¿`estadoCita` puede traer valores distintos de `PENDIENTE` / `REALIZADA`? Se
   mapea a la entidad pero no se muestra, siguiendo al frontal web.
11. ¿Se conservan los códigos de error actuales (403 por cláusula no autorizada,
   `412.00` en `codigo-respuesta`, 404 sin datos)?
12. ¿La agenda pasa también a `/ciudadanos/{sid}/...` y agregará las citas
   hospitalarias?
