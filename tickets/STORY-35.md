---
id: 35
jira_key: JCCMEC-34
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-27
parent: JCCMEC-27
sprint: Sprint 5
reporter:
assignee:
story_points:
labels:
  - expedientes
  - detalle
  - documentos
  - aportacion-documental
  - metadata
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T16:06:40+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-34
---
# [STORY-35] Detalle de expediente con metadata y ficheros asociados
## Functional Description
Cubrir la lectura del detalle de expediente, su metadata operativa y la zona de trabajo para consultar ficheros ya asociados o preparar la aportación desde el propio detalle.

## Acceptance Criteria
- [x] Se contemplan campos de detalle como consejería, oficina tramitadora, procedimiento, código del asunto, fechas y estado.
- [x] Se contempla listado de ficheros ya asociados al expediente.
- [x] Se contempla zona para añadir ficheros sobre el expediente desde el propio detalle.
- [x] Se contemplan estados de expediente abierto o cerrado y restricciones operativas.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-34]
  - Blocks:
    - [STORY-38]
  - Related to:
    - [EPIC-5]
- Endpoint coverage:
  - /publicacion/selectbynumexp
- Detail and operations:
  - Metadata funcional del expediente con formato consistente de fechas y estados.
  - Listado de ficheros ya asociados como base para la trazabilidad documental.
  - Zona operativa de aportación condicionada al estado abierto o cerrado del expediente.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - /publicacion/selectbynumexp
  - image_references/Expediente - detalle.png
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md pantalla 3
- Provisional hierarchy:
  - Epic candidate: [EPIC-5]
- Dependency map:
  - Blocked by [STORY-34].
  - Blocks [STORY-38].
  - Reutiliza el workspace de gestiones y habilita la vía embebida de aportación documental.

## Notes
### Comments
- 2026-04-23T10:00:00+02:00 | by Copilot | Implementado el detalle real de expediente bajo `lib/features/casework/detail/{0_entity,1_domain,2_presentation,3_data}`, sustituyendo el placeholder `CaseworkItemDetailPlaceholderPage`. La página muestra la metadata (consejería, oficina, procedimiento, código de asunto, fechas, chip de estado), el listado de ficheros asociados con icono por MIME y descarga diferida (TODO future-sprint), y embebe `UploadEvidenceSection` (STORY-38) cuando el expediente está `abierto`; cuando está `cerrado` muestra un banner informativo. El enum `ExpedienteEstado` admite `unknown` como fallback tolerante (TASK-40 Q1). El repositorio mock devuelve dos expedientes deterministas (`EXP/2025/00123` abierto con 2 ficheros, `EXP/2025/00098` cerrado con 1 fichero) y lanza `StateError` para cualquier otro número, alimentando el estado de error.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-23T10:00:00+02:00 | by Copilot | Status → Done, sprint Sprint 5, AC marcados. Implementación completa de la pantalla de detalle de expediente con metadata, ficheros asociados y aportación embebida (commit en task/EPIC-5-casework/STORY-35-expediente-detail/implement-expediente-detail).

