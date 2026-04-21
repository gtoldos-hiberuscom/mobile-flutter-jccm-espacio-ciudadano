---
id: 52
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
  - wallet
  - documentos
  - qr
  - pkpass
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-52] Gestión transversal de QR, PDF, PKPass y wallet móvil
## Functional Description
Definir la capacidad común de descarga, apertura, compartición y alta en wallet para documentos de carnet digital, cubriendo el pipeline técnico desde la respuesta backend hasta el consumo seguro en el dispositivo.

## Acceptance Criteria
- [ ] Se contempla pipeline común para obtención de binarios/base64 y persistencia temporal segura.
- [ ] Se contempla apertura/preview o compartición del PDF/QR.
- [ ] Se contempla alta en Apple Wallet/Google Wallet o fallback equivalente.
- [ ] Se contemplan nombres de fichero, errores de sistema y limpieza de temporales.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-15]
    - [TASK-53]
  - Blocks:
    - [STORY-49]
    - [STORY-50]
    - [STORY-51]
  - Related to:
    - [EPIC-7]
- Shared capability:
  - /carnet-digital/qr/{dni}
  - /carnet-digital/pdf/{dni}
  - /carnet-digital/pkpass/{dni}
- Technical scope:
  - Obtención de binarios o cadenas base64 desde backend.
  - Apertura, preview, compartición y alta en wallet según plataforma.
  - Gestión segura de nombres de fichero, errores de sistema y limpieza de temporales.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /carnet-digital/qr/{dni}, /carnet-digital/pdf/{dni}, /carnet-digital/pkpass/{dni}
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 6
  - image_references/Servicios - Mis carnets digitales.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-7]
- Dependency map:
  - Blocked by [STORY-15] para patrones documentales transversales y [TASK-53] para cierre del contrato real de binarios/wallet.
  - Blocks [STORY-49], [STORY-50] y [STORY-51].
  - Actúa como capacidad común reutilizable para todos los carnets digitales.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
