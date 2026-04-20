# Anexo B — Features, dominio, datos, estado y navegación

Derivado de `architecture_canon_flutter_v2.md`.

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

