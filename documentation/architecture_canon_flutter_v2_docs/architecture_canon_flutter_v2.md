# Canon de Arquitectura Flutter — Fuente de verdad de implementación

**Versión:** 2.0  
**Fecha:** 20 de abril de 2026  
**Estado:** Normativo  
**Ámbito:** Apps Flutter mobile-first con soporte opcional para web y escritorio  
**Stack por defecto:** Flutter + Riverpod + GoRouter + Dio + Freezed + build_runner

---

## 0. Cómo leer este documento

Este documento **no es una guía orientativa**. Es la **fuente de verdad operativa** para construir, revisar, mantener y escalar un proyecto Flutter dentro del equipo.

Su objetivo es que, ante cualquier duda de implementación, exista una respuesta explícita sobre:

- cómo se organiza el repositorio;
- qué piezas viven en `app`, `core`, `features` y `packages`;
- qué dependencias están permitidas y cuáles están prohibidas;
- cómo se inicializa la app;
- cómo se gestionan entorno, navegación, estado, errores, autenticación, observabilidad, seguridad y testing;
- cómo se valida que una feature está realmente terminada.

Cuando este documento y el código entren en conflicto, la resolución correcta es:

1. verificar si el código incumple el canon;
2. si la decisión de código es deliberada y mejor, registrar un ADR y actualizar este documento;
3. nunca normalizar una excepción silenciosa.

---

## 1. Principios rectores

### 1.1. Principio de separación de responsabilidades

La aplicación se divide en responsabilidades con fronteras claras. La UI no resuelve infraestructura. El dominio no conoce Flutter. La capa de datos no decide navegación. Los detalles técnicos no contaminan el lenguaje del negocio.

### 1.2. Principio de dependencias hacia dentro

Las decisiones de negocio son más estables que las librerías concretas. Por tanto:

- las capas internas no dependen de detalles externos;
- las abstracciones viven más cerca del dominio;
- las implementaciones concretas viven más cerca de infraestructura.

### 1.3. Principio de feature ownership

Cada feature debe ser comprensible, testeable y evolucionable de forma casi aislada. Una persona debe poder abrir `lib/features/<feature>` y entender:

- qué hace;
- qué expone;
- de qué depende;
- cómo se testea;
- cómo se integra en la app.

### 1.4. Principio de defaults explícitos

Todo proyecto debe tener defaults claros para evitar debates repetitivos:

- un solo state management;
- un solo router;
- una estrategia única de errores;
- una estrategia única de DI;
- una estrategia única de tests;
- una estrategia única de entornos y release.

### 1.5. Principio de verificabilidad

Una regla de arquitectura que no pueda revisarse en PR, lint, test o checklist es débil. El objetivo del canon es que las decisiones importantes sean observables.

### 1.6. Principio de modularidad pragmática

No se diseña para micro-paquetes prematuros, pero sí para que una feature pueda extraerse con bajo coste. Esto obliga a minimizar acoplamientos laterales y a centralizar contratos.

---

## 2. Tecnología base y decisiones por defecto

### 2.1. Stack por defecto

- **Flutter** como framework de UI multi-plataforma.
- **Riverpod** como solución de state management y DI.
- **GoRouter** como router declarativo basado en URL.
- **Dio** como cliente HTTP.
- **Freezed** para modelos inmutables y unions.
- **build_runner** para generación de código.
- **flutter_localizations + intl** para i18n/l10n.
- **flutter_secure_storage** para secretos/tokens.
- **shared_preferences / storage específico** solo para datos no sensibles.

Flutter recomienda separar responsabilidades y organizar la app con capas bien definidas, aunque remarca que sus pautas deben adaptarse al contexto del proyecto. citeturn430061view0turn430061view1 Riverpod documenta `Notifier` y `AsyncNotifier` como eje de la lógica mutable, indicando además que la lógica debe ir en `build` y no en el constructor. citeturn430061view2turn430061view3 GoRouter se define como un router declarativo y orientado a URL para Flutter. citeturn101581search0 Dio soporta configuración global, interceptores, cancelación, timeouts y adapters personalizados. citeturn101581search1

### 2.2. Tecnología desaconsejada por defecto

Salvo ADR explícito, se evita:

- `provider`, `get_it`, `bloc`, `mobx`, `redux` o múltiples paradigmas mezclados;
- `StateNotifier` para nuevo código;
- navegación imperativa dispersa basada en `Navigator.push` salvo casos muy acotados;
- singletons manuales globales;
- modelos mutables compartidos;
- DTOs expuestos fuera de infraestructura.

Riverpod desaconseja `StateNotifier` frente a `Notifier` y `AsyncNotifier` para nuevo código. citeturn430061view3

### 2.3. Compatibilidad con proyectos existentes

Si el proyecto heredado ya usa otra pila:

- la migración debe ser progresiva;
- el nuevo código seguirá este canon;
- las zonas legacy se etiquetarán como tales;
- no se propagará el patrón antiguo a nuevas features.

---

## 3. Alcance del canon

Este documento cubre cuatro planos:

1. **Arquitectura de repositorio**  
   Cómo se organiza el monorepo o el repo simple.

2. **Arquitectura de aplicación**  
   Cómo arranca la app, cómo se compone el shell, cómo se inyectan dependencias y cómo se integran las features.

3. **Arquitectura de feature**  
   Cómo se modela el negocio, la UI, la infraestructura y el estado de una feature.

4. **Gobierno transversal**  
   Cómo se validan calidad, testing, seguridad, performance, accesibilidad, release y observabilidad.

---

## 4. Topología obligatoria del repositorio

## 4.1. Estructura recomendada

```text
/
  .github/
    workflows/
    pull_request_template.md
  analysis_options.yaml
  melos.yaml                    # opcional si hay múltiples packages/apps
  pubspec.yaml
  README.md
  docs/
    architecture/
      architecture_canon.md
      adr/
  config/
    development.json
    preproduction.json
    production.json
  lib/
    app/
    core/
    features/
    l10n/
    main_development.dart
    main_preproduction.dart
    main_production.dart
  test/
  integration_test/
  tool/
  scripts/
  packages/                     # opcional
    design_system/
    app_lints/
    shared_contracts/
```

### 4.2. Criterios

- **`lib/app/`** contiene composición global de la aplicación.
- **`lib/core/`** contiene infraestructura y utilidades transversales compartidas.
- **`lib/features/`** contiene módulos funcionales.
- **`packages/`** contiene librerías compartidas solo cuando merecen vida propia.
- **`docs/architecture/`** contiene este canon, ADRs y guías normativas.
- **`config/`** contiene definiciones por entorno consumidas en build.

### 4.3. Qué no debe ocurrir

- meter toda la app directamente en `lib/` sin fronteras;
- usar `utils/` como cajón desastre;
- mezclar `screens`, `services`, `repositories`, `widgets`, `models` globales sin contexto;
- guardar lógica de negocio en helpers anónimos o extensiones sin ownership claro.

---

## 5. Arquitectura global de la app

La app se divide en tres macrozonas:

```text
lib/
  app/       -> composición global, bootstrap, router, shell, theme, localization
  core/      -> capacidades transversales reutilizables
  features/  -> capacidades funcionales del negocio
```

### 5.1. `app/` — composición de aplicación

`app/` es el lugar donde se ensambla el sistema. No contiene negocio de feature.

```text
lib/app/
  bootstrap/
    bootstrap.dart
    app_initializer.dart
  config/
    app_config.dart
    build_environment.dart
  routing/
    app_router.dart
    route_registry.dart
    route_guards.dart
  shell/
    app.dart
    app_scaffold.dart
    app_startup.dart
  theme/
    app_theme.dart
    app_colors.dart
    app_typography.dart
  localization/
    localization.dart
  observers/
    app_lifecycle_observer.dart
```

Responsabilidades:

- leer entorno;
- inicializar dependencias globales;
- configurar router;
- configurar tema;
- configurar localización;
- registrar observers;
- arrancar la aplicación.

### 5.2. `core/` — capacidades transversales

`core/` no modela negocio funcional concreto. Modela capacidades comunes y contratos de infraestructura reutilizables.

```text
lib/core/
  analytics/
  auth/
  config/
  connectivity/
  constants/
  design_system/
  errors/
  extensions/
  logging/
  monitoring/
  navigation/
  network/
  permissions/
  platform/
  security/
  storage/
  utils/
```

Regla: si algo es usado por muchas features y no pertenece al dominio de una sola, evalúa si vive en `core/`.

### 5.3. `features/` — módulos funcionales

Cada feature encapsula su dominio, su estado, su UI y su infraestructura específica.

```text
lib/features/
  authentication/
  home/
  profile/
  appointments/
  notifications/
```

---

## 6. Contrato obligatorio de una feature

## 6.1. Estructura mínima

La estructura normativa por feature es:

```text
lib/features/<feature_name>/
  0_entity/
  1_domain/
  2_presentation/
  3_data/
  <feature_name>.dart            # opcional, barrel raíz controlado
```

### 6.2. Responsabilidad de cada capa

- **0_entity**  
  Modelos de dominio estables y agnósticos de framework.

- **1_domain**  
  Casos de uso, repositorios abstractos, value objects, reglas de negocio.

- **2_presentation**  
  Estado de UI, páginas, widgets, providers y routing local.

- **3_data**  
  APIs, DTOs, mappers, fuentes de datos, repositorios concretos.

### 6.3. Estructura ampliada recomendada

```text
lib/features/<feature_name>/
  0_entity/
    entities/
    value_objects/
    enums/
    entity.dart
  1_domain/
    repositories/
    usecases/
    services/
    domain.dart
  2_presentation/
    controllers/
    providers/
    routes/
    pages/
    widgets/
    states/
    presentation.dart
  3_data/
    api/
    datasources/
    dto/
    mappers/
    repositories/
    data.dart
```

### 6.4. Reglas de ownership

Una feature:

- puede depender de `core/`;
- puede depender de contratos públicos de otra feature solo si está aprobado y documentado;
- no debe importar internals de otra feature;
- no debe exponer infraestructura a otras features.

---

## 7. Reglas de dependencia

## 7.1. Flujo permitido

```text
2_presentation  -> 1_domain -> 0_entity
3_data          -> 1_domain -> 0_entity
app             -> core + features
core            -> paquetes externos + utilidades propias
```

## 7.2. Flujo prohibido

- `1_domain` importando `2_presentation`
- `1_domain` importando `3_data`
- `0_entity` importando Flutter, Dio o Riverpod
- `2_presentation` importando repositorios concretos de `3_data`, excepto el punto de composición DI en providers
- `features/a` importando archivos internos de `features/b/3_data`
- UI llamando directamente a APIs HTTP
- routing leyendo DTOs o errores crudos de red

## 7.3. Excepción permitida: provider files como punto de composición

Los archivos de `2_presentation/providers/` pueden importar `3_data` **solo** para cablear implementación concreta a abstracción, como ya recogía tu documento base. fileciteturn2file0

Regla estricta:

- páginas, widgets y controllers **no** importan `3_data`;
- providers de composición **sí pueden** importar `3_data` para DI;
- ese punto debe ser mínimo, explícito y fácilmente localizable.

---

## 8. Estructura normativa de `app/`

## 8.1. Entry points por entorno

Se usarán entry points explícitos:

```text
lib/main_development.dart
lib/main_preproduction.dart
lib/main_production.dart
```

Cada entry point solo hace tres cosas:

1. crear `AppConfig` del entorno;
2. llamar a `bootstrap(config)`;
3. no contener lógica de negocio ni wiring complejo.

Ejemplo:

```dart
Future<void> main() async {
  final config = AppConfig.development();
  await bootstrap(config);
}
```

## 8.2. Bootstrap

`bootstrap.dart` es el único lugar que puede coordinar la inicialización global:

- `WidgetsFlutterBinding.ensureInitialized()`;
- carga de configuración;
- inicialización de logger;
- inicialización de storage;
- inicialización de servicios externos;
- configuración de `ProviderScope`;
- `runApp(...)`.

Ejemplo de orden:

```dart
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  final bootstrapResult = await AppInitializer(config).initialize();

  runApp(
    ProviderScope(
      overrides: bootstrapResult.overrides,
      observers: [AppProviderObserver()],
      child: App(config: config),
    ),
  );
}
```

## 8.3. `AppInitializer`

Si el bootstrap crece, se delega en una clase orquestadora:

Responsabilidades:

- inicializar recursos asíncronos;
- devolver overrides de providers;
- construir dependencias de arranque;
- capturar errores de startup y mapearlos a una pantalla de recuperación.

No debe:

- navegar;
- resolver lógica de feature;
- dejar estado global mutable disperso.

## 8.4. `App`

`App` compone:

- `MaterialApp.router` o `CupertinoApp.router`;
- tema;
- localización;
- routerConfig;
- builders globales;
- banners/flags por entorno;
- overlays globales no intrusivos.

---

## 9. Configuración de entornos, flavors y build

Tu arquitectura actual ya introduce `--dart-define-from-file` como base de configuración por entorno. fileciteturn1file6turn1file9 Ese enfoque se mantiene, pero se endurece.

Flutter documenta el uso de flavors para diferenciar configuraciones y variantes de build, incluyendo nombre, iconos, assets y ajustes únicos por flavor. citeturn430061view6

## 9.1. Regla general

Se separan tres conceptos:

1. **Entorno lógico**  
   development / preproduction / production

2. **Flavor de build**  
   Configuración nativa de Android/iOS cuando proceda

3. **Configuración runtime compilada**  
   Valores consumidos por Dart desde `dart-define`

## 9.2. Objeto normativo `AppConfig`

```dart
class AppConfig {
  final BuildEnvironment environment;
  final String appName;
  final Uri apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableVerboseLogs;
  final bool showEnvironmentBanner;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool enablePerformanceMonitoring;

  const AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableVerboseLogs,
    required this.showEnvironmentBanner,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.enablePerformanceMonitoring,
  });
}
```

## 9.3. Regla de lectura

Ninguna feature debe leer `String.fromEnvironment` directamente.  
Solo `app/config/` puede hacerlo y transformarlo en un `AppConfig` tipado.

## 9.4. Regla de secretos

Nunca se inyectan secretos reales de backend en binarios cliente.

Permitido:

- base URLs;
- flags funcionales no sensibles;
- timeouts;
- toggles de analytics;
- claves públicas o identificadores públicos, si aplica.

No permitido:

- client secrets OAuth confidenciales;
- API keys privadas;
- credenciales de prueba;
- tokens persistentes.

## 9.5. Mapeo nativo

Android/iOS pueden tener flavors/schemes propios, pero el contrato de negocio debe basarse en `AppConfig`, no en lecturas ad-hoc de plataforma.

---

## 10. `core/` — definición exacta por capacidad

## 10.1. `core/errors/`

Contiene la taxonomía común de errores del proyecto.

```text
lib/core/errors/
  app_exception.dart
  app_failure.dart
  error_mapper.dart
  user_message_resolver.dart
```

### Regla

Se distingue entre:

- **Exception**: error técnico lanzado dentro de infraestructura.
- **Failure**: error de dominio o aplicación ya interpretado.
- **UserMessage**: representación final para UI.

Ejemplo:

```dart
sealed class AppFailure {
  const AppFailure();
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure();
}

final class ValidationFailure extends AppFailure {
  final String code;
  const ValidationFailure(this.code);
}
```

## 10.2. `core/network/`

Contiene el stack HTTP común.

```text
lib/core/network/
  dio_provider.dart
  base_options_factory.dart
  interceptors/
    auth_interceptor.dart
    common_headers_interceptor.dart
    logging_interceptor.dart
    retry_interceptor.dart
  network_result.dart
```

### Reglas

- una única fuente de creación de `Dio`;
- interceptores registrados en un orden conocido;
- no crear `Dio()` dentro de features salvo pruebas controladas;
- cancelación, timeouts y headers comunes centralizados.

## 10.3. `core/auth/`

Contiene lo transversal de sesión y credenciales, no la feature funcional completa de login si existe una.

Ejemplos:

```text
lib/core/auth/
  auth_session.dart
  auth_token_store.dart
  auth_state_provider.dart
  session_refresher.dart
```

Regla: el contrato de sesión es global; la UI concreta de autenticación vive en `features/authentication`.

## 10.4. `core/storage/`

Separa almacenamiento por sensibilidad:

```text
lib/core/storage/
  secure/
    secure_store.dart
  preferences/
    app_preferences.dart
  cache/
    cache_store.dart
```

Reglas:

- tokens en secure storage;
- preferencias no sensibles en shared preferences o equivalente;
- caché funcional con política explícita de expiración;
- nunca guardar secretos en almacenamiento no seguro.

## 10.5. `core/logging/`

```text
lib/core/logging/
  app_logger.dart
  log_context.dart
  log_redaction.dart
```

Reglas:

- todos los logs pasan por un logger común;
- se redactan PII, tokens y secretos;
- los logs técnicos nunca se presentan tal cual al usuario;
- los entornos no productivos pueden ampliar detalle; producción minimiza ruido y datos sensibles.

## 10.6. `core/analytics/`

```text
lib/core/analytics/
  analytics_service.dart
  analytics_event.dart
  analytics_params.dart
```

Reglas:

- las features emiten eventos de dominio/app, no invocaciones crudas al SDK;
- los nombres de evento son tipados o centralizados;
- parámetros sensibles están vetados o anonimizados.

## 10.7. `core/monitoring/`

Incluye crash reporting, performance tracing y breadcrumbs.

Reglas:

- cualquier error no controlado relevante debe dejar rastro técnico;
- eventos de navegación y fallos importantes deben generar breadcrumbs;
- si se usan SDKs externos, su consumo queda encapsulado.

## 10.8. `core/design_system/`

Si el proyecto tiene más de una feature significativa, el design system no puede disolverse en widgets sueltos.

```text
lib/core/design_system/
  tokens/
  components/
  layouts/
  feedback/
```

Reglas:

- colores, tipografía, spacing y radios centralizados;
- componentes base reutilizables;
- estados vacíos/loading/error homogéneos;
- accesibilidad y theming tratados como concerns de diseño, no parches de última hora.

## 10.9. `core/navigation/`

Aunque el router viva en `app/routing`, `core/navigation` puede alojar primitives comunes:

- route intents;
- helpers de deep link parsing;
- modelos compartidos de navegación segura;
- launchers externos.

No debe duplicar el router.

## 10.10. `core/security/`

Lugar para:

- sanitización de URLs;
- validación de certificados si procede;
- policies de copia/pegado, screenshots, jailbreak/root detection si aplica;
- helpers de protección de datos.

## 10.11. `core/permissions/`

Regla:

- las features no interactúan directamente con el plugin concreto;
- usan un servicio/contrato del core que abstrae estado, rationale y petición.

---

## 11. Entidades, value objects y modelos de dominio

## 11.1. `0_entity/`

Contiene el lenguaje estable del negocio.

### Permitido

- `freezed`;
- enums y value objects;
- validación local pura;
- helpers deterministas.

### Prohibido

- Flutter;
- Riverpod;
- Dio;
- `BuildContext`;
- serialización HTTP como preocupación principal;
- dependencias a infraestructura.

## 11.2. Entidad vs DTO vs Model de UI

- **Entidad**: modelo del dominio.
- **DTO**: modelo de intercambio con red o almacenamiento.
- **UI State Model**: modelo de representación de pantalla.

Nunca se reutiliza un DTO como entidad de dominio por comodidad.

Excepción controlada: si el código generado representa exactamente el dominio y así se decide por ADR, esa simplificación debe ser explícita y muy justificada.

## 11.3. Value Objects

Usar value objects cuando aportan invariantes:

- `EmailAddress`
- `DocumentId`
- `PhoneNumber`
- `Money`
- `PaginationCursor`

Ventaja: la validación deja de estar dispersa.

---

## 12. Capa de dominio (`1_domain/`)

## 12.1. Contenido obligatorio

- repositorios abstractos;
- casos de uso;
- servicios de dominio solo si son realmente de negocio;
- failures específicas si el dominio las necesita.

## 12.2. Caso de uso como unidad de comportamiento

Todo comportamiento relevante y testeable debe vivir en un use case o en un servicio de dominio.

Ejemplos:

- `FetchAppointmentsUseCase`
- `SubmitOtpUseCase`
- `RefreshSessionUseCase`
- `GetUserProfileUseCase`

## 12.3. Reglas de los use cases

- una intención clara por caso de uso;
- inputs explícitos;
- output explícito;
- no conocer UI;
- no conocer navegación;
- no conocer SDKs concretos.

## 12.4. Resultado normativo

Se permiten dos estrategias, pero el proyecto elige una y la aplica de forma uniforme:

### Opción A — `Result` sellado
Recomendado cuando ya lo tienes muy asentado.

```dart
sealed class FetchProfileResult {
  const FetchProfileResult();
}

final class FetchProfileSuccess extends FetchProfileResult {
  final UserProfile profile;
  const FetchProfileSuccess(this.profile);
}

final class FetchProfileFailed extends FetchProfileResult {
  final AppFailure failure;
  const FetchProfileFailed(this.failure);
}
```

### Opción B — `Either`/`Result<T, Failure>`
Permitida si el proyecto usa una abstracción genérica consistente.

Regla: no mezclar ambas arbitrariamente.

## 12.5. Errores en dominio

El dominio no registra logs de infraestructura.  
El dominio transforma o propaga fallos de forma interpretable.

---

## 13. Capa de datos (`3_data/`)

## 13.1. Responsabilidades

- hablar con backend;
- hablar con caché;
- hablar con bases locales;
- mapear DTOs a entidades;
- materializar repositorios abstractos.

## 13.2. Subdivisión recomendada

```text
3_data/
  api/
  datasources/
    remote/
    local/
  dto/
  mappers/
  repositories/
```

## 13.3. API wrappers

Si existe cliente OpenAPI generado, se usa como detalle de infraestructura dentro de `3_data/api/`, tal como ya reflejabas en el documento actual. fileciteturn2file0

Regla:

- las features no importan clientes generados desde presentación;
- el wrapper adapta naming, errores, cancelación y modelos;
- el resto de la feature trabaja con contratos propios.

## 13.4. Datasource remoto

Debe encargarse de:

- construir request;
- invocar cliente;
- devolver DTOs o excepciones técnicas.

No debe:

- decidir mensajes de usuario;
- decidir navegación;
- mezclar mapping de dominio si se quiere máxima claridad.

## 13.5. Mappers

Los mappers son explícitos. No usar conversiones implícitas dispersas en múltiples sitios.

Regla:

- un mapper por agregado/familia de modelos;
- tests unitarios obligatorios para mappers no triviales.

## 13.6. Repositorio concreto

Es el punto donde se orquesta:

- remote;
- local;
- caché;
- strategy offline-first o online-first;
- mapping a entidad;
- conversión de exceptions a failures si aplica.

---

## 14. Estrategia de estado con Riverpod

Riverpod define que los notifiers exponen la lógica mutable y que la lógica debe ir en `build`, no en el constructor; además, `Notifier`/`AsyncNotifier` son la vía recomendada frente a `StateNotifier`. citeturn430061view2turn430061view3

## 14.1. Regla de uso

- usar `@riverpod` con code generation por defecto;
- usar `Notifier` para estado síncrono;
- usar `AsyncNotifier` para cargas asíncronas con ciclo de vida de pantalla;
- usar providers funcionales para dependencias simples, cómputos derivados o families sencillas.

## 14.2. Qué va en un controller/notifier

Sí:

- orquestación UI -> use case -> state;
- loading flags;
- errores de pantalla;
- refresh;
- acciones del usuario;
- coordinación local de pantalla.

No:

- lógica de negocio profunda;
- creación manual de dependencias;
- parsing HTTP;
- navegación dispersa sin contrato.

## 14.3. Reglas críticas

- jamás poner lógica en constructor del notifier;
- `build()` define estado inicial/carga;
- `ref.watch()` para reactividad;
- `ref.read()` para acciones/callbacks;
- tras `await`, validar ciclo de vida cuando corresponda antes de mutar o navegar;
- controllers pequeños y con un estado bien definido.

## 14.4. Families

Usar families cuando el estado depende claramente de parámetros de entrada.

Ejemplo:

```dart
@riverpod
Future<OrderDetails> orderDetails(Ref ref, String orderId) async {
  final repo = ref.read(orderRepositoryProvider);
  return repo.fetchOrderDetails(orderId);
}
```

## 14.5. Provider overrides en tests

Riverpod documenta el testeo de providers y el mocking de notifiers generados, incluyendo la particularidad de codegen. citeturn430061view4

Regla del proyecto:

- todos los puntos externos relevantes deben poder overridearse;
- ningún controller debe crear por sí mismo dependencias concretas;
- tests deben usar `ProviderContainer` o `ProviderScope(overrides: ...)`.

---

## 15. Modelado de estado de pantalla

## 15.1. Estrategia recomendada

Cada pantalla relevante tiene un `State` explícito y tipado.

Ejemplo:

```dart
@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    UserProfile? profile,
    AppFailure? failure,
    @Default(false) bool isRefreshing,
  }) = _ProfileState;
}
```

## 15.2. Estados prohibidos

Evitar:

- múltiples bools incoherentes sin contrato;
- usar solo `AsyncValue` si la pantalla requiere semántica adicional compleja;
- esconder errores como strings mágicos.

## 15.3. Cuándo usar `AsyncValue`

Buena opción cuando la pantalla es simple y el patrón loading/data/error es suficiente.

Cuando la pantalla tiene más semántica:

- formularios;
- paginación;
- refresh parcial;
- múltiples subcargas;
- confirmaciones;
- side effects encadenados;

entonces un `State` propio suele ser mejor.

---

## 16. Navegación y routing

GoRouter ofrece navegación declarativa basada en URL y soporta deep links y escenarios avanzados de routing. citeturn101581search0

## 16.1. Regla general

La navegación global vive en `app/routing/`.  
Cada feature puede declarar sus rutas en `2_presentation/routes/`, pero el registro final es global.

## 16.2. Estructura

```text
lib/app/routing/
  app_router.dart
  route_registry.dart
  redirect_rules.dart
  app_route_names.dart

lib/features/<feature>/2_presentation/routes/
  routes.dart
```

## 16.3. Contrato por feature

Cada feature expone un provider o registro de rutas.

Tu patrón actual de `Provider<List<GoRoute>>` es válido y coherente con el stack existente. fileciteturn2file0

## 16.4. Reglas de navegación

- las rutas tienen ownership claro;
- evitar strings mágicos repartidos;
- preferir constantes o route data tipada;
- parámetros de path/query se parsean y validan de forma explícita;
- guards centralizados;
- redirects globales mínimamente acoplados.

## 16.5. Deep links

Toda ruta pública debe definir:

- patrón;
- parámetros esperados;
- comportamiento si faltan;
- fallback seguro;
- si requiere autenticación o no.

## 16.6. Navegación desde controllers

Permitido solo si existe un patrón consistente, por ejemplo mediante un `NavigationService` o eventos de navegación observados por la UI.

Preferido:

- controller emite intención;
- widget/efecto de UI ejecuta navegación.

Esto reduce acoplamiento con `BuildContext`.

---

## 17. Shell de aplicación

## 17.1. App shell

Si la app tiene navegación principal persistente, se crea un shell explícito:

```text
lib/app/shell/
  app_shell_page.dart
  shell_navigation_controller.dart
```

Responsabilidades:

- bottom nav / rail / drawer;
- conservación de estado de tabs;
- composición de slots de contenido;
- badges y elementos globales no funcionales.

No debe contener lógica de negocio de features.

## 17.2. Splash y startup

El startup se modela explícitamente:

- restauración de sesión;
- precarga mínima necesaria;
- resolución de primer destino;
- gating por mantenimiento / force update / onboarding si aplica.

No se oculta en `main.dart`.

---

## 18. Networking, autenticación y sesión

## 18.1. Cliente HTTP

`Dio` es la implementación estándar. citeturn101581search1

## 18.2. Orden recomendado de interceptores

1. request correlation / trace id  
2. common headers  
3. auth header  
4. logging redacted  
5. retry / refresh strategy  
6. response normalization si aplica

## 18.3. Token handling

Reglas:

- el token no se consulta directamente desde cualquier capa;
- existe un `AuthTokenStore` o equivalente;
- el `AuthInterceptor` lee token desde esa abstracción;
- refresh centralizado y serializado;
- evitar carreras al expirar el token.

## 18.4. Estrategia de refresh

Debe definirse una sola:

- refresh automático transparente;
- invalidación total y logout;
- reintento controlado;
- bloqueo concurrente si varias requests disparan refresh a la vez.

## 18.5. Headers comunes

Centralizar:

- `Accept-Language`
- version/build
- platform
- trace id
- app id si aplica

## 18.6. Timeouts y cancelación

Dio soporta cancelación y timeouts; el proyecto debe usarlos de forma explícita en operaciones largas, navegación interrumpida y formularios sensibles. citeturn101581search1

Reglas:

- toda operación cancelable de UI debería poder cancelarse;
- peticiones de pantalla destruida no deben seguir actualizando estado;
- uploads/downloads deben soportar progreso y cancelación.

---

## 19. Persistencia, caché y modo offline

## 19.1. Política explícita por dato

Todo dato persistido debe clasificarse:

- **session secret**
- **preferencia de usuario**
- **caché efímera**
- **caché durable**
- **cola offline**
- **dato legalmente sensible**

## 19.2. Estrategias permitidas

- online-first
- cache-first
- stale-while-revalidate
- offline queue / outbox

Cada repositorio debe documentar la suya cuando no sea obvia.

## 19.3. Invalidación

Toda caché necesita:

- clave;
- TTL o política de invalidación;
- criterio de refresh;
- ownership.

Si no existe esto, no hay caché; hay deuda técnica oculta.

---

## 20. Observabilidad: logging, analytics, tracing y crash reporting

## 20.1. Logging

Se distinguen niveles:

- debug
- info
- warning
- error
- critical

Reglas:

- no loggear PII;
- no loggear tokens;
- no loggear bodies completos salvo entorno seguro y redacción aplicada;
- contexto útil siempre: feature, use case, request id, user id anonimizado si procede.

## 20.2. Analytics

Cada evento debe tener:

- nombre estable;
- contexto funcional;
- parámetros aprobados;
- ownership;
- decisión sobre si es obligatorio o no.

## 20.3. Performance monitoring

Medir al menos:

- arranque frío;
- tiempo a primera pantalla usable;
- tiempo a dato visible por pantalla crítica;
- errores de red por endpoint;
- crashes por versión/build.

## 20.4. Breadcrumbs

Antes de un fallo relevante conviene tener breadcrumbs de:

- navegación;
- acciones importantes;
- requests críticas;
- cambios de sesión;
- toggles de feature flag.

---

## 21. Localización, formatos y textos

Flutter documenta que, para soportar otros idiomas, la app debe configurar `flutter_localizations`, `supportedLocales` y el flujo de generación de recursos localizados; además, el flujo moderno incluye `intl` y generación desde configuración `l10n`. citeturn430061view5

## 21.1. Regla general

Toda app de producto debe ser localizable desde el principio.

## 21.2. Estructura recomendada

```text
lib/l10n/
  app_es.arb
  app_en.arb
l10n.yaml
```

## 21.3. Reglas

- nada de strings hardcodeadas en widgets salvo prototipos efímeros;
- placeholders, plurales y selects definidos correctamente;
- formatos de fecha, moneda y número dependientes de locale;
- textos de error de usuario también localizados;
- accesibilidad y labels también localizados.

## 21.4. Textos técnicos vs funcionales

- mensajes internos de log: no necesitan localización;
- mensajes de usuario: sí;
- códigos de error: pueden ser internos, pero nunca mostrarse crudos.

---

## 22. Theming y design system

## 22.1. Tema único de aplicación

`app/theme/` define:

- color scheme;
- typography;
- component themes;
- spacing scale;
- radii/elevation tokens.

## 22.2. Regla de consumo

Las features no inventan colores hex ni `TextStyle` inline arbitrarios.

Preferido:

- tokens;
- componentes de design system;
- extensiones de theme controladas.

## 22.3. Dark mode y high contrast

Decisión obligatoria por proyecto:

- soportado desde el inicio;
- soportado más adelante;
- no soportado por alcance.

Lo importante es que quede explícito.

---

## 23. Accesibilidad

Tu documento actual ya incluye a11y como preocupación, pero aquí pasa a ser parte contractual del proyecto. fileciteturn1file12

## 23.1. Mínimos obligatorios

- labels/semantics en componentes interactivos relevantes;
- orden lógico de foco;
- targets táctiles adecuados;
- contraste suficiente;
- feedback no exclusivamente dependiente del color;
- textos escalables y layouts robustos.

## 23.2. Regla de componentes

Todo componente del design system debe nacer accesible o con contrato explícito de accesibilidad.

## 23.3. Checklist de PR

Toda UI nueva debe responder:

- ¿se puede entender con lector de pantalla?
- ¿se puede usar con tamaño de texto aumentado?
- ¿el foco es coherente?
- ¿el error se percibe sin depender del color?
- ¿los labels están localizados?

---

## 24. Seguridad

## 24.1. Principios

- minimizar exposición de datos;
- no confiar en el cliente para seguridad de negocio;
- endurecer almacenamiento local;
- sanitizar entradas y salidas;
- proteger trazas y logs;
- revisar apertura de enlaces externos.

## 24.2. Reglas concretas

- tokens en secure storage;
- secretos reales nunca embebidos;
- URLs externas validadas;
- logs redactados;
- borrar sesión en logout de forma completa;
- evitar serializar datos sensibles en analytics/crash reports.

## 24.3. PII

Debe existir una lista explícita de campos sensibles del proyecto.

Ejemplos comunes:

- documento de identidad;
- email;
- teléfono;
- dirección;
- datos bancarios;
- tokens;
- datos sanitarios.

Cualquier tratamiento de estos datos exige revisión.

---

## 25. Performance

## 25.1. Presupuestos mínimos

Toda app debe definir objetivos aproximados para:

- startup;
- carga de pantallas críticas;
- scrolling fluido;
- peso de APK/IPA;
- consumo de red;
- coste de rebuilds.

## 25.2. Reglas de UI

- usar `const` cuando aporte valor;
- evitar trabajo costoso en `build`;
- paginar listas grandes;
- desacoplar estados para no reconstruir árboles innecesarios;
- evitar `setState` disperso si el proyecto usa Riverpod.

## 25.3. Reglas de datos

- batch requests cuando tenga sentido;
- caché razonable;
- compresión y payloads acotados;
- parseo fuera de hot paths si fuese costoso.

---

## 26. Estrategia de testing

Flutter recomienda combinar muchos unit y widget tests con suficientes integration tests para cubrir los casos importantes, asumiendo los trade-offs de confianza, coste de mantenimiento y velocidad. citeturn436078view0

Tu guía de testing ya define una pirámide clara con unit, BDD/widget-like, goldens y E2E/integration. fileciteturn2file1 Ese modelo se consolida así:

## 26.1. Pirámide normativa

1. **Unit tests**  
   Dominio, mappers, utilidades, validadores.

2. **Widget / BDD tests**  
   Comportamiento de UI, rutas, estados visuales, interacción.

3. **Golden tests**  
   Estados críticos y regresiones visuales.

4. **Integration / E2E tests**  
   Flujos extremos a extremo y smoke/regresión crítica.

Flutter define tres categorías principales: unit, widget e integration tests, con distinta confianza y coste. citeturn436078view0turn436078view1

## 26.2. Reglas por capa

### Dominio
- un test por caso de uso mínimo;
- happy path y error path;
- mocks de repositorios;
- no tocar red ni disco.

### Data
- tests de mappers;
- tests de repositorios;
- contract tests del cliente generado;
- tests de parsing y errores.

### Presentación
- controller/notifier tests;
- widget tests de pantallas importantes;
- validación de loading, data, error y empty.

### Integración
- login;
- restauración de sesión;
- navegación principal;
- flujo crítico de negocio;
- errores recuperables principales.

## 26.3. Cliente generado y contratos HTTP

Tu `test_quality_guide.md` ya fija una barra mínima muy buena para endpoints: método, path, query, headers, body, content-type, auth, parseo, errores, transporte, nullability y binarios. fileciteturn2file2 Esa matriz se vuelve contractual.

Regla:

Ningún endpoint se da por validado solo porque compile o porque un builder round-trip pase. El cierre exige comportamiento observable de contrato y transporte. fileciteturn1file5turn2file2

## 26.4. Organización

Se mantiene la separación ya descrita en tu guía:

- `test/` para unit/widget/BDD;
- `integration_test/` para integración;
- goldens por feature;
- helpers compartidos controlados. fileciteturn2file1turn1file14

## 26.5. CI

Los tests automáticos mínimos en CI deben incluir:

- análisis estático;
- generación de código verificada;
- unit tests;
- widget/BDD tests;
- golden checks si el pipeline lo soporta;
- integration tests en job específico si el entorno está preparado.

---

## 27. Release, versionado y changelog

Tu política actual de versionado usa SemVer `MAJOR.MINOR.PATCH+BUILD`, build autoincrementado en CI, tags `vX.Y.Z`, convención de commits y changelog automatizado. fileciteturn2file3turn1file15 Eso se integra aquí sin cambios de fondo.

## 27.1. Regla

`pubspec.yaml` es la fuente de verdad funcional de versión de la app, con build number sobrescribible por CI. fileciteturn2file3

## 27.2. Pipeline mínimo de release

- branch de release o estrategia trunk claramente definida;
- bump de versión;
- generación de changelog;
- tag;
- build firmada;
- despliegue;
- release notes.

## 27.3. Convención de commits

Se mantiene convención estructurada porque favorece:

- changelog;
- auditoría;
- revisión de PR;
- lectura semántica de cambios. fileciteturn1file15

---

## 28. Lints, formato y verificaciones automáticas

## 28.1. `analysis_options.yaml`

Debe endurecer:

- warnings como errores cuando sea viable;
- reglas contra imports no permitidos si se dispone de lint custom;
- reglas de estilo del proyecto;
- exclusiones mínimas.

## 28.2. Custom lints

Muy recomendable crear un package interno `app_lints` o `custom_lint` para verificar:

- imports prohibidos entre capas;
- imports cruzados entre features;
- naming;
- rutas de carpetas;
- uso de `StateNotifier` en nuevo código;
- strings hardcodeadas en UI;
- acceso directo a `String.fromEnvironment`.

## 28.3. Build verification

CI debe fallar si:

- `build_runner` genera diffs no commiteados;
- faltan archivos generados;
- hay goldens pendientes de actualizar de forma no justificada;
- el análisis estático falla;
- la cobertura mínima crítica cae por debajo del umbral acordado.

---

## 29. ADRs y gestión de excepciones

## 29.1. Cuándo hace falta ADR

Crear ADR cuando se cambie:

- state management;
- estrategia de routing;
- estructura del repo;
- sistema de errores;
- forma de cachear;
- estrategia offline;
- release process;
- integración crítica con SDKs;
- cualquier excepción relevante a este canon.

## 29.2. Formato mínimo de ADR

- contexto;
- decisión;
- alternativas consideradas;
- consecuencias;
- fecha;
- estado.

## 29.3. Regla

Una excepción sin ADR no es arquitectura; es deriva.

---

## 30. Ejemplo normativo de una feature completa

## 30.1. Estructura

```text
lib/features/profile/
  0_entity/
    entities/
      user_profile.dart
    value_objects/
      profile_id.dart
    entity.dart
  1_domain/
    repositories/
      profile_repository.dart
    usecases/
      fetch_profile_usecase.dart
      update_profile_usecase.dart
    domain.dart
  2_presentation/
    states/
      profile_state.dart
    providers/
      profile_providers.dart
    controllers/
      profile_controller.dart
    routes/
      routes.dart
    pages/
      profile_page.dart
      edit_profile_page.dart
    widgets/
      profile_header.dart
      profile_form.dart
    presentation.dart
  3_data/
    api/
      profile_api.dart
    dto/
      user_profile_dto.dart
    mappers/
      user_profile_mapper.dart
    repositories/
      profile_repository_impl.dart
    data.dart
```

## 30.2. Flujo

1. `ProfilePage` observa `profileControllerProvider`
2. `ProfileController` llama a `FetchProfileUseCase`
3. `FetchProfileUseCase` usa `ProfileRepository`
4. `ProfileRepositoryImpl` llama a `ProfileApi`
5. `ProfileApi` usa `Dio`
6. DTO -> Mapper -> Entity
7. Entity -> State -> UI

## 30.3. Resultado esperado

- UI sin conocimiento de HTTP;
- dominio sin conocimiento de Flutter;
- repositorio sin navegación;
- errores tipados;
- testabilidad completa.

---

## 31. Anti-patrones prohibidos

### 31.1. Feature god object
Un único controller que hace UI, validación, navegación, llamadas HTTP y persistencia.

### 31.2. DTO leak
Exponer modelos de red fuera de `3_data`.

### 31.3. Singleton manual
Instanciar servicios globales con variables estáticas opacas.

### 31.4. Service locator encubierto
Acceder a dependencias desde cualquier sitio sin trazabilidad.

### 31.5. `BuildContext` en dominio/data
Acopla capas internas a Flutter.

### 31.6. Navegación desde cualquier helper
Hace imposible entender el flujo.

### 31.7. Stringly-typed everything
Rutas, claves, analytics y errores como strings mágicos por todos lados.

### 31.8. `utils.dart`
Fichero o carpeta comodín sin ownership.

### 31.9. Error crudo al usuario
Mostrar `DioException`, stack trace o body backend tal cual.

### 31.10. Una carpeta `models/` global
Mezcla entidad, DTO y estado sin fronteras.

### 31.11. Lógica en el constructor del notifier
Prohibido por contrato y por la propia guía de Riverpod. citeturn430061view2

---

## 32. Checklist de creación de proyecto

- [ ] Definidos entry points por entorno
- [ ] Definido `AppConfig`
- [ ] Definido bootstrap único
- [ ] Definido router global
- [ ] Definido logger común con redacción
- [ ] Definido cliente Dio común
- [ ] Definido storage seguro y no seguro
- [ ] Definido sistema de errores
- [ ] Definido design system mínimo
- [ ] Definida localización base
- [ ] Definida estrategia de tests
- [ ] Definido versionado/release
- [ ] Definidas reglas de lint
- [ ] Documentado ADR inicial de stack si hace falta

---

## 33. Checklist de creación de feature

- [ ] Nombre en snake_case
- [ ] Estructura 0/1/2/3 creada
- [ ] Entidades definidas
- [ ] Repositorio abstracto definido
- [ ] Use cases definidos
- [ ] API/datasources definidos
- [ ] Mapper explícito
- [ ] Repositorio concreto implementado
- [ ] Providers de composición creados
- [ ] Controller/notifier creado
- [ ] Estado de pantalla definido
- [ ] Página/s y widgets creados
- [ ] Ruta registrada
- [ ] Unit tests de dominio
- [ ] Tests de mappers/repositorio
- [ ] Tests de controller/widget
- [ ] Strings localizadas
- [ ] Accesibilidad mínima revisada
- [ ] Analytics/monitoring evaluados

---

## 34. Checklist de PR

- [ ] No hay imports prohibidos entre capas
- [ ] No hay imports internos cruzados entre features no autorizados
- [ ] La feature no crea `Dio`, storage ni SDKs directamente
- [ ] Los errores están mapeados correctamente
- [ ] No se exponen DTOs fuera de `3_data`
- [ ] No hay strings de UI hardcodeadas sin justificación
- [ ] El estado de pantalla es explícito y coherente
- [ ] Hay tests en la capa adecuada
- [ ] Los logs no exponen PII
- [ ] La accesibilidad mínima está cubierta
- [ ] La navegación está registrada en el punto correcto
- [ ] Si hubo excepción al canon, existe ADR

---

## 35. Reglas de naming

## 35.1. Archivos
`snake_case.dart`

## 35.2. Clases y tipos
`PascalCase`

## 35.3. Variables y funciones
`camelCase`

## 35.4. Providers
Sufijo `Provider`

## 35.5. Use cases
Sufijo `UseCase` o `Usecase`, pero una sola convención por repo.  
Recomendación: **`UseCase`** por legibilidad.

## 35.6. Repositorios
- abstracción: `ProfileRepository`
- implementación: `ProfileRepositoryImpl`

## 35.7. Estados
`<Feature>State`

## 35.8. Resultados
`<Action>Result`, `<Action>Success`, `<Action>Failed`

---

## 36. Decisiones por defecto del proyecto

Estas son las decisiones por defecto salvo ADR contrario:

- arquitectura por `app/ + core/ + features/`
- features con capas `0_entity/1_domain/2_presentation/3_data`
- Riverpod con `@riverpod`
- `Notifier/AsyncNotifier` para nuevo código
- GoRouter para routing
- Dio para networking
- config tipada vía `AppConfig`
- `dart-define-from-file` para configuración compilada
- secure storage para tokens
- errores tipados
- test pyramid con unit + widget/BDD + golden + integration
- versionado semántico + build CI
- logs redactados
- localización desde el inicio
- design system centralizado
- cero imports laterales arbitrarios entre features

---

## 37. Relación con la documentación previa

Este canon **absorbe y amplía** varios elementos que ya existían:

- la modularización por feature y las capas 0/1/2/3 del documento actual; fileciteturn2file0
- la política de providers y Riverpod ya recogida allí; fileciteturn1file10
- la configuración por entorno basada en `dart-define-from-file`; fileciteturn1file6turn1file9
- la pirámide y workflows de testing; fileciteturn2file1turn1file11
- la barra mínima de calidad para endpoints generados; fileciteturn2file2turn1file5
- la política de versionado y release; fileciteturn2file3turn1file15

La diferencia es que ahora el documento deja de centrarse casi solo en la feature y pasa a cubrir también:

- app bootstrap;
- shell;
- core transversal;
- taxonomía de errores;
- observabilidad;
- seguridad;
- entorno y build;
- gobierno de excepciones;
- checklists de proyecto completo.

---

## 38. Criterio final de calidad

Un proyecto Flutter conforme a este canon no es solo uno que “funciona”.

Es uno en el que:

- el código tiene fronteras entendibles;
- los defaults son explícitos;
- las features son localizables y testeables;
- los errores y side effects son trazables;
- la infraestructura no contamina el dominio;
- la UI no improvisa arquitectura;
- el equipo puede añadir funcionalidades sin reescribir medio proyecto.

Si una implementación obliga a preguntar constantemente “¿dónde va esto?”, “¿quién crea esto?”, “¿desde dónde se navega?”, “¿dónde se maneja este error?” o “¿quién es dueño de este dato?”, entonces todavía no cumple el objetivo de este documento.

---

## 39. Próximo paso recomendado

Convertir este canon en un sistema verificable:

1. `analysis_options.yaml` endurecido  
2. `custom_lint` para imports y capas  
3. plantilla de feature scaffold  
4. PR checklist enlazada a este documento  
5. ADR template  
6. ejemplo real de feature gold standard en el repo

Ese paso es el que convierte la arquitectura de “texto bonito” en arquitectura operativa.