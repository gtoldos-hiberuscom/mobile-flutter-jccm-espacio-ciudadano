---
id: 7
jira_key:
type: Epic
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
  - wallet
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
# [EPIC-7] Carnets digitales, wallet y documentos acreditativos
## Functional Description
Cubrir la visualización, descarga y uso móvil de los carnets digitales del ciudadano, incluyendo catálogo, detalle por carnet, exportaciones en QR/PDF/PKPass y los estados de no disponibilidad o no vigencia observados en diseño y documentación funcional.

## Acceptance Criteria
- [ ] El epic cubre catálogo de carnets, detalles por carnet y exportación.
- [ ] Se reflejan wallet/mobile pass, PDF, QR y estados no vigente/no disponible.
- [ ] Se explicita la validación pendiente de respuestas binarias/string y contratos asociados.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
    - [EPIC-2]
  - Blocks:
    - [STORY-48]
    - [STORY-49]
    - [STORY-50]
    - [STORY-51]
    - [STORY-52]
    - [TASK-53]
  - Related to:
    - [EPIC-3]
- Scope decomposition:
  - Catálogo principal de carnets digitales con estados de disponibilidad y navegación.
  - Experiencias específicas para familia numerosa, carnet joven y discapacidad.
  - Gestión transversal de QR, PDF, PKPass y alta en wallet móvil.
- Technical uncertainty:
  - Pendiente validar si las respuestas de QR/PDF/PKPass llegan como binario, string o base64.
  - Pendiente confirmar contratos asociados a estados no vigente, no descargable y no disponible.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 6
  - MAPEO_ENDPOINTS_PANTALLAS.md Mi Carnet Digital
  - MAPEO_DETALLADO_ENDPOINTS.md sección 6
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 6
  - image_references/Servicios - Mis carnets digitales.png
  - Modal Carnet joven.png
- Provisional hierarchy:
  - Children:
    - [STORY-48]
    - [STORY-49]
    - [STORY-50]
    - [STORY-51]
    - [STORY-52]
    - [TASK-53]
- Dependency map:
  - Blocked by [EPIC-1] y [EPIC-2].
  - Related to [EPIC-3] por continuidad de servicios/documentos del ciudadano.
  - Se descompone en catálogo, variantes de carnet y capacidad transversal de exportación/wallet.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
