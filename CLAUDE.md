# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`jccm_espacio_ciudadano` ("Carpeta Ciudadana CLM") is a Flutter citizen-facing mobile app for JCCM (Junta de Comunidades de Castilla-La Mancha) digital services. Android + iOS. User-facing strings are Spanish; code/identifiers are English.

## Toolchain

- Flutter is pinned via **FVM** to `3.41.7` (`.fvmrc`). Local editor uses `.fvm/versions/3.41.7`. Use that SDK; prefer `fvm flutter ...` if FVM is installed, otherwise plain `flutter` against the pinned version.
- The app does **not** use `--dart-define`d secrets inline; runtime config comes from `config_*.json` files passed via `--dart-define-from-file` (see below). `AppConfig.fromEnvironment()` reads these and **throws** on any missing key — there are no defaults.

## Common commands

```bash
# Run / build (always pass an env config file)
flutter run --dart-define-from-file=config_development.json
flutter build apk --debug   --dart-define-from-file=config_development.json
flutter build apk --release --dart-define-from-file=config_development.json
flutter build appbundle --release --dart-define-from-file=config_production.json

# Configs: config_development.json | config_preproduction.json | config_production.json

# Analyze / lint (custom_lint + riverpod_lint are wired in)
flutter analyze
dart run custom_lint

# Tests
flutter test                         # default run; `backend` + `performance` tags are skipped by default
flutter test test/path/to/file_test.dart           # single file
flutter test --plain-name "description substring"   # single test by name
flutter test --tags performance      # opt-in performance budgets
flutter test --tags backend          # opt-in backend tests

# Regenerate the OpenAPI client (run INSIDE the generated package)
cd generated/dart_dio_client && dart run build_runner build --delete-conflicting-outputs

# Full clean rebuild (clean, pub get, pod install, codegen)
./build_full_runner.sh
```

CI (Jenkins) builds with `flutter build apk|appbundle --release --dart-define-from-file=<config>`; tests are opt-in via a `RUN_TESTS` param. See `Jenkinsfile`.

## Architecture

The contract is **`documentation/ARCHITECTURE.md`** — read the relevant section before changing a feature. Summary below; note where this repo's actual code diverges from the doc's examples.

### Layout

- `lib/core/` — global composition and shared infrastructure: `app/bootstrap.dart` (entrypoint wiring), `config/` (typed `AppConfig`), `network/` (Dio client + interceptors), `storage/` (secure + shared prefs), `routing/` (GoRouter, session guard, shell), `errors/` (`AppError` sealed hierarchy), `design_system/`, `security/` (biometrics), `connectivity/`, `logger/`, `accessibility/`.
- `lib/features/<feature>/` — each business module has the four mandatory layers, even if nearly empty:
  - `0_entity/` — immutable domain models, pure Dart (only `meta`'s `@immutable` allowed; no Flutter/Dio/JSON).
  - `1_domain/` — `usecases/`, `repositories/` (interfaces), `services/`, `domain.dart` barrel.
  - `2_presentation/` — `pages/`, `widgets/`, `controllers/`, `providers/`, `presentation.dart` barrel.
  - `3_data/` — `api/` (Dio wrappers + DTOs), `mappers/` (DTO↔entity), `repositories/` (impls), `data.dart` barrel.
- `lib/l10n/` — ARB localization (`app_es.arb` is the template; generates `AppLocalizations`, see `l10n.yaml`).
- `generated/dart_dio_client/` — OpenAPI-generated Dio client, package name `espacio_ciudadano_api` (generated from `fachada-sede-api-swagger.yaml`). It is a path dependency.

### Hard rules (enforced as architecture contract)

- **Dependencies point downward only**: `3_data → 1_domain → 0_entity`. Domain/data never import Flutter or `BuildContext`.
- **Features never import from `generated/`.** A feature's `3_data/api/` wraps the generated client; DTOs are mapped to entities in `3_data/mappers/` and **never leak outside `3_data/`**.
- **`2_presentation` may not import `3_data`** — with one exception: `2_presentation/providers/*.dart` is the DI seam and *is* allowed to import `3_data` to wire concrete impls to domain interfaces. Pages, widgets, and controllers use providers only.
- Use cases return **sealed result classes** (one `sealed`/`final` hierarchy per use case; see `LoadLifeEventsUsecase`), catching errors and returning them as values. Core failures use the `AppError` sealed types in `lib/core/errors/app_error.dart`. Raw backend/transport errors are never shown to the user.
- No business logic in notifier/controller constructors. Always re-check `ref.mounted` after `await`.
- Forbidden: global `lib/models|screens|services|repositories|widgets` or `lib/utils.dart`.

### State management — Riverpod 3

Uses `flutter_riverpod` 3 with `Notifier`/`AsyncNotifier` (no `StateNotifier`). `riverpod_lint` rules `missing_provider_scope` and `prefer_final_provider_parameters` are enabled. Tests override providers via `ProviderContainer`.

### Entities — IMPORTANT divergence from the doc

`pubspec.yaml` lists `freezed`/`json_serializable` and `ARCHITECTURE.md` shows freezed examples, but **the current `lib/` code uses hand-written immutable classes** (manual `==`, `hashCode`, `copyWith`) and **has no `.freezed.dart`/`.g.dart` files**. There is no `build_runner` in the root `pubspec.yaml`; codegen only runs for `generated/dart_dio_client`. Match the existing hand-written style in `0_entity/` unless told otherwise. (The doc also uses placeholder names like `navarra_empleo_api` / `hiberus_scaffold` from the scaffold it derives from — the real client is `espacio_ciudadano_api` and the package is `jccm_espacio_ciudadano`.)

### Networking & auth

Dio-based (`lib/core/network/`), config-driven base URL/timeout. Auth is OAuth/Cl@ve via `flutter_appauth` against a Keycloak SSO (`SSO_*` keys in the config files); tokens in `flutter_secure_storage`; biometric gate in `lib/core/security/`. Routing enforces sessions through `lib/core/routing/session_guard.dart`.

## Lint / formatter

- `analysis_options.yaml` is strict: `strict-casts`, `strict-inference`, `strict-raw-types`, plus a large explicit lint set (e.g. `always_declare_return_types`, `always_use_package_imports`, `avoid_dynamic_calls`). Use **package imports**, not relative.
- Formatter `page_width: 1024`, `trailing_commas: preserve`.

## Project conventions

- Jira project **`JCCMEC`** is the source of truth for tickets; identifiers use `JCCMEC-{n}` in branches/commits. Managed branch naming: `epic/<id>-<slug>`, `ticket/<epic>/<type-id>-<slug>`, `task/<epic>/<ticket>/<slug>` (lowercase ASCII, hyphenated). See `.github/copilot-instructions.md`.
- `tickets/` holds local EPIC/STORY/TASK markdown; `documentation/` holds ADRs and analysis docs.
- JSON entry points (the `config_*.json` files / `AppConfig`) must not rely on nullish-coalescing fallbacks — required values must be present, and missing keys throw.
