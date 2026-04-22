# Transformación del roadmap para Gesproy

## 1. Propósito

Este documento transforma el roadmap original de 10 sprints definido en [documentation/backlog_review_roadmap.md](backlog_review_roadmap.md) en una vista operativa de 20 sprints oficiales para Gesproy. Cada sprint del roadmap original se desdobla en dos sprints simultáneos de squad —uno para Squad 2 (entrega funcional) y otro para Squad 3 (habilitadores técnicos, gobierno y release readiness)— preservando íntegramente la lógica de ejecución, las dependencias y las puertas de descubrimiento ya descritas en el backlog. No se redefine alcance ni se inventa trabajo nuevo: se reorganiza la planificación para reflejar la realidad operativa de los dos equipos paralelos y para ofrecer una traza directamente utilizable en seguimiento y facturación dentro de Gesproy.

## 2. Criterios de transformación

- El roadmap fuente describe 10 sprints reales de calendario (Sprint 1 a Sprint 10).
- Cada sprint original se transforma en dos sprints oficiales simultáneos de squad: `SP-EC-APP-SQ2-XX` y `SP-EC-APP-SQ3-XX`.
- El reparto entre squads no es mecánico: se asigna cada ticket al squad cuya naturaleza operativa lo posee de forma realista (entrega funcional vs. habilitador técnico, gobierno y calidad).
- Se preservan exactamente las dependencias, las puertas de descubrimiento (`TASK-16`, `TASK-21`, `TASK-27`, `TASK-32`, `TASK-40`, `TASK-47`, `TASK-53`, `TASK-58`, `TASK-63`, `TASK-71`) y la postura de hardening tardío descritas en el backlog.
- Dentro de esas restricciones, se busca un equilibrio razonable de esfuerzo entre los dos sprints paralelos. Cuando no es posible un equilibrio simétrico sin romper la coherencia operativa, se prioriza realismo y se documenta la justificación en `Notas operativas`.
- Ningún ticket se duplica entre squads. Cuando un ítem requiere coordinación, se asigna ownership a un squad y se anota el punto de coordinación con el squad paralelo.
- Los sprints 8, 9 y 10 son sprints de cierre/estabilización: agrupan trabajo de publicación, UAT, regresión, hardening y reserva controlada, y se documentan como tal sin duplicar tickets ya cerrados.

## 3. Mapeo entre roadmap original y roadmap transformado

| Sprint original | Fechas | Sprint Squad 2 | Sprint Squad 3 | Descripción de la ola de ejecución |
| --- | --- | --- | --- | --- |
| Sprint 1 | 2026-04-21 → 2026-05-04 | SP-EC-APP-SQ2-01 | SP-EC-APP-SQ3-01 | Arranque del producto: shell visible, landing pública e identidad inicial / fundamentos técnicos, contrato API y línea base de seguridad y observabilidad. |
| Sprint 2 | 2026-05-05 → 2026-05-18 | SP-EC-APP-SQ2-02 | SP-EC-APP-SQ3-02 | Cierre de sesión y home logada, contenidos legales y ayuda / validación de claims y línea base de CI/CD. |
| Sprint 3 | 2026-05-19 → 2026-06-01 | SP-EC-APP-SQ2-03 | SP-EC-APP-SQ3-03 | Dominios informativos y agenda inicial / cierre de la puerta de contrato del dashboard. |
| Sprint 4 | 2026-06-02 → 2026-06-15 | SP-EC-APP-SQ2-04 | SP-EC-APP-SQ3-04 | Agenda/CIP, expedientes, catálogo de carnets, hechos vitales y soporte / validaciones SESCAM y de superficies adicionales de carnets. |
| Sprint 5 | 2026-06-16 → 2026-06-29 | SP-EC-APP-SQ2-05 | SP-EC-APP-SQ3-05 | Detalles de expedientes, aportación documental y notificaciones / validaciones de contrato de procedimientos, notificaciones y carnets. |
| Sprint 6 | 2026-06-30 → 2026-07-27 (4 semanas) | SP-EC-APP-SQ2-06 | SP-EC-APP-SQ3-06 | Cierre funcional de notificaciones, carnets y recomendaciones / firma con Afirma y validación semántica de recomendaciones. |
| Sprint 7 | 2026-07-28 → 2026-08-24 (4 semanas) | SP-EC-APP-SQ2-07 | SP-EC-APP-SQ3-07 | QA funcional, accesibilidad y regresión visual previas al handoff / definición de soporte, resiliencia, pirámide de pruebas y presupuestos de rendimiento. |
| Sprint 8 | 2026-08-25 → 2026-09-07 | SP-EC-APP-SQ2-08 | SP-EC-APP-SQ3-08 | Preparación de UAT y empaquetado de release / pipelines, hardening y verificación de presupuestos de rendimiento. |
| Sprint 9 | 2026-09-08 → 2026-09-21 | SP-EC-APP-SQ2-09 | SP-EC-APP-SQ3-09 | Cierre de defectos funcionales / endurecimiento de seguridad, rendimiento y resiliencia. |
| Sprint 10 | 2026-09-22 → 2026-10-05 | SP-EC-APP-SQ2-10 | SP-EC-APP-SQ3-10 | Seguimiento de publicación y verificación funcional final / checklist de release, ventana de hotfix y reserva de contingencia. |

## 4. Roadmap transformado detallado

### SP-EC-APP-SQ2-01

Sprint original: Sprint 1
Squad: Squad 2
Épica(s): EPIC-1 Foundations, EPIC-2 Identidad y sesión
Objetivo del sprint: Levantar la cara visible del producto desde el primer sprint: shell de navegación, sistema de diseño base, landing pública y los flujos iniciales de login y consentimiento, de forma que exista una experiencia navegable mínima sobre la que iterar.
Tareas / tickets asociados:

- `STORY-13` Shell global, router, guards y deep links — habilita toda la navegación anónima y logada y es la base sobre la que se conectan los flujos de identidad y los dominios funcionales.
- `STORY-14` Sistema de diseño, tema, l10n y accesibilidad base — sistema de diseño compartido que alimenta cada ticket de UI posterior.
- `STORY-17` Landing pública y arquitectura de información previa al acceso — primera superficie funcional accesible sin sesión.
- `STORY-18` Login Cl@ve, callback y ciclo de vida de sesión — flujo de identidad ciudadano, consumido por todas las épicas autenticadas.
- `STORY-19` Consentimiento legal inicial y aceptación de uso de datos — gating funcional posterior al primer login.

Notas operativas: La integración fina de `STORY-18` se cierra en coordinación con `TASK-21` (Squad 3), que valida claims JWT e `idAgente`. El squad construye el flujo de extremo a extremo y consume las decisiones de la puerta de validación a medida que se publican.

### SP-EC-APP-SQ3-01

Sprint original: Sprint 1
Squad: Squad 3
Épica(s): EPIC-1 Foundations, EPIC-10 Calidad y release readiness
Objetivo del sprint: Establecer los cimientos técnicos del proyecto: topología de repositorio y bootstrap por entorno, capa compartida de red y almacenamiento seguro, estrategia de adaptación de OpenAPI y línea base de observabilidad y seguridad. Sin estos elementos ningún flujo funcional posterior es sostenible.
Tareas / tickets asociados:

- `STORY-11` Topología de repositorio, bootstrap de la app y entrypoints por entorno — primer ticket del proyecto, condición previa de toda la cadena.
- `STORY-12` Capa compartida de networking, almacenamiento seguro y estrategia de errores — habilitador de cualquier trabajo apoyado en API y de `TASK-16`.
- `TASK-16` Puerta de adaptación OpenAPI y encapsulación DTO — decide la estrategia de cliente generado y desbloquea las puertas de contrato posteriores (`TASK-21`, `TASK-27`, `TASK-32`, `TASK-47`, `TASK-53`, `TASK-58`).
- `STORY-64` Observabilidad, analítica y logging con redacción de PII — superpuesta a todas las épicas funcionales desde el inicio.
- `TASK-69` Inventario de PII, hardening de seguridad y ADRs de excepción de arquitectura — abre el trabajo continuo de seguridad que se extiende hasta el sprint de hardening.

Notas operativas: Carga elevada y no comparable 1:1 con SP-EC-APP-SQ2-01, pero coherente con el rol de habilitador técnico del Squad 3 en el primer sprint. La puerta `TASK-16` debe quedar resuelta dentro de esta ola para no bloquear las olas siguientes.

### SP-EC-APP-SQ2-02

Sprint original: Sprint 2
Squad: Squad 2
Épica(s): EPIC-1, EPIC-2, EPIC-3, EPIC-9
Objetivo del sprint: Cerrar el bloque de sesión, exponer la home logada inicial y entregar los contenidos legales, de ayuda y de navegación estática que dan completitud a la experiencia post-login y soportan onboarding y compliance.
Tareas / tickets asociados:

- `STORY-15` Estados compartidos de carga, vacío, error, paginación y acciones documentales — primitivas de UX reutilizables por todos los dominios.
- `STORY-20` Estado de usuario logado, menú personal y bloqueo por mantenimiento — gate de acceso a la home logada.
- `STORY-22` Home logada con resumen ciudadano y accesos rápidos — primera superficie autenticada de valor.
- `STORY-59` Centro de ayuda con FAQ, guías y contacto informativo — habilitable temprano sobre el shell ya disponible.
- `STORY-61` Páginas legales y estáticas: términos, privacidad, accesibilidad, aviso — soportan onboarding, footer y cumplimiento.
- `STORY-62` Mapa del sitio y navegación global del footer — completa el shell y los contenidos estáticos.

Notas operativas: `STORY-22` se construye sin esperar al cierre de `TASK-71` (Squad 3, sprint 4): se aplica la versión base de la home y se reservan los puntos de extensión para cuando se confirmen las superficies adicionales de carnets.

### SP-EC-APP-SQ3-02

Sprint original: Sprint 2
Squad: Squad 3
Épica(s): EPIC-2 Identidad, EPIC-10 Release readiness
Objetivo del sprint: Cerrar la validación de claims de sesión que condicionan la integración final de identidad y dejar establecida la línea base de CI/CD que dará soporte a todas las olas de entrega siguientes.
Tareas / tickets asociados:

- `TASK-21` Validar claims JWT, `idAgente` y parámetros de federación — puerta de descubrimiento que cierra la integración de autenticación.
- `STORY-68` CI/CD, verificación de codegen, pipeline de entornos y checklist de release — empieza temprano y se cierra tarde; en este sprint se establece la línea base.

Notas operativas: Reparto de carga aparentemente menor en número de tickets, pero ambos elementos son intensivos en habilitación técnica y gobierno y consumen capacidad equivalente al sprint funcional paralelo.

### SP-EC-APP-SQ2-03

Sprint original: Sprint 3
Squad: Squad 2
Épica(s): EPIC-3 Portada y dominios informativos, EPIC-4 Agenda y salud
Objetivo del sprint: Entregar el primer barrido de dominios informativos del ciudadano y arrancar la slice de agenda, materializando el dashboard MVP descrito en el roadmap.
Tareas / tickets asociados:

- `STORY-23` Landing de educación, titulaciones y enlaces relacionados — primera landing temática.
- `STORY-24` Landing de empleo, estado y superficies de inscripción a ofertas — bloqueada parcialmente por `TASK-27`, se construye el contenedor y se itera al cerrar la puerta.
- `STORY-25` Landing de servicios sociales con familia numerosa y servicios relacionados — mismo patrón de iteración condicionado a `TASK-27`.
- `STORY-26` Dominio de Estado y otros intereses con domicilio, vehículos y bienes inmuebles — funcionalmente claro una vez existe el routing de home.
- `STORY-28` Gestión de enlaces externos y navegación saliente de dominio — slice de soporte transversal a las landings anteriores.
- `STORY-29` Lista de agenda, calendario y filtros temporales — abre la slice de salud sobre identidad y shell ya disponibles.

Notas operativas: La puerta `TASK-27` (Squad 3) se ejecuta en paralelo. El squad funcional avanza con los contenedores y aplica las decisiones de contrato cuando se publican, evitando bloqueo total de la ola.

### SP-EC-APP-SQ3-03

Sprint original: Sprint 3
Squad: Squad 3
Épica(s): EPIC-3 Portada y dominios informativos
Objetivo del sprint: Resolver la puerta cruzada de contrato del dashboard, que condiciona el alcance final de varias landings de dominio y de la home.
Tareas / tickets asociados:

- `TASK-27` Validar bloques visibles del dashboard sin contrato confirmado — puerta de decisión cruzada para `STORY-23`, `STORY-24`, `STORY-25` y `STORY-31`.

Notas operativas: Sprint deliberadamente acotado en número de tickets pero crítico en impacto: su cierre desbloquea olas posteriores. La capacidad libre del Squad 3 en esta ola se dedica a dar continuidad a las líneas transversales ya abiertas (`STORY-64`, `STORY-68`, `TASK-69`) sin crear tickets nuevos.

### SP-EC-APP-SQ2-04

Sprint original: Sprint 4
Squad: Squad 2
Épica(s): EPIC-4, EPIC-5, EPIC-7, EPIC-8, EPIC-9
Objetivo del sprint: Ampliar el alcance funcional a salud (detalle de cita y CIP), abrir el shell de gestiones y la búsqueda asociada, publicar el catálogo de carnets, iniciar hechos vitales y autorizaciones, y dejar disponible el formulario de soporte técnico.
Tareas / tickets asociados:

- `STORY-30` Detalle de cita, justificante y manejo de estados — construye sobre la lista de agenda ya entregada.
- `STORY-31` Superficies reutilizables de CIP y salud en home y agenda — depende de `TASK-27` y `TASK-71`; se entregan los puntos compartidos preparados para sus salidas.
- `STORY-34` Workspace principal de expedientes, entradas y salidas — shell funcional del dominio de gestiones.
- `STORY-39` Búsqueda por identificación, número de expediente o número de registro — vía alternativa de acceso al dominio.
- `STORY-48` Catálogo de carnets digitales con disponibilidad y estados bloqueados — depende de `TASK-53`; se publica el contenedor preparado para iterar.
- `STORY-54` Selección y persistencia de hechos vitales del ciudadano — primera slice del dominio de personalización.
- `STORY-55` Permisos de uso de datos y revocación desde preferencias — acopla consentimiento legal y control de personalización.
- `STORY-60` Formulario de soporte técnico con adjuntos, consentimiento y captcha — depende de `TASK-63` para la operativa final; se construye la pieza de UI y se difiere la integración al cierre de la puerta.

Notas operativas: Sprint funcional muy denso, alineado con la ola de máxima apertura de dominios del roadmap original. Las puertas `TASK-32` y `TASK-71` (Squad 3) se ejecutan en paralelo y se integran progresivamente.

### SP-EC-APP-SQ3-04

Sprint original: Sprint 4
Squad: Squad 3
Épica(s): EPIC-4 Salud, EPIC-7 Carnets
Objetivo del sprint: Cerrar las puertas de descubrimiento que condicionan agenda/CIP y las superficies adicionales de carnets en home, asegurando que la apertura funcional simultánea no produzca retrabajo.
Tareas / tickets asociados:

- `TASK-32` Validar formato real de payload SESCAM y reglas de parseo — debe cerrarse antes de finalizar adaptadores y UX resiliente de salud.
- `TASK-71` Aclarar superficies adicionales de carnets mostradas en la home — afecta a `STORY-22`, `STORY-31` y `STORY-48`.

Notas operativas: Carga claramente menor que SP-EC-APP-SQ2-04 en número de tickets, pero ambos son puertas críticas de contrato cuya resolución condiciona el alcance del sprint funcional paralelo. Se asume el desequilibrio por realismo operativo.

### SP-EC-APP-SQ2-05

Sprint original: Sprint 5
Squad: Squad 2
Épica(s): EPIC-5 Gestiones y aportación, EPIC-6 Notificaciones, EPIC-7 Carnets
Objetivo del sprint: Profundizar el dominio de gestiones con detalle de expediente, registro y aportación documental completa, abrir el centro de notificaciones y el alta de datos de contacto, y consolidar la capa compartida de exportación de carnets.
Tareas / tickets asociados:

- `STORY-35` Detalle de expediente con metadatos y ficheros — construye sobre `STORY-34` y consume `TASK-40`.
- `STORY-36` Detalle de registro de entrada/salida — construye sobre `STORY-34`.
- `STORY-37` Flujo dedicado de aportación documental por terceros — depende de `TASK-40` y de las primitivas de upload.
- `STORY-38` Subida de adjuntos, hashing, validación y descarga de justificante — núcleo técnico de aportación y evidencia documental.
- `STORY-41` Centro de notificaciones con filtros de estado y paginación — superficie base del dominio.
- `STORY-42` Registro de datos de contacto para notificación electrónica — prerrequisito para ciudadanos sin canal configurado.
- `STORY-52` QR, PDF, PKPass y wallet compartidos — habilitador técnico para cada historia concreta de carnet.

Notas operativas: Las puertas `TASK-40`, `TASK-47` y `TASK-53` (Squad 3) se ejecutan en paralelo. `STORY-38` se diseña con las decisiones preliminares de `TASK-40` y se ajusta de forma controlada al cierre de la puerta.

### SP-EC-APP-SQ3-05

Sprint original: Sprint 5
Squad: Squad 3
Épica(s): EPIC-5, EPIC-6, EPIC-7
Objetivo del sprint: Cerrar simultáneamente tres puertas de contrato que condicionan las épicas funcionales más cargadas de la fase central del proyecto.
Tareas / tickets asociados:

- `TASK-40` Validar el flujo completo de procedimiento y evidencia — puerta previa al cierre de expediente y aportación.
- `TASK-47` Confirmar contrato real de notificación y asociación documental — puerta previa al cierre de estados de notificación y detalle.
- `TASK-53` Validar payloads binarios/string de carnet y reglas de wallet — puerta previa al comportamiento final de exportación documental.

Notas operativas: Tres puertas concurrentes representan una carga técnica intensiva comparable, en términos de capacidad consumida, al sprint funcional paralelo, aunque el conteo bruto de tickets sea menor.

### SP-EC-APP-SQ2-06

Sprint original: Sprint 6
Squad: Squad 2
Épica(s): EPIC-6 Notificaciones, EPIC-7 Carnets, EPIC-8 Recomendaciones
Objetivo del sprint: Cerrar la cara funcional de la ola central larga: decisión y detalle de notificaciones, carnets concretos (familia numerosa, joven, discapacidad) y recomendaciones personalizadas con su estado vacío.
Tareas / tickets asociados:

- `STORY-43` Decisión de notificación pendiente con flujo de aceptar/rechazar — depende de `STORY-41`, `STORY-42` y del cierre de `TASK-47`.
- `STORY-44` Detalle de notificación aceptada/rechazada/expirada con documentos — consume el contrato validado y los puntos de entrada de la lista.
- `STORY-49` Carnet digital de familia numerosa y exportaciones — sobre el catálogo y la capa compartida ya disponibles.
- `STORY-50` Carnet joven, modal de detalle y formatos móviles — mismo patrón.
- `STORY-51` Carnet de discapacidad, datos de grado y estado no válido — mismo patrón.
- `STORY-56` Recomendaciones personalizadas con filtros y agrupación — depende de `STORY-54`, `STORY-55` y `TASK-58`.
- `STORY-57` Estado vacío de recomendaciones y onboarding cuando faltan datos — slice paralela a `STORY-56`.

Notas operativas: La pieza de firma (`STORY-45`, `STORY-46`) se ejecuta en paralelo en SP-EC-APP-SQ3-06 por su carga técnica de integración con Afirma y deep links seguros. La integración funcional dentro de la app se coordina con Squad 3.

### SP-EC-APP-SQ3-06

Sprint original: Sprint 6
Squad: Squad 3
Épica(s): EPIC-6 Firma, EPIC-8 Recomendaciones
Objetivo del sprint: Resolver los componentes técnicamente más sensibles de la ola larga (firma con Afirma y validación de semántica de recomendaciones), de forma que el squad funcional pueda concentrarse en el cierre de superficies finales.
Tareas / tickets asociados:

- `STORY-45` Lista de documentos a firmar, validación de certificado e historial firmado — workbench de firma con criticidad técnica y de seguridad.
- `STORY-46` Salto al navegador hacia Afirma y retorno seguro a la app — depende de `STORY-45` y del manejo de deep links móviles.
- `TASK-58` Confirmar reglas de segmentación y contrato semántico de recomendaciones — puerta previa al cierre final de `STORY-56` y `STORY-57`.

Notas operativas: La asignación de `STORY-45` y `STORY-46` al Squad 3 responde a su componente fuerte de integración técnica externa, certificado, deep linking y retorno seguro, alineado con la responsabilidad operativa del squad. Mejora también el equilibrio de carga frente al sprint funcional paralelo, que de otro modo concentraría todo el cierre de épicas.

### SP-EC-APP-SQ2-07

Sprint original: Sprint 7
Squad: Squad 2
Épica(s): EPIC-10 Calidad transversal
Objetivo del sprint: Concentrar la verificación funcional, de accesibilidad y de regresión visual sobre las superficies funcionales ya construidas, antes del handoff a UAT.
Tareas / tickets asociados:

- `STORY-67` QA funcional, accesibilidad y regresión visual previas al handoff — concentra la fase de verificación tras la integración principal.

Notas operativas: Sprint funcional deliberadamente acotado: el Squad 2 actúa principalmente como propietario de la verificación funcional de extremo a extremo y como interlocutor frente al squad de gobierno, que en paralelo cierra puertas técnicas y operativas. La carga bruta es menor que en el sprint paralelo, pero la criticidad de QA en esta ventana justifica la asignación dedicada.

### SP-EC-APP-SQ3-07

Sprint original: Sprint 7
Squad: Squad 3
Épica(s): EPIC-9 Soporte, EPIC-10 Calidad y release readiness
Objetivo del sprint: Cerrar la operativa de soporte y endurecer las dimensiones técnicas que sostienen el candidato a UAT: resiliencia, pirámide de pruebas y presupuestos de rendimiento.
Tareas / tickets asociados:

- `TASK-63` Definir integración de soporte y modelo de escalado de incidencias — desbloquea la operativa final de `STORY-60`.
- `STORY-65` Cache, offline, conectividad, retry y resiliencia — adquiere sentido cuando ya existen flujos de datos reales.
- `STORY-66` Pirámide de pruebas, contract tests y validación del cliente generado — se consolida sobre las integraciones existentes.
- `TASK-70` Presupuestos de rendimiento de arranque, listas y documentos — se ejecuta sobre flujos representativos.

Notas operativas: También se da continuidad explícita al cierre de hallazgos abiertos de `TASK-40`, `TASK-47`, `TASK-53`, `TASK-58` y `TASK-71` que el roadmap original sitúa en este sprint. No se duplican tickets: se gestionan como cierre de hallazgos sobre las puertas ya abiertas.

### SP-EC-APP-SQ2-08

Sprint original: Sprint 8
Squad: Squad 2
Épica(s): EPIC-10 Release readiness (vista funcional)
Objetivo del sprint: Soportar la preparación de UAT y el handoff funcional desde la perspectiva de producto: verificación final de superficies funcionales, regresión guiada y aceptación de la versión candidata.
Tareas / tickets asociados:

- Cierre de UAT funcional asociado a `STORY-67`, sin redefinir alcance.
- Verificación de telemetría funcional asociada a `STORY-64` desde el punto de vista de producto.

Notas operativas: Sprint de cierre y empaquetado de release; no se introducen tickets nuevos. La actividad consiste en consolidar UAT y la verificación funcional sobre el conjunto ya construido. La traza de los tickets originales (`STORY-67`, `STORY-64`) se mantiene en sus sprints de origen y aquí se documenta su closure funcional.

### SP-EC-APP-SQ3-08

Sprint original: Sprint 8
Squad: Squad 3
Épica(s): EPIC-10 Release readiness
Objetivo del sprint: Cerrar la línea de release readiness: pipelines, paquetes de release, hardening y verificación de presupuestos de rendimiento sobre el candidato a UAT.
Tareas / tickets asociados:

- Cierre de empaquetado y pipeline asociado a `STORY-68`.
- Cierre de resiliencia asociado a `STORY-65`.
- Cierre del programa de hardening asociado a `TASK-69`.
- Verificación final de presupuestos de rendimiento asociada a `TASK-70`.

Notas operativas: Sprint de estabilización; no se introducen tickets nuevos. Se documenta el cierre de los tickets cross-cutting indicados en el roadmap original para Sprint 8 (publication readiness, UAT handoff, regression y release packaging).

### SP-EC-APP-SQ2-09

Sprint original: Sprint 9
Squad: Squad 2
Épica(s): Todas las épicas funcionales
Objetivo del sprint: Concentrar el cierre de defectos funcionales detectados en UAT y el ajuste fino de superficies de usuario antes de la publicación.
Tareas / tickets asociados:

- Cierre de defectos funcionales sobre las épicas EPIC-2 a EPIC-9, sin redefinir alcance ni introducir tickets nuevos.

Notas operativas: Sprint de defect closure según el roadmap original. No se inventa trabajo nuevo: la actividad se traza sobre las épicas y tickets ya entregados.

### SP-EC-APP-SQ3-09

Sprint original: Sprint 9
Squad: Squad 3
Épica(s): EPIC-10 Calidad y release readiness
Objetivo del sprint: Endurecer seguridad, rendimiento y resiliencia tras el feedback de UAT y dejar la versión candidata estabilizada.
Tareas / tickets asociados:

- Endurecimiento de seguridad como continuación de `TASK-69`.
- Ajuste de rendimiento como continuación de `TASK-70`.
- Cierre de resiliencia como continuación de `STORY-65`.

Notas operativas: Sprint de hardening sin tickets nuevos; se documentan las líneas de cierre que el roadmap original asocia a este sprint.

### SP-EC-APP-SQ2-10

Sprint original: Sprint 10
Squad: Squad 2
Épica(s): EPIC-10 Release y publicación (vista funcional)
Objetivo del sprint: Acompañar el seguimiento de publicación en stores y la verificación funcional final, manteniendo capacidad de respuesta ante observaciones de validación final.
Tareas / tickets asociados:

- Verificación funcional final y acompañamiento de publicación, sin tickets nuevos.

Notas operativas: Sprint de cierre final y reserva de estabilización funcional. No se redefine alcance.

### SP-EC-APP-SQ3-10

Sprint original: Sprint 10
Squad: Squad 3
Épica(s): EPIC-10 Release y publicación
Objetivo del sprint: Ejecutar el checklist final de release, mantener una ventana controlada de hotfix y la reserva de contingencia de proyecto.
Tareas / tickets asociados:

- Ejecución de checklist final de release como continuación de `STORY-68`.
- Ventana controlada de hotfix y reserva de contingencia.

Notas operativas: Sprint final de cierre; no se introducen tickets nuevos.

## 5. Vista por olas paralelas

| Ola | Sprint Squad 2 | Sprint Squad 3 | Intención combinada | Complementariedad y observación de carga |
| --- | --- | --- | --- | --- |
| 1 | SP-EC-APP-SQ2-01 | SP-EC-APP-SQ3-01 | Bootstrap visible + cimientos técnicos | Squad 2 pone en pie shell, identidad y diseño; Squad 3 pone en pie repo, networking, contrato API, observabilidad y seguridad. Carga técnica intensa en ambos, equilibrada en esfuerzo aunque asimétrica en número de tickets. |
| 2 | SP-EC-APP-SQ2-02 | SP-EC-APP-SQ3-02 | Cierre de sesión y contenidos vs. validación de claims y CI/CD | Squad 2 entrega más superficies; Squad 3 cierra dos piezas pequeñas en número pero pesadas en habilitación. Equilibrio razonable. |
| 3 | SP-EC-APP-SQ2-03 | SP-EC-APP-SQ3-03 | Apertura de dominios informativos y agenda vs. puerta de contrato del dashboard | Carga claramente cargada al lado funcional; el lado técnico se concentra en una puerta crítica. Asumido por realismo. |
| 4 | SP-EC-APP-SQ2-04 | SP-EC-APP-SQ3-04 | Apertura masiva de funcional vs. cierre de puertas SESCAM y carnets adicionales | Sprint funcional muy denso; sprint técnico acotado pero crítico para no producir retrabajo. |
| 5 | SP-EC-APP-SQ2-05 | SP-EC-APP-SQ3-05 | Profundización funcional de gestiones, notificaciones y exportación de carnets vs. cierre de tres puertas de contrato | Equilibrio razonable: carga funcional alta vs. tres puertas concurrentes intensivas. |
| 6 | SP-EC-APP-SQ2-06 | SP-EC-APP-SQ3-06 | Cierre funcional de notificaciones, carnets y recomendaciones vs. firma con Afirma y semántica de recomendaciones | Buen equilibrio: la firma se sitúa en Squad 3 por su carga técnica, descargando al squad funcional ya muy denso. |
| 7 | SP-EC-APP-SQ2-07 | SP-EC-APP-SQ3-07 | QA funcional y accesibilidad vs. soporte, resiliencia, pruebas y rendimiento | Sprint funcional acotado y enfocado a calidad; sprint técnico denso por consolidación de readiness. |
| 8 | SP-EC-APP-SQ2-08 | SP-EC-APP-SQ3-08 | UAT funcional y empaquetado vs. release packaging y hardening | Equilibrio operativo: ambos sprints son cierres no creativos. |
| 9 | SP-EC-APP-SQ2-09 | SP-EC-APP-SQ3-09 | Cierre de defectos funcionales vs. hardening de seguridad y rendimiento | Equilibrio operativo en estabilización. |
| 10 | SP-EC-APP-SQ2-10 | SP-EC-APP-SQ3-10 | Acompañamiento de publicación vs. checklist final y ventana de hotfix | Equilibrio operativo en cierre. |

## 6. Tabla final para gestión en Gesproy

| Sprint | Squad | Épica | Ticket/Tarea | Descripción breve |
| --- | --- | --- | --- | --- |
| SP-EC-APP-SQ2-01 | Squad 2 | EPIC-1 | STORY-13 | Shell global, router, guards y deep links de la app. |
| SP-EC-APP-SQ2-01 | Squad 2 | EPIC-1 | STORY-14 | Sistema de diseño, tema, l10n y accesibilidad base. |
| SP-EC-APP-SQ2-01 | Squad 2 | EPIC-2 | STORY-17 | Landing pública e información previa al acceso. |
| SP-EC-APP-SQ2-01 | Squad 2 | EPIC-2 | STORY-18 | Login Cl@ve, callback y ciclo de vida de sesión. |
| SP-EC-APP-SQ2-01 | Squad 2 | EPIC-2 | STORY-19 | Consentimiento legal inicial y aceptación de uso de datos. |
| SP-EC-APP-SQ3-01 | Squad 3 | EPIC-1 | STORY-11 | Topología de repo, bootstrap y entrypoints por entorno. |
| SP-EC-APP-SQ3-01 | Squad 3 | EPIC-1 | STORY-12 | Capa compartida de networking, almacenamiento seguro y errores. |
| SP-EC-APP-SQ3-01 | Squad 3 | EPIC-1 | TASK-16 | Puerta de adaptación OpenAPI y encapsulación DTO. |
| SP-EC-APP-SQ3-01 | Squad 3 | EPIC-10 | STORY-64 | Observabilidad, analítica y logging con redacción de PII. |
| SP-EC-APP-SQ3-01 | Squad 3 | EPIC-10 | TASK-69 | Inventario de PII, hardening y ADRs de excepción. |
| SP-EC-APP-SQ2-02 | Squad 2 | EPIC-1 | STORY-15 | Estados compartidos de carga, vacío, error y paginación. |
| SP-EC-APP-SQ2-02 | Squad 2 | EPIC-2 | STORY-20 | Estado de usuario logado, menú personal y bloqueo de mantenimiento. |
| SP-EC-APP-SQ2-02 | Squad 2 | EPIC-3 | STORY-22 | Home logada con resumen ciudadano y accesos rápidos. |
| SP-EC-APP-SQ2-02 | Squad 2 | EPIC-9 | STORY-59 | Centro de ayuda con FAQ, guías y contacto informativo. |
| SP-EC-APP-SQ2-02 | Squad 2 | EPIC-9 | STORY-61 | Páginas legales y estáticas. |
| SP-EC-APP-SQ2-02 | Squad 2 | EPIC-9 | STORY-62 | Mapa del sitio y navegación global del footer. |
| SP-EC-APP-SQ3-02 | Squad 3 | EPIC-2 | TASK-21 | Validar claims JWT, idAgente y parámetros de federación. |
| SP-EC-APP-SQ3-02 | Squad 3 | EPIC-10 | STORY-68 | Línea base de CI/CD, codegen y pipeline de entornos. |
| SP-EC-APP-SQ2-03 | Squad 2 | EPIC-3 | STORY-23 | Landing de educación, titulaciones y enlaces. |
| SP-EC-APP-SQ2-03 | Squad 2 | EPIC-3 | STORY-24 | Landing de empleo y ofertas. |
| SP-EC-APP-SQ2-03 | Squad 2 | EPIC-3 | STORY-25 | Landing de servicios sociales y servicios relacionados. |
| SP-EC-APP-SQ2-03 | Squad 2 | EPIC-3 | STORY-26 | Dominio de Estado y otros intereses. |
| SP-EC-APP-SQ2-03 | Squad 2 | EPIC-3 | STORY-28 | Gestión de enlaces externos y navegación saliente. |
| SP-EC-APP-SQ2-03 | Squad 2 | EPIC-4 | STORY-29 | Lista de agenda, calendario y filtros temporales. |
| SP-EC-APP-SQ3-03 | Squad 3 | EPIC-3 | TASK-27 | Validar bloques visibles del dashboard sin contrato confirmado. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-4 | STORY-30 | Detalle de cita, justificante y manejo de estados. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-4 | STORY-31 | Superficies reutilizables de CIP y salud. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-5 | STORY-34 | Workspace principal de expedientes, entradas y salidas. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-5 | STORY-39 | Búsqueda por identificación, expediente o registro. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-7 | STORY-48 | Catálogo de carnets digitales y estados bloqueados. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-8 | STORY-54 | Selección y persistencia de hechos vitales. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-8 | STORY-55 | Permisos de uso de datos y revocación. |
| SP-EC-APP-SQ2-04 | Squad 2 | EPIC-9 | STORY-60 | Formulario de soporte técnico con adjuntos y captcha. |
| SP-EC-APP-SQ3-04 | Squad 3 | EPIC-4 | TASK-32 | Validar payload SESCAM y reglas de parseo. |
| SP-EC-APP-SQ3-04 | Squad 3 | EPIC-7 | TASK-71 | Aclarar superficies adicionales de carnets en home. |
| SP-EC-APP-SQ2-05 | Squad 2 | EPIC-5 | STORY-35 | Detalle de expediente con metadatos y ficheros. |
| SP-EC-APP-SQ2-05 | Squad 2 | EPIC-5 | STORY-36 | Detalle de registro de entrada/salida. |
| SP-EC-APP-SQ2-05 | Squad 2 | EPIC-5 | STORY-37 | Aportación documental por terceros. |
| SP-EC-APP-SQ2-05 | Squad 2 | EPIC-5 | STORY-38 | Subida de adjuntos, hashing, validación y justificante. |
| SP-EC-APP-SQ2-05 | Squad 2 | EPIC-6 | STORY-41 | Centro de notificaciones con filtros y paginación. |
| SP-EC-APP-SQ2-05 | Squad 2 | EPIC-6 | STORY-42 | Registro de datos de contacto para notificación electrónica. |
| SP-EC-APP-SQ2-05 | Squad 2 | EPIC-7 | STORY-52 | QR, PDF, PKPass y wallet compartidos. |
| SP-EC-APP-SQ3-05 | Squad 3 | EPIC-5 | TASK-40 | Validar flujo completo de procedimiento y evidencia. |
| SP-EC-APP-SQ3-05 | Squad 3 | EPIC-6 | TASK-47 | Confirmar contrato real de notificación y documentos. |
| SP-EC-APP-SQ3-05 | Squad 3 | EPIC-7 | TASK-53 | Validar payloads binarios/string y reglas de wallet. |
| SP-EC-APP-SQ2-06 | Squad 2 | EPIC-6 | STORY-43 | Decisión de notificación pendiente con aceptar/rechazar. |
| SP-EC-APP-SQ2-06 | Squad 2 | EPIC-6 | STORY-44 | Detalle de notificación aceptada/rechazada/expirada. |
| SP-EC-APP-SQ2-06 | Squad 2 | EPIC-7 | STORY-49 | Carnet digital de familia numerosa y exportaciones. |
| SP-EC-APP-SQ2-06 | Squad 2 | EPIC-7 | STORY-50 | Carnet joven, modal de detalle y formatos móviles. |
| SP-EC-APP-SQ2-06 | Squad 2 | EPIC-7 | STORY-51 | Carnet de discapacidad, grado y estado no válido. |
| SP-EC-APP-SQ2-06 | Squad 2 | EPIC-8 | STORY-56 | Recomendaciones personalizadas con filtros y agrupación. |
| SP-EC-APP-SQ2-06 | Squad 2 | EPIC-8 | STORY-57 | Estado vacío de recomendaciones y onboarding. |
| SP-EC-APP-SQ3-06 | Squad 3 | EPIC-6 | STORY-45 | Documentos a firmar, validación de certificado e historial. |
| SP-EC-APP-SQ3-06 | Squad 3 | EPIC-6 | STORY-46 | Salto al navegador hacia Afirma y retorno seguro. |
| SP-EC-APP-SQ3-06 | Squad 3 | EPIC-8 | TASK-58 | Confirmar segmentación y contrato semántico de recomendaciones. |
| SP-EC-APP-SQ2-07 | Squad 2 | EPIC-10 | STORY-67 | QA funcional, accesibilidad y regresión visual. |
| SP-EC-APP-SQ3-07 | Squad 3 | EPIC-9 | TASK-63 | Definir integración de soporte y modelo de escalado. |
| SP-EC-APP-SQ3-07 | Squad 3 | EPIC-10 | STORY-65 | Cache, offline, conectividad, retry y resiliencia. |
| SP-EC-APP-SQ3-07 | Squad 3 | EPIC-10 | STORY-66 | Pirámide de pruebas, contract tests y validación de codegen. |
| SP-EC-APP-SQ3-07 | Squad 3 | EPIC-10 | TASK-70 | Presupuestos de rendimiento de arranque, listas y documentos. |
| SP-EC-APP-SQ2-08 | Squad 2 | EPIC-10 | Cierre UAT funcional (STORY-67) | Verificación final de superficies funcionales y handoff a UAT. |
| SP-EC-APP-SQ2-08 | Squad 2 | EPIC-10 | Verificación telemetría (STORY-64) | Verificación funcional de telemetría desde el lado de producto. |
| SP-EC-APP-SQ3-08 | Squad 3 | EPIC-10 | Cierre release packaging (STORY-68) | Empaquetado de release y verificación de pipeline. |
| SP-EC-APP-SQ3-08 | Squad 3 | EPIC-10 | Cierre resiliencia (STORY-65) | Cierre operativo de resiliencia sobre flujos representativos. |
| SP-EC-APP-SQ3-08 | Squad 3 | EPIC-10 | Cierre hardening (TASK-69) | Cierre del programa de hardening y excepciones de arquitectura. |
| SP-EC-APP-SQ3-08 | Squad 3 | EPIC-10 | Verificación rendimiento (TASK-70) | Verificación final de presupuestos de rendimiento. |
| SP-EC-APP-SQ2-09 | Squad 2 | EPIC-2 a EPIC-9 | Cierre de defectos funcionales | Cierre de defectos detectados en UAT en las épicas funcionales. |
| SP-EC-APP-SQ3-09 | Squad 3 | EPIC-10 | Endurecimiento seguridad (TASK-69) | Continuación del endurecimiento de seguridad. |
| SP-EC-APP-SQ3-09 | Squad 3 | EPIC-10 | Ajuste rendimiento (TASK-70) | Ajuste fino de rendimiento sobre flujos finales. |
| SP-EC-APP-SQ3-09 | Squad 3 | EPIC-10 | Cierre resiliencia (STORY-65) | Cierre final de resiliencia post-UAT. |
| SP-EC-APP-SQ2-10 | Squad 2 | EPIC-10 | Acompañamiento publicación | Verificación funcional final y seguimiento de publicación. |
| SP-EC-APP-SQ3-10 | Squad 3 | EPIC-10 | Checklist final de release (STORY-68) | Ejecución del checklist final de release. |
| SP-EC-APP-SQ3-10 | Squad 3 | EPIC-10 | Ventana de hotfix y reserva | Ventana controlada de hotfix y reserva de contingencia. |

## 7. Comprobación de cobertura y consistencia

- Todos los tickets listados en la sección "Ticket roadmap by sprint" del roadmap original están representados en este documento, asignados al squad cuya naturaleza operativa los posee de forma realista.
- Ningún ticket del backlog ha sido modificado, renombrado, movido o eliminado.
- Ningún archivo del repositorio ha sido alterado más allá de la creación de este propio documento.
- Las puertas de descubrimiento (`TASK-16`, `TASK-21`, `TASK-27`, `TASK-32`, `TASK-40`, `TASK-47`, `TASK-53`, `TASK-58`, `TASK-63`, `TASK-71`) mantienen su posicionamiento relativo respecto al trabajo funcional que desbloquean.
- Los sprints 8, 9 y 10 se documentan como sprints de cierre y estabilización: no se introducen tickets nuevos, sino que se traza el cierre operativo de los tickets cross-cutting ya iniciados en sprints anteriores, en línea con lo descrito en el roadmap original.
- Esta es una vista de planificación: el backlog fuente permanece intacto y sigue siendo la única fuente de verdad sobre alcance, criterios de aceptación y dependencias.

## 8. Nota final

Este documento existe únicamente para soportar la planificación formal, la gobernanza y la trazabilidad de facturación dentro de Gesproy mediante una vista operativa de 20 sprints alineada con la realidad de los dos squads paralelos. No redefine el alcance del producto, no altera los tickets existentes y no sustituye al roadmap fuente: lo proyecta sobre el modelo oficial de seguimiento sin tocar la definición subyacente del backlog.
