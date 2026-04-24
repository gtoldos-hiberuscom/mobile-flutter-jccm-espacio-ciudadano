---
id: 42
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 5
reporter:
assignee:
story_points:
labels:
  - notificaciones
  - contacto
  - onboarding
  - formulario
  - api-contract
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-24T13:55:20+02:00
due_date:
jira_url:
---
# [STORY-42] Alta de datos de contacto para plataforma de notificación electrónica
## Functional Description
Cubrir el flujo previo de registro de teléfono móvil y correo electrónico necesario para operar con notificaciones electrónicas, aclarando además las dependencias de backend cuando el contrato no esté confirmado.

## Acceptance Criteria
- [x] Se contempla formulario con teléfono móvil y correo electrónico, exigiendo al menos uno.
- [x] Se contempla copy explicativa sobre el uso futuro de esos datos.
- [x] Se contempla estado de éxito o alta completada y retorno al centro de notificaciones.
- [x] Se explicitan dependencias de backend si no existe contrato confirmado en la API actual.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-41]
    - [TASK-47]
  - Blocks:
    - [STORY-43]
  - Related to:
    - [EPIC-6]
- Flow slices:
  - Formulario de alta con exigencia de al menos un canal de contacto.
  - Copy explicativa sobre uso futuro de móvil y correo.
  - Éxito de alta y retorno al centro de notificaciones.
  - Backlog condicionado por confirmación del backend real en [TASK-47].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Notificaciones - Alta.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N5
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 5
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-41] y [TASK-47].
  - Blocks [STORY-43].
  - Depende de validar si existe contrato backend real para el alta de contacto.

## Notes
### Comments
- Implementación entregada: formulario con campos de teléfono (con hint de prefijo `+34 `) y correo electrónico construido bajo `lib/features/notifications/contact/2_presentation/`; validador de dominio que cubre los modos de fallo `phone`, `email` y `bothEmpty`; repositorio mock (`NotificationContactRepositoryImpl`) con latencia simulada de 300 ms que persiste el contacto en memoria (cableado al backend real diferido según TASK-47 y gateado por `kNotificationContactLiveBackendEnabled = false`); `NotificationContactGateBanner` embebido en la cabecera del body de `notifications_center_page.dart` y visible únicamente cuando falta el contacto; ruta `Routes.notificationContactRegistration = '/notifications/contact/registration'` registrada en el shell autenticado; claves de localización (ES + EN) con prefijo `notificationContact*` regeneradas mediante `flutter gen-l10n`; añadidos 7 tests nuevos bajo `test/features/notifications/contact/` y la suite completa pasa (188 tests).
- Backend diferido: el cableado real con Dio queda aparcado hasta que el backend confirme el contrato para el alta de contacto del ciudadano; se trazará como follow-up de Sprint 6 reservado en un ticket independiente.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T13:55:20+02:00 | by Copilot | STORY-42 implemented (mock backend + gate banner) — status set to Done.
