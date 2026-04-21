---
id: 45
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
  - firma-digital
  - afirma
  - certificado
  - documentos
  - listado
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-45] Listado de documentos a firmar, validación de certificado e histórico firmado
## Functional Description
Cubrir la operativa principal de firma digital previa al salto a Afirma, incluyendo listado de documentos pendientes, validación de certificado electrónico o VEC y acceso al histórico de documentos ya firmados.

## Acceptance Criteria
- [ ] Se contempla listado de documentos pendientes de firma.
- [ ] Se contempla validación de certificado electrónico o VEC.
- [ ] Se contempla acceso al histórico de documentos ya firmados.
- [ ] Se contemplan errores recuperables de autenticación, certificado y transporte.

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
