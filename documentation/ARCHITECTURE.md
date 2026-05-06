# Clean Architecture modular por features para Flutter

**Última actualización:** 30 de diciembre de 2025

---

> **Nota:** Este documento contiene la especificación técnica y las reglas de arquitectura. Si buscas una visión general breve del proyecto y cómo empezar, consulta `documentation/README.md`.

---

## 📑 Índice

### PARTE I: Fundamentos de Arquitectura

1. [Propósito del documento](#1-propósito-del-documento)
2. [Principios de diseño](#2-principios-de-diseño)
3. [Estructura general del proyecto](#3-estructura-general-del-proyecto)
4. [Contrato de una feature](#4-contrato-de-una-feature)
5. [Capas en detalle](#5-capas-en-detalle)
   - [Capa 0: Entity](#51-capa-0-entity)
   - [Capa 1: Domain](#52-capa-1-domain)
   - [Capa 2: Presentation](#53-capa-2-presentation)
   - [Capa 3: Data](#54-capa-3-data)

### PARTE II: Implementación Técnica

6. [Navegación y Routing (GoRouter)](#6-navegación-y-routing-con-gorouter)
7. [Reglas de dependencia e imports](#7-reglas-de-dependencia-e-imports)
   - [Barrel files y exports](#73-barrels)
8. [Inyección de dependencias (Riverpod 3)](#8-inyección-de-dependencias-con-riverpod-3)
   - [Anti-patrones y errores comunes](#81-anti-patrones-y-errores-comunes-crítico-para-claude-code)
9. [Networking y autenticación](#9-networking-y-autenticación)
   - [Configuración de entornos](#91-configuración-de-entorno-libenvdart)
10. [Logging y errores](#10-logging-y-errores)
11. [Testing](#11-testing)

### PARTE III: Calidad y Buenas Prácticas

12. [Ciclo de vida de una nueva feature](#12-ciclo-de-vida-de-una-nueva-feature)
13. [Extensibilidad y modularidad](#13-extensibilidad-y-modularidad)
14. [Manejo de errores y excepciones](#14-manejo-de-errores-y-excepciones)
15. [Performance y Optimización](#15-performance-y-optimización)
16. [Accesibilidad (A11y)](#16-accesibilidad-a11y)
17. [Seguridad](#17-seguridad)
18. [Convenciones de Naming](#18-convenciones-de-naming)
19. [Riverpod 3.0 - Buenas Prácticas Críticas](#19-riverpod-30---buenas-prácticas-críticas)

### PARTE IV: Workflows y Checklists

20. [Checklist de PR (mínimo requerido)](#20-checklist-de-pr-mínimo-requerido)
21. [Workflow completo para Claude Code](#21-workflow-completo-para-claude-code-crear-una-feature-desde-cero)
22. [Prompts de Referencia](#22-prompts-de-referencia)
23. [Referencias y notas finales](#23-referencias-y-notas-finales)

---

## 1. Propósito del documento

Este documento define cómo estructuramos el código en este proyecto Flutter:

- Qué capas existen y qué hace cada una
- Cómo debe organizarse una feature
- Qué dependencias están permitidas y cuáles están prohibidas
- Cómo modelamos casos de uso, resultados, repositorios, estado y UI
- Qué esperamos a nivel de testing y mantenibilidad

> **Este documento se considera un contrato de arquitectura** que las features nuevas deben cumplir.

---

## 2. Principios de diseño

La arquitectura se basa en:

- **Modularización por feature**: Cada feature tiene su propio mini-módulo con las mismas capas
- **Clean Architecture**: Separación clara entre:
  - Entidades de dominio
  - Lógica de negocio
  - UI
  - Infraestructura (APIs, repos, storage)
- **Dependencias unidireccionales**: Solo se puede depender "hacia abajo" (`infraestructura → dominio → entidades`)
- **SOLID**:
  - Una clase = una responsabilidad
  - Dependemos de abstracciones, no de implementaciones
  - Clases abiertas a extensión, cerradas a modificación cuando sea posible
- **Testabilidad como requisito**: Todo lo que no se pueda testear fácilmente se considera sospechoso
- **Previsibilidad**: Cualquier desarrollador debería poder abrir `lib/features/<feature>` y entender qué hay y dónde tocar

---

## 3. Estructura general del proyecto

```text
lib/
  features/
    <feature>/
      0_entity/         # Entidades de dominio (freezed, inmutables, sin dependencias externas)
      1_domain/         # Lógica de negocio, casos de uso, repositorios abstractos
        usecases/       # Un archivo por caso de uso, *_usecase.dart
        repositories/   # Interfaces de repositorios
        services/       # Servicios de dominio si son necesarios
        domain.dart     # Barrel de la capa de dominio
      2_presentation/   # UI, estado, controladores
        pages/          # Pantallas principales
        widgets/        # Widgets reutilizables
        controllers/    # Notifiers / controllers de UI
        providers/      # Providers de Riverpod 3
        presentation.dart  # Barrel de presentación
      3_data/           # Infraestructura: API, mappers, repos concretos
        api/            # Clases de API (Dio), DTOs
        mappers/        # Conversores DTO ⇄ Entity
        repositories/   # Implementaciones de repositorios de dominio
        data.dart       # Barrel de data
  http_client.dart       # Config global de Dio + interceptores
  navigation.dart        # Config de go_router
  logger.dart            # Logging centralizado
  setup.dart             # Inicialización de dependencias globales
  theme/                 # Tema y estilos compartidos
  localization/          # Internacionalización (.arb)
  main.dart              # Entry point real
  main.mocked.dart       # Entry point con providers mockeados / escenario de test
```

> **Regla general:** dentro de una feature, las carpetas `0_entity`, `1_domain`, `2_presentation` y `3_data` son obligatorias, aunque inicialmente estén casi vacías.

### 3.1. Código generado con OpenAPI 3.0

El directorio `generated/` contiene las implementaciones de cliente API generadas automáticamente a partir de especificaciones OpenAPI 3.0:

```text
generated/
  navarra_empleo_api/     # Cliente API generado con openapi_generator
    lib/
      api/                # Clases de API (endpoints)
      model/              # DTOs/modelos generados
    doc/                  # Documentación autogenerada
```

**Características del código generado:**
- **Generado con `openapi_generator`**: Garantiza sincronización con el contrato del backend
- **DTOs completos**: Todos los modelos de request/response con serialización JSON
- **Endpoints tipados**: Métodos para cada operación de la API con tipos seguros
- **Documentación incluida**: Cada modelo y endpoint tiene su documentación en `doc/`

**Reglas de uso:**
- Las features **NO deben importar directamente** desde `generated/`
- La capa `3_data/api/` de cada feature actúa como **wrapper** del cliente generado
- Los DTOs generados se mapean a entidades de dominio mediante `3_data/mappers/`
- Para regenerar el código:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```

**Ejemplo de uso correcto:**
```dart
// ❌ INCORRECTO: Importar directamente desde generated en presentación
import 'package:generated/navarra_empleo_api/api.dart';

// ✅ CORRECTO: La capa 3_data envuelve el cliente generado
class InscripcionesApi {
  final navarra_empleo_api.InscripcionesApi _generatedApi;
  
  InscripcionesApi(Dio dio) 
    : _generatedApi = navarra_empleo_api.InscripcionesApi(dio);
  
  Future<List<InscripcionDto>> getInscripciones() async {
    final response = await _generatedApi.obtenerInscripciones();
    return response.data?.inscripciones ?? [];
  }
}
```

---

## 4. Contrato de una feature

Una feature es un módulo funcional completo (ej: `presence`, `auth`, `profile`, etc.) que:

- Tiene sus propias entidades, casos de uso, UI y data
- Puede, idealmente, extraerse a un package sin romper el resto de la app
- Solo expone lo necesario a través de sus barrels (`domain.dart`, `presentation.dart`, `data.dart`)

### 4.1. Naming de feature

- Directorio: `lib/features/<feature_name>/`
- `<feature_name>` en snake_case: `presence`, `user_profile`, `session_history`, etc.

---

## 5. Capas en detalle

### 5.1. Capa 0 – Entity (`0_entity/`)

**Responsabilidad:**
- Representar el modelo de dominio de la feature
- Ser independiente de cualquier tecnología (no Flutter, no Dio, no JSON)

**Reglas:**
- Las entidades se definen con `freezed` + `json_serializable` cuando tiene sentido
- **No se puede importar nada de:**
  - `dart:io`
  - `package:flutter/*`
  - Dio, Riverpod ni nada de UI o infraestructura
- Pueden tener:
  - Lógica de validación simple
  - Métodos de utilidad que no dependan de IO

**Ejemplo:**
```dart
@freezed
abstract class StandPresence with _$StandPresence {
  const factory StandPresence({
    required String id,
    required String standName,
    required DateTime checkinTime,
    DateTime? checkoutTime,
  }) = _StandPresence;

  factory StandPresence.empty() => StandPresence(
    id: '',
    standName: '',
    checkinTime: DateTime.fromMillisecondsSinceEpoch(0),
  );
}
```

---

### 5.2. Capa 1 – Domain (`1_domain/`)

**Responsabilidad:**
- Contener la lógica de negocio y las reglas del sistema
- Definir lo que la app "sabe hacer" sin preocuparse de cómo se implementa técnicamente

**Componentes:**
- Usecases (`usecases/`)
- Repositorios abstractos (`repositories/`)
- Servicios de dominio (`services/`, opcional)

#### 5.2.1. Casos de uso

**Reglas:**
- Archivo: `<action>_usecase.dart`
- Clase: `<Action>Usecase`
- La salida debe ser un resultado sellado: `<Action>Result` con subclases `Success` y `Failed`
- **No se puede importar nada de:**
  - `2_presentation`
  - `3_data`
  - `package:flutter/*`
  - Dio, Riverpod

**Ejemplo:**
```dart
sealed class FetchCheckinsResult {}

class FetchCheckinsSuccess extends FetchCheckinsResult {
  final List<Checkin> checkins;
  FetchCheckinsSuccess(this.checkins);
}

class FetchCheckinsFailed extends FetchCheckinsResult {
  final String message;
  FetchCheckinsFailed(this.message);
}

class FetchCheckinsUsecase {
  final PresenceRepository _repository;

  FetchCheckinsUsecase(this._repository);

  Future<FetchCheckinsResult> execute() async {
    try {
      return FetchCheckinsSuccess(await _repository.fetchCheckins());
    } catch (e, s) {
      // El logging se hace fuera, aquí solo empaquetamos el error
      return FetchCheckinsFailed(e.toString());
    }
  }
}
```

#### 5.2.2. Repositorios abstractos

Definen qué necesita el dominio, no cómo.
Tienen métodos con entidades de dominio, no DTOs de la API.

```dart
abstract class PresenceRepository {
  Future<List<Checkin>> fetchCheckins();
  Future<Checkin> sendCheckin(Checkin checkin);
}
```

---

### 5.3. Capa 2 – Presentation (`2_presentation/`)

**Responsabilidad:**
- Poner la información en pantalla
- Gestionar el estado de UI
- Orquestar casos de uso → estado → renderización

**Subcarpetas:**
- `pages/` → pantallas principales
- `widgets/` → widgets reutilizables
- `controllers/` → lógica de UI (Notifiers, controllers)
- `providers/` → definición de providers de Riverpod 3

**Reglas:**
- No se puede hacer llamadas directas a APIs aquí
- No se puede importar ninguna clase de `3_data`
- Solo se consumen usecases y repositorios vía providers

**Ejemplo de provider + controller:**
```dart
final fetchCheckinsUsecaseProvider = Provider<FetchCheckinsUsecase>((ref) {
  final repo = ref.read(presenceRepositoryProvider);
  return FetchCheckinsUsecase(repo);
});

class CheckinsController extends AsyncNotifier<List<Checkin>> {
  @override
  Future<List<Checkin>> build() async {
    final usecase = ref.read(fetchCheckinsUsecaseProvider);
    final result = await usecase.execute();

    return switch (result) {
      FetchCheckinsSuccess s => s.checkins,
      FetchCheckinsFailed f => throw Exception(f.message),
    };
  }
}

final checkinsControllerProvider =
    AsyncNotifierProvider<CheckinsController, List<Checkin>>(CheckinsController.new);
```

> 🔁 Navegación (`go_router`) se define fuera de la feature, pero las pantallas de la feature se importan desde `presentation.dart`.

---

### 5.4. Capa 3 – Data (`3_data/`)

**Responsabilidad:**
- Acceso a recursos externos:
  - APIs HTTP
  - Almacenamiento local
  - Servicios de terceros
- Convertir datos externos (DTOs) a entidades de dominio y viceversa

**Subcarpetas:**
- `api/` → Wrappers del cliente generado, endpoints personalizados, DTOs adicionales
- `mappers/` → mappers DTO ⇄ Entity
- `repositories/` → implementaciones de `PresenceRepository`, etc.

**Reglas:**
- Esta capa **sí puede importar:**
  - `lib/http_client.dart`
  - `lib/logger.dart`
  - `package:generated/navarra_empleo_api/api.dart` (cliente API generado)
  - Dio y otras librerías de infraestructura
- No puede importar nada de `2_presentation`
- Debe exponer implementaciones que cumplan los contratos de dominio
- Los DTOs del código generado se mapean a entidades de dominio, **nunca se exponen fuera de `3_data/`**

**Ejemplo de API (wrapper del cliente generado):**
```dart
import 'package:generated/navarra_empleo_api/api.dart' as navarra_api;

class InscripcionesApi {
  final navarra_api.InscripcionesApi _generatedApi;

  InscripcionesApi(Dio dio) 
    : _generatedApi = navarra_api.InscripcionesApi(dio);

  Future<List<InscripcionDto>> getInscripciones() async {
    try {
      final response = await _generatedApi.obtenerInscripciones();
      // Convertir del modelo generado a nuestro DTO interno si es necesario
      return response.data?.inscripciones ?? [];
    } catch (e) {
      // El error se propaga al repositorio
      rethrow;
    }
  }
}
```

**Ejemplo alternativo (endpoint personalizado no generado):**
```dart
class CustomPresenceApi {
  final Dio _dio;

  CustomPresenceApi(this._dio);

  Future<List<CheckinDto>> getCheckins() async {
    final response = await _dio.get('/checkins');
    final data = response.data as List<dynamic>;
    return data.map((json) => CheckinDto.fromJson(json as Map<String, dynamic>)).toList();
  }
}
```

**Ejemplo de repository:**
```dart
class PresenceRepositoryImpl implements PresenceRepository {
  final PresenceApi _api;
  final CheckinMapper _mapper;

  PresenceRepositoryImpl(this._api, this._mapper);

  @override
  Future<List<Checkin>> fetchCheckins() async {
    final dtos = await _api.getCheckins();
    return dtos.map(_mapper.dtoToEntity).toList();
  }
}
```

---

## 6. Navegación y Routing con GoRouter

### 6.1. Arquitectura de rutas por feature

Cada feature define sus propias rutas en un archivo dedicado siguiendo este patrón:

```text
features/
  <feature>/
    2_presentation/
      routes/
        routes.dart     # Define appointmentsRoutesProvider
      pages/            # Las páginas referenciadas en las rutas
      providers/
      controllers/
```

### 6.2. Definición de rutas en una feature

**Archivo:** `lib/features/appointments/2_presentation/routes/routes.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hiberus_scaffold/features/appointments/2_presentation/pages/appointments_home_page.dart';
import 'package:hiberus_scaffold/features/appointments/2_presentation/pages/my_appointments_page.dart';

/// Provider para las rutas de la feature de Cita Previa
final appointmentsRoutesProvider = Provider<List<GoRoute>>((final ref) {
  return [
    GoRoute(
      path: '/appointments',
      builder: (final context, final state) => const AppointmentsHomePage(),
      routes: [
        // Rutas anidadas
        GoRoute(
          path: 'new',
          builder: (final context, final state) => const SelectAgencyPage(),
          routes: [
            GoRoute(
              path: 'select-service',
              builder: (final context, final state) => const SelectServicePage(),
            ),
          ],
        ),
        GoRoute(
          path: 'my-appointments',
          builder: (final context, final state) => const MyAppointmentsPage(),
        ),
      ],
    ),
  ];
});
```

**⚠️ CRÍTICO - Patrón obligatorio para rutas:**

- ✅ **CORRECTO**: Usar un **Provider de Riverpod** que devuelve `List<GoRoute>`
- ❌ **INCORRECTO**: Definir rutas como lista estática (ej: `final certificatesRoutes = [GoRoute(...)]`)

**Razón del patrón:**
- **Consistencia arquitectónica**: Todas las features usan el mismo patrón
- **Reactividad**: Las rutas pueden depender de otros providers si es necesario
- **Testabilidad**: Los providers se pueden mockear fácilmente
- **Inyección de dependencias**: Mantiene la filosofía de Riverpod en toda la app

**Características importantes:**
- Nombrado como `<feature>RoutesProvider` (con sufijo `Provider`)
- Todas las rutas de la feature están contenidas dentro del provider
- Las rutas anidadas se definen con el parámetro `routes: []` de GoRoute
- Los path anidados son **relativos** (`'new'` bajo `/appointments` = `/appointments/new`)

### 6.3. Registro en el router global

**Archivo:** `lib/navigation/navigation.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hiberus_scaffold/features/appointments/2_presentation/routes/routes.dart' as appointments_routes;
import 'package:hiberus_scaffold/features/inscripciones/2_presentation/routes.dart' as inscripciones_routes;
import 'package:hiberus_scaffold/features/login/2_presentation/routes.dart' as login_routes;

final allRoutesProvider = Provider<List<GoRoute>>((final ref) {
  return [
    ...ref.watch(login_routes.loginRoutesProvider),
    ...ref.watch(appointments_routes.appointmentsRoutesProvider),
    ...ref.watch(inscripciones_routes.inscripcionesRoutesProvider),
    // Más features...
  ];
});

final goRouterProvider = Provider<GoRouter>((final ref) {
  final routes = ref.watch(allRoutesProvider);
  return GoRouter(
    routes: routes,
    redirect: (final context, final state) {
      final isRoot = state.uri.path == '/' && state.uri.query.isEmpty;
      if (isRoot) {
        return '/login';
      }
      return null;
    },
  );
});
```

**Pasos para agregar una nueva feature:**
1. Importar el archivo de rutas con un alias: `as <feature>_routes`
2. Añadir el spread operator en `allRoutesProvider`: `...ref.watch(<feature>_routes.<feature>RoutesProvider)`

### 6.4. Migración de rutas placeholder

Cuando una feature se migra de un placeholder a implementación completa:

**Antes** (en `main_home/routes.dart`):
```dart
GoRoute(path: '/cita_previa', builder: (final c, final s) => placeholder('Cita Previa')),
```

**Después** (comentado):
```dart
// GoRoute(path: '/cita_previa', builder: (final c, final s) => placeholder('Cita Previa')), // Migrado a feature appointments
```

Esto deja claro que la ruta fue movida y evita duplicados.

### 6.5. Navegación en el código

**Navegación simple:**
```dart
// En un widget o controller
context.go('/appointments');
context.push('/appointments/new');
context.pop();
```

**Navegación con parámetros de ruta:**
```dart
// Definición de ruta
GoRoute(
  path: 'details/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return DetailsPage(id: id);
  },
),

// Navegación
context.go('/appointments/details/123');
```

**Navegación con query parameters:**
```dart
// Navegación
context.go('/appointments?filter=active');

// Lectura en la página
final state = GoRouterState.of(context);
final filter = state.uri.queryParameters['filter'];
```

### 6.6. Checklist para agregar rutas de una nueva feature

- [ ] Crear `features/<feature>/2_presentation/routes/routes.dart`
- [ ] Definir `<feature>RoutesProvider` que devuelve `List<GoRoute>`
- [ ] Importar páginas necesarias desde `2_presentation/pages/`
- [ ] Definir estructura de rutas (principal + anidadas)
- [ ] Importar el provider en `lib/navigation/navigation.dart` con alias
- [ ] Agregar spread del provider en `allRoutesProvider`
- [ ] Si migra una ruta existente, comentar la antigua en `main_home/routes.dart`
- [ ] Probar navegación con `context.go()` o `context.push()`

---

## 7. Reglas de dependencia e imports

### 7.1. Flujo permitido

```text
3_data  →  1_domain  →  0_entity
2_presentation → 1_domain → 0_entity
```

### 7.2. Prohibido

- `2_presentation` importando `3_data`
- `1_domain` importando `2_presentation` o `3_data`
- Widgets importando directamente API o repositorios concretos
- Llamadas a Dio fuera de `3_data/api`

### 7.3. Barrels

Cada capa puede tener un barrel:
- `1_domain/domain.dart`
- `2_presentation/presentation.dart`
- `3_data/data.dart`

**Regla recomendada:**
- Desde fuera de la feature se importa el barrel:
  ```dart
  import 'package:app/features/presence/2_presentation/presentation.dart';
  ```
- Dentro de la feature se puede importar directamente archivos internos si tiene sentido, pero se prioriza el uso de barrels

#### 7.3.1. Patrón de barrel files (CRÍTICO)

**Archivo:** `lib/features/<feature>/1_domain/domain.dart`
```dart
// Exportar SOLO interfaces y casos de uso, NO implementaciones
export 'repositories/user_repository.dart';
export 'usecases/fetch_user_usecase.dart';
export 'usecases/update_profile_usecase.dart';

// NO exportar nada de 3_data desde aquí
```

**Archivo:** `lib/features/<feature>/2_presentation/presentation.dart`
```dart
// Exportar providers, páginas y widgets reutilizables
export 'providers/providers.dart';
export 'pages/user_profile_page.dart';
export 'pages/edit_profile_page.dart';
export 'widgets/user_card.dart';

// NO exportar controllers internos a menos que otras features los necesiten
```

**Archivo:** `lib/features/<feature>/3_data/data.dart`
```dart
// Exportar SOLO la implementación del repositorio
export 'repositories/user_repository_impl.dart';

// NO exportar APIs, DTOs ni mappers (son internos a la capa)
```

**Archivo:** `lib/features/<feature>/<feature>.dart` (barrel raíz, opcional)
```dart
// Re-exporta los barrels de las capas
export '1_domain/domain.dart';
export '2_presentation/presentation.dart';
// NO exportar 3_data (las implementaciones se inyectan via providers)
```

---

### 7.4. EJEMPLO COMPLETO: Feature "User Profile" paso a paso

> **📘 Detailed Guide:** For a complete step-by-step example of creating a feature, see [generation_create_complete_feature.md](prompts/generation_create_complete_feature.md)

---

## 8. Inyección de dependencias con Riverpod 3

**Principios:**
- Toda dependencia se resuelve vía providers
- Nada de singletons manuales globales
- Para tests se usan `ProviderContainer` y overrides

**Ejemplos:**
```dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  // Config interceptores...
  return dio;
});

final presenceApiProvider = Provider<PresenceApi>((ref) {
  final dio = ref.read(dioProvider);
  return PresenceApi(dio);
});

final presenceRepositoryProvider = Provider<PresenceRepository>((ref) {
  return PresenceRepositoryImpl(
    ref.read(presenceApiProvider),
    CheckinMapper(),
  );
});
```

En tests:
```dart
final container = ProviderContainer(
  overrides: [
    presenceRepositoryProvider.overrideWithValue(MockPresenceRepository()),
  ],
);
```

---

## 8.1. Anti-patrones y errores comunes (CRÍTICO para Claude Code)

> **📘 Detailed Guide:** For anti-patterns with corrections, see [review_anti_patterns_clean_arch.md](prompts/review_anti_patterns_clean_arch.md)

### Common Anti-Patterns Summary

1. **Presentation importing Data** - 2_presentation NEVER imports 3_data *(except provider files - see below)*
2. **DTOs exposed outside 3_data** - DTOs are implementation details
3. **Business logic in controllers** - Logic goes in 1_domain/usecases
4. **Not using sealed results** - Usecases return sealed Result classes
5. **Missing ref.mounted checks** - Always check after await
6. **Using StateNotifier** - Use @riverpod with Notifier/AsyncNotifier

---

### ⚠️ IMPORTANT EXCEPTION: Provider Files and Dependency Injection

**Provider files (`2_presentation/providers/*.dart`) are allowed to import `3_data`** because they act as the **Dependency Injection** layer.

#### Why This Exception Exists

Provider files are responsible for:
1. Wiring concrete implementations (`3_data`) to abstractions (`1_domain`)
2. Creating the dependency graph for the feature
3. Providing dependency injection for the entire feature

This follows the **Dependency Inversion Principle** - the DI layer knows about both abstractions and implementations, but the rest of presentation only knows abstractions.

#### ✅ CORRECT Pattern: Provider File

```dart
// File: lib/features/appointments/2_presentation/providers/appointments_providers.dart

// ✅ ALLOWED: Provider files can import 3_data for DI
import 'package:hiberus_scaffold/features/appointments/1_domain/repositories/appointments_repository.dart';
import 'package:hiberus_scaffold/features/appointments/1_domain/usecases/crear_cita_usecase.dart';
import 'package:hiberus_scaffold/features/appointments/3_data/api/appointments_api_wrapper.dart';
import 'package:hiberus_scaffold/features/appointments/3_data/repositories/appointments_repository_impl.dart';

/// Provider for the API wrapper
final appointmentsApiWrapperProvider = Provider<AppointmentsApiWrapper>((ref) {
  final api = ref.read(navarraEmpleoApiProvider);
  final dio = ref.read(dioProvider);
  return AppointmentsApiWrapper(api.getCitaPreviaApi(), dio);
});

/// Provider for the repository (wiring concrete to interface)
final appointmentsRepositoryProvider = Provider<AppointmentsRepository>((ref) {
  final apiWrapper = ref.read(appointmentsApiWrapperProvider);
  return AppointmentsRepositoryImpl(apiWrapper); // ✅ Concrete implementation
});

/// Provider for the usecase
final crearCitaUsecaseProvider = Provider<CrearCitaUsecase>((ref) {
  final repository = ref.read(appointmentsRepositoryProvider);
  return CrearCitaUsecase(repository);
});
```

#### ✅ CORRECT: Controllers Use Providers Only

```dart
// File: lib/features/appointments/2_presentation/controllers/appointment_controller.dart

// ✅ ONLY imports from 1_domain and 2_presentation
import 'package:hiberus_scaffold/features/appointments/1_domain/usecases/crear_cita_usecase.dart';
import 'package:hiberus_scaffold/features/appointments/2_presentation/providers/appointments_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
class AppointmentController extends _$AppointmentController {
  @override
  AppointmentState build() => const AppointmentState();

  Future<void> createAppointment() async {
    // ✅ Controller only knows about providers and domain
    final usecase = ref.read(crearCitaUsecaseProvider);
    final result = await usecase.execute(...);

    // NO imports from 3_data!
  }
}
```

#### ❌ INCORRECT: Page/Widget Importing 3_data

```dart
// ❌ PROHIBITED: Pages/widgets must NEVER import 3_data
import 'package:hiberus_scaffold/features/appointments/3_data/repositories/appointments_repository_impl.dart';

class AppointmentPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ❌ WRONG: Direct instantiation of concrete implementation
    final repo = AppointmentsRepositoryImpl(...);
  }
}
```

#### Summary: The Rule

| File Type | Can Import 3_data? | Reason |
|-----------|-------------------|--------|
| **Provider files** (`2_presentation/providers/*.dart`) | ✅ **YES** | Dependency Injection layer |
| **Controllers** (`2_presentation/controllers/*.dart`) | ❌ **NO** | Only use providers |
| **Pages** (`2_presentation/pages/*.dart`) | ❌ **NO** | Only use providers |
| **Widgets** (`2_presentation/widgets/*.dart`) | ❌ **NO** | Only use providers |
| **Domain** (`1_domain/**/*.dart`) | ❌ **NO** | Domain is framework-agnostic |

**Key Principle:** The provider file is the **single point** where `2_presentation` meets `3_data`. Everything else in `2_presentation` only knows about providers and domain abstractions.

```

**Regla:** StateNotifier está **PROHIBIDO**. Usar `@riverpod` con code generation.

---

### ❌ Anti-patrón 7: Duplicar modelos con freezed cuando ya existen en built_value

```dart
// ❌ INCORRECTO - Duplicar modelo que ya existe en navarra_empleo_api
@freezed
abstract class Agencia with _$Agencia {
  const factory Agencia({
    required int id,
    required String nombre,
  }) = _Agencia;
}
```

```dart
// ✅ CORRECTO - Usar directamente el modelo generado
import 'package:generated/navarra_empleo_api/model/agencia.dart';

// Usar Agencia directamente del paquete generado
Future<List<Agencia>> getAgencias() async {
  final api = AgenciasApi();
  final response = await api.obtenerAgencias();
  return response.data ?? [];
}
```

**Regla:** Si el modelo existe en `navarra_empleo_api` (built_value), **NO** crear duplicado con freezed.

---

### ❌ Anti-patrón 8: ref.read() para estado reactivo

```dart
// ❌ INCORRECTO - No se actualiza la UI cuando cambia el locale
@override
Widget build(BuildContext context, WidgetRef ref) {
  final locale = ref.read(currentLocaleProvider); // ❌ MAL: read()
  
  return MaterialApp(
    locale: locale,
    // ...
  );
}
```

```dart
// ✅ CORRECTO - La UI se reconstruye cuando cambia el locale
@override
Widget build(BuildContext context, WidgetRef ref) {
  final locale = ref.watch(currentLocaleProvider); // ✅ BIEN: watch()
  
  return MaterialApp(
    locale: locale,
    // ...
  );
}
```

**Regla:**
- `ref.watch()` → Para estado reactivo (UI se actualiza cuando cambia)
- `ref.read()` → Para llamar métodos/acciones (no reactivo)

---

### ❌ Anti-patrón 9: Operaciones costosas en build()

```dart
// ❌ INCORRECTO - Ordenar en cada rebuild
@override
Widget build(BuildContext context) {
  final items = [3, 1, 4, 1, 5, 9];
  final sortedItems = items.toList()..sort(); // ❌ Se ejecuta en cada rebuild!
  
  return ListView(
    children: sortedItems.map((item) => Text('$item')).toList(),
  );
}
```

```dart
// ✅ CORRECTO - Calcular en el provider/controller
@riverpod
class ItemsController extends _$ItemsController {
  @override
  List<int> build() {
    final items = [3, 1, 4, 1, 5, 9];
    return items.toList()..sort(); // ✅ Solo se ejecuta cuando cambia
  }
}

@override
Widget build(BuildContext context, WidgetRef ref) {
  final sortedItems = ref.watch(itemsControllerProvider);
  
  return ListView(
    children: sortedItems.map((item) => Text('$item')).toList(),
  );
}
```

**Regla:** build() debe ser **idempotente y rápido**. Cálculos costosos van en providers/controllers.

---

### ❌ Anti-patrón 10: Navegar antes de verificar errores

```dart
// ❌ INCORRECTO - Navegar incluso si hay error
Future<void> onSubmit() async {
  final result = await usecase.execute(data);
  
  // ❌ MAL: Navega siempre, incluso con error
  if (!ref.mounted) return;
  context.go('/success');
}
```

```dart
// ✅ CORRECTO - Solo navegar en Success
Future<void> onSubmit() async {
  state = state.copyWith(isLoading: true, error: null);

  final result = await usecase.execute(data);
  
  if (!ref.mounted) return;

  switch (result) {
    case SubmitSuccess():
      state = state.copyWith(isLoading: false);
      context.go('/success'); // ✅ Solo navegar si tuvo éxito
    case SubmitFailed(:final message):
      state = state.copyWith(
        isLoading: false,
        error: message, // ✅ Mostrar error en la UI actual
      );
  }
}
```

**Regla:** Validar el resultado antes de navegar. Mostrar errores en la pantalla actual.

---

## 9. Networking y autenticación

En `lib/http_client.dart`:
- Configuración común de Dio
- Interceptores:
  - Logging (`PrettyDioLogger`, `CurlLoggerDioInterceptor`)
  - Autenticación (`AuthInterceptor` con token desde provider)
  - Headers comunes (`CommonHeadersInterceptor`)
  - Manejo de refresh de token (`QueuedInterceptorsWrapper`)

**Regla:**
- Las features no crean instancias de Dio por su cuenta; usan siempre el `dioProvider` definido en `lib/setup.dart`

### 9.1. Configuración de entorno (`lib/env.dart`)

Las variables de entorno se gestionan mediante `lib/env.dart` usando `--dart-define-from-file` en tiempo de compilación, cargando archivos JSON de configuración:

**Archivos de configuración disponibles:**
- `config_development.json` - Entorno de desarrollo/validación
- `config_preproduction.json` - Entorno de preproducción
- `config_production.json` - Entorno de producción

**Ejemplo de archivo de configuración (`config_development.json`):**
```json
{
  "URL_API_SERVICE": "https://val-frontend.admon-cfnavarra.es:8844/EmpleoMovilService/",
  "API_MID_NAME": "api/v2",
  "TIMEOUT_CALL": "10",
  "TIMEOUT_READ": "10",
  "URL_FORMACION": "https://val-frontend.admon-cfnavarra.es/EmpleoFormate.Internet/",
  "TIMEOUT_TOKEN": "30",
  "URL_OFERTAS": "https://administracionelectronica.navarra.es/EmpleoIntermediacion/empleo/",
  "EMAIL_CONTACTO": "portal.empleo@navarra.es",
  "FORZAR_LOG_EN_RELEASE": "true",
  "DEBUG_MODE": "true"
}
```

**Clase Env (`lib/env.dart`):**
```dart
class Env {
  static const apiServiceUrl = String.fromEnvironment('URL_API_SERVICE');
  static const timeoutCallSeconds = int.fromEnvironment('TIMEOUT_CALL', defaultValue: 10);
  static const timeoutReadSeconds = int.fromEnvironment('TIMEOUT_READ', defaultValue: 10);
  static const urlFormacion = String.fromEnvironment('URL_FORMACION');
  static const timeoutToken = int.fromEnvironment('TIMEOUT_TOKEN', defaultValue: 30);
  static const urlOfertas = String.fromEnvironment('URL_OFERTAS');
  static const emailContacto = String.fromEnvironment('EMAIL_CONTACTO');
  static const forzarLogEnRelease = bool.fromEnvironment('FORZAR_LOG_EN_RELEASE', defaultValue: false);
  static const debugMode = bool.fromEnvironment('DEBUG_MODE', defaultValue: false);
}
```

**Uso en tiempo de build:**
```bash
# Development
flutter run --dart-define-from-file=config_development.json

# Preproduction
flutter run --dart-define-from-file=config_preproduction.json

# Production
flutter build apk --release --dart-define-from-file=config_production.json
flutter build appbundle --release --dart-define-from-file=config_production.json
```

**Uso en el código:**
```dart
// En lib/http_client.dart o setup.dart
final dio = Dio(BaseOptions(
  baseUrl: Env.apiServiceUrl,
  connectTimeout: Duration(seconds: Env.timeoutCallSeconds),
  receiveTimeout: Duration(seconds: Env.timeoutReadSeconds),
));

// Logging condicional
if (Env.forzarLogEnRelease || Env.debugMode) {
  logger.d('Debug info...');
}
```

**Ventajas:**
- ✅ Separación clara entre entornos (dev/pre/prod) mediante archivos JSON
- ✅ No se hardcodean URLs ni configuraciones sensibles en el código
- ✅ Valores por defecto para desarrollo local
- ✅ Compatible con CI/CD (seleccionar archivo según entorno)
- ✅ Más legible que múltiples `--dart-define` individuales
- ✅ Versionado de configuraciones en Git (sin datos sensibles)

**Diferencias entre entornos:**
| Variable | Development | Preproduction | Production |
|----------|-------------|---------------|------------|
| `URL_API_SERVICE` | val-frontend:8844 | preadministracionelectronica | administracionelectronica |
| `TIMEOUT_CALL` | 10s | 30s | 30s |
| `TIMEOUT_TOKEN` | 30s | 600s (10min) | 600s (10min) |
| `DEBUG_MODE` | true | false | false |

---

## 10. Logging y errores

- El logging se centraliza en `lib/logger.dart`
- Los repositorios pueden:
  - Loggear errores técnicos usando el logger compartido
  - Lanzar excepciones o devolver resultados de `Failed` mapeados a dominio

**Regla de oro:**
- En la capa de dominio no se hacen logs de infraestructura (HTTP, etc.)
- En la capa de presentación, los errores se transforman en:
  - Mensajes de UI
  - Estados de error en providers

---

## 11. Testing

### Dominio
- Tests unitarios por caso de uso
- Mocks de repositorios
- Comprobación de:
  - Flujo feliz (`Success`)
  - Flujo de error (`Failed`)

### Data
- Tests de:
  - Mappers
  - Repositorios (con API mockeada o DioAdapter)

### Presentación
- Tests de:
  - Controllers / notifiers (`AsyncNotifier`)
  - Widgets importantes (pantallas principales, flujos críticos)

### Testing BDD e Integración

El proyecto soporta tests BDD (Behavior-Driven Development) mediante `bdd_widget_test` y pasos compartidos en `shared_test_steps/`.

**Inicialización de tests (`shared_test_steps/the_app_is_running.dart`):**

```dart
Future<void> theAppIsRunning(WidgetTester tester) async {
  // Detecta el tipo de test (Integration vs BDD)
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final isIntegration = binding is IntegrationTestWidgetsFlutterBinding;
  final isAutomatic = binding is AutomatedTestWidgetsFlutterBinding;
  
  Widget appWidget;
  if (isIntegration) {
    // E2E: usa SharedPreferences real
    sharedPrefs = await SharedPreferences.getInstance();
    appWidget = const ProviderScope(child: MainApp());
  } else if (isAutomatic) {
    // BDD: usa mocks
    final mockPrefs = MockAppPreferences();
    appWidget = ProviderScope(
      overrides: [appPreferencesProvider.overrideWithValue(mockPrefs)],
      child: const MainApp(),
    );
  }
  
  // Mock de MethodChannels necesarios
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    .setMockMethodCallHandler(smsAutofillChannel, (call) async {
      if (call.method == 'listenForCode') return null;
      return null;
    });
  
  await tester.pumpWidget(appWidget);
}
```

**Características clave:**
- **Detección automática** del tipo de test (BDD vs E2E)
- **Mocks de MethodChannels**: SMS autofill, App Links, Package Info
- **Provider overrides**: Para inyectar dependencias mockeadas
- **Pasos compartidos reutilizables**: `i_see_text.dart`, `i_tap_button.dart`, etc.

**Estructura de tests BDD:**
```
shared_test_steps/
  the_app_is_running.dart      # Setup inicial
  i_see_text.dart              # Verificar texto en pantalla
  i_tap_button_with_text.dart  # Interacción con botones
  i_wait_seconds.dart          # Esperas controladas
  mocks/                       # Mocks compartidos
integration_test/
  features/
    login.feature              # Escenarios Gherkin
    login_test.dart            # Tests generados
```

**Ventajas del approach:**
- Tests legibles en formato Gherkin (Given/When/Then)
- Reutilización de pasos entre features
- Separación clara entre tests unitarios, BDD e integración
- Mocks automáticos de plataforma (SMS, deep links)

---

## 12. Ciclo de vida de una nueva feature

> **📘 Detailed Checklist:** See [validation_feature_lifecycle_checklist.md](prompts/validation_feature_lifecycle_checklist.md)

---

## 13. Extensibilidad y modularidad

Una feature debe poder:
- Extraerse a un package
- Reutilizarse en otra app con mínimo esfuerzo

Para soportar esto:
- Evitamos referencias cruzadas entre features salvo en casos muy claros
- La lógica de negocio no depende de assets ni de UI concreta

---

## 14. Manejo de errores y excepciones

> **📘 Detailed Guide:** See [generation_error_handling_pattern.md](prompts/generation_error_handling_pattern.md)

### Error Handling Summary

- **1_domain/usecases**: Return sealed Result classes (Success/Failed)
- **3_data**: Convert exceptions to domain-specific errors
- **2_presentation**: Handle results with pattern matching
- Log errors with context and stack traces

---

---

## 15. Performance y Optimización

> **📘 Detailed Guide:** See [review_performance_optimization.md](prompts/review_performance_optimization.md)

### Performance Best Practices Summary

- Use `const` constructors wherever possible
- Provide keys for lists that change
- Avoid expensive operations in build()
- Use builder patterns for large widgets

---

## 16. Accesibilidad (A11y)

> **📘 Detailed Guide:** See [review_accessibility_compliance.md](prompts/review_accessibility_compliance.md)

### Accessibility Requirements Summary

- Add Semantics for screen readers
- Minimum touch target: 48x48 dp
- Color contrast: WCAG AA (4.5:1 for text)
- Logical focus traversal order

---

## 17. Seguridad

> **📘 Detailed Guide:** See [review_security_vulnerabilities.md](prompts/review_security_vulnerabilities.md)

### Security Best Practices Summary

- Store tokens in `flutter_secure_storage`
- Validate all user inputs
- Sanitize URLs before opening
- Never log sensitive data

---

## 18. Convenciones de Naming

### 18.1. Archivos

**snake_case para todos los archivos:**
```
user_profile_page.dart
fetch_user_usecase.dart
user_repository_impl.dart
```

### 18.2. Clases y tipos

**PascalCase:**
```dart
class UserProfile {}
class FetchUserUsecase {}
sealed class FetchUserResult {}
```

### 18.3. Variables y funciones

**camelCase:**
```dart
final userName = 'John';
void fetchUserData() {}
```

### 18.4. Constantes

**lowerCamelCase (no SCREAMING_SNAKE):**
```dart
// ✅ CORRECTO (Dart style)
const defaultTimeout = Duration(seconds: 30);
const maxRetries = 3;

// ❌ INCORRECTO (Java/Kotlin style)
const DEFAULT_TIMEOUT = Duration(seconds: 30);
const MAX_RETRIES = 3;
```

### 18.5. Providers

**Terminar con `Provider`:**
```dart
final userRepositoryProvider = Provider<UserRepository>(...);
final fetchUserUsecaseProvider = Provider<FetchUserUsecase>(...);
final userControllerProvider = NotifierProvider<UserController, UserState>(...);
```

### 18.6. Resultados sellados

**Patrón:** `<Action>Result` con `<Action>Success` y `<Action>Failed`
```dart
sealed class FetchUserResult {}
class FetchUserSuccess extends FetchUserResult {
  final User user;
  FetchUserSuccess(this.user);
}
class FetchUserFailed extends FetchUserResult {
  final String message;
  FetchUserFailed(this.message);
}
```

### 18.7. Páginas y widgets

**Sufijos descriptivos:**
```dart
// Páginas
class UserProfilePage extends StatelessWidget {}
class LoginPage extends StatelessWidget {}

// Widgets reutilizables
class UserCard extends StatelessWidget {}
class CustomButton extends StatelessWidget {}

// Dialogs
class ConfirmationDialog extends StatelessWidget {}
```

---

### 18.8. Árboles de decisión (Guías rápidas para Claude Code)

> **📘 Quick Reference:** See [decision_architecture_quick_reference.md](prompts/decision_architecture_quick_reference.md)

---

## 19. Riverpod 3.0 - Buenas Prácticas Críticas

> **📘 Detailed Guide:** See [validation_riverpod3_patterns.md](prompts/validation_riverpod3_patterns.md)

### Riverpod 3.0 Critical Rules

**⚠️ MANDATORY: ref.mounted after await**

```dart
Future<void> loadData() async {
  final result = await usecase.execute();
  if (!ref.mounted) return;  // ✅ CRITICAL
  state = result;
}
```

- Use `@riverpod` annotation (NO StateNotifier)
- `ref.watch()` for reactive state in build()
- `ref.read()` for methods in callbacks

---

## 20. Checklist de PR (mínimo requerido)

> **📘 Complete Checklist:** See [review_pr_checklist_complete.md](prompts/review_pr_checklist_complete.md)

### PR Review Summary

- [ ] Architecture rules respected
- [ ] Riverpod 3.0 patterns followed (ref.mounted checks)
- [ ] Error handling with sealed results
- [ ] Performance optimizations (const, keys)
- [ ] Accessibility compliance
- [ ] Security checks passed
- [ ] Tests written and passing

---

## 21. Workflow completo para Claude Code: Crear una feature desde cero

> **📘 Complete Workflow:** See [workflow_create_feature_step_by_step.md](prompts/workflow_create_feature_step_by_step.md)

### Workflow Summary

1. **Planning** - Don't code yet, understand requirements
2. **Structure** - Create folder structure
3. **Layers** - Implement in order: 0_entity → 1_domain → 3_data → 2_presentation
4. **Integration** - Register routes, run build_runner
5. **Validation** - Verify architecture, test, review

---

## 22. Prompts de Referencia

Esta sección enlaza a prompts especializados extraídos de este documento para uso con Claude AI.

### 🔄 Migration Prompts
- [Analyze Android Code](prompts/migration_analyze_android_code.md) - Deep analysis before migration
- [Create Migration Plan](prompts/migration_create_migration_plan.md) - Comprehensive migration planning
- [Generate Flutter Code](prompts/migration_generate_flutter_code.md) - Phase-by-phase code generation
- [Complete Feature Migration](prompts/migration_complete_feature_android_to_flutter.md) - End-to-end feature migration
- [UI-Only Migration](prompts/migration_ui_only_xml_to_widgets.md) - XML to Flutter widgets
- [Business Logic Migration](prompts/migration_business_logic_viewmodel_to_usecase.md) - ViewModel to UseCase
- [UI Resources Extraction](prompts/migration_ui_resources_extraction.md) - Colors, dimensions, strings

### ✅ Validation Prompts
- [Feature Architecture Audit](prompts/validation_feature_architecture_audit.md) - Complete architecture review
- [Riverpod 3.0 Patterns](prompts/validation_riverpod3_patterns.md) - Riverpod best practices validation
- [Riverpod 3.0 Enforcement](prompts/validation_riverpod3_enforcement.md) - Code-level enforcement
- [Dependency Flow Analysis](prompts/validation_dependency_flow_analysis.md) - Layer dependency validation
- [Feature Lifecycle Checklist](prompts/validation_feature_lifecycle_checklist.md) - Completeness checklist
- [Migration Final Checklist](prompts/validation_migration_final_checklist.md) - Pre-delivery validation

### 🔍 Review Prompts
- [Pre-Commit Review](prompts/review_pre_commit_complete.md) - Comprehensive PR review
- [PR Checklist Complete](prompts/review_pr_checklist_complete.md) - Minimum PR requirements
- [Anti-Patterns Review](prompts/review_anti_patterns_clean_arch.md) - Identify & fix anti-patterns
- [Performance Analysis](prompts/review_performance_analysis.md) - Performance optimization review
- [Performance Optimization](prompts/review_performance_optimization.md) - Best practices
- [Accessibility Compliance](prompts/review_accessibility_compliance.md) - A11y review
- [Security Audit](prompts/review_security_audit.md) - Security vulnerabilities
- [Security Vulnerabilities](prompts/review_security_vulnerabilities.md) - Common security issues

### 🏗️ Generation Prompts
- [Create Complete Feature](prompts/generation_create_complete_feature.md) - Step-by-step feature creation
- [Error Handling Pattern](prompts/generation_error_handling_pattern.md) - Error handling code
- [Test Templates](prompts/generation_test_templates.md) - Unit & widget test generation
- [Feature README](prompts/generation_feature_readme.md) - Documentation generation
- [API Integration Docs](prompts/generation_api_integration_docs.md) - API documentation
- [Architecture Decision Record](prompts/generation_architecture_decision_record.md) - ADR template

### 🔄 Workflow Prompts
- [Create Feature Step-by-Step](prompts/workflow_create_feature_step_by_step.md) - Complete workflow guide

### 🤔 Decision Prompts
- [Architecture Quick Reference](prompts/decision_architecture_quick_reference.md) - Decision trees
- [When to Ask User](prompts/decision_when_to_ask_user.md) - Clarification guidelines

> **💡 Tip:** Use these prompts with Claude AI for guided implementation, reviews, and migrations following project standards.

---

## 23. Referencias y notas finales

### 23.1. Fuente de verdad

Este documento es la **fuente de verdad** para la arquitectura del repositorio. 

**Proceso de cambios:**
- Cualquier ajuste a las reglas debe hacerse vía Pull Request
- Documentar la razón del cambio en el commit
- Actualizar la fecha de "Última actualización"
- Revisar impacto en features existentes

### 23.2. Contribuir a este documento

**Si encuentras:**
- Ambigüedades o contradicciones
- Ejemplos desactualizados
- Secciones faltantes
- Mejoras en organización

**Por favor:**
1. Abre un issue describiendo el problema/mejora
2. O crea un PR con la solución propuesta
3. Menciona en qué sección específica está el problema
4. Si añades contenido nuevo, actualiza el índice

**Filosofía del documento:**
- Claridad sobre brevedad
- Ejemplos concretos sobre teoría abstracta
- Decisiones explícitas sobre flexibilidad
- Copy-paste ready code sobre pseudocódigo

---

[⬆️ Volver al índice](#-índice)