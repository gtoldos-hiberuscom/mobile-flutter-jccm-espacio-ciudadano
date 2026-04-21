---
id: 10
jira_key:
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
  - calidad
  - seguridad
  - observabilidad
  - testing
  - ci-cd
  - release-readiness
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-21T22:41:38+02:00
due_date:
jira_url:
---
# [EPIC-10] Calidad transversal, seguridad, observabilidad y release readiness
## Functional Description
Cubrir el trabajo no funcional necesario para entregar la aplicación con calidad, seguridad, trazabilidad, testing y pipeline de release alineados con el canon, incluyendo observabilidad, caché/offline, QA, CI/CD, performance y decisiones explícitas de PII y ADRs.

## Acceptance Criteria
- [ ] El epic cubre observabilidad, caché/offline, testing, QA, CI/CD, seguridad y performance.
- [ ] Se explicitan decisiones de PII, ADRs, budgets y validaciones finales.
- [ ] El epic sirve de pista de endurecimiento y cierre antes de entrega.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [EPIC-1]
  - Blocks:
    - [STORY-64]
    - [STORY-65]
    - [STORY-66]
    - [STORY-67]
    - [STORY-68]
    - [TASK-69]
    - [TASK-70]
  - Related to:
    - [EPIC-2]
    - [EPIC-3]
    - [EPIC-4]
    - [EPIC-5]
    - [EPIC-6]
    - [EPIC-7]
    - [EPIC-8]
    - [EPIC-9]
- Hardening scope:
  - Observabilidad, analytics y logging con redacción de PII.
  - Estrategia de caché/offline, retry y resiliencia.
  - Pirámide de testing, QA funcional/accesibilidad y regresión visual.
  - Pipeline CI/CD, checklists de release y budgets de performance.
- Governance expectations:
  - Inventario PII, decisiones ADR y excepciones al canon.
  - Evidencias de validación final antes de promoción a release.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §§21-29
  - annex_d checklists
  - PLANIFICACION_PROYECTO.md fase 8
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 13
- Provisional hierarchy:
  - Children:
    - [STORY-64]
    - [STORY-65]
    - [STORY-66]
    - [STORY-67]
    - [STORY-68]
    - [TASK-69]
    - [TASK-70]
- Dependency map:
  - Blocked by [EPIC-1].
  - Related to todos los epics funcionales activos, de [EPIC-2] a [EPIC-9].
  - Centraliza el endurecimiento transversal previo a la entrega.

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
