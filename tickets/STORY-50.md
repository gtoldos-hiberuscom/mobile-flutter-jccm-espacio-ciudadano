---
id: 50
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 6
reporter:
assignee:
story_points:
labels:
  - carnets-digitales
  - carnet-joven
  - modal
  - qr
  - pkpass
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-29T10:15:10+00:00
due_date:
jira_url:
---
# [STORY-50] Carnet Joven con modal de detalle y formatos móviles
## Functional Description
Cubrir la experiencia del Carnet Joven, incluyendo su ficha específica, la variante modal o superpuesta observada en diseño y el acceso a formatos móviles/documentales desde los distintos puntos de entrada de la aplicación.

## Acceptance Criteria
- [x] Se contempla ficha de Carnet Joven con número y vigencia.
- [x] Se contempla la variante modal o superpuesta de detalle.
- [x] Se contemplan QR, PDF y PKPass como formatos disponibles.
- [x] Se contempla navegación coherente desde home, menú o listado de carnets.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-48]
    - [TASK-53]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-7]
    - [STORY-52]
- Integration scope:
  - /carnet-digital/joven/{dni}
  - /carnet-digital/qr/{dni}
  - /carnet-digital/pdf/{dni}
  - /carnet-digital/pkpass/{dni}
- UI considerations:
  - Variante modal/overlay de detalle según diseño.
  - Navegación coherente desde home, menú y listado de carnets.
  - Consistencia de acciones QR/PDF/PKPass entre tarjeta y detalle.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /carnet-digital/joven/{dni}, /carnet-digital/qr/{dni}, /carnet-digital/pdf/{dni}, /carnet-digital/pkpass/{dni}
  - image_references/Servicios - Mis carnets digitales.png
  - Modal Carnet joven.png
  - CarnetJoven.md
- Provisional hierarchy:
  - Epic candidate: [EPIC-7]
- Dependency map:
  - Blocked by [STORY-48] y [TASK-53].
  - Sin descendientes explícitos en este corte.
  - Related to [STORY-52] para la gestión común de archivos y wallet móvil.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Sprint 6 start; status → In Progress.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Implemented `lib/features/digital_cards/joven/` (entity, repo + mock with magic-valid PDF/PKPass, AsyncNotifier, full-page detail and modal-bottom-sheet variant sharing a common `JovenDetailBody`). Routed at `Routes.cardJovenDetail = '/cards/joven'`; catalogue tile tap on `DigitalCardType.joven` opens the modal per AC, full page reserved for deep-link / future home shortcuts. Reuses STORY-52 `WalletActionController` for QR/PDF/PKPass. Added 10 l10n keys × 2 locales. Tests cover repo (incl. magic per format), notifier, full page, modal. Acceptance criteria satisfied; status → Done.
