# TASK-27 — Dashboard contract gap discovery

## Context

The dashboard cluster (EPIC-3) inherits a set of visible blocks that come from the
PPT design and the original screen mapping but are not all covered by the API
described in `fachada-sede-api-swagger.yaml`. Sprint 3 needs an explicit decision,
per block, on whether the experience ships against a real API, redirects to an
external portal via the existing `ExternalLinkCatalog` (STORY-28), is shipped as a
controlled "Próximamente" placeholder, or is deferred to a later sprint.

This document is the discovery gate referenced by [STORY-23], [STORY-24],
[STORY-25] and [STORY-31] in their `Blocked by [TASK-27] (partial)` line. It
exists so that none of those stories invents data, fakes endpoints, or blocks on
backend availability.

Inputs cross-checked:
- `fachada-sede-api-swagger.yaml` (current, signed contract).
- `documentation/initial_documentation/MAPEO_ENDPOINTS_PANTALLAS.md` (sections
  on Bienestar Social and Empleo, R5 risk row).
- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md` (rows 1.6,
  R5).
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
  (sections N1 and N8, screen 1 Dashboard, screen 8 Bienestar Social).
- `generated/dart_dio_client/` (generated Dart client; mirrors swagger 1:1, no
  additional endpoints).
- Image references listed in `tickets/TASK-27.md > Traceability`.

Swagger keyword sweep (literal grep over `fachada-sede-api-swagger.yaml`):

| Keyword          | Hits in swagger                                                                 |
|------------------|---------------------------------------------------------------------------------|
| `becad`          | 0 (no `/api/v1/educacion/*beca*` operation, no `becado` field in any schema)    |
| `terma` / `balne`| 0                                                                               |
| `aparca` / `parking` / `estacion` | 0                                                              |
| `dependenci`     | 0 dedicated operation; only related: `/intermediacion/discapacidad/datos`, `/carnet-digital/grado-discapacidad/{dni}` |
| `oferta`         | 0 (only `/sepe/demandante-empleo-fecha-actual/{numDocumento}` exposes status)   |
| `salud`          | 0 dedicated portal endpoint; SESCAM operations: `/sescam/cip/{numDocumento}`, `/sescam/citas/{numDocumento}`, `/sescam/citas-pasadas/{numDocumento}` |

## Inventory of visible-but-uncontracted blocks

| Block | Source | Confirmed contract? | Gap type | Affected stories |
|---|---|---|---|---|
| Condición de becado | `image_references/Landing Educación.png`, `Landing Educación-1.png`; PPT/PFT Educación; not enumerated as gap in `MAPEO_ENDPOINTS_PANTALLAS.md` (treated as inferred field) | No. `fachada-sede-api-swagger.yaml` keyword `becad` returns 0 matches. Generated client `generated/dart_dio_client/` has no beca-related operation. | Missing endpoint. The educación contracts (`/api/v1/educacion/titulos-universitarios/{numDocumento}`, `/api/v1/educacion/titulos-no-universitarios/{numDocumento}`) do not return scholarship status fields. | STORY-23 |
| Termalismo / balnearios | `image_references/Landing Bienestar social.png`; `MAPEO_ENDPOINTS_PANTALLAS.md` row "Termalismo ❌ SIN ENDPOINT"; R5 in `MAPEO_DETALLADO_ENDPOINTS.md` | No. Swagger keywords `terma`/`balne` return 0 matches. | Missing endpoint. | STORY-25 |
| Tarjeta de estacionamiento | `image_references/Landing Bienestar social.png`; `MAPEO_ENDPOINTS_PANTALLAS.md` row "Tarjeta de Estacionamiento ❌ SIN ENDPOINT" | No. Swagger keywords `aparca`/`parking`/`estacion` return 0 matches. | Missing endpoint. | STORY-25 |
| Atención a la dependencia | `image_references/Servicios - Atención a la dependencia.png`; `MAPEO_ENDPOINTS_PANTALLAS.md` row "Atención a la Dependencia ❌ SIN ENDPOINT"; `DOCUMENTO_COMPRENSION_FUNCIONAL.md` N1 | No dedicated endpoint for "atención a la dependencia". Adjacent contracts that do exist are `/api/v1/intermediacion/discapacidad/datos` and `/api/v1/carnet-digital/grado-discapacidad/{dni}`, which are about discapacidad acreditation, not dependencia. | Missing endpoint (ambiguous adjacency: discapacidad ≠ dependencia). | STORY-25 |
| Inscripciones en ofertas | `image_references/Servicios - Demandante de empleo-1.png`; `MAPEO_ENDPOINTS_PANTALLAS.md` row "Inscripciones en Ofertas ❌ SIN ENDPOINT"; `DOCUMENTO_COMPRENSION_FUNCIONAL.md` N1 | No. Swagger keyword `oferta` returns 0 matches. The only sepe operation is `/api/v1/sepe/demandante-empleo-fecha-actual/{numDocumento}`, which exposes employment-seeker status only. | Missing endpoint. | STORY-24 |
| Mi salud digital | `image_references/Servicios - Mapa web.png`; `DOCUMENTO_COMPRENSION_FUNCIONAL.md` N1; STORY-31 contract-sensitive surfaces | No "salud digital" portal endpoint exists. SESCAM operations (`/sescam/cip/{numDocumento}`, `/sescam/citas/{numDocumento}`, `/sescam/citas-pasadas/{numDocumento}`) cover CIP and citas only, and even there the response is documented as `string` with shape pending validation (R1, N4). | Missing endpoint for "Mi salud digital" portal entry (the citas/CIP slice already belongs to STORY-29/STORY-31 and is out of scope for this gate). | STORY-31 (future sprint) |

Note: TASK-27's `Discovery scope` lists six blocks; the row for `Mi salud digital`
covers the surface explicitly attributed to STORY-31 in the next sprint, not the
SESCAM citas/CIP slice that is already contracted and assigned to STORY-29 /
STORY-31.

## Decision per block

### Condición de becado — DECISION: PLACEHOLDER_CONTROLLED

Swagger has no scholarship endpoint and no `becado`/`beca` field on the educación
title operations. STORY-23 already lists this surface as
"contract-sensitive — sujeta a validación adicional". Ship the visual block in
the Educación landing as a localized "Próximamente" card with an info icon
explaining that the data depends on a backend that is not yet exposed. No
hard-coded boolean, no fake API call. When the backend appears, the card is
swapped for the real bound widget without changing the layout.

### Termalismo / balnearios — DECISION: EXTERNAL_LINK

Swagger has no `terma`/`balne` operation and the program is published by the JCCM
Bienestar Social portal. Replace the visual block in the Bienestar Social
landing with a secure outbound entry routed through the existing
`ExternalLinkCatalog` (STORY-28) pointing at the JCCM Bienestar Social /
Termalismo program landing. The catalog already enforces the allow-list and
analytics tagging, so we don't introduce a new outbound surface type.

### Tarjeta de estacionamiento — DECISION: EXTERNAL_LINK

Swagger keyword sweep returns 0 hits. The "tarjeta de estacionamiento para
personas con discapacidad" is administratively a JCCM/local-entity procedure
(sede electrónica) rather than a federated read API. Replace the visual block
with an external link routed through `ExternalLinkCatalog` to the JCCM sede
electrónica entry for the procedure. Mirrors the termalismo decision in the same
landing. The new catalog entry itself is owned by STORY-28; this gate only
records the dependency.

### Atención a la dependencia — DECISION: EXTERNAL_LINK

Swagger does not expose an "atención a la dependencia" read endpoint. The
adjacent contracts `/api/v1/intermediacion/discapacidad/datos` and
`/api/v1/carnet-digital/grado-discapacidad/{dni}` cover *discapacidad* acreditation
and must NOT be wired to the dependencia card (different program, different
data). Ship the block as an external link via `ExternalLinkCatalog` to the JCCM
Bienestar Social "Atención a la dependencia" portal. The discapacidad endpoints
remain bound to their own dedicated cards inside STORY-25 unchanged.

### Inscripciones en ofertas — DECISION: EXTERNAL_LINK

Swagger has no `oferta` operation. Active job-offer subscription is operated by
the SEPE/Empleo CLM federated portals, not by the carpeta ciudadana façade.
Replace the visual block with two outbound entries already tracked by the
existing catalog keys (`externalLinkEmpleoClmLabel`,
`externalLinkEmpleoPublicoClmLabel` are already in `lib/l10n/app_es.arb`), so no
new catalog key is needed for STORY-24. The "demandante de empleo" card itself
keeps its real binding to `/api/v1/sepe/demandante-empleo-fecha-actual/{numDocumento}`.

### Mi salud digital — DECISION: DEFERRED

STORY-31 is explicitly tagged for a future sprint and TASK-27 only blocks the
Sprint 3 cluster. There is no dedicated "salud digital" endpoint in swagger and
the SESCAM string-shape risk (R1, N4) is still open. Defer the decision to the
sprint that owns STORY-31 instead of forcing a placeholder now. This deferral
does not block STORY-23/24/25 because none of them depend on the Mi salud
digital surface. STORY-31 itself stays "Blocked by [TASK-27] (partial)" and will
re-open this row when scheduled.

## Impact on Sprint 3 stories

This is the operational instruction implementers of STORY-23, STORY-24 and
STORY-25 must follow when they pick up their tickets. It does not change those
tickets' AC boxes, status, or sprint — it tells the implementer how each AC item
should ship.

### STORY-23 — Educación

- AC "landing de Educación con información relevante, trámites sugeridos y enlaces" → **ship as functional** (real API for títulos + external links via STORY-28).
- AC "listados/detalles de títulos universitarios y no universitarios" → **ship as functional** (`/api/v1/educacion/titulos-universitarios/{numDocumento}`, `/api/v1/educacion/titulos-no-universitarios/{numDocumento}`).
- AC "condición de becado como capacidad explícita del diseño" → **ship as controlled placeholder** ("Próximamente", localized info icon, no fake state).
- AC "enlaces externos como Educamos CLM y surfaces de empty/error" → **ship as external link** (uses existing `externalLinkEducamosClmLabel` catalog entry).

### STORY-24 — Empleo

- AC "landing de Empleo con accesos a información relevante y enlaces" → **ship as functional** (landing chrome + external links).
- AC "demandante de empleo con inscripción y fecha de continuidad" → **ship as functional** (`/api/v1/sepe/demandante-empleo-fecha-actual/{numDocumento}`).
- AC "inscripciones en ofertas con listado y estado de candidatura" → **ship as external link** (Empleo CLM and Empleo público CLM via existing catalog keys; no fake list rendered).
- AC "enlaces a Empleo CLM y Empleo público CLM y estados vacíos/error" → **ship as external link** (already in catalog).

### STORY-25 — Bienestar social

- AC "landing de Bienestar social con información relevante y enlaces externos" → **ship as functional** (landing chrome + external links).
- AC "detalle de familia numerosa con datos del título y beneficiarios" → **ship as functional** (`/api/v1/ccaa/familia-numerosa/{numDocumento}`).
- AC "tarjeta de estacionamiento y atención a la dependencia como pantallas funcionales inferidas del diseño" → **ship as external link** for both, via `ExternalLinkCatalog`. The "pantalla funcional" interpretation is replaced by an outbound card, because no real contract exists.
- AC "termalismo/balnearios como capacidad visible del dominio y fallback si el backend no está disponible" → **ship as external link** (no swagger contract; the "fallback" requirement is satisfied by the outbound card pattern, no error state needed because there is no inbound call).

### STORY-31 — Salud digital

- AC "explicitar gaps de contrato para capacidades de salud visibles en diseño pero no confirmadas" → **explicitly deferred** to the sprint that schedules STORY-31; this document is the recorded deferral.

## Backend / product follow-ups

Each bullet is an open question to escalate to backend / product. The tag in
brackets is the dependency that gets unblocked the day the question is resolved.

- [STORY-23 / condición de becado] Confirm whether scholarship state will be exposed as a new `/educacion/*` endpoint or as an enrichment field on the títulos operations, and what the authoritative source is (Educamos CLM, MEFP, JCCM beca registry). Until then the surface ships as a controlled placeholder.
- [STORY-25 / termalismo] Confirm whether the JCCM termalismo program will expose a per-citizen status endpoint (eligibility, current adjudication) or remain a portal-only program. Currently shipped as external link.
- [STORY-25 / tarjeta de estacionamiento] Confirm whether tarjeta de estacionamiento (discapacidad) state can be federated through an existing carnet-digital-style operation, or if the ciudadano must be sent to the sede procedure. Currently shipped as external link.
- [STORY-25 / atención a la dependencia] Confirm whether Ley de Dependencia status (grado, valoración, prestaciones) will be exposed as a federated read endpoint, and whether it should reuse `intermediacion/*` or be a new namespace. Explicitly different from `discapacidad`.
- [STORY-24 / inscripciones en ofertas] Confirm whether the SEPE federation will be extended with an "ofertas inscritas" read endpoint or whether the experience permanently delegates to Empleo CLM. Currently shipped as external link.
- [STORY-31 / mi salud digital] Confirm scope of "Mi salud digital" portal entry for the sprint that picks up STORY-31, plus close R1/N4 (SESCAM `string` response shape) before binding any new salud surface.
- [Cross-cutting] For every block currently shipped as `EXTERNAL_LINK`, confirm with product the canonical landing URL and whether it must be added to `ExternalLinkCatalog` as a new allow-listed entry (catalog work itself is owned by STORY-28).
