# Modo demostración (revisores de App Store / Google Play)

## Por qué existe

Los revisores de Apple y Google no pueden identificarse con Cl@ve, y sin sesión la app no muestra más que la landing. Apple (guideline 2.1) y Google exigen una cuenta o un modo de demostración para revisar lo que hay tras el login. No hay usuario de pruebas posible sin Cl@ve (el cliente de Cerbero es público, sin `client_credentials`), así que la app incorpora un **modo demostración** en la misma compilación de producción: funciona sola, con datos ficticios locales, sin tocar ni Cl@ve, ni Cerbero, ni la fachada.

## Cómo se entra

Landing → **«Saber más sobre Espacio ciudadano»** → en la barra inferior, enlace **«Acceder a demostración»** → hoja de confirmación → código de acceso **`1234`** (`DemoSession.accessCode`; no es un secreto, sólo evita entradas por error) → «Entrar en la demostración». Mientras dura, una cinta **DEMO** se pinta sobre todas las pantallas. Se sale con **«Cerrar sesión»** (menú de perfil o Preferencias).

Texto para las notas de revisión (App Store Connect «Notas» / Play Console «Instrucciones de acceso»):

> La identificación real exige Cl@ve (sistema de identidad del Gobierno de España, solo para residentes con DNI/NIE), por lo que no es posible facilitar una cuenta de pruebas. Para revisar la aplicación: ábrala, pulse «Saber más sobre Espacio ciudadano», después «Acceder a demostración» en la parte inferior, introduzca el código **1234** y confirme. Entrará con una persona ficticia («Lucía Ejemplo Demo») y datos de ejemplo almacenados en la propia app; ninguna acción se envía a servicios reales. Para salir, pulse «Cerrar sesión».

## Cómo funciona

- **Sesión**: `LandingNotifier.enterDemoMode()` arranca en memoria (`AuthSessionController.startInMemory`) un `TokenResponse` fabricado por `DemoSession` (`lib/core/demo/demo_session.dart`): JWT sin firma con `iss = espacio-ciudadano-demo`, `sub_alt = PERDEMO001`, `PersonIdentifier = 00000000T`, nivel `high` y caducidad a 10 años (no se renueva nunca). Sin `id_token`: cerrar sesión no abre ningún navegador.
- **El modo demo se deriva del token**: `demoModeProvider` (`lib/core/demo/demo_mode_provider.dart`) mira el `iss` de los claims. No hay flag aparte: entrar, cerrar sesión (`clear()` anula los claims) y reanudar tras un reinicio con acceso rápido quedan coherentes solos.
- **Autenticación**: con claims demo, `authRepositoryProvider` devuelve `DemoAuthRepository` (renovar/elevar devuelven el mismo token; cerrar/revocar no hacen nada).
- **Red**: `dioProvider` conserva el `Dio` y los interceptores reales y sustituye el transporte por `DemoHttpClientAdapter`, que resuelve contra `DemoBackend` (`lib/core/demo/demo_backend.dart`): estado en memoria + tabla de rutas por feature (`lib/core/demo/routes/`) con fixtures (`lib/core/demo/fixtures/`). El sobre de la fachada, el desempaquetado del cliente generado y los mappers trabajan igual que contra el gateway.
- **Escrituras simuladas**: mutan el estado en memoria (seleccionar hechos vitales cambia las recomendaciones, aceptar cláusulas, crear/editar el contacto, comparecer una notificación, aportar documentación añade un registro de entrada, etc.). El backend nace al entrar y muere al cerrar sesión.
- **Consentimiento**: la demo empieza **sin** la cláusula 0 aceptada, para que el revisor pase una vez por el flujo legal real. El estado inicial no es el 404 del gateway sino un 200 con el catálogo completo y todo `pendiente` (lo que devuelve el gateway a quien nunca contestó): `ConsentRepositoryImpl.fetchClauses` convierte el 404 en `LoadClausesFailed` y la página legal no podría cargar las cláusulas que hay que aceptar. Tras un reinicio con acceso rápido, `DemoBackend.seeded` lee `consent_accepted_PERDEMO001` y `consent_accepted_clauses_PERDEMO001` para no volver a pedirla (si no, el guard cerraría la sesión guardada).
- Al entrar se borran las trazas locales de la identidad demo (`DemoSession.localTraceKeys`) para que cada demostración empiece como un ciudadano nuevo.

## Cobertura

52 rutas registradas en `DemoBackend.seeded` (`lib/core/demo/demo_backend.dart`), repartidas en `lib/core/demo/routes/`: consentimiento (3), hechos vitales y preferencias (3), recomendaciones (1), contacto de notificaciones (3), Mis datos (17: bienestar social, educación, empleo, vivienda, vehículos y salud), agenda (2; la de citas pendientes de primaria la comparte con salud), gestión (13: expedientes, registros, notificaciones y aportación de documentación), carnés digitales (8) y soporte (2). Cada grupo tiene su test `test/core/demo/demo_<feature>_routes_test.dart` que ejecuta el **repositorio real** contra el backend demo; `test/core/routing/session_guard_demo_test.dart` recorre el gate de consentimiento con el `ConsentRepositoryImpl` real.

## Qué sigue siendo real

- La comprobación de versión al arrancar (`app_update`, cliente público propio).
- El aviso de «sin conexión» (`connectivity_plus`): en modo avión aparece aunque la demo funcione.
- Los enlaces externos (`url_launcher`) abren las webs reales.

## Limitaciones conocidas

- Los **pkpass** son un zip mínimo sin firma: Wallet los rechaza (la app muestra su error curado). PDF y QR sí son ficheros válidos.
- La demo y una sesión real guardada en el dispositivo (acceso rápido) no pueden convivir: el gate de consentimiento borraría esa sesión sin avisar. Si la hay, la hoja de confirmación lo explica y ofrece «Cerrar la sesión guardada y entrar», que hace el mismo cierre que «Cerrar sesión» (fin de sesión en Cerbero con el `id_token` guardado + limpieza local) antes de entrar.

## Mantenimiento de fixtures

Las fixtures se copian del JSON de los tests de repositorio (`test/features/<feature>/*_repository_impl_test.dart`), que ya están validados contra los mappers, y se adaptan a la persona ficticia. Si cambia el contrato de un endpoint: actualizar su test de repositorio, la fixture y el test `test/core/demo/demo_<feature>_routes_test.dart`, que ejecuta el repositorio real contra el backend demo. Una ruta sin cubrir responde 404 y deja traza `[demo] sin ruta …` en el log.
