# Anexo A — Fundamentos, repositorio, app y core

Derivado de `architecture_canon_flutter_v2.md`.

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

