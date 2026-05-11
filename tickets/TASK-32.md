---
id: 32
jira_key: JCCMEC-26
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link: JCCMEC-15
parent: JCCMEC-15
sprint: Sprint 4
reporter:
assignee:
story_points:
labels:
  - discovery
  - sescam
  - parsing
  - api-contract
  - agenda
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-11T15:57:23+02:00
due_date:
jira_url: https://hiberusmobile.atlassian.net/browse/JCCMEC-26
---
# [TASK-32] Validar formato real de payloads SESCAM y estrategia de parsing
## Functional Description
Conseguir ejemplos reales y cerrar la estrategia de parsing para citas, citas pasadas y CIP, actualmente tipados como string.

## Acceptance Criteria
- [x] Se obtienen o solicitan ejemplos reales de respuestas string de SESCAM.
- [x] Se decide estrategia de parseo, validación y manejo de errores recuperables.
- [x] Se documenta el impacto en agenda, CIP y widget de próximos eventos.
- [x] Se dejan trazadas las limitaciones si no hay acceso temprano a preproducción.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
  - Blocks:
    - [STORY-30]
    - [STORY-31]
  - Related to:
    - [EPIC-4]
    - [STORY-29]
- Parsing scope:
  - /sescam/citas/{numDocumento}
  - /sescam/citas-pasadas/{numDocumento}
  - /sescam/cip/{numDocumento}
- Expected outcome:
  - Estrategia de parseo robusta, validación y gestión de errores recuperables para agenda y CIP.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - SescamApi.md
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md N4 y R1
  - MAPEO_DETALLADO_ENDPOINTS.md secciones 2.1-2.3
- Provisional hierarchy:
  - Epic candidate: [EPIC-4]
- Dependency map:
  - Blocked by [TASK-16].
  - Blocks [STORY-30] y [STORY-31].
  - Related to [STORY-29] por el modelo base de agenda.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T08:20:00+02:00 | by plan-manager | Sprint 4: To Do → In Progress; sprint set.
- 2026-04-22T08:30:00+02:00 | by plan-manager | Strategy documented in `documentation/discovery/TASK-32-sescam-payload-strategy.md`. Tolerant parser scaffold landed in `lib/features/agenda/3_data/sescam/sescam_payload_parser.dart` with 4 strategies (json_object, json_array, line_separated, base64_envelope), typed error taxonomy (empty/unknownShape/partial/serverEnvelopeKo) and feature flag `kSescamLiveParsingEnabled = false`. 12 unit tests pass. Ticket marked Done — must be revisited as soon as a real preproduction sample is captured. AC1 satisfied as "documented request" (no preproduction credentials available in this run).
