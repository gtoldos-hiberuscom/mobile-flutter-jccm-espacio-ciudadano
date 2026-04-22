---
id: 64
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
reporter:
assignee:
story_points:
labels:
  - observabilidad
  - analytics
  - logging
  - pii
  - monitoring
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T00:42:50Z
due_date:
jira_url:
---
# [STORY-64] Observabilidad, analytics y logging con redacción de PII
## Functional Description
Definir la base de analítica, trazas y monitoring sin exponer datos sensibles del ciudadano, contemplando eventos clave de navegación, errores relevantes, descargas y enlaces externos, junto con una política explícita de redacción de PII.

## Acceptance Criteria
- [x] Se contempla logging estructurado y redactado.
- [x] Se contemplan eventos/telemetría para navegación principal, descargas, enlaces externos y errores relevantes.
- [x] Se contempla monitoring/crash reporting sin fuga de PII.
- [x] Se contempla preparación operativa para evolución futura, incluidas capacidades de notificación/push cuando proceda.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
    - [STORY-14]
    - [TASK-69]
  - Blocks:
    - [STORY-67]
    - [STORY-68]
  - Related to:
    - [EPIC-10]
- Observability scope:
  - Logging estructurado con redacción de identificadores o datos sensibles.
  - Telemetría de navegación principal, descargas, errores y enlaces externos.
  - Crash reporting/monitoring con exclusión de PII.
  - Preparación de eventos reutilizables para evolución operativa futura.
- Security considerations:
  - La política de PII y hardening se alinea con [TASK-69].
  - Debe evitarse fuga de datos en eventos, breadcrumbs o payloads de error.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §§24 y 26
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 13
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N3
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-12], [STORY-14] y [TASK-69].
  - Blocks [STORY-67] y [STORY-68].
  - Aporta la base de observabilidad transversal del epic [EPIC-10].

## Notes
### Comments
- 2026-04-22T00:42:50Z | by Copilot | Implementation complete. Commit `9ba4b8d` (`feat(quality-security): [EPIC-10/STORY-64/implement-logging-analytics] structured PII-redacted logging, typed analytics event system and navigation observer`) on branch `task/EPIC-10-quality-security/STORY-64-observability/implement-logging-analytics` delivers:
  - **Logging**: `LogLevel` enum, `AppLogger` abstract interface, `ConsoleLogger` with PII-key redaction (`token`, `id`, `name`, `dni`, `nss`, `plate`, `license`, `matricula` → `[REDACTED]`), `kReleaseMode`-aware no-op, and `appLoggerProvider` (`@Riverpod(keepAlive:true)`).
  - **Analytics**: `sealed` event hierarchy (`PageViewEvent`, `DownloadEvent`, `ExternalLinkEvent`, `AppErrorEvent`), `AnalyticsService` abstract interface, `ConsoleAnalyticsService` (full no-op in release), and `analyticsServiceProvider` (`@Riverpod(keepAlive:true)`).
  - **Routing integration**: `AnalyticsObserver` (`NavigatorObserver` → `AnalyticsService` bridge) registered in `app_router.dart` alongside `AppLifecycleObserver`.
  - `dart analyze lib/` passes with zero issues.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T00:42:50Z | by Copilot | Status transitioned `To Do` → `Done`. All acceptance criteria marked checked. Implementation evidence recorded (commit `9ba4b8d`, branch `task/EPIC-10-quality-security/STORY-64-observability/implement-logging-analytics`). `dart analyze lib/` clean.
