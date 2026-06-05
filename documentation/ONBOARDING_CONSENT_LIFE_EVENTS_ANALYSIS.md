# Análisis de implementación: Onboarding, Condiciones de uso, Protección de datos y Hechos Vitales

> **Fecha de generación:** 4 de junio de 2026
> **Alcance:** Verificación basada exclusivamente en tickets (`/tickets/`) y código fuente (`/lib/`).
> **Propósito:** Documentación precisa para Jira del estado real desarrollado e identificación de huecos pendientes.

---

## 1. Tickets identificados y su relación

| Ticket | Jira Key | Descripción | Estado |
|---|---|---|---|
| STORY-17 | JCCMEC-9 | Landing anónima y flujo informativo previo al acceso | ✅ Done |
| STORY-18 | JCCMEC-10 | Login Cl@ve, callback seguro y ciclo de vida de sesión | ✅ Done |
| STORY-19 | JCCMEC-11 | Aceptación inicial de condiciones de uso y protección de datos | ✅ Done |
| TASK-21 | JCCMEC-13 | Validar claims JWT, idAgente y parámetros federados | ✅ Done |
| STORY-54 | JCCMEC-53 | Selección y guardado de hechos vitales | ✅ Done |
| STORY-55 | JCCMEC-54 | Autorizaciones de uso de datos y revocación desde preferencias | ✅ Done |
| STORY-56 | JCCMEC-55 | Recomendaciones personalizadas con filtros y agrupación por hecho vital | ✅ Done |
| STORY-57 | JCCMEC-56 | Onboarding y estado vacío de recomendaciones | ✅ Done |
| STORY-61 | JCCMEC-60 | Páginas legales estáticas (condiciones, privacidad, accesibilidad, aviso legal) | ✅ Done |

---

## 2. Flujo completo verificado en código

```
App start
  └─ LandingPage
       ├─ [biometricQuickAccess = true + token en SecureStorage]
       │     └─ authenticateBiometrically → restaura sesión → Routes.home*
       └─ [usuario pulsa "Acceder con Cl@ve"]
             └─ flutter_appauth (PKCE) → callback deep link
                   └─ LoginCallbackPage → esperando landingProvider
                         └─ loginSuccess → Routes.home*

* Cada navegación a ruta autenticada pasa por SessionGuard.redirect():
   1. ¿Tiene token válido?
         No → intenta refresh silencioso
               Si falla → limpia SecureStorage → Routes.landing
   2. ¿Ha aceptado consentimiento? (SharedPreferences keyed por idAgente)
         No → Routes.legalPrivacy (PrivacyPage con scroll-lock)
                └─ scroll hasta el final → botón "Aceptar y continuar" activo
                      └─ Routes.consent?mode=onboarding (ConsentPage paso 2)
                            ├─ Rechazo → Routes.landing
                            └─ Aceptación → persiste en SharedPreferences → Routes.home
   3. ¿Ha visto onboarding de hechos vitales? (SharedPreferences keyed por idAgente)
         No → Routes.lifeEvents?mode=onboarding (LifeEventsPage modo onboarding)
                └─ guardar selección → HechosVitalesApi (backend real) →
                      marca visto en SharedPreferences → Routes.home
   4. Navega a destino original
```

---

## 3. Descripción detallada de lo implementado por ticket

---

### STORY-17 — Landing anónima y flujo informativo previo al acceso

**Ficheros principales:**
- `lib/features/landing/2_presentation/landing_page.dart`
- `lib/features/landing/2_presentation/landing_notifier.dart`
- `lib/features/landing/2_presentation/landing_help_page.dart`
- `lib/features/landing/2_presentation/landing_about_page.dart`

**Navegación y flujo:**

- Pantalla pública (no autenticada) con logo institucional JCCM, logo Espacio Ciudadano, tagline y hero image. Diseño basado en Figma `00_Splash_Inicio`.
- El router (`GoRouter`) inicia en `Routes.landing` (`/`). Es la ubicación de entrada de la app.
- Barra inferior fija (`AppStickybar`) con 3 botones de acción: acceder, ayuda y "acerca de".
- Navegación a `LandingHelpPage` (`/landing/help`) y `LandingAboutPage` (`/landing/about`) como rutas hijas.
- El botón principal de acceso lanza `LandingNotifier.login()`.

**Persistencia y restauración de sesión:**

- En `didChangeDependencies`, antes de renderizar, se ejecuta `tryUnlockStoredSession()`.
- Si el flag `biometricQuickAccessEnabled` está activo en SharedPreferences **y** existe un `accessToken` en `SecureStorage`, se intenta autenticación biométrica nativa.
- Si tiene éxito, se restaura la sesión completa en memoria (`tokenResponseProvider`, `jwtClaimsProvider`) decodificando el JWT almacenado y se navega a `Routes.home` sin mostrar el flujo de login. Este comportamiento se ejecuta **en cada reapertura de la app**.

**Manejo de errores:**

- Los errores de login se muestran mediante `SnackBar` con mensaje genérico localizado.
- El flag `isLoggingIn` bloquea llamadas duplicadas al método `login()`.

**Internacionalización:** Claves l10n en `app_es.arb` / `app_en.arb`.

**⚠️ Hueco identificado:** Los accesos directos a Aviso Legal y Protección de Datos desde la pantalla principal de la landing no están confirmados en el código del router. Las rutas legales no están declaradas como hijas del `GoRoute` de `/landing`, por lo que no son accesibles para usuarios no autenticados sin navegar explícitamente.

---

### STORY-18 — Login Cl@ve, callback seguro y ciclo de vida de sesión

**Ficheros principales:**
- `lib/features/auth/3_data/auth_repository_impl.dart`
- `lib/features/landing/2_presentation/login_callback_page.dart`
- `lib/features/landing/2_presentation/landing_notifier.dart`
- `lib/core/routing/session_guard.dart`
- `lib/features/auth/0_entity/jwt_claims.dart`
- `lib/features/auth/0_entity/jwt_decoder.dart`

**Autenticación:**

- `AuthRepositoryImpl` usa `flutter_appauth` para lanzar el flujo OAuth2/OIDC completo con PKCE (`authorizeAndExchangeCode`).
- Los parámetros `discoveryUrl`, `ssoClientId` y `ssoRedirectUri` se leen de `AppConfig` (tipado, por entorno: development / preproduction / production).

**Callback Cl@ve:**

- `LoginCallbackPage` es la pantalla transitoria que gestiona el retorno del deep link de Cl@ve.
- Observa `landingProvider` mediante `ref.listen` y navega a `Routes.home` al detectar `loginSuccess: true`, o vuelve a `Routes.landing` si hay error.
- Previene doble navegación mediante el flag `_navigationScheduled`.

**Persistencia segura de tokens:**

- El `LandingNotifier` persiste en `SecureStorage` (cifrado, basado en `flutter_secure_storage`):
  - `StorageKeys.accessToken`
  - `StorageKeys.refreshToken`
  - `StorageKeys.sessionExpiresAt` (ISO 8601)

**Renovación silenciosa de token:**

- El `SessionGuard` intercepta cada navegación a rutas protegidas.
- Si el token está expirado, llama a `AuthRepository.refreshToken()` con el `refreshToken` almacenado.
- Si el refresh tiene éxito: persiste los nuevos tokens en `SecureStorage`, actualiza `tokenResponseProvider` en memoria y permite la navegación.
- Si el refresh falla (cualquier excepción): elimina los tres registros de `SecureStorage` y redirige a `Routes.landing`.

**Decodificación JWT:**

- `JwtDecoder` es un decodificador pure Dart de Base64Url **sin verificación de firma** (la validación criptográfica se delega al OIDC provider).
- Extrae `JwtClaims` con: `sub`, `idAgente`, `displayName`, `isExpired`.

**Cierre de sesión:**

- `LogoutUseCase` contemplado y accionable desde el drawer de usuario (`user_profile` feature, widget `UserDrawerMenu`).

**Manejo de errores:**

- Los errores de `flutter_appauth` se clasifican en: `AuthException.cancelled`, `.remoteFailure`, `.unexpected`.
- La cancelación del usuario (el ciudadano cierra el navegador de Cl@ve) no se trata como error visible.

---

### STORY-19 — Aceptación inicial de condiciones de uso y protección de datos (JCCMEC-11)

**Ficheros principales:**
- `lib/features/consent/2_presentation/pages/consent_page.dart`
- `lib/features/consent/2_presentation/controllers/consent_notifier.dart`
- `lib/features/legal/2_presentation/privacy_page.dart`
- `lib/features/consent/3_data/repositories/consent_repository_impl.dart`
- `lib/features/consent/1_domain/usecases/check_consent_required_usecase.dart`
- `lib/features/consent/1_domain/usecases/accept_consent_usecase.dart`
- `lib/core/routing/session_guard.dart` (`_consentRedirect`)

**Flujo de dos pasos gestionado por `ConsentNotifier`:**

El notifier maneja 8 estados:

```
loading → step1Locked → step1Unlocked → step2 → saving → accepted
                                                        ↘ rejected
                                                        ↘ saveError
```

**Paso 1 — Información de protección de datos (`PrivacyPage`):**

- La `PrivacyPage` renderiza el texto legal de protección de datos con scroll completo.
- Un `ScrollController` monitoriza la posición. Cuando el usuario llega al final (margen de 64dp), llama a `ConsentNotifier.onScrollReachedEnd()`, lo que transiciona a `step1Unlocked`.
- El CTA "Aceptar y continuar" permanece **deshabilitado** hasta alcanzar `step1Unlocked`.
- Al aceptar, el notifier transiciona a `step2` y el router navega a `ConsentPage`.

**Paso 2 — Autorizaciones opcionales (`ConsentPage`):**

- Lista de 3 checkboxes (`Clause`) con opción "Marcar todo".
- El ícono de información (`i`) en el `AppBar` permite volver a la `PrivacyPage` sin perder el estado de los checkboxes (mediante `context.push`).
- El flag `isOnboarding` controla la visibilidad del botón de retroceso en el `AppBar`.

**Aceptación:**

- `AcceptConsentUsecase` → `ConsentRepository.markConsentAccepted()` persiste en SharedPreferences:
  - `consentAccepted_<idAgente>` = `true`
  - `consentAcceptedClauses_<idAgente>` = lista de IDs de cláusulas seleccionadas
- Tras guardar, transiciona a `accepted` y `ConsentPage` navega a `Routes.home`.

**Rechazo:**

- Disponible en paso 1 (botón `X`) y paso 2 (botón `X`).
- El estado transiciona a `rejected` y se navega a `Routes.landing`.
- **⚠️ Hueco:** No se llama a `LogoutUseCase` ni se limpian los tokens de `SecureStorage` al rechazar. El token podría quedar almacenado y la restauración biométrica podría reenganchar la sesión en el siguiente inicio (mitigado por el guard, pero es un riesgo de consistencia).

**Error de guardado:**

- Si `markConsentAccepted()` lanza excepción, transiciona a `saveError` y muestra un `SnackBar` localizado.
- El usuario permanece en paso 2 para reintentar.

**Persistencia por ciudadano:**

- El consentimiento está keyed por `idAgente`. Distintos ciudadanos en el mismo dispositivo tienen estados independientes en SharedPreferences.
- El `consentProvider` es un `NotifierProvider.family<ConsentNotifier, ConsentState, String>`. Un cambio de sesión (nuevo `idAgente`) crea una instancia nueva del notifier.

**Catálogo de cláusulas:**

- Las 3 cláusulas están hardcodeadas en `ConsentRepositoryImpl` con versión `'1.0'` como comentario en el código.
- No hay integración con backend para obtener cláusulas remotas.
- **⚠️ Hueco:** No existe ningún mecanismo de versionado automático. Si el texto legal cambia, los usuarios que ya aceptaron la versión anterior **no verán el nuevo texto ni se les pedirá nueva aceptación**.

**Guard de navegación (integrado en `SessionGuard`):**

- `_consentRedirect()` se ejecuta para cualquier ruta autenticada (excepto `/consent` y `/privacy`).
- Consulta `CheckConsentRequiredUsecase` → `ConsentRepository.hasAcceptedConsent(idAgente)`.
- Si el resultado es `ConsentRequired`, redirige a `Routes.legalPrivacy` (paso 1).
- Esto garantiza que **en cada nueva sesión** se valide el consentimiento antes de acceder a cualquier funcionalidad autenticada.

**Reuso desde preferencias:**

- `STORY-55` añade en `DataConsentPage` un CTA que navega a `Routes.consent` (sin modo onboarding) para revisar el texto de protección de datos.

---

### TASK-21 — Validar claims JWT, idAgente y parámetros federados

**Ficheros principales:**
- `lib/features/auth/0_entity/jwt_claims.dart`
- `lib/features/auth/0_entity/jwt_decoder.dart`
- `docs/architecture/TASK-21-jwt-claims-validation.md`

**Lo implementado:**

- **`JwtClaims`**: value class inmutable con `sub`, `idAgente`, `displayName`, `isExpired`, `validateAudience`. Usado como fuente de verdad para todo el sistema de consentimiento y hechos vitales.
- **`JwtDecoder`**: decodificador pure Dart de Base64Url. Sin verificación de firma por diseño (delegada al OIDC provider).
- **`jwtClaimsProvider`**: Riverpod notifier (`StateNotifier`) que expone `JwtClaims?` en memoria. Es la fuente de verdad para `idAgente` en toda la app.
- **Documento de arquitectura** `docs/architecture/TASK-21-jwt-claims-validation.md`: contrato de claims, estrategia de fallback para claims ausentes, checklist de validación y ADR §7.1.

**⚠️ Pendiente no cerrado:** La confirmación del nombre exacto del claim `nif`/`idAgente` en el entorno Cl@ve sandbox no estaba resuelta en el momento del cierre del ticket. Si el claim real tiene un nombre diferente al esperado, `idAgente` será `null` o cadena vacía, rompiendo el guardado de consentimiento, el onboarding de hechos vitales y las autorizaciones de datos.

---

### STORY-54 — Selección y guardado de hechos vitales

**Ficheros principales:**
- `lib/features/personalization/2_presentation/life_events_page.dart`
- `lib/features/personalization/2_presentation/life_events_notifier.dart`
- `lib/features/personalization/3_data/life_events_repository_impl.dart`
- `lib/features/personalization/3_data/onboarding_preferences_repository_impl.dart`
- `lib/features/personalization/1_domain/usecases/check_life_events_onboarding_usecase.dart`
- `lib/features/personalization/1_domain/usecases/mark_life_events_onboarding_seen_usecase.dart`
- `lib/core/routing/session_guard.dart` (`_onboardingRedirect`)

**Pantalla y modos:**

- `LifeEventsPage` es un `ConsumerStatefulWidget` con lista de checkboxes de hechos vitales, barra sticky con botones "Guardar" y "Resetear", diálogo de confirmación para el reset.
- Acepta el query param `mode=onboarding`. En modo onboarding: (1) el botón de retroceso del `AppBar` no se muestra, (2) las selecciones se limpian al cargar (`clearSelectionsOnLoad: true`), forzando una selección desde cero.

**Integración con backend (real):**

`LifeEventsRepositoryImpl` usa el cliente generado `HechosVitalesApi` (Dio) contra:

| Método | Endpoint | Propósito |
|---|---|---|
| `GET` | `/hechos-vitales/hechos/{idAgente}` | Carga las selecciones actuales del ciudadano |
| `GET` | `/hechos-vitales/hechos` | Catálogo completo de hechos vitales disponibles |
| `PATCH` | `/hechos-vitales/hechos` | Guarda la selección del ciudadano |
| `DELETE` | `/hechos-vitales/preferencias/{idAgente}` | Reset completo de preferencias |

**Gestión de estado:**

- `LifeEventsNotifier` es un `Notifier<LifeEventsState>` con un enum de 11 estados (`LifeEventsStatus`).
- Keyed por el record `(idAgente: String, clearSelectionsOnLoad: bool)`.
- Estados: `initial`, `loading`, `loaded`, `saving`, `saved`, `resetting`, `reset`, `error`, `saveError`, `resetError`, `empty`.

**Persistencia del "onboarding visto":**

- `OnboardingPreferencesRepositoryImpl` guarda en SharedPreferences:
  - Clave: `lifeEventsOnboardingSeen_<idAgente>` = `true`
- Esta marca se establece al completar el onboarding mediante `MarkLifeEventsOnboardingSeenUsecase`.
- Es la señal que usa el `SessionGuard` para determinar si redirigir o no al onboarding.

**Guard de navegación (integrado en `SessionGuard`):**

- `_onboardingRedirect()` se ejecuta **después** de `_consentRedirect()`, formando una cadena de guardas:
  ```
  SessionGuard → _consentRedirect → _onboardingRedirect → ruta destino
  ```
- Consulta `CheckLifeEventsOnboardingUsecase` → `OnboardingPreferencesRepository.hasSeenLifeEventsOnboarding(idAgente)`.
- Si `hasSeen == false` (o si la consulta falla), redirige a `Routes.lifeEventsOnboarding` (`/preferences/life-events?mode=onboarding`).

**Accesibilidad:** WCAG 2.1 AA documentado en el fichero (reglas 3.1, 3.4, 3.10, 3.11, 3.14).

---

### STORY-55 — Autorizaciones de uso de datos y revocación desde preferencias

**Ficheros principales:**
- `lib/features/personalization/2_presentation/` (DataConsentPage y notifier)
- `lib/features/personalization/3_data/` (DataConsentRepositoryImpl)

**Pantalla:**

- `DataConsentPage` con 3 `SwitchListTile` para:
  1. Autorización de consulta de datos JCCM (Bienestar social, Empleo, Educación, Salud).
  2. Autorización de consulta de datos de otras administraciones.
  3. Consentimiento para tratamiento de datos y elaboración de perfil de recomendaciones.
- Acción de guardado explícito (botón "Guardar").
- Diálogo de confirmación para "Revocar todo".
- CTA que navega a `Routes.consent` (sin modo onboarding) para revisar el texto de protección de datos aceptado inicialmente.

**Ruta:** `Routes.preferencesConsent = '/preferences/consent'` registrada en el shell autenticado.

**⚠️ Hueco crítico — Backend diferido:**

- El `DataConsentRepositoryImpl` incluye marcadores `TODO(future-sprint)` para el cableado Dio real.
- Las operaciones diferidas son:
  - `GET /hechos-vitales/clausulas/{idAgente}`
  - `PATCH /hechos-vitales/clausulas`
  - `DELETE /hechos-vitales/preferencias/{idAgente}`
- La funcionalidad está gateada por `kDataConsentLiveBackendEnabled = false`.
- **Las autorizaciones de esta pantalla no persisten en backend. Solo se guardan en memoria.**

---

### STORY-56 — Recomendaciones personalizadas con filtros y agrupación por hecho vital

**Ficheros principales:**
- `lib/features/recommendations/` (entidad, dominio, presentación, datos)

**Pantalla:**

- `RecommendationsPage` con 4 tabs: `Todos / Últimos días / Novedades / Tramitación inmediata`.
- Cards con: título, plazo, unidad responsable y hecho vital asociado.
- Paginación dual: botón "Ver más" + scroll-end listener automático.

**Endpoints definidos (no integrados aún):**
- `GET /hechos-vitales/servicios/{idAgente}`
- `GET /hechos-vitales/servicios/segmentacion/{idAgente}`

**⚠️ Hueco — Backend diferido:**

- El repositorio de recomendaciones es mock: 14 fixtures, page size 6, paginación por cursor offset.
- Gateado por `kRecommendationsLiveBackendEnabled = false`.
- **Los trámites recomendados no provienen del backend real.**

---

### STORY-57 — Onboarding y estado vacío de recomendaciones

**Ficheros principales:**
- `lib/features/recommendations/` (variantes de empty state)

**Implementado:**

- Enum `RecommendationsEmptyVariant` con 3 variantes:
  - `unconfigured` — el ciudadano no ha seleccionado hechos vitales.
  - `unauthorised` — el ciudadano no ha dado las autorizaciones necesarias.
  - `configuredButEmpty` — configuración completa pero el backend no devuelve resultados.
- Mapping puro `from(config, bucketHasItems)` sin side effects.
- `RecommendationsEmptyView`: vista completa para `unconfigured`/`unauthorised`. Para `configuredButEmpty`, se pinta por bucket con CTA "Ver todos" que anima al tab 0.
- CTA principal "Mis preferencias" navega a `Routes.preferencesConsent`.
- `ref.listen` invalida los controllers de recomendaciones cuando la configuración transiciona a `configured`.

**⚠️ Hueco — CTA "Mis hechos vitales" sin implementar:**

- El CTA secundario "Mis hechos vitales" en `RecommendationsEmptyView` muestra un `SnackBar` con mensaje "próximamente" (`recommendationsLifeEventsComingSoon`).
- **No navega a `Routes.lifeEvents`**. Existe un `TODO` abierto en el código.

---

### STORY-61 — Páginas legales estáticas

**Ficheros principales:**
- `lib/features/legal/2_presentation/privacy_page.dart`
- `lib/features/legal/2_presentation/` (LegalDocumentPage y documentos)

**Documentos empaquetados localmente (100% offline):**

| Documento | Ruta |
|---|---|
| Condiciones de uso | `Routes.legalTerms` |
| Protección de datos | `Routes.legalPrivacy` (también actúa como paso 1 del consentimiento) |
| Accesibilidad | `Routes.legalAccessibility` |
| Aviso legal | `Routes.legalNotice` |

**`PrivacyPage` — doble rol:**

- Es la página de información de protección de datos consultable desde cualquier punto de la app.
- **También actúa como paso 1 del flujo de consentimiento**: contiene el `ScrollController` que notifica al `ConsentNotifier` cuando el usuario llega al final, y muestra el botón "Aceptar y continuar" condicionado al estado `step1Unlocked`.

**Renderizado:**

- `LegalDocumentPage`: renderizador mini-Markdown (párrafos + bullets) sin dependencias externas nuevas. Scroll completo y soporte de enlaces externos.

**Privacidad — contenido compartido:**

- El contenido del documento de protección de datos es el mismo texto que aparece en el flujo de consentimiento (RGPD/LOPDGDD), garantizando coherencia entre onboarding y página legal estática.

**Acceso desde footer autenticado:**

- El footer en `AppScaffold` (dentro del `ShellRoute` autenticado) incluye enlaces a Help, Sitemap y las 4 páginas legales, todos envueltos en `Semantics(button: true, label: ...)`.

**⚠️ Hueco — Acceso desde zona no autenticada:**

- El footer con accesos legales solo es visible para el usuario autenticado (está dentro del `ShellRoute`).
- Las rutas legales no están registradas como hijas del `GoRoute` de `/landing` en el router.
- **Los usuarios no autenticados no pueden acceder a las páginas legales** desde la landing (a menos que exista navegación desde `LandingHelpPage` o `LandingAboutPage`, no confirmada en el código revisado).

---

## 4. Huecos y requisitos pendientes identificados

| # | Área | Ticket relacionado | Descripción | Impacto |
|---|---|---|---|---|
| 1 | Consentimiento — versionado | STORY-19 | No existe lógica que detecte cambios en el texto legal y fuerce re-consent. La versión `'1.0'` es solo un comentario en el código, sin comparación con el valor almacenado en SharedPreferences. | Si el texto legal cambia, los usuarios que ya aceptaron no ven el nuevo texto ni se les pide nueva aceptación. **Riesgo legal.** |
| 2 | Rechazo — limpieza de sesión | STORY-19 | Al rechazar el consentimiento, no se llama a `LogoutUseCase` ni se limpian los tokens de `SecureStorage`. | La restauración biométrica en el siguiente inicio podría reenganchar la sesión sin pasar por consentimiento (el guard lo mitiga, pero la sesión queda "sucia"). |
| 3 | Autorizaciones de datos — backend | STORY-55 | `DataConsentRepositoryImpl` no persiste en backend. Gateado por `kDataConsentLiveBackendEnabled = false`. | Las autorizaciones para datos JCCM, otras administraciones y perfilado de recomendaciones no se envían al servidor. La personalización real depende de esto. |
| 4 | Recomendaciones — backend | STORY-56 | Repositorio mock gateado por `kRecommendationsLiveBackendEnabled = false`. | Los trámites recomendados no provienen del backend real. La funcionalidad de recomendaciones es demostrativa únicamente. |
| 5 | CTA "Mis hechos vitales" desde estado vacío | STORY-57 | El botón secundario en `RecommendationsEmptyView` muestra un `SnackBar` de "próximamente" en vez de navegar a `Routes.lifeEvents`. Existe un `TODO` abierto en el código. | El usuario no puede acceder directamente a la configuración de hechos vitales desde el estado vacío de recomendaciones. |
| 6 | Páginas legales desde landing no autenticada | STORY-17 / STORY-61 | Las rutas legales no son hijas del `GoRoute` de `/landing`. El footer con accesos legales solo aparece en el shell autenticado. | Los usuarios no autenticados no pueden acceder a páginas legales desde la landing. Posible incumplimiento del requisito legal de accesibilidad pública. |
| 7 | Home logada (STORY-22) | STORY-22 | `Routes.home` redirige a `Routes.sitemap` (safety redirect). La `LoggedHomePage` real con bloques temáticos nunca llegó a `develop`. | Tras completar el onboarding, el usuario llega al sitemap en vez de a la home real. Afecta a la navegación post-consentimiento y post-onboarding de hechos vitales. |
| 8 | Claim `idAgente` — confirmación pendiente | TASK-21 | El nombre exacto del claim JWT para `idAgente` en Cl@ve sandbox no estaba confirmado al cerrar el ticket. | Si el claim real tiene un nombre diferente, `idAgente` será `null`, rompiendo el guardado de consentimiento, el onboarding de hechos vitales y las autorizaciones. **Bloquea los flujos de esta área en producción.** |

---

## 5. Resumen de dependencias entre componentes

```
SecureStorage (flutter_secure_storage)
  ├─ accessToken / refreshToken / sessionExpiresAt
  └─ leído por: SessionGuard, LandingNotifier (restauración biométrica)

SharedPreferences (via AppStorage)
  ├─ consentAccepted_<idAgente>            → leído por: CheckConsentRequiredUsecase
  ├─ consentAcceptedClauses_<idAgente>     → escrito por: AcceptConsentUsecase
  └─ lifeEventsOnboardingSeen_<idAgente>   → leído por: CheckLifeEventsOnboardingUsecase

En memoria (Riverpod)
  ├─ tokenResponseProvider                 → TokenResponse con expiry
  ├─ jwtClaimsProvider                     → JwtClaims (idAgente, displayName, sub)
  ├─ consentProvider(idAgente)             → ConsentNotifier (estado del flujo de 2 pasos)
  └─ lifeEventsProvider((idAgente, ...))   → LifeEventsNotifier (estado de selección)

Backend (HechosVitalesApi — Dio)
  ├─ GET  /hechos-vitales/hechos/{idAgente}           ← LifeEventsRepositoryImpl ✅
  ├─ GET  /hechos-vitales/hechos                      ← LifeEventsRepositoryImpl ✅
  ├─ PATCH /hechos-vitales/hechos                     ← LifeEventsRepositoryImpl ✅
  ├─ DELETE /hechos-vitales/preferencias/{idAgente}   ← LifeEventsRepositoryImpl ✅
  ├─ GET  /hechos-vitales/clausulas/{idAgente}        ← DataConsentRepositoryImpl ⚠️ DIFERIDO
  ├─ PATCH /hechos-vitales/clausulas                  ← DataConsentRepositoryImpl ⚠️ DIFERIDO
  └─ GET  /hechos-vitales/servicios/{idAgente}        ← RecommendationsRepository ⚠️ MOCK
```

---

*Documento generado a partir de la revisión de `/tickets/` y `/lib/features/` el 4 de junio de 2026. No se han incluido funcionalidades, requisitos ni comportamientos no verificados en el código fuente.*
