# Ajustes de Mapeo de API - Títulos Universitarios

## Estructura Real de la API

Según la respuesta real del endpoint `/api/v1/educacion/titulos-universitarios/{numDocumento}`:

```json
{
  "body": {
    "resul": "0",
    "mensaje": "TRAMITADA",
    "fecnac": "01/01/1967",
    "docu": null,
    "elemento": [
      {
        "univers": "Universidad de Barcelona",
        "centro": "Facultad de Filología",
        "nomcar": "Licenciado en Filología Hispánica",
        "tipotit": "Licenciado",
        "fecfin": "01/06/2000",
        "numtit": "1988000333",
        "reguniv": "345135",
        "fecexpedicion": "08/05/2008",
        "codtitulacion": "3053",
        "coduniversidad": "4",
        "codcentro": "08032919",
        "codtipotitulo": "04",
        "codpaisexpedicion": "724",
        "paisexpedicion": "ESPAÑA"
      }
    ],
    "idpeticion": "7a7479f7fa5fec7a5t0125485",
    "codestado": "0003"
  }
}
```

## Mapeo de Campos Implementado

| Campo UI                | Campo API              | Ejemplo                                  |
|------------------------|------------------------|------------------------------------------|
| Nombre del título      | `nomcar`               | "Licenciado en Filología Hispánica"      |
| Universidad            | `univers`              | "Universidad de Barcelona"               |
| Número de título       | `numtit`               | "1988000333"                             |
| Fecha finalización     | `fecfin`               | "01/06/2000" → "1 jun 2000"              |
| Fecha expedición       | `fecexpedicion`        | "08/05/2008" → "8 may 2008"              |

## Campos Alternativos (Fallback)

Para asegurar compatibilidad con posibles variaciones de la API, se implementaron campos alternativos:

### Nombre del título
```dart
['nomcar', 'titulacion', 'tipotit']
```

### Universidad
```dart
['univers', 'universidad', 'centro']
```
Nota: Se priorizan en ese orden. Solo se usa `centro` como último recurso.

### Número de título
```dart
['numtit', 'nordlib', 'numlib', 'reguniv', 'nregnac', 'nregmec', 'nregaut']
```

### Fechas
```dart
// Fecha finalización
['fecfin']

// Fecha expedición
['fecexpedicion', 'fecexp']
```

## Formato de Fechas

### Entrada
La API devuelve fechas en formato `dd/MM/yyyy`:
- `"01/06/2000"`
- `"08/05/2008"`

### Procesamiento
El parser maneja múltiples formatos:
- ISO 8601: `"2000-06-01"`
- Europeo con `/`: `"01/06/2000"`
- Europeo con `-`: `"01-06-2000"`

### Salida
Las fechas se formatean en español corto:
- `"1 jun 2000"` (sin cero inicial en día)
- `"8 may 2008"` (sin cero inicial en día)

Nombres de meses:
```dart
1 => 'ene', 2 => 'feb', 3 => 'mar', 4 => 'abr',
5 => 'may', 6 => 'jun', 7 => 'jul', 8 => 'ago',
9 => 'sep', 10 => 'oct', 11 => 'nov', 12 => 'dic'
```

## Ejemplo de Visualización

Con los datos de ejemplo de la API:

```
╔═══════════════════════════════════════════════════╗
║ Nº TÍTULO: 1988000333                             ║
║                                                   ║
║ Licenciado en Filología Hispánica                 ║
║                                                   ║
║ Universidad de Barcelona                          ║
║                                                   ║
║ FECHA FINALIZACIÓN              1 jun 2000        ║
║ FECHA EXPEDICIÓN                8 may 2008        ║
╚═══════════════════════════════════════════════════╝
```

## Cambios Realizados en el Código

### 1. `my_data_education_repository_impl.dart`
```dart
// Antes:
final titleName = _firstString(raw, const ['titulacion', 'tipotit']);
final universityName = _firstString(raw, const ['centro']);
final completionDate = _parseDate(_firstString(raw, const ['fecfin']));
final expeditionDate = _parseDate(_firstString(raw, const ['fecexp']));

// Después:
final titleName = _firstString(raw, const ['nomcar', 'titulacion', 'tipotit']);
final universityName = _firstString(raw, const ['univers', 'universidad', 'centro']);
final titleNumber = _firstString(raw, const [
  'numtit',      // ← NUEVO campo principal
  'nordlib',
  'numlib',
  'reguniv',     // ← NUEVO campo alternativo
  'nregnac',
  'nregmec',
  'nregaut',
]);
final completionDate = _parseDate(_firstString(raw, const ['fecfin']));
final expeditionDate = _parseDate(_firstString(raw, const ['fecexpedicion', 'fecexp']));
```

## Validación

✅ Campo `nomcar` mapeado correctamente  
✅ Campo `univers` mapeado correctamente  
✅ Campo `numtit` mapeado correctamente  
✅ Campo `fecfin` parseado y formateado correctamente  
✅ Campo `fecexpedicion` parseado y formateado correctamente  
✅ Fallbacks implementados para compatibilidad  
✅ Formato de salida coincide con diseño de Figma  

## Testing Recomendado

1. **Datos reales**: Verificar con usuario que tiene títulos reales
2. **Fechas variadas**: Probar con diferentes formatos de fecha
3. **Campos faltantes**: Verificar que los fallbacks funcionan
4. **Múltiples títulos**: Verificar que se listan todos correctamente
5. **Sin títulos**: Verificar estado empty

## Notas Técnicas

- El campo `centro` (Facultad) NO se muestra en la UI según diseño de Figma
- Solo se usa `univers` para mostrar el nombre de la universidad
- El formato de fecha es consistente en toda la app (día sin cero inicial + mes abreviado + año)
- Los campos alternativos aseguran robustez ante cambios en la API
