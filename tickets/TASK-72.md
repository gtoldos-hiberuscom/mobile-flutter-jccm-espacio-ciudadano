---
id: 72
jira_key: TASK-72
type: Task
status: In Progress
priority:
project: Carpeta Ciudadana CLM
epic_link:
parent:
sprint:
reporter:
assignee:
story_points:
labels: ["auth", "refactor", "feature-migration", "use-cases", "clave"]
fix_versions: []
affected_versions: []
created_at: 2026-04-29T00:43:51+02:00
updated_at: 2026-04-29T00:43:51+02:00
due_date:
jira_url:
---

# [TASK-72] Migrar lib/core/auth a lib/features/auth y crear LoginUseCase y LogoutUseCase

## Functional Description

La infraestructura de autenticación con Cl@ve reside actualmente en `lib/core/auth/` como dos ficheros (`clave_auth_remote_datasource.dart` y `clave_auth_remote_datasource_provider.dart`). Este task mueve ese código al módulo de feature de autenticación (`lib/features/auth/`) siguiendo la estructura canónica `0_entity / 1_domain / 3_data` del proyecto.

Además se crean los casos de uso `LoginUseCase` y `LogoutUseCase` en la capa de dominio, se expone la interfaz de repositorio `AuthRepository` como contrato de dominio, y se extrae una implementación de repositorio `AuthRepositoryImpl` que mapea los DTOs de Cl@ve a entidades de dominio limpias.

## Acceptance Criteria

- [ ] `lib/core/auth/` queda vacío (solo `.gitkeep`); los dos ficheros Dart originales se eliminan.
- [ ] La feature `lib/features/auth/` existe con estructura canónica: `0_entity/`, `1_domain/`, `3_data/`.
- [ ] `0_entity/auth_failure.dart` contiene `AuthFailureReason` (enum) y `AuthException` (renombrado desde `ClaveAuthException`) como tipo de fallo de dominio, con mensajes genéricos sin referencias a proveedor.
- [ ] `0_entity/auth_session.dart` contiene `AuthSession` como entidad de dominio limpia del resultado de autenticación.
- [ ] `0_entity/auth_user.dart` contiene `AuthUser` como entidad de dominio limpia de información del usuario.
- [ ] `1_domain/auth_repository.dart` define `abstract interface class AuthRepository` con métodos `login`, `logout`, `refreshToken`, `fetchUserInfo`. La constante `defaultScopes` (=['openid']) vive en este fichero.
- [ ] `1_domain/login_use_case.dart` contiene `LoginUseCase` que delega a `AuthRepository.login()` y retorna `AuthSession`.
- [ ] `1_domain/logout_use_case.dart` contiene `LogoutUseCase` que delega a `AuthRepository.logout()` y retorna `void`.
- [ ] `3_data/` contiene: DTOs (`ClaveTokenResponseDto`, `ClaveUserInfoDto`), datasource (interface + impl), provider del datasource, `AuthRepositoryImpl` con mapeo DTO→entidad, y provider de `AuthRepository`.
- [ ] Los DTOs no se filtran fuera de `3_data/`.
- [ ] `dart analyze lib/features/auth/` devuelve 0 errores.
- [ ] El test existente en `test/core/auth/` se mueve a `test/features/auth/` con imports actualizados.
- [ ] Se añaden tests de `LoginUseCase` y `LogoutUseCase`.
- [ ] `flutter test test/features/auth/` pasa sin errores.

## Technical Details

- **Platform(s):** Multi-platform
- **Environment:** development, preproduction, production
- **Branch:** `task/EPIC-2-identity-session/TASK-72-auth-feature-migration/migrate-auth-to-feature`

### Dependencies

- Blocked by:
  - [STORY-18]
- Blocks:
  - none (infrastructure task)
- Related to:
  - [EPIC-2]
  - [STORY-18]
  - [TASK-21]

### Files Affected

| Action | Path |
|--------|------|
| DELETE | `lib/core/auth/clave_auth_remote_datasource.dart` |
| DELETE | `lib/core/auth/clave_auth_remote_datasource_provider.dart` |
| CREATE | `lib/features/auth/auth.dart` |
| CREATE | `lib/features/auth/0_entity/auth_session.dart` |
| CREATE | `lib/features/auth/0_entity/auth_user.dart` |
| CREATE | `lib/features/auth/0_entity/auth_failure.dart` |
| CREATE | `lib/features/auth/1_domain/auth_repository.dart` |
| CREATE | `lib/features/auth/1_domain/login_use_case.dart` |
| CREATE | `lib/features/auth/1_domain/logout_use_case.dart` |
| CREATE | `lib/features/auth/3_data/clave_auth_remote_datasource.dart` |
| CREATE | `lib/features/auth/3_data/clave_auth_remote_datasource_provider.dart` |
| CREATE | `lib/features/auth/3_data/clave_token_response_dto.dart` |
| CREATE | `lib/features/auth/3_data/clave_user_info_dto.dart` |
| CREATE | `lib/features/auth/3_data/auth_repository_impl.dart` |
| CREATE | `lib/features/auth/3_data/auth_repository_provider.dart` |
| MOVE | `test/core/auth/clave_auth_remote_datasource_test.dart` → `test/features/auth/` |

## Traceability

- **Jira:**
- **Epic:**
- **Parent:**
- **Sources:**
  - `lib/core/auth/clave_auth_remote_datasource.dart`
  - `lib/core/auth/clave_auth_remote_datasource_provider.dart`
  - `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_b.md` §11-12
- **Related to:** [EPIC-2], [STORY-18], [TASK-21]

## Notes

### Comments

- 2026-04-29T00:43:51+02:00 | by Copilot | Task created. Implementation started on `feat/auth_review`. Task branch: `task/EPIC-2-identity-session/TASK-72-auth-feature-migration/migrate-auth-to-feature`.

### Change Log

- 2026-04-29T00:43:51+02:00 | by Copilot | Initial ticket creation. Status: In Progress.
