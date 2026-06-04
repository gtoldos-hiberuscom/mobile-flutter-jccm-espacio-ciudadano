# Estándar de Accesibilidad Flutter — Guía Corporativa

**Versión:** 1.0  
**Fecha:** Mayo 2026  
**Proyecto de referencia:** Presencia (Navarra Empleo)  
**Nivel objetivo:** WCAG 2.1 AA  
**Plataformas:** iOS (VoiceOver) + Android (TalkBack)

---

## Índice

1. [Introducción](#1-introducción)
2. [Arquitectura de accesibilidad](#2-arquitectura-de-accesibilidad)
3. [Reglas obligatorias](#3-reglas-obligatorias)
4. [Patrones reutilizables](#4-patrones-reutilizables)
5. [Anti-patrones detectados](#5-anti-patrones-detectados)
6. [Checklist oficial](#6-checklist-oficial)
7. [Recomendaciones para el Design System](#7-recomendaciones-para-el-design-system)
8. [Conclusiones](#8-conclusiones)

---

## 1. Introducción

### Objetivo

Este documento define las reglas, patrones y estándares de accesibilidad que deben seguirse en todos los proyectos Flutter de la compañía. Está basado en la implementación validada del proyecto Presencia.

### Filosofía

La accesibilidad no es una capa que se añade al final, sino una propiedad intrínseca de cada componente. El proyecto adopta el principio de **"accesible por defecto"**: los componentes del Design System ya incorporan semántica correcta, liberando a los desarrolladores de feature de preocuparse por los detalles de bajo nivel.

### Estándares aplicados

| Estándar | Nivel | Aplicación |
|----------|-------|------------|
| WCAG 2.1 | AA | Contraste, nombres accesibles, orden de foco |
| WCAG 1.3.1 | A | Estructura semántica (headings, listas) |
| WCAG 1.4.11 | AA | Contraste de componentes no textuales (≥3:1) |
| WCAG 2.4.3 | A | Orden de foco coherente |
| WCAG 2.5.5 | AAA | Área táctil mínima 48×48dp |
| WCAG 3.3.1 | A | Identificación de errores |
| WCAG 4.1.2 | A | Nombre, función, valor para controles |
| WCAG 4.1.3 | AA | Mensajes de estado anunciados |

---

## 2. Arquitectura de accesibilidad

### Estructura por capas

```
┌─────────────────────────────────────────────────┐
│  Capa de Feature (Pages)                        │
│  → headingLevel, orden visual, focus flow       │
├─────────────────────────────────────────────────┤
│  Capa de Design System (DS Widgets)             │
│  → Semantics integrada, ExcludeSemantics,       │
│    liveRegion, SemanticsService                 │
├─────────────────────────────────────────────────┤
│  Capa de Servicios Transversales                │
│  → ErrorDisplayService, LoadingService          │
│  → AutoScrollOnFocus, AASkipToContent           │
├─────────────────────────────────────────────────┤
│  Capa de Tema (ThemeData)                       │
│  → Focus color >18:1 contraste, highlight       │
├─────────────────────────────────────────────────┤
│  Capa de Validación Automática                  │
│  → aa_sdd_accessibility runtime bridge          │
│  → Lint rules custom (clean_linter)             │
└─────────────────────────────────────────────────┘
```

### Componentes clave centralizados

| Componente | Ubicación | Responsabilidad |
|------------|-----------|-----------------|
| `DSHeader` | `design_system/widgets/headers/` | Heading H1 con `Positioned` 1×1px para prioridad en screen reader |
| `DSInput` | `design_system/widgets/inputs/` | Label semántico, anuncio de errores, ExcludeSemantics en TextField |
| `DSButton` | `design_system/widgets/buttons/` | `button: true`, `enabled`, label fallback al texto |
| `DSIcon` | `design_system/widgets/icons/` | `ExcludeSemantics` para decorativos, `image: true` para informativos |
| `DSDialog` | `design_system/widgets/dialogs/` | `scopesRoute`, `OrdinalSortKey`, heading en título |
| `DSSpinner` | `design_system/widgets/feedback/` | `liveRegion`, anuncia "Cargando" / "Contenido cargado" |
| `AutoScrollOnFocus` | `aa_sdd_accessibility/widgets/` | Scroll automático al recibir foco del lector de pantalla |
| `AASemanticWrapper` | `aa_sdd_accessibility/widgets/` | Helper para envolver widgets con semántica rápida |
| `AASkipToContent` | `aa_sdd_accessibility/widgets/` | "Skip to content" para bypass blocks (WCAG 2.4.1) |
| `ErrorDisplayService` | `lib/services/` | `SemanticsService.sendAnnouncement` en cada error/éxito |
| `LoadingService` | `lib/services/` | Anuncia "Cargando" al mostrar y "Contenido cargado" al ocultar |

### Helpers y utilidades

```dart
// Extension para semántica rápida
widget.asHeader(label: 'Título')
widget.asButton(label: 'Enviar', hint: 'Envía el formulario')
widget.withAASemantics(label: 'x', isTextField: true)

// Live Region wrapper
AALiveRegion(message: 'Contenido actualizado', child: ...)

// Auto-scroll al ganar foco
AutoScrollOnFocus(child: DSInput(...))
```

---

## 3. Reglas obligatorias

### 3.1 — Toda pantalla debe tener exactamente un Heading H1

**WCAG:** 1.3.1 (Info and Relationships)  
**Motivo:** Los usuarios de lector de pantalla navegan por headings para entender la estructura. Sin H1, no saben en qué pantalla están.

**✅ Correcto:**
```dart
Semantics(
  header: true,
  headingLevel: 1,
  child: Text(loc.titulo_pagina, style: DSTypography.h1),
)
```

**❌ Incorrecto:**
```dart
Text(loc.titulo_pagina, style: DSTypography.h1) // Sin semántica de header
```

**Patrón DSHeader:** El componente `DSHeader` ya crea un nodo semántico de 1×1px con `header: true, headingLevel: 1` posicionado en la parte superior, garantizando que se anuncia PRIMERO independientemente del orden visual.

---

### 3.2 — El heading de página debe anunciarse ANTES que la navegación

**WCAG:** 1.3.1, 2.4.2  
**Motivo:** En Android, el Accessibility Scanner ignora nodos de tamaño cero. El proyecto usa un nodo `SizedBox(width: 1, height: 1)` posicionado con `Positioned(top: 0, left: 0)`.

**✅ Correcto (patrón de DSHeader):**
```dart
Stack(
  children: [
    Positioned(
      top: 0,
      left: 0,
      child: Semantics(
        label: pageTitle,
        header: true,
        headingLevel: 1,
        focusable: true,
        child: const SizedBox(width: 1, height: 1),
      ),
    ),
    // ... contenido visual del header
  ],
)
```

---

### 3.3 — Los iconos decorativos deben excluirse del árbol semántico

**WCAG:** 1.1.1 (Non-text Content)  
**Motivo:** Un icono sin label añade ruido ("unlabeled image") al lector de pantalla.

**✅ Correcto (patrón DSIcon):**
```dart
// Decorativo: sin semanticsLabel → automáticamente excluido
const DSIcon(DSIcons.arrowBack) // → ExcludeSemantics(child: Icon(...))

// Informativo: con semanticsLabel → Semantics(label: ..., image: true)
DSIcon(DSIcons.warning, semanticsLabel: 'Advertencia')
```

**❌ Incorrecto:**
```dart
Icon(Icons.arrow_back) // Icono suelto sin semántica ni exclusión
```

---

### 3.4 — Los botones interactivos deben envolver todo en Semantics + ExcludeSemantics

**WCAG:** 4.1.2 (Name, Role, Value)  
**Motivo:** Sin este patrón, el lector de pantalla anuncia cada hijo del botón por separado (icono, texto) en vez del conjunto.

**✅ Correcto (patrón DSButton):**
```dart
Semantics(
  label: semanticsLabel ?? text ?? '',
  hint: semanticsHint,
  button: true,
  enabled: onPressed != null,
  onTap: onPressed,
  child: ExcludeSemantics(
    child: GestureDetector(
      onTap: onTap,
      child: Row(children: [icon, text]),
    ),
  ),
)
```

**❌ Incorrecto:**
```dart
GestureDetector(
  onTap: onTap,
  child: Row(children: [Icon(Icons.send), Text('Enviar')]),
  // El lector lee "send icon" + "Enviar" como 2 elementos separados
)
```

---

### 3.5 — Áreas de toque mínimas de 48×48dp

**WCAG:** 2.5.5 (Target Size)  
**Motivo:** Usuarios con discapacidad motriz necesitan áreas de toque suficientes.

**✅ Correcto (patrón de DSHeader `_buildTouchableIcon`):**
```dart
Semantics(
  label: semanticsLabel,
  button: true,
  enabled: onTap != null,
  child: GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      child: Center(child: ExcludeSemantics(child: DSIcon(icon))),
    ),
  ),
)
```

---

### 3.6 — Los errores de formulario deben anunciarse automáticamente

**WCAG:** 3.3.1 (Error Identification), 4.1.3 (Status Messages)  
**Motivo:** El usuario que no ve la pantalla no sabe que apareció un error a menos que se le anuncie.

**✅ Correcto (patrón DSInput `didUpdateWidget`):**
```dart
@override
void didUpdateWidget(covariant DSInput oldWidget) {
  super.didUpdateWidget(oldWidget);
  final newError = widget.errorMessage;
  if (newError != null && newError.isNotEmpty && oldWidget.errorMessage != newError) {
    final announcement = 'Error, ${widget.label}: $newError';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        SemanticsService.sendAnnouncement(View.of(context), announcement, TextDirection.ltr);
      }
    });
  }
}
```

**Importante:** El anuncio incluye el prefijo "Error" y el nombre del campo para que el usuario identifique cuál campo falló.

---

### 3.7 — El label semántico del input debe incluir el error

**WCAG:** 1.3.1, 3.3.1  
**Motivo:** Cuando el usuario navega al campo con TalkBack/VoiceOver, debe escuchar el error sin necesidad de buscar el texto del error visualmente.

**✅ Correcto:**
```dart
final String semanticLabel = [
  if (fieldLabel.isNotEmpty) fieldLabel,        // "Contraseña"
  if (fieldValue != null) fieldValue,           // "abc123"
  if (errorForSemantics != null) errorForSemantics, // "Error: mínimo 8 caracteres"
].join(', ');

Semantics(
  label: semanticLabel,
  textField: true,
  enabled: widget.enabled,
  child: Column(children: [...]),
)
```

---

### 3.8 — No exponer el valor en campos de contraseña

**WCAG:** Privacidad + 4.1.2  
**Motivo:** Si `obscureText: true`, el texto debe seguir oculto también en el árbol semántico.

**✅ Correcto (patrón `_effectiveSemanticValue`):**
```dart
String? get _effectiveSemanticValue {
  if (widget.obscureText) return null; // Nunca exponer passwords
  if (_controller.text.isEmpty) return null;
  return _controller.text;
}
```

---

### 3.9 — Dialogs deben tener foco aislado y orden controlado

**WCAG:** 2.4.3 (Focus Order), 1.3.1  
**Motivo:** Al abrir un dialog, el lector de pantalla no debe poder navegar fuera de él.

**✅ Correcto (patrón DSDialog):**
```dart
Semantics(
  container: true,
  scopesRoute: true,       // Aísla el foco dentro del dialog
  namesRoute: true,        // Anuncia el nombre del dialog
  explicitChildNodes: true, // Permite OrdinalSortKey en hijos
  label: resolvedDialogLabel,
  child: Column(
    children: [
      Semantics(header: true, headingLevel: 1, sortKey: OrdinalSortKey(1), ...),  // Título
      Semantics(sortKey: OrdinalSortKey(2), child: Text(body)),                     // Cuerpo
      Semantics(sortKey: OrdinalSortKey(3), child: buttons),                       // Acciones
    ],
  ),
)
```

---

### 3.10 — Spinners/Loaders deben anunciar inicio y fin

**WCAG:** 4.1.3 (Status Messages)  
**Motivo:** Sin anuncio, el usuario con lector de pantalla no sabe que la app está procesando algo.

**✅ Correcto (patrón DSSpinner + LoadingService):**
```dart
// Al mostrar:
SemanticsService.sendAnnouncement(view, 'Cargando', TextDirection.ltr);

// Al desaparecer (dispose del spinner):
SemanticsService.sendAnnouncement(view, 'Contenido cargado', TextDirection.ltr);

// Widget spinner con liveRegion:
Semantics(
  container: true,
  liveRegion: true,
  label: 'Cargando',
  focusable: false,
  child: ExcludeSemantics(child: spinnerAnimation),
)
```

---

### 3.11 — Mensajes de feedback (errores, éxitos) deben usar SemanticsService

**WCAG:** 4.1.3  
**Motivo:** Snackbars/overlays no reciben foco, así que el lector de pantalla no los anuncia a menos que se use una API explícita.

**✅ Correcto (patrón ErrorDisplayService):**
```dart
static void _showAlert(BuildContext context, String message, DSAlertType type) {
  // Mostrar overlay visual...
  Overlay.of(context).insert(overlayEntry);
  
  // SIEMPRE anunciar para lectores de pantalla:
  SemanticsService.sendAnnouncement(View.of(context), message, Directionality.of(context));
}
```

---

### 3.12 — Focus color debe tener contraste ≥3:1

**WCAG:** 1.4.11 (Non-text Contrast), 1.4.1 (Use of Color)  
**Motivo:** El indicador de foco por defecto de Android (verde) no cumple WCAG contra fondos blancos.

**✅ Correcto (en `main.dart` + `theme.dart`):**
```dart
// main.dart
FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;

// theme.dart (light)
focusColor: Color(0xFF0D0D0D), // grey950: >18:1 contraste vs blanco
```

---

### 3.13 — Elementos en grupo de selección mutua deben indicar `inMutuallyExclusiveGroup`

**WCAG:** 4.1.2  
**Motivo:** TalkBack anuncia "en grupo de selección mutua" para que el usuario sepa que solo puede elegir una opción.

**✅ Correcto (patrón DSRadioButtonCard):**
```dart
Semantics(
  label: semanticsLabel ?? label,
  container: true,
  inMutuallyExclusiveGroup: true,
  checked: _isSelected,
  enabled: !_isDisabled,
  onTap: () => onChanged?.call(value),
  child: ExcludeSemantics(child: ...),
)
```

---

### 3.14 — Cards expandibles deben indicar estado `expanded`

**WCAG:** 4.1.2 (Value)  
**Motivo:** El usuario debe saber si la card está expandida o colapsada antes de interactuar.

**✅ Correcto (patrón DSDropdownInfoCard):**
```dart
Semantics(
  label: _buildSemanticsLabel(), // Incluye contenido expandido si aplica
  button: true,
  expanded: _isExpanded,
  onTap: _toggleExpanded,
  child: ...,
)
```

---

### 3.15 — Scroll automático al recibir foco de accesibilidad

**WCAG:** 2.4.3  
**Motivo:** Al navegar con TalkBack/VoiceOver a un widget offscreen, si no se scrollea automáticamente, el usuario pierde contexto.

**✅ Correcto (patrón AutoScrollOnFocus):**
```dart
AutoScrollOnFocus(
  child: DSButton(...)
)

// Internamente usa:
Semantics(
  onDidGainAccessibilityFocus: () {
    Scrollable.ensureVisible(context, duration: Duration(milliseconds: 300));
  },
  child: child,
)
```

---

### 3.16 — Texto escalable: no limitar textScaleFactor

**WCAG:** 1.4.4 (Resize Text)  
**Motivo:** Los usuarios con baja visión configuran tamaño de fuente mayor en el sistema.

**✅ Correcto (en `main_app.dart`):**
```dart
// Pasar textScaler del sistema SIN clamp
MediaQuery(
  data: MediaQuery.of(context), // Sin .copyWith(textScaleFactor: clamp)
  child: child,
)
```

---

### 3.17 — Bordes de componentes UI deben tener contraste ≥3:1

**WCAG:** 1.4.11  
**Motivo:** Los bordes de inputs, cards y controles son el límite visual que el usuario necesita percibir.

**✅ Correcto:**
```dart
// DSDropdownInfoCard, DSMapCard, etc.
border: Border.all(color: DSColors.grey600), 
// grey600 vs white = 4.54:1 — cumple 3:1 mínimo
```

---

### 3.18 — Labels compuestos para cards con múltiples datos

**WCAG:** 1.3.1, 4.1.2  
**Motivo:** Si una card tiene 5 textos internos, el lector leería cada uno por separado. Mejor unificar en un solo label.

**✅ Correcto (patrón `_buildSemanticsLabel`):**
```dart
String _buildSemanticsLabel() {
  final segments = <String>[];
  _appendSemanticsSegment(segments, code);
  _appendSemanticsSegment(segments, statusText);
  _appendSemanticsSegment(segments, title);
  _appendSemanticsSegment(segments, dateRange);
  if (_isExpanded) {
    _appendSemanticsSegment(segments, '$imparteLabel: $imparte');
    // ... más campos
  }
  return segments.join(', ');
}

void _appendSemanticsSegment(List<String> segments, String? value) {
  final normalized = value?.replaceAll('\n', ' ').trim();
  if (normalized != null && normalized.isNotEmpty) segments.add(normalized);
}
```

---

### 3.19 — Landscape: mantener heading semántico aunque esté visualmente oculto

**WCAG:** 1.3.1  
**Motivo:** En landscape puede ocultarse el título para ganar espacio, pero el lector de pantalla aún lo necesita.

**✅ Correcto (patrón FormacionPage):**
```dart
if (!isLandscape)
  Semantics(header: true, headingLevel: 1, child: Text(title))
else
  // Visualmente oculto pero semánticamente presente
  Semantics(header: true, headingLevel: 1, label: title, child: SizedBox.shrink())
```

---

### 3.20 — Suffix icons interactivos necesitan su propio nodo semántico

**WCAG:** 4.1.2  
**Motivo:** El icono "ojo" para mostrar/ocultar password es un botón independiente del input.

**✅ Correcto (patrón DSInput):**
```dart
if (widget.onSuffixTap != null && widget.enabled)
  Semantics(
    label: widget.suffixSemanticsLabel,   // "Mostrar contraseña"
    hint: widget.suffixSemanticsHint,      // "Pulsa para alternar visibilidad"
    button: true,
    enabled: true,
    onTap: widget.onSuffixTap,
    child: ExcludeSemantics(child: GestureDetector(onTap: ..., child: DSIcon(...))),
  )
else
  ExcludeSemantics(child: DSIcon(...)) // No interactivo → invisible para SR
```

---

## 4. Patrones reutilizables

### 4.1 — Patrón "Semantics + ExcludeSemantics" (Unified Node)

El patrón más frecuente del proyecto. Se usa en TODO widget interactivo complejo:

```dart
Semantics(
  label: 'Label unificado',
  [role]: true,     // button, textField, checkbox...
  enabled: ...,
  onTap: ...,
  child: ExcludeSemantics(
    child: /* contenido visual complejo */
  ),
)
```

**Aplicado en:** DSButton, DSInput, DSCheckbox, DSRadioButtonCard, DSDropdownInfoCard, DSHeader (iconos)

---

### 4.2 — Patrón de anuncio de errores (dual)

Los errores se anuncian por dos vías simultáneas:

1. **SemanticsService.sendAnnouncement** en `didUpdateWidget` — para anuncio inmediato
2. **Label semántico del campo** incluye el error — para re-lectura al navegar

---

### 4.3 — Patrón de heading invisible para prioridad de lectura

```dart
Stack(children: [
  Positioned(top: 0, left: 0, child: Semantics(header: true, headingLevel: 1, label: title, child: SizedBox(width: 1, height: 1))),
  // ... contenido visual
])
```

---

### 4.4 — Patrón de BottomSheet / Dialog con foco aislado

```dart
Semantics(
  container: true,
  scopesRoute: true,
  namesRoute: true,
  explicitChildNodes: true,
  label: 'Nombre del dialog',
  child: Column(children: [
    Semantics(sortKey: OrdinalSortKey(1), ...),
    Semantics(sortKey: OrdinalSortKey(2), ...),
    Semantics(sortKey: OrdinalSortKey(3), ...),
  ]),
)
```

---

### 4.5 — Patrón de formulario accesible

| Elemento | Patrón |
|----------|--------|
| Label | `ExcludeSemantics(child: Text(label))` — el label va en el Semantics padre |
| Input | `ExcludeSemantics(child: TextField(...))` — semántica en Semantics wrapper |
| Error | Se incluye en el label del campo + `SemanticsService.sendAnnouncement` |
| Placeholder | NUNCA se expone como valor semántico |
| Submit button | Deshabilitado hasta validación → `enabled: false` en Semantics |

---

### 4.6 — Patrón de navegación (Back button)

```dart
Semantics(
  label: loc.volver, // "Volver"
  button: true,
  enabled: onBackPressed != null,
  child: GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onBackPressed,
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: 48), // Touch target
      child: ExcludeSemantics(child: Row(children: [Icon, Text('Volver')])),
    ),
  ),
)
```

---

## 5. Anti-patrones detectados

### 5.1 — DSMapCard con `onTap: () {}` vacío

**Archivo:** `ds_map_card.dart`  
**Problema:** El Semantics tiene `onTap: () {}` (función vacía), lo que hace que TalkBack anuncie la card como "botón, disponible" cuando realmente no hace nada.  
**Solución:** Eliminar `onTap` del Semantics o pasar el callback real.

### 5.2 — AASkipToContent con animatedOpacity basada en Focus.of(context)

**Archivo:** `aa_skip_to_content.dart`  
**Problema:** El botón "Skip to content" solo es visible con foco de teclado, pero en móvil no hay tab-focus. Es útil para web pero innecesario en Flutter móvil puro.  
**Solución:** Considerar remover en builds puramente móviles o mantener solo para versiones web.

### 5.3 — Uso inconsistente de `AutoScrollOnFocus`

**Problema:** Se aplica a DSButton pero no a otros widgets interactivos como DSCheckbox o DSRadioButtonCard.  
**Solución:** Añadir AutoScrollOnFocus a todos los widgets interactivos del DS, o aplicarlo a nivel de formulario.

### 5.4 — AlertDialog nativo en ErrorDisplayService sin semántica DS

**Archivo:** `error_display_service.dart` → `showErrorDialog`  
**Problema:** Usa `AlertDialog` de Material en vez de `DSDialog`, perdiendo la semántica refinada (scopesRoute, OrdinalSortKey).  
**Solución:** Migrar a `DSDialog` o envolver con el mismo patrón de Semantics.

---

## 6. Checklist oficial

### Pre-commit: por cada pantalla nueva

- [ ] La pantalla tiene exactamente un `Semantics(header: true, headingLevel: 1)`
- [ ] El heading se anuncia ANTES que los controles de navegación
- [ ] El orden de lectura del lector de pantalla coincide con el orden visual
- [ ] Todos los inputs tienen label accesible (via `DSInput.label` o `semanticsLabel`)
- [ ] Los errores de validación son anunciados vía `SemanticsService.sendAnnouncement`
- [ ] Los placeholders NO se exponen como valores semánticos
- [ ] Los campos de password no exponen su valor en el árbol semántico
- [ ] Los dialogs usan `scopesRoute: true` para aislar el foco
- [ ] Los iconos decorativos están en `ExcludeSemantics` o usan `DSIcon` sin label
- [ ] Los iconos informativos tienen `semanticsLabel` descriptivo
- [ ] Los botones tienen `button: true` + `enabled` + label significativo
- [ ] No hay elementos con `onTap: () {}` vacío exponiendo interactividad falsa
- [ ] Las áreas de toque interactivas son ≥ 48×48dp (`ConstrainedBox`)
- [ ] Los mensajes de feedback (toast/snackbar/overlay) usan `SemanticsService.sendAnnouncement`
- [ ] Los spinners/loaders tienen `liveRegion: true` y anuncian "Cargando" / "Cargado"
- [ ] No existen headings duplicados en la misma pantalla
- [ ] Las cards con múltiples textos unifican su label en un solo nodo `Semantics`
- [ ] Los controles de selección (radio, checkbox) indican `checked` y `inMutuallyExclusiveGroup`
- [ ] Las cards expandibles indican `expanded: true/false`
- [ ] El contraste del focus color en theme es ≥3:1 (verificar que no se sobreescribe)

### Pre-release: auditoría completa

- [ ] Test con TalkBack (Android) navegando todas las pantallas
- [ ] Test con VoiceOver (iOS) navegando todas las pantallas
- [ ] Verificar con Accessibility Scanner (Android)
- [ ] Verificar text scaling a 200% no rompe layouts
- [ ] Verificar landscape mantiene headings semánticos
- [ ] Ejecutar `flutter test` con tests BDD de semántica

---

## 7. Recomendaciones para el Design System

### Props obligatorias en todo widget interactivo

| Prop | Tipo | Obligatoriedad | Uso |
|------|------|----------------|-----|
| `semanticsLabel` | `String?` | Opcional con fallback | Label principal para screen reader |
| `semanticsHint` | `String?` | Opcional | Descripción de la acción |
| `enabled` | `bool` | Derivada de `onPressed != null` | Estado habilitado/deshabilitado |

### Regla de fallback de label

Todo widget DS debe tener un fallback automático para el label:

```dart
label: semanticsLabel ?? text ?? title ?? 'Widget genérico'
```

### Wrappers que todo DS Widget debería usar

| Wrapper | Cuándo |
|---------|--------|
| `Semantics(...)` | SIEMPRE como root del widget |
| `ExcludeSemantics(child: ...)` | Dentro del Semantics, envolviendo el contenido visual |
| `AutoScrollOnFocus(child: ...)` | Para widgets que pueden estar offscreen en formularios |
| `ConstrainedBox(minWidth: 48, minHeight: 48)` | Para todo target de tap |

### Helpers que deberían existir en todo proyecto

1. **`SemanticsService.sendAnnouncement`** wrapper localizado
2. **Error announce helper** que añade prefijo "Error, {campo}: {mensaje}"
3. **Loading state announcer** ("Cargando" / "Contenido cargado")
4. **`_buildSemanticsLabel`** pattern para cards complejas

---

## 8. Conclusiones

### Estado actual del proyecto

| Aspecto | Nivel |
|---------|-------|
| Design System | ✅ Maduro — todos los widgets tienen semántica integrada |
| Pantallas de features | ✅ Consistente — headings en todas las páginas |
| Anuncio de errores | ✅ Automatizado — centralizado en DSInput + ErrorDisplayService |
| Foco y navegación | ✅ Correcto — scopesRoute en dialogs, AutoScrollOnFocus |
| Contraste | ✅ Validado — focus color >18:1, bordes >3:1 |
| Runtime validation | ✅ Existe — `aa_sdd_accessibility` bridge para auditoría automática |

### Nivel de madurez: **Alto (4/5)**

El proyecto tiene accesibilidad estructural sólida, con patrones bien definidos y automatizados. Las pocas inconsistencias son menores y localizadas.

### Recomendaciones futuras

1. **Migrar `AlertDialog` nativos a `DSDialog`** para semántica unificada
2. **Añadir `headingLevel: 2`** a subtítulos de secciones dentro de páginas (actualmente solo se usa H1)
3. **Extender `AutoScrollOnFocus`** a DSCheckbox, DSRadioButton y DSDropdown
4. **Crear test de integración automatizado** que recorra todas las pantallas y valide que cada una tiene exactamente un H1
5. **Documentar labels semánticos** en un glosario para traductores (los labels también deben localizarse)

### Riesgos a evitar

- **No añadir Semantics sin ExcludeSemantics en los hijos** — genera nodos duplicados
- **No usar `Semantics(label: '')` vacío** — crea nodos fantasma en el árbol
- **No abusar de liveRegion** — si todo es liveRegion, el usuario se satura de anuncios
- **No olvidar localizar labels semánticos** — `loc.accessibility_*` para todos los textos fijos

---

*Documento generado a partir de la auditoría del proyecto Presencia (Mayo 2026). Para dudas: consultar los archivos en `documentation/sdd_design_system_semantics/` y `lib/features/aa_sdd_accessibility/`.*
