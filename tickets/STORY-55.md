---
id: 55
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
  - consentimiento
  - privacidad
  - preferencias
  - recomendaciones
  - legal
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [STORY-55] Autorizaciones de uso de datos y revocación desde preferencias
## Functional Description
Cubrir la gestión de autorizaciones necesarias para mostrar datos y generar recomendaciones personalizadas, incluyendo guardado explícito, revocación desde preferencias y reutilización de la información de protección de datos aceptada al inicio.

## Acceptance Criteria
- [ ] Se contempla pantalla/sección de autorizaciones con guardado explícito.
- [ ] Se contemplan autorizaciones para datos JCCM, otras administraciones y perfilado de recomendaciones.
- [ ] Se contempla revocación o borrado de preferencias desde el mismo ámbito funcional.
- [ ] Se reutiliza o referencia la información de protección de datos aceptada al inicio.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-19]
    - [TASK-21]
  - Blocks:
    - [STORY-56]
    - [STORY-57]
  - Related to:
    - [EPIC-8]
- Integration scope:
  - /hechos-vitales/clausulas/{idAgente}
  - /hechos-vitales/clausulas
  - /hechos-vitales/preferencias/{idAgente}
- Privacy scope:
  - Autorizaciones para datos JCCM, otras administraciones y perfilado.
  - Revocación o borrado desde preferencias.
  - Referencia a la aceptación inicial de condiciones y protección de datos.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - endpoints /hechos-vitales/clausulas/{idAgente}, /hechos-vitales/clausulas, /hechos-vitales/preferencias/{idAgente}
  - image_references/Proactividad - Mis uso de datos.png
  - Acceso - Condiciones.png
- Provisional hierarchy:
  - Epic candidate: [EPIC-8]
- Dependency map:
  - Blocked by [STORY-19] y [TASK-21].
  - Blocks [STORY-56] y [STORY-57].
  - Conecta las preferencias proactivas con el consentimiento inicial del usuario.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
