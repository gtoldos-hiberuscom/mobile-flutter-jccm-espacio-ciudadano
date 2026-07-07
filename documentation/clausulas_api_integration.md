# Integración de Cláusulas con el Cliente de la API

## Resumen

Se ha conectado exitosamente el sistema de cláusulas de consentimiento con el cliente de la API generado (`dart_dio_client`). El repositorio `ConsentRepositoryImpl` ahora utiliza la API de Hechos Vitales para sincronizar las cláusulas con el backend.

## Cambios Realizados

### 1. Mapper de Cláusulas (`lib/features/consent/3_data/mappers/clause_mapper.dart`)

**Nuevo archivo** que proporciona conversión bidireccional entre:
- DTOs de la API: `Clausulas` y `ClausulasAgente` (generados)
- Entidad de dominio: `Clause`

**Funcionalidad:**
- `fromDto()` - Convierte un DTO individual a entidad de dominio
- `fromDtoList()` - Convierte lista de DTOs manteniendo las etiquetas del fallback
- `toDto()` - Convierte entidad a DTO para enviar a la API
- `toClausulasAgente()` - Crea el wrapper completo para requests API

### 2. Repositorio Actualizado (`lib/features/consent/3_data/repositories/consent_repository_impl.dart`)

**Cambios principales:**

#### Constructor
- Ahora recibe `Dio` además de `AppStorage`
- Inicializa `HechosVitalesApi` del cliente generado
- Ya no es `const` (debido a la inicialización de la API)

#### `hasAcceptedConsent()`
- **Antes:** Solo consultaba local storage
- **Ahora:** 
  1. Verifica caché local primero (respuesta rápida)
  2. Intenta sincronizar con API usando `obtenerClausulasPorAgente()`
  3. Cachea el resultado si la API responde
  4. Fallback a local storage si la API falla

#### `markConsentAccepted()`
- **Antes:** Solo guardaba en local storage
- **Ahora:**
  1. Persiste localmente primero (soporte offline inmediato)
  2. Sincroniza con backend usando `enviarClausulas()`
  3. Usa `ClauseMapper` para convertir entidades a DTOs
  4. Maneja errores de API sin afectar el guardado local

#### `hasAcceptedClause()`
- **Antes:** Solo consultaba local storage
- **Ahora:**
  1. Verifica caché local primero
  2. Intenta sincronizar con API
  3. Parsea respuesta JSON del `body` de `Respuesta`
  4. Busca la cláusula específica en la respuesta
  5. Fallback a local storage si la API falla

### 3. Provider Actualizado (`lib/features/consent/2_presentation/providers/consent_repository_provider.dart`)

**Cambios:**
- Importa `api_client_provider` para obtener `dioProvider`
- Pasa tanto `storage` como `dio` al constructor del repositorio

### 4. Dependencia Agregada (`pubspec.yaml`)

**Agregado:**
```yaml
built_collection: ^5.1.1
```

Necesario para trabajar con `ListBuilder` y `BuiltList` en el mapper.

## API Endpoints Utilizados

Del cliente generado `HechosVitalesApi`:

### `POST /api/v1/hechos-vitales/clausulas`
**Método:** `enviarClausulas()`
- **Uso:** Registrar/enviar cláusulas por primera vez
- **Body:** `ClausulasAgente` (idAgente + lista de cláusulas)
- **Respuesta:** `Respuesta` con resultado

### `PATCH /api/v1/hechos-vitales/clausulas`
**Método:** `actualizarClausulas()`
- **Uso:** Actualizar cláusulas existentes
- **Body:** `ClausulasAgente`
- **Respuesta:** `Respuesta` con resultado
- **Estado:** No implementado aún (se usa `enviarClausulas` para todo)

### `GET /api/v1/hechos-vitales/clausulas/{idAgente}`
**Método:** `obtenerClausulasPorAgente()`
- **Uso:** Recuperar cláusulas aceptadas por el ciudadano
- **Respuesta:** `Respuesta` con body JSON conteniendo las cláusulas

## Estrategia de Sincronización

### Híbrido: Local + API

**Ventajas:**
1. **Respuesta inmediata:** Caché local proporciona datos instantáneos
2. **Soporte offline:** Funciona sin conexión
3. **Sincronización automática:** Se sincroniza con backend cuando es posible
4. **Resiliencia:** Si la API falla, la app continúa funcionando

**Flujo:**
```
Usuario acepta cláusulas
    ↓
1. Guardar localmente (SharedPreferences) ✓
    ↓
2. Enviar a API (background)
    ↓
3. Si falla → mantener local (ya guardado)
   Si éxito → sincronizado
```

## Estructura de Datos

### Request Body (ejemplo del curl)
```json
{
  "idAgente": "PER9998003",
  "clausulas": [
    {
      "idClausula": 1,
      "seleccionado": false,
      "version": "1.0"
    },
    {
      "idClausula": 2,
      "seleccionado": true,
      "version": "1.0"
    },
    {
      "idClausula": 3,
      "seleccionado": true,
      "version": "1.0"
    }
  ]
}
```

### Response Body Structure
```dart
Response<Respuesta> {
  data: Respuesta {
    body: JsonObject {
      value: {
        "clausulas": [
          {
            "idClausula": 1,
            "seleccionado": false,
            "version": "1.0"
          },
          ...
        ]
      }
    },
    codigoRespuesta: "OK",
    mensajeRespuesta: "...",
    timestamp: DateTime
  }
}
```

## Testing

Para probar la integración:

```bash
# Verificar que compile sin errores
flutter analyze lib/features/consent/

# Formatear código
dart format lib/features/consent/

# Ejecutar tests unitarios
flutter test test/features/consent/
```

## Próximos Pasos

1. **Implementar `actualizarClausulas()`** para edición desde preferencias
2. **Agregar logging** para debugging de sincronización API
3. **Implementar retry logic** para fallos temporales de red
4. **Agregar tests de integración** para los flujos API
5. **Monitorear respuestas** para ajustar parsing del `body.value`

## Notas Técnicas

### Parsing del Body
La respuesta API usa `JsonObject` que contiene `value` con la estructura real:
```dart
response.data?.body?.value // Map<String, dynamic>?
```

Se requiere casting cuidadoso y null-safety completo.

### Serialización
- El cliente generado usa `built_value` para serialización
- `standardSerializers` se pasa al construir `HechosVitalesApi`
- Los DTOs son inmutables con builders

### Error Handling
- Try-catch envuelve todas las llamadas API
- Los errores no rompen la funcionalidad (fallback a local)
- Se puede agregar logging más adelante

## Referencias

- **Swagger API:** `fachada-sede-api-swagger.yaml`
- **Cliente generado:** `generated/dart_dio_client/`
- **Documentación API:** `generated/dart_dio_client/doc/HechosVitalesApi.md`
- **Arquitectura:** `documentation/ARCHITECTURE.md`
