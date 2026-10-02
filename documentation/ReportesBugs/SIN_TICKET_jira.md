# Errores de las revisiones de JCCM sin ticket en Jira

> Extracto de `CONSOLIDADO_errores_vs_jira.md` (01/10/2026), cruzado con JCCMEC-1 a JCCMEC-236 en Jira (solo lectura; no se ha creado nada). Los IDs `E-NNN` son los del consolidado.
> Origen: **H2** = Pruebas Hito 2 (20/07 y 06/08) · **R31** = revisión del 31/08 · **R21** = revisión del 21/09 · **R28** = revisión del 28/09.

**12 puntos sin ticket:**
- **9 pendientes de arreglar** (bloque 1): habría que abrirles ticket.
- **2 ya corregidos** (bloque 2): no hay trazabilidad en Jira.
- **1 que no procede** (bloque 3).

---

## 1. Pendientes de arreglar (9)

| ID | Pantalla | Error o cambio | Tipo | Origen | Nota del revisor | Observaciones |
|---|---|---|---|---|---|---|
| E-081 | Gestión · Mis expedientes | En el listado, la app muestra la **Consejería** y la web la **oficina tramitadora** (por ejemplo, «Dirección general de humanización y atención sociosanitaria») | Funcional | R21 (23/09), R28 | ✘ «no corregido» (LAR 28/09) | El caso de prueba de la **182** espera la consejería en mayúsculas como categoría: hay que actualizarlo también. |
| E-082 | Gestión · Mis expedientes | Para el mismo expediente, la **fecha de inicio** difiere entre la web y la app | Funcional | R28 | — | Comprobar qué campo de la API se usa. |
| E-086 | Gestión · Aportar documentación | Solo se debe poder aportar documentación a los expedientes cuyo campo **`adjuntar` vale `X`** | Funcional | H2 | — | Es del Hito 2 («pendiente probar con usuario que tenga»): verificar si ya se cumple antes de abrir ticket. |
| E-095 | Gestión · Aportar documentación | El orden de los estados de carga sigue el de las cards de diseño (1. papelera → 2. cargando → 3. completado, aunque pone «eliminar»). Debe ser **1. cargando → 2. completado → 3. eliminar (con papelera)** | Diseño | R28 | — | — |
| E-065 | Carnets digitales | En Android, el PKPASS se guarda como **`.pkpass.zip`** y Wallet no puede abrirlo | Funcional | H2 | — | Puede estar resuelto por el trabajo de Cartera digital (223, QA Testing): verificar antes de abrir ticket. |
| E-018 | Todas las pantallas | **Quitar la campana superior**: se acordó para notificaciones push, que no habrá en esta versión | Diseño | H2 | — | El caso de prueba de la **151** espera la campana en el AppBar: hay que actualizarlo también. |
| E-036 | Protección de datos | Párrafos con **tamaños de letra distintos** sin criterio; el enlace de la AEPD con **otro estilo** que el de la Sede; un **punto suelto** bajo la URL de la Sede | Diseño | R28 | — | El antecedente (170, unificar estilos) está cerrado. Puede estar afectado por `7dcadf6` (01/10, texto idéntico al oficial). |
| E-031 | Formulario de soporte | La URL del RAT aparece como **texto** y no avisa de que es un enlace externo. La correcta es `https://rat.castillalamancha.es/detalle/2309` | UX Writing | H2, R31 | ⏸ «Pendiente aprobar texto final» (LAR 15/09) | Solo lo recogía la 161, que está **Desestimada**; la 212 no lo incluye. |
| E-062 | Gestión · Alta en notificaciones | Texto de ayuda de la **(i)** | UX Writing | R31 | — | Se podría añadir a la 226 (Revisión UX Writing) en vez de abrir un ticket propio. |

## 2. Ya corregidos, sin ticket (2)

| ID | Pantalla | Cambio | Tipo | Origen | Nota del revisor |
|---|---|---|---|---|---|
| E-060 | Preferencias · Mis hechos vitales | «Cancelar» abría la ventana «Borrar tus preferencias»; ahora «Desmarcar todo» desmarca todas las opciones | Funcional | R31 (03/09) | ✔ BDG y LAR 16/09 |
| E-070 | Carnets digitales | Botón «PKPASS» renombrado a **«Cartera digital»** en las dos plataformas, a raíz de la demo a Vicepresidencia (10/09) y por recomendación de UX Writing (11/09) | UX Writing | R31 (10 y 11/09) | ✔ BDG 15/09 |

## 3. No procede (1)

| ID | Pantalla | Cambio | Origen | Nota del revisor |
|---|---|---|---|---|
| E-059 | Preferencias · Mis hechos vitales | Botones Guardar/Cancelar frente a Aceptar/Desmarcar todo del diseño | R31 (03/09) | «No es incidencia, lo tienen que cambiar en diseño» (LAR 16/09). Lo cambia diseño, no la app. |

---

## 4. Propuesta de tickets

> Redactados con la misma estructura que los últimos tickets de JCCMEC (Resumen · Contexto · Criterios de aceptación). **No se ha creado ninguno.** El código de Gesproy y la persona asignada se dejan sin rellenar.
> Los tickets 4.1 a 4.9 corresponden a los puntos pendientes. Los 4.10 y 4.11 son opcionales: solo sirven para dejar constancia en Jira de lo ya corregido y se crearían directamente cerrados. E-059 no lleva ticket porque no es una incidencia de la app.

### 4.1 · E-081

**Tipo:** Error
**Título:** Exp - El listado muestra la Consejería en lugar de la oficina tramitadora

**Descripción:**

> ### Resumen
> En el listado de «Mis expedientes», cada tarjeta muestra la Consejería. En Espacio Ciudadano Web, para el mismo expediente, se muestra la oficina tramitadora.
>
> ### Contexto
> - Reportado en las revisiones de JCCM del 23/09 y del 28/09. El 28/09 sigue marcado como «no corregido».
> - Ejemplo: la web muestra «Dirección general de humanización y atención sociosanitaria» y la app muestra la Consejería.
> - Gesproy: #______
>
> ### Criterios de aceptación
> - La tarjeta del listado muestra la oficina tramitadora, igual que la web.
> - Si el expediente no trae oficina tramitadora, se muestra «-», sin «null» ni huecos descuadrados.
> - El detalle del expediente mantiene los campos «CONSEJERÍA» y «OFICINA TRAMITADORA».
> - Se actualiza el resultado esperado del caso de prueba TC-066 (JCCMEC-182), que hoy espera la consejería en mayúsculas como categoría.

### 4.2 · E-082

**Tipo:** Error
**Título:** Exp - La fecha de inicio no coincide con la web

**Descripción:**

> ### Resumen
> Para un mismo expediente, la fecha de inicio que muestra la app es distinta de la que muestra Espacio Ciudadano Web.
>
> ### Contexto
> - Reportado en la revisión de JCCM del 28/09, con capturas de la web y de la app.
> - Hay que comprobar qué campo de la respuesta de expedientes usa la app como fecha de inicio y cuál usa la web. Puede ser un problema de campo, de zona horaria o de formato.
> - Gesproy: #______
>
> ### Criterios de aceptación
> - La fecha de inicio del listado y del detalle coincide con la de la web para el mismo expediente.
> - El formato es dd/mm/aaaa, como en Figma.
> - Si no viene informada, se muestra «-».

### 4.3 · E-086

**Tipo:** Error
**Título:** Aportar documentación - Permitir aportar solo a los expedientes con «adjuntar = X»

**Descripción:**

> ### Resumen
> Solo se puede aportar documentación a los expedientes cuyo campo `adjuntar` de la respuesta de la API vale `X`. A los demás no se puede.
>
> ### Contexto
> - Reportado en las Pruebas del Hito 2 (20/07); entonces quedó pendiente de probar con un usuario que tuviera expedientes.
> - **Antes de empezar, verificar si la regla ya se cumple** en la versión actual. Si se cumple, cerrar el ticket con la evidencia.
> - Gesproy: #______
>
> ### Criterios de aceptación
> - En «Aportar documentación a un expediente de terceros», un expediente con `adjuntar` distinto de `X` no permite aportar y muestra un mensaje explicativo con un texto validado por UX Writing.
> - En «Mis expedientes», el botón «Aportar documentación» del detalle sigue la misma regla.
> - Un expediente con `adjuntar = X` mantiene el flujo actual.

### 4.4 · E-095

**Tipo:** Error
**Título:** Aportar documentación - El orden de los estados de carga de los documentos está invertido

**Descripción:**

> ### Resumen
> Al aportar documentación, cada documento recorre los estados en el orden de las cards de diseño: 1. papelera → 2. cargando → 3. completado (aunque pone «eliminar»). Es incorrecto.
>
> ### Contexto
> - Reportado en la revisión de JCCM del 28/09, con captura.
> - Gesproy: #______
>
> ### Criterios de aceptación
> - La secuencia de cada documento es: 1. **Cargando** → 2. **Completado** → 3. **Eliminar**, con el icono de papelera.
> - La papelera solo aparece cuando el documento ya está subido.
> - Los literales de cada estado coinciden con el estado real del documento.

### 4.5 · E-065

**Tipo:** Error
**Título:** Carnets - En Android el PKPASS se guarda como «.pkpass.zip»

**Descripción:**

> ### Resumen
> En Android, al descargar un carnet en formato PKPASS, el diálogo de guardado muestra la extensión `.pkpass`, pero el archivo se guarda como `.pkpass.zip` y Wallet no lo abre.
>
> ### Contexto
> - Reportado en las Pruebas del Hito 2 (20/07).
> - **Antes de empezar, verificar** si lo resolvió el trabajo de «Cartera digital» (JCCMEC-223). Si está resuelto, cerrar el ticket con la evidencia.
> - Gesproy: #______
>
> ### Criterios de aceptación
> - En Android, el archivo descargado conserva la extensión `.pkpass` y el tipo MIME `application/vnd.apple.pkpass`.
> - Abrir el archivo desde Descargas lo abre con la aplicación de cartera.

### 4.6 · E-018

**Tipo:** Tarea
**Título:** Quitar la campana de notificaciones de la barra superior

**Descripción:**

> ### Resumen
> Hay que eliminar de todas las pantallas la campana de la barra superior.
>
> ### Contexto
> - Reportado en las Pruebas del Hito 2 (20/07): se acordó que la campana era para las notificaciones push, que no existen en esta versión inicial.
> - El caso de prueba TC-042 (JCCMEC-151) espera hoy la campana en el AppBar.
> - Gesproy: #______
>
> ### Criterios de aceptación
> - La campana no aparece en ninguna pantalla, tanto con sesión iniciada como sin ella.
> - El hueco no deja un espacio vacío ni desplaza el avatar respecto a Figma.
> - Se actualiza el resultado esperado de TC-042 (JCCMEC-151).

### 4.7 · E-036

**Tipo:** Error
**Título:** Protección de datos - Formato del texto no uniforme y enlaces con estilos distintos

**Descripción:**

> ### Resumen
> En la página de Protección de datos, el formato del texto no es uniforme y los enlaces no tienen el mismo estilo.
>
> ### Contexto
> - Reportado en la revisión de JCCM del 28/09, con capturas.
> - Hay párrafos con un tamaño de letra mayor y otros con uno menor, sin ninguna lógica aparente.
> - El enlace a la web de la AEPD no tiene el mismo estilo que el enlace a la Sede.
> - Bajo la URL de la Sede aparece un punto suelto.
> - Antecedente: JCCMEC-170 (Cerrado). Puede estar afectado por el cambio de texto de JCCMEC-186 (`7dcadf6`).
> - Gesproy: #______
>
> ### Criterios de aceptación
> - Todo el cuerpo de texto usa el mismo estilo tipográfico del design system, y los títulos de sección el suyo.
> - Todos los enlaces (AEPD, Sede y correo electrónico) comparten el mismo estilo de enlace.
> - No hay puntos ni caracteres sueltos.
> - Se aplica igual en la pantalla de Protección de datos del primer inicio.

### 4.8 · E-031

**Tipo:** Error
**Título:** Formulario de soporte - El enlace al RAT debe ser un enlace externo

**Descripción:**

> ### Resumen
> En el texto informativo de protección de datos del formulario de soporte, la URL del RAT aparece como texto plano. Debe ser un enlace y avisar de que se abre fuera de la app.
>
> ### Contexto
> - Reportado en las Pruebas del Hito 2 (20/07) y en la revisión del 31/08.
> - Hasta ahora solo lo recogía JCCMEC-161, que está Desestimada; JCCMEC-212 no lo incluye.
> - Nota del revisor del 15/09: «Pendiente aprobar texto final». **El texto definitivo depende de JCCM.**
> - Gesproy: #______
>
> ### Criterios de aceptación
> - El enlace apunta a `https://rat.castillalamancha.es/detalle/2309`.
> - Al pulsarlo, se muestra el aviso de salida a un enlace externo, como en el resto de la app.
> - El texto que lo acompaña es el aprobado por JCCM.

### 4.9 · E-062

**Tipo:** Tarea
**Título:** Alta en notificaciones - Texto de ayuda de la (i)

> Alternativa: añadirlo como un punto más de **JCCMEC-226** (Revisión UX Writing) en vez de abrir un ticket propio.

**Descripción:**

> ### Resumen
> Hay que revisar con UX Writing el texto de ayuda que muestra la (i) en la pantalla de alta de datos de contacto de notificaciones.
>
> ### Contexto
> - Reportado en la revisión de JCCM del 31/08 («UX Writing - Texto de ayuda en (i)»), sin nota posterior.
> - Gesproy: #______
>
> ### Criterios de aceptación
> - La (i) muestra el texto validado por UX Writing, con el mismo formato de ventana de información que el resto de la app, y no como un mensaje de error.
> - Si el texto incluye un contacto o una URL, apunta al organismo responsable.

### 4.10 · E-060 (opcional, para dejar constancia)

**Tipo:** Error · **Estado al crearlo:** Cerrado
**Título:** Hechos vitales - «Cancelar» abría «Borrar tus preferencias»

**Descripción:**

> ### Resumen
> En la selección de hechos vitales de Preferencias, el botón «Cancelar» abría la ventana «Borrar tus preferencias». El comportamiento correcto es desmarcar todas las opciones.
>
> ### Contexto
> - Reportado en la revisión de JCCM del 03/09. Verificado como corregido por BDG y LAR el 16/09.
> - Gesproy: #______

### 4.11 · E-070 (opcional, para dejar constancia)

**Tipo:** Tarea · **Estado al crearlo:** Cerrado
**Título:** Carnets - Renombrar el botón «PKPASS» a «Cartera digital»

**Descripción:**

> ### Resumen
> En la hoja de descarga de carnets, el botón «PKPASS» pasa a llamarse «Cartera digital» en Android y en iOS.
>
> ### Contexto
> - Comentario de la demo a Vicepresidencia (10/09): proponían «Wallet» en Android y «Cartera» en iOS.
> - El 11/09 se unifica a «Cartera digital» en las dos plataformas, por recomendación de UX Writing.
> - Verificado como corregido por BDG el 15/09.
> - Gesproy: #______
