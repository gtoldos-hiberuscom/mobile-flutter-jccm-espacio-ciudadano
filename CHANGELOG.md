# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto se adhiere al [Versionado Semántico](https://semver.org/lang/es/).

Las versiones se nombran `X.Y.Z+B`, donde `+B` es el número de build de la
entrega (`version:` de `pubspec.yaml`). Entre corchetes, el código de Gestión de
Proyectos al que se imputa cada cambio.

## [Sin publicar]

## [0.1.5+7] - 2026-09-11

Entrega a QA y cliente contra preproducción. Integra en una sola versión el
trabajo de accesibilidad y adaptación a tablet que hasta ahora vivía solo en el
repositorio remoto, junto con las correcciones de las versiones 0.1.3+5 y
0.1.4+6.

### Añadido

- Adaptación a tablet: los componentes del design system se ajustan al ancho
  disponible en pantallas grandes. [286771]
- Control de la orientación en móvil. [286771]
- Batería de pruebas de accesibilidad sobre el design system, la agenda, la
  landing, las páginas legales y los estados vacíos. [284199]

### Cambiado

- El botón de descarga del carné en Android pasa a llamarse «Cartera digital»,
  igual que en iOS. [284199]
- Se revisan los textos y la semántica accesible de los carnets. [284199]
- Se mejora la localización y se refina la navegación accesible, incluidas las
  etiquetas del componente de navegación, el inicio y la página de privacidad. [282844]
- Se refinan las pantallas de empleo y salud de Mis Datos. [282844]
- Se alinea la tipografía de la página legal y se afinan las recomendaciones
  del inicio. [282844]


## [0.1.4+6] - 2026-09-11

### Seguridad

- Aislamiento de la sesión de Cl@ve en Android mediante Ephemeral Custom Tabs,
  de modo que el estado del navegador no sobrevive entre identificaciones y el
  selector de método vuelve a aparecer siempre. Cuando el navegador del
  dispositivo no puede garantizar el aislamiento, el flujo se degrada de forma
  explícita y se avisa al usuario en lugar de compartir cookies en silencio. [282847]

### Corregido

- La agenda degrada por fuente: si una de las procedencias de citas falla, se
  muestran las demás y se avisa de lo que no pudo cargarse, en vez de dejar la
  pantalla entera en error. [282844]

## [0.1.3+5] - 2026-09-07

### Añadido

- Aportación de documentación alineada con el modelo de la sede web: el lote se
  puede editar antes de enviarlo, se registra una única aportación a la vez y la
  cola de subidas respeta los ficheros que el ciudadano retira. [282844]
- Resolución del sobre de autorización `412.00/3034`: la aplicación explica que
  falta la autorización correspondiente en lugar de mostrar un error genérico. [282844]

### Cambiado

- Mis Datos unifica el contrato de estados y solo interpreta como datos las
  respuestas `2xx`. [282844]
- El listado de notificaciones pasa a páginas de 50 elementos. [282844]
- Se desactivan los reintentos automáticos de Riverpod en toda la aplicación:
  un fallo se muestra y se reintenta a petición del usuario. [282844]
- El plazo de subida se dimensiona según el tamaño del envío y no según el
  `TIMEOUT` general. [282844]
- La aplicación deja de declarar un tema oscuro que el design system no soporta. [282844]

### Corregido

- **Agenda**: fechas siempre en hora local y deduplicación de citas por franja de
  minuto; las citas del inicio dejan de usar la ruta antigua de SESCAM. [282844]
- **Notificaciones**: la paginación ya no pierde elementos en silencio; cada
  tarjeta de la pestaña «Todo» muestra su estado y respeta el orden de bandeja;
  el detalle se respalda con el resumen del listado y permite descargar sus
  documentos; los elementos sin identificador se descartan en vez de recibir un
  `0`; un estado ilegible ya no reactiva la comparecencia. [282844]
- **Autorización y consentimiento**: un fallo al comprobar las cláusulas deja de
  anunciarse como «no estás autorizado»; revocar la cláusula de recomendaciones
  limpia los hechos vitales con `PATCH` y nunca con `DELETE /preferencias`; una
  segunda revocación dentro del mismo proceso también cierra la sesión; el
  registro sintético de cláusulas pendientes ya no provoca cierre de sesión. [282844] [282847]
- **Mis Datos**: la falta de autorización se resuelve antes de invitar a
  autorizar y la decide el sobre de respuesta, no el código HTTP; se lee la
  categoría del título universitario; los datos del inmueble se presentan
  juntos; Bienestar Social deja de interpretar cuerpos `4xx` como datos, y los
  errores de transporte ya no se convierten en datos de negocio inventados. [282844]
- **Gestión**: el cierre de una aportación ni caduca ni se queda colgado; la
  transacción nunca se cierra con la lista de documentos vacía; un fichero sin
  enviar se anuncia como «Seleccionado» y no como «Subido»; el detalle de
  notificación deja de fabricar el identificador `0` al aceptar; expedientes y
  registros traducen el sobre de autorización. [282844]
- **Carnets**: un rechazo por falta de autorización dejaba de distinguirse de
  «no tienes carnets». [282844]
- **Hechos vitales**: el restablecimiento deja de fallar —y de darse por bueno—
  en silencio. [282844]
- **Inicio y landing**: «Mis novedades» informa cuando no hay novedades; el
  aviso de acceso con Cl@ve aparece desde las dos pantallas; el velo de Cl@ve
  cubre también la pantalla de cómo acceder; la FAQ deja de mostrar entradas de
  relleno. [282844]
- **Páginas legales**: se pueden leer sin arrastrar el flujo de consentimiento. [282844]
- **Textos**: teléfono correcto del 012, corrección de erratas visibles y
  retirada de claves de prueba del fichero de traducciones. [282844]
- **Interfaz**: orden de secciones, tarjeta de demanda deshabilitada, corte del
  aviso legal e icono de información de contacto. [282844]
- El calendario pinta todos los días del mes. [282844]

### Seguridad

- Ninguna traza imprime tokens ni datos personales: la redacción vuelve a estar
  activa por defecto, con un interruptor por entorno (`LOG_REDACTION_OFF`) para
  depurar contra UAT y preproducción, ninguna traza de red se salta el control
  de verbosidad y desaparece la última impresión directa a consola. [282844]
- Se eliminan claves de almacenamiento en desuso y la expiración de sesión deja
  de heredarse de un valor obsoleto tras reiniciar. [282847]

## [0.1.2+4] - 2026-09-01

### Corregido

- Hotfix del gate de consentimiento en UAT: el gate falla en abierto ante fallos
  transitorios del backend y se corrigen los callejones sin salida del velo de
  Cl@ve. [282847]

## [0.1.1+3] - 2026-08-28

Publicada sin notas de versión.

## [0.1.0+1] - 2026-07-29

Primera versión etiquetada del proyecto.

---

## Alcance inicial (Sprints 1 y 2)

> Estas entradas venían del andamiaje inicial del repositorio y **nunca se
> asignaron a una versión publicada**. Se conservan literalmente a la espera de
> repartirlas entre `0.1.0+1` y `0.1.1+3`.

### Sprint 1

- STORY-11 — Bootstrap del repositorio y entrypoints por entorno.
- STORY-12 — Red, almacenamiento seguro y estrategia de errores compartida.
- STORY-13 — Shell global, routing, guards y deep links.
- STORY-14 — Design system, theming, localización y accesibilidad base.
- STORY-17 — Landing anónima y flujo informativo previo al acceso.
- STORY-18 — Login Cl@ve, callback seguro y ciclo de vida de sesión.
- STORY-19 — Aceptación inicial de condiciones de uso y protección de datos.
- TASK-21 — Validación de claims JWT, idAgente y parámetros federados obligatorios.

### Sprint 2

- STORY-15 — Estados compartidos de UI, paginación, refresh y acciones documentales.
- STORY-20 — Estado de usuario logado, menú personal y mantenimiento bloqueante.
- STORY-22 — Portada logada con resumen ciudadano y accesos rápidos.
- STORY-28 — Enlaces externos y navegación saliente de dominios temáticos.
- STORY-59 — Centro de ayuda con FAQ, guías y contacto informativo.
- STORY-61 — Páginas legales y estáticas de uso, privacidad, accesibilidad y aviso legal.
- STORY-62 — Mapa web y navegación global de footer.
- STORY-64 — Observabilidad, analytics y logging con redacción de PII.
- STORY-68 — CI/CD baseline, verificación de codegen y checklist de release.
- TASK-69 — Inventario PII, hardening de seguridad y ADRs de excepción al canon.
