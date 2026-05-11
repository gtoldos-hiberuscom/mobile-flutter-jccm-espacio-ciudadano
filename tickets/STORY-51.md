---
id: 51
jira_key: JCCMEC-50
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-29
parent: JCCMEC-29
sprint: Sprint 6
reporter:
assignee:
story_points:
labels:
  - carnets-digitales
  - discapacidad
  - pkpass
  - parsing
  - ui-state
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-50
---
# [STORY-51] Discapacidad, grado y manejo de carnet no vigente
## Functional Description
Cubrir el caso del carnet o acreditación de discapacidad incluyendo el grado cuando exista, la generación de pass asociado cuando proceda y el tratamiento explícito del estado no vigente o sin datos disponible en diseño.

## Acceptance Criteria
- [x] Se contempla lectura del grado de discapacidad cuando exista.
- [x] Se contempla PKPass/formatos asociados si el carnet está vigente.
- [x] Se contempla estado no vigente o no disponible con mensaje explícito y sin acciones inválidas.
- [x] Se contemplan errores de parsing para payloads string y casos sin datos.

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
  - /carnet-digital/grado-discapacidad/{dni}
  - /carnet-digital/discapacidad-pkpass/{dni}
- State considerations:
  - Mostrar grado cuando el backend lo provea.
  - Desactivar acciones en estado no vigente/no disponible.
  - Manejar parsing ambiguo cuando la respuesta llegue como string o payload no estructurado.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /carnet-digital/grado-discapacidad/{dni}, /carnet-digital/discapacidad-pkpass/{dni}
  - image_references/Servicios - Mis carnets digitales.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N4
- Provisional hierarchy:
  - Epic candidate: [EPIC-7]
- Dependency map:
  - Blocked by [STORY-48] y [TASK-53].
  - Sin descendientes explícitos en este corte.
  - Related to [STORY-52] por reutilización de gestión de pass/documentos.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Sprint 6 start; status → In Progress.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Implemented `lib/features/digital_cards/discapacidad/` (entity + parse failure enum, tolerant `DiscapacidadParser` for structured map / bare-string / unparseable inputs, repository + mock with `mockVariant` switch, AsyncNotifier, detail page covering vigente / noVigente / notAvailable / parseError branches with PKPass-only WalletActionBar). Routed at `Routes.cardDiscapacidadDetail = '/cards/discapacidad'`; catalog tile tap on `DigitalCardType.discapacidad` navigates here. Added 13 l10n keys × 2 locales. Tests cover parser, repo (per variant + magic), notifier, page widget per branch (20 new tests). Acceptance criteria satisfied; status → Done.
