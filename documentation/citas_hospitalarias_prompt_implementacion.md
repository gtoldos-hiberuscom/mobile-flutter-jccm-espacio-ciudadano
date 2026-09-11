# Citas hospitalarias SESCAM: requisitos y prompt de implementación

## 1. Objetivo de la tarea

Completar en esta aplicación Flutter la consulta de citas hospitalarias del SESCAM y su integración en la Agenda del ciudadano. Reutilizar la implementación existente y adaptarla a los requisitos de este documento. Implementar y validar el alcance completo, respetando la arquitectura, navegación, localización, accesibilidad y sistema de diseño del repositorio.

Este documento consolida las capturas de requisitos funcionales y Swagger facilitadas por el usuario. Es autosuficiente como punto de partida para la implementación. Distingue los requisitos recibidos, los hallazgos del código y las cuestiones que necesitan confirmación; no presupone contratos que no aparecen en las capturas.

### Procedencia

| Dato | Valor |
| --- | --- |
| Proyecto | Espacio Ciudadano – APP Móvil |
| Funcionalidad | Consulta de citas hospitalarias (SESCAM) |
| Organismo | Agencia de Transformación Digital – Junta de Comunidades de Castilla-La Mancha |
| Origen funcional | Espacio Ciudadano Web |
| Fecha del documento recibido | Septiembre de 2026 |
| Cambio indicado | Se incluye el apartado 2.3: integración en Agenda |

## 2. Alcance funcional obligatorio

### 2.1. Acceso y pantalla de consulta

- Dentro de **Mis datos → Salud**, habilitar un enlace a **Mis citas hospitalarias**.
- Mostrar el identificador **CIP** del ciudadano.
- Mostrar dos pestañas: **Citas pendientes** y **Citas pasadas**.
- Abrir por defecto **Citas pendientes**.
- Permitir alternar las pestañas sin recargar toda la pantalla.
- Mostrar el listado correspondiente a cada estado.
- Adaptar la composición web a los patrones móviles de la APP, manteniendo toda la información funcional. No se exige reproducir visualmente la web.
- La funcionalidad es exclusivamente de consulta. Quedan fuera solicitar, modificar y anular citas.

Textos de referencia de la pantalla web:

> Consulta la información sobre tus citas hospitalarias del SESCAM.
> Si alguno de los datos no está actualizado deberás ponerte en contacto con el SESCAM.

### 2.2. Información por cita

| Campo visible | Ejemplo de referencia |
| --- | --- |
| Día de la semana y fecha | Martes - 03/02/2026 |
| Servicio | Traumatología, Medicina Interna, Radiología |
| Prestación | Consulta sucesiva, Consulta enfermería, TC cerebro sin/con contraste |
| Sala | Planta 1 |
| Centro / hospital | Hospital General de Tomelloso |
| Agenda | Traumatología 6 - Dra. Castellanos |
| Fecha y hora de la cita | 03/02/2026, 11:40 |

Cuando haya varias citas el mismo día, mostrar todas diferenciadas. No agruparlas ni eliminar alguna por compartir fecha u hora. Revisar que los textos largos y el escalado de fuente permitan consultar la información completa.

### 2.3. Estados y comportamiento

- Carga de datos con los componentes habituales de la aplicación.
- Mensaje explícito de ausencia de citas, independiente para cada pestaña.
- Error de comunicación con SESCAM con mensaje y posibilidad de reintentar.
- Mensaje específico cuando falte aceptación de las cláusulas.
- Mensaje específico cuando el nivel de autenticación sea insuficiente y acción para elevarlo.
- No presentar errores de servicio o autorización como si fueran listados vacíos.
- Conservar la coherencia de la información con la consulta equivalente en Espacio Ciudadano Web.

### 2.4. Integración en Agenda

Las citas hospitalarias deben aparecer en la Agenda junto con notificaciones, carnés, citas de atención primaria y demás elementos existentes.

El documento recibido indica que el servicio web de citas y eventos de Agenda está siendo modificado para incluir este nuevo tipo. Su contrato definitivo no está incluido en las capturas.

Trabajo necesario:

- Obtener y revisar el contrato definitivo de Agenda y ejemplos del nuevo tipo.
- Adaptar modelos, mapeo, clasificación y presentación de los eventos hospitalarios.
- Revisar ordenación y convivencia con los tipos actuales.
- Evitar duplicados si una misma cita llega por varias fuentes, sin eliminar citas distintas que coincidan en fecha y hora.
- Aplicar las condiciones de acceso también a la información hospitalaria mostrada en Agenda.
- Definir con el contrato disponible cómo tratar los eventos restringidos sin impedir consultar los demás eventos autorizados.

No inventar una agregación de endpoints adicional si el servicio de Agenda ya entrega estas citas. La necesidad de consultar otra fuente debe justificarse con el contrato real.

## 3. Cláusulas y autorización

La consulta pertenece al área **Salud**, con origen **JCCM, a través del SESCAM**, de forma análoga a las citas de atención primaria.

Se requiere aceptación previa de ambas cláusulas:

1. **Cláusula inicial:** condiciones de uso y autorizaciones de Espacio Ciudadano.
2. **Cláusula JCCM:** autorización expresa para consultar los hechos administrativos en poder de la JCCM en materia de Salud, entre otras áreas, y mostrarlos en Espacio Ciudadano.

Reutilizar los identificadores y mecanismos existentes de consentimiento. Verificar la comprobación previa y el tratamiento de denegaciones del servicio. Tras aceptar las cláusulas, permitir recuperar la consulta mediante el flujo habitual de la APP.

La integración no debe permitir acceder a información hospitalaria a través de Agenda o de otra ruta alternativa sin satisfacer estos requisitos.

## 4. Nivel de seguridad y Cerbero

### 4.1. Requisito recibido

Se exige como mínimo nivel **substantial (medio)**. Validar el campo **`authNLevel`** del token emitido por Cerbero después de autenticar al ciudadano:

- Nivel suficiente: permitir consultar las citas, siempre que también estén aceptadas las cláusulas.
- Nivel `low`: impedir la consulta y ofrecer elevar el nivel de seguridad.
- Tras la elevación: obtener la sesión/token actualizado, volver a comprobar el nivel y recuperar la consulta solicitada.

La documentación cita **«Cl@ve – Niveles de Seguridad v2.0»**, de administracionelectronica.gob.es, página 14. La URL exacta no está disponible en las capturas. El mínimo `substantial` es un requisito explícito del documento recibido, no una conclusión normativa añadida aquí.

Resumen de la tabla aportada, únicamente como referencia documental:

| Nivel Cl@ve | Registro / credencial de referencia | Nivel ENS mostrado |
| --- | --- | --- |
| 2, bajo | Registro básico con Clave PIN o Permanente sin OTP; registro fuerte con Permanente sin OTP | Bajo |
| 3, medio | Registro fuerte con Clave PIN, Permanente reforzada con OTP o certificado reconocido en soporte software | Medio |
| 4, alto | Registro fuerte con DNI electrónico u otros certificados reconocidos en soporte hardware acreditado | Alto |

No deducir el nivel efectivo únicamente del método de acceso: utilizar el claim y la correspondencia de valores confirmada por Cerbero.

### 4.2. Trabajo técnico requerido

- Revisar el modelo y lectura de claims e incorporar `authNLevel` donde corresponda.
- Confirmar los valores admitidos y su orden. Las capturas muestran `low` y `substantial`; no documentan el literal del nivel superior.
- Tratar un claim ausente o desconocido sin conceder acceso por defecto.
- Implementar el control antes de solicitar o mostrar información hospitalaria.
- Confirmar el mecanismo oficial de elevación para la integración móvil: parámetros, redirección, intercambio de tokens y retorno.
- No asumir que `acr_values`, un formulario OTP propio o una simple repetición del login son el mecanismo correcto sin verificar el contrato.
- Resolver cancelación, error, nivel todavía insuficiente y sesión expirada.
- Actualizar el estado de sesión y los proveedores dependientes tras la elevación, evitando datos de una sesión anterior.
- Revisar el comportamiento ante cierre de sesión, revocación de consentimiento o pérdida del nivel requerido.
- Verificar que el backend aplica igualmente la autorización. El control de interfaz no sustituye la protección del servicio.
- No registrar tokens ni información sanitaria en logs.

### 4.3. Datos de prueba recibidos

- El apartado de pruebas indica que con certificado digital o DNI-e no se solicitará elevación.
- Para Cl@ve permanente con nivel bajo, el documento proporciona el código de prueba **`111111`** para elevar el nivel.

Este código es exclusivamente una referencia de pruebas del entorno facilitado. No incorporarlo como constante, validación local ni mecanismo de producción. Confirmar el entorno y los usuarios válidos. El criterio de autorización sigue siendo el nivel comunicado por Cerbero.

## 5. Contratos de API aportados

### 5.1. Operaciones

| Método | Ruta | Finalidad |
| --- | --- | --- |
| GET | `/api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pendientes` | Consultar citas hospitalarias pendientes |
| GET | `/api/v1/ciudadanos/{idAgente}/salud/hospitalaria-citas-pasadas` | Consultar citas hospitalarias pasadas |

Según las capturas Swagger:

- `idAgente`: parámetro de ruta obligatorio de tipo string, descrito como documento NIF/NIE del ciudadano.
- Formato descrito: NIF de 8 dígitos y letra, o NIE de letra, 7 dígitos y letra.
- `Authorization`: cabecera con token Bearer.
- Requiere consentimiento para acceso a datos sanitarios del SESCAM.
- Respuesta `200`: listado obtenido correctamente, `application/json`.
- En pendientes se ve un `400` por formato de documento no válido.
- No se ve un parámetro de paginación para hospitalaria en las capturas.

### 5.2. Forma del cuerpo

El ejemplo Swagger utiliza un envoltorio de respuesta cuyo campo `body` es un array de `CitaHospitalariaDetalleSescam`. Ejemplo ilustrativo con identificadores ficticios, basado en los campos visibles:

```json
{
  "body": [
    {
      "servicio": "TRAUMATOLOGIA",
      "prestacion": "CONSULTA SUCESIVA",
      "sala": "PLANTA 1 TRAUMATOLOGIA 2",
      "estadoCita": "PENDIENTE",
      "centro": {
        "nombre": "HOSPITAL GENERAL DE TOMELLOSO"
      },
      "agenda": {
        "codigo": "TTRA-F",
        "descripcion": "TRAUMATOLOGIA 6 - DRA. CASTELLANOS"
      },
      "fecha": "03/02/2026",
      "hora": "11:40",
      "nhc": "00000000",
      "id": "cita-ejemplo-1"
    }
  ]
}
```

En citas pasadas se muestra `estadoCita: "REALIZADA"`. En la captura también se observan metadatos como `timestamp` y `mensaje-respuesta`; el envoltorio completo no es visible. Confirmarlo con OpenAPI o respuestas reales antes de modificar el decodificador.

| Campo API | Uso previsto |
| --- | --- |
| `servicio` | Servicio visible |
| `prestacion` | Prestación visible |
| `sala` | Sala visible |
| `centro.nombre` | Hospital visible |
| `agenda.descripcion` | Agenda visible |
| `fecha`, `hora` | Fecha, día de la semana y hora visibles |
| `estadoCita` | Estado del modelo; no se exige mostrar una etiqueta adicional |
| `agenda.codigo`, `id` | Identificadores técnicos cuando proceda |
| `nhc` | Número de historia clínica; no confundir con CIP ni mostrarlo como sustituto |

El CIP se obtiene mediante el mecanismo de Salud existente; no aparece en estos ejemplos de listado.

### 5.3. Aspectos pendientes de confirmar

- Identificador real por entorno: las capturas describen NIF/NIE, pero el código actual envía `sub_alt` al gateway.
- Disponibilidad de ambas rutas en el entorno objetivo.
- Forma completa del envoltorio, nulabilidad y posibles errores funcionales dentro de respuestas HTTP exitosas.
- Semántica de `401`, `403`, `404` y denegación por nivel insuficiente. No asumir que todo `403` significa falta de cláusulas.
- Formato y zona horaria de las fechas, ordenación, volumen y posible paginación futura.
- Contrato definitivo del nuevo evento hospitalario en Agenda.

## 6. Estado observado en el repositorio

Revisión inicial realizada el 9 de septiembre de 2026. Revalidar estos hallazgos antes de implementar porque el código puede haber cambiado.

### 6.1. Elementos reutilizables

- `lib/features/my_data/3_data/api/salud_api.dart`: operaciones de CIP, primaria y ambas consultas hospitalarias; reutiliza el tratamiento común de respuestas.
- `lib/features/my_data/0_entity/hospital_appointment.dart`: entidad con servicio, prestación, sala, estado, centro, agenda, fecha/hora e identificadores.
- `lib/features/my_data/3_data/mappers/hospital_appointment_mapper.dart`: mapea `body`, `centro` y `agenda`; actualmente descarta citas sin fecha reconocible. Revisar ese comportamiento frente al contrato real.
- `lib/features/my_data/3_data/my_data_health_repository_impl.dart`: repositorio de Salud.
- `lib/features/my_data/2_presentation/providers/my_data_health_provider.dart`: proveedores de CIP y hospitalaria con guardas de cláusula inicial y JCCM.
- `lib/features/my_data/2_presentation/my_data_health_page.dart`: selección de ámbito primaria/hospitalaria, pendientes/pasadas, CIP y tarjetas hospitalarias.
- `test/features/my_data/my_data_health_repository_impl_test.dart`: pruebas existentes de mapeo, rutas y ordenación hospitalaria, entre otras.

### 6.2. Diferencias y trabajo pendiente

- **Hospitalaria está desactivada** mediante `kHospitalAppointmentsEnabled = false` en la pantalla de Salud. El comentario lo relaciona con disponibilidad de rutas; comprobar el entorno real antes de habilitarla.
- La pantalla existente utiliza un selector primaria/hospitalaria. El requisito recibido pide un enlace a «Mis citas hospitalarias» desde Salud: adaptar la navegación para cumplirlo y reutilizar lo posible de la vista.
- Revisar la tarjeta actual para garantizar visibilidad de todos los campos y textos completos.
- En la revisión inicial no se ha encontrado control de `authNLevel` ni flujo específico de elevación. No considerar resuelta esta parte por existir login o refresco de token.
- `lib/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart` devuelve `sub_alt` para ambas variantes de identificador. Hay que contrastarlo con el Swagger recibido.
- Agenda combina citas de primaria y eventos generales; su modelo contempla `notification`, `health` y `credential`, sin tipo hospitalario explícito. Revisar si hace falta diferenciarlo y adaptar el mapeo al contrato definitivo.

### 6.3. Archivos relacionados que revisar

- `lib/features/auth/3_data/auth_repository_impl.dart`
- `lib/features/auth/2_presentation/providers/auth_session_controller.dart`
- `lib/features/auth/2_presentation/providers/jwt_claims_notifier.dart`
- `lib/features/my_data/2_presentation/providers/my_data_authorization_guard.dart`
- `lib/features/my_data/2_presentation/providers/my_data_authorization_provider.dart`
- `lib/features/agenda/0_entity/agenda_appointment.dart`
- `lib/features/agenda/3_data/agenda_repository_impl.dart`
- `lib/features/agenda/2_presentation/providers/agenda_appointments_provider.dart`
- `lib/features/agenda/2_presentation/agenda_page.dart`
- `documentation/clausulas_api_integration.md`
- `documentation/consent_clause_access_matrix.md`
- `documentation/ACCESSIBILITY_STANDARD.md`
- Pruebas existentes de Salud, consentimiento, autenticación y Agenda.

La existencia de código y pruebas no acredita integración real ni que los tests estén pasando. Esta revisión documental no ha ejecutado pruebas ni llamadas de servicio.

## 7. Plan de implementación

### Fase A. Contratos y diseño de la solución

- [ ] Leer las instrucciones aplicables del repositorio y revisar el estado actual de los archivos afectados.
- [ ] Contrastar lo ya implementado con cada requisito de este documento.
- [ ] Confirmar rutas, identificador, respuestas, errores y origen del CIP en el entorno objetivo.
- [ ] Confirmar contrato de Agenda y mecanismo de elevación de Cerbero.
- [ ] Definir navegación móvil y reutilización de componentes existentes.
- [ ] Registrar las incertidumbres que no puedan resolverse con la documentación disponible; avanzar con las partes independientes sin inventar contratos.

### Fase B. Consulta hospitalaria

- [ ] Ajustar modelos y mapeos solo donde el contrato real lo requiera.
- [ ] Completar el acceso desde Mis datos → Salud.
- [ ] Mostrar CIP, textos informativos y pestañas con pendientes por defecto.
- [ ] Mostrar todos los campos requeridos y todas las citas de un mismo día.
- [ ] Completar carga, vacío, error y reintento por pestaña.
- [ ] Revisar fechas, campos opcionales, textos largos, localización y accesibilidad.

### Fase C. Autorización y elevación

- [ ] Verificar cláusula inicial y JCCM antes de la consulta.
- [ ] Incorporar lectura y comprobación explícita de `authNLevel`.
- [ ] Mostrar bloqueo y acción de elevación cuando corresponda.
- [ ] Integrar el flujo confirmado de Cerbero y el retorno a la consulta.
- [ ] Gestionar cancelación, error, token nuevo sin nivel suficiente y expiración.
- [ ] Invalidar el estado sensible cuando cambie la sesión o la autorización.

### Fase D. Agenda

- [ ] Integrar el nuevo evento hospitalario con el contrato definitivo.
- [ ] Adaptar clasificación, presentación y ordenación.
- [ ] Revisar deduplicación y coincidencias de fecha/hora.
- [ ] Aplicar autorización y nivel de seguridad a esta vía de acceso.
- [ ] Comprobar regresión de primaria, notificaciones y carnés.

### Fase E. Validación y entrega

- [ ] Añadir o adaptar pruebas de los comportamientos relevantes.
- [ ] Ejecutar formato, análisis y pruebas correspondientes con las herramientas y versión del proyecto.
- [ ] Validar los flujos en Android e iOS con servicios y usuarios de prueba disponibles.
- [ ] Contrastar datos con Espacio Ciudadano Web para el mismo usuario.
- [ ] Documentar cambios, comprobaciones, dependencias y limitaciones pendientes.

## 8. Criterios de aceptación y pruebas

| Caso | Resultado esperado |
| --- | --- |
| Acceso desde Salud | Existe acceso identificable a Mis citas hospitalarias |
| Entrada con permisos y nivel suficientes | Se muestra CIP y se seleccionan pendientes |
| Cambio de pestaña | Cambia el listado sin recargar toda la pantalla |
| Pendientes sin datos | Mensaje explícito de ausencia de pendientes |
| Pasadas sin datos | Mensaje explícito de ausencia de pasadas |
| Varias citas el mismo día, incluso a la misma hora | Todas las citas distintas permanecen visibles |
| Información completa | Se pueden consultar servicio, prestación, sala, centro, agenda, fecha y hora |
| Campo opcional ausente / texto largo | La interfaz sigue siendo legible y no muestra valores técnicos nulos |
| Fallo de SESCAM | Error y reintento; no se presenta como lista vacía |
| Falta cláusula inicial o JCCM | No se consultan ni muestran datos hospitalarios; se informa del requisito |
| Aceptación de cláusulas | Se puede recuperar la consulta con el flujo habitual |
| `authNLevel = low` | Se bloquea hospitalaria y se ofrece elevar el nivel |
| Claim ausente o desconocido | No se concede acceso por defecto |
| Nivel suficiente confirmado | Se permite acceso si también hay consentimiento |
| Elevación correcta | Se actualiza sesión, se comprueba el nuevo nivel y se retoma la consulta |
| Elevación cancelada o fallida | Se mantiene el bloqueo y la aplicación sigue utilizable |
| Sesión expirada o usuario distinto | No quedan datos hospitalarios de la sesión anterior |
| Agenda con citas hospitalarias autorizadas | Se muestran junto con el resto de eventos, correctamente clasificadas |
| Agenda sin autorización suficiente | No expone datos hospitalarios y conserva los eventos que se puedan consultar |
| Cita recibida por varias fuentes | No se duplica ni provoca eliminación de otras citas distintas |
| Regresión | Primaria, notificaciones, carnés, consentimiento y login mantienen su funcionamiento |
| Comparación con Web | Coinciden los datos funcionales para el mismo ciudadano |
| Android/iOS y accesibilidad | Navegación, lectura y elevación funcionan en ambas plataformas |

Incluir pruebas unitarias de mapeo y nivel de seguridad, pruebas de estado y widgets para los bloqueos y listados, y pruebas de integración/manuales para Cerbero y servicios reales. Distinguir siempre resultados con mocks de validación real.

## 9. Estimación preliminar de referencia

Estimación del trabajo pendiente en la APP, reutilizando el código observado:

| Bloque | Horas |
| --- | ---: |
| Contratos, identificadores y respuestas reales | 4–8 |
| Acceso desde Salud y pantalla hospitalaria | 8–12 |
| Verificación y ajustes de cláusulas | 4–8 |
| `authNLevel`, elevación, sesión y retorno | 20–28 |
| Integración en Agenda | 12–16 |
| Pruebas, regresión Android/iOS y correcciones | 16–24 |
| **Total** | **64–96** |

Equivale a **8–12 jornadas de 8 horas**. Referencia de planificación: **12 jornadas**, sujeta a disponibilidad de servicios y confirmación del flujo de Cerbero. No incluye desarrollo de backend/Cerbero, esperas de otros equipos ni publicación en tiendas. La estimación no constituye un contrato técnico ni permite omitir requisitos.

## 10. Instrucción de ejecución para el agente implementador

Implementa la funcionalidad descrita en este documento en el repositorio actual. Empieza revisando las instrucciones locales y el código existente; reutiliza lo que ya está construido. Resuelve las diferencias entre esa implementación y los requisitos, incluyendo Agenda, consentimiento y elevación de seguridad.

No consideres la tarea terminada por activar `kHospitalAppointmentsEnabled`: verifica todos los criterios de aceptación. No inventes parámetros de Cerbero, valores de nivel ni contratos de Agenda. Si falta información externa indispensable, concreta qué falta, completa el trabajo independiente y documenta qué validación o integración queda bloqueada.

Entrega los cambios de código y pruebas, una explicación breve de la solución y las comprobaciones realizadas, así como cualquier dependencia pendiente. No afirmes validación contra servicios reales cuando solo se hayan utilizado mocks. No despliegues ni publiques en tiendas como parte de esta tarea.
