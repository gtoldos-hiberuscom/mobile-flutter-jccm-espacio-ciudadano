# Anexo C — Calidad transversal, seguridad, testing y gobierno técnico

Derivado de `architecture_canon_flutter_v2.md`.

## 21. Localización, formatos y textos

Flutter documenta que, para soportar otros idiomas, la app debe configurar `flutter_localizations`, `supportedLocales` y el flujo de generación de recursos localizados; además, el flujo moderno incluye `intl` y generación desde configuración `l10n`. citeturn430061view5

## 21.1. Regla general

Toda app de producto debe ser localizable desde el principio.

## 21.2. Estructura recomendada

```text
lib/l10n/
  app_es.arb
  app_en.arb
l10n.yaml
```

## 21.3. Reglas

- nada de strings hardcodeadas en widgets salvo prototipos efímeros;
- placeholders, plurales y selects definidos correctamente;
- formatos de fecha, moneda y número dependientes de locale;
- textos de error de usuario también localizados;
- accesibilidad y labels también localizados.

## 21.4. Textos técnicos vs funcionales

- mensajes internos de log: no necesitan localización;
- mensajes de usuario: sí;
- códigos de error: pueden ser internos, pero nunca mostrarse crudos.

---

## 22. Theming y design system

## 22.1. Tema único de aplicación

`app/theme/` define:

- color scheme;
- typography;
- component themes;
- spacing scale;
- radii/elevation tokens.

## 22.2. Regla de consumo

Las features no inventan colores hex ni `TextStyle` inline arbitrarios.

Preferido:

- tokens;
- componentes de design system;
- extensiones de theme controladas.

## 22.3. Dark mode y high contrast

Decisión obligatoria por proyecto:

- soportado desde el inicio;
- soportado más adelante;
- no soportado por alcance.

Lo importante es que quede explícito.

---

## 23. Accesibilidad

Tu documento actual ya incluye a11y como preocupación, pero aquí pasa a ser parte contractual del proyecto. fileciteturn1file12

## 23.1. Mínimos obligatorios

- labels/semantics en componentes interactivos relevantes;
- orden lógico de foco;
- targets táctiles adecuados;
- contraste suficiente;
- feedback no exclusivamente dependiente del color;
- textos escalables y layouts robustos.

## 23.2. Regla de componentes

Todo componente del design system debe nacer accesible o con contrato explícito de accesibilidad.

## 23.3. Checklist de PR

Toda UI nueva debe responder:

- ¿se puede entender con lector de pantalla?
- ¿se puede usar con tamaño de texto aumentado?
- ¿el foco es coherente?
- ¿el error se percibe sin depender del color?
- ¿los labels están localizados?

---

## 24. Seguridad

## 24.1. Principios

- minimizar exposición de datos;
- no confiar en el cliente para seguridad de negocio;
- endurecer almacenamiento local;
- sanitizar entradas y salidas;
- proteger trazas y logs;
- revisar apertura de enlaces externos.

## 24.2. Reglas concretas

- tokens en secure storage;
- secretos reales nunca embebidos;
- URLs externas validadas;
- logs redactados;
- borrar sesión en logout de forma completa;
- evitar serializar datos sensibles en analytics/crash reports.

## 24.3. PII

Debe existir una lista explícita de campos sensibles del proyecto.

Ejemplos comunes:

- documento de identidad;
- email;
- teléfono;
- dirección;
- datos bancarios;
- tokens;
- datos sanitarios.

Cualquier tratamiento de estos datos exige revisión.

---

## 25. Performance

## 25.1. Presupuestos mínimos

Toda app debe definir objetivos aproximados para:

- startup;
- carga de pantallas críticas;
- scrolling fluido;
- peso de APK/IPA;
- consumo de red;
- coste de rebuilds.

## 25.2. Reglas de UI

- usar `const` cuando aporte valor;
- evitar trabajo costoso en `build`;
- paginar listas grandes;
- desacoplar estados para no reconstruir árboles innecesarios;
- evitar `setState` disperso si el proyecto usa Riverpod.

## 25.3. Reglas de datos

- batch requests cuando tenga sentido;
- caché razonable;
- compresión y payloads acotados;
- parseo fuera de hot paths si fuese costoso.

---

## 26. Estrategia de testing

Flutter recomienda combinar muchos unit y widget tests con suficientes integration tests para cubrir los casos importantes, asumiendo los trade-offs de confianza, coste de mantenimiento y velocidad. citeturn436078view0

Tu guía de testing ya define una pirámide clara con unit, BDD/widget-like, goldens y E2E/integration. fileciteturn2file1 Ese modelo se consolida así:

## 26.1. Pirámide normativa

1. **Unit tests**  
   Dominio, mappers, utilidades, validadores.

2. **Widget / BDD tests**  
   Comportamiento de UI, rutas, estados visuales, interacción.

3. **Golden tests**  
   Estados críticos y regresiones visuales.

4. **Integration / E2E tests**  
   Flujos extremos a extremo y smoke/regresión crítica.

Flutter define tres categorías principales: unit, widget e integration tests, con distinta confianza y coste. citeturn436078view0turn436078view1

## 26.2. Reglas por capa

### Dominio
- un test por caso de uso mínimo;
- happy path y error path;
- mocks de repositorios;
- no tocar red ni disco.

### Data
- tests de mappers;
- tests de repositorios;
- contract tests del cliente generado;
- tests de parsing y errores.

### Presentación
- controller/notifier tests;
- widget tests de pantallas importantes;
- validación de loading, data, error y empty.

### Integración
- login;
- restauración de sesión;
- navegación principal;
- flujo crítico de negocio;
- errores recuperables principales.

## 26.3. Cliente generado y contratos HTTP

Tu `test_quality_guide.md` ya fija una barra mínima muy buena para endpoints: método, path, query, headers, body, content-type, auth, parseo, errores, transporte, nullability y binarios. fileciteturn2file2 Esa matriz se vuelve contractual.

Regla:

Ningún endpoint se da por validado solo porque compile o porque un builder round-trip pase. El cierre exige comportamiento observable de contrato y transporte. fileciteturn1file5turn2file2

## 26.4. Organización

Se mantiene la separación ya descrita en tu guía:

- `test/` para unit/widget/BDD;
- `integration_test/` para integración;
- goldens por feature;
- helpers compartidos controlados. fileciteturn2file1turn1file14

## 26.5. CI

Los tests automáticos mínimos en CI deben incluir:

- análisis estático;
- generación de código verificada;
- unit tests;
- widget/BDD tests;
- golden checks si el pipeline lo soporta;
- integration tests en job específico si el entorno está preparado.

---

## 27. Release, versionado y changelog

Tu política actual de versionado usa SemVer `MAJOR.MINOR.PATCH+BUILD`, build autoincrementado en CI, tags `vX.Y.Z`, convención de commits y changelog automatizado. fileciteturn2file3turn1file15 Eso se integra aquí sin cambios de fondo.

## 27.1. Regla

`pubspec.yaml` es la fuente de verdad funcional de versión de la app, con build number sobrescribible por CI. fileciteturn2file3

## 27.2. Pipeline mínimo de release

- branch de release o estrategia trunk claramente definida;
- bump de versión;
- generación de changelog;
- tag;
- build firmada;
- despliegue;
- release notes.

## 27.3. Convención de commits

Se mantiene convención estructurada porque favorece:

- changelog;
- auditoría;
- revisión de PR;
- lectura semántica de cambios. fileciteturn1file15

---

## 28. Lints, formato y verificaciones automáticas

## 28.1. `analysis_options.yaml`

Debe endurecer:

- warnings como errores cuando sea viable;
- reglas contra imports no permitidos si se dispone de lint custom;
- reglas de estilo del proyecto;
- exclusiones mínimas.

## 28.2. Custom lints

Muy recomendable crear un package interno `app_lints` o `custom_lint` para verificar:

- imports prohibidos entre capas;
- imports cruzados entre features;
- naming;
- rutas de carpetas;
- uso de `StateNotifier` en nuevo código;
- strings hardcodeadas en UI;
- acceso directo a `String.fromEnvironment`.

## 28.3. Build verification

CI debe fallar si:

- `build_runner` genera diffs no commiteados;
- faltan archivos generados;
- hay goldens pendientes de actualizar de forma no justificada;
- el análisis estático falla;
- la cobertura mínima crítica cae por debajo del umbral acordado.

---

## 29. ADRs y gestión de excepciones

## 29.1. Cuándo hace falta ADR

Crear ADR cuando se cambie:

- state management;
- estrategia de routing;
- estructura del repo;
- sistema de errores;
- forma de cachear;
- estrategia offline;
- release process;
- integración crítica con SDKs;
- cualquier excepción relevante a este canon.

## 29.2. Formato mínimo de ADR

- contexto;
- decisión;
- alternativas consideradas;
- consecuencias;
- fecha;
- estado.

## 29.3. Regla

Una excepción sin ADR no es arquitectura; es deriva.

---

