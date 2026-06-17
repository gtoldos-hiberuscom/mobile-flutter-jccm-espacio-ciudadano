# Modal de Ayuda - Títulos Universitarios

## Resumen
Se ha implementado el modal de ayuda (bottom sheet) para la pantalla de títulos universitarios según el diseño de Figma (nodo 43973:1982).

## Diseño Implementado

### Estructura del Modal

El modal contiene:

1. **Handle de arrastre**: Barra gris en la parte superior para cerrar
2. **Botón "Salir"**: En la esquina superior derecha con ícono de cerrar
3. **Título**: "Sobre tus títulos universitarios" (leadingBold)
4. **Cuerpo principal**: 
   - Texto explicativo sobre el Registro Nacional de Titulados
   - Información sobre títulos anteriores a 1996
5. **Divider**: Separador visual
6. **Texto de pie**: Información sobre cómo contactar si hay errores
7. **Botón de contacto**: Botón secundario con ícono "open_in_new"

### Visualización

```
╔════════════════════════════════════════════╗
║          ════           [Salir ✕]          ║
║                                            ║
║ Sobre tus títulos universitarios           ║
║                                            ║
║ Consulta los datos de los títulos que     ║
║ figuren en el registro Nacional de         ║
║ Titulados universitarios oficiales del    ║
║ Ministerio de Ciencia, Innovación y       ║
║ Universidades.                             ║
║ Si tu título es anterior a 1996 es         ║
║ posible que tus datos no puedan           ║
║ visualizarse automáticamente.              ║
║                                            ║
║ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   ║
║                                            ║
║ Si alguno de tus datos no es correcto     ║
║ o no está actualizado, contacta con la    ║
║ Ministerio de Ciencia, Innovación y       ║
║ Universidades.                             ║
║                                            ║
║ ┌────────────────────────────────────┐    ║
║ │      Contactar  [↗]                │    ║
║ └────────────────────────────────────┘    ║
╚════════════════════════════════════════════╝
```

## Componentes Utilizados

### AppBottomSheet
```dart
AppBottomSheet.show<void>(
  context: context,
  title: l10n.educationUniversityTitlesInfoTitle,
  body: Column(
    // Contenido del modal
  ),
);
```

### Elementos del Body

1. **Texto principal**:
```dart
Text(
  l10n.educationUniversityTitlesInfoBody,
  style: AppTypography.bodyRegular.copyWith(
    color: AppColors.textPrimary,
  ),
)
```

2. **Divider**:
```dart
Divider(
  color: AppColors.divider,
  thickness: 1,
)
```

3. **Botón de contacto**:
```dart
AppButton(
  label: l10n.educationUniversityTitlesInfoContactButton,
  onPressed: () => _openContactUrl(context, l10n),
  hierarchy: AppButtonHierarchy.secondary,
  trailingIcon: AppIcons.openInNew,
  isExpanded: true,
)
```

## Funcionalidad del Botón Contactar

Al pulsar el botón "Contactar":

1. Se abre el navegador externo con la URL del Ministerio
2. URL: `https://www.ciencia.gob.es/`
3. Si falla, muestra un snackbar de error

### Implementación
```dart
Future<void> _openContactUrl(
  final BuildContext context,
  final AppLocalizations l10n,
) async {
  const url = 'https://www.ciencia.gob.es/';
  
  final accepted = await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
  
  if (!context.mounted || accepted) {
    return;
  }
  
  AppAlertSnackbar.show(
    context,
    message: l10n.externalLinkOpenFailed,
    severity: AppAlertSeverity.error,
  );
}
```

## Localizaciones Agregadas

### Español (`app_es.arb`)
```json
{
  "educationUniversityTitlesInfoTitle": "Sobre tus títulos universitarios",
  "educationUniversityTitlesInfoBody": "Consulta los datos de los títulos que figuren en el registro Nacional de Titulados universitarios oficiales del Ministerio de Ciencia, Innovación y Universidades.\nSi tu título es anterior a 1996 es posible que tus datos no puedan visualizarse automáticamente.",
  "educationUniversityTitlesInfoFooter": "Si alguno de tus datos no es correcto o no está actualizado, contacta con la Ministerio de Ciencia, Innovación y Universidades.",
  "educationUniversityTitlesInfoContactButton": "Contactar"
}
```

### Inglés (`app_en.arb`)
```json
{
  "educationUniversityTitlesInfoTitle": "About your university degrees",
  "educationUniversityTitlesInfoBody": "Check the data of degrees listed in the National Register of Official University Graduates of the Ministry of Science, Innovation and Universities.\nIf your degree is prior to 1996, your data may not be automatically displayed.",
  "educationUniversityTitlesInfoFooter": "If any of your data is incorrect or not updated, contact the Ministry of Science, Innovation and Universities.",
  "educationUniversityTitlesInfoContactButton": "Contact"
}
```

## Tokens de Diseño Utilizados

### Tipografía
- **Título**: `AppTypography.leadingBold` (18px, bold)
- **Cuerpo**: `AppTypography.bodyRegular` (16px, regular)

### Colores
- **Texto**: `AppColors.textPrimary` (#002855)
- **Divider**: `AppColors.divider` (neutral300)

### Espaciado
- **Padding vertical**: `AppDimensions.space4` (4px)
- **Gap después de divider**: `AppDimensions.space8` (8px)

### Componentes
- **Botón**: `AppButtonHierarchy.secondary` (borde + texto en primary)
- **Icono**: `AppIcons.openInNew` (↗)

## Activación del Modal

El modal se abre al pulsar el botón de información (ℹ️) en el AppHeaderBar:

```dart
AppHeaderBar(
  title: l10n.educationUniversityTitlesTitle,
  onBack: () => context.go(Routes.myDataEducation),
  onInfo: () => _showInfoSheet(context, l10n), // ← Abre el modal
)
```

## Archivos Modificados

1. **`my_data_university_titles_page.dart`**:
   - Agregado import de `url_launcher`
   - Actualizada función `_showInfoSheet` con contenido completo
   - Agregada función `_openContactUrl` para abrir URL externa

2. **`app_es.arb`**:
   - 4 nuevas claves de localización en español

3. **`app_en.arb`**:
   - 4 nuevas claves de localización en inglés

## Testing Recomendado

1. ✅ Abrir el modal pulsando el botón de información
2. ✅ Verificar que el texto se muestra correctamente
3. ✅ Verificar que el divider separa las secciones
4. ✅ Pulsar "Contactar" y verificar que abre el navegador
5. ✅ Simular fallo de apertura para ver el snackbar de error
6. ✅ Cerrar el modal arrastrando hacia abajo
7. ✅ Cerrar el modal con el botón "Salir"
8. ✅ Verificar en español e inglés

## Notas Técnicas

- El modal usa `AppBottomSheet` del design system
- El botón aprovecha `isExpanded: true` para ocupar todo el ancho
- La URL del ministerio puede actualizarse fácilmente cambiando la constante
- El modal sigue el patrón de diseño de la app (bottom sheet con handle)
- Manejo de errores con snackbar si el navegador no puede abrirse
- Uso de `context.mounted` para evitar errores después de async

## Estado Final

✅ Modal implementado según diseño de Figma  
✅ Localizaciones en español e inglés  
✅ Funcionalidad de contacto operativa  
✅ Manejo de errores implementado  
✅ 0 errores de compilación  
✅ 0 warnings de análisis estático  
✅ Código formateado  
