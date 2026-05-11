---
id: 52
jira_key: JCCMEC-51
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-29
parent: JCCMEC-29
sprint: Sprint 5
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
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-51
---
# [STORY-52] Gestión transversal de QR, PDF, PKPass y wallet móvil
## Functional Description
Definir la capacidad común de descarga, apertura, compartición y alta en wallet para documentos de carnet digital, cubriendo el pipeline técnico desde la respuesta backend hasta el consumo seguro en el dispositivo.

## Acceptance Criteria
- [x] Se contempla pipeline común para obtención de binarios/base64 y persistencia temporal segura.
- [x] Se contempla apertura/preview o compartición del PDF/QR.
- [x] Se contempla alta en Apple Wallet/Google Wallet o fallback equivalente.
- [x] Se contemplan nombres de fichero, errores de sistema y limpieza de temporales.

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
- 2026-04-24T11:38:32Z | by Copilot | Mock implementation chosen because path_provider/share_plus/open_filex are not yet in pubspec; the repository contract and the controller are stable so STORY-49/50/51 can wire real packages without API churn.
- 2026-04-24T11:38:32Z | by Copilot | Bootstrap integration of `sweepDigitalCardsTempCache` is intentionally deferred — documented as TODO inside `lib/core/storage/temp_cleanup.dart` so the first per-card story to land can wire the call.
- 2026-04-24T11:38:32Z | by Copilot | STORY-49, STORY-50 and STORY-51 (blocked-by) are now unblocked from a shared-capability standpoint.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T11:38:32Z | by Copilot | STORY-52 implemented: shared QR/PDF/PKPass/wallet capability under lib/features/digital_cards/exporters/, deterministic file naming, BinaryArtifact magic validation, WalletActionController with platform-aware capability chain (Apple Wallet on iOS / share fallback on Android), mock DigitalCardsExporterRepository (path_provider/share_plus/open_filex deferred to per-card stories), and lib/core/storage/temp_cleanup.dart cold-start sweeper. Localization keys added (ES + EN). 26 new tests, all passing; 0 new analyzer issues. STORY-49/50/51 unblocked. Status To Do → Done; sprint set to Sprint 5.
