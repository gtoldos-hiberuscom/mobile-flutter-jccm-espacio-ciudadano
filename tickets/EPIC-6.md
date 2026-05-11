---
id: 6
jira_key: JCCMEC-28
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
  - notificaciones
  - firma-digital
  - afirma
  - documentos
  - certificados
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-28
---
# [EPIC-6] Notificaciones administrativas y firma digital
## Functional Description
Cubrir la consulta y gestión de notificaciones administrativas, así como el flujo transversal de firma electrónica con Afirma y el retorno seguro a la aplicación.

## Acceptance Criteria
- [ ] El epic cubre listado, detalle, alta de contacto, aceptación o rechazo y documentos de notificación.
- [ ] El epic cubre listado de documentos a firmar, validación de certificado y documentos ya firmados.
- [ ] Se explicita la ambigüedad de contrato de notificaciones y el retorno por navegador o deep link de firma.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
    - [EPIC-2]
  - Blocks:
    - [STORY-41]
    - [STORY-42]
    - [STORY-43]
    - [STORY-44]
    - [STORY-45]
    - [STORY-46]
    - [TASK-47]
  - Related to:
    - [EPIC-5]
- Scope decomposition:
  - Centro de notificaciones con filtros por estado y navegación a detalle.
  - Alta previa de datos de contacto para la plataforma de notificación electrónica.
  - Gestión de estados pendiente, aceptada, rechazada y caducada con documentos asociados.
  - Listado de documentos a firmar, validación de certificado y retorno seguro desde Afirma.
- Technical uncertainty:
  - Contrato real de notificaciones pendiente de cierre en [TASK-47].
  - Retorno por navegador o deep link en firma condicionado por el flujo externo de Afirma.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantallas 5 y 9
  - MAPEO_ENDPOINTS_PANTALLAS.md Notificaciones y Firma
  - MAPEO_DETALLADO_ENDPOINTS.md secciones 5 y 9
  - RESUMEN_FUNCIONALIDADES_PPT.md secciones 5 y 9
  - image_references/Notificaciones - listado.png
  - image_references/Notificaciones - Alta.png
  - image_references/Notifiación pendiente - detalle.png
  - image_references/Notifiación pendiente - confirmación.png
  - image_references/Notifiación aceptada - detalle.png
  - image_references/Notifiación rechazada - detalle.png
- Provisional hierarchy:
  - Children:
    - [STORY-41]
    - [STORY-42]
    - [STORY-43]
    - [STORY-44]
    - [STORY-45]
    - [STORY-46]
    - [TASK-47]
- Dependency map:
  - Blocked by [EPIC-1] y [EPIC-2].
  - Related to [EPIC-5] por continuidad de documentos, evidencias y firma transversal.
  - Se descompone en notificaciones administrativas y flujo externo de firma digital.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
