---
id: 46
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
  - deep-link
  - callback
  - handoff
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-46] Salto a navegador, firma en Afirma y retorno seguro a la app
## Functional Description
Modelar el tramo externo del proceso de firma, el handoff a navegador o sistema de firma y el reingreso controlado en la aplicación tras cancelación, error o firma completada.

## Acceptance Criteria
- [ ] Se contempla handoff al navegador o sistema externo de firma.
- [ ] Se contempla retorno a la app mediante deep link o callback equivalente.
- [ ] Se contemplan casos de cancelación, error y firma completada.
- [ ] Se contempla sincronización posterior del estado firmado en la app.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-13]
    - [STORY-45]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-6]
- External flow scope:
  - Handoff al navegador o sistema externo de firma.
  - Retorno mediante deep link o callback equivalente.
  - Sincronización posterior del estado firmado al reingresar en la app.
  - Manejo explícito de cancelación, error y firma completada.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 9
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 9
  - PLANIFICACION_PROYECTO.md fase 6
- Provisional hierarchy:
  - Epic candidate: [EPIC-6]
- Dependency map:
  - Blocked by [STORY-13] y [STORY-45].
  - Sin descendientes explícitos en este corte.
  - Cierra el tramo externo de firma y retorno seguro a la app.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
