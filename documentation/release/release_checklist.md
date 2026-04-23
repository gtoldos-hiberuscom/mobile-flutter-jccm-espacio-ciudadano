# Release checklist — jccm_espacio_ciudadano

> **Status:** Sprint 2 baseline scaffold. Each section below is the minimum
> contract for the release-readiness flow and will be expanded in later sprints
> (STORY-66, STORY-67, TASK-69, TASK-70 and the post-baseline release tickets).

## 1. Pre-release verification

_Sprint 2 baseline — to be expanded in later sprints._

- [ ] `flutter analyze --no-fatal-infos` is green on the release commit.
- [ ] `flutter test` is green on the release commit.
- [ ] Codegen is clean: `scripts/verify_codegen.sh` exits 0 (no diff after
      `dart run build_runner build --delete-conflicting-outputs`).
- [ ] Localization ARBs are in sync: every key present in `lib/l10n/app_en.arb`
      has a translation in the rest of the catalog.
- [ ] No `TODO`, `FIXME` or `print(` left in the code paths touched by the release.

## 2. Environment promotion (development → preproduction → production)

_Sprint 2 baseline — to be expanded in later sprints._

- [ ] Build with `main_development.dart` and smoke-test against `config_development.json`.
- [ ] Promote to `main_preproduction.dart` + `config_preproduction.json` and re-validate.
- [ ] Promote to `main_production.dart` + `config_production.json` and re-validate.
- [ ] Capture promotion evidence (build id + environment + tester) before signing off.

## 3. Versioning

_Sprint 2 baseline — to be expanded in later sprints._

- [ ] `pubspec.yaml` `version:` bumped following SemVer (`MAJOR.MINOR.PATCH+BUILD`).
- [ ] Git tag created in the form `vX.Y.Z` on the release commit.
- [ ] Release branch protection / approval enforced before tagging.

## 4. Changelog

_Sprint 2 baseline — to be expanded in later sprints._

- [ ] [`CHANGELOG.md`](../../CHANGELOG.md) updated following Keep a Changelog.
- [ ] `## [Unreleased]` section reorganized into a versioned section with date.
- [ ] Each entry references the originating ticket id (`STORY-…`, `TASK-…`, `BUG-…`).

## 5. Release evidence

_Sprint 2 baseline — to be expanded in later sprints._

- [ ] Link to the green CI run (GitHub Actions URL) attached to the release ticket.
- [ ] Manual smoke checklist executed and signed (login, home, perfil, ayuda, legal, mapa web).
- [ ] PII / security checklist re-checked against the latest TASK-69 inventory.
- [ ] Performance budgets re-checked against the latest TASK-70 thresholds.
- [ ] Release ticket transitioned to Done with the evidence attached.

---

### Deferred to later sprints

- Build artifact upload (APK / AAB / IPA) and store deploy automation.
- Signed builds and credential management.
- Integration / golden / e2e suites.
- Coverage report publishing and threshold enforcement.
- Automated changelog/tag generation from commits.

These items are tracked under STORY-66, STORY-67, TASK-69, TASK-70 and the
release-automation tickets that will be opened after the Sprint 2 baseline.
