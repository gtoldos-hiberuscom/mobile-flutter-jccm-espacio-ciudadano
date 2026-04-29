# TASK-71 — Cards surfaces shown on the logged home

## Context

The "Mis carnets digitales" widget on the logged home (STORY-22) and the design
of the "Mis carnets digitales" section (STORY-48, EPIC-7) include two surfaces
that are *not* enumerated as official `carnet-digital/*` operations in the
swagger contract: **Tarjeta Sanitaria** and **Tarjeta de Biblioteca**. This
document closes the discovery question for those two surfaces so that
STORY-22 (already shipped), STORY-31 (CIP/health surfaces) and STORY-48
(catalogue) can be implemented without inventing data or contracts.

Inputs cross-checked:

- `fachada-sede-api-swagger.yaml` (signed contract).
- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`
  (sections 6.1 to 6.8 — `/carnet-digital/*`).
- `documentation/initial_documentation/MAPEO_ENDPOINTS_PANTALLAS.md`
  (Mi Carnet Digital block).
- `documentation/initial_documentation/RESUMEN_FUNCIONALIDADES_PPT.md`
  sections 2 (Salud) and 6 (Mi Carnet Digital).
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
  (functional scope, R5 risk row).
- `documentation/discovery/TASK-27-dashboard-contract-gaps.md` (Mi salud
  digital decision and `EXTERNAL_LINK` pattern).
- Image references: `Landing logado mobile.png`,
  `Servicios - Mis carnets digitales.png`, `Servicios - Mis citas médicas.png`.

Swagger keyword sweep (literal grep):

| Keyword              | Hits in swagger                                                          |
|----------------------|--------------------------------------------------------------------------|
| `biblioteca`         | 0                                                                        |
| `library`            | 0                                                                        |
| `tarjeta-sanitaria`  | 0                                                                        |
| `cip`                | 1 — `GET /sescam/cip/{numDocumento}` (response `string`, R1 open)        |
| `carnet-digital`     | 8 — familia-numerosa, joven, discapacidad (PKPass + grado), QR, PDF, PKPass generic |

## Inventory

| Surface                | Visible in                                          | Confirmed contract? | Decision         | Owner story |
|------------------------|-----------------------------------------------------|---------------------|------------------|-------------|
| Tarjeta Sanitaria (CIP)| Home widget "Mis carnets digitales" + section ficha | Partial — `/sescam/cip/{numDocumento}` exists but response is `string` (R1, blocked by TASK-32). No PKPass / QR / PDF endpoint for CIP. | **CIP_REUSE** — surface CIP through the salud domain (STORY-31), reuse it as a *read-only mini-card* inside the cards catalogue. No PKPass/QR/PDF actions. | STORY-31 owns the data; STORY-48 renders the read-only card |
| Tarjeta de Biblioteca  | Home widget "Mis carnets digitales" + section grid  | None — 0 hits in swagger; not enumerated in any `MAPEO_*` document; only appears in design assets. | **OUT_OF_MVP** — drop from the cards catalogue for the MVP. Optionally surface as a controlled "Próximamente" placeholder if product confirms intent; otherwise keep removed and re-open via a new ticket when a contract appears. | None (placeholder only if product opts in) |

## Decision per surface

### Tarjeta Sanitaria — DECISION: CIP_REUSE (no wallet semantics)

The CIP is a real piece of citizen data with a confirmed (string-shape) backend
endpoint `/sescam/cip/{numDocumento}`. It is **not** a federated digital carnet
in the sense of the `carnet-digital/*` namespace: no PKPass, no QR, no PDF
generator exists for it. Treating it as one would imply inventing either a
Wallet pass or a downloadable artifact that the backend does not expose.

Operational consequences:

- **STORY-22 (home widget "Mis carnets digitales")**: keep the home block
  count semantics ("how many digital cards the citizen has available"). CIP
  *should not* be counted in that number, because clicking the home block
  navigates to the cards catalogue (STORY-48), not to the salud detail.
  Document this in STORY-22 retro-notes; no code change needed in Sprint 4
  unless the count is currently inflated by CIP (it is not — the mock counts
  real cards only, see `home_dashboard_repository_impl.dart`).
- **STORY-31 (CIP/health surfaces reused between home and agenda)**: owns
  the CIP card. Renders the CIP value, the holder name, the expiry/region as
  available, and a clear visual that distinguishes it from the wallet-style
  carnets. Surfaced from the salud entry on the home (the `homeBlockSaludTitle`
  surface — see TASK-27 deferred decision) and from the agenda detail via a
  shared widget owned by `lib/features/agenda/2_presentation/widgets/`
  *or* `lib/features/health_card/2_presentation/widgets/` (see open follow-up
  below).
- **STORY-48 (cards catalogue)**: renders the CIP as a *read-only mini-card*
  at the top of the catalogue, with an explicit "ver tarjeta sanitaria" CTA
  that navigates to the salud entry owned by STORY-31. **No** "añadir a
  Wallet", **no** "descargar PDF", **no** "generar QR" actions on this card.

### Tarjeta de Biblioteca — DECISION: OUT_OF_MVP

There is **no** swagger entry, **no** `MAPEO_*` row, **no** functional
description in the PPT/Functional document, and **no** confirmed JCCM
biblioteca-digital programme for the carpeta ciudadana. The image asset is
the only source.

Operational consequences:

- **STORY-22**: do not render a "Tarjeta de biblioteca" entry on the home
  widget. Retro-confirm in the STORY-22 notes that the existing home widget
  does not surface biblioteca content (it does not — see
  `home_block_card.dart`, no biblioteca id in `HomeBlockId`).
- **STORY-48**: do not include biblioteca in the cards catalogue. If, during
  product review, the team decides to keep the visual placeholder, it ships
  as a localized "Próximamente" disabled card, mirroring the
  `PLACEHOLDER_CONTROLLED` pattern from TASK-27. Default for Sprint 4 is to
  omit it entirely.
- **Re-open trigger**: when product confirms a real biblioteca digital
  programme with a backend endpoint, open a dedicated story under EPIC-7
  (`STORY-XX library-card`).

## Impact on the affected tickets

### STORY-22 (Home dashboard) — already Done

- No code change required. The Sprint 3 implementation does not surface CIP
  inside the digital-cards count and does not include a biblioteca entry.
- Append a Notes / Change Log line referencing this discovery so the
  decision is traceable from STORY-22's history.

### STORY-31 (CIP / health surfaces reused between home and agenda)

- Owns the CIP read-only surface and renders it from a shared widget
  consumed by home (salud entry) and agenda (event detail header / agenda
  shell).
- Must not surface PKPass/QR/PDF actions on the CIP card.
- Continues to depend on TASK-32 for the real string parsing strategy of
  `/sescam/cip/{numDocumento}`.

### STORY-48 (Cards catalogue)

- Catalogue renders the federated `carnet-digital/*` cards (familia
  numerosa, joven, discapacidad) plus a read-only CIP mini-card linking
  back to the salud surface owned by STORY-31.
- Biblioteca is omitted by default; if product opts in, ship as a
  localized "Próximamente" disabled card with no actions.
- Full payload binding for federated cards remains blocked by TASK-53.
  Sprint 4 ships the catalogue container, the state model (available /
  not vigent / not downloadable), and stub repository data flagged
  `// TODO(TASK-53)`.

## Backend / product follow-ups

Each bullet is an open question to escalate.

- [STORY-31] Confirm whether the salud entry on the home dashboard should
  expose the CIP value directly or only navigate to a salud detail page.
  Today the home widget for salud (`HomeBlockId.agenda` for SESCAM data)
  links to the agenda screen; STORY-31 must decide whether to add a
  dedicated salud detail or extend the existing salud entry.
- [STORY-31 / STORY-48] Confirm the canonical home for the CIP read-only
  widget. Two valid options:
  1. Owned by `lib/features/agenda/2_presentation/widgets/cip_card.dart`
     and re-exported. Cheaper because all SESCAM data shares parsing.
  2. Owned by a new `lib/features/health_card/` feature. Cleaner if a
     dedicated salud surface is later added.
  Sprint 4 picks option 1 for STORY-31 to minimise feature-tree churn;
  if a dedicated salud landing is added in a later sprint, the widget can
  be moved without breaking consumers.
- [STORY-48] Confirm with product whether biblioteca is "Próximamente" or
  fully removed for the MVP. Default in this discovery is *removed*.
- [STORY-48 / TASK-53] Schedule TASK-53 (validate real `string` payload of
  the `carnet-digital/*` operations) to unblock full binding.
- [Cross-cutting] When biblioteca / any new carnet appears in a future
  contract, prefer adding it under EPIC-7 with its own story rather than
  retro-fitting STORY-22 or STORY-48.

## Resolution

This discovery resolves the "biblioteca" question (OUT_OF_MVP) and the
"tarjeta sanitaria" question (CIP_REUSE, no wallet semantics) for Sprint 4.
STORY-31 and STORY-48 may proceed in this sprint applying these decisions.
STORY-22 is retroactively confirmed as compatible with no code change.

## Sprint 7 closure annotation

Reviewed during Sprint 7 (SP-EC-APP-SQ2-07) under STORY-67 QA-as-code.
No new defects surfaced that contradict the strategy recorded above.
The decision matrix in this document remains the authoritative input
for the corresponding implementation ticket; outstanding items stay
parked on their owner sprint per the roadmap and are not escalated to
new tickets at this point.
