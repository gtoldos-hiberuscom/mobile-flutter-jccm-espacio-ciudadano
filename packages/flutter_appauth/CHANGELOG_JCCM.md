# Changelog del fork JCCM (vendorizado)

Fork mínimo de `flutter_appauth` vendorizado en este repo. Base upstream sin
tocar salvo lo listado aquí. Contexto, diseño y evidencia:
`docs/auth/clave_android_session_investigation.md`,
`docs/auth/flutter_appauth_android_ephemeral_design.md`,
`docs/auth/flutter_appauth_android_ephemeral_poc_results.md`.

## 12.0.0+jccm.1 — 2026-08-31

- Base: `flutter_appauth 12.0.0` publicado en pub.dev (código Android
  byte-idéntico al de la 12.1.0; delta iOS/macOS/Dart: CERO ficheros tocados).
- `android/build.gradle`: `compileSdkVersion 35 → 36` y nueva dependencia
  `androidx.browser:browser:1.10.0` (APIs de Ephemeral Custom Tabs, estables
  desde 1.9.0; requieren compileSdk 36 y AGP ≥ 8.9.1 en el host).
- `android/.../FlutterAppauthPlugin.java`:
  - Lee la clave `externalUserAgent` que el platform interface ya envía por el
    MethodChannel (índice del enum Dart `ExternalUserAgent`); el plugin de serie
    la ignora en Android.
  - Índice 1 (`ephemeralAsWebAuthenticationSession`) ⇒ el authorize y el
    endSession se lanzan en una **Ephemeral Custom Tab**: detección de soporte
    (`AuthorizationService.getBrowserDescriptor()` +
    `CustomTabsClient.isEphemeralBrowsingSupported`) y
    `createCustomTabsIntentBuilder(uri).setEphemeralBrowsingEnabled(true)`
    pasado a los overloads públicos de AppAuth 0.11.1
    `getAuthorizationRequestIntent(request, cti)` /
    `getEndSessionRequestIntent(request, cti)`. AppAuth-Android NO se forkea.
  - Si se pide efímero y el navegador no lo soporta (sin categoría
    `EphemeralBrowsing`, sin navegador CCT, o navegador standalone) ⇒ error
    tipado `ephemeral_browsing_unavailable`. **Nunca** fallback silencioso: la
    política de degradación vive en la capa Dart de la app.
  - Nuevo método de canal `isEphemeralBrowsingAvailable` (sonda de capacidad,
    síncrona, sin datos sensibles).
  - Log diagnóstico tag `FlutterAppauthEphemeral` (navegador, versión, soporte;
    sin URIs ni tokens).

### Invariante que protege el CI de la app

El fork asume `ExternalUserAgent.ephemeralAsWebAuthenticationSession.index == 1`
en `flutter_appauth_platform_interface` (por eso la app lo pinea EXACTO y
`test/features/auth/external_user_agent_contract_test.dart` fija el índice).

### Cómo actualizar la base upstream

1. Copiar el paquete nuevo de pub-cache encima (sin `example/`).
2. Re-aplicar `docs/auth/poc_evidence/fork_ephemeral.diff` (`patch -p2`) y
   renombrar `POC_LOG_TAG` → `EPHEMERAL_LOG_TAG`.
3. Revisar el enum `ExternalUserAgent` del platform interface nuevo (el test de
   contrato falla si cambia el índice) y actualizar el pin exacto en el pubspec
   de la app.
4. Actualizar esta entrada y la versión (`X.Y.Z+jccm.N`).
