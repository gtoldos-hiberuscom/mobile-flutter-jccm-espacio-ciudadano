---
id: 21
jira_key:
type: Task
status: Done
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint: Sprint 2
reporter:
assignee:
story_points:
labels:
  - auth
  - jwt
  - federation
  - discovery
  - api-contract
fix_versions: []
affected_versions: []
created_at: 2026-04-21T22:41:38+02:00
updated_at: 2026-05-04T12:00:00+02:00
due_date:
jira_url:
---
# [TASK-21] Validar claims JWT, idAgente y parámetros federados obligatorios
## Functional Description
Obtener o formalizar la matriz real de claims/parámetros necesarios para Cl@ve, servicios federados, hechos vitales y firma.

## Acceptance Criteria
- [x] Se documentan claims necesarios para servicios federados, firma e idAgente.
- [x] Se identifican faltantes, fallback y comportamiento cuando el token no contiene datos esperados.
- [x] Se dejan trazadas las dependencias bloqueadas por falta de formalización.
- [x] Se vincula el resultado con recomendaciones, hechos vitales y firma.

## Technical Details
- Platform(s): Multi-platform
- Environment: development, preproduction, production
- Dependencies:
  - Blocked by:
    - [TASK-16]
    - [STORY-18]
  - Blocks:
    - [STORY-45]
    - [STORY-54]
    - [STORY-56]
  - Related to:
    - [EPIC-2]

## Traceability
- Jira:
- Epic:
- Parent:
- Sources:
  - DOCUMENTO_COMPRENSION_FUNCIONAL.md S2/N6 y S1/N10
  - MAPEO_ENDPOINTS_PANTALLAS.md integración Cl@ve
  - RESUMEN_FUNCIONALIDADES_PPT.md sección 12
- Provisional hierarchy:
  - Epic candidate: [EPIC-2]
- Dependency map:
  - Blocked by [TASK-16] y [STORY-18].
  - Blocks [STORY-45], [STORY-54] y [STORY-56].

## Notes
### Comments
- 2026-05-01 | by Copilot | Implementation gate deliverables committed on branch `task/EPIC-2-identity-session/TASK-21-jwt-claims-validation/validate-jwt-claims` (commit 165635f). Created: `docs/architecture/TASK-21-jwt-claims-validation.md` (claims contract, fallback strategy, validation checklist, ADR §7.1), `lib/core/auth/jwt_claims.dart` (JwtClaims value class with idAgente/displayName/isExpired/validateAudience), `lib/core/auth/jwt_decoder.dart` (pure Dart Base64Url decoder, no signature verification by design), and TASK-21 annotation comment in `lib/features/auth/3_data/auth_repository_impl.dart`. `dart analyze lib/core/auth/` reports 0 errors. Dependent stories STORY-18 and STORY-45 remain blocked pending Section 6 checklist confirmations (Cl@ve sandbox registration, nif/idAgente claim name, token endpoint URL).
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Implementation merged to `develop`. Evidence reconciled: `docs/architecture/TASK-21-jwt-claims-validation.md` (federation/idAgente/firma claim contract, fallbacks and traceability to recommendations, hechos vitales and firma), `lib/core/auth/jwt_claims.dart`, `lib/core/auth/jwt_decoder.dart`, and the TASK-21 annotation in `lib/features/auth/3_data/auth_repository_impl.dart`. Implementing commit: `165635f`. Note: dependent STORY-45, STORY-54 and STORY-56 remain gated on Cl@ve sandbox confirmation per the prior comment.

### Change Log
- 2026-04-21T22:41:38+02:00 | by Copilot | Initial file creation.
- 2026-05-01T00:00:00+02:00 | by Copilot | Status transitioned from `To Do` → `In Progress`.
- 2026-05-04T12:00:00+02:00 | by ticket-manager | Sprint set to `Sprint 2`; status transitioned from `In Progress` → `Done` after reconciling against merged implementation on `develop`.
