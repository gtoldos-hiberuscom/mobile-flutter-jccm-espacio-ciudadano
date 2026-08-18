# Reglas de accesibilidad por componente

Fecha: 13 de agosto de 2026  
Referencia: aplicación Navarra Empleo  
Destino: nuevos proyectos Flutter que deban reproducir el mismo nivel de accesibilidad.

## Propósito

Este documento es una **especificación de implementación**, no una auditoría. Define las reglas obligatorias que debe aplicar el nuevo proyecto tomando como referencia los patrones de accesibilidad de Navarra Empleo.

Las palabras **debe**, **no debe** y **obligatorio** expresan requisitos de aceptación. Una pantalla o componente no se considera terminado hasta cumplir sus reglas automáticas y manuales.

Objetivo de conformidad: **WCAG 2.2 nivel AA**, complementado con las convenciones de accesibilidad de Flutter, Android y iOS.

## Reglas transversales

### 1. Idioma y localización

- Todos los nombres accesibles, hints, estados, errores y anuncios deben proceder de `AppLocalizations`.
- No deben existir textos semánticos técnicos o sin localizar como `button_1`, `ds_submit` o `Input Label`.
- La aplicación debe declarar los idiomas soportados y actualizar la semántica cuando cambie el idioma.
- Las fechas, horas, cantidades, siglas y códigos deben tener una pronunciación comprensible. Cuando la lectura literal no sea adecuada, debe proporcionarse una representación semántica específica.
- La etiqueta accesible de un control debe contener su texto visible.

### 2. Texto y escalado

- Todo texto debe usar los tokens tipográficos del design system o el `TextTheme` del proyecto.
- Debe respetarse `MediaQuery.textScaler` sin limitar el escalado configurado por la persona usuaria.
- Todas las pantallas deben funcionar con texto al 200 %, sin pérdida de información, solapamientos ni controles inaccesibles.
- `RichText` debe declarar `textScaler: MediaQuery.textScalerOf(context)`.
- El texto debe poder ocupar varias líneas. En filas se usarán `Flexible`, `Expanded` o `Wrap` cuando pueda crecer.
- No se usarán alturas fijas en contenedores con texto. Los anchos de diseño se convertirán en constraints adaptativas.
- Los textos de 12 px se reservan para información secundaria y nunca para instrucciones esenciales, errores o acciones.

Patrón global:

```dart
MaterialApp(
  builder: (context, child) {
    final mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: mediaQuery.textScaler,
      ),
      child: child!,
    );
  },
)
```

### 3. Encabezados y jerarquía

- Cada pantalla debe tener **un único encabezado principal de nivel 1** que describa su propósito.
- El título principal debe usar `Semantics(header: true, headingLevel: 1)`.
- Las secciones internas deben usar nivel 2; las subsecciones incluidas en ellas, nivel 3.
- No deben saltarse niveles sin una razón estructural.
- El nivel semántico es independiente del estilo visual. Usar `DSTypography.h1` no convierte un texto en H1; del mismo modo, un H1 puede usar otro estilo visual si el diseño lo exige.
- El nombre del encabezado debe ser el mismo texto localizado que se muestra visualmente.
- El encabezado principal debe aparecer al comienzo del orden semántico cuando se abre la pantalla.
- No debe duplicarse el H1 entre una cabecera común y el título visible del contenido.
- Un encabezado no es un botón y no debe incorporar acciones ni una parada de foco de teclado innecesaria.

Título principal:

```dart
Semantics(
  header: true,
  headingLevel: 1,
  child: Text(
    l10n.register_title,
    style: DSTypography.h1.copyWith(
      color: DSColors.grey950,
    ),
  ),
)
```

Sección interna:

```dart
Semantics(
  header: true,
  headingLevel: 2,
  child: Text(
    l10n.section_title,
    style: DSTypography.h3.copyWith(
      color: DSColors.grey950,
    ),
  ),
)
```

### 4. Contraste y uso del color

#### Ratios obligatorios

| Elemento | Ratio mínimo |
|---|---:|
| Texto normal | 4,5:1 |
| Texto grande: al menos 24 px regular o 18,66 px negrita | 3:1 |
| Iconos funcionales | 3:1 |
| Bordes necesarios para identificar un control | 3:1 |
| Indicadores de selección | 3:1 |
| Indicadores de foco | 3:1 |
| Partes necesarias de gráficos informativos | 3:1 |

- El ratio debe calcularse entre el color renderizado y su fondo efectivo, incluidas transparencias.
- Todos los estados deben validarse por separado: default, hover, focused, pressed, selected, error y disabled.
- Los títulos H1–H4 siguen siendo texto y deben cumplir el ratio correspondiente.
- El color nunca debe ser la única forma de comunicar error, selección, foco, éxito o aviso. Se añadirá texto, icono, borde, forma o estado semántico.
- El estado deshabilitado es una excepción de contraste WCAG, pero debe seguir siendo reconocible y anunciar `enabled: false`.
- Sobre imágenes, mapas o degradados debe existir una superficie u overlay que garantice el contraste en toda la zona ocupada por el texto.

#### Combinaciones de referencia

| Uso | Primer plano / fondo | Ratio | Aplicación |
|---|---|---:|---|
| Texto principal | gris 950 / blanco | 19,44:1 | Recomendado |
| Texto mínimo admisible sobre blanco | gris 600 / blanco | 4,54:1 | Solo texto normal AA |
| Botón primario | blanco / rojo 500 | 5,14:1 | Texto e iconos activos |
| Botón primario pulsado | blanco / rojo 800 | 13,34:1 | Texto e iconos activos |
| Error | rojo 600 / blanco | 6,91:1 | Texto, icono y borde |
| Información | cian 700 / cian 50 | 6,06:1 | Texto e icono |
| Aviso | amarillo 800 / amarillo 50 | 7,22:1 | Texto e icono |
| Éxito | verde 700 / verde 50 | 5,56:1 | Texto e icono |
| Borde de control | gris 600 / blanco | 4,54:1 | Recomendado |
| Gris 500 / blanco | 2,78:1 | No usar en información o límites necesarios |

Cada nuevo par de colores debe calcularse y documentarse. No se aceptará una combinación únicamente por inspección visual.

### 5. Área táctil, teclado y foco

- Todo control interactivo debe disponer de un área mínima de **48×48 dp**.
- Un icono puede medir 16 o 24 px visualmente, pero su contenedor interactivo debe mantener 48×48 dp.
- La etiqueta completa de checkbox y radio debe activar el control.
- Todo elemento operable mediante toque debe poder recibir foco y activarse mediante teclado y tecnología asistiva.
- Se priorizarán los controles Material (`Button`, `IconButton`, `Checkbox`, `Radio`, `InkWell`) o `FocusableActionDetector` con acciones explícitas.
- Un `GestureDetector` acompañado únicamente de `Focus` no es suficiente: deben implementarse Enter y Espacio.
- Escape o atrás debe cerrar menús y diálogos sin perder el contexto.
- El foco debe ser visible, alcanzar 3:1 de contraste, seguir el orden de lectura y no quedar oculto por teclado, modal o barra fija.
- Al cerrar un diálogo o menú, el foco debe regresar al elemento que lo abrió.
- Los campos deben desplazarse automáticamente cuando el teclado pueda ocultarlos.

### 6. Nombre, rol, valor y estado

- Todo control debe exponer nombre accesible localizado, rol, valor/estado y acciones coherentes.
- No debe existir ningún `Semantics(label: '')` en un componente informativo o interactivo.
- Los botones deben anunciar nombre, rol botón y estado habilitado.
- Los toggles deben anunciar también `toggled` o `checked` y actualizarlo inmediatamente.
- Los checkbox deben anunciar `checked` y `enabled`.
- Los radio deben anunciar `checked`, `enabled` e `inMutuallyExclusiveGroup`.
- Los desplegables deben anunciar nombre, valor actual y estado expandido/contraído.
- Los campos deben anunciar etiqueta, valor, obligatoriedad, propósito, habilitación y error.
- Los iconos decorativos deben excluirse del árbol semántico.
- Los iconos funcionales deben tener un nombre localizado que describa la acción, no su apariencia.
- No deben declararse acciones semánticas vacías o que no produzcan la acción anunciada.
- Se usará `ExcludeSemantics` o `MergeSemantics` para evitar lecturas duplicadas, manteniendo navegación granular cuando el contenido sea largo.

### 7. Errores, alertas y carga

- Los errores deben mostrarse mediante texto e icono además de color.
- El mensaje debe identificar el campo, explicar el problema y, cuando sea posible, indicar cómo corregirlo.
- El error debe estar asociado semánticamente con su campo.
- Los errores dinámicos deben anunciarse una sola vez mediante `liveRegion` o `SemanticsService.sendAnnouncement`.
- Los mensajes de estado importantes deben anunciarse sin mover el foco.
- La carga debe anunciar su inicio y su finalización.
- Un spinner indeterminado no debe anunciar un porcentaje inexistente.
- Los mensajes temporales deben permanecer el tiempo suficiente o poder recuperarse.

## Reglas por componente

### `DSHeader`

- Debe recibir el título localizado de la pantalla mediante `pageTitle`.
- Debe exponer exactamente un H1 con `header: true` y `headingLevel: 1`.
- El H1 debe ser el primer contenido semántico de la pantalla.
- Si el título se muestra en el contenido, la cabecera no debe crear un segundo H1 equivalente.
- Atrás, inicio, notificaciones, ajustes, menú y cerrar deben tener etiquetas localizadas específicas.
- Cada acción debe ser un botón semántico, medir 48×48 dp y funcionar con toque, Enter y Espacio.
- El orden debe ser título, navegación y después contenido principal.
- Los iconos y el logotipo decorativos deben excluirse de semántica.
- Texto e iconos deben alcanzar el contraste correspondiente con el fondo de la cabecera.

### `DSButton`

- Debe exponer `button: true`, un nombre no vacío y `enabled` coherente con `onPressed`.
- El nombre debe incluir el texto visible. En variantes icon-only, `semanticsLabel` localizado es obligatorio.
- `semanticsHint` solo debe usarse cuando aporte información distinta del nombre.
- Los botones toggle deben anunciar `toggled` o `checked`.
- Debe funcionar con toque, acción semántica, Enter y Espacio.
- El área mínima es 48×48 dp en todas las variantes, incluidas las terciarias.
- El foco debe ser visible y tener contraste 3:1.
- El texto debe envolver al 200 % sin truncarse.
- Primario: blanco sobre rojo 500 o más oscuro. Secundario/terciario: gris 950 sobre blanco.
- El estado disabled debe anunciarse y no ejecutar acciones.

### `DSMenu` y `DSMenuItem`

- El menú debe tener un nombre solo cuando este ayude a identificar el grupo; nunca una etiqueta vacía.
- Cada opción debe ser una única parada de foco con nombre, rol, enabled y selected cuando corresponda.
- Debe abrirse con Enter/Espacio, navegarse con flechas y cerrarse con Escape, atrás o toque exterior.
- El foco inicial debe situarse en la opción seleccionada o en la primera habilitada.
- Al cerrar, debe volver al botón que abrió el menú.
- Cada opción debe medir al menos 48 dp de alto.
- Los divisores son decorativos y deben excluirse de semántica.

### `DSCalendarDay` y `DSCalendarYear`

- Cada celda debe anunciar día/año, selección, disponibilidad y contexto necesario.
- El día debe poder anunciar fecha completa, “hoy” y “seleccionado” sin depender únicamente del color.
- Las celdas deben medir al menos 48×48 dp o mantener área equivalente sin solapamiento.
- Deben funcionar con toque, acción semántica, Enter y Espacio.
- El calendario debe permitir navegación lógica con flechas.
- Días fuera de rango deben anunciarse como deshabilitados y no ejecutar acciones.
- Los estados default, today, selected y focused deben cumplir contraste no textual 3:1.

### `DSInput`

- La etiqueta visible y persistente es obligatoria; el placeholder nunca puede ser la única etiqueta.
- Debe exponer rol de campo, nombre, valor, enabled y obligatoriedad.
- Debe configurar `keyboardType`, `textInputAction`, `autofillHints`, autocorrección y sugerencias según el dato.
- Los campos de contraseña deben ofrecer mostrar/ocultar con etiqueta y estado actualizados.
- El icono suffix interactivo debe tener botón semántico y área de 48×48 dp.
- El error debe anunciarse como “Error, {campo}: {problema}. {solución}”.
- El error debe aparecer visualmente con texto, icono y borde; rojo 600 sobre blanco es la combinación de referencia.
- Debe desplazarse al recibir foco si el teclado pudiera ocultarlo.
- Debe funcionar a 200 % y en 320 dp de ancho sin overflow.

### `DSTextArea`

- Debe aplicar todas las reglas de `DSInput`.
- Debe aceptar crecimiento vertical del texto y no depender de una altura fija que recorte contenido.
- Debe anunciar correctamente instrucciones, límite de caracteres y error.
- El contador, si existe, debe actualizarse sin generar anuncios excesivos.

### `DSDropdown`

- Debe anunciar etiqueta, valor seleccionado, enabled y expanded/collapsed.
- El botón y la lista deben mantener una única relación semántica clara.
- Debe abrirse con toque, Enter o Espacio; navegar con flechas; seleccionar con Enter; cerrar con Escape.
- El foco debe entrar en la lista y regresar al botón al cerrarla.
- Las opciones deben exponer nombre, selected y enabled.
- El error debe asociarse al control y anunciarse una vez.
- La anchura debe adaptarse al contenedor y la lista debe poder desplazarse.
- El icono de flecha es decorativo cuando el estado ya está anunciado.

### `DSSearchForm`

- Debe tener una etiqueta de grupo solo si no duplica las etiquetas de sus controles.
- El campo, filtros y botón de búsqueda deben conservar nombres independientes.
- La acción del teclado “buscar” debe ejecutar la misma operación que el botón.
- Los resultados o el estado vacío deben anunciarse sin mover el foco de forma inesperada.
- Debe aplicar las reglas de `DSInput`, `DSDropdown` y `DSButton`.

### `DSCheckbox`

- Toda la fila formada por indicador y etiqueta debe ser pulsable y medir al menos 48 dp de alto.
- Debe exponer nombre, `checked`, `enabled` y una única acción.
- Debe funcionar con toque, acción semántica y Espacio.
- El indicador seleccionado debe usar check/relleno además de color.
- El borde sin seleccionar debe usar al menos gris 600 sobre blanco.
- La etiqueta visible debe formar parte del nombre accesible.

### `DSCheckboxCard`

- Debe aplicar todas las reglas de `DSCheckbox` a la tarjeta completa.
- La tarjeta debe ser una única parada semántica y de foco.
- La selección debe anunciarse y diferenciarse mediante check, peso tipográfico y borde/relleno.
- No deben existir acciones duplicadas entre tarjeta y checkbox interno.

### `DSRadioButton`

- Debe exponer nombre, `checked`, `enabled` e `inMutuallyExclusiveGroup`.
- Toda la fila debe ser pulsable y medir al menos 48 dp de alto.
- Debe funcionar con toque, acción semántica, flechas y Espacio.
- El grupo debe tener una leyenda o pregunta anunciada antes de sus opciones.
- Solo una opción del grupo puede estar seleccionada.
- El borde sin seleccionar debe usar al menos gris 600 sobre blanco.
- La selección debe distinguirse mediante forma/relleno/check además del color.

### `DSRadioButtonCard`

- Debe aplicar todas las reglas de `DSRadioButton` a la tarjeta completa.
- Cada tarjeta debe ser una única parada de foco y un único nodo semántico.
- No deben duplicarse las acciones de tarjeta y radio interno.
- Debe anunciarse el estado seleccionado inmediatamente después del cambio.

### `DSCard`

- Una tarjeta informativa sin acción no debe anunciarse como botón.
- Una tarjeta accionable debe anunciar nombre, rol botón y enabled.
- El nombre debe resumir el destino o propósito sin ocultar información que necesite navegación granular.
- La tarjeta debe funcionar con toque, acción semántica, Enter y Espacio.
- Debe tener área mínima de 48 dp, foco visible y contraste 3:1.
- El contenido debe adaptarse al 200 % sin depender de altura fija.

### `DSDropdownInfoCard`

- Debe anunciar nombre, valor relevante y estado expanded/collapsed.
- El contenido contraído no debe anunciarse como si estuviera visible.
- Al expandirse, el contenido debe quedar disponible en orden de lectura.
- Debe existir una sola acción de expansión y una única parada de foco.
- El botón de descarga interno debe conservar nombre y foco independientes.
- Debe funcionar con toque, Enter, Espacio y acción semántica.

### `DSMapCard`

- La información de ubicación debe conservar etiquetas y valores comprensibles.
- Una tarjeta sin acción no debe declarar `onTap` ni rol interactivo.
- Abrir mapa, ruta, llamada o web debe implementarse como acciones independientes con nombres explícitos.
- `RichText` debe respetar `MediaQuery.textScalerOf(context)`.
- El mapa o imagen de fondo no debe reducir el contraste del texto.

### `DSDialog`

- Debe anunciar título, descripción y acciones al abrirse.
- El título debe marcarse como encabezado dentro del diálogo.
- El foco inicial debe entrar en el diálogo y quedar contenido en él.
- Escape/atrás debe cerrar cuando la operación lo permita.
- Al cerrar, el foco debe volver al elemento que lo abrió.
- Los botones deben tener nombres inequívocos; se evitarán acciones genéricas como “Sí” sin contexto.
- Debe adaptarse a texto al 200 %, pantallas estrechas y orientación horizontal mediante constraints y scroll.

### `DSModalCalendar`

- Debe aplicar las reglas de `DSDialog`, `DSCalendarDay` y `DSCalendarYear`.
- Debe anunciar mes/año mostrado y fecha seleccionada.
- Anterior, siguiente y selector de mes/año deben ser botones de 48×48 dp con etiquetas localizadas.
- La navegación por teclado debe mantener una cuadrícula lógica.
- Cancelar y aceptar deben conservar foco y nombres explícitos.
- El ancho debe ser máximo adaptable, nunca un ancho rígido obligatorio.

### `DSAlert`

- Debe anunciar tipo y mensaje mediante una única etiqueta localizada.
- Debe utilizar texto/icono además del color.
- Una alerta dinámica debe usar `liveRegion`; una alerta ya presente al cargar no debe generar anuncios repetidos.
- Cuando se use contenido visual personalizado, `semanticsLabel` es obligatorio.
- No se usarán fallbacks genéricos como “Alert”.
- Las combinaciones de información, aviso, éxito y error deben mantener al menos 4,5:1 para texto.

### `DSSpinner`

- Debe anunciar una operación concreta, por ejemplo “Cargando ofertas”.
- Debe usar live region cuando represente una espera relevante.
- Debe anunciar la finalización una sola vez.
- Un spinner decorativo debe excluirse de semántica.
- No debe anunciar porcentajes en progreso indeterminado.
- La animación debe respetar las preferencias de reducción de movimiento cuando sea aplicable.

### `DSIcon`

- Debe ser decorativo por defecto y quedar excluido mediante `ExcludeSemantics`.
- Un icono informativo debe recibir una etiqueta localizada.
- Un icono accionable debe estar dentro de un botón semántico de 48×48 dp.
- La etiqueta debe describir la acción (“Cerrar”), no la forma (“Aspa”).
- Los iconos funcionales deben alcanzar contraste 3:1.

### `DSAlertTag` y `DSTag`

- Deben anunciar una única etiqueta y evitar duplicar icono y texto.
- El tipo o estado debe expresarse con texto/icono además del color.
- Si la etiqueta no expresa el significado, el nombre debe incluirlo: “Error: documentación pendiente”.
- Si un tag pasa a ser seleccionable o eliminable, debe convertirse en control con estado, foco, acción de teclado y área de 48×48 dp.
- Texto e iconos deben cumplir sus ratios contra el fondo del tag.

### `DSPageLayout`

- Debe mantener el orden semántico: encabezado, contenido principal y acciones finales.
- Debe respetar safe areas, orientación y teclado en pantalla.
- El contenido debe poder desplazarse con texto al 200 %.
- La barra inferior no debe ocultar contenido ni el indicador de foco.
- Las acciones persistentes deben conservar nombre, posición y comportamiento entre pantallas.

## Criterios de aceptación por componente

Cada componente interactivo debe incluir pruebas para:

1. Nombre, rol, valor, enabled y selected/checked/toggled/expanded cuando corresponda.
2. Ausencia de etiquetas vacías y nodos semánticos duplicados.
3. Área táctil mínima mediante `androidTapTargetGuideline` y, cuando proceda, `iOSTapTargetGuideline`.
4. Activación mediante acción semántica, Enter, Espacio y Escape según el control.
5. Orden de foco hacia delante y hacia atrás.
6. Indicador de foco visible con contraste 3:1.
7. Contraste de todos los estados renderizados.
8. Reflow sin overflow a 320×568 dp y texto al 200 %.
9. Textos largos en todos los idiomas soportados.
10. Anuncio único y comprensible de errores, carga y cambios de estado.

Ejemplo de prueba de reflow:

```dart
testWidgets('funciona con texto al 200 %', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(
        size: Size(320, 568),
        textScaler: TextScaler.linear(2),
      ),
      child: buildTestApp(),
    ),
  );

  expect(tester.takeException(), isNull);
});
```

## Validación manual antes de publicar

- Recorrer todos los flujos principales con TalkBack.
- Recorrer todos los flujos principales con VoiceOver.
- Completar cada flujo solo con teclado físico.
- Revisar escalas de texto 100 %, 150 % y 200 %.
- Revisar pantalla de 320 dp y orientación horizontal.
- Comprobar foco al abrir/cerrar menús, diálogos y selectores.
- Comprobar español y euskera con los textos más largos.
- Verificar que ningún significado depende únicamente de color, posición o gesto.
- Confirmar manualmente los ratios generados por transparencias, imágenes y overlays.

La conformidad se acepta únicamente cuando las pruebas automáticas pasan y la validación manual no detecta barreras.
