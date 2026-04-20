# Anexo D — Ejemplo completo, anti-patrones, checklists y defaults

Derivado de `architecture_canon_flutter_v2.md`.

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
