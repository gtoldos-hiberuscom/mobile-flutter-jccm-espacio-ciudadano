---
id: 55
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
  - consentimiento
  - privacidad
  - preferencias
  - recomendaciones
  - legal
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T11:30:00+02:00
due_date:
jira_url:
---
# [STORY-55] Autorizaciones de uso de datos y revocación desde preferencias
## Functional Description
Cubrir la gestión de autorizaciones necesarias para mostrar datos y generar recomendaciones personalizadas, incluyendo guardado explícito, revocación desde preferencias y reutilización de la información de protección de datos aceptada al inicio.

## Acceptance Criteria
- [x] Se contempla pantalla/sección de autorizaciones con guardado explícito.
- [x] Se contemplan autorizaciones para datos JCCM, otras administraciones y perfilado de recomendaciones.
- [x] Se contempla revocación o borrado de preferencias desde el mismo ámbito funcional.
- [x] Se reutiliza o referencia la información de protección de datos aceptada al inicio.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-19]
    - [TASK-21]
  - Blocks:
    - [STORY-56]
    - [STORY-57]
  - Related to:
    - [EPIC-8]
- Integration scope:
  - /hechos-vitales/clausulas/{idAgente}
  - /hechos-vitales/clausulas
  - /hechos-vitales/preferencias/{idAgente}
- Privacy scope:
  - Autorizaciones para datos JCCM, otras administraciones y perfilado.
  - Revocación o borrado desde preferencias.
  - Referencia a la aceptación inicial de condiciones y protección de datos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /hechos-vitales/clausulas/{idAgente}, /hechos-vitales/clausulas, /hechos-vitales/preferencias/{idAgente}
  - image_references/Proactividad - Mis uso de datos.png
  - Acceso - Condiciones.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [STORY-19] y [TASK-21].
  - Blocks [STORY-56] y [STORY-57].
  - Conecta las preferencias proactivas con el consentimiento inicial del usuario.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T11:25:00+02:00 | by Copilot | To Do → In Progress. Sprint 4 implementation started on branch task/EPIC-8-personalization/STORY-55-data-consent/implement-data-consent.
- 2026-04-22T11:30:00+02:00 | by Copilot | In Progress → Done. Implemented `lib/features/personalization/` data-consent slice (entity + state, repository contract, Riverpod notifier, mock repository impl, `DataConsentPage` with three SwitchListTiles, explicit Save action, revoke-all confirmation dialog and CTA linking to the existing onboarding `ConsentPage` at `/consent` for protección-de-datos reference). Added `Routes.preferencesConsent` (`/preferences/consent`) inside the authenticated shell and a CTA on `LifeEventsPage`. l10n keys added under the `dataConsent*` prefix in `app_es.arb` / `app_en.arb`. Notifier reuses STORY-54 idAgente strategy (`sessionStateProvider` → `LifeEventsPage.stubIdAgente`). Dio wiring for `/hechos-vitales/clausulas/{idAgente}`, `PATCH /hechos-vitales/clausulas` and `DELETE /hechos-vitales/preferencias/{idAgente}` deferred to a follow-up story (depends on TASK-21 idAgente closure) — see `TODO(future-sprint)` in `data_consent_repository_impl.dart`. Tests: `flutter test test/features/personalization/` → 15/15 pass (5 notifier + 2 widget added on top of STORY-54). Analyzer: 0 errors / 0 warnings on `lib/features/personalization/`.
