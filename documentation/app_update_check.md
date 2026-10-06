# Aviso de actualización de la app (JCCMEC-63)

**Estado:** implementado con transporte real de tienda (App Store / Google Play) · **Feature:** `lib/features/app_update/` · **Fases:** mock 05/10/2026 → tiendas 06/10/2026

## Qué hace

Al arrancar y cada vez que la app vuelve de segundo plano, pregunta a la tienda de la plataforma qué versión está publicada y, si procede, muestra un aviso a pantalla completa por encima del router:

| Situación | Aviso | Se puede cerrar |
|---|---|---|
| instalada `< minVersion` | **Forzada**: «Actualización necesaria» | No: ni botón, ni atrás, ni tocar debajo |
| `minVersion <= instalada < latestVersion` | **Recomendada**: «Hay una nueva versión disponible» | Sí («Ahora no» o atrás); esa versión no vuelve a avisar |
| instalada `>= latestVersion` | Nada | — |

«Actualizar» abre la ficha de la app en la tienda; el aviso no se cierra porque el sistema reinicia la app tras instalar. Si la tienda no se abre, el aviso enseña un error y se puede reintentar.

## De dónde sale la versión publicada

Decisión del 06/10/2026: directamente de las tiendas, sin manifiesto propio y **sin etiquetas en la descripción de la ficha**.

| | iOS (App Store) | Android (Google Play) |
|---|---|---|
| Fuente | Búsqueda de iTunes: `GET https://itunes.apple.com/lookup?bundleId=<bundleId>&country=es` (pública, sin autenticación) | API oficial de actualizaciones in-app (plugin `in_app_update` 5.0.0) |
| Espacio de versión | Versión de marketing `x.y.z` (`CFBundleShortVersionString`) | **Solo `versionCode`**: instalada y publicada se comparan como `0.0.N` |
| `latestVersion` | `results[0].version` | `0.0.availableVersionCode` si `updateAvailability == updateAvailable`; si no, la instalada |
| `minVersion` | **Siempre `0.0.0`: App Store nunca fuerza** | `latestVersion` si la release se publicó con `updatePriority >= 4`; si no, `0.0.0` |
| `storeUrl` | `trackViewUrl` (debe ser `https` y host de la lista blanca) | `https://play.google.com/store/apps/details?id=<applicationId>` |
| Número en el aviso | Sí («la versión 0.1.9») | **No**: el ciudadano no debe ver «versión 12» |
| Id de aplicación | `PackageInfo.packageName` | `PackageInfo.packageName` |

Implementaciones en `3_data/`: `ItunesAppUpdateRepositoryImpl` (api + DTO + mapper propios; Dio sin interceptores de auth, 5 s de plazo, cuerpo en crudo porque iTunes responde `text/javascript`) y `PlayAppUpdateRepositoryImpl` (envoltorio del plugin importado con prefijo porque su `AppUpdateInfo` colisiona con la entidad; plazo de 5 s). La selección por plataforma vive en `buildAppUpdateRepository` (`2_presentation/providers/app_update_repository_providers.dart`).

## Limitaciones que hay que conocer

- **La app no está publicada en ninguna tienda** (06/10/2026): iTunes devuelve `resultCount: 0` y la ficha de Play da 404. El transporte real no se puede ver funcionando hasta publicar; mientras tanto, `APP_UPDATE_SOURCE=mock-*`.
- **iOS nunca fuerza.** Sin etiqueta en la ficha no hay fuente de «versión mínima». Si algún día hace falta, habrá que añadir una fuente propia.
- **Android fuerza solo con prioridad in-app ≥ 4**, que se fija al publicar con la Google Play Developer API (`inAppUpdatePriority`); la consola web no lo permite.
- **Android no tiene nombre de versión.** Play no tiene API de consulta y rascar la ficha web es inviable: comprobado el 06/10 con Telegram (tres versiones distintas según idioma, todas de reseñas), Spotify, Google Translate e Instagram (la ruta `ds:5[1][2][140]` que leía `google-play-scraper` ya viene vacía; la versión se carga bajo demanda por una RPC interna).
- **Play solo contesta a apps instaladas desde Play** (incluidas las pistas de pruebas) con firma de Play. Emulador sin Play, APK instalado a mano o iOS → `PlatformException` → fail-open.
- **iTunes va por CDN**: una versión recién publicada puede tardar horas en aparecer.

## Decisiones

- **Fail-open.** Si la tienda no contesta, contesta mal o no conoce la app, no se bloquea a nadie: una línea `[app_update] comprobación no disponible` y el estado no cambia (una forzada ya visible se queda).
- **La recomendada ignorada se recuerda por versión y por fuente** (`StorageKeys.appUpdateIgnoredVersionPrefix` + `store` | `mock`, por dispositivo). Una versión posterior vuelve a avisar; la forzada avisa siempre. Haber descartado la `99.0.0` del mock en un móvil de pruebas no silencia la real.
- **Overlay en `MaterialApp.router(builder:)`, no `showDialog`.** Un diálogo sobre el navigator desaparece cuando el router sustituye la página (`router.go`, redirects del guard); una forzada no puede desaparecer. Mientras hay aviso, lo de debajo queda sin toques, foco ni lector de pantalla.
- **Atrás en Android** se intercepta con `WidgetsBindingObserver.didPopRoute` en el gate. Si algún día se activa el predictive back (`enableOnBackInvokedCallback`), el gate deberá además emitir `NavigationNotification(canHandlePop: true)` mientras esté visible.
- **Lista blanca de tiendas** (`appStoreAllowedHosts`): la URL de la ficha debe ser `https` y de `play.google.com`, `apps.apple.com` o `itunes.apple.com`, venga de donde venga.
- **Sin caché ni reintentos** del manifiesto: cada vuelta de segundo plano vuelve a preguntar.
- **Observabilidad:** líneas `logger` con prefijo `[app_update]` (aviso mostrado, descartado, tienda abierta, fallos). Nunca la URL completa, solo el host.

## Fuente de datos y cómo probar

La clave `APP_UPDATE_SOURCE` (en los tres `config_*.json`, valor `store`) elige la fuente; una errata cae en `store`:

| Valor | Qué hace |
|---|---|
| `store` (por defecto) | Tienda de la plataforma |
| `mock-forced` | Manifiesto fijo que fuerza (mínima `99.0.0`) |
| `mock-recommended` | Manifiesto fijo que recomienda la `99.0.0` |
| `mock-none` | Manifiesto fijo sin nada que avisar |

```bash
flutter run --dart-define-from-file=config_development.json --dart-define=APP_UPDATE_SOURCE=mock-forced
```

Los manifiestos mock (`AppUpdateMockScenario`) usan `0.0.1` y `99.0.0` para que el escenario no dependa de la versión instalada, también en espacio `versionCode`. Su formato:

```json
{
  "android": { "latestVersion": "99.0.0", "minVersion": "0.0.1", "policy": "recommended", "storeUrl": "https://play.google.com/store/apps/details?id=es.jccm.espaciociudadano" },
  "ios":     { "latestVersion": "99.0.0", "minVersion": "0.0.1", "policy": "recommended", "storeUrl": "https://apps.apple.com/es/app/id0000000000" }
}
```

Humo real contra iTunes (red, opt-in, con una app publicada): `flutter test --tags backend --run-skipped test/features/app_update/itunes_live_lookup_test.dart`. Con `store` en simulador iOS la consola debe mostrar la petición a `itunes.apple.com/lookup` seguida de `[app_update] comprobación no disponible: FormatException: App Store lookup returned no results…` y ninguna UI mientras la app no esté publicada.

## Evolución posible

- `InAppUpdate.performImmediateUpdate()` / flujo flexible de Play para actualizar sin salir de la app (necesitaría un puerto de dominio nuevo).
- `clientVersionStalenessDays` de Play para escalar una recomendada a forzada tras N días.
