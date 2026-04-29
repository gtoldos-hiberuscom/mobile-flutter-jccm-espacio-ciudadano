---
id: 65
jira_key:
type: Story
status: In Progress
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 7
reporter:
assignee:
story_points:
labels:
  - cache
  - offline
  - conectividad
  - resiliencia
  - retry
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-04-29T14:34:17+00:00
due_date:
jira_url:
---
# [STORY-65] Caché, offline, conectividad, retry y resiliencia de datos
## Functional Description
Definir la estrategia de resiliencia transversal para red inestable, datos estáticos y flujos con refresh, estableciendo políticas de caché, offline, retry y fallback diferenciadas según sensibilidad y volatilidad de la información.

## Acceptance Criteria
- [ ] Se contempla caché razonable por módulos y contenido estático offline.
- [ ] Se contemplan reintentos, pull-to-refresh y detección de conectividad.
- [ ] Se contemplan políticas diferenciadas para datos sensibles y no sensibles.
- [ ] Se contemplan fallback states para módulos con contratos externos inestables.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [STORY-12]
    - [STORY-15]
    - [TASK-69]
  - Blocks:
    - [STORY-67]
  - Related to:
    - [EPIC-10]
- Resilience scope:
  - Estrategia de caché por módulo y disponibilidad offline de contenido estático.
  - Detección de conectividad, retry y pull-to-refresh.
  - Políticas diferenciadas para datos sensibles frente a datos consultivos.
  - Estados fallback para integraciones o contratos externos inestables.
- Security and data considerations:
  - Las restricciones de PII y almacenamiento seguro se coordinan con [TASK-69].
  - Debe contemplarse refresh y expiración adecuados según tipo de dato.

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - annex_b estrategia de datos/caché
  - annex_c §25
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 13
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md R4
- Provisional hierarchy:
  - Epic candidate: [EPIC-10]
- Dependency map:
  - Blocked by [STORY-12], [STORY-15] y [TASK-69].
  - Blocks [STORY-67].
  - Define la resiliencia transversal y disponibilidad degradada del epic [EPIC-10].

## Notes
### Comments
- None yet.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-04-29T14:34:17+00:00 | by plan-manager | Sprint 7 (SP-EC-APP-SQ3-07): To Do → In Progress. Wave 1 — core resilience primitives landed on `task/EPIC-10-quality-release/STORY-65-resilience/core-primitives`: `lib/core/connectivity/connectivity_status.dart` (connectivity_plus 6.x stream), `lib/core/connectivity/offline_banner.dart`, `lib/core/network/retry_policy.dart` (exp-backoff + jitter, idempotent methods only, wired into `api_client.dart` behind `kResilienceLayerEnabled`), `lib/core/cache/ttl_cache.dart` + provider. Adopters matrix in `documentation/qa/resilience-adopters.md`. 14 unit tests added under `test/core/{cache,connectivity,network}`.
