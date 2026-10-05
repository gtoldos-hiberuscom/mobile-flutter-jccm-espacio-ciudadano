# Pendiente por arreglar — revisiones de JCCM

> Extracto de `CONSOLIDADO_errores_vs_jira.md` (01/10/2026). Los IDs `E-NNN` son los de ese documento. Aquí solo aparece lo que **no está cerrado**: lo que el revisor marca como no corregido o pendiente, lo que no tiene ticket y lo que sigue abierto en Jira sin validar. Se han quitado los puntos ya corregidos y E-059, que el revisor anotó como «no es incidencia».

**Situación**
- 🔴 El revisor dice que **no está corregido**, aunque el ticket figure como cerrado o en QA.
- 🟠 Pendiente de una decisión, de backend o de UX Writing.
- 🟡 Abierto en Jira (Por hacer, QA Testing o Bloqueada) y sin validar por el revisor.
- ⚪ **Sin ticket** en Jira.

**Total: 57 puntos.** 🔴 15 · 🟠 15 · 🟡 19 · ⚪ 8. Sin ticket hay 9 en total: los 8 ⚪ más E-081, que va contado como 🔴.

---

## Icono, nombre y arranque

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-001 | El icono y el nombre de la app (en Android, el logo) no son correctos; el nombre debe ser «Espacio Ciudadano CLM» | Diseño | 157 · 217 Bloqueada | 🔴 |
| E-002 | La imagen del molino en horizontal y en iOS | Diseño | 179 QA Testing | 🟡 |

## Login, sesión y SSO

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-006 | La biometría no se pide y obliga a identificarse otra vez a los pocos minutos | Funcional | 193 QA Testing | 🟡 |
| E-008 | Cerrar la app sin cerrar sesión y entrar con otro usuario da error de Cerbero, sin salida | Funcional | 224 Bloqueada · 228 En curso | 🟠 pendiente de reunión interna |
| E-009 | Educamos mantiene al usuario anterior tras cambiar de usuario | Funcional | 224 · 228 | 🟠 |
| E-010 | EmpleoCLM y EducamosCLM deben abrirse en el navegador, no dentro de la app | Funcional | 224 Bloqueada | 🟠 |
| E-011 | Con certificado de representante: mostrar «Información y servicios» en Mis datos (Educación da error) | Funcional | 222 QA Testing | 🟡 |
| E-012 | Con certificado de representante no salen expedientes ni registros; hay que enviar `tipodocumento=CIF` | Funcional | 222 QA Testing | 🟡 |
| E-013 | Con certificado de representante: Preferencias debe mostrar los datos del representado | Funcional | 222 QA Testing | 🟡 |

## Aspectos generales y ayuda

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-018 | Quitar la campana superior de todas las páginas | Diseño | — (el caso de prueba de la 151 espera la campana) | ⚪ |
| E-021 | Las preguntas frecuentes deben abrir páginas aparte y estar categorizadas como en la web | Diseño | 187 Por hacer | 🟡 |

## Formulario de soporte

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-027 | Falta el captcha en el formulario sin sesión | Funcional | 212 Cerrado | 🔴 arreglo `48bba08` (30/09) sin entregar |
| E-030 | Falla el envío de la incidencia (sin sesión) | Funcional | 212 · 214 Cerrado | 🔴 mismo arreglo, sin validar |
| E-031 | Enlace al RAT (`rat.castillalamancha.es/detalle/2309`) como enlace externo | UX Writing | 161 Desestimada | ⚪🟠 pendiente de aprobar el texto |

## Protección de datos y contenido legal

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-035 | Texto de protección de datos (inicial y página) actualizado a la última versión | UX Writing | 186 QA Testing (`7dcadf6`) | 🟡 |
| E-036 | Tamaños de letra irregulares, el enlace de la AEPD con otro estilo que el de la Sede y un punto suelto bajo la URL de la Sede | Diseño | — | ⚪ |
| E-039 | Unificar fuente y tamaño entre Accesibilidad, Aviso legal y Protección de datos | Diseño | 122 · 170 Cerrado | 🟠 notas contradictorias |

## Home logada y menú

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-040 | En horizontal, las cards de Mis datos se ven enormes | Diseño | 179 QA Testing | 🟡 |
| E-044 | FAB «Carnets»: etiqueta y despliegue de tipos según el diseño | Diseño | 152 QA Testing | 🟡 |
| E-046 | Mis novedades vacías: mostrar «Notificaciones (0)», «Próximas citas (0)» y los textos de vacío | Diseño | 164 Cerrado · 201 Desestimada | 🔴 |
| E-047 | Mostrar la sección Trámites recomendados con su aviso cuando no hay autorización o hechos vitales | Funcional | 164 Cerrado | 🟠 «¿Lo dejamos así?» sin respuesta |
| E-050 | El enlace a la Sede del menú de perfil, según el diseño | Diseño | 174 QA Testing | 🟡 |

## Preferencias y condiciones de uso

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-055 | Con el usuario 99949991H no carga Preferencias (`/contacto` devuelve 500) | Funcional (backend) | 202 Bloqueada | 🟠 corrección de JCCM |
| E-057 | La (i) de Condiciones de uso debe mostrar un mensaje de ayuda, no la página de Protección de datos | Diseño | 208 QA Testing | 🟡 el equipo no entiende el requisito |
| E-062 | Texto de ayuda de la (i) en Alta en notificaciones | UX Writing | — | ⚪ |

## Carnets digitales

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-065 | En Android, el PKPASS se guarda como `.pkpass.zip` | Funcional | — | ⚪ |
| E-067 | La silueta o mapa de la Comunidad se corta en la tarjeta | Diseño | 173 Por hacer | 🟠 pendiente del nuevo diseño |
| E-071 | En la (i): quitar «contacta con tu centro de salud» y el botón con URL | UX Writing | 199 · 175 Cerrado · 226 Por hacer | 🔴 |

## Gestión: expedientes

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-081 | El listado debe mostrar la oficina tramitadora, no la Consejería | Funcional | — (el caso de prueba de la 182 espera la consejería) | 🔴⚪ |
| E-082 | La fecha de inicio no coincide con la de la web | Funcional | — | ⚪ |

## Gestión: aportar documentación a un expediente de terceros

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-086 | Permitir aportar solo a los expedientes con `adjuntar = X` | Funcional | — | ⚪ |
| E-090 | Si falla una subida, poder quitar ese documento (no solo Reintentar) | Funcional | 185 QA Testing | 🟡 no reproducido |
| E-091 | Reintentar vuelve a subir todos los documentos | Funcional | 185 QA Testing | 🟡 |
| E-093 | Bloquear los expedientes propios, que deben ir por Mis expedientes, con el mismo mensaje que la web | Funcional | 219 QA Testing · 236 Por hacer | 🔴 arreglo `2513ee7` no incluido en la build probada |
| E-094 | El texto de la (i) solo habla de persona autorizada | UX Writing | 236 · 226 Por hacer | 🟠 UX Writing |
| E-095 | El orden de los estados de carga está invertido; debe ser cargando → completado → eliminar | Diseño | — | ⚪ |

## Gestión: notificaciones

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-099 | El mensaje cuando no hay notificaciones | Diseño | 167 Cerrado | 🟠 notas contradictorias |
| E-106 | Un usuario sin alta en Notifica recibe un error al editar el contacto; debería ofrecerle darse de alta | Funcional (backend) | 202 Bloqueada | 🟠 la API devuelve 500 |
| E-107 | En las expiradas, solo debe poder descargarse el acuse de recibo, no el documento | Funcional | 221 QA Testing | 🔴 |

## Agenda

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-109 | El mensaje «No hemos podido cargar tus citas sanitarias» para un usuario sin CIP | UX Writing | 195 QA Testing | 🟡 |
| E-110 | Cards de notificaciones según el diseño, sin mezclar | Diseño | 195 QA Testing · 213 Bloqueada | 🔴 |
| E-111 | Cards de citas de primaria según el diseño (título, «Teleconsulta demanda», sobra «C.s. …») | Diseño | 216 Por hacer | 🟡 |

## Mis datos

| ID | Qué falta | Tipo | Ticket | Situación |
|---|---|---|---|---|
| E-113 | Que la (i) y el mensaje de «no hay datos» coincidan (Inscripciones, Bienes inmuebles, Carnets, Vehículos y Domicilio) | UX Writing | 226 Por hacer | 🟠 UX Writing |
| E-114 | **Salud**: cards de citas pendientes y pasadas según el diseño | Diseño | 215 Por hacer | 🔴 |
| E-115 | **Salud**: mensaje para un usuario sin CIP («servicio no disponible») | UX Writing | 196 QA Testing · 227 Por hacer | 🟠 UX Writing |
| E-122 | **Empleo**: título de la card «Mi demanda de empleo» sin las cláusulas aceptadas | Diseño | 166 Cerrado | 🟠 notas contradictorias |
| E-123 | **Empleo**: card de demanda con las cláusulas aceptadas, según el diseño | Diseño | 203 QA Testing | 🔴 |
| E-124 | **Empleo**: «Tu demanda de empleo» → «Mi demanda de empleo» | UX Writing | 203 QA Testing | 🟡 |
| E-125 | **Empleo**: en PRE no hay datos y la app dice «Activa» | Funcional | 203 QA Testing | 🟡 |
| E-126 | **Empleo**: sin la cláusula AGE sale «INSCRIPCIÓN NO ACTIVA»; solo debe salir el aviso de autorizar | Funcional | 220 QA Testing | 🔴 |
| E-127 | **Empleo**: sobra el título que hay encima de las ofertas en Inscripciones | Diseño | 203 QA Testing | 🔴 |
| E-128 | **Empleo**: texto y URL del Portal de empleabilidad en el mensaje de «no hay datos» | UX Writing | 211 Cerrado · 226 · 233 Por hacer | 🔴 |
| E-129 | **Empleo**: sin inscripciones sale la (i) en vez de «no se han encontrado datos» | UX Writing | 233 Por hacer | 🟡 |
| E-133 | **Bienes inmuebles**: al volver del detalle debe quedarse en el filtro en el que se estaba (Urbano o Rústico) | Funcional | 197 QA Testing | 🟡 |
| E-134 | **Domicilio**: la web muestra más datos que la app | Funcional | 198 QA Testing | 🟠 la API no los envía |
| E-135 | **Domicilio** sin datos: quitar el botón del Ayuntamiento | UX Writing | 235 Por hacer | 🟠 UX Writing |
| E-139 | **Educación**: URL de títulos universitarios y texto del mensaje de «no hay datos» | UX Writing | 210 Cerrado (no está en la 226) | 🔴 |
