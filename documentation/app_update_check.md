# Aviso de actualización de la app (JCCMEC-63)

**Estado:** implementado con transporte mock · **Feature:** `lib/features/app_update/` · **Fecha:** 05/10/2026

## Qué hace

Al arrancar y cada vez que la app vuelve de segundo plano, consulta qué versión está publicada y, si procede, muestra un aviso a pantalla completa por encima del router:

| Situación | Aviso | Se puede cerrar |
|---|---|---|
| instalada `< minVersion` | **Forzada**: «Actualización necesaria» | No: ni botón, ni atrás, ni tocar debajo |
| `minVersion <= instalada < latestVersion` | La `policy` del manifiesto (`recommended` → «Hay una nueva versión disponible»; `none` → nada) | Sí («Ahora no» o atrás) |
| instalada `>= latestVersion` | Nada | — |

«Actualizar» abre la ficha de la app en la tienda; el aviso no se cierra porque el sistema reinicia la app tras instalar. Si la tienda no se abre, el aviso enseña un error y se puede reintentar.

## Contrato del manifiesto remoto

```json
{
  "android": { "latestVersion": "1.2.0", "minVersion": "1.0.0", "policy": "recommended", "storeUrl": "https://play.google.com/store/apps/details?id=es.jccm.espaciociudadano" },
  "ios":     { "latestVersion": "1.2.0", "minVersion": "1.0.0", "policy": "recommended", "storeUrl": "https://apps.apple.com/es/app/id<APPLE_ID>" }
}
```

- Versiones `x.y.z` (el `+build` se ignora). `policy` ∈ `none | recommended | forced`.
- `storeUrl` debe ser `https` y su host estar en `appStoreAllowedHosts` (`play.google.com`, `apps.apple.com`, `itunes.apple.com`). Cualquier otra cosa invalida el manifiesto.
- Claves desconocidas en la raíz se ignoran; una plataforma ausente solo falla si es la que corre.
- **Pendiente del cliente:** el id numérico de App Store Connect para el `storeUrl` de iOS.

## Decisiones

- **Fail-open.** Si el manifiesto no llega o no valida, no se bloquea a nadie: se registra `[app_update] comprobación no disponible` y el estado no cambia (una forzada ya visible se queda).
- **La recomendada ignorada se recuerda por versión** (`StorageKeys.appUpdateIgnoredVersion`, por dispositivo). Una versión posterior vuelve a avisar; la forzada avisa siempre.
- **Overlay en `MaterialApp.router(builder:)`, no `showDialog`.** Un diálogo sobre el navigator desaparece cuando el router sustituye la página (`router.go`, redirects del guard); una forzada no puede desaparecer. Mientras hay aviso, lo de debajo queda sin toques, foco ni lector de pantalla.
- **Atrás en Android** se intercepta con `WidgetsBindingObserver.didPopRoute` en el gate (no hay `ModalRoute` por encima del router para un `PopScope`). Si algún día se activa el predictive back (`enableOnBackInvokedCallback`), el gate deberá además emitir `NavigationNotification(canHandlePop: true)` mientras esté visible.
- **Observabilidad:** líneas `logger` con prefijo `[app_update]` (aviso mostrado, descartado, tienda abierta, fallos). Nunca la URL completa, solo el host.

## Transporte: hoy mock, mañana real

La tecnología (API, string remoto, Firebase Remote Config…) no está decidida. Hoy `StaticAppUpdateRepositoryImpl` sirve un JSON fijado en código que pasa por el mismo DTO + mapper que usará el transporte definitivo. Cuando se decida, **solo cambia `appUpdateRepositoryProvider`** (`2_presentation/providers/app_update_repository_providers.dart`) y se retiran `AppUpdateMockScenario` y la clave `APP_UPDATE_MOCK`.

### Probar los tres escenarios

La clave `APP_UPDATE_MOCK` (`forced` | `recommended` | `none`, por defecto `none`) elige el manifiesto mock. Está en los tres `config_*.json` a `none`; para probar:

```bash
flutter run --dart-define-from-file=config_development.json --dart-define=APP_UPDATE_MOCK=forced
```

o cambiar el valor en `config_development.json` sin commitearlo. Los manifiestos mock usan `0.0.1` y `99.0.0` para que el escenario no dependa de la versión instalada.
