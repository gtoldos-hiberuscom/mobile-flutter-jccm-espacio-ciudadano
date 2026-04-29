---
id: 73
jira_key: ""
type: Task
status: Done
priority: Medium
project: NAVEMP
epic_link: NAVEMP-2
parent: ""
sprint: ""
reporter: ""
assignee: Copilot
story_points: 1
labels: [auth, riverpod, domain]
fix_versions: []
affected_versions: []
created_at: "2026-04-29T01:32:00+02:00"
updated_at: "2026-04-29T01:40:00+02:00"
due_date: ""
jira_url: ""
---
# [TASK-73] Añadir Riverpod providers para LoginUseCase y LogoutUseCase

## Functional Description
Exponer `LoginUseCase` y `LogoutUseCase` como proveedores Riverpod para que la capa de presentación pueda consumirlos sin instanciarlos directamente.

## Acceptance Criteria
- [ ] Existe `lib/features/auth/3_data/auth_use_case_providers.dart` con providers `@riverpod` para `LoginUseCase` y `LogoutUseCase`.
- [ ] El archivo generado `auth_use_case_providers.g.dart` existe y está actualizado.
- [ ] Los providers están exportados desde el barrel `lib/features/auth/auth.dart`.
- [ ] `dart analyze lib/features/auth/` → 0 issues.
- [ ] Los tests existentes pasan sin modificación.

## Technical Details
### Approach
Crear `lib/features/auth/3_data/auth_use_case_providers.dart` con dos funciones `@riverpod`:
- `loginUseCaseProvider` — instancia `LoginUseCase(ref.watch(authRepositoryProvider))`
- `logoutUseCaseProvider` — instancia `LogoutUseCase(ref.watch(authRepositoryProvider))`

Los providers de use cases pertenecen a `3_data/` para mantener la restricción de que `1_domain/` no importe de `3_data/`.

### Dependencies
- Depends on: TASK-72 (AuthRepositoryProvider ya existe)

### Files
- CREATE: `lib/features/auth/3_data/auth_use_case_providers.dart`
- CREATE: `lib/features/auth/3_data/auth_use_case_providers.g.dart` (generated)
- MODIFY: `lib/features/auth/auth.dart` (barrel export)

## Traceability
- Epic: EPIC-2 (Identidad, sesión y consentimiento)
- Related: TASK-72 (auth feature migration)

## Notes
### Comments
- 2026-04-29T01:32:00+02:00 | by Copilot | Tarea creada como seguimiento de TASK-72. Los providers de use cases fueron identificados como siguiente paso natural tras la migración del feature de auth.
- 2026-04-29T01:40:00+02:00 | by Copilot | Implementation complete on task branch `task/EPIC-2-identity-session/TASK-73-use-case-providers/add-use-case-providers` (commit `7b2fb3e`). Merged into ticket branch then into `feat/auth_review`. Created `lib/features/auth/3_data/auth_use_case_providers.dart` with `@riverpod loginUseCaseProvider` and `logoutUseCaseProvider`; generated `auth_use_case_providers.g.dart`; exported from `auth.dart` barrel. dart analyze → 0 issues; 18/18 tests passing.

### Change Log
- 2026-04-29T01:32:00+02:00 | status | To Do → In Progress | by Copilot
- 2026-04-29T01:40:00+02:00 | status | In Progress → Done | by Copilot
