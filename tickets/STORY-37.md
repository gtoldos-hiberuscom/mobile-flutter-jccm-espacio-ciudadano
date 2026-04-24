---
id: 37
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 5
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
updated_at: 2026-04-24T13:55:57+02:00
due_date:
jira_url:
---
# [STORY-37] Flujo dedicado de aportación de documentos por terceros
## Functional Description
Cubrir la experiencia específica de aportación de documentos sobre un expediente mediante un wizard propio, identificando interesado y expediente antes de llegar al detalle operativo.

## Acceptance Criteria
- [x] Se contempla pantalla introductoria con explicación funcional y restricciones del flujo.
- [x] Se contempla identificación del interesado por tipo y número de documento.
- [x] Se contempla búsqueda por número de registro o número de expediente.
- [x] Se contempla transición al detalle del expediente encontrado dentro del mismo flujo.

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
- Implementation slices (delivered):
  - `lib/features/casework/aportacion/0_entity/`: `aportacion_step`, `aportacion_session`, `interested_party_identification`, `aportacion_search_query` (sealed union), `aportacion_failure`.
  - `lib/features/casework/aportacion/1_domain/`: `AportacionResolver` (thin wrapper over `CaseworkRepository.searchByExpedienteNumber` / `searchByRegistroNumber`) y `AportacionSessionNotifier` con transiciones intro → identificación → búsqueda → detalle → confirmación, back y manejo de fallos.
  - `lib/features/casework/aportacion/2_presentation/`: `AportacionWizardPage` con AppBar, breadcrumbs y "Paso N de M", más cinco widgets de paso (`aportacion_intro_step`, `aportacion_identification_step`, `aportacion_search_step`, `aportacion_detail_step`, `aportacion_complete_step`) y un `AportacionFailureBanner`.
  - Reutilización de STORY-35 vía nuevo widget aditivo `lib/features/casework/detail/2_presentation/widgets/expediente_detail_view.dart` (no modifica `expediente_detail_page.dart`).
  - Reutilización directa de `UploadEvidenceSection` (STORY-38) embebida en el paso de detalle; el wizard avanza a la confirmación al detectar `uploadSession.finalized`.
  - Routing: `Routes.caseworkAportacion = '/casework/aportacion'` y entrada secundaria (icono `upload_file_outlined`) en `casework_workspace_page.dart`.
  - `lib/l10n/app_es.arb` + `lib/l10n/app_en.arb`: claves `caseworkAportacion*` y regeneración de `app_localizations*.dart` vía `flutter gen-l10n`.
  - Tests: `test/features/casework/aportacion/aportacion_session_notifier_test.dart` (7 casos: estado inicial, happy path, back, identificación inválida, no resultados, error de red, reset) y `aportacion_wizard_page_widget_test.dart` (3 casos: render intro, transición intro→identificación→búsqueda→detalle, banner notFound).

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Aportación - paso 1.png
  - image_references/Aportación - paso 2.png
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
- 2026-04-24 | Implementación cerrada en sprint 5. El wizard reutiliza el contrato existente `CaseworkRepository` (sin endpoints nuevos) mediante un `AportacionResolver` aislado en `1_domain` que devuelve la primera coincidencia de `selectbynumexp` / `selectbynumreg`. La integración Dio real continúa pendiente al igual que en STORY-39 — el mock actual de `CaseworkRepositoryImpl` se mantiene.

### Deferred items
- Cableado real Dio para `selectbynumexp` y `selectbynumreg` (heredado de STORY-39 / discovery TASK-40).
- Validación funcional de los textos definitivos de copy con negocio.
- Confirmación con backend del comportamiento esperado cuando la búsqueda devuelve múltiples expedientes (la primera coincidencia se asume canónica).

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-24T13:55:57+02:00 | by Copilot | Status → Done; Sprint 5; AC marcadas; añadidas implementation slices, comentario de cierre y deferred items. Implementación entregada en `task/EPIC-5-casework/STORY-37-third-party-aportacion/implement-third-party-aportacion`.
