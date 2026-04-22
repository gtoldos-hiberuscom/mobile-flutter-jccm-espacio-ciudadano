---
id: 68
jira_key:
type: Story
status: In Progress
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
reporter:
assignee:
story_points:
labels:
  - ci-cd
  - release
  - codegen
  - entornos
  - checklist
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-22T07:20:32Z
due_date:
jira_url:
---
# [STORY-68] CI/CD, verificación de codegen, entornos y checklist de release
## Functional Description
Definir el pipeline mínimo y la checklist de salida para builds, tests, versiones y promoción de entornos, asegurando evidencia de validación previa a release y control explícito sobre análisis estático, codegen y suites relevantes.

## Acceptance Criteria
- [ ] Se contemplan análisis estático, verificación de generación de código y ejecución de suites de tests relevantes.
- [ ] Se contemplan entornos development/preproduction/production y su promoción.
- [ ] Se contempla versionado, changelog, tagging y checklist de entrega.
- [ ] Se contempla evidencia de validación previa a release.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-64]
    - [STORY-66]
    - [STORY-67]
    - [TASK-69]
    - [TASK-70]
  - Blocks:
    - None.
  - Related to:
    - [EPIC-10]
- Release scope:
  - Pipeline mínimo con análisis estático, verificación de codegen y tests.
  - Gestión de entornos development/preproduction/production y su promoción.
  - Versionado, tagging, changelog y checklist de salida.
  - Evidencia auditable de validación previa a release.
- Release governance:
  - Debe incorporar decisiones de seguridad/PII de [TASK-69].
  - Debe incorporar budgets y validaciones de rendimiento de [TASK-70].

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_c §27
  - annex_d §§32-34 y 36
  - PLANIFICACION_PROYECTO.md fases 1 y 8
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-64], [STORY-66], [STORY-67], [TASK-69] y [TASK-70].
  - Sin descendientes explícitos en este corte.
  - Cierra la pista de release readiness del epic [EPIC-10].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-22T07:20:32Z | status | To Do -> In Progress | by Copilot | 4 GitHub Actions workflows created and committed on task/EPIC-10-quality-security/STORY-68-cicd-pipeline/implement-cicd (commit c83dde8): ci.yml, release.yml, pr_quality.yml, dependency_review.yml.
