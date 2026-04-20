# Mapeo Detallado de Endpoints — Carpeta Ciudadana CLM

**Proyecto:** Aplicación Móvil Carpeta Ciudadana — Junta de Comunidades de Castilla-La Mancha  
**API de referencia:** Fachada Sede API v1.41.0  
**Fecha:** 17 de febrero de 2026  
**Clasificación:** Documento de trabajo — Uso interno del proyecto

---

## Mapa Detallado de Endpoints por Pantalla

| # | Pantalla | Endpoint | Método | Objetivo Funcional | Datos Clave | Observaciones |
|---|----------|----------|--------|-------------------|-------------|---------------|
| **1** | **Dashboard / Inicio** | | | | | |
| 1.1 | Dashboard | `POST /educacion/titulos-universitarios/{numDocumento}` | POST | Obtener títulos universitarios del ciudadano | Listado de títulos académicos universitarios | Servicio federado, requiere JWT Cl@ve |
| 1.2 | Dashboard | `POST /educacion/titulos-no-universitarios/{numDocumento}` | POST | Obtener títulos no universitarios del ciudadano | Listado de títulos académicos no universitarios | Servicio federado, requiere JWT Cl@ve |
| 1.3 | Dashboard | `GET /sescam/citas/{numDocumento}` | GET | Consultar próximas citas sanitarias | Citas futuras con fecha, hora, centro | Respuesta tipo `string`, estructura a validar |
| 1.4 | Dashboard | `POST /ccaa/familia-numerosa/{numDocumento}` | POST | Obtener datos de familia numerosa | Categoría, número de hijos, vigencia | Servicio federado, requiere JWT Cl@ve |
| 1.5 | Dashboard | `POST /intermediacion/discapacidad/datos` | POST | Consultar datos de discapacidad | Grado de discapacidad, tipo, vigencia | Servicio federado, requiere JWT Cl@ve |
| 1.6 | Dashboard | `POST /sepe/demandante-empleo-fecha-actual/{numDocumento}` | POST | Consultar situación laboral actual en SEPE | Demandante de empleo (sí/no), fecha inscripción | Servicio federado, requiere JWT Cl@ve |
| 1.7 | Dashboard | `POST /ine/datos-residencia/{numDocumento}` | POST | Obtener datos de residencia del INE | Municipio, provincia, fecha empadronamiento | Servicio federado, requiere JWT Cl@ve |
| 1.8 | Dashboard | `POST /catastro/datos-catastrales/{numDocumento}` | POST | Consultar datos catastrales (propiedades) | Listado de inmuebles, referencia catastral | Servicio federado, retorna modelo genérico `Respuesta` |
| 1.9 | Dashboard | `POST /dgt/lista-vehiculos/{numDocumento}` | POST | Obtener vehículos registrados a nombre del ciudadano | Listado de vehículos (matrícula, marca, modelo) | Servicio federado, requiere JWT Cl@ve |
| | | | | | | **5 bloques sin API:** Termalismo, Tarjeta Estacionamiento, Atención Dependencia, Inscripciones Empleo |
| **2** | **Mi Agenda** | | | | | |
| 2.1 | Mi Agenda | `GET /sescam/citas/{numDocumento}` | GET | Consultar citas sanitarias futuras | Citas con fecha, hora, centro, especialidad | Respuesta tipo `string`, estructura a validar |
| 2.2 | Mi Agenda | `GET /sescam/citas-pasadas/{numDocumento}` | GET | Consultar citas sanitarias pasadas | Histórico de citas con detalles | Respuesta tipo `string`, estructura a validar |
| 2.3 | Mi Agenda | `GET /sescam/cip/{numDocumento}` | GET | Obtener tarjeta sanitaria (CIP) | Código de Identificación Personal sanitario | Respuesta tipo `string`, estructura a validar |
| **3** | **Mis Gestiones / Expedientes** | | | | | |
| 3.1 | Mis Gestiones | `POST /publicacion/selectbynif` | POST | Listar expedientes propios del ciudadano por NIF | Listado de expedientes con estado, fecha, órgano | Filtrado por tipo documento (DNI/Pasaporte) |
| 3.2 | Mis Gestiones | `POST /publicacion/selectbynifentrada` | POST | Listar expedientes de entradas de registro | Registros de entrada con número, fecha, asunto | Filtrado por tipo documento |
| 3.3 | Mis Gestiones | `POST /publicacion/selectbynifsalida` | POST | Listar expedientes de salidas de registro | Registros de salida con número, fecha, destinatario | Filtrado por tipo documento |
| 3.4 | Mis Gestiones | `POST /publicacion/selectbynumexp` | POST | Consultar detalle de expediente por número | Detalle completo del expediente, documentos | Búsqueda directa por número |
| 3.5 | Mis Gestiones | `POST /publicacion/selectbynumreg` | POST | Consultar detalle de registro por número | Detalle completo del registro, documentos | Búsqueda directa por número |
| 3.6 | Mis Gestiones | `POST /procedimiento/subiradjunto` | POST | Subir documentación adjunta a expediente | Confirmación de carga, referencia fichero | Max 5 ficheros, 50MB c/u. Formatos: PDF, DOC, DOCX, ZIP, XLS, XLSX |
| 3.7 | Mis Gestiones | `POST /procedimiento/obtenerhashdeadjunto` | POST | Generar hash de validación antes de subir fichero | Hash MD5/SHA para verificación integridad | Se ejecuta antes de cada carga |
| **4** | **Consulta de Expedientes** | | | | | |
| 4.1 | Consulta Expedientes | `POST /publicacion/selectbynif` | POST | Buscar expedientes por identificación del interesado | Resultados de búsqueda por NIF/Pasaporte | Reutiliza endpoint de Mis Gestiones |
| 4.2 | Consulta Expedientes | `POST /publicacion/selectbynumexp` | POST | Buscar expediente por número de expediente | Detalle del expediente encontrado | Reutiliza endpoint de Mis Gestiones |
| 4.3 | Consulta Expedientes | `POST /publicacion/selectbynumreg` | POST | Buscar registro por número de registro | Detalle del registro encontrado | Reutiliza endpoint de Mis Gestiones |
| 4.4 | Consulta Expedientes | `POST /procedimiento/subiradjunto` | POST | Aportar documentos al expediente consultado | Confirmación de aportación | Reutiliza endpoint de Mis Gestiones |
| **5** | **Notificaciones** | | | | | |
| 5.1 | Notificaciones | `POST /servicio/midetalle` | POST | Listar notificaciones del ciudadano (pendientes, aceptadas, expiradas) | Listado de notificaciones con estado, fecha, asunto | **Endpoint por confirmar con backend** |
| 5.2 | Notificaciones | `POST /publicacion/midocfirmados` | POST | Consultar documentos firmados (notificaciones asociadas) | Documentos descargables relacionados con notificaciones | Reutilizado también en Firma Digital |
| **6** | **Mi Carnet Digital** | | | | | |
| 6.1 | Mi Carnet Digital | `GET /carnet-digital/familia-numerosa/{dni}` | GET | Visualizar datos del carnet de familia numerosa | Categoría, número de hijos, vigencia, miniatura | Miniatura con icono y grafismo |
| 6.2 | Mi Carnet Digital | `GET /carnet-digital/familia-numerosa-pkpass/{dni}` | GET | Descargar PKPass de familia numerosa para Wallet | Archivo PKPass (Apple/Google Wallet) | Respuesta tipo `string`, posiblemente base64 |
| 6.3 | Mi Carnet Digital | `GET /carnet-digital/discapacidad-pkpass/{dni}` | GET | Descargar PKPass de discapacidad para Wallet | Archivo PKPass (Apple/Google Wallet) | Respuesta tipo `string`, posiblemente base64 |
| 6.4 | Mi Carnet Digital | `GET /carnet-digital/grado-discapacidad/{dni}` | GET | Obtener grado de discapacidad | Porcentaje/grado de discapacidad | Respuesta tipo `string`, estructura a validar |
| 6.5 | Mi Carnet Digital | `GET /carnet-digital/joven/{dni}` | GET | Visualizar datos del carnet joven | Datos del carnet, vigencia, miniatura | Miniatura con icono y grafismo |
| 6.6 | Mi Carnet Digital | `POST /carnet-digital/qr/{dni}` | POST | Generar código QR del carnet | Datos codificados en QR para validación | QR genérico para carnets |
| 6.7 | Mi Carnet Digital | `POST /carnet-digital/pdf/{dni}` | POST | Descargar carnets en formato PDF | Archivo PDF con carnets digitales | Respuesta tipo `string`, base64 |
| 6.8 | Mi Carnet Digital | `POST /carnet-digital/pkpass/{dni}` | POST | Descargar carnets en formato PKPass | Archivo PKPass genérico | Respuesta tipo `string`, base64 |
| **7** | **Mis Recomendaciones** | | | | | |
| 7.1 | Mis Recomendaciones | `GET /hechos-vitales/servicios/{idAgente}` | GET | Obtener trámites recomendados según hechos vitales seleccionados | Lista de trámites agrupados por hecho vital con fechas y unidad responsable | Requiere parámetro `idAgente` del JWT Cl@ve |
| 7.2 | Mis Recomendaciones | `GET /hechos-vitales/servicios/segmentacion/{idAgente}` | GET | Filtrar trámites por urgencia, novedad o plazo | Trámites segmentados (últimos días, novedades, inmediatos) | Parámetro `operacion`: ultimos_dias, novedades, inmediatos |
| **8** | **Mis Hechos Vitales** | | | | | |
| 8.1 | Mis Hechos Vitales | `GET /hechos-vitales/hechos/{idAgente}` | GET | Listar hechos vitales del agente (previamente seleccionados) | Hechos vitales con selección actual | Requiere parámetro `idAgente` del JWT Cl@ve |
| 8.2 | Mis Hechos Vitales | `PATCH /hechos-vitales/hechos` | PATCH | Guardar selección de hechos vitales del ciudadano | Confirmación de guardado | Request: `ListaHechosAgente` con array de selecciones |
| 8.3 | Mis Hechos Vitales | `GET /hechos-vitales/clausulas/{idAgente}` | GET | Obtener cláusulas de privacidad del agente | Cláusulas con estado de aceptación | Requiere parámetro `idAgente` del JWT Cl@ve |
| 8.4 | Mis Hechos Vitales | `PATCH /hechos-vitales/clausulas` | PATCH | Guardar aceptación de cláusulas de privacidad | Confirmación de aceptación | Request: `ClausulasAgente` con array de aceptaciones |
| 8.5 | Mis Hechos Vitales | `GET /hechos-vitales/preferencias/{idAgente}` | GET | Consultar preferencias de notificación del agente | Configuración de preferencias | Requiere parámetro `idAgente` del JWT Cl@ve |
| 8.6 | Mis Hechos Vitales | `DELETE /hechos-vitales/preferencias/{idAgente}` | DELETE | Resetear/borrar todas las preferencias del agente | Confirmación de borrado | Vuelve a estado inicial, sin selecciones |
| **9** | **Firma Digital** | | | | | |
| 9.1 | Firma Digital | `POST /afirma/milistardocumentosreq` | POST | Listar documentos pendientes de firma digital | Lista de tipos de documento con estado | Requiere parámetros del JWT Cl@ve |
| 9.2 | Firma Digital | `POST /afirma/mivecreq` | POST | Validar certificado electrónico (VEC) para firma | Resultado de validación del certificado | Requiere parámetros del JWT Cl@ve |
| 9.3 | Firma Digital | `POST /publicacion/midocfirmados` | POST | Consultar documentos ya firmados por el ciudadano | Lista de documentos firmados con fecha y estado | Reutilizado también en Notificaciones |
| **10** | **Condiciones de Uso** | | | | | |
| 10.1 | Condiciones de Uso | Ninguno (contenido estático) | - | Mostrar condiciones de uso y autorizaciones del servicio | Texto legal, políticas de privacidad | Sin dependencia de backend, contenido empaquetado |
| **11** | **Guía de Ayuda** | | | | | |
| 11.1 | Guía de Ayuda | Ninguno (contenido estático) | - | Ofrecer contenido de ayuda con búsqueda y filtros locales | Temas de ayuda, vídeos, enlaces externos | Sin dependencia de backend, búsqueda local en cliente |

---

## Riesgos y Dependencias

| # | Riesgo / Dependencia | Probabilidad | Impacto | Mitigación propuesta |
|---|---------------------|-------------|---------|---------------------|
| R1 | Estructura real de las respuestas `string` desconocida hasta pruebas con entorno real (9 operaciones: SESCAM, carnets digitales). | Alta | Medio | Solicitar acceso a entorno de preproducción en las primeras semanas del proyecto. Planificar una fase de descubrimiento de datos. |
| R2 | Endpoint de Notificaciones (`POST /servicio/midetalle`) no confirmado. | Media | Medio | Validar con el equipo de backend antes de Sprint 1. Si no existe, replantear alcance de la pantalla. |
| R3 | Valor y obtención de `idAgente` no formalizados (utilizado en Hechos Vitales y Recomendaciones). | Media | Medio | Confirmar con el equipo de backend el mecanismo exacto de obtención del JWT Cl@ve. Bloquea parcialmente servicios de Hechos Vitales y Recomendaciones. |
| R4 | Disponibilidad y estabilidad del entorno de preproducción para pruebas de integración. | Media | Alto | Acordar con el cliente ventanas de acceso y protocolo de escalado de incidencias. |
| R5 | Servicios del Dashboard sin API (Termalismo, Tarjeta Estacionamiento, Atención Dependencia, Inscripciones Empleo): posible expectativa del usuario no satisfecha. | Baja | Bajo | Comunicar al usuario de forma clara qué servicios están disponibles y cuáles no. Diseñar la interfaz para absorber futuros servicios sin rediseño. |
| R6 | Flujo de tramitación de procedimientos (`inicproc`, `miconfirmarproc`, `miobtenerres`) sin pantalla asignada: alcance sin confirmar. | Media | Medio | Solicitar confirmación formal del alcance. Si entra, implica estimación adicional. |
| R7 | Servicios federados (9 endpoints POST) utilizan patrón POST para consultas debido a sistemas legacy (SAP). | Baja | Bajo | Patrón identificado y documentado. No supone impedimento funcional, solo consideración arquitectónica. |
| R8 | Inconsistencias en documentación de la API (descripciones erróneas, modelos vacíos, endpoints sin descripción). | Baja | Bajo | Validar comportamiento real de los endpoints en entorno de preproducción. Documentar discrepancias encontradas. |
| R9 | Gestión del ciclo de vida de sesión Cl@ve (expiración, renovación) no formalizada. | Media | Alto | Definir durante el desarrollo la estrategia de renovación automática o manual del token. Establecer manejo de errores 401/403. |
| R10 | Restricciones de subida de ficheros (5 archivos máx, 50MB c/u, formatos específicos) pueden resultar insuficientes. | Baja | Bajo | Validar con cliente y usuarios si las restricciones son adecuadas. Comunicar claramente al usuario los límites antes de la subida. |

---

**Total de endpoints mapeados:** 41  
**Endpoints con dependencia JWT Cl@ve:** 18  
**Endpoints con respuesta `string` no estructurada:** 9  
**Pantallas sin dependencia de backend:** 2 (Condiciones de Uso, Guía de Ayuda)

---

*Documento generado el 17 de febrero de 2026.*  
*Para cualquier aclaración sobre el contenido de este documento, contactar con el equipo de proyecto.*
