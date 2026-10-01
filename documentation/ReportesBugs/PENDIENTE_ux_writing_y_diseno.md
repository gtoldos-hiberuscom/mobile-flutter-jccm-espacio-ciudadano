# Pendiente de UX Writing, ajustes gráficos y diferencias con Figma

> Extracto de `PENDIENTE_por_arreglar.md` (01/10/2026) con solo lo que no es funcional. Los IDs `E-NNN` son los de `CONSOLIDADO_errores_vs_jira.md`. Solo aparece lo **pendiente**; lo ya corregido está en el consolidado.

**Situación**
- 🔴 El revisor dice que no está corregido.
- 🟠 Pendiente de una decisión, de UX Writing o de un diseño nuevo.
- 🟡 Abierto en Jira y sin validar.
- ⚪ Sin ticket.

**Total: 33 puntos distintos.** UX Writing 14 · Diferencias con Figma 12 · Ajustes gráficos 8. E-001 cuenta en dos bloques.

---

## 1. UX Writing: textos, mensajes y URL (14)

| ID | Pantalla | Qué falta | Ticket | Situación |
|---|---|---|---|---|
| E-001 | Arranque | El nombre de la app debe ser «Espacio Ciudadano CLM». El icono, en el bloque 3. | 157 · 217 Bloqueada | 🔴 |
| E-031 | Formulario de soporte | El enlace al RAT (`rat.castillalamancha.es/detalle/2309`) debe ser un enlace que avise de que es externo | 161 Desestimada | ⚪🟠 pendiente de aprobar el texto |
| E-035 | Protección de datos | Texto inicial y de la página actualizado a la última versión oficial | 186 QA Testing (`7dcadf6`) | 🟡 |
| E-062 | Alta en notificaciones | Texto de ayuda de la (i) | — | ⚪ |
| E-071 | Carnets | En la (i), quitar «contacta con tu centro de salud» y el botón con URL, porque cada carnet es de un organismo distinto | 199 · 175 Cerrado · 226 Por hacer | 🔴 |
| E-094 | Aportar documentación | El texto de la (i) solo habla de persona autorizada; alinearlo con el mensaje de la web | 236 · 226 Por hacer | 🟠 |
| E-109 | Agenda | El mensaje «No hemos podido cargar tus citas sanitarias» para un usuario sin CIP del SESCAM | 195 QA Testing | 🟡 |
| E-113 | Mis datos (común) | Que la (i) y el mensaje de «no hay datos» coincidan en organismo y contacto: Inscripciones, Bienes inmuebles, Carnets, Vehículos y Domicilio | 226 Por hacer | 🟠 |
| E-115 | Salud | El mensaje para un usuario sin CIP («servicio no disponible») | 196 QA Testing · 227 Por hacer | 🟠 |
| E-124 | Empleo | «Tu demanda de empleo» → «Mi demanda de empleo» | 203 QA Testing | 🟡 |
| E-128 | Empleo · Inscripciones | Texto y URL del Portal de empleabilidad en el mensaje de «no hay datos» (en la (i) ya está bien) | 211 Cerrado · 226 · 233 Por hacer | 🔴 |
| E-129 | Empleo · Inscripciones | Sin inscripciones aparece la (i) en vez de «no se han encontrado datos» | 233 Por hacer | 🟡 |
| E-135 | Domicilio | Sin datos, quitar el botón del Ayuntamiento, porque no hay URL | 235 Por hacer | 🟠 |
| E-139 | Educación | URL de títulos universitarios y texto del mensaje de «no hay datos», que no coincide con la (i) | 210 Cerrado (no está en la 226) | 🔴 |

## 2. Diferencias con Figma (12)

| ID | Pantalla | Qué falta | Ticket | Situación |
|---|---|---|---|---|
| E-018 | Todas | Quitar la campana superior: se acordó para un push que no habrá en esta versión | — (el caso de prueba de la 151 espera la campana) | ⚪ |
| E-021 | Ayuda y contacto | Las preguntas frecuentes deben abrir páginas aparte, no un acordeón, y estar categorizadas como en la web | 187 Por hacer | 🟡 |
| E-044 | Home logada | FAB «Carnets»: etiqueta y despliegue de tipos según el diseño | 152 QA Testing | 🟡 |
| E-046 | Home logada | Mis novedades vacías: «Notificaciones (0)», «Próximas citas (0)» y los textos de vacío | 164 Cerrado · 201 Desestimada | 🔴 |
| E-050 | Menú de perfil | Enlace a la Sede según el diseño | 174 QA Testing | 🟡 |
| E-057 | Condiciones de uso | La (i) debe mostrar un mensaje de ayuda, como en el diseño, y no abrir la página de Protección de datos | 208 QA Testing | 🟡 el equipo no entiende el requisito |
| E-095 | Aportar documentación | El orden de los estados de carga sigue el de las cards de diseño y está invertido; debe ser cargando → completado → eliminar (papelera) | — | ⚪ |
| E-110 | Agenda | Las cards de notificaciones no siguen el diseño y salen mezcladas | 195 QA Testing · 213 Bloqueada | 🔴 |
| E-111 | Agenda | Cards de citas de primaria: título «Cita de atención Primaria», «Teleconsulta demanda» mal colocada y sobra «C.s. …» | 216 Por hacer | 🟡 |
| E-114 | Salud | Cards de citas pendientes y pasadas: el modo aparece una sola vez como título y «Teleconsulta demanda» va debajo del médico | 215 Por hacer | 🔴 |
| E-123 | Empleo | Card de demanda con las cláusulas aceptadas, según el diseño | 203 QA Testing | 🔴 |
| E-127 | Empleo · Inscripciones | Sobra el título que hay encima de las cards de las ofertas | 203 QA Testing | 🔴 |

## 3. Ajustes gráficos (8)

| ID | Pantalla | Qué falta | Ticket | Situación |
|---|---|---|---|---|
| E-001 | Arranque | Icono de la app (en Android, el logo) | 157 · 217 Bloqueada | 🔴 |
| E-002 | Home no logada | Imagen del molino: en horizontal no se ve bien y en iOS solo asoman las aspas | 179 QA Testing | 🟡 |
| E-036 | Protección de datos | Tamaños de letra sin criterio, el enlace de la AEPD con otro estilo que el de la Sede y un punto suelto bajo la URL de la Sede | — | ⚪ |
| E-039 | Accesibilidad, Aviso legal y Protección de datos | Unificar fuente y tamaño (BDG ve Accesibilidad más grande) | 122 · 170 Cerrado | 🟠 notas contradictorias |
| E-040 | Home logada | En horizontal, las cards de Mis datos se ven enormes | 179 QA Testing | 🟡 |
| E-067 | Carnets | La silueta o mapa de la Comunidad se corta en la tarjeta | 173 Por hacer | 🟠 pendiente del nuevo diseño |
| E-099 | Notificaciones | El mensaje cuando no hay notificaciones no se ve bien | 167 Cerrado | 🟠 notas contradictorias |
| E-122 | Empleo | Sin las cláusulas aceptadas no aparece el título de la card «Mi demanda de empleo» | 166 Cerrado | 🟠 notas contradictorias |

> E-001 aparece en dos bloques porque tiene dos partes: el nombre es UX Writing y el icono es gráfico. En el total cuenta una sola vez.
