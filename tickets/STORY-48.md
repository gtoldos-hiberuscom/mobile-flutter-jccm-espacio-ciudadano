---
id: 48
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
  - catalogo
  - ui-state
  - qr
  - pdf
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-48] Catálogo de carnets digitales con disponibilidad y estados bloqueados
## Functional Description
Cubrir la pantalla principal de carnets digitales con listado de credenciales, disponibilidad por tipo de carnet, estados bloqueados/no vigentes y acceso a los formatos descargables o navegables desde la tarjeta o su ficha.

## Acceptance Criteria
- [ ] Se contemplan al menos familia numerosa, carnet joven y discapacidad.
- [ ] Se contemplan estados disponible, no vigente y no descargable.
- [ ] Se contemplan accesos a QR, PKPASS y PDF desde la propia tarjeta o ficha.
- [ ] Se contemplan mensajes vacíos/error y navegación desde portada/home.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-15]
    - [STORY-18]
  - Blocks:
    - [STORY-49]
    - [STORY-50]
    - [STORY-51]
    - [STORY-52]
  - Related to:
    - [EPIC-7]
- Screen scope:
  - Listado principal con disponibilidad por carnet y estados bloqueados.
  - Navegación desde home/portada hacia la sección de carnets.
  - Entrada a QR, PKPASS y PDF desde tarjeta o ficha asociada.
- State model:
  - Disponible con acciones.
  - No vigente con mensaje explícito.
  - No descargable o no disponible sin acciones inválidas.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - image_references/Servicios - Mis carnets digitales.png
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 6
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N4
- Provisional hierarchy:
  - Epic candidate: [EPIC-7]
- Dependency map:
  - Blocked by [STORY-15] para patrones transversales de UI/documentos y [STORY-18] para sesión autenticada.
  - Blocks [STORY-49], [STORY-50], [STORY-51] y [STORY-52].
  - Sirve de puerta de entrada al dominio de carnets digitales.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
