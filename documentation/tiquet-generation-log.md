● Backlog completo materializado en tickets/: 70 tickets reales — 10 épicas, 48 stories y
  12 tasks. La salida canónica ya está creada y cubre foundations, flujos funcionales,
  inferencias de UI desde capturas, gaps de contrato, QA y release.

  Árbol del backlog resultante

   - [EPIC-1] Foundations, app shell y arquitectura base
    - [STORY-11] Bootstrap del repositorio y entrypoints por entorno
    - [STORY-12] Red, almacenamiento seguro y estrategia de errores compartida
    - [STORY-13] Shell global, routing, guards y deep links
    - [STORY-14] Design system, theming, localización y accesibilidad base
    - [STORY-15] Estados compartidos de UI, paginación, refresh y acciones documentales
    - [TASK-16] Validar estrategia de adaptación del cliente OpenAPI y gaps de contrato 
  base
   - [EPIC-2] Identidad, sesión y consentimiento del ciudadano
    - [STORY-17] Landing anónima y flujo informativo previo al acceso
    - [STORY-18] Login Cl@ve, callback seguro y ciclo de vida de sesión
    - [STORY-19] Aceptación inicial de condiciones de uso y protección de datos
    - [STORY-20] Estado de usuario logado, menú personal y mantenimiento bloqueante
    - [TASK-21] Validar claims JWT, idAgente y parámetros federados obligatorios
   - [EPIC-3] Portada, dashboard y dominios informativos del ciudadano
    - [STORY-22] Portada logada con resumen ciudadano y accesos rápidos
    - [STORY-23] Dominio Educación con landing, títulos y enlaces de interés
    - [STORY-24] Dominio Empleo con estado de demandante e inscripciones en ofertas
    - [STORY-25] Dominio Bienestar social con familia numerosa y servicios sociales 
  vinculados
    - [STORY-26] Dominio Estado y otros temas de interés con domicilio, inmuebles y 
  vehículos
    - [STORY-28] Enlaces externos y navegación saliente de dominios temáticos
    - [TASK-27] Validar contratos ausentes o ambiguos de bloques visibles en dashboard
   - [EPIC-4] Agenda y servicios de salud del ciudadano
    - [STORY-29] Agenda con listado de eventos, calendario y filtros temporales
    - [STORY-30] Detalle de cita, justificantes y estados de agenda
    - [STORY-31] CIP y superficies de salud reutilizadas entre home y agenda
    - [TASK-32] Validar formato real de payloads SESCAM y estrategia de parsing
   - [EPIC-5] Gestiones, expedientes y aportación documental
    - [STORY-34] Workspace de Mis gestiones con tabs de expedientes, entradas y salidas
    - [STORY-35] Detalle de expediente con metadata y ficheros asociados
    - [STORY-36] Detalle de entradas y salidas de registro
    - [STORY-37] Flujo dedicado de aportación de documentos por terceros
    - [STORY-38] Subida de adjuntos con hash, validaciones y descarga de justificante
    - [STORY-39] Consulta de expedientes por identificación, número de expediente o 
  registro
    - [TASK-40] Validar flujo completo de procedimientos y evidencias de registro
   - [EPIC-6] Notificaciones administrativas y firma digital
    - [STORY-41] Centro de notificaciones con filtros por estado y paginación
    - [STORY-42] Alta de datos de contacto para plataforma de notificación electrónica
    - [STORY-43] Notificación pendiente con aceptación, rechazo y confirmación de rechazo
    - [STORY-44] Detalle de notificación aceptada, rechazada o caducada con documentos
    - [STORY-45] Listado de documentos a firmar, validación de certificado e histórico 
  firmado
    - [STORY-46] Salto a navegador, firma en Afirma y retorno seguro a la app
    - [TASK-47] Confirmar contrato real de notificaciones y asociación de documentos
   - [EPIC-7] Carnets digitales, wallet y documentos acreditativos
    - [STORY-48] Catálogo de carnets digitales con disponibilidad y estados bloqueados
    - [STORY-49] Carnet digital de familia numerosa y sus exportaciones
    - [STORY-50] Carnet Joven con modal de detalle y formatos móviles
    - [STORY-51] Discapacidad, grado y manejo de carnet no vigente
    - [STORY-52] Gestión transversal de QR, PDF, PKPass y wallet móvil
    - [TASK-53] Validar respuestas binarias o string de carnets y reglas de wallet
   - [EPIC-8] Hechos vitales, autorizaciones y recomendaciones personalizadas
    - [STORY-54] Selección y guardado de hechos vitales del ciudadano
    - [STORY-55] Autorizaciones de uso de datos y revocación desde preferencias
    - [STORY-56] Recomendaciones personalizadas con filtros y agrupación por hecho vital
    - [STORY-57] Onboarding y estado vacío de recomendaciones cuando faltan permisos o 
  hechos vitales
    - [TASK-58] Confirmar reglas de segmentación y contrato semántico de recomendaciones
   - [EPIC-9] Ayuda, soporte y contenidos legales de la aplicación
    - [STORY-59] Centro de ayuda con FAQ, guías y contacto informativo
    - [STORY-60] Formulario de soporte técnico con adjuntos, consentimiento y captcha
    - [STORY-61] Páginas legales y estáticas de uso, privacidad, accesibilidad y aviso 
  legal
    - [STORY-62] Mapa web y navegación global de footer
    - [TASK-63] Definir integración operativa del soporte técnico y escalado de 
  incidencias
   - [EPIC-10] Calidad transversal, seguridad, observabilidad y release readiness
    - [STORY-64] Observabilidad, analytics y logging con redacción de PII
    - [STORY-65] Caché, offline, conectividad, retry y resiliencia de datos
    - [STORY-66] Pirámide de testing, contract tests y validación del cliente generado
    - [STORY-67] QA funcional, accesibilidad y regresión visual antes de entrega
    - [STORY-68] CI/CD, verificación de codegen, entornos y checklist de release
    - [TASK-69] Inventario PII, hardening de seguridad y ADRs de excepción al canon
    - [TASK-70] Validar budgets de performance y manejo de listas, documentos y startup
   - Discovery transversal adicional
    - [TASK-71] Aclarar superficies adicionales de carnets mostradas en portada

  Matriz de cobertura fuente -> tickets

  ┌──────────────────────────────────────────────────────┬──────────────────────────────┐
  │ Fuente                                               │ Tickets cubiertos            │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ .github/copilot-instructions.md                      │ [EPIC-1], [STORY-11],        │
  │                                                      │ [TASK-69]                    │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ documentation/architecture_canon_flutter_v2_docs/*   │ [EPIC-1], [EPIC-10],         │
  │                                                      │ [STORY-11]–[STORY-14],       │
  │                                                      │ [STORY-18], [STORY-28],      │
  │                                                      │ [STORY-64]–[STORY-68],       │
  │                                                      │ [TASK-69], [TASK-70]         │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ DOCUMENTO_COMPRENSION_FUNCIONAL.md                   │ [EPIC-2]–[EPIC-9],           │
  │                                                      │ [STORY-17]–[STORY-19],       │
  │                                                      │ [STORY-24], [STORY-25],      │
  │                                                      │ [STORY-30], [STORY-35],      │
  │                                                      │ [STORY-37], [STORY-39],      │
  │                                                      │ [STORY-41]–[STORY-46],       │
  │                                                      │ [STORY-48], [STORY-51],      │
  │                                                      │ [STORY-57], [STORY-59],      │
  │                                                      │ [STORY-61],                  │
  │                                                      │ [STORY-64]–[STORY-66],       │
  │                                                      │ [TASK-16], [TASK-21],        │
  │                                                      │ [TASK-27], [TASK-32],        │
  │                                                      │ [TASK-40], [TASK-47],        │
  │                                                      │ [TASK-53], [TASK-58],        │
  │                                                      │ [TASK-63], [TASK-69],        │
  │                                                      │ [TASK-71]                    │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ MAPEO_ENDPOINTS_PANTALLAS.md                         │ [EPIC-3]–[EPIC-8],           │
  │                                                      │ [TASK-21], [TASK-27]         │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ MAPEO_DETALLADO_ENDPOINTS.md                         │ [EPIC-3]–[EPIC-8],           │
  │                                                      │ [STORY-36], [STORY-41],      │
  │                                                      │ [TASK-32], [TASK-40],        │
  │                                                      │ [TASK-47], [TASK-53],        │
  │                                                      │ [TASK-58]                    │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ PLANIFICACION_PROYECTO.md                            │ [EPIC-1], [EPIC-10],         │
  │                                                      │ [STORY-11], [STORY-18],      │
  │                                                      │ [STORY-46],                  │
  │                                                      │ [STORY-66]–[STORY-68],       │
  │                                                      │ [TASK-70]                    │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ RESUMEN_FUNCIONALIDADES_PPT.md                       │ [EPIC-2]–[EPIC-10],          │
  │                                                      │ [STORY-15], [STORY-17],      │
  │                                                      │ [STORY-18], [STORY-22],      │
  │                                                      │ [STORY-23], [STORY-29],      │
  │                                                      │ [STORY-34], [STORY-39],      │
  │                                                      │ [STORY-42], [STORY-45],      │
  │                                                      │ [STORY-46], [STORY-48],      │
  │                                                      │ [STORY-52], [STORY-54],      │
  │                                                      │ [STORY-56], [STORY-57],      │
  │                                                      │ [STORY-59]–[STORY-61],       │
  │                                                      │ [STORY-64], [STORY-65],      │
  │                                                      │ [TASK-21], [TASK-63],        │
  │                                                      │ [TASK-70], [TASK-71]         │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ generated/dart_dio_client/*                          │ [TASK-16], [TASK-32],        │
  │                                                      │ [TASK-40], [TASK-47],        │
  │                                                      │ [TASK-53], [TASK-58]         │
  ├──────────────────────────────────────────────────────┼──────────────────────────────┤
  │ documentation/image_references/*                     │ [EPIC-2]–[EPIC-9],           │
  │                                                      │ [STORY-13]–[STORY-15],       │
  │                                                      │ [STORY-17], [STORY-19],      │
  │                                                      │ [STORY-20],                  │
  │                                                      │ [STORY-22]–[STORY-31],       │
  │                                                      │ [STORY-34]–[STORY-38],       │
  │                                                      │ [STORY-41]–[STORY-62],       │
  │                                                      │ [STORY-67], [TASK-27],       │
  │                                                      │ [TASK-63], [TASK-71]         │
  └──────────────────────────────────────────────────────┴──────────────────────────────┘

  Gaps detectados y tickets creados para resolverlos

   - JWT / idAgente / claims federados no formalizados → [TASK-21]
   - Payloads string de SESCAM sin estructura confirmada → [TASK-32]
   - Contratos dudosos o ausentes en dashboard (becado, termalismo, tarjeta de 
  estacionamiento, dependencia, inscripciones, mi salud digital) → [TASK-27]
   - Flujo completo de procedimientos y registro no cerrado → [TASK-40]
   - Endpoint real de notificaciones y asociación documental sin confirmar → [TASK-47]
   - Respuestas binarias/base64 y reglas wallet de carnets sin validar → [TASK-53]
   - Semántica real de segmentación de recomendaciones → [TASK-58]
   - Backend/captcha/circuito operativo del soporte técnico → [TASK-63]
   - Superficies extra de carnets en portada (Tarjeta Sanitaria / Tarjeta Biblioteca) → 
  [TASK-71]

  Inferencias funcionales hechas a partir de imágenes

   - Estado de mantenimiento/bloqueo en home autenticada → [STORY-20]
   - Menú lateral, footer global y mapa web con IA explícita → [STORY-13], [STORY-62]
   - Flujo de alta de contacto para notificaciones electrónicas → [STORY-42]
   - Confirmación de rechazo de notificación pendiente → [STORY-43]
   - Wizard completo de aportación por terceros con búsqueda previa, hash y justificante 
  → [STORY-37], [STORY-38]
   - Módulos visibles de inscripciones en ofertas, tarjeta de estacionamiento y atención 
  a la dependencia pese a huecos de API → [STORY-24], [STORY-25], [TASK-27]
   - Estado vacío/onboarding de recomendaciones y CTA a preferencias → [STORY-57]
   - Formulario de soporte técnico con adjuntos, consentimiento, captcha y acuse por 
  email → [STORY-60], [TASK-63]
   - Estados de carnet no vigente / no descargable → [STORY-48], [STORY-51]
   - Superficies adicionales de Tarjeta Sanitaria y Tarjeta Biblioteca en portada → 
  [TASK-71]

  Cierre

  No queda alcance conocido sin ticket o sin ticket de descubrimiento.
  La jerarquía real está creada en tickets/, no hay tickets huérfanos, no hay subtareas
  embebidas en padres, y cada pieza funcional o ambigua detectada en documentación o
  capturas quedó cubierta con ticket ejecutable o con ticket explícito de validación.
