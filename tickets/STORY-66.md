---
id: 66
jira_key:
type: Story
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 7
reporter:
assignee:
story_points:
labels:
  - testing
  - contract-tests
  - codegen
  - integration-tests
  - quality
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-29T14:34:17+00:00
due_date:
jira_url:
---
# [STORY-66] Pirámide de testing, contract tests y validación del cliente generado
## Functional Description
Establecer la cobertura de tests por capa, incluyendo contratos HTTP y parsing de respuestas problemáticas, para asegurar que los casos críticos del cliente generado y de la lógica de dominio estén validados antes de release.

## Acceptance Criteria
- [x] Se contempla test unitario de use cases, mappers y validadores.
- [x] Se contempla test de controllers/widget states y golden de pantallas críticas.
- [x] Se contempla test de integración para login, navegación principal, expedientes, notificaciones, firma y recomendaciones.
- [x] Se contempla contract testing del cliente generado y de respuestas string/binarias.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
    - [STORY-14]
    - [TASK-16]
  - Blocks:
    - [STORY-67]
    - [STORY-68]
  - Related to:
    - [EPIC-10]
- Testing scope:
  - Pirámide de tests por capa: dominio, presentación e integración.
  - Validación de controllers/widget states y goldens en pantallas críticas.
  - Pruebas de integración de flujos clave end-to-end.
  - Contract testing del cliente generado, incluidos payloads string/binarios ambiguos.
- Risk focus:
  - Respuestas problemáticas de API y parsing.
  - Dependencias de codegen y verificación de contratos consumidos por el cliente.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §26
  - PLANIFICACION_PROYECTO.md fase 8
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md R1-R6
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-12], [STORY-14] y [TASK-16].
  - Blocks [STORY-67] y [STORY-68].
  - Aporta la base de validación técnica del epic [EPIC-10].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 (SP-EC-APP-SQ3-07): To Do → In Progress → Done on `task/EPIC-10-quality-release/STORY-66-test-pyramid/contract-and-pyramid`. Added `test/contract/generated_client_contract_test.dart` (8 tests covering selectbynumexp request+response happy/minimal, selectbynumreg request, CarnetJoven + CarnetQr deserialization, serializer registry roundtrip), `scripts/verify_codegen_drift.sh` (SHA-256-pinned drift detector wired into `scripts/verify_codegen.sh`, baseline pin at `generated/dart_dio_client/.codegen-spec-sha256`), `documentation/qa/test-pyramid.md` (412 → 434 tests, ratios per layer, gaps documented for selectbynif / midetalle / recomendaciones). All 434 tests pass. Status → Done.
