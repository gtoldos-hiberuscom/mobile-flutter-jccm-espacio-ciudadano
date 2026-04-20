# Carpeta Ciudadana CLM — Comprensión Funcional y Mapeo de Servicios

**Proyecto:** Aplicación Móvil Carpeta Ciudadana — Junta de Comunidades de Castilla-La Mancha  
**API de referencia:** Fachada Sede API v1.41.0  
**Fecha:** 17 de febrero de 2026  
**Elaborado por:** [Nombre del equipo / empresa]  
**Destinatario:** [Nombre del responsable de proyecto — Cliente]  
**Clasificación:** Documento de trabajo — Uso interno del proyecto

---

## 1. Resumen Ejecutivo

Este documento recoge el análisis funcional realizado sobre la especificación OpenAPI (Fachada Sede API v1.41.0) y su correspondencia con las pantallas y funcionalidades previstas para la aplicación móvil Carpeta Ciudadana.

El objetivo es doble:

- **Confirmar la comprensión del alcance:** qué pantallas se construirán, qué servicios las alimentan y qué datos se intercambian.
- **Identificar lagunas y puntos de validación:** qué aspectos de la documentación requieren confirmación antes o durante el desarrollo.

El análisis concluye que **la especificación cubre el 87-89 % de los servicios necesarios** (40-41 de 47 operaciones disponibles). Las 10 pantallas principales de la aplicación están mapeadas, 9 de ellas con cobertura completa. Las funcionalidades sin cobertura en la API corresponden a servicios del Dashboard que no disponen de endpoint en la especificación actual.

---

## 2. Alcance y Supuestos

### 2.1 Qué entra en el alcance

- 10 pantallas funcionales: Dashboard, Mi Agenda, Mis Gestiones, Consulta de Expedientes, Notificaciones, Mi Carnet Digital, Mis Recomendaciones, Mis Hechos Vitales, Condiciones de Uso y Guía de Ayuda.
- Un flujo transversal de Firma Digital (integración con sistema Afirma).
- Integración con autenticación Cl@ve como mecanismo de identidad (los parámetros del token de sesión condicionan la mayoría de las llamadas a servicios).

### 2.2 Supuestos y Aclaraciones de Implementación

#### Autenticación y Sesión (S1, N10)
- **S1**: La autenticación mediante Cl@ve proporciona un token (JWT) con los datos de identidad necesarios para todas las llamadas a servicios federados (documento, nombre, identificador de autorización, tipo de documento).
- **N10**: Todas las pantallas con interacción con la API dependen del token de sesión obtenido tras la autenticación con Cl@ve. Si este token expira, no se renueva o no contiene los datos esperados, la operativa de la aplicación se verá comprometida. La gestión del ciclo de vida de la sesión (renovación, cierre, manejo de expiración) se definirá durante el desarrollo.

#### Parámetro idAgente (S2, N6)
- **S2**: El parámetro `idAgente` utilizado en los servicios de Hechos Vitales y Recomendaciones se obtiene como constante derivada del proceso de autenticación.
- **N6**: Los servicios de Hechos Vitales y Recomendaciones utilizan un identificador (`idAgente`) que funciona como constante derivada del proceso de autenticación Cl@ve. A confirmar su valor exacto y mecanismo de obtención con el equipo de backend.

#### Patrón de Servicios Federados (S3, N7)
- **S3**: Los servicios federados (Catastro, DGT, Educación, INE, SEPE, Familia Numerosa) emplean método POST para operaciones de consulta. Esto responde al patrón de la API subyacente (SAP/legacy) y no implica creación de recursos.
- **N7**: Este patrón está identificado y no supone un impedimento funcional.

#### Respuestas no Estructuradas (S4, N4)
- **S4**: Las respuestas marcadas como `string` en la especificación (9 operaciones) contienen datos estructurados (posiblemente XML, JSON serializado o binario codificado en base64) que requieren tratamiento adicional en la aplicación. Su estructura exacta se determinará durante el desarrollo.
- **N4**: Esto afecta a los servicios de SESCAM (citas, CIP), carnets digitales (PDF, PKPass, grado de discapacidad) e intermediación de discapacidad. Será necesario obtener ejemplos de respuestas reales en entorno de preproducción para implementar correctamente el tratamiento de estos datos.

#### Dashboard — Servicios Adicionales (N1)
- Estos servicios (Termalismo, Tarjeta de Estacionamiento, Atención a la Dependencia, Inscripciones en Ofertas de Empleo) se implementarán bajo el supuesto de que la API proporcionará los endpoints correspondientes en versiones posteriores o se accederá a través de servicios federados alternativos.
- **Enfoque**: Diseñar la pantalla de Dashboard con estructura flexible para acomodarlos sin rediseño. Mientras tanto, se propone tratarlos como funcionalidades no disponibles en la interfaz (indicación visual al ciudadano) o excluirlos del alcance hasta que se habiliten los servicios correspondientes.

#### Flujo de Tramitación de Procedimientos (N2, N9)
- Se asume que los endpoints `inicproc`, `miconfirmarproc`, `miobtenerres` y `subiradjuntosinfirma` disponibles en la API serán utilizados para implementar un flujo completo de tramitación accesible desde una pantalla dedicada o integrado en "Mis Gestiones".
- **Operaciones sin pantalla asignada** que podrían formar parte de este flujo o futuros desarrollos: `POST /publicacion/selectbynifexp`, `POST /publicacion/misexpedientes`, `POST /consulta/miconsultareq`, `POST /documentacion/registrarfichero`, `POST /intermediacion/familia-numerosa/datos`.

#### Notificaciones Push (N3)
- La aplicación implementará notificaciones push asumiendo que se habilitará un servicio de notificaciones (FCM/APNs) en fases posteriores.
- **Fase 1**: Se contempla consulta manual de notificaciones; la infraestructura se preparará para recibir notificaciones cuando estén operativas.

#### Endpoint de Notificaciones (N5)
- Se ha asignado provisionalmente la operación `POST /servicio/midetalle` a la pantalla de Notificaciones, basándose en su descripción ("consultar el detalle de un trámite").
- **A validar** con el equipo de backend antes de iniciar el desarrollo de esta pantalla, ya que no hay confirmación explícita de que sea el servicio correcto.

#### Inconsistencias en la Documentación de la API (N8)
Se han detectado las siguientes discrepancias en la especificación OpenAPI que no afectan a la funcionalidad, pero conviene tener en cuenta:
- Descripciones erróneas (p. ej., endpoints de discapacidad con descripción referida a familia numerosa).
- Un endpoint sin descripción alguna (`POST /intermediacion/familia-numerosa/datos`).
- Un endpoint de registro de fichero (`POST /documentacion/registrarfichero`) sin códigos de error definidos.
- Un modelo de datos vacío (`DATOSPROCEDIMIENTO`) sin propiedades documentadas.
- El endpoint de datos catastrales retorna un modelo genérico (`Respuesta`) en lugar de un modelo con los datos específicos del catastro.

---

## 3. Mapa de Pantallas y Servicios

### 3.1 Tabla de correspondencia principal

| # | Pantalla / Funcionalidad | Objetivo funcional | Endpoints utilizados | Datos clave | Observaciones |
|---|--------------------------|-------------------|---------------------|-------------|---------------|
| 1 | **Dashboard / Inicio** | Mostrar un resumen del ciudadano agrupado por áreas temáticas (Educación, Salud, Bienestar Social, Empleo, Vivienda/Vehículos). | POST `/educacion/titulos-universitarios/{numDocumento}` | Títulos, citas, datos de familia, empleo, residencia, catastro, vehículos. | 7 de 12 bloques temáticos disponen de endpoint. 5 bloques sin servicio en la API actual (ver N1). |
|   |  |  | POST `/educacion/titulos-no-universitarios/{numDocumento}` |  |  |
|   |  |  | GET `/sescam/citas/{numDocumento}` |  |  |
|   |  |  | POST `/ccaa/familia-numerosa/{numDocumento}` |  |  |
|   |  |  | POST `/intermediacion/discapacidad/datos` |  |  |
|   |  |  | POST `/sepe/demandante-empleo-fecha-actual/{numDocumento}` |  |  |
|   |  |  | POST `/ine/datos-residencia/{numDocumento}` |  |  |
|   |  |  | POST `/catastro/datos-catastrales/{numDocumento}` |  |  |
|   |  |  | POST `/dgt/lista-vehiculos/{numDocumento}` |  |  |
| 2 | **Mi Agenda** | Consultar citas sanitarias pasadas y futuras, y obtener la tarjeta sanitaria (CIP). | GET `/sescam/citas/{numDocumento}` | Citas futuras, citas pasadas, CIP. | Los tres endpoints devuelven formato `string`; la estructura real de los datos debe validarse (ver N4). Filtros de período se aplican en la aplicación. |
|   |  |  | GET `/sescam/citas-pasadas/{numDocumento}` |  |  |
|   |  |  | GET `/sescam/cip/{numDocumento}` |  |  |
| 3 | **Mis Gestiones / Expedientes** | Consultar expedientes del ciudadano (propios, entradas y salidas de registro) y aportar documentación. | POST `/publicacion/selectbynif` | Listado de expedientes, detalle por expediente o registro, documentos adjuntos. | Restricciones de adjuntos: formatos PDF, DOC, DOCX, ZIP, XLS, XLSX; máximo 5 archivos, 50 MB cada uno. Se genera un hash de validación antes de cada carga. |
|   |  |  | POST `/publicacion/selectbynifentrada` |  |  |
|   |  |  | POST `/publicacion/selectbynifsalida` |  |  |
|   |  |  | POST `/publicacion/selectbynumexp` |  |  |
|   |  |  | POST `/publicacion/selectbynumreg` |  |  |
|   |  |  | POST `/procedimiento/subiradjunto` |  |  |
|   |  |  | POST `/procedimiento/obtenerhashdeadjunto` |  |  |
| 4 | **Consulta de Expedientes** | Buscar expedientes por tipo de documento, número de expediente o número de registro. | POST `/publicacion/selectbynif` | Resultados de búsqueda, detalle, aportación de documentos. | Reutiliza los mismos servicios que Mis Gestiones. No requiere endpoints adicionales. |
|   |  |  | POST `/publicacion/selectbynumexp` |  |  |
|   |  |  | POST `/publicacion/selectbynumreg` |  |  |
|   |  |  | POST `/procedimiento/subiradjunto` |  |  |
| 5 | **Notificaciones** | Consultar notificaciones del ciudadano con distintos estados (pendientes, aceptadas, expiradas) y acceder a documentos asociados. | POST `/servicio/midetalle` | Listado de notificaciones, documentos descargables. | El endpoint asignado requiere confirmación (ver N5). No se contemplan notificaciones push; la consulta es siempre iniciada por el usuario. |
|   |  |  | POST `/publicacion/midocfirmados` |  |  |
| 6 | **Mi Carnet Digital** | Visualizar, descargar y añadir al móvil los carnets digitales del ciudadano (Familia Numerosa, Discapacidad, Carnet Joven). | GET `/carnet-digital/familia-numerosa/{dni}` | Datos de cada carnet, código QR, archivos PDF y PKPass para wallet móvil. | Los endpoints de PDF, PKPass y grado de discapacidad devuelven formato `string` (previsiblemente contenido codificado en base64). A validar durante integración (ver N4). |
|   |  |  | GET `/carnet-digital/familia-numerosa-pkpass/{dni}` |  |  |
|   |  |  | GET `/carnet-digital/discapacidad-pkpass/{dni}` |  |  |
|   |  |  | GET `/carnet-digital/grado-discapacidad/{dni}` |  |  |
|   |  |  | GET `/carnet-digital/joven/{dni}` |  |  |
|   |  |  | POST `/carnet-digital/qr/{dni}` |  |  |
|   |  |  | POST `/carnet-digital/pdf/{dni}` |  |  |
|   |  |  | POST `/carnet-digital/pkpass/{dni}` |  |  |
| 7 | **Mis Recomendaciones** | Presentar trámites recomendados al ciudadano en función de sus hechos vitales, con filtros por urgencia, novedad y plazo. | GET `/hechos-vitales/servicios/{idAgente}` | Lista de trámites agrupados por hecho vital, fechas de presentación, unidad responsable. | Requiere que el ciudadano haya configurado previamente sus hechos vitales (pantalla 8). Depende del parámetro `idAgente` (ver N6). |
|   |  |  | GET `/hechos-vitales/servicios/segmentacion/{idAgente}` |  |  |
| 8 | **Mis Hechos Vitales** | Seleccionar situaciones vitales del ciudadano (p. ej., "Tener un hijo", "Cambiar de trabajo") y aceptar cláusulas de privacidad para personalizar recomendaciones. | GET `/hechos-vitales/hechos/{idAgente}` | Lista de hechos vitales con selección, cláusulas, preferencias. | Incluye operaciones de escritura (guardar selección, guardar cláusulas, borrar preferencias). Los endpoints de lectura y escritura están correctamente documentados. |
|   |  |  | PATCH `/hechos-vitales/hechos` |  |  |
|   |  |  | GET `/hechos-vitales/clausulas/{idAgente}` |  |  |
|   |  |  | PATCH `/hechos-vitales/clausulas` |  |  |
|   |  |  | GET `/hechos-vitales/preferencias/{idAgente}` |  |  |
|   |  |  | DELETE `/hechos-vitales/preferencias/{idAgente}` |  |  |
| 9 | **Firma Digital** | Listar documentos pendientes de firma, validar certificados electrónicos y consultar documentos ya firmados. | POST `/afirma/milistardocumentosreq` | Lista de tipos de documento, resultado de validación de firma, documentos firmados. | El proceso de firma se completa fuera de la aplicación (redirección a navegador web). La aplicación gestiona la solicitud y recepción del resultado. Requiere datos del token de sesión de Cl@ve. |
|   |  |  | POST `/afirma/mivecreq` |  |  |
|   |  |  | POST `/publicacion/midocfirmados` |  |  |
| 10 | **Condiciones de Uso** | Mostrar las condiciones de uso y autorizaciones del servicio. | Ninguno (contenido estático). | Texto legal empaquetado en la aplicación. | Sin dependencia de backend. |
| 11 | **Guía de Ayuda** | Ofrecer contenido de ayuda con búsqueda local, filtros por categoría y enlaces a recursos externos. | Ninguno (contenido estático). | Contenido de ayuda, enlaces a vídeos y recursos web. | Sin dependencia de backend. Búsqueda y filtrado se ejecutan localmente en la aplicación. |

### 3.2 Resumen de cobertura pero como un párrafo cada uno y también los supuestos cada uno con como un párrafo no hace falta que pongas identificadores para cada supuesto aclaración.

| Indicador | Valor |
|-----------|-------|
| Pantallas totales | 10 (+ 1 flujo transversal de Firma Digital) |
| Pantallas con cobertura completa | 9 de 10 (90 %) |
| Pantalla con cobertura parcial | 1 — Notificaciones (endpoint por confirmar) |
| Operaciones de la API utilizadas | 40-41 de 47 (85-87 %) |
| Operaciones sin asignación a pantalla | 5-6 (posibles flujos de tramitación, ver N2) |
| Pantallas sin dependencia de API | 2 (Condiciones de Uso, Guía de Ayuda) |

---

## 4. Riesgos y Dependencias

| # | Riesgo / Dependencia | Probabilidad | Impacto | Mitigación propuesta |
|---|---------------------|-------------|---------|---------------------|
| R1 | Estructura real de las respuestas `string` (apartado 2.2, Respuestas no Estructuradas) desconocida hasta pruebas con entorno real. | Alta | Medio | Solicitar acceso a entorno de preproducción en las primeras semanas del proyecto. Planificar una fase de descubrimiento de datos. |
| R2 | Endpoint de Notificaciones no confirmado (apartado 2.2, Endpoint de Notificaciones). | Media | Medio | Validar con el equipo de backend antes de Sprint 1. Si no existe, replantear alcance de la pantalla. |
| R3 | Valor y obtención de `idAgente` no formalizados (apartado 2.2, Parámetro idAgente). | Media | Medio | Confirmar con el equipo de backend. Bloquea parcialmente los servicios de Hechos Vitales y Recomendaciones. |
| R4 | Disponibilidad y estabilidad del entorno de preproducción para pruebas de integración. | Media | Alto | Acordar con el cliente ventanas de acceso y protocolo de escalado de incidencias. |
| R5 | Servicios del Dashboard sin API (apartado 2.2, Dashboard — Servicios Adicionales): posible expectativa del usuario no satisfecha. | Baja | Bajo | Comunicar al usuario de forma clara qué servicios están disponibles y cuáles no. Diseñar la interfaz para absorber futuros servicios sin rediseño. |
| R6 | Flujo de tramitación de procedimientos (apartado 2.2, Flujo de Tramitación de Procedimientos) fuera o dentro del alcance sin confirmar. | Media | Medio | Solicitar confirmación formal del alcance. Si entra, implica estimación adicional. |

---

## 5. Siguientes Pasos

1. **Validación de este documento con el cliente.** Confirmar que el mapeo refleja correctamente las expectativas funcionales y el alcance acordado.
2. **Confirmación de puntos abiertos (sección 2.2).** Prioridad sobre: Respuestas no Estructuradas (S4/N4), Endpoint de Notificaciones (N5) y Parámetro idAgente (S2/N6), por su impacto en las primeras fases de desarrollo.
3. **Acceso a entorno de preproducción.** Para validar el comportamiento real de los servicios, especialmente los que devuelven datos no tipados.
4. **Definición del alcance del flujo de tramitación.** Confirmar si las operaciones de inicio, confirmación y resultado de procedimientos forman parte de esta fase del proyecto (sección 2.2, Flujo de Tramitación de Procedimientos).
5. **Inicio del desarrollo** conforme al mapeo validado, con tratamiento de los puntos pendientes como iteraciones de descubrimiento durante la ejecución.

---

*Documento emitido por [Nombre del responsable], [Cargo], [Empresa].*  
*Para cualquier aclaración sobre el contenido de este documento, contactar con [email de contacto].*
