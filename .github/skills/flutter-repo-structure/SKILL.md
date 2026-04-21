---
name: flutter-repo-structure
description: >-
  Apply the Flutter canon for repository topology, app bootstrap, core
  capabilities, environment entrypoints, AppConfig, and dependency boundaries.
  Use when creating or refactoring lib/app, lib/core, lib/l10n, config/, or
  main_<env>.dart files.
---

Use this skill when the task affects repository topology, bootstrap, environment configuration, or shared code placement.

## Canon sources
Read these sections first:
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_index.md`
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_a.md` sections 4-10
- `documentation/architecture_canon_flutter_v2_docs/architecture_canon_flutter_v2_annex_d.md` sections 32, 34, 35, 36 when scaffolding or reviewing

## Required structure
- `lib/app/` is for composition only: bootstrap, config, routing, shell, theme, localization, observers.
- `lib/core/` is for shared infrastructure and cross-cutting capabilities.
- `lib/features/` is for business functionality.
- `lib/l10n/` is for localization assets.
- `config/` is the preferred place for environment definitions when the build consumes them.
- `documentation/architecture_canon_flutter_v2_docs/` is the active source of truth in this repository until the team relocates the canon.

## Placement rules
- Do not leave business code directly under `lib/`.
- Do not create top-level `lib/models`, `lib/screens`, `lib/services`, `lib/repositories`, `lib/widgets`, or `lib/utils.dart`.
- `app/` assembles the system; it does not own feature business logic.
- `core/` only hosts capabilities that are genuinely shared across features.
- Entry points and environment setup must stay explicit; do not hide startup logic in ad hoc helpers.

## Dependency rules
- `app -> core + features`
- `core -> external packages + internal shared utilities`
- `features -> core`
- Cross-feature access is limited to approved public contracts, never feature internals.

## Done checklist
- Every new file lives under the correct macrozone.
- Bootstrap, router, theme, localization, and config responsibilities remain explicit.
- No forbidden global folders or catch-all files were introduced.
- If the task changes repo defaults or stack decisions, require an ADR or an explicit user override.
