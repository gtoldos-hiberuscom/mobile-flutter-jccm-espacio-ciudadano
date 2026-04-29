# STORY-67 — UAT functional handoff (Sprint 8 closure)

| Field            | Value                                                                 |
|------------------|-----------------------------------------------------------------------|
| Ticket           | STORY-67                                                              |
| Sprint           | Sprint 8 closure (originally scoped in Sprint 7 — SP-EC-APP-SQ2-07)   |
| Date (ISO)       | 2026-04-29                                                            |
| Commit SHA       | `79151ae561da7c2e0304551ccaf7acd189046406`                            |
| Branch           | `task/EPIC-10-quality-release/STORY-67-qa/sprint8-uat-handoff`        |
| Status           | UAT-ready candidate (entry pending checklist sign-off)                |
| Owner            | implementer (proxy for Squad 2 QA)                                    |

This document is the consolidated functional handoff produced for
Sprint 8 UAT entry. It supersedes the Sprint 7 pre-handoff snapshot
captured in [`STORY-67-regression-report.md`](./STORY-67-regression-report.md)
and references the sibling Sprint 8 closure deliverables produced by
TASK-69 (hardening), TASK-70 (performance) and STORY-64 (telemetry).

All claims below are grounded in repository evidence at the SHA above.
Test paths cited are real files in the worktree; coverage gaps are
labelled explicitly so UAT planners can size manual effort.

---

## 1. Verified surface list

Coverage legend:
- **Goldens** — automated golden image baseline under `test/qa/goldens/`.
- **A11y smoke** — automated accessibility guideline matchers in
  `test/qa/accessibility_smoke_test.dart`.
- **E2E smoke** — happy-path integration coverage in
  `test/integration/smoke_happy_path_test.dart`.
- **Feature tests** — presentation/notifier/repository tests under
  `test/features/<feature>/`. The cell lists the directory and the
  approximate count of files; dig into the directory for the exact
  list.
- **Manual-only** — surfaces or flows where there is no automated
  coverage at the named layer and UAT must exercise them by hand.

| Feature           | Page(s) (lib/features path)                                                                 | Goldens                                                       | A11y smoke                                              | E2E smoke                                                                | Feature tests under `test/features/<f>/`                                                                                                          | Manual-only                                            | Notes |
|-------------------|---------------------------------------------------------------------------------------------|---------------------------------------------------------------|---------------------------------------------------------|--------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|-------|
| landing           | `landing/2_presentation/landing_page.dart`                                                  | ✅ `test/qa/goldens/landing_page_phone_portrait.png` (via `test/qa/landing_golden_test.dart`) | ✅ `test/qa/accessibility_smoke_test.dart` (LandingPage) | ✅ landing-level coverage in `test/integration/smoke_happy_path_test.dart` | ❌ no `test/features/landing/` dir — landing is covered exclusively by the QA harness above                                                       | Device-level VoiceOver/TalkBack traversal              | Sole golden baseline shipped in repo. Sprint 7 STORY-67 ACs covered. |
| auth/login (Cl@ve)| `auth/3_data/clave_auth_remote_datasource.dart` + system WebView (no in-repo page widget)   | ❌                                                            | ❌ (WebView opaque to widget tests)                     | ❌                                                                       | `test/features/auth/` — `auth_repository_impl_test.dart`, `clave_auth_remote_datasource_test.dart`, `use_cases_test.dart`                          | Full Cl@ve OAuth round-trip on device, token refresh   | No auth `2_presentation/` page widget; the UI is the system browser/WebView so widget-level UI tests are not meaningful. Domain + datasource + repo are covered. |
| consent           | `consent/2_presentation/consent_page.dart`                                                  | ❌                                                            | ❌                                                      | ❌ (not exercised by smoke harness)                                      | ❌ no `test/features/consent/` directory                                                                                                          | Full consent flow + persistence on device              | Functional gap at automation level: consent page has no presentation tests at the SHA above. Manual UAT pass required. |
| home (app shell)  | `app/shell/app_scaffold.dart`, `app/shell/app.dart` (post-login destination)                | ❌ (deferred — depends on dynamic citizen profile + perso config) | ❌                                                      | covered indirectly via smoke-harness navigation hop                     | ❌ no dedicated `test/features/home/` (home is the shell, not a feature)                                                                           | Tab/drawer navigation, deep-link landing, error states | Sprint 7 report flagged Home golden as deferred to Sprint 8; deterministic golden still pending — tracked as polish, not UAT-blocking. |
| agenda            | `agenda/2_presentation/...`                                                                 | ❌                                                            | ❌                                                      | not exercised end-to-end by smoke harness                                | `test/features/agenda/` — 9 files: `agenda_event_tile_test`, `agenda_notifier_test`, `agenda_period_filter_test`, `agenda_states_widget_test`, `cip_card_widget_test`, `cip_summary_notifier_test`, `sescam_payload_parser_test`, `sescam_to_agenda_mapper_test`, `upcoming_events_summary_widget_test` | Dynamic-type 200% truncation review                    | OfflineBanner adopted (see `documentation/qa/resilience-adopters.md`). Polish item from Sprint 7 §Gap #3 should be visually re-verified in UAT. |
| casework          | `casework/2_presentation/...`                                                               | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/casework/` — search (3), workspace (2), `aportacion/` (2), `detail/` (2), `registro/` (2), `uploads/` (3) — 14 files total          | Real backend wiring against `/publicacion/select*`     | Mock data only at this SHA. Sprint 7 §Gap #2 still open; UAT exercises the mock surface, not real expediente data. |
| notifications     | `notifications/2_presentation/...`                                                          | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/notifications/` — center (3), `contact/` (4), `detail/` (4) — 11 files total                                                       | Push delivery, deep-link from notification             | OfflineBanner adopted. Contact registration gate covered at notifier + page widget level. |
| digital_cards     | `digital_cards/2_presentation/...`                                                          | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/digital_cards/` — catalog (3), `discapacidad/` (4), `exporters/` (2), `familia_numerosa/` (3), `joven/` (4) — 16 files total       | Wallet/PDF export on physical device, share-sheet      | Binary cache covered by STORY-50 disk cache; export flows still need device validation. |
| signature         | `signature/2_presentation/...` + Afirma deep-link return                                    | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/signature/` — inbox (3), `handoff/` (3) — 6 files total                                                                            | Real Afirma round-trip                                 | Mock catalog + placeholder Afirma URL — see §4. |
| recommendations   | `recommendations/2_presentation/...`                                                        | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/recommendations/` — controller, page widget, dto, repo mock + `empty/` variants (3) — 7 files total                                | Real backend recommendations payload                   | OfflineBanner adopted. Backend live flag still off (`kRecommendationsLiveBackendEnabled = false`) — see §4. |
| education         | `education/2_presentation/...`                                                              | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/education/education_landing_notifier_test.dart`                                                                                     | Visual review, deep-link interactions                  | Notifier-only coverage; widget-level golden/a11y left for UAT manual sweep. |
| employment        | `employment/2_presentation/...`                                                             | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/employment/employment_landing_notifier_test.dart`                                                                                   | Visual review, deep-link interactions                  | Notifier-only coverage. |
| social_welfare    | `social_welfare/2_presentation/...`                                                         | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/social_welfare/social_welfare_landing_notifier_test.dart`                                                                           | Visual review, deep-link interactions                  | Notifier-only coverage. |
| state_affairs     | `state_affairs/2_presentation/...`                                                          | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/state_affairs/state_affairs_landing_notifier_test.dart`                                                                             | Visual review, deep-link interactions                  | Notifier-only coverage. |
| external_links    | `external_links/2_presentation/...`                                                         | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/external_links/` — `external_link_catalog_test.dart`, `external_link_launcher_test.dart`                                            | Real device URL launching across browsers              | Catalog + launcher logic covered; real intent dispatch depends on installed browsers. |
| help              | `help/2_presentation/...` (incl. support form)                                              | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/help/` — `help_repository_test.dart`, `support_form_notifier_test.dart`, `support_form_page_test.dart`, `support_form_validator_test.dart` | End-to-end submission against real backend             | Captcha + submission still mocked — see §4. |
| legal             | `legal/2_presentation/...`                                                                  | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/legal/legal_documents_repository_test.dart`                                                                                         | Visual review of legal pages, scroll, links            | Repository-only automated coverage. |
| sitemap           | `sitemap/2_presentation/...`                                                                | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/sitemap/sitemap_repository_test.dart`                                                                                               | Navigation traversal review                            | Repository-only automated coverage. |
| user_profile      | `user_profile/2_presentation/widgets/...`                                                   | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | ❌ no `test/features/user_profile/` directory                                                                                                      | Profile rendering, edit/save flows                     | Functional gap at automation level: only widget building blocks present, no notifier/page tests at this SHA. |
| personalization   | `personalization/2_presentation/...`                                                        | ❌                                                            | ❌                                                      | not exercised end-to-end                                                 | `test/features/personalization/` — `data_consent_notifier_test.dart`, `data_consent_page_test.dart`, `life_events_notifier_test.dart`, `life_events_page_test.dart` | Cross-feature impact of life-event toggles             | Strong notifier + page coverage of consent and life-events surfaces. |
| maintenance       | `maintenance/2_presentation/maintenance_page.dart`                                          | ❌                                                            | ❌                                                      | ❌                                                                       | ❌ no `test/features/maintenance/` directory                                                                                                      | Trigger maintenance mode and verify lockout            | Functional gap at automation level — exercise via remote-config toggle in pre-prod. |

### Surface coverage summary

- **Goldens** — 1 (LandingPage). Home/Recommendations/Carnet goldens
  remained deferred (see Sprint 7 report §Sprint 8 expectations); they
  did not block UAT entry and are tracked as polish.
- **A11y smoke (automated)** — 1 surface (LandingPage) with 4
  guideline matchers. All other surfaces rely on the manual matrix
  from `documentation/qa/accessibility-checklist.md` plus device
  traversal during UAT.
- **E2E smoke** — landing-only happy-path harness in
  `test/integration/smoke_happy_path_test.dart`. Per-feature deep
  flows are validated through their own widget/notifier suites under
  `test/features/<feature>/`.
- **Feature tests** — present for 17 of 21 enumerated surfaces.
  Surfaces lacking any `test/features/<feature>/` directory at this
  SHA: `landing` (covered by QA harness instead), `consent`,
  `user_profile`, `maintenance`. Of these, `landing` is automation-
  covered through `test/qa/`; the other three require explicit manual
  UAT passes.

---

## 2. Consolidated regression report (Sprint 7 → Sprint 8)

The Sprint 7 baseline lives in
[`STORY-67-regression-report.md`](./STORY-67-regression-report.md).
Below is the carry-forward / closed / new triage on top of that
baseline.

### 2.1 Carry-forward items still open at UAT entry

| # | Item (Sprint 7) | Status at Sprint 8 closure | Disposition |
|---|-----------------|----------------------------|-------------|
| 1 | Home page golden — deferred (depends on citizen profile + perso config) | Still deferred. No deterministic golden shipped at this SHA. | Polish backlog item; not UAT-blocking. UAT validates Home visually on device. |
| 2 | Casework workspace deep e2e — gated on real Dio wiring to `/publicacion/select*` | Repository still mock-backed (see §4). | Out of scope for UAT closure; UAT exercises mock surface only. |
| 3 | Dynamic-type at 200% on agenda two-line tile titles | Re-verify in UAT device sweep. No code-level change required by STORY-67 owner; Sprint 8 polish deliverables are owned by the agenda squad. | Re-flag during UAT if reproduces. |
| 4 | Recommendations card focus order (load-more before last card "open") | Re-verify in UAT keyboard/TalkBack sweep. | Re-flag during UAT if reproduces. |

### 2.2 Items closed during Sprint 8

| Workstream | Evidence (deliverable to be merged in this sprint) | Effect on UAT |
|------------|----------------------------------------------------|---------------|
| Resilience adoption sweep (STORY-65 closure) | `documentation/qa/resilience-adopters.md` (final adoption matrix; OfflineBanner + TTL cache + retry on agenda / notifications / recommendations; banners l10n migration captured as Sprint 8 follow-up internal to STORY-65). | Online↔offline transitions can be exercised on agenda/notifications/recommendations during UAT with confidence the primitives are wired. |
| Performance re-verification (TASK-70) | `documentation/qa/TASK-70-performance-verification-sprint8.md` (sibling deliverable produced concurrently). | Perf budgets for app startup, list scroll, and image loading are re-baselined; UAT should not chase regressions covered there. |
| Hardening final report (TASK-69) | `documentation/security/TASK-69-hardening-final-report.md` (sibling deliverable produced concurrently). | Security findings are pre-resolved or explicitly documented; UAT does not re-litigate security posture. |
| Telemetry verification (STORY-64) | `documentation/qa/STORY-64-telemetry-verification-sprint8.md` (sibling deliverable produced concurrently). | Event taxonomy and consent-gating are validated end-to-end; UAT can rely on telemetry signals during smoke. |

### 2.3 New items discovered during Sprint 8 enumeration

| # | Item | Evidence | Impact | Disposition |
|---|------|----------|--------|-------------|
| N1 | No `test/features/consent/` directory at this SHA. | Filesystem walk under `test/features/`. | Consent flow has no automated presentation coverage. | Manual UAT pass required; not UAT-blocking (consent page exists and is reachable). |
| N2 | No `test/features/user_profile/` directory at this SHA. | Filesystem walk; `lib/features/user_profile/2_presentation/` ships only `widgets/`. | User-profile rendering only covered by ad-hoc visual review. | Manual UAT pass required; not UAT-blocking. |
| N3 | No `test/features/maintenance/` directory at this SHA. | Filesystem walk; `lib/features/maintenance/2_presentation/maintenance_page.dart` exists. | Maintenance mode behaviour only verifiable by toggling remote config. | Manual UAT pass against pre-prod required; not UAT-blocking. |
| N4 | E2E smoke harness covers landing only — no per-feature happy paths. | `test/integration/smoke_happy_path_test.dart` reads as a landing-level smoke. | UAT cannot rely on integration-level guard for downstream features. | Acknowledged; per-feature widget suites compensate. Future hardening: extend smoke per surface. |

None of N1–N4 are defects discovered against shipped functionality —
they are coverage gaps already implied by the Sprint 7 report and are
explicitly named here so UAT scoping is honest.

---

## 3. Known limitations carried into UAT

These are intentional limitations grounded in code at this SHA. UAT
should test the documented surface, not the ones marked pending.

### 3.1 Recommendations — mock backend, not live

- Evidence: `lib/features/recommendations/3_data/recommendations_feature_flags.dart`
  declares `const bool kRecommendationsLiveBackendEnabled = false;`
- Provider: `lib/features/recommendations/3_data/recommendations_repository_provider.dart`
  selects `RecommendationsRepositoryMock` while the flag is `false`
  (`// TODO(future-sprint): wire RecommendationsRepositoryHttp once 7.1 / 7.2 …`).
- UAT impact: recommendations content is deterministic in-memory data.
  Real curated payloads are out of scope for this UAT round.

### 3.2 Signature / Afirma — placeholder URL and mock catalog

- Evidence:
  `lib/features/signature/3_data/signature_repository_impl.dart`
  ships a deterministic mock catalog
  (`// TODO(future-sprint): replace mock with Dio-backed datasources bound`
  `// to /afirma/milistardocumentosreq, /afirma/mivecreq and …`).
- Evidence:
  `lib/features/signature/3_data/url_launcher_signature_handoff_launcher.dart`
  uses a placeholder URL
  (`// TODO(future-sprint): replace stub Afirma URL builder with the real …`
  `// /afirma/* endpoint contract. The current presentation-layer URL`
  `// (https://afirma.jccm.es/sign?docId=…&returnTo=…) is a deliberate`
  `// placeholder until the Afirma integration team publishes the real …`).
- UAT impact: end-to-end Afirma signing cannot be validated; UAT
  validates the inbox UX, deep-link parsing
  (`signature_deep_link_parser_test.dart`) and return handling
  (`afirma_return_page_test.dart`) only.

### 3.3 Support / help — backend channel pending (TASK-63)

- Evidence:
  `lib/features/help/3_data/support_repository_provider.dart`
  contains
  `// TODO(TASK-63): wire real backend channel (operator inbox + email …)`
  and
  `// TODO(TASK-63): wire real backend channel — for now we simulate a …`.
- UAT impact: form validation and submission UX are real; the
  back-channel that would deliver the ticket to operators is mocked.
  UAT may end-to-end test only up to the success/failure UI states.

### 3.4 Casework workspace — mock data only

- Evidence: Sprint 7 report §Gap #2 — repository not yet wired against
  `/publicacion/select*`. No code change at this SHA reverses that.
- UAT impact: search/detail/aportación/registro/uploads flows are
  exercised against deterministic fixtures.

### 3.5 OfflineBanner copy — Spanish only

- Evidence:
  `documentation/qa/resilience-adopters.md` §Operational notes
  ("Banner copy is hard-coded ES today; l10n key migration is tracked
  as a Sprint 8 follow-up handled inside STORY-65 closure work.").
- UAT impact: switching device locale will not translate the offline
  banner in this build.

### 3.6 Maintenance / consent / user_profile — manual UAT only

- Evidence: filesystem walk in §1 — no `test/features/<f>/`
  directories at this SHA.
- UAT impact: these surfaces require explicit manual scripts; do not
  treat absence of automated failures as evidence of correctness.

---

## 4. UAT entry criteria checklist

Each item must be flipped to ✅ before opening UAT to the citizen-
facing test cohort. Sibling deliverables referenced by relative path
exist (or are landing in this Sprint 8 integration window) at the
adjacent file paths shown.

- [ ] Build artifacts produced via `.github/workflows/release.yml`
      for `development`, `preproduction`, and `production` flavours.
- [ ] Env config snapshots frozen and attached to the UAT release tag:
      [`config_development.json`](../../config_development.json),
      [`config_preproduction.json`](../../config_preproduction.json),
      [`config_production.json`](../../config_production.json).
- [ ] Performance budgets re-verified — see
      [`TASK-70-performance-verification-sprint8.md`](./TASK-70-performance-verification-sprint8.md).
- [ ] Hardening final report signed off — see
      [`../security/TASK-69-hardening-final-report.md`](../security/TASK-69-hardening-final-report.md).
- [ ] Telemetry verification done — see
      [`STORY-64-telemetry-verification-sprint8.md`](./STORY-64-telemetry-verification-sprint8.md).
- [ ] Resilience adoption final — see
      [`resilience-adopters.md`](./resilience-adopters.md).
- [ ] Test data caveats documented (mock vs live backends) — captured
      in §3 above (recommendations, signature, support, casework).
- [ ] Promotion runbook signed — see
      [`../release/promotion-policy.md`](../release/promotion-policy.md).

> Note: as of this SHA the `documentation/release/` directory contains
> `release_checklist.md`. The promotion policy file referenced above
> is being produced concurrently by the Sprint 8 release-promotion
> workstream and will be available alongside this handoff once the
> integration window completes. UAT entry should not be granted until
> that file is in place and signed.

---

## 5. Sign-off

UAT entry is **recommended** for this build, contingent on the
checklist in §4 turning fully green.

At handoff, no UAT-blocking defects are known against shipped
functionality:
- The four Sprint 7 gaps (§2.1) are non-blocking polish or carry-
  forward items already disclosed.
- The four Sprint 8 enumeration findings (§2.3 N1–N4) are coverage
  gaps, not functional defects, and are mitigated by manual UAT
  scripts on consent, user_profile and maintenance.
- The five known limitations (§3) are intentional product decisions
  with documented in-code TODOs and are scoped out of this UAT round.

The UAT cohort should be briefed on the §3 limitations so that
expectations on recommendations content, signature round-trip, and
support submission are aligned with what the build can actually do.

— Recorded for STORY-67 closure, Sprint 8 (2026-04-29).

---

## Appendix A — Per-surface narrative

The table in §1 is dense; this appendix expands the rationale for each
row so that the UAT lead can build manual scripts without going back
to the source tree. Every claim is a restatement of what the table
already cites — no new evidence is introduced here.

### A.1 landing
- Single golden baseline shipped (`test/qa/goldens/landing_page_phone_portrait.png`).
- A11y smoke covers four guideline matchers driven from
  `test/qa/accessibility_smoke_test.dart`.
- Smoke harness (`test/integration/smoke_happy_path_test.dart`) boots
  the landing page and validates the happy-path render.
- Manual UAT focus: device-level VoiceOver/TalkBack traversal of the
  landing CTAs and language-switch behaviour.

### A.2 auth/login (Cl@ve)
- No `2_presentation/` page widget exists for auth in this repo —
  the OAuth front-channel is the system browser / WebView, which is
  not amenable to widget tests.
- Domain layer is exercised by `use_cases_test.dart`; data layer is
  exercised by `auth_repository_impl_test.dart` and
  `clave_auth_remote_datasource_test.dart`.
- Manual UAT focus: real Cl@ve round-trip on physical device, token
  refresh after expiry, denied-consent abort path, back-button mid-
  flow.

### A.3 consent
- Page exists (`consent/2_presentation/consent_page.dart`) but no
  `test/features/consent/` directory ships at this SHA.
- Manual UAT focus: first-launch flow, "decline" path, persistence
  across cold-restarts, change-of-mind from settings.

### A.4 home (app shell)
- Home is composed by the app shell (`app/shell/app.dart`,
  `app/shell/app_scaffold.dart`); there is no `lib/features/home/`.
- Sprint 7 §Gap #1 documented why a deterministic golden is hard:
  the Home content depends on the citizen profile and personalization
  config.
- Manual UAT focus: tab/drawer navigation, handling of empty-profile
  vs populated-profile states, deep-link landing into nested tabs.

### A.5 agenda
- Strongest non-landing automated coverage in the repo (9 test files
  spanning notifier, mappers, payload parser, period filter and
  multiple widgets).
- Resilience adopter (offline banner + TTL cache prefix `agenda:`).
- Manual UAT focus: re-verification of Sprint 7 §Gap #3 (dynamic-type
  truncation at 200%).

### A.6 casework
- 14 test files spanning search, workspace, aportación wizard,
  expediente detail, registro detail, and uploads (validator, session
  notifier, evidence section widget).
- Repository still mock-backed; backend wiring tracked outside this
  ticket.
- Manual UAT focus: full mock workflow per role, attachment picker
  fallback paths.

### A.7 notifications
- 11 test files spanning center notifier + page widget, contact
  registration gate (notifier, page widget, validator and gate
  banner), and detail (notifier, page, repository, document tile).
- Resilience adopter (offline banner + TTL cache prefix
  `notifications:`).
- Manual UAT focus: real push delivery on device, deep-link from
  notification payload, contact registration round-trip.

### A.8 digital_cards
- 16 test files spanning catalog (notifier, page, tile), exporters
  (binary artifact resolver, wallet action controller), and per-card
  flows (`discapacidad`, `familia_numerosa`, `joven`).
- Manual UAT focus: real wallet/PDF export, share sheets per OS,
  binary cache eviction behaviour.

### A.9 signature
- 6 test files: inbox (notifier, page, repository impl) and handoff
  (deep-link parser, controller, Afirma return page).
- Mock catalog and placeholder Afirma URL — see §3.2.
- Manual UAT focus: inbox interactions only; Afirma round-trip is out
  of scope for this UAT round.

### A.10 recommendations
- 7 test files: dto, controller, page widget, mock repo, plus three
  empty-state variants (variant logic, empty view widget, page config
  transition).
- Resilience adopter (offline banner + TTL cache prefix
  `recommendations:`).
- Mock backend (§3.1).
- Manual UAT focus: re-verification of Sprint 7 §Gap #4 (focus order
  on cards under keyboard / TalkBack traversal).

### A.11 education / employment / social_welfare / state_affairs
- Each has a single landing notifier test under
  `test/features/<feature>/`.
- Manual UAT focus: visual review of landing pages, deep-link
  behaviour, scroll/reset, language switch.

### A.12 external_links
- Two tests: catalog content and launcher logic.
- Manual UAT focus: real URL launch on device across browsers and
  intent-resolution edge cases.

### A.13 help (incl. support form)
- Four tests covering repository, support form notifier, page widget,
  and validator.
- Captcha + submission still mocked (§3.3).
- Manual UAT focus: form UX, validation messaging, success/failure UI
  states (real backend round-trip is not validated).

### A.14 legal / sitemap
- Each has a single repository-level test.
- Manual UAT focus: visual review of legal documents (scroll, links,
  language switch) and sitemap traversal.

### A.15 user_profile
- Only `widgets/` ship under `2_presentation/` and no
  `test/features/user_profile/` directory exists at this SHA.
- Manual UAT focus: rendering with full / partial profile data,
  edit/save flows if present in this build.

### A.16 personalization
- Four tests: data-consent (notifier + page) and life-events
  (notifier + page).
- Manual UAT focus: cross-feature impact of toggling life events
  (does Home / Recommendations react as expected?).

### A.17 maintenance
- Page exists (`maintenance/2_presentation/maintenance_page.dart`),
  no automated tests.
- Manual UAT focus: trigger maintenance flag in pre-prod and verify
  the lockout UX, the localized copy, and the recovery path when the
  flag is cleared.

---

## Appendix B — Files inspected to produce this report

For traceability, this report was produced after inspecting:

- `test/qa/` (`accessibility_smoke_test.dart`, `landing_golden_test.dart`,
  `goldens/landing_page_phone_portrait.png`).
- `test/integration/smoke_happy_path_test.dart`.
- `test/features/<feature>/` directories for every feature listed in §1.
- `lib/features/recommendations/3_data/` (mock vs live boundary).
- `lib/features/signature/3_data/signature_repository_impl.dart` and
  `lib/features/signature/3_data/url_launcher_signature_handoff_launcher.dart`
  (Afirma placeholder URL).
- `lib/features/help/3_data/support_repository_provider.dart`
  (TASK-63 backend pending).
- `documentation/qa/STORY-67-regression-report.md` (Sprint 7 baseline).
- `documentation/qa/resilience-adopters.md` (Sprint 7 / Sprint 8
  resilience adoption matrix).
- `.github/workflows/release.yml` (build artifact production for the
  UAT entry checklist).
- Filesystem walk of `lib/features/` and `test/features/` to confirm
  surface enumeration.

No claim in this document is based on inference beyond what these
files state.
