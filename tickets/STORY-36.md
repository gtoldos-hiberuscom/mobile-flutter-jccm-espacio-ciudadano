---
id: 36
jira_key: JCCMEC-35
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-27
parent: JCCMEC-27
sprint: Sprint 5
reporter:
assignee: Copilot
story_points:
labels:
  - registro
  - entradas
  - salidas
  - detalle
  - listados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-35
---
# [STORY-36] Detalle de entradas y salidas de registro
## Functional Description
Cubrir la lectura detallada de registros de entrada y salida asociados al ciudadano, manteniendo consistencia de navegación, formatos y manejo de vacíos o errores.

## Acceptance Criteria
- [x] Se contempla listado y detalle de entradas de registro con número, fecha y consejería de destino.
- [x] Se contempla la variante equivalente para salidas de registro aunque la evidencia visual principal sea de entradas.
- [x] Se contemplan breadcrumbs y retorno al listado correspondiente.
- [x] Se contemplan mensajes vacíos o error y consistencia de formatos de fecha y número.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-34]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-5]
- Endpoint coverage:
  - /publicacion/selectbynifentrada
  - /publicacion/selectbynifsalida
  - /publicacion/selectbynumreg
- Detail scope:
  - Variante de entradas y salidas alineada en navegación y presentación.
  - Breadcrumbs y retorno coherente al listado de origen.
  - Tratamiento explícito de vacíos, errores y formatos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /publicacion/selectbynifentrada
  - /publicacion/selectbynifsalida
  - /publicacion/selectbynumreg
  - image_references/Entradas registro - listado.png
  - image_references/Entrada registro - detalle.png
  - MAPEO_DETALLADO_ENDPOINTS.md 3.2, 3.3, 3.5
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [STORY-34].
  - Sin tickets descendientes explícitos en este corte.
  - Comparte superficie funcional de gestiones con expedientes, pero con foco en detalle de registros.

## Notes
### Comments
- None yet.
- 2026-04-24 | Copilot — Implemented registro detail surface (entrada/salida) under `lib/features/casework/registro/` with read-only metadata block, breadcrumbs, ficheros list and informational banner. Added route `Routes.caseworkRegistroDetail = /casework/registro/:kind/:numreg` and wired registro item taps in `casework_workspace_page.dart` (entradas/salidas only — expediente nav untouched, owned by STORY-35). Mock `RegistroRepositoryImpl` covers two entradas, two salidas, plus one empty-ficheros case per kind to drive the empty UI state. Added ES/EN l10n keys prefixed `caseworkRegistroDetail*`.
- 2026-04-24 | Copilot — Validation: `flutter analyze` introduces 0 new errors and 0 new warnings (only pre-existing baseline issues in `generated/` and `home_page.dart` remain). `flutter test` 176/176 pass, including 8 new tests in `test/features/casework/registro/`.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T11:34:20+00:00 | by Copilot | Implemented STORY-36 registro entrada/salida detail with breadcrumbs and ficheros list.
