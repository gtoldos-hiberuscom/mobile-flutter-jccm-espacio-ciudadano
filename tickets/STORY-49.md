---
id: 49
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
  - familia-numerosa
  - qr
  - pdf
  - pkpass
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-29T10:15:10+00:00
due_date:
jira_url:
---
# [STORY-49] Carnet digital de familia numerosa y sus exportaciones
## Functional Description
Cubrir la experiencia específica del carnet digital de familia numerosa, mostrando sus datos principales y habilitando la obtención de QR, PDF y PKPass cuando el carnet se encuentre vigente y disponible para consumo móvil.

## Acceptance Criteria
- [x] Se contempla lectura de número de carnet y fecha de caducidad.
- [x] Se contempla descarga o generación de QR, PDF y PKPass cuando el carnet está vigente.
- [x] Se contempla integración con wallet móvil cuando corresponda.
- [x] Se contemplan errores de generación/descarga y fallback visual.

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
  - /carnet-digital/familia-numerosa/{dni}
  - /carnet-digital/familia-numerosa-pkpass/{dni}
  - /carnet-digital/qr/{dni}
  - /carnet-digital/pdf/{dni}
  - /carnet-digital/pkpass/{dni}
- Functional focus:
  - Lectura de metadatos del carnet.
  - Generación/descarga de formatos móviles y documentales.
  - Fallback visual ante error, indisponibilidad o vigencia expirada.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /carnet-digital/familia-numerosa/{dni}, /carnet-digital/familia-numerosa-pkpass/{dni}, /carnet-digital/qr/{dni}, /carnet-digital/pdf/{dni}, /carnet-digital/pkpass/{dni}
  - image_references/Servicios - Mis carnets digitales.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-7]
- Dependency map:
  - Blocked by [STORY-48] para entrada/navegación y por [TASK-53] para validar payloads binarios/string y reglas wallet.
  - Sin descendientes explícitos en este corte.
  - Related to [STORY-52] por la capacidad común de exportación y apertura.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Sprint 6 start; status → In Progress.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Implemented `lib/features/digital_cards/familia_numerosa/` (entities, repository abstraction + mock impl with magic-valid PDF/PKPass payloads, AsyncNotifier, detail page with members section + WalletActionBar). Routed at `Routes.cardFamiliaNumerosaDetail = '/cards/familia-numerosa'`; catalogue tile tap navigates only for `DigitalCardType.familiaNumerosa` (joven/discapacidad keep snackbar with TODO markers). Reuses STORY-52 `WalletActionController.persistAndAct` for QR/PDF/PKPass exports. Added 18 l10n keys × 2 locales. Tests: repo (incl. magic validation per format), notifier (load/refresh/unavailable), detail page widget. Acceptance criteria satisfied; status → Done.
