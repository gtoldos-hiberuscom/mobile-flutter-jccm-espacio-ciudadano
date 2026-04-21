---
id: 49
jira_key:
type: Story
status: To Do
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
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
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-49] Carnet digital de familia numerosa y sus exportaciones
## Functional Description
Cubrir la experiencia específica del carnet digital de familia numerosa, mostrando sus datos principales y habilitando la obtención de QR, PDF y PKPass cuando el carnet se encuentre vigente y disponible para consumo móvil.

## Acceptance Criteria
- [ ] Se contempla lectura de número de carnet y fecha de caducidad.
- [ ] Se contempla descarga o generación de QR, PDF y PKPass cuando el carnet está vigente.
- [ ] Se contempla integración con wallet móvil cuando corresponda.
- [ ] Se contemplan errores de generación/descarga y fallback visual.

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
