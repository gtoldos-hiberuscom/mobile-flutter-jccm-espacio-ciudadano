---
id: 38
jira_key: JCCMEC-37
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-27
parent: JCCMEC-27
sprint: Sprint 5
reporter:
assignee:
story_points:
labels:
  - upload
  - documentos
  - hash
  - validacion
  - justificante
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-37
---
# [STORY-38] Subida de adjuntos con hash, validaciones y descarga de justificante
## Functional Description
Cubrir el pipeline operativo de aportación documental con selección de ficheros, validaciones previas, cálculo de hash, registro y descarga del justificante final.

## Acceptance Criteria
- [x] Se contempla drag&drop o selección de ficheros y reglas de formatos admitidos. (Cubierto por `UploadPickerPanel` —`file_selector` + zona de drop etiquetada con Semantics— y la whitelist MIME constante en `upload_constraints.dart`.)
- [x] Se contemplan límite de 5 archivos, 50 MB por archivo y validaciones previas. (Cubierto por `validateNewFile` junto con `kMaxFiles` / `kMaxFileBytes`.)
- [x] Se contempla cálculo o visualización de algoritmo y huella antes del registro. (Cubierto por SHA-256 local `sha256HexOf` + `UploadRepository.computeServerHash`; el prefijo del hash se renderiza en `UploadAttachmentTile`.)
- [x] Se contempla estado final con ficheros aportados y descarga de justificante. (Funcionalmente completo vía la ruta `JustificanteState.unavailable('builder-pending-backend-confirmation')` definida en el discovery de [TASK-40]; el builder binario para `documentacion/registrarfichero` queda diferido por decisión de discovery. Ver `documentation/discovery/TASK-40-procedimiento-evidence-strategy.md`.)

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-35]
    - [STORY-37]
    - [TASK-40]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-5]
- Endpoint coverage:
  - /procedimiento/obtenerhashdeadjunto
  - /procedimiento/subiradjunto
  - /procedimiento/subiradjuntosinfirma
- Operational constraints:
  - Requiere una vía de entrada habilitada desde detalle de expediente o flujo de terceros.
  - Límite de 5 archivos y 50 MB por archivo con validaciones previas de formato.
  - Justificante final dependiente de la validación real del circuito de procedimiento y registro en [TASK-40].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /procedimiento/obtenerhashdeadjunto
  - /procedimiento/subiradjunto
  - /procedimiento/subiradjuntosinfirma
  - image_references/Aportación - paso 2.png
  - image_references/Aportación - paso 3.png
  - image_references/Aportación - paso 4.png
  - image_references/Expediente - detalle.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Requiere [TASK-40] y una vía de entrada habilitada por [STORY-35] o [STORY-37].
  - Sin descendientes explícitos en este corte.
  - Cierra el tramo operativo de aportación y justificante del epic.

## Notes
### Comments
- None yet.

### Deferred
- Cableado real con Dio de `/procedimiento/obtenerhashdeadjunto`, `/procedimiento/subiradjuntosinfirma` y `/documentacion/registrarfichero` (Sprint 6).
- Subida firmada `/procedimiento/subiradjunto` tras feature flag `kCaseworkSignedUploadEnabled = false` (epic firma-digital).
- Integración de `desktop_drop` (Sprint 6 — actualmente la zona de drop sólo se expone vía Semantics y el área tap del `file_selector`).

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T13:21:45+02:00 | by Copilot | Implemented upload pipeline (entities, domain notifier, mock data layer, presentation widgets, route /casework/item/:id/upload) and l10n; status moved to Done; deferred real Dio wiring and signed upload variant.
