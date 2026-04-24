---
id: 60
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 4
reporter:
assignee:
story_points:
labels:
  - soporte
  - formulario
  - adjuntos
  - captcha
  - privacidad
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-24T10:48:01+02:00
due_date:
jira_url:
---
# [STORY-60] Formulario de soporte técnico con adjuntos, consentimiento y captcha
## Functional Description
Cubrir la experiencia de soporte técnico observada en diseño para incidencias de la plataforma, incluyendo el formulario, sus validaciones, adjuntos, consentimiento de uso de datos, protección antibot y la confirmación posterior por correo.

## Acceptance Criteria
- [x] Se contempla formulario con nombre, email, confirmación de email, asunto y descripción.
- [x] Se contemplan validaciones de obligatorio, límite de 100 caracteres para asunto y contador/límite para descripción.
- [x] Se contempla adjunto opcional, checkbox de autorización de uso de datos y captcha/antibot.
- [x] Se contempla confirmación de envío y comunicación posterior por correo.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-59]
    - [TASK-63]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-9]
- Support form scope:
  - Campos identificativos y de contacto con doble validación de email.
  - Asunto con límite de 100 caracteres y descripción con contador/límite visible.
  - Adjuntos opcionales y aceptación explícita del tratamiento de datos.
  - Mecanismo captcha/antibot y mensaje de confirmación de envío.
- Open integration points:
  - Backend/canal operativo, gestión de adjuntos y confirmación real quedan condicionados por [TASK-63].
  - Debe alinearse con el contexto y acceso definido en [STORY-59].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Ayuda - Soporte.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 11
  - image_references/Servicios - Mapa web.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-9]
- Dependency map:
  - Blocked by [STORY-59] y [TASK-63].
  - Sin descendientes explícitos en este corte.
  - Depende de cerrar la integración operativa del soporte antes de implementación funcional.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T10:48:01+02:00 | by Copilot | To Do → In Progress (Sprint 4 — implementación del formulario de soporte).
- 2026-04-24T10:48:01+02:00 | by Copilot | In Progress → Done. Implementado `lib/features/help/` con 0_entity (`SupportRequest`, `PickedAttachment`, `SupportFormState`, `SupportValidationError`), 1_domain (`SupportRepository`, `AttachmentPicker`, `SupportFormValidator`, `SupportFormNotifier`), 3_data (`SupportRepositoryImpl` mock + `StubAttachmentPicker`) y 2_presentation (`SupportFormPage` con `Form`/`TextFormField`s, `widgets/captcha_placeholder.dart`, `widgets/attachment_picker_field.dart`, `widgets/character_counter.dart`). Ruta `/help/support` registrada en `lib/app/routing/app_router.dart` y enlazada desde el centro de ayuda. ARB `support*` en es/en. `flutter analyze lib/features/help/ test/features/help/` → 0 issues; `flutter test test/features/help/` → 20 tests passed (validador, notifier, widget). Backend real diferido a [TASK-63] (`SupportRepositoryImpl` mock con 500 ms y `// TODO(TASK-63)` explícito); captcha real diferido a [TASK-63] (mock `CaptchaPlaceholder` con badge "MOCK" y `// TODO(TASK-63)`); selector real de adjuntos diferido a [TASK-63] (`StubAttachmentPicker` sin nuevas dependencias).
