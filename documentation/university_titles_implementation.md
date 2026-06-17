# Implementación de Títulos Universitarios - Mis Datos Educación

## Resumen
Se ha implementado la pantalla de listado de títulos universitarios según el diseño de Figma (nodo 43973:1882), conectada a la API de educación del backend.

## Archivos Creados

### Entities (0_entity/)
- **university_title.dart**: Entidad que representa un título universitario con:
  - `titleNumber`: Número de título
  - `titleName`: Nombre del título
  - `universityName`: Nombre de la universidad
  - `completionDate`: Fecha de finalización
  - `expeditionDate`: Fecha de expedición

### Domain (1_domain/repositories/)
- **my_data_education_repository.dart**: Interfaz del repositorio con el método `loadUniversityTitles`

### Data (3_data/)
- **my_data_education_repository_impl.dart**: Implementación del repositorio que:
  - Se conecta a la API `/api/v1/educacion/titulos-universitarios/{numDocumento}`
  - Parsea la respuesta JSON/XML
  - Extrae los datos de los elementos (títulos)
  - Maneja fechas en múltiples formatos (ISO, dd/MM/yyyy)

### Presentation (2_presentation/)
- **my_data_education_provider.dart**: Provider de Riverpod que:
  - Expone `myDataEducationRepositoryProvider`
  - Expone `universityTitlesProvider` que carga automáticamente los títulos

- **my_data_university_titles_page.dart**: Pantalla de lista de títulos que:
  - Muestra un AppHeaderBar con título, botón back e info
  - Lista las tarjetas de títulos con diseño según Figma
  - Maneja estados: loading, error (con retry), empty, y data
  - Cada tarjeta muestra:
    - Número de título (en caption uppercase, color bluemuted)
    - Nombre del título (en leading bold)
    - Universidad (en body regular)
    - Fechas de finalización y expedición (en formato "1 jul 2000")

## Archivos Modificados

### Routing
- **route_registry.dart**: 
  - Agregada ruta `myDataEducationUniversityTitles = '/my-data/education/university-titles'`
  - Agregada a `_authenticated` set

- **app_router.dart**: 
  - Agregada ruta GoRoute para `MyDataUniversityTitlesPage`
  - Agregado import del nuevo archivo

### My Data Education Page
- **my_data_education_page.dart**:
  - Agregado parámetro `onTap` opcional a `_EducationNavCard`
  - Configurado navegación a la nueva página cuando se toca "Títulos universitarios"
  - Dejado "Títulos no universitarios" como "Coming soon"

## Diseño Implementado (Figma 43973:1882)

La pantalla sigue fielmente el diseño de Figma:

### Estructura Visual
- **Header**: AppHeaderBar con título "Títulos universitarios", botón back e info
- **Body**: Lista scrolleable de tarjetas con padding 16px
- **Cards**: Container con:
  - Border left de 4px en color `borderBlueMutedLight`
  - Borders de 1px en todos los lados
  - Border radius de 1px
  - Background blanco
  - Padding interno de 8px + 16px horizontal

### Contenido de Tarjetas
Cada tarjeta muestra (de arriba a abajo):
1. **Número de título**: Typography captionUppercase, color borderBlueMutedBase
2. **Nombre del título**: Typography leadingBold (18px bold), color textPrimary
3. **Universidad**: Typography bodyRegular (16px), color primary
4. **Fechas** (2 filas):
   - Label en captionUppercase, color primary
   - Valor en bodyRegular, color primary
   - Formato: "FECHA FINALIZACIÓN: 1 jul 2000"
   - "FECHA EXPEDICIÓN: 8 nov 2001"

## API Integración

### Endpoint
```
POST /api/v1/educacion/titulos-universitarios/{numDocumento}
```

### Request Body
```json
{
  "docu": "{numDocumento}",
  "tipodoc": "NIF"
}
```

### Response Schema (DTEDUTUORES)
```yaml
{
  "body": {
    "elemento": [ // Array de títulos
      {
        "titulacion": "Nombre del título",
        "centro": "Nombre de la universidad",
        "nordlib": "Número de título",
        "fecfin": "Fecha de finalización",
        "fecexp": "Fecha de expedición"
      }
    ]
  }
}
```

## Estados Manejados

1. **Loading**: Muestra `AppLoadingIndicator` centrado
2. **Error**: Muestra mensaje de error + botón "Reintentar" (hierarchy secondary)
3. **Empty**: Muestra mensaje "No constan títulos universitarios a tu nombre"
4. **Success**: Muestra lista de tarjetas con separación de 16px

## Testing Recomendado

1. Verificar que la navegación funciona desde My Data > Education > University Titles
2. Probar con usuario que tiene títulos universitarios
3. Probar con usuario sin títulos (estado empty)
4. Simular error de red (estado error + retry)
5. Verificar que los formatos de fecha se muestran correctamente
6. Verificar accesibilidad (semantics labels)

## Notas Técnicas

- El código sigue la arquitectura Clean Architecture del proyecto (entity/domain/data/presentation)
- Usa Riverpod para state management
- Maneja múltiples formatos de fecha (ISO, dd/MM/yyyy, dd-MM-yyyy)
- Parsea respuestas JSON con estructura flexible (maneja tanto Map como List en elemento)
- Soporta múltiples campos posibles para número de título (nordlib, numlib, nregnac, nregmec)
- No tiene warnings ni errores de análisis estático
- Código formateado según estándares del proyecto

## Próximos Pasos

- Implementar títulos no universitarios (similar estructura)
- Añadir filtros/búsqueda si hay muchos títulos
- Considerar cacheo de datos para mejorar performance
- Implementar pull-to-refresh
