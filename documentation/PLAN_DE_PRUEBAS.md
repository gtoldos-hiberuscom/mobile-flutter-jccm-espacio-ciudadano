# Plan de pruebas — Espacio Ciudadano CLM (app móvil)

**Aplicación:** `jccm_espacio_ciudadano` — Carpeta Ciudadana CLM (Android + iOS)
**Versión del plan:** 1.1 — 25/08/2026
**Ámbito:** pruebas funcionales manuales de toda la app. Integra y amplía el plan parcial anterior (antiguos TC-1 a TC-50), corrigiendo los casos cuyo resultado esperado no coincidía con el comportamiento implementado.

> **Cambios v1.1:** se eliminan todos los casos de **biometría** (funcionalidad que se retira de la app) y se añade la sección **Acceso de representantes** (funcionalidad en definición; ajustar los casos cuando esté especificada e implementada).

---

## Índice

1. [Landing pública, ayuda y soporte](#1-landing-pública-ayuda-y-soporte)
2. [Login con Cl@ve](#2-login-con-clve)
3. [Acceso de representantes](#3-acceso-de-representantes)
4. [Onboarding: protección de datos, condiciones de uso y hechos vitales](#4-onboarding)
5. [Pantalla de inicio (Home)](#5-pantalla-de-inicio-home)
6. [Carnets digitales](#6-carnets-digitales)
7. [Gestión — Mis expedientes](#7-gestión--mis-expedientes)
8. [Gestión — Aportar documentación a un expediente](#8-gestión--aportar-documentación-a-un-expediente)
9. [Gestión — Expedientes de terceros](#9-gestión--expedientes-de-terceros)
10. [Gestión — Mis registros](#10-gestión--mis-registros)
11. [Gestión — Notificaciones electrónicas](#11-gestión--notificaciones-electrónicas)
12. [Mis datos — general](#12-mis-datos--general)
13. [Mis datos — Salud](#13-mis-datos--salud)
14. [Mis datos — Bienestar Social](#14-mis-datos--bienestar-social)
15. [Mis datos — Empleo](#15-mis-datos--empleo)
16. [Mis datos — Educación](#16-mis-datos--educación)
17. [Mis datos — Vivienda](#17-mis-datos--vivienda)
18. [Mis datos — Vehículos](#18-mis-datos--vehículos)
19. [Agenda](#19-agenda)
20. [Trámites recomendados](#20-trámites-recomendados)
21. [Preferencias](#21-preferencias)
22. [Menú de perfil y cierre de sesión](#22-menú-de-perfil-y-cierre-de-sesión)
23. [Pantallas legales](#23-pantallas-legales)
24. [Enlaces externos](#24-enlaces-externos)
25. [Sesión y seguridad](#25-sesión-y-seguridad)
26. [Transversales: accesibilidad, idioma, conectividad, navegación](#26-transversales)
27. [Riesgos y observaciones conocidas](#27-riesgos-y-observaciones-conocidas)

**Convenciones**
- Cada caso indica **Precondición** solo cuando no basta con "app instalada y arrancada".
- "Usuario autenticado" = login con Cl@ve completado y onboarding legal aceptado.
- Los mensajes entre comillas son los literales implementados en la app (español).
- Ejecutar la batería completa en **Android** y en **iOS**; los casos exclusivos de una plataforma lo indican.

---

## 1. Landing pública, ayuda y soporte

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-001 | Abrir la app sin sesión previa | Se muestra la landing pública con logo de Castilla-La Mancha, logo Espacio Ciudadano, texto de presentación e imagen. Barra fija con 3 botones: "Ayuda y contacto", "Información y ayuda sobre el espacio" y "Acceder a mi Espacio ciudadano". |
| TC-002 | Pulsar "Ayuda y contacto" | Se abre la pantalla de ayuda con 2 pestañas: **Preguntas frecuentes** y **Contacto**. |
| TC-003 | Revisar la pestaña "Preguntas frecuentes" | Se listan las preguntas frecuentes (qué es Espacio Ciudadano, qué necesito para acceder, qué datos personales se almacenan, corrección de errores en los datos, qué eventos se muestran en Mi agenda, etc.) y el bloque "Guías de ayuda". Nota: hay 3 entradas placeholder ("Preguntas a trabajar para app") pendientes de contenido. |
| TC-004 | Pulsar una pregunta frecuente | Se abre la pantalla de detalle con la pregunta como título y su respuesta. El botón atrás devuelve al listado. |
| TC-005 | Pulsar "Guías de ayuda" | Se muestra el diálogo "Vas a salir de la aplicación"; al continuar, se abre el enlace en el navegador externo. |
| TC-006 | Revisar la pestaña "Contacto" | Se muestran las tarjetas de teléfono **012** y **952 274 552**, la tarjeta "Listado de Oficinas de Información y Registro" (enlace externo) y el botón "Formulario de Soporte". |
| TC-007 | Pulsar una tarjeta de teléfono | Se abre el marcador del dispositivo con el número precargado (sin diálogo de confirmación). |
| TC-008 | Pulsar "Formulario de Soporte" sin estar autenticado | Se abre el formulario con campos: Nombre y apellidos, Correo, Confirmar correo, Asunto, Mensaje, adjunto opcional y checkbox de autorización de uso de datos (con enlace a la información de privacidad). Botones "Cancelar" y "Aceptar". |
| TC-009 | Abrir el formulario de soporte estando autenticado | No se muestran ni el campo "Nombre y apellidos" ni el checkbox de consentimiento. |
| TC-010 | Enviar el formulario con campos vacíos | Se muestran los errores de validación por campo: nombre obligatorio, correo obligatorio, asunto obligatorio, mensaje obligatorio, consentimiento obligatorio. No se envía. |
| TC-011 | Introducir un correo con formato inválido o correos que no coinciden | Se muestran "Introduce un correo válido" / error de confirmación de correo no coincidente. No se envía. |
| TC-012 | Superar la longitud máxima de asunto o mensaje (mensaje > 2000 caracteres) | Se muestra el error de longitud máxima y no se permite enviar. |
| TC-013 | Adjuntar un fichero mayor de 20 MB | Se muestra "El archivo excede el tamaño máximo permitido." y el fichero no se adjunta. |
| TC-014 | Adjuntar un fichero válido (≤ 20 MB, formato permitido) | El fichero queda adjunto al formulario y puede eliminarse antes de enviar. |
| TC-015 | Enviar el formulario con todos los datos correctos | Se muestra la pantalla de confirmación "Solicitud enviada" con el botón "Enviar otra solicitud", que resetea el formulario. |
| TC-016 | Pulsar "Información y ayuda sobre el espacio" | Se abre "Saber más sobre el Espacio Ciudadano" con la definición del espacio, la sección "¿Qué encontrarás?" (información personal, expedientes, notificaciones, carnets, citas, recomendaciones) y el botón "Acceder a mi Espacio Ciudadano". |
| TC-017 | Abrir la pantalla "Cómo acceder" | Se muestra la información sobre identificación con Cl@ve (Cl@ve Móvil, Cl@ve Permanente, DNIe/certificado) y el botón de acceso. Si se llega desde la home autenticada (`?from=home`), el botón de acceso no se muestra. |

## 2. Login con Cl@ve

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-018 | Pulsar "Acceder a mi Espacio ciudadano" | Se lanza el flujo OAuth: se abre el navegador/pestaña segura con la pantalla de Cl@ve donde el usuario elige método: Cl@ve Permanente, Cl@ve Móvil o Certificado digital/DNIe. Mientras tanto la app muestra el velo "Accediendo con Cl@ve" / "Estamos validando tu identidad…". |
| TC-019 | Completar login con **Cl@ve Permanente** | Se accede con usuario y contraseña de Cl@ve Permanente en la web; al terminar, la app recibe el callback (`es.jccm.espaciociudadano://auth/callback`) y continúa a onboarding (primer acceso) o a Home. |
| TC-020 | Completar login con **Cl@ve Móvil** | Se redirige a la app/flujo de Cl@ve Móvil; tras confirmar en el móvil, la app recibe el callback y continúa. |
| TC-021 | Completar login con **certificado digital** | El navegador solicita elegir un certificado instalado en el dispositivo; tras seleccionarlo, la app recibe el callback y continúa. |
| TC-022 | Cancelar el login (cerrar el navegador / volver atrás) | La app vuelve a la landing sin mostrar mensaje de error (cancelación silenciosa). |
| TC-023 | Provocar un fallo en el login (p. ej. error del IdP) | Se muestra un snackbar de error genérico ("No hemos podido cargar la información solicitada.") y el usuario permanece en la landing. Sin trazas técnicas visibles. |
| TC-024 | Login correcto de un usuario que ya completó el onboarding | Se navega directamente a `/home` sin pasar por protección de datos ni condiciones de uso. |

## 3. Acceso de representantes

> ⚠️ **Funcionalidad en definición.** Estos casos describen el comportamiento esperado del acceso en representación de otra persona (apoderamientos); deberán revisarse y concretarse cuando la funcionalidad esté especificada e implementada (pantallas, literales y reglas de negocio definitivas).

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-025 | Identificarse con Cl@ve siendo un usuario con representaciones vigentes | Tras el login se ofrece elegir el modo de acceso: **en nombre propio** o **en representación de** otra persona (listado de representados disponibles). |
| TC-026 | Seleccionar una persona representada | Se valida la representación contra el registro de apoderamientos correspondiente y se accede al espacio ciudadano **del representado**. |
| TC-027 | Navegar en modo representación | En todo momento se muestra un indicador visible y permanente de que se está actuando en representación (nombre/identificador del representado). |
| TC-028 | Revisar los datos mostrados en modo representación | Todos los apartados (expedientes, registros, notificaciones, mis datos, carnets, agenda…) muestran la información del **representado**, nunca la del representante. |
| TC-029 | Acceder con una representación de ámbito limitado | Solo se puede acceder a los apartados/trámites incluidos en el ámbito del apoderamiento; el resto aparecen bloqueados con un aviso explicativo. |
| TC-030 | Intentar acceder con una representación caducada o revocada | Se deniega el acceso en representación con un mensaje claro; el usuario puede continuar en nombre propio. |
| TC-031 | Cambiar de representado o volver a actuar en nombre propio | Se puede cambiar el contexto sin cerrar sesión; al cambiar, todos los datos y contadores se recargan con la nueva identidad. |
| TC-032 | Realizar acciones en nombre del representado (aportar documentación, aceptar una notificación) | La acción se ejecuta sobre el expediente/notificación del representado y queda registrada la identidad del representante que la realizó. |
| TC-033 | Cerrar sesión en modo representación | Se cierra la sesión y se limpia por completo el contexto de representación; el siguiente acceso vuelve a pedir la elección de modo. |

## 4. Onboarding

*Protección de datos → Condiciones de uso y autorizaciones → Hechos vitales.*

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-034 | Hacer **primer login** (o tras borrar datos de la app / eliminar cuenta) | Se muestra la pantalla de **Protección de datos** (modo onboarding) con el texto legal completo (responsable del tratamiento, finalidad, AEPD, seguridad, perfiles, DPD). |
| TC-035 | Intentar continuar **sin llegar al final** del texto de protección de datos | El botón "Continuar" permanece deshabilitado hasta hacer scroll al final del contenido. |
| TC-036 | Hacer scroll hasta el final y pulsar "Continuar" | Se habilita el botón y al pulsarlo se navega a **"Condiciones de uso y autorizaciones"**. |
| TC-037 | Pulsar "Salir" en la pantalla de protección de datos | Se rechaza el consentimiento: se limpia la sesión y se vuelve a la landing (pantalla de acceso). |
| TC-038 | En "Condiciones de uso y autorizaciones", revisar el contenido | Se muestran las cláusulas opcionales con checkbox (autorización de consulta de datos JCCM, autorización de consulta de datos AGE, hechos vitales/recomendaciones). La cláusula de protección de datos es obligatoria y no aparece como checkbox. |
| TC-039 | Continuar marcando las autorizaciones de datos y la de hechos vitales | Se guarda el consentimiento y se navega a la pantalla de **"Mis hechos vitales"** en modo onboarding. |
| TC-040 | Continuar **sin** marcar la cláusula de hechos vitales | Se guarda el consentimiento y se navega directamente a `/home` (no se pasa por hechos vitales). |
| TC-041 | Forzar error al guardar el consentimiento (sin red) | Snackbar "No se ha podido guardar el consentimiento. Por favor, inténtalo de nuevo."; el usuario permanece en la pantalla. |
| TC-042 | Abandonar el onboarding en condiciones de uso (matar la app / volver) | Al reabrir la app sin consentimiento completado, se vuelve a la landing; el guard de sesión borra la sesión persistida y exige repetir el flujo. |
| TC-043 | Pantalla "Mis hechos vitales" (onboarding): revisar contenido | Título "Selecciona las temáticas sobre las que te gustaría recibir información", lista de checkboxes de hechos vitales y barra con **"Rellenar luego"**, **"Desmarcar todo"** y **"Aceptar"**. No hay botón atrás. |
| TC-044 | Pulsar "Rellenar luego" | No se guarda selección y se navega a la home. |
| TC-045 | Marcar varios hechos vitales y pulsar "Desmarcar todo" | Se desmarcan todas las opciones seleccionadas. |
| TC-046 | Marcar hechos vitales y pulsar "Aceptar" | Se guardan las preferencias ("Tus preferencias se han guardado correctamente.") y se navega a la home. |

## 5. Pantalla de inicio (Home)

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-047 | Acceder a la home autenticada | Se muestran: **Mis novedades** (tarjetas "Notificaciones (n)" y "Próximas citas (n)"), grid **"Mis datos"** con 6 accesos (Salud, Bienestar Social, Empleo, Educación, Vivienda, Vehículos), sección **Trámites recomendados** (carrusel + botón "Ir a recomendaciones") y botón flotante **Carnets**. Barra inferior con 5 pestañas: Inicio, Gestión, Mis datos, Agenda, Recomendados. AppBar con avatar (iniciales del usuario). |
| TC-048 | Usuario con 0 notificaciones pendientes / 0 citas próximas | La tarjeta de novedades correspondiente **no se muestra** (se oculta con contador 0). |
| TC-049 | Pulsar la tarjeta "Notificaciones (n)" | Se navega al listado de notificaciones de Gestión. |
| TC-050 | Pulsar la tarjeta "Próximas citas (n)" | Se navega a la Agenda. |
| TC-051 | Pulsar cada acceso del grid "Mis datos" | Cada uno navega a su sección correspondiente de Mis datos. |
| TC-052 | Usuario **con** autorización de hechos vitales y recomendaciones disponibles | El carrusel muestra hasta 5 trámites recomendados; "Ir a recomendaciones" abre la pestaña Recomendados. |
| TC-053 | Usuario **sin** autorización de hechos vitales | La sección de trámites recomendados no muestra recomendaciones personalizadas. |
| TC-054 | Pulsar el botón flotante **Carnets** con carnets disponibles | Se despliegan botones por cada carnet del usuario (Joven / Familia Numerosa / Discapacidad) más "Mostrar todos". Cada carnet abre su hoja de descarga; "Mostrar todos" navega a Mis carnets digitales. |
| TC-055 | Pulsar el FAB Carnets mientras aún se consultan los carnets | Snackbar "Estamos consultando tus carnets digitales." |
| TC-056 | Pulsar el FAB Carnets sin carnets disponibles | Snackbar "No tienes carnés digitales disponibles." |
| TC-057 | Pulsar el FAB Carnets con error del servicio | Snackbar "No hemos podido consultar tus carnets digitales." |
| TC-058 | Pulsar el FAB Carnets sin autorización JCCM | Se navega a la pantalla de carnets, que muestra el aviso de autorización (ver TC-064). |
| TC-059 | Navegar entre las 5 pestañas del footer | Cada pestaña carga su sección; la pestaña activa queda resaltada y se mantiene coherente al navegar a subpantallas. |

## 6. Carnets digitales

*Precondición general: usuario autenticado con autorización de consulta de datos JCCM (salvo donde se indique).*

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-060 | Abrir "Mostrar todos" / Mis carnets digitales | Se listan todos los carnets del usuario. Cada tarjeta muestra: tipo (Carnet Joven / Familia Numerosa / Discapacidad), número, fecha principal (emisión / entrada en vigor / caducidad según tipo), fecha secundaria (solo Familia Numerosa), etiqueta "DEFINITIVO" cuando aplica y botón **Descargar**. |
| TC-061 | Pulsar el icono de información del apartado | Se abre la hoja "Sobre Mis Carnets Digitales" con la información del apartado y la vía de contacto en caso de error en los carnets. |
| TC-062 | Pulsar "Descargar" en un **Carnet Joven** | Se abre la hoja de descarga con previsualización del **QR** y formatos disponibles: **QR**, **PKPASS** y **PDF**. |
| TC-063 | Pulsar "Descargar" en Familia Numerosa o Discapacidad | La hoja de descarga ofrece solo **PKPASS** (QR y PDF son exclusivos del Carnet Joven). |
| TC-064 | Abrir carnets **sin** autorización JCCM | Aviso "Debes autorizar la consulta de los hechos administrativos…" con acceso directo (engranaje) a Condiciones de uso y autorizaciones. |
| TC-065 | Descargar cada formato disponible (QR / PKPASS / PDF) | Se abre el guardado de fichero del sistema; al confirmar, toast "{FORMATO} guardado correctamente.". En Android, el PKPASS se guarda mediante el canal nativo. Mientras hay una descarga en curso, el resto de botones de descarga quedan bloqueados. |
| TC-066 | Fallar una descarga (cancelar guardado / sin espacio / error) | Se muestra "No hemos podido descargar {FORMATO}." y se puede reintentar. |
| TC-067 | Hacer pull-to-refresh en el listado de carnets | Se recarga la lista de carnets. |
| TC-068 | Usuario sin carnets | Se muestra "Aún no tienes carnets digitales asociados." |
| TC-069 | Error del servicio de carnets | Mensaje de error con botón "Reintentar". |

## 7. Gestión — Mis expedientes

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-070 | Abrir la pestaña **Gestión** del footer | Se muestran las tarjetas: **Mis expedientes**, **Mis registros**, **Aportar documentos a un expediente de terceros** y **Mis notificaciones**. Si el usuario no tiene datos de contacto registrados, "Mis notificaciones" aparece deshabilitada con el aviso "Registra tus datos de contacto…" y botón **Activar**. |
| TC-071 | Abrir "Mis expedientes" | Se listan los expedientes activos del usuario: título, consejería, nº de expediente, fecha de inicio y estado. |
| TC-072 | Usuario sin expedientes | Se muestra "No tienes expedientes activos". |
| TC-073 | Error al cargar expedientes | "No hemos podido cargar tus expedientes" + botón "Reintentar" (que recarga). |
| TC-074 | Pulsar la lupa y filtrar expedientes | Se abre la hoja "Filtrar expedientes" con: número de expediente, descripción, fecha de inicio (rango) y fecha de cierre (rango). Al aplicar, el listado se filtra y la lupa muestra un badge con el nº de filtros activos. |
| TC-075 | Aplicar un filtro sin coincidencias | "Sin coincidencias" / "Revisa los datos introducidos y vuelve a intentarlo." |
| TC-076 | Abrir el detalle de un expediente | Se muestran: título, **Datos del Expediente** (consejería, oficina tramitadora, nº expediente) y **Estado de tramitación** (fecha inicio, fecha cierre, estado). El botón **"Aportar documentación"** solo aparece si el expediente admite aportación. |
| TC-077 | Error al cargar el detalle | "No hemos podido cargar el detalle del expediente" + "Reintentar". |

## 8. Gestión — Aportar documentación a un expediente

*Precondición: expediente que admite aportación de documentos.*

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-078 | Pulsar "Aportar documentación" | Se abre la pantalla con el aviso: "Puedes aportar hasta 5 ficheros de 20MB máx. cada uno, en formato PDF, DOC, DOCX, ZIP, XLS o XLSX." Botones: **Cancelar** y **Seleccionar documentos**. Como en la web, **"Registrar documentos aportados" no aparece hasta que hay documentos**. |
| TC-079 | Pulsar "Cancelar" | Se vuelve a la pantalla del expediente. |
| TC-080 | Seleccionar documentos válidos (formato y tamaño permitidos) | Los documentos se añaden como tarjetas y **su carga arranca en ese momento, sin pulsar nada más** (como en la web): barra de progreso y, al terminar cada uno, estado "Subido". Aparece "Registrar documentos aportados", deshabilitado mientras quede algún fichero sin subir. Cada tarjeta permite eliminarla. |
| TC-081 | Seleccionar un fichero de formato no permitido | Se muestra error de formato no permitido y el fichero no se añade. |
| TC-082 | Seleccionar un fichero mayor de 20 MB | Se muestra error de tamaño máximo y el fichero no se añade. |
| TC-083 | Intentar añadir más de 5 ficheros | Se muestra error de máximo de ficheros y no se añaden los sobrantes. |
| TC-084 | Seleccionar dos veces el mismo fichero | Se muestra error de fichero duplicado. |
| TC-085 | Quitar todos los ficheros de la lista | El botón "Registrar documentos aportados" desaparece: no se ofrece registrar sin documentos. |
| TC-086 | Pulsar "Registrar documentos aportados" con todos los ficheros subidos | Se cierra la aportación con los documentos que quedan en la lista y aparece el diálogo de éxito "Los documentos han sido enviados correctamente" con botones **"Cerrar sin descargar"** y **"Descargar justificante"**. |
| TC-087 | Cancelar una subida en curso desde su tarjeta | Se cancela **solo ese fichero**, que sale de la lista; los demás siguen subiendo y **no aparece ningún mensaje de error**. Se puede volver a seleccionarlo. |
| TC-088 | Fallo de subida de un fichero (p. ej. cortando la red durante su carga) | **Solo esa tarjeta** queda en rojo con "Reintentar" y el icono de eliminar; el resto del lote termina de subirse. "Registrar documentos aportados" queda deshabilitado mientras siga ahí. No hay mensaje aparte: la tarjeta es el aviso. |
| TC-089 | Pulsar "Cerrar sin descargar" | Se vuelve a la pantalla del expediente sin descargar nada. |
| TC-090 | Pulsar "Descargar justificante" y confirmar el guardado | Se guarda el PDF `justificante_<nºexpediente>.pdf` en el dispositivo, toast "Justificante de aportación descargado" y se vuelve al expediente. |
| TC-091 | Pulsar "Descargar justificante" y **cancelar** el guardado del sistema | El diálogo de éxito se vuelve a mostrar (el justificante solo existe en memoria); se puede reintentar la descarga o cerrar sin descargar. |
| TC-092 | Registrar con la sesión caducada (401) | Se muestra "Tu sesión ha caducado" y no se registra la aportación. |
| TC-092a | Pulsar "Reintentar" en la tarjeta de un fichero que falló | Se vuelve a subir **solo ese fichero**; los demás conservan su estado "Subido" y no se vuelven a enviar. Al completarse, "Registrar documentos aportados" se habilita. |
| TC-092b | Pulsar "Eliminar" en un fichero ya subido | La tarjeta desaparece de la lista y **los demás conservan su estado "Subido"**; se puede registrar el resto sin volver a subir nada. |
| TC-092c | Fallo al cerrar el registro (p. ej. cortando la red al pulsar "Registrar") | "Los documentos se han subido pero no se ha podido finalizar el registro. Puedes reintentarlo." Las tarjetas **siguen en "Subido"** y volver a pulsar "Registrar" reintenta solo el cierre, sin re-subir los ficheros. |
| TC-092d | Fallo al preparar la aportación (p. ej. sin red al seleccionar el primer fichero) | "No hemos podido registrar la documentación. Inténtalo de nuevo." y los ficheros quedan como "Seleccionado"; "Reintentar" en una tarjeta vuelve a intentarlo. |

## 9. Gestión — Expedientes de terceros

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-093 | Abrir "Aportar documentos a un expediente de terceros" | Pantalla de búsqueda con: selector de **tipo de documento** (DNI, NIE, CIF, Pasaporte, CEE) + número; y dos campos mutuamente excluyentes: **Número de registro del expediente** y **Código identificador del expediente**. Botón inferior **"Encontrar expediente"**. |
| TC-094 | Escribir en uno de los dos campos de expediente | El otro campo se deshabilita automáticamente (solo se admite uno de los dos). |
| TC-095 | Pulsar el icono de información | Se abre la hoja "Aportar documentos a un expediente" con los 3 supuestos (persona interesada, representante legal, persona autorizada). |
| TC-096 | Buscar sin número de documento | "Introduce el número de documento de la persona interesada." |
| TC-097 | Buscar sin nº de registro ni código identificador | "Rellena el número de registro o el código identificador del expediente (solo uno de los dos)." |
| TC-098 | Buscar con datos incorrectos / expediente inexistente | Se muestra el error devuelto por el servicio y no se navega; no se encuentra el expediente. |
| TC-099 | Buscar con datos correctos | Se abre el detalle del expediente del tercero y se permite aportar documentación (mismo flujo de la sección 8). Al volver atrás desde el detalle se regresa a la búsqueda de terceros. |

## 10. Gestión — Mis registros

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-100 | Abrir "Mis registros" | Pantalla con dos pestañas: **Entradas de registro** y **Salidas de registro**. |
| TC-101 | Revisar el listado de entradas | Por cada entrada: nombre del registro, nº de registro y fecha. |
| TC-102 | Revisar el listado de salidas | Por cada salida: nombre del registro, nº de registro y fecha. |
| TC-103 | Filtrar entradas o salidas (lupa) | Hoja "Filtrar entradas/salidas de registro" con nº de registro, descripción y rango de fechas. Los filtros son independientes por pestaña y la lupa muestra badge con filtros activos. |
| TC-104 | Filtro sin resultados | Mensaje de sin coincidencias con indicación de revisar los datos. |
| TC-105 | Usuario sin registros | "No tienes entradas de registro" / "No tienes salidas de registro" según pestaña. |
| TC-106 | Error al cargar | "No hemos podido cargar tus entradas/salidas de registro" + "Reintentar". |
| TC-107 | Abrir el detalle de un registro (entrada y salida) | "Datos del Registro": nº de registro, fecha y **consejería de origen** (entradas) o **de destino** (salidas). Pantalla de solo lectura. |

## 11. Gestión — Notificaciones electrónicas

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-108 | En Gestión, pulsar "Activar" (usuario sin datos de contacto) | Se abre la pantalla de alta con: campo **Teléfono móvil**, campo **Correo electrónico**, aviso "*Obligatorio rellenar al menos uno de los medios de contacto" y botón **"Dar de alta notificaciones"**. Icono de información con la hoja "Datos de contacto". |
| TC-109 | Dar de alta con ambos campos vacíos | Banner de error: es obligatorio indicar al menos un medio de contacto. |
| TC-110 | Dar de alta con teléfono inválido (≠ 9 dígitos) o email inválido | Banner de error de validación del campo correspondiente; no se activan las notificaciones. |
| TC-111 | Dar de alta con datos correctos | Snackbar "Datos de contacto guardados" y vuelta a la pantalla de Gestión, donde "Mis notificaciones" pasa a estar habilitada. |
| TC-112 | Abrir "Mis notificaciones" | Listado con filtro de estado: **Todo / Pendientes / Aceptadas / Expiradas** (el estado "Expiradas" se alcanza desplazando el selector con la flecha). Cada tarjeta muestra: organismo, etiqueta de estado, título, procedimiento y fecha de expiración (resaltada en ámbar si está pendiente). |
| TC-113 | Filtrar notificaciones (lupa) | Hoja "Filtrar notificaciones" con descripción y fecha de expiración. Filtro sin resultados muestra su mensaje propio. |
| TC-114 | Pulsar el icono de configuración | Se navega a "Datos de contacto para notificaciones" (Preferencias) y al guardar se vuelve al listado. |
| TC-115 | Abrir una notificación **pendiente** | Detalle con: etiqueta de estado, título, **Datos del expediente** (organismo emisor, procedimiento, nº expediente), **Estado notificación** (fecha de puesta a disposición, fecha de expiración) y barra inferior **"Aceptar notificación"**. Las notificaciones pendientes **no muestran** la sección Documentos. |
| TC-116 | Pulsar "Aceptar notificación" | Snackbar "Has aceptado la notificación.", se vuelve al listado y el estado pasa de "Pendiente" a "Aceptada". |
| TC-117 | Fallo al aceptar | "No hemos podido aceptar la notificación. Inténtalo de nuevo." — el estado no cambia. |
| TC-118 | Abrir una notificación **aceptada** o **expirada** | Detalle con datos del expediente, estado (fecha de puesta a disposición y fecha de lectura o expiración) y sección **Documentos** (nombre y tamaño). Sin botón de aceptar. Nota: los documentos se listan pero **no tienen descarga implementada** (ver sección 27). |
| TC-119 | Usuario sin notificaciones | "No tienes notificaciones en este momento". |
| TC-120 | Error al cargar el listado o el detalle | Mensaje de error correspondiente + "Reintentar". |

## 12. Mis datos — general

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-121 | Abrir "Mis datos" en el footer | Se muestran 6 tarjetas: **Salud**, **Bienestar Social**, **Empleo**, **Educación**, **Vivienda** y **Vehículos**; todas navegan a su sección. |
| TC-122 | Patrón común de cada sección | Cada sección tiene 2 pestañas: **"Mis datos de X"** e **"Información y servicios"**, e icono de información con su hoja explicativa. |
| TC-123 | Acceder a una sección sin la autorización requerida | Se muestra el aviso contextual de autorización pendiente con acceso (engranaje) a "Condiciones de uso y autorizaciones"; los datos no se cargan. Las secciones Salud y Bienestar Social requieren la autorización **JCCM**; Empleo (demanda), Educación, Vivienda y Vehículos requieren la autorización **AGE**. |
| TC-124 | Conceder la autorización desde el aviso y volver | Al volver a la sección, los datos se cargan con normalidad. |
| TC-125 | Servicio no disponible en cualquier sección | Mensaje de servicio no disponible + botón **"Actualizar"** que relanza la consulta. |
| TC-126 | Enlaces de "Información y servicios" en cualquier sección | Cada enlace muestra el diálogo "Vas a salir de la aplicación" y abre el navegador externo. |

## 13. Mis datos — Salud

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-127 | Abrir "Mis datos de Salud" | Se muestra el **CIP** del usuario, selector **Pendientes / Pasadas** y el listado de **citas de Atención Primaria** agrupado por año y mes. Cada cita muestra: día, día de la semana, hora, modalidad, profesional que atenderá, descripción y centro. El selector Primaria/Hospitalaria está desactivado (citas hospitalarias no habilitadas en esta versión). |
| TC-128 | Cambiar entre "Pendientes" y "Pasadas" | El listado cambia entre citas futuras y pasadas. |
| TC-129 | Hacer scroll en "Pasadas" con muchas citas | Se cargan más citas automáticamente al llegar al final y/o con el botón "Cargar más citas" (paginación). |
| TC-130 | Filtrar citas (lupa) | Hoja "Filtrar citas" con rango de fecha de la cita; el listado se filtra. |
| TC-131 | Pulsar el icono de información | Hoja "Sobre Mis datos de Salud": consulta de citas de Atención Primaria del SESCAM y aviso de contactar con el Centro de Salud si algún dato es incorrecto. |
| TC-132 | Usuario sin citas | Mensaje de sin datos + botón "Contacto" (abre el portal de sanidad de CLM). |
| TC-133 | Revisar "Información y servicios" de Salud | Trámites: Reclamaciones y quejas SESCAM, Solicitud de tarjeta sanitaria, Libre elección en atención especializada. Enlaces de interés: SESCAM, Mi Salud Digital, Historia clínica digital (SNS). |

## 14. Mis datos — Bienestar Social

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-134 | Abrir "Mis datos de Bienestar" | Se muestran 5 tarjetas de navegación: **Familia numerosa**, **Discapacidad**, **Termalismo**, **Atención a la dependencia** y **Tarjeta de estacionamiento**. Sin autorización JCCM aparecen deshabilitadas con el aviso contextual. |
| TC-135 | Abrir "Familia numerosa" | "Mi título": comunidad, nº título, categoría, vigente (Sí/No), fecha de emisión, fecha de caducidad, nº de hijos; bloque **Beneficiarios** (documento, fecha de nacimiento, nombre completo, titular Sí/No) y aviso con botón "Contacto oficinas". |
| TC-136 | Abrir "Discapacidad" | Grado (%), fecha de efectos, validez definitiva, nº expediente, fecha de nacimiento, procede movilidad, concurso de tercera persona, real decreto. |
| TC-137 | Abrir "Termalismo" | "Último balneario adjudicado": nombre del balneario, fecha desde y fecha hasta. |
| TC-138 | Abrir "Atención a la dependencia" | "Mi situación actual" (fecha de solicitud, fecha de resolución, grado reconocido, baremo) y **Prestaciones** (categoría, nombre, fecha resolución, fecha efecto, importe €). |
| TC-139 | Abrir "Tarjeta de estacionamiento" | Código de la tarjeta, modalidad y vigencia (desde/hasta). |
| TC-140 | Usuario sin datos en cada subapartado | Mensaje propio de sin datos con vía de contacto. |
| TC-141 | Icono de información en cada subapartado | Hoja informativa con botón "Contacto oficinas". |
| TC-142 | Revisar "Información y servicios" de Bienestar | Trámites: reconocimiento del grado de discapacidad, atención temprana, estancias temporales en centros residenciales. Enlaces: Historia Social Única, Infancia y Familias. |

## 15. Mis datos — Empleo

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-143 | Abrir "Mis datos de Empleo" con ambas autorizaciones | Bloque **demanda de empleo** (datos de la demanda, requiere autorización AGE) y bloque **Inscripciones en ofertas** (tarjeta navegable, requiere autorización JCCM). |
| TC-144 | Usuario sin demanda de empleo | Se muestra el estado vacío del bloque de demanda. |
| TC-145 | Fallo del servicio de demanda | Banner "Servicio no disponible" (descartable) + botón "Recargar página". |
| TC-146 | Pulsar "Inscripciones en ofertas" **sin** autorización JCCM | Diálogo "No has autorizado la consulta de datos en tu perfil" con botones "Ir a Condiciones de uso y autorizaciones" y "Volver". |
| TC-147 | Abrir "Inscripciones en ofertas" con autorización | Listado con: fecha de publicación, fecha de inscripción, fecha fin del proceso de selección y estado de la candidatura. Estados vacío y error con reintento. |
| TC-148 | Revisar "Información y servicios" de Empleo | Trámites: certificado de profesionalidad, inscripción como demandante, credenciales de la oficina virtual. Enlaces: Empleo CLM, Empleo Público CLM. |

## 16. Mis datos — Educación

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-149 | Abrir "Mis datos de Educación" (autorización AGE) | Tarjetas **Títulos universitarios** y **Títulos no universitarios**; deshabilitadas con aviso si falta la autorización. |
| TC-150 | Abrir "Títulos universitarios" | Tarjetas con: nº de título, nombre, universidad, fecha de finalización y fecha de expedición. Hoja de información con botón de contacto (Ministerio de Ciencia). |
| TC-151 | Abrir "Títulos no universitarios" | Tarjetas con: provincia, fecha de expedición y fecha de finalización. Hoja "Sobre tus títulos no universitarios". |
| TC-152 | Usuario sin títulos / error de servicio | Mensajes propios de vacío y de error con reintento. |
| TC-153 | Revisar "Información y servicios" de Educación | Trámites: equivalencia de títulos, becas, título de secundaria. Enlaces: Educamos CLM, portal del profesorado. |

## 17. Mis datos — Vivienda

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-154 | Abrir "Mis datos de Vivienda" (autorización AGE) | Tarjetas **Bienes inmuebles** y **Domicilio en Castilla-La Mancha**. |
| TC-155 | Abrir "Bienes inmuebles" | Filtro segmentado **Todo / Urbano / Rústico**; tarjetas con referencia catastral, dirección, valor catastral, valor del suelo, valor de construcción y uso. |
| TC-156 | Filtrar por Urbano/Rústico sin resultados | Mensaje propio de vacío por filtro. |
| TC-157 | Abrir el detalle de un inmueble | "Datos de la vivienda" (6 campos), botón **"Mostrar cartografía"** (solo si hay URL; abre enlace externo con confirmación) y bloque **Titulares** (nombre y tipo de titularidad) o mensaje de sin titulares. La pantalla se cierra con la **X**. |
| TC-158 | Usuario sin inmuebles | Mensaje de sin datos con botón de contacto a la Sede del Catastro. |
| TC-159 | Abrir "Domicilio en Castilla-La Mancha" | "Datos del domicilio" (dirección, CP, municipio, provincia, entidad colectiva, entidad singular, unidad poblacional) y "Datos de empadronamiento" (tipo de variación, fecha de variación). Vacío → contacto con Ayuntamiento/oficinas OIR. |
| TC-160 | Revisar "Información y servicios" de Vivienda | Enlaces: Vivienda CLM, Catastro. Trámites: registro de vivienda protegida, ayudas de emergencia social, ayudas al alquiler. |

## 18. Mis datos — Vehículos

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-161 | Abrir "Mis datos de Vehículos" (autorización AGE) | Sección "Mis vehículos" con una tarjeta por vehículo mostrando la **matrícula**. |
| TC-162 | Usuario sin vehículos | Mensaje de sin datos (DGT) con botón "Contacto" a la sede de la DGT. |
| TC-163 | Icono de información | Hoja informativa con botón de contacto de la DGT. |
| TC-164 | Revisar "Información y servicios" de Vehículos | Enlaces: DGT, Carpeta Ciudadana AGE. Trámites: MOVES III vehículos, MOVES III infraestructura, CAP. |

## 19. Agenda

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-165 | Abrir la pestaña **Agenda** | Se muestran: filtros de rango **Todos / 7 días / 30 días / 365 días**, **calendario** con los días con eventos marcados, fila "Actualizado el {fecha} a las {hora}" con botón **"Actualizar agenda"** y listado de eventos agrupado por año/mes. |
| TC-166 | Revisar los tipos de evento del listado | Eventos de **notificación**, de **salud** (con canal presencial/telefónico) y de **credencial** (sin hora). |
| TC-167 | Cambiar el filtro de rango | El listado y el calendario reflejan solo los eventos del periodo seleccionado. |
| TC-168 | Pulsar "Actualizar agenda" | Se refrescan los eventos contra los sistemas de origen y se actualiza la fecha de "Actualizado el…". Si el refresco remoto falla, el listado local se recarga igualmente. |
| TC-169 | Periodo sin eventos | "No hay citas para el periodo seleccionado." |
| TC-170 | Error al cargar la agenda | "No hemos podido cargar tu agenda." + "Intentar de nuevo". |
| TC-171 | Abrir la agenda **sin** autorización JCCM | Aviso contextual con engranaje hacia Condiciones de uso y autorizaciones; no se muestran filtro ni listado. |

## 20. Trámites recomendados

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-172 | Abrir la pestaña **Recomendados** (con autorización de hechos vitales) | Listado de recomendaciones con navegación de segmentos **Todo / Últimos días / Novedades / Trámite inmediato** (los últimos accesibles con flechas o swipe). Cada tarjeta: título, categorías, hechos vitales asociados y estado o plazo. |
| TC-173 | Pulsar una recomendación con URL de detalle | Diálogo "Vas a salir de la aplicación" y apertura del detalle en el navegador. |
| TC-174 | Pulsar una recomendación sin URL | Snackbar "Detalle disponible próximamente". |
| TC-175 | Pulsar "Filtrar por hechos vitales" | Se abre "Filtrar recomendaciones por hecho" con chips seleccionables y barra con **Limpiar** y **Aplicar**. Al aplicar, el listado se filtra y el botón muestra el nº de filtros activos. |
| TC-176 | Aplicar un filtro sin resultados | "No hay recomendaciones para el filtro realizado." + botón "Resetear filtro". |
| TC-177 | Pulsar el engranaje de la pantalla | Se navega a "Mis hechos vitales" (Preferencias) y al volver se recargan las recomendaciones. |
| TC-178 | Abrir Recomendados **sin** autorización de hechos vitales | Aviso de no autorizado con engranaje hacia Condiciones de uso y autorizaciones. |
| TC-179 | Usuario autorizado pero sin recomendaciones | Aviso "Actualmente no hay recomendaciones disponibles…" + botón "Editar preferencias - hechos vitales". |
| TC-180 | Error al cargar | "No hemos podido cargar las recomendaciones." + "Reintentar". |

## 21. Preferencias

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-181 | Abrir **Preferencias** desde el menú de perfil | Tarjetas: **Condiciones de uso y autorizaciones** (botón Editar), **Mis hechos vitales** (resumen de selección + "Actualizado el…" + botón Seleccionar), **Datos de contacto para notificaciones** (resumen + botón Gestionar) y botón destructivo **Eliminar cuenta**. |
| TC-182 | Pulsar "Editar" en Condiciones de uso | Se abre "Condiciones de uso y autorizaciones" en modo edición (con botón atrás e icono de información que reabre el texto legal); los cambios se guardan y se vuelve a Preferencias. |
| TC-183 | Revocar la autorización JCCM o AGE y visitar las secciones afectadas | Las secciones dependientes (Salud, Bienestar, Carnets, Agenda / Educación, Vivienda, Vehículos, demanda de Empleo) pasan a mostrar el aviso de autorización pendiente. |
| TC-184 | Tarjeta "Mis hechos vitales" sin la cláusula de hechos vitales aceptada | La tarjeta aparece deshabilitada. |
| TC-185 | Pulsar "Seleccionar" en Mis hechos vitales | Se abre la pantalla de hechos vitales en modo edición con **Limpiar** y **Guardar** (Guardar solo activo si hay cambios). Al guardar: "Tus preferencias se han guardado correctamente." |
| TC-186 | Salir de hechos vitales con cambios sin guardar | Diálogo "Descartar cambios" con "Seguir editando" / "Descartar". |
| TC-187 | Pulsar "Borrar preferencias" en hechos vitales | Diálogo "Borrar tus preferencias" ("Se eliminarán todos los hechos vitales seleccionados. Esta acción no se puede deshacer.") con Cancelar/Borrar; al borrar se limpia la selección. |
| TC-188 | Pulsar "Gestionar" en Datos de contacto | Formulario precargado con el contacto actual; mismas validaciones que el alta (al menos un medio, teléfono de 9 dígitos, email válido). Al guardar: "Datos de contacto guardados" y vuelta a Preferencias. |
| TC-189 | Pulsar "Eliminar cuenta" | Diálogo "Eliminación de cuenta y revocación de permisos" con el texto de confirmación y botones **Cancelar** / **Eliminar**. |
| TC-190 | Confirmar "Eliminar" | Se borran hechos vitales, cláusulas y datos locales, se cierra la sesión (logout federado) y se vuelve a la landing. Un nuevo login exige repetir el onboarding completo (TC-034). |
| TC-191 | Fallo al eliminar cuenta | "No hemos podido borrar tus autorizaciones. Inténtalo de nuevo." — la sesión no se cierra. |

## 22. Menú de perfil y cierre de sesión

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-192 | Pulsar el avatar de la AppBar (Home, Agenda, Recomendados) | Se abre el menú de perfil: cabecera "Hola, {nombre}" con tipo y número de documento (DNI/NIE/NIF); ítems **Preferencias** y **Mis carnets digitales**; enlaces **Ayuda y contacto**, **Accesibilidad**, **Aviso legal**, **Protección de datos**; botón **"Ir a Sede Electrónica"** y **Cerrar sesión**. |
| TC-193 | Verificar los datos de la cabecera | Nombre e identificador coinciden con los del certificado/Cl@ve usados en el login. |
| TC-194 | Pulsar "Ir a Sede Electrónica" | Diálogo de salida de la app y apertura de la Sede Electrónica de la JCCM en el navegador. |
| TC-195 | Pulsar "Cerrar sesión" | Se cierra la sesión local y la sesión federada de Cl@ve (logout con id_token) y se vuelve a la landing. Un nuevo acceso requiere identificarse otra vez (la cookie SSO queda invalidada: Cl@ve vuelve a pedir credenciales). |

## 23. Pantallas legales

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-196 | Abrir "Protección de datos" desde el menú de perfil | Se muestra el texto legal completo en modo consulta (sin bloqueo de scroll ni botones de onboarding); el atrás vuelve a la home. |
| TC-197 | Abrir "Aviso legal" | Se muestra la pantalla de aviso legal completa. |
| TC-198 | Abrir "Accesibilidad" | Se muestra la declaración de accesibilidad con **buscador de texto** dentro del contenido; la búsqueda resalta/localiza coincidencias. |

## 24. Enlaces externos

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-199 | Pulsar cualquier enlace externo de la app | Siempre se muestra primero el diálogo bloqueante "Vas a salir de la aplicación" / "El contenido se abrirá en una ventana de tu navegador" con **Volver** y **Continuar**. No se puede cerrar tocando fuera. |
| TC-200 | Pulsar "Volver" en el diálogo | El diálogo se cierra y no se abre nada. |
| TC-201 | Pulsar "Continuar" | El enlace se abre en el navegador externo (no dentro de la app). |
| TC-202 | Fallo al abrir un enlace o teléfono | Snackbar de error de apertura de enlace; la app no se rompe. |

## 25. Sesión y seguridad

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-203 | Cerrar la app y volver a abrirla | Se muestra la landing y es necesario identificarse de nuevo con Cl@ve/certificado (no existe acceso rápido; la sesión no se rehidrata automáticamente). |
| TC-204 | Dejar la sesión caducar y realizar una acción con red | La app intenta renovar el token automáticamente; si lo consigue, la acción se completa sin que el usuario lo perciba. |
| TC-205 | Renovación imposible (refresh token caducado/revocado) | Se muestra "Tu sesión ha caducado" donde aplique y/o se redirige a la landing al navegar; no se muestran errores técnicos. |
| TC-206 | Navegar a una ruta protegida sin sesión (p. ej. tras expulsión) | El guard de sesión redirige a la landing. |
| TC-207 | Restaurar la app desde una copia de seguridad en un dispositivo nuevo (Android e iOS) | La primera apertura tras la restauración **no** conserva la sesión: el almacenamiento seguro restaurado se limpia y se exige login completo. |
| TC-208 | Verificar la privacidad de los errores | En ningún fallo de red/servicio se muestran al usuario trazas técnicas, códigos crudos ni URLs del backend. |

## 26. Transversales

### 26.1 Accesibilidad

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-209 | Recorrer la landing, about y ayuda con TalkBack/VoiceOver | El título H1 de la pantalla se anuncia primero; las imágenes decorativas no se anuncian; todos los botones de icono tienen etiqueta/tooltip. |
| TC-210 | Recorrer listados y formularios con lector de pantalla | Tarjetas, filas de checkbox y campos anuncian etiquetas coherentes; los diálogos anuncian su título al abrirse. |
| TC-211 | Aumentar el tamaño de fuente del sistema (>150 %) | Los textos escalan sin cortes; los diálogos con botones en horizontal pasan a disposición vertical; no hay solapes en las pantallas principales. |
| TC-212 | Verificar el tamaño de las zonas táctiles | Todos los elementos interactivos alcanzan el mínimo de 48 dp. |

### 26.2 Idioma, orientación y plataforma

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-213 | Dispositivo en español | Toda la interfaz se muestra en español. |
| TC-214 | Dispositivo en inglés | La interfaz se muestra en inglés (la app sigue el idioma del sistema; no hay selector interno). Con cualquier otro idioma del sistema, la app cae al idioma por defecto. |
| TC-215 | Girar el dispositivo | La app permanece bloqueada en vertical (portrait) en todas las pantallas. |
| TC-216 | Ejecutar los flujos críticos (login, aportación, descargas) en Android y en iOS | Comportamiento equivalente; en Android el guardado de PKPASS usa el canal nativo; en iOS la selección de ficheros respeta los tipos permitidos. |

### 26.3 Conectividad y estados de red

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-217 | Usar la app sin conexión | Las pantallas de datos muestran sus estados de error con opción de reintento; la app no se bloquea ni se cierra. **Nota:** actualmente no se muestra ningún banner de "sin conexión" (componente implementado pero no integrado, ver sección 27). |
| TC-218 | Recuperar la conexión y reintentar | Los botones "Reintentar"/"Actualizar" recargan los datos correctamente. |
| TC-219 | Red lenta / timeouts | Se muestran los indicadores de carga y, agotado el tiempo, el error curado con reintento. |

### 26.4 Navegación y deep links

| ID | Acción | Resultado esperado |
|---|---|---|
| TC-220 | Abrir el deep link `es.jccm.espaciociudadano://auth/callback` fuera de un login en curso | La app gestiona el callback sin crashear (navega a landing en caso de error). |
| TC-221 | Navegar a una ruta inexistente | Se muestra la pantalla 404 "La ruta solicitada no existe". |
| TC-222 | Usar el botón atrás físico/gesto en cada pantalla | La navegación vuelve a la pantalla lógica anterior (detalles → listados → sección → home); desde la home no se sale a pantallas protegidas tras cerrar sesión. |
| TC-223 | Cambiar de pestaña del footer estando en una subpantalla profunda | La pestaña destino se carga correctamente y el estado de la pestaña de origen no corrompe la navegación. |

## 27. Riesgos y observaciones conocidas

Puntos detectados en el código que el equipo debe decidir si son defectos a corregir o comportamiento aceptado. No son casos de prueba ejecutables tal cual, pero deben vigilarse en regresión:

1. **Retirada de la biometría**: el código actual todavía incluye la funcionalidad (diálogo de activación en la Home, tarjeta en Preferencias, desbloqueo automático en la landing y textos asociados). Al retirarla, verificar en regresión que no queda ningún resto visible (diálogos, tarjetas, prompts, literales) y que la app siempre exige login con Cl@ve al reabrirse.
2. **Acceso de representantes sin implementar**: no existe todavía en el código; la sección 3 de este plan es provisional y debe concretarse con la especificación definitiva.
3. **Documentos de notificaciones sin descarga**: en el detalle de una notificación aceptada/expirada los documentos se listan pero no tienen acción de descarga (existen los textos de descarga en los recursos, sin UI asociada).
4. **Rechazo de notificaciones no implementado**: existen literales para "Rechazar definitivamente" pero no hay botón ni flujo.
5. **Banner offline no integrado**: el componente "Sin conexión. Mostrando datos guardados." está implementado pero no se usa en ninguna pantalla.
6. **Citas hospitalarias desactivadas** por flag en código (`kHospitalAppointmentsEnabled = false`): el selector Primaria/Hospitalaria aparece deshabilitado.
7. **Ruta `/gestion/registros/detail`** exige datos de navegación (`extra`); si se llega sin ellos (deep link/restauración) la app puede crashear.
8. **`/design-system`** (catálogo interno de componentes) es accesible sin autenticación; valorar si debe deshabilitarse en release.
9. **`/login` es un placeholder** no funcional si se navega directamente; `/` (splash) y `/maintenance` no tienen ruta registrada (caen en 404).
10. **Campana de notificaciones oculta** en todas las AppBar (`showNotifications: false`) aunque existe el handler.
11. **No hay notificaciones push**: "Mis novedades" son contadores consultados por API al abrir la home.
12. **No se muestra la versión de la app** en ninguna pantalla.
13. **Captcha del formulario de soporte**: existen componentes y textos de captcha pero no está integrado en el formulario.
14. **Firma electrónica (@firma)**: hay textos y una ruta de retorno declarada (`/sign/afirma/return`) pero sin pantallas ni registro en el router — funcionalidad futura.
15. **Discrepancia de literal**: el error de asunto del formulario de soporte menciona 100 caracteres en el recurso pero la validación aplica 1000.
16. **FAQ**: tres entradas siguen siendo placeholder ("Preguntas a trabajar para app").

---

## Trazabilidad con el plan anterior

| Plan antiguo | Este plan | Nota |
|---|---|---|
| TC-1, TC-2 | TC-002…TC-006, TC-016 | Ampliados con contacto, formulario de soporte y detalle de FAQ. |
| TC-3 a TC-6 | TC-018…TC-021 | La elección de método (Permanente/Móvil/Certificado) ocurre en la web de Cl@ve, no en una pantalla propia de la app. |
| TC-7 a TC-13 | TC-034…TC-042 | Igual flujo; añadido el caso de error de guardado. |
| TC-14 a TC-17 | TC-043…TC-046 | "Rellenar luego" y "Aceptar" llevan directamente a la Home. |
| TC-18, TC-19 | **Eliminados** | La biometría se retira de la app (ver riesgo nº 1); tras el onboarding se navega directamente a la Home y cada apertura de la app exige login con Cl@ve. |
| TC-20 | TC-047…TC-059 | Añadidos estados del FAB Carnets y ocultación de novedades a 0. |
| TC-21 a TC-25 | TC-054, TC-060…TC-069 | Corregido: los formatos QR/PDF solo aplican al Carnet Joven; PKPASS a todos. |
| TC-26 a TC-29 | TC-070, TC-108…TC-111 | Igual, con literales exactos. |
| TC-30 a TC-39 | TC-071…TC-092 | Añadidos filtros, límite de 5 ficheros, duplicados, cancelación/reintento de subida y bucle del justificante. |
| TC-40 a TC-43 | TC-100…TC-107 | El detalle muestra consejería de origen (entradas) o destino (salidas). |
| TC-44 a TC-46 | TC-093…TC-099 | Añadido selector de tipo de documento y exclusión mutua de campos. |
| TC-47 a TC-49 (notificaciones) | TC-112…TC-120 | Corregido: las pendientes no muestran Documentos; los documentos listados no se descargan (riesgo nº 3). |
| TC-49 (Mis datos), TC-50 | TC-121…TC-133 | Ampliado a las 6 secciones completas de Mis datos. |
| — | TC-025…TC-033 | **Nueva sección**: Acceso de representantes (funcionalidad en definición). |
