# Consolidado de errores de las revisiones de JCCM — cruce con Jira JCCMEC

> Generado el 01/10/2026 a partir de los 5 documentos de `documentation/ReportesBugs/` y de una consulta **de solo lectura** a Jira (proyecto JCCMEC, tickets 1–236). En Jira no se ha cambiado nada.
> Los DNI de personas reales se han enmascarado. Los usuarios de prueba de Cl@ve (99999999R, 99949991H) se dejan tal cual.

## Fuentes

| Código | Documento | Fechas que cubre | ¿Lleva notas del revisor? |
|---|---|---|---|
| **H2** | `20260720-Pruebas Hito2.docx` | 20/07 y 06/08 | No |
| **R31** | `20260831_Revision_version31082026.docx` | 31/08, 03/09, 04/09, 07/09, 08/09, 10/09, 11/09 | Sí: comentarios de BDG y LAR del 15 al 18/09 |
| **R14** | `20260914_Revision_version14092026.docx` | 14, 15, 16, 17 y 18/09 | Pocas: LAR (23/09), BDG (17 y 21/09) y JCJ (21/09) |
| **R21** | `20260921_Revision_version21092026.docx` | 21, 22, 23 y 24/09 | Sí: LAR (23 y 28/09), BDG (28 y 29/09) y JCJ (28 y 29/09) |
| **R28** | `20260928_Revision_version28092026.docx` | 28/09 | No |

## Leyenda

- **Tipo**: **Funcional**: comportamiento, datos o integración. **Diseño**: UI, maquetación o diferencias con Figma. **UX Writing**: textos, literales, mensajes y URL de contacto.
- **Nota**: la última anotación del revisor. ✔ corregido · ✘ no corregido · ◐ corregido a medias o notas que se contradicen · ⏸ pendiente de decidir o de otro equipo · — sin nota.
- **Coherencia** entre el estado del ticket y la nota:
  - ✅ coherente
  - ⚠️ incoherente: el ticket está cerrado o en QA y el revisor dice que no está corregido, o al revés
  - ❓ no se puede comprobar porque no hay nota
  - 🚫 no hay ticket

---

## 1. Resumen: lo que hay que mirar

### 1.1 Incoherencias entre el estado del ticket y la nota del revisor (⚠️)

| ID | Error | Ticket(s) y estado | Qué no cuadra |
|---|---|---|---|
| E-046 | Mis novedades vacías: faltan «Notificaciones (0)» y «Próximas citas (0)» | 164 **Cerrado**, 201 **Desestimada** | LAR (15/09): «Debería aparecer Notificaciones (0) y Próximas citas (0)». Sigue sin estar, y no queda ningún ticket vivo. |
| E-047 | La sección Trámites recomendados desaparece sin autorización o sin hechos vitales | 164 **Cerrado** | BDG (15/09): «La sección sigue sin aparecer ¿Lo dejamos así?». Se cerró sin responder a la pregunta. |
| E-030 | Error al enviar el formulario de soporte | 212 **Cerrado**, 214 **Cerrado** (161 Desestimada) | LAR (15/09) «No corregido», y el 23/09 se vuelve a reportar sin nota de corrección. El arreglo (`48bba08`: sin sesión, el formulario abre la web) es del **30/09** y está en `release`. JCCM todavía no lo ha validado. |
| E-027 | Falta el captcha en el formulario no logado | 212 **Cerrado** (161 Desestimada, 59 Desestimada) | LAR (15/09) «NO CORREGIDO». Se resuelve con el mismo cambio del 30/09 (abrir la web), que nadie ha revisado. |
| E-031 | Enlace al RAT del formulario de soporte | 161 **Desestimada** | Nota «Pendiente aprobar texto final», pero el único ticket está desestimado y 212 no lo recoge. |
| E-071 | La (i) de Carnets dice «contacta con tu centro de salud»: hay que quitar la frase y el botón | 199 **Cerrado**, 175 **Cerrado**, 206 Desestimada | Se vuelve a reportar el 23/09 y sigue en la lista de UX Writing del 28/09. En 175, G.T. comenta el 01/10 que «la url va a algo de sanidad». |
| E-072 | Carnet Joven: el botón PDF queda oculto | 206 **Desestimada** | LAR (28/09) «corregido», pero el único ticket que lo recoge está desestimado y el cambio queda sin trazabilidad. Inconsistencia leve. |
| E-093 | Aportar documentación a terceros deja usar expedientes propios | 219 **QA Testing**, 236 Por hacer | LAR (28/09) «no corregido» y se repite en R28. 219 no debería estar en QA. El arreglo `2513ee7` está en `release`/`develop`, pero no en la build que se probó. |
| E-107 | Notificaciones expiradas: solo debe poder descargarse el acuse de recibo | 221 **QA Testing** | LAR (28/09) «no corregida» y se repite en R28. JCJ preguntó el 29/09 si era el comportamiento esperado o el error. |
| E-126 | Empleo sin la cláusula AGE muestra «INSCRIPCIÓN NO ACTIVA» | 220 **QA Testing** | LAR (28/09) «no corregido» y se repite en R28. |
| E-110 | Las cards de notificaciones de la Agenda no siguen el diseño | 195 **QA Testing**, 213 Bloqueada | LAR (28/09) «No corregida». 213 (Bloqueada) cuadra; 195 en QA Testing no. |
| E-139 | Educación: texto y URL del mensaje cuando no hay datos | 210 **Cerrado** | G.T. lo cerró el 01/10 («uxwriting… lo cierro»), pero Educación **no figura** en la lista de 226 (Revisión UX Writing): el traslado no ha quedado registrado. |
| E-128 | Inscripciones en ofertas: texto y URL del mensaje cuando no hay datos | 211 **Cerrado** | Se cerró el 01/10 por ser UX Writing. Sí está en 226 y en 233 (Por hacer), así que el trabajo sigue vivo, pero 211 se cerró sin corregirlo. |

### 1.2 Errores sin ticket en Jira (🚫)

| ID | Error | Última nota |
|---|---|---|
| E-018 | Quitar la campana superior de todas las páginas. Además, el caso de prueba de JCCMEC-151 espera **encontrarla** en el AppBar. | — (H2) |
| E-031 | Enlace al RAT: solo lo recogía 161, que está desestimado | ⏸ Pendiente aprobar texto final |
| E-036 | Protección de datos: tamaños de letra irregulares, el enlace de la AEPD con otro estilo y un punto suelto bajo la URL de la Sede | — (R28) |
| E-060 | Hechos vitales: «Cancelar» abría «Borrar tus preferencias» | ✔ corregido |
| E-062 | Alta en notificaciones: texto de ayuda de la (i) | — (R31) |
| E-065 | El PKPASS se guarda como `.pkpass.zip` en Android | — (H2) |
| E-070 | Renombrar PKPASS a «Cartera digital» | ✔ corregido |
| E-081 | El listado de expedientes muestra la Consejería y la web la oficina tramitadora. Además, el caso de prueba de JCCMEC-182 espera la consejería. | ✘ no corregido (28/09) |
| E-082 | Las fechas de inicio de los expedientes no coinciden entre web y app | — (R28) |
| E-086 | Solo se debe poder aportar documentación a los expedientes con `adjuntar = X` | — (H2) |
| E-095 | El orden de los estados de carga en Aportar documentación está invertido | — (R28) |

Por qué E-059 (botones Guardar/Cancelar de Hechos vitales) no está en esta tabla: el revisor anotó que «No es incidencia, lo tienen que cambiar en diseño», así que no necesita ticket.

### 1.3 Duplicados en Jira (el mismo error en varios tickets)

| Error | Tickets |
|---|---|
| Icono y nombre de la app | 157 y 217 (los dos Bloqueada) |
| Formulario de soporte | 161 (Desestimada), 212 y 214 (Cerrado), y antes 109, 110 y 134 |
| Aportar documentación a expedientes propios | 219 (QA Testing) y 236 (Por hacer) |
| Domicilio sin datos | 234 (Desestimada) y 235 (Por hacer) |
| Sesión y SSO al cambiar de usuario | 224 (Bloqueada) y 228 (En curso) |
| Carnets (i) | 175, 199 y 206 |

---

## 2. Lista completa por pantalla

### 2.1 Icono, nombre y arranque

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-001 | El icono y el nombre de la app no son correctos (en Android, el logo); el nombre debe ser «Espacio Ciudadano CLM» | Diseño | R31, R21, R28 | ✘ «No corregido» (LAR 28/09) | 157 Bloqueada · 217 Bloqueada | ✅ |
| E-002 | La imagen del molino queda detrás de los botones; en horizontal no se ve bien y en iOS solo asoman las aspas | Diseño | H2 | — | 101 Cerrado · 179 QA Testing (orientación) | ❓ |
| E-003 | Al abrir la app, la Home no logada tapa la barra de estado | Diseño | R31 | ✔ (LAR 15/09) | 159 Cerrado | ✅ |

### 2.2 Login, sesión y SSO

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-004 | Tras caducar la sesión, el login devuelve a la Home no logada | Funcional | H2 | — | 102 Cerrado | ❓ |
| E-005 | Tras identificarse se ve un instante la Home no logada antes de la logada (parpadeo) | Funcional | H2 | — | 103 Cerrado | ❓ |
| E-006 | Con la biometría activada no la pide y hay que volver a identificarse a los pocos minutos | Funcional | H2 | — | 104 Cerrado · 193 QA Testing | ❓ |
| E-007 | Tras un rato de inactividad la app se bloquea; al reabrirla, el spinner no termina y acaba en error | Funcional | R31 | ✔ (BDG 15/09) | 158 Cerrado | ✅ |
| E-008 | Cerrar la app sin cerrar sesión y entrar con otro usuario da error de Cerbero, sin salida posible | Funcional | R21 | ⏸ «pendiente de una reunión interna» (BDG 28/09) | 224 Bloqueada · 228 En curso | ✅ |
| E-009 | Tras cerrar sesión y entrar con otro usuario, Educamos sigue con el usuario anterior | Funcional | R21 | ⏸ (misma reunión) | 224 · 228 | ✅ |
| E-010 | EmpleoCLM y EducamosCLM se abren dentro de la app y deberían abrirse en el navegador | Funcional | R21 | — | 224 Bloqueada | ✅ |
| E-011 | Con certificado de representante, Mis datos debe dejar ver «Información y servicios»; ahora Educación muestra un error | Funcional | R21 | — | 222 QA Testing | ❓ |
| E-012 | Con certificado de representante no salen expedientes ni registros. La API indica que hay que enviar `tipodocumento=CIF` y no `NIF` | Funcional | R21 | ⏸ diagnóstico de la API (BDG 29/09) | 222 QA Testing (arreglo relacionado: `2513ee7`) | ❓ |
| E-013 | Con certificado de representante, Preferencias debe mostrar los datos del representado | Funcional | R21 | — | 222 QA Testing | ❓ |

### 2.3 Saber más y aspectos generales

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-014 | «Saber más»: demasiados formatos de fuente | Diseño | H2, R31 | — | 163 Cerrado | ❓ |
| E-015 | «Acceder» desde «Saber más» no avisa de que se accede con Cl@ve | Funcional | R31 | ✔ (LAR 15/09) | 163 Cerrado | ✅ |
| E-016 | No se avisa al salir a un enlace externo | Funcional | H2 | — | 105 Cerrado | ❓ |
| E-017 | Sobra el icono (i) en Aviso legal, Protección de datos, Accesibilidad, Bienestar, Educación y Vivienda | Diseño | H2 | — | 106 Cerrado | ❓ |
| E-018 | Quitar la campana superior de todas las páginas (no hay push en esta versión) | Diseño | H2 | — | **Ninguno**. El caso de prueba de 151 espera la campana. | 🚫 |
| E-019 | Lupa de búsqueda en Protección de datos; ponerla también en Aviso legal | Diseño | H2 | — | 107 Cerrado | ❓ |
| E-020 | No hay diseño de estado vacío para Registros, Expedientes, Notificaciones y Carnets | Diseño | H2 | — | 126 · 167 · 168 Cerrado | ❓ |

### 2.4 Ayuda y contacto

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-021 | Las preguntas frecuentes son un acordeón y en el diseño abren páginas aparte; hay que categorizarlas como en la web | Diseño | H2 | — | 108 Cerrado · 187 Por hacer | ❓ |
| E-022 | El texto de las respuestas tiene poco contraste | Diseño | H2 | — | 108 Cerrado | ❓ |
| E-023 | Falta espacio inferior: el contenido queda bajo los controles del sistema | Diseño | H2 | — | 108 Cerrado | ❓ |
| E-024 | URL incorrectas de Guías de ayuda y del listado de Oficinas | UX Writing | H2 | — | 108 Cerrado | ❓ |
| E-025 | Las preguntas frecuentes se cortan por abajo | Diseño | R31 | ✔ (BDG 15/09) | 160 Cerrado · 149 Cerrado | ✅ |

### 2.5 Formulario de soporte

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-026 | El captcha parece un control deshabilitado y no se entiende que hay que pulsarlo | Diseño | H2 | — | 110 · 134 Cerrado | ❓ |
| E-027 | Falta el captcha (formulario no logado) | Funcional | R31, R14 (16 y 17/09) | ✘ «NO CORREGIDO» (LAR 15/09) | 212 Cerrado · 161 Desestimada | ⚠️ |
| E-028 | El placeholder de «Confirmar correo» no es un ejemplo de email | UX Writing | H2 | — | 110 Cerrado | ❓ |
| E-029 | El check de consentimiento de protección de datos sale también con sesión iniciada | Funcional | H2 | — | 110 Cerrado | ❓ |
| E-030 | Falla el envío. Sin sesión: «No tienes permisos». Con sesión: «No hemos podido enviar…». El 17/09 con sesión ya funcionaba y sin sesión no | Funcional | H2, R31, R14 (16 y 17/09), R21 (23/09) | ✘ «No corregido» (LAR 15/09); reportado de nuevo el 23/09 | 109 Cerrado · 212 Cerrado · 214 Cerrado | ⚠️ |
| E-031 | La URL del RAT aparece como texto y no avisa de que es externa; la buena es `rat.castillalamancha.es/detalle/2309` | UX Writing | H2, R31 | ⏸ «Pendiente aprobar texto final» | 161 Desestimada | ⚠️🚫 |

### 2.6 Primer inicio, consentimiento y protección de datos

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-032 | Los botones de la primera página deben ser «Salir» y «Continuar», no «Aceptar» | UX Writing | H2 | — | 111 · 88 Cerrado | ❓ |
| E-033 | El texto de las cláusulas no coincide con la web: solo se usa `textoCheck` | UX Writing | H2 | — | 113 Cerrado | ❓ |
| E-034 | Al marcar la cláusula 3 (recomendaciones) debe llevar a elegir los hechos vitales | Funcional | H2 | — | 112 Cerrado | ❓ |
| E-035 | El texto de protección de datos (pantalla inicial y página) no está actualizado con la última versión oficial | UX Writing | R21 (22/09) | — | 186 QA Testing (arreglo `7dcadf6`, 01/10) · 156 Cerrado | ✅ |
| E-036 | Protección de datos: tamaños de letra sin criterio, el enlace de la AEPD con otro estilo que el de la Sede y un punto suelto bajo esa URL | Diseño | R28 | — | **Ninguno** (el antecedente, 170, está cerrado) | 🚫 |
| E-037 | Protección de datos: el texto se corta por abajo y no se ve el email | Diseño | R31 | ✔ (BDG y LAR 16/09) | 170 Cerrado | ✅ |
| E-038 | Accesibilidad: el texto se corta por abajo | Diseño | R31 | ✔ (BDG 16/09) | 170 Cerrado | ✅ |
| E-039 | Accesibilidad, Aviso legal y Protección de datos: unificar fuente y tamaño | Diseño | H2, R31 | ◐ LAR «corregido» / BDG «REVISAR, accesibilidad parece más grande» | 122 · 170 Cerrado | ◐ |

### 2.7 Home logada

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-040 | En horizontal, las cards de Mis datos se ven enormes | Diseño | H2 | — | 179 QA Testing · 94 Cerrado | ❓ |
| E-041 | Falta el botón «Ir a recomendaciones» | Diseño | H2 | — | 114 Cerrado | ❓ |
| E-042 | En los hechos vitales de los trámites recomendados se ve la unidad y no debería | Diseño | H2 | — | 115 Cerrado | ❓ |
| E-043 | Los trámites recomendados salen todos en «Últimos días» y no coinciden con la web | Funcional | H2 | — | 116 Cerrado | ❓ |
| E-044 | El FAB no lleva la etiqueta «Carnets» y no despliega los tipos de carnet | Diseño | H2 | — | 117 · 85 Cerrado · 152 QA Testing | ❓ |
| E-045 | «Bienestar Social» se corta en la card | Diseño | H2 | — | 118 Cerrado | ❓ |
| E-046 | Mis novedades sin datos: solo sale el título. Faltan «Notificaciones (0)», «Próximas citas (0)» y los textos de vacío | Diseño | R31, R14 (15/09) | ✘ (LAR 15/09) | 164 Cerrado · 201 Desestimada | ⚠️ |
| E-047 | Sin autorización o sin hechos vitales desaparece la sección Trámites recomendados; debería salir con su aviso | Funcional | R31 | ⏸ «¿Lo dejamos así?» (BDG 15/09) | 164 Cerrado | ⚠️ |
| E-048 | Quitar «Estado» de los trámites recomendados | Diseño | R31 | ✔ (BDG 15/09) | 165 Cerrado | ✅ |

### 2.8 Menú de perfil

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-049 | Las iniciales del avatar siempre son «AM» | Funcional | H2 | — | 119 Cerrado | ❓ |
| E-050 | El enlace a la Sede no sigue el diseño | Diseño | H2 | — | 119 Cerrado · 174 QA Testing | ❓ |
| E-051 | «Hola, Nombre Apellido1 Apellido2» es demasiado largo; debe ser «Hola, Nombre» | UX Writing | H2 | — | 119 Cerrado | ❓ |
| E-052 | La etiqueta «NIF/NIE» no sirve para persona jurídica | UX Writing | H2 | — | 135 Cerrado | ❓ |

### 2.9 Preferencias, condiciones de uso y hechos vitales

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-053 | Falta espacio inferior: el botón Eliminar queda bajo los controles del sistema | Diseño | H2 | — | 120 Cerrado | ❓ |
| E-054 | La (i) de Preferencias muestra un aviso con aspecto de error en vez de la ventana de información | Diseño | H2 | — | 120 Cerrado | ❓ |
| E-055 | Con el usuario 99949991H no carga Preferencias: `/contacto` devuelve 500 | Funcional (backend) | R14 (15/09) | ⏸ backend confirma el 500 (BDG 21/09) | 202 Bloqueada | ✅ |
| E-056 | La (i) de Condiciones de uso abre Protección de datos con «Salir»/«Continuar»; debe llevar flecha de volver | Funcional | R31 | ✔ (BDG y LAR 16/09) | 170 · 153 Cerrado | ✅ |
| E-057 | La (i) de Condiciones de uso debería mostrar un mensaje de ayuda, como en el diseño, y no la página de Protección de datos | Diseño | R14 (16/09) | — | 208 QA Testing (JCJ: «no entiendo a qué se refieren») | ❓ |
| E-058 | Mis hechos vitales: la (i) no muestra nada | Funcional | R31 | ✔ (BDG y LAR 16/09) | 171 Cerrado | ✅ |
| E-059 | Hechos vitales: Guardar/Cancelar frente a Aceptar/Desmarcar todo del diseño | UX Writing | R31 (03/09) | ⏸ «No es incidencia, lo tienen que cambiar en diseño» | — (no procede) | ✅ |
| E-060 | Hechos vitales: «Cancelar» abría «Borrar tus preferencias»; debe desmarcar todo | Funcional | R31 (03/09) | ✔ (BDG y LAR 16/09) | **Ninguno** | 🚫 |
| E-061 | Al revocar la cláusula de recomendaciones no se borran los hechos vitales | Funcional | H2 | — | 121 Cerrado | ❓ |
| E-062 | Alta en notificaciones: texto de ayuda de la (i) | UX Writing | R31 | — | **Ninguno** | 🚫 |

### 2.10 Carnets digitales

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-063 | Sin la cláusula manda a Preferencias y no a Condiciones de uso | Funcional | H2 | — | 123 Cerrado | ❓ |
| E-064 | Un usuario con Carnet Joven recibe «No hemos podido cargar tus carnets» | Funcional | H2 | — | 123 Cerrado | ❓ |
| E-065 | En Android, el PKPASS se guarda como `.pkpass.zip` y Wallet no lo abre | Funcional | H2 | — | **Ninguno específico** (51 es el transversal) | 🚫 |
| E-066 | «Cartera digital» no abre Wallet y descarga el fichero | Funcional | R31 (07/09), R14 (16/09), R21 (21/09) | ✔ (LAR 28/09) | 223 QA Testing (iOS no es posible) · 206 Desestimada | ✅ (se podría cerrar salvo iOS) |
| E-067 | La silueta o mapa de la Comunidad se corta en la tarjeta | Diseño | R31 (08/09), R14 (16/09) | ⏸ pendiente del nuevo diseño | 173 Por hacer · 206 Desestimada | ✅ |
| E-068 | Los formatos de descarga salen entre signos «+» | Diseño | R31 (08/09) | ✔ (BDG 15/09) | 176 Cerrado | ✅ |
| E-069 | Sale resaltado PDF en vez de QR; tras la demo, que no haya ninguno resaltado | Diseño | R31 (08 y 10/09) | ✔ (BDG 15/09) | 176 Cerrado | ✅ |
| E-070 | Renombrar «PKPASS» a «Cartera digital» en las dos plataformas | UX Writing | R31 (10 y 11/09) | ✔ (BDG 15/09) | **Ninguno** | 🚫 |
| E-071 | La (i) dice «contacta con tu centro de salud»: quitar la frase y el botón con URL, porque cada carnet es de un organismo distinto | UX Writing | R14 (14 y 16/09), R21 (22 y 23/09), R28 (lista UX) | ✘ reportado de nuevo el 23/09 y en la lista del 28/09 | 199 Cerrado · 175 Cerrado · 206 Desestimada · 226 Por hacer | ⚠️ |
| E-072 | Carnet Joven: el PDF queda oculto; hay que ajustar la altura | Diseño | R14 (16/09), R21 (23/09) | ✔ (LAR 28/09) | 206 Desestimada (176 Cerrado, botón cortado) | ⚠️ leve |
| E-073 | Mensaje de cláusula no autorizada tras la nueva cláusula de carnets | UX Writing | R14 (16/09) | — | 180 Cerrado | ❓ |

### 2.11 Recomendaciones

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-074 | Sin hechos vitales abre Preferencias y no Hechos vitales; el aviso de personalizar sale siempre | Funcional | H2 | — | 124 Cerrado | ❓ |
| E-075 | El filtro por categorías no funciona y todo sale en «Últimos días» | Funcional | H2 | — | 124 Cerrado | ❓ |
| E-076 | El mensaje de «no hay recomendaciones» no sigue Figma y falta el de filtro sin resultados | UX Writing | H2 | — | 124 Cerrado | ❓ |
| E-077 | «Últimos días» muestra un trámite que la web no tiene | Funcional | R14 (14/09) | ✔ «No se produce el error» (BDG 17/09) | 200 Cerrado | ✅ |

### 2.12 Gestión: expedientes

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-078 | Expedientes que parecen simulados: el estado sale como código, el asunto siempre es «Entrada Registro Único» y falla el registro de documentación | Funcional | H2 | — | 125 Cerrado | ❓ |
| E-079 | Se mezclan expedientes con entradas de registro | Funcional | H2 (06/08) | — | 138 · 139 Cerrado | ❓ |
| E-080 | El nombre del expediente o procedimiento difiere entre web y app, también en Aportar documentación y en el justificante | Funcional | R14 (16/09), R21 (21 y 23/09) | ✔ (LAR 28/09, dos notas) | 218 Cerrado · 207 QA Testing | ✅ (207 se podría cerrar) |
| E-081 | En el listado, la app muestra la Consejería y la web la oficina tramitadora | Funcional | R21 (23/09), R28 | ✘ «no corregido» (LAR 28/09) | **Ninguno**. El caso de prueba de 182 espera la consejería. | 🚫 |
| E-082 | La fecha de inicio difiere entre web y app para el mismo expediente | Funcional | R28 | — | **Ninguno** | 🚫 |
| E-083 | El calendario de los filtros se corta por la derecha (Registros y Expedientes) | Diseño | R31 (04/09), R14 (16/09), R21 (23/09) | ✔ (LAR 28/09) | 209 Cerrado | ✅ |

### 2.13 Gestión: registros

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-084 | El título muestra el código SIACI y no el asunto, tanto en la lista como en el detalle | Funcional | H2 | — | 126 Cerrado | ❓ |
| E-085 | Sin datos, el mensaje tiene poco contraste o no se ve bien | Diseño | H2, R31 | ✔ (BDG 16/09) | 126 · 168 Cerrado | ✅ |

### 2.14 Gestión: aportar documentación a un expediente de terceros

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-086 | Solo se debe poder aportar a los expedientes con `adjuntar = X` | Funcional | H2 | — | **Ninguno** | 🚫 |
| E-087 | El botón «Registrar documentos aportados» sale sin documentos | Funcional | R31 | ✔ (LAR 16/09) | 169 Cerrado | ✅ |
| E-088 | La subida no empieza al seleccionar los documentos | Funcional | R31 | ✔ (LAR 16/09) | 169 Cerrado | ✅ |
| E-089 | «Cancelar» en un documento cancela todos | Funcional | R31 | ✔ (LAR 16/09) | 169 Cerrado | ✅ |
| E-090 | Si falla una subida, solo se ofrece Reintentar: no se puede quitar el documento | Funcional | R31 | ⏸ «No he podido reproducirlo» (LAR 16/09) | 169 Cerrado · 185 QA Testing | ❓ |
| E-091 | Reintentar vuelve a subir todos los documentos | Funcional | R31 | — | 169 Cerrado · 185 QA Testing | ❓ |
| E-092 | «Eliminar» en un documento ya subido no hace nada | Funcional | R31 | ✔ (LAR 16/09) | 169 Cerrado | ✅ |
| E-093 | Deja aportar a expedientes propios, que deben ir por Mis expedientes; mensaje alineado con la web | Funcional | R21 (23/09), R28 | ✘ «no corregido» (LAR 28/09) | 219 QA Testing · 236 Por hacer | ⚠️ |
| E-094 | El texto de la (i) solo habla de persona autorizada; revisarlo junto con el mensaje de la web | UX Writing | R21 (23/09), R28 | ⏸ «UX Writing» (LAR 28/09) | 236 · 226 Por hacer | ✅ |
| E-095 | El orden de los estados de carga está invertido (papelera → cargando → completado); debe ser cargando → completado → eliminar | Diseño | R28 | — | **Ninguno** | 🚫 |

### 2.15 Gestión: notificaciones

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-096 | El listado se ve, pero no se puede acceder a las notificaciones | Funcional | H2 | — | 127 Cerrado | ❓ |
| E-097 | Editar datos de contacto: la información sale con aspecto de error | Diseño | R31 | ✔ (BDG y LAR 16/09) | 167 Cerrado | ✅ |
| E-098 | En las cards faltan el procedimiento y la fecha de expiración | Diseño | R31 | ✔ (LAR 16/09) | 167 Cerrado | ✅ |
| E-099 | Sin notificaciones, el mensaje no se ve bien | Diseño | R31 | ◐ LAR «Corregido» / BDG «Pendiente revisar el mensaje» | 167 Cerrado | ◐ |
| E-100 | En el detalle de una aceptada faltan documentos: siempre el mismo, llamado «Documento_1.pdf», y sin acuse de recibo | Funcional | R31, R14 (14/09), R21 (21/09) | ✔ acuse corregido (LAR 28/09) | 167 · 194 Cerrado | ✅ |
| E-101 | Entrando desde «Todo» no sale el botón Aceptar | Funcional | R31 | ✔ (BDG y LAR 16/09) | 167 Cerrado | ✅ |
| E-102 | Falta «Procedimiento» en el detalle | Diseño | R31 | ✔ (BDG y LAR 16/09) | 167 Cerrado | ✅ |
| E-103 | Falta la confirmación antes de aceptar | Funcional | R31 | ✔ (BDG 15/09) | 167 Cerrado | ✅ |
| E-104 | Al aceptar vuelve al listado y no al detalle con los documentos | Funcional | R31 | ✔ (BDG y LAR 16/09) | 167 Cerrado | ✅ |
| E-105 | Con el usuario 99999999R: «No se han podido cargar las notificaciones», cuando en la web sí cargan | Funcional | R14 (14/09) | — | 204 Cerrado (se limitó a 10 páginas por un 429) | ❓ |
| E-106 | Usuario sin alta en Notifica: editar el contacto da error; la web le ofrece darse de alta | Funcional (backend) | R14 (15/09) | ⏸ la API devuelve 500; JCCM «subimos corrección» (BDG 21/09) | 202 Bloqueada | ✅ |
| E-107 | Expiradas: solo debe poder descargarse el acuse de recibo, no el documento. Era un error de la web que se copió a la app | Funcional | R21 (23/09), R28 | ✘ «no corregida» (LAR 28/09) | 221 QA Testing | ⚠️ |

### 2.16 Agenda

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-108 | Citas de primaria que parecen simuladas y cards que no siguen el diseño | Funcional | H2 | — | 128 Cerrado | ❓ |
| E-109 | «No hemos podido cargar tus citas sanitarias» con un usuario sin CIP del SESCAM | UX Writing | R14 (14/09) | — | 195 QA Testing | ❓ |
| E-110 | Las cards de notificaciones son distintas al diseño y salen mezcladas | Diseño | R14 (14 y 16/09), R21 (23/09), R28 | ✘ «No corregida» (LAR 28/09) | 195 QA Testing · 213 Bloqueada | ⚠️ (195) / ✅ (213) |
| E-111 | Cards de citas de primaria: título «Cita de atención Primaria», «Teleconsulta demanda» mal colocada y sobra «C.s. …» | Diseño | R14 (18/09) | — | 216 Por hacer | ✅ |

### 2.17 Mis datos: aspectos comunes

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-112 | En todas las secciones: URL de enlaces y trámites, trámites antes que enlaces, (i) con su botón de contacto y mensaje de «no hay datos» | UX Writing | H2 | — | 129 · 79 Cerrado | ❓ |
| E-113 | Que la (i) y el mensaje de «no hay datos» coincidan en organismo y contacto (Inscripciones, Bienes inmuebles, Carnets, Vehículos y Domicilio) | UX Writing | R21 (23/09), R28 | ⏸ pendiente de sincronizar con UX Writing | 226 Por hacer | ✅ |

### 2.18 Mis datos: salud

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-114 | Cards de citas pendientes y pasadas: el modo sale repetido y «Teleconsulta demanda» va arriba cuando debe ir debajo del médico | Diseño | H2, R31, R14 (18/09), R28 | ✘ «sigue sin seguir diseño» (BDG 18/09) · «comprobar» (LAR 23/09) | 215 Por hacer (antes, 166) | ✅ |
| E-115 | Usuario sin CIP: «servicio no disponible»; UX va a revisar el mensaje | UX Writing | H2, R14 (14/09) | ⏸ | 196 QA Testing · 227 Por hacer (ventana de info de Salud) | ❓ |

### 2.19 Mis datos: bienestar social

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-116 | Familia numerosa pide aceptar una cláusula que ya está aceptada y dice que no hay título (en la web sí lo hay) | Funcional | H2 | — | 130 Cerrado · 75 Desestimada | ❓ |
| E-117 | En «Categoría» sale «G» en vez de la descripción | Funcional | R31 | ✔ (BDG 18/09) | 166 Cerrado | ✅ |
| E-118 | La información de la (i) aparece también fija abajo | Diseño | R31 | ✔ (BDG 18/09) | 166 Cerrado | ✅ |
| E-119 | URL de contacto de la (i) incorrecta | UX Writing | R31 | ✔ (BDG 15/09) | 166 Cerrado | ✅ |

### 2.20 Mis datos: empleo

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-120 | Dice que no hay inscripciones y en la web sí las hay | Funcional | H2 | — | 131 Cerrado | ❓ |
| E-121 | El enlace de contacto de la (i) (SEPE) es incorrecto | UX Writing | R31 | ✔ (BDG 15/09) | 166 Cerrado | ✅ |
| E-122 | Sin las cláusulas no sale el título de la card «Mi demanda de empleo» | Diseño | R31 | ◐ BDG «Pendiente» (16/09) / LAR «Corregido» (15/09) | 166 Cerrado | ◐ |
| E-123 | Con las cláusulas aceptadas, la card de demanda no sigue el diseño | Diseño | R31, R14 (15/09) | ✘ «No corregido» (LAR 15/09) | 203 QA Testing | ❓ (sin nota posterior) |
| E-124 | «Tu demanda de empleo» debe ser «Mi demanda de empleo» | UX Writing | R14 (15/09) | — | 203 QA Testing | ❓ |
| E-125 | En PRE no hay datos de demanda y la app dice «Activa» | Funcional | R14 (15/09) | — | 203 QA Testing | ❓ |
| E-126 | Sin la cláusula AGE sale «INSCRIPCIÓN NO ACTIVA»; solo debe salir el aviso de autorizar | Funcional | R21 (23/09), R28 | ✘ «no corregido» (LAR 28/09) | 220 QA Testing | ⚠️ |
| E-127 | Card de inscripción: falta la fecha de fin, el estado se ve distinto y sobra un título encima de las ofertas | Diseño | R31, R14 (15/09) | ◐ card corregida, pero sobra el título (BDG 15/09) | 203 QA Testing | ✅ |
| E-128 | Inscripciones: texto y URL del Portal de empleabilidad en la (i) y en el mensaje de «no hay datos» | UX Writing | R31, R14 (16/09), R21 (23/09), R28 | ◐ (i) corregida, falta el mensaje de «no hay datos» (LAR 15/09) | 211 Cerrado · 226 · 233 Por hacer | ⚠️ leve |
| E-129 | Sin inscripciones sale la información de la (i) en vez del mensaje de «no se han encontrado datos» | UX Writing | R28 | — | 233 Por hacer (probable) | ❓ |

### 2.21 Mis datos: vivienda y vehículos

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-130 | Bienes inmuebles: cambiar «ESTADO» por «Uso» en las cards | Diseño | H2 | — | 132 Cerrado | ❓ |
| E-131 | Bienes inmuebles: falta el contacto de Catastro en la (i) | UX Writing | R31 | ✔ (BDG 15/09) | 166 Cerrado | ✅ |
| E-132 | Bienes inmuebles: «Uso» queda fuera del recuadro azul | Diseño | R31 | ✔ (BDG 15/09) | 166 Cerrado | ✅ |
| E-133 | Bienes inmuebles: al volver del detalle va a «Todos» y no al filtro en el que se estaba (Urbano o Rústico) | Funcional | R14 (14/09) | — | 197 QA Testing | ❓ |
| E-134 | Domicilio: la web muestra más datos que la app | Funcional | R14 (14/09) | ⏸ «comprobar» (LAR 23/09); según JCJ la API no envía más | 198 QA Testing | ✅ |
| E-135 | Domicilio sin datos: no mostrar el botón del Ayuntamiento, porque no hay URL | UX Writing | R21 (23/09) | ⏸ «UX Writing» (LAR 28/09) | 235 Por hacer · 234 Desestimada (duplicado) | ✅ |
| E-136 | Vivienda y Vehículos: los enlaces de interés salen antes que los trámites | Diseño | H2 (Bienestar), R31 | ✔ (BDG 15/09) | 129 · 166 Cerrado | ✅ |
| E-137 | Vehículos sin la cláusula AGE: «no hemos encontrado vehículos», y la URL del contacto de la DGT es incorrecta | Funcional | H2 | — | 133 Cerrado | ❓ |

### 2.22 Mis datos: educación

| ID | Error o cambio | Tipo | Aparece en | Nota | Ticket(s) | Coh. |
|---|---|---|---|---|---|---|
| E-138 | URL incorrectas en la (i) para títulos universitarios y no universitarios | UX Writing | R31 | ✔ (BDG 16/09 y LAR 15/09) | 166 Cerrado | ✅ |
| E-139 | Mensaje de «no hay datos»: URL de títulos universitarios y texto distinto al de la (i) | UX Writing | R31 (nota), R14 (16/09) | ✘ «El texto es diferente…» (LAR 15/09) | 210 Cerrado (G.T. 01/10, «uxwriting») | ⚠️ |

---

## 3. Observaciones

1. **Lo que se probó no es lo que hay en `release`.** Varios ⚠️ (E-027, E-030 y E-093) ya tienen arreglo en local (`48bba08` del 30/09 y `2513ee7`), pero no en la build que revisó JCCM. Antes de mover esos tickets hay que entregar una build nueva y que el revisor la valide.
2. **Tickets cerrados sin que el revisor lo confirme.** Los «paraguas» 164, 166, 167, 169 y 170 se cerraron con ✅ por puntos. Casi todo coincide con las notas, salvo 164 (E-046 y E-047, que siguen pendientes) y los puntos de 166 que pasaron a 203, 211, 215 y 226.
3. **Los tickets cerrados como «UX Writing»** (210 y 211, cerrados por G.T. el 01/10) solo cuadran si el trabajo sigue vivo en 226. Para Educación (E-139) no lo está.
4. **El H2 no tiene notas del revisor**, así que sus 60 puntos aproximadamente salen como ❓ aunque los tickets 101 a 135 estén cerrados.
5. **Casos de prueba que contradicen lo que se pide**: 151 da por buena la campana (E-018) y 182 espera la consejería en la tarjeta del expediente (E-081).
