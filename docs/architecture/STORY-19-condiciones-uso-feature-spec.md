# STORY-19 - Aceptacion inicial de condiciones de uso y proteccion de datos

## 1. Proposito

Definir la especificacion funcional y tecnica completa de `STORY-19 / JCCMEC-11`, cubriendo el flujo obligatorio de lectura, aceptacion y persistencia del consentimiento legal antes del acceso funcional a la aplicacion.

Esta historia no es una simple pantalla estatica. El comportamiento esperado, segun ticket y referencias visuales, es un onboarding legal de dos pasos:

1. lectura obligatoria del contenido legal
2. aceptacion explicita de todas las autorizaciones requeridas


## 2. Fuentes de verdad

Fuentes principales:

- `tickets/STORY-19.md`
- `image_references/03_2_FlujoIdentificación-Condiciones_aceptado@4x.png`
- `image_references/03_1_FlujoIdentificación-Condiciones_aceptado.png`
- `image_references/03_3_FlujoIdentificación-Condiciones_default.png`
- `image_references/03_4_FlujoIdentificación-Condiciones_aceptado_2.png`

Fuentes de soporte:

- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`
- `documentation/initial_documentation/MAPEO_ENDPOINTS_PANTALLAS.md`
- `generated/dart_dio_client/doc/HechosVitalesApi.md`
- `generated/dart_dio_client/doc/Clausulas.md`
- `generated/dart_dio_client/doc/ClausulasAgente.md`
- `lib/l10n/app_es.arb`
- `lib/core/routing/route_registry.dart`
- `lib/core/routing/app_router.dart`
- `lib/core/storage/storage_keys.dart`

Regla de interpretacion:

- La UX de detalle se toma de las capturas `03_*`.
- El ticket manda sobre la existencia de persistencia y versionado.
- El contrato de `clausulas` es la mejor base tecnica disponible para soportar la aceptacion versionada.


## 3. Resumen funcional

El ciudadano debe aceptar las condiciones de uso y la informacion de proteccion de datos antes de entrar en cualquier superficie autenticada.

El flujo consta de dos pasos obligatorios:

1. una pantalla larga de informacion legal donde el boton principal no se activa hasta que la persona llega al final del scroll
2. una pantalla de autorizaciones con checkboxes obligatorios donde el boton principal no se activa hasta que todas las clausulas requeridas quedan marcadas

Si el ciudadano rechaza el flujo, no puede continuar al contenido funcional autenticado.


## 4. Objetivo de negocio

- Garantizar consentimiento expreso antes del primer acceso funcional.
- Forzar una lectura efectiva del contenido legal previo a la aceptacion.
- Registrar la aceptacion de manera reutilizable para modulos posteriores.
- Reutilizar el mismo consentimiento como base para superficies futuras, especialmente preferencias/autorizaciones y paginas legales.


## 5. Alcance

### Incluido

- Gate legal tras autenticacion correcta y antes de acceso funcional.
- Paso 1 de lectura legal con scroll obligatorio.
- Paso 2 de autorizaciones con checkboxes obligatorios.
- Rechazo con salida funcional del area autenticada.
- Persistencia de la aceptacion.
- Versionado de clausulas aceptadas.
- Reapertura de la informacion legal completa desde el segundo paso.
- Reutilizacion posterior del consentimiento en otros modulos.

### No incluido

- Revocacion posterior de autorizaciones desde preferencias. Eso pertenece a `STORY-55`.
- Paginas legales globales accesibles desde menu/footer. Eso pertenece a `STORY-61`.
- Definicion final de copy legal fuera del contenido ya validado por negocio/legal.


## 6. Dependencias

Dependencias de ticket:

- Bloqueada por `STORY-17`
- Bloqueada por `STORY-18`
- Bloquea `STORY-55`
- Bloquea `STORY-61`
- Relacionada con `EPIC-2`

Dependencias runtime:

- Sesion autenticada valida.
- Identidad de usuario disponible.
- Si se persiste contra backend, `idAgente` resuelto desde la sesion.


## 7. Flujo principal

1. El ciudadano completa autenticacion con Cl@ve.
2. Antes de navegar al destino autenticado, la app evalua si falta consentimiento o si la version aceptada ha quedado obsoleta.
3. Si falta consentimiento vigente, la app redirige a `Routes.consent`.
4. Se muestra el paso 1 de lectura legal.
5. El ciudadano debe llegar al final del contenido para desbloquear `Aceptar y continuar`.
6. Si pulsa `Rechazar y salir`, se aborta el acceso funcional.
7. Si pulsa `Aceptar y continuar`, se muestra el paso 2 de autorizaciones.
8. En el paso 2, el ciudadano debe marcar todas las clausulas obligatorias.
9. Cuando todas las clausulas estan marcadas, se activa `Aceptar`.
10. Al aceptar, la app persiste localmente y, si aplica, remotamente las clausulas/versiones aceptadas.
11. Tras guardar correctamente, la app reanuda la navegacion al destino original o al siguiente gate funcional definido por producto.


## 8. Especificacion de pantallas

### 8.1 Paso 1 - Lectura legal obligatoria

Referencias:

- Estado inicial: `03_2_FlujoIdentificación-Condiciones_aceptado@4x.png`
- Estado desbloqueado: `03_1_FlujoIdentificación-Condiciones_aceptado.png`

Identidad de pantalla:

- Titulo visible: `Condiciones de uso y autorizaciones`
- Contenido: texto legal largo, estructurado por preguntas/titulares y parrafos
- CTA secundaria: `Rechazar y salir`
- CTA principal: `Aceptar y continuar`

Estructura visual:

- Cabecera superior fija con titulo.
- Cuerpo desplazable verticalmente con contenido legal extenso.
- Barra inferior fija con dos acciones apiladas.
- `Rechazar y salir` aparece habilitado desde el inicio.
- `Aceptar y continuar` aparece deshabilitado al entrar.

Reglas de interaccion:

- El usuario debe alcanzar el final del scroll para desbloquear el CTA principal.
- El desbloqueo debe producirse al llegar al final del contenido, no por mero tiempo en pantalla.
- Una vez desbloqueado, `Aceptar y continuar` puede permanecer habilitado aunque el usuario vuelva a desplazarse hacia arriba.
- No se debe permitir avanzar al paso 2 mientras el CTA siga deshabilitado.

Reglas de negocio:

- Este paso demuestra lectura previa, no aceptacion completa.
- La aceptacion definitiva aun no ha ocurrido en este paso.


### 8.2 Paso 2 - Autorizaciones obligatorias

Referencias:

- Estado inicial: `03_3_FlujoIdentificación-Condiciones_default.png`
- Estado valido: `03_4_FlujoIdentificación-Condiciones_aceptado_2.png`

Identidad de pantalla:

- Titulo visible truncado en app bar: `Condiciones de uso y auto...`
- Accion izquierda: cierre `X`
- Accion derecha: icono `info`
- CTA secundaria: `Marcar todo`
- CTA principal: `Aceptar`

Estructura visual:

- App bar compacta con cerrar e informacion.
- Lista vertical de clausulas con checkbox a la izquierda.
- Cada clausula puede ocupar varias lineas.
- Zona inferior fija con dos acciones:
  - `Marcar todo`
  - `Aceptar`

Modelo de contenido:

- El numero de clausulas debe ser variable.
- La pantalla no debe hardcodear exactamente tres items.
- El backend y/o configuracion debe poder entregar una lista versionada de clausulas.
- En la referencia se aprecian al menos tres autorizaciones de tipo:
  - consulta de datos JCCM
  - consulta de datos complementarios / otros ambitos
  - consentimiento para recomendaciones con perfilado basado en hechos vitales

Reglas de interaccion:

- `Aceptar` empieza deshabilitado.
- `Aceptar` solo se habilita cuando todas las clausulas obligatorias estan marcadas.
- `Marcar todo` marca todas las clausulas pendientes en una sola accion.
- Cuando todas las clausulas ya estan marcadas, `Marcar todo` pasa a estado deshabilitado.
- Si el usuario desmarca una clausula tras haber completado el conjunto:
  - `Aceptar` vuelve a deshabilitarse
  - `Marcar todo` vuelve a habilitarse

Semantica de acciones:

- `X` equivale a cancelar el onboarding legal y provoca la misma salida funcional que un rechazo.
- El icono `info` reabre o muestra el contenido legal completo del paso 1 sin perder el estado actual de los checkboxes.

Reglas de negocio:

- No existe aceptacion parcial valida.
- Todas las clausulas obligatorias forman una unidad de consentimiento.
- El guardado se produce solo al pulsar `Aceptar`.


### 8.3 Mapeo explicito de pasos visuales

Paso 1:

- `03_2`: pantalla legal con `Aceptar y continuar` deshabilitado antes de llegar al final

Paso 2:

- `03_1`: misma pantalla legal con `Aceptar y continuar` habilitado tras completar la lectura

Paso 3:

- `03_3`: pantalla de autorizaciones mostrada despues de pulsar `Aceptar y continuar`

Paso 4:

- `03_4`: pantalla de autorizaciones con todos los checkboxes marcados y `Aceptar` habilitado


## 9. Reglas de navegacion

Entrada:

- La ruta de entrada es `Routes.consent` (`/consent`).
- Debe ejecutarse como gate previo al acceso funcional autenticado.

Salida por rechazo:

- El ciudadano no puede continuar al area autenticada.
- A nivel funcional, la salida debe equivaler a logout o invalidacion del acceso en curso.
- En lugar de forzar cierre nativo de app en todas las plataformas, la implementacion puede resolverlo como `cerrar sesion + volver a landing`, ya que es mas portable y verificable.

Salida por aceptacion:

- Tras persistir correctamente el consentimiento, la app debe continuar hacia:
  - la ruta autenticada originalmente solicitada, o
  - el siguiente gate/onboarding definido por producto

Informacion adicional:

- El acceso a informacion ampliada de proteccion de datos puede resolverse mediante:
  - reapertura del paso 1 desde el icono `info`, y/o
  - navegacion a `Routes.privacy`


## 10. Persistencia y versionado

### 10.1 Requisitos funcionales

La historia exige:

- persistencia del consentimiento
- versionado del consentimiento
- reutilizacion posterior del consentimiento en preferencias

Por tanto, guardar solo un booleano `accepted=true` no es suficiente para cumplir completamente la historia.

### 10.2 Persistencia minima requerida

La solucion debe almacenar al menos:

- identificador del usuario o `idAgente`
- fecha/hora de aceptacion
- version del contenido legal aceptado
- lista de clausulas aceptadas
- version individual de cada clausula aceptada, si el backend la entrega

### 10.3 Persistencia local

En el repo ya existe:

- `StorageKeys.consentAccepted`

Pero para cumplimiento completo de la historia se necesita complementar ese estado con versionado. Puede resolverse con metadatos adicionales locales o con lectura/escritura remota como fuente principal.

### 10.4 Persistencia remota candidata

El mejor contrato disponible es el de `clausulas`:

- `GET /api/v1/hechos-vitales/clausulas/{idAgente}`
- `PATCH /api/v1/hechos-vitales/clausulas`

Modelo:

- `ClausulasAgente`
  - `idAgente: String`
  - `clausulas: BuiltList<Clausulas>`
- `Clausulas`
  - `idClausula: int`
  - `seleccionado: bool`
  - `version: String`

Payload de referencia:

```json
{
  "idAgente": "constante_clave_jwt",
  "clausulas": [
    { "idClausula": 1, "seleccionado": true, "version": "1.0" },
    { "idClausula": 2, "seleccionado": true, "version": "1.0" },
    { "idClausula": 3, "seleccionado": true, "version": "1.0" }
  ]
}
```

### 10.5 Politica de vigencia

El consentimiento debe considerarse no vigente cuando ocurra cualquiera de estos casos:

- no existe aceptacion previa para el usuario actual
- la version legal local/remota es distinta de la ultima aceptada
- falta alguna clausula obligatoria en el registro aceptado


## 11. Estados y manejo de errores

Estados minimos:

- carga inicial
- paso 1 bloqueado
- paso 1 desbloqueado
- paso 2 incompleto
- paso 2 completo
- guardando aceptacion
- error al guardar

Comportamientos requeridos:

- Si falla la lectura remota de clausulas pero existe una estrategia local de respaldo, debe degradarse con contenido empaquetado.
- Si falla el guardado final, el usuario debe permanecer en el paso 2 y recibir feedback claro.
- No se debe dejar entrar al area autenticada si la persistencia requerida no ha finalizado con exito.
- Si el catalogo de clausulas cambia entre carga y confirmacion, debe recargarse y obligar a revisar la nueva version.


## 12. Accesibilidad

- Todos los botones y checkboxes deben tener labels de accesibilidad claras.
- El bloqueo por scroll no debe depender solo de gestos tactiles; con lector de pantalla debe poder alcanzarse el final del contenido y desbloquearse el CTA.
- El foco debe seguir este orden: cabecera, contenido, acciones.
- El estado habilitado/deshabilitado de `Aceptar y continuar` y `Aceptar` debe anunciarse correctamente.
- Las clausulas deben ser activables sobre toda la fila, no solo sobre el cuadrado del checkbox.


## 13. Criterios de aceptacion ampliados

- Se muestra el onboarding legal al primer acceso autenticado o cuando la version vigente no coincide con la aceptada.
- El paso 1 no permite avanzar hasta completar la lectura por scroll.
- El rechazo impide el acceso funcional autenticado.
- El paso 2 no permite confirmar mientras falte alguna clausula obligatoria.
- `Marcar todo` selecciona todas las clausulas pendientes y deja `Aceptar` habilitado.
- El icono `info` permite revisar el contenido legal completo sin perder el progreso de checkboxes.
- La aceptacion final queda persistida con versionado suficiente para reutilizacion posterior.
- El consentimiento aceptado puede ser consultado o referenciado desde preferencias y superficies legales posteriores.


## 14. Estado actual del repo

Hechos observables en el codigo actual:

- Existe `Routes.consent = '/consent'`.
- `app_router.dart` sigue enlazando esa ruta a un `DomainLandingPlaceholder`, no a una pantalla real del flujo.
- Existen claves de l10n para el copy basico del consentimiento.
- Existen rutas legales reutilizables (`/legal/terms`, `/legal/privacy`, etc.).
- Existe `StorageKeys.consentAccepted`, pero por si sola no cubre versionado completo.

Conclusion tecnica:

- El repo ya tiene el encaje de routing y parte del copy.
- Falta materializar la UI real de dos pasos y cerrar la estrategia final de persistencia/versionado para que `STORY-19` quede completamente representada en codigo.
