# Aviso de actualización de la app (JCCMEC-63)

**Estado:** implementado contra el servidor de versiones (pendiente de que back lo publique) · **Feature:** `lib/features/app_update/` · **Fases:** mock 05/10/2026 → tiendas 06/10/2026 → servidor propio 14/10/2026

## Qué hace

Al arrancar y cada vez que la app vuelve de segundo plano, pregunta al servidor de versiones qué hacer con la versión instalada y, si procede, muestra un aviso a pantalla completa por encima del router:

| Respuesta (`accion`) | Aviso | Se puede cerrar |
|---|---|---|
| `FORZADA` | «Actualización necesaria» | No: ni botón, ni atrás, ni tocar debajo |
| `RECOMENDADA` | «Hay una nueva versión disponible» | Sí («Ahora no» o atrás); esa versión no vuelve a avisar |
| `NINGUNA` | Nada | — |

El aviso enseña la `versionPublicada`; si el servidor manda `mensaje`, ese texto sustituye la explicación por defecto (el título sigue siendo el de la app).

«Actualizar» abre la ficha de la app en la tienda; el aviso no se cierra porque el sistema reinicia la app tras instalar. Si la tienda no se abre, el aviso enseña un error y se puede reintentar.

## El servidor de versiones

Decisión del 14/10/2026: **decide el back**, no la app ni las tiendas. Así se puede forzar o recomendar una versión concreta sin publicar nada. El transporte de tiendas (iTunes Lookup en iOS, `in_app_update` en Android) se eliminó: iOS no podía forzar nunca y Android solo veía el `versionCode`.

Contrato: **`documentation/api/app-version-api.yaml`** (OpenAPI 3.0.1), el documento que se entrega a back.

```
GET {BASE_URL}/api/v1/app-movil/actualizacion?plataforma=ANDROID&idAplicacion=es.jccm.espaciociudadano&version=0.1.9

200 { "body": { "accion": "RECOMENDADA", "versionPublicada": "0.2.0", "mensaje": null }, ... }
```

- **Versión:** solo la de marketing `x.y.z` (`PackageInfo.version`), en las dos plataformas. El build no viaja: requisito de publicación, **cada subida a tienda sube la `x.y.z`**.
- **Host:** hoy `AppConfig.baseUrl` (el mismo gateway que el resto de APIs). Punto abierto con back.
- **Autenticación:** ninguna; la consulta se hace antes del login con Cl@ve. Dio propio (`AppVersionApi.standalone`) sin el interceptor de autenticación (que podría refrescar o cerrar sesión ante un 401) ni el de errores. Punto abierto con back si quieren protegerlo.
- **Plazo:** 5 s.

Capas: `AppVersionApi` (Dio) → `AppUpdateDecisionDto` (sobre `Respuesta` + `body`, valida forma) → `AppUpdateDecisionMapper` (valida significado) → `AppUpdateDecision` → `CheckAppUpdateUsecase`.

## La URL de la tienda

No viene del servidor: la construye `appStorePageUrl` (`3_data/url_launcher_app_store_launcher.dart`).

| | URL |
|---|---|
| Android | `https://play.google.com/store/apps/details?id=<packageName>` |
| iOS | `https://apps.apple.com/es/app/id<APP_STORE_ID>` |

`APP_STORE_ID` es la clave obligatoria de los `config_*.json` con el Apple ID de la app en App Store Connect (`6795089236`); no se puede deducir del bundle id.

## Decisiones

- **Fail-open.** Si el servidor no contesta, contesta un error, contesta fuera de contrato (acción desconocida, versión mal formada) o contesta algo **incoherente** (forzada/recomendada sin `versionPublicada` o con una versión no mayor que la instalada), no se bloquea a nadie: una línea `[app_update] comprobación no disponible` y el estado no cambia (una forzada ya visible se queda).
- **La recomendada ignorada se recuerda por versión y por fuente** (`StorageKeys.appUpdateIgnoredVersionPrefix` + `api` | `mock`, por dispositivo). Una versión posterior vuelve a avisar; la forzada avisa siempre. Haber descartado la `99.0.0` del mock en un móvil de pruebas no silencia la real.
- **Overlay en `MaterialApp.router(builder:)`, no `showDialog`.** Un diálogo sobre el navigator desaparece cuando el router sustituye la página (`router.go`, redirects del guard); una forzada no puede desaparecer. Mientras hay aviso, lo de debajo queda sin toques, foco ni lector de pantalla.
- **Atrás en Android** se intercepta con `WidgetsBindingObserver.didPopRoute` en el gate. Si algún día se activa el predictive back (`enableOnBackInvokedCallback`), el gate deberá además emitir `NavigationNotification(canHandlePop: true)` mientras esté visible.
- **Sin caché ni reintentos**: cada vuelta de segundo plano vuelve a preguntar, para que un forzado surta efecto enseguida.
- **Observabilidad:** líneas `logger` con prefijo `[app_update]` (aviso mostrado, descartado, tienda abierta, fallos). Nunca la URL completa.

## Fuente de datos y cómo probar

La clave `APP_UPDATE_SOURCE` (en los tres `config_*.json`, valor `api`) elige la fuente; una errata cae en `api`:

| Valor | Qué hace |
|---|---|
| `api` (por defecto) | Servidor de versiones |
| `mock-forced` | Respuesta fija `FORZADA` a la `99.0.0` |
| `mock-recommended` | Respuesta fija `RECOMENDADA` a la `99.0.0` |
| `mock-none` | Respuesta fija `NINGUNA` |

```bash
flutter run --dart-define-from-file=config_development.json --dart-define=APP_UPDATE_SOURCE=mock-forced
```

Los mocks (`AppUpdateMockScenario`) son respuestas JSON con el contrato real y pasan por el mismo DTO y mapper que la del servidor. Mientras back no publique el endpoint, con `api` la consola muestra la petición a `/api/v1/app-movil/actualizacion` seguida de `[app_update] comprobación no disponible: …` y ninguna UI.

## Evolución posible

- `InAppUpdate.performImmediateUpdate()` / flujo flexible de Play para actualizar sin salir de la app (volvería a necesitar `in_app_update` y un puerto de dominio nuevo).
