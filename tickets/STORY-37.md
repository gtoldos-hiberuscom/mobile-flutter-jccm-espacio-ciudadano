---
id: 37
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
  - aportacion-documental
  - terceros
  - wizard
  - expedientes
  - identificacion
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-37] Flujo dedicado de aportación de documentos por terceros
## Functional Description
Cubrir la experiencia específica de aportación de documentos sobre un expediente mediante un wizard propio, identificando interesado y expediente antes de llegar al detalle operativo.

## Acceptance Criteria
- [ ] Se contempla pantalla introductoria con explicación funcional y restricciones del flujo.
- [ ] Se contempla identificación del interesado por tipo y número de documento.
- [ ] Se contempla búsqueda por número de registro o número de expediente.
- [ ] Se contempla transición al detalle del expediente encontrado dentro del mismo flujo.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-18]
    - [STORY-34]
  - Blocks:
    - [STORY-38]
  - Related to:
    - [EPIC-5]
    - [STORY-39]
- Flow slices:
  - Pantalla introductoria y copy de restricciones.
  - Identificación de interesado por tipo y número de documento.
  - Búsqueda por número de registro o expediente.
  - Transición al detalle encontrado dentro del wizard.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Aportación - paso 1.png
  - image_references/Aportación - paso 2.png
  - image_references/Servicios - Mapa web.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N2/N9
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [STORY-13], [STORY-18] y [STORY-34].
  - Blocks [STORY-38].
  - Related to [STORY-39] por reutilización potencial de búsqueda y transición a detalle.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
