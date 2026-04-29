---
id: 45
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
  - firma-digital
  - afirma
  - certificado
  - documentos
  - listado
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-29T10:15:10+00:00
due_date:
jira_url:
---
# [STORY-45] Listado de documentos a firmar, validación de certificado e histórico firmado
## Functional Description
Cubrir la operativa principal de firma digital previa al salto a Afirma, incluyendo listado de documentos pendientes, validación de certificado electrónico o VEC y acceso al histórico de documentos ya firmados.

## Acceptance Criteria
- [x] Se contempla listado de documentos pendientes de firma.
- [x] Se contempla validación de certificado electrónico o VEC.
- [x] Se contempla acceso al histórico de documentos ya firmados.
- [x] Se contemplan errores recuperables de autenticación, certificado y transporte.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-18]
    - [TASK-21]
  - Blocks:
    - [STORY-46]
  - Related to:
    - [EPIC-6]
- Endpoint coverage:
  - /afirma/milistardocumentosreq
  - /afirma/mivecreq
  - /publicacion/midocfirmados
- Operational scope:
  - Listado de documentos pendientes y acceso a histórico firmado.
  - Validación de certificado o VEC antes del salto al flujo externo.
  - Manejo de errores recuperables de autenticación, certificado y transporte.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /afirma/milistardocumentosreq
  - /afirma/mivecreq
  - /publicacion/midocfirmados
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 9
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 9
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-13], [STORY-18] y [TASK-21].
  - Blocks [STORY-46].
  - Prepara el salto a Afirma y el histórico documental de firma.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Sprint 6 start; status → In Progress.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Implemented `lib/features/signature/` (entities, repository abstraction + mock impl, AsyncNotifier inbox + certificate validation provider, inbox page with pending/history tabs, certificate banner with re-validate CTA). Routed at `Routes.signatureInbox = '/sign'` under the auth shell. Added 28 l10n keys × 2 locales. Tests: repository (6), notifier (4), inbox page widget (2). Mocks for `/afirma/milistardocumentosreq`, `/afirma/mivecreq`, `/publicacion/midocfirmados` with `// TODO(future-sprint)` markers. Sign CTA shows placeholder snackbar pending STORY-46. Acceptance criteria satisfied; status → Done.
- 2026-04-29T10:15:10+00:00 | by plan-manager | Notes: Riverpod codegen avoided in favour of plain `AsyncNotifierProvider`/`FutureProvider` to keep the slice self-contained without coupling to the existing `*.g.dart` fingerprint scheme; flagged for a future repo-wide codegen pass.
