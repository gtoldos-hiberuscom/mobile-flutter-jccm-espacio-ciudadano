# TASK-40 — Procedimiento and evidence contract discovery

## Context

EPIC-5 (Casework) needs a definitive answer on which procedure-tramitation
and registry endpoints can land in Sprint 5 and which must explicitly
defer. The OpenAPI contract exposes a family of operations under
`/procedimiento/*`, `/documentacion/*`, `/publicacion/*` and
`/consulta/*` that are *available* but not all of them are mapped to a
screen in the functional documentation (this is risk row R6 in
`MAPEO_DETALLADO_ENDPOINTS.md` and the open point N2/N9 in
`DOCUMENTO_COMPRENSION_FUNCIONAL.md`).

This document is the in-scope vs follow-up decision required by the AC
of TASK-40. It feeds STORY-35 (expediente detail), STORY-37 (third-party
contribution wizard) and STORY-38 (upload + justificante).

## Inputs cross-checked

- `generated/dart_dio_client/doc/ProcedimientoApi.md` — generated client
  surface for `inicproc`, `miconfirmarproc`, `miobtenerres`,
  `subiradjunto`, `subiradjuntosinfirma`, `obtenerhashdeadjunto`.
- `generated/dart_dio_client/doc/DocumentacionApi.md` — generated client
  surface for `registrarfichero`.
- `generated/dart_dio_client/doc/PublicacionApi.md` — generated client
  surface for `selectbynif`, `selectbynifexp`, `selectbynifentrada`,
  `selectbynifsalida`, `selectbynumexp`, `selectbynumreg`,
  `misexpedientes`, `midetalle`, `midocfirmados`.
- `generated/dart_dio_client/doc/ConsultaApi.md` — generated client
  surface for `miconsultareq`.
- Generated DTOs: `DTProcedimiento`, `CONFIRMARPROCEDIMIENTO`,
  `RESULTADOPROCEDIMIENTO`, `ZCSRMOBTRESPUESTAEXP(+Response)`, `ADJUNTO`,
  `RegistrarFicheroRequest`, `DocumentoRegistro`, `XMLRegistro`,
  `ZCSRFCMISEXPEDIENTES(+Response)`, `DTSELECTBYNIFV2REQ`,
  `ZCSRFCCONSULTAFAQ(+Response)`.
- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`
  rows 3.1 → 3.7 (Mis Gestiones) and 4.1 → 4.4 (Consulta de
  Expedientes), plus risk row R6.
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
  sections N2 / N8 / N9.
- Sibling tickets STORY-35, STORY-37, STORY-38, EPIC-5.

No preproduction credentials or sample payloads are available to this
run. All payload shapes below are taken from the generated DTOs only;
no sample bodies are inferred.

## Endpoint inventory

All operations are `POST` with `Content-Type: application/json` and
`Accept: application/json`. The generated client exposes them under
the package base URL `https://fachada-sede-api-pre.cm-pre.jccm.es/api/v1`.
The generator marks every operation as "No authorization required",
which is a known artefact of the OpenAPI document; the real backend is
behind Cl@ve (see N10) and the Dio interceptor stack already in
`core/network/` is the integration point for the bearer token. No new
auth surface is in scope here.

### Procedimiento

| Endpoint | Generated method | Request DTO | Response DTO | Functional confirmation |
|----------|------------------|-------------|--------------|--------------------------|
| `POST /procedimiento/inicproc` | `miIniProcOperation` | `DTProcedimiento` | `RESULTADOPROCEDIMIENTO` | **Inferred** — N2/N9 list it as part of the un-screened tramitation flow; R6 flags scope as unconfirmed. |
| `POST /procedimiento/miconfirmarproc` | `miConfirmarProcOperation` | `CONFIRMARPROCEDIMIENTO` (wraps `DTProcedimiento` + `PDATOS`) | `RESULTADOPROCEDIMIENTO` | **Inferred** — same as above. |
| `POST /procedimiento/miobtenerres` | `miObtenerRespuestaOperation` | `ZCSRMOBTRESPUESTAEXP` (`irefdoc`, `ttextosrespuesta`) | `ZCSRMOBTRESPUESTAEXPResponse` (`esubrc`, `return_`, `ttextosrespuesta`) | **Inferred** — same as above. |
| `POST /procedimiento/subiradjuntosinfirma` | `miSubirAdjuntoSinFirmaOperation` | `ADJUNTO` (`idunico`, `nifcif`, `nombre`, `tipoprocedimiento`, optional `data`/`hash`/`metadatos`/…) | `RESULTADOPROCEDIMIENTO` | **Confirmed** — row 3.6 / N2 list the upload path explicitly for Mis Gestiones. |
| `POST /procedimiento/subiradjunto` | `miSubirAdjuntoOperation` | `ADJUNTO` (signed) | `RESULTADOPROCEDIMIENTO` | **Confirmed** — row 3.6, signed variant. |
| `POST /procedimiento/obtenerhashdeadjunto` | `hashAdjuntoaOperation` | `ADJUNTO` | `RESULTADOPROCEDIMIENTO` | **Confirmed** — row 3.7, hash-before-upload. |

### Documentación / registry evidence

| Endpoint | Generated method | Request DTO | Response DTO | Functional confirmation |
|----------|------------------|-------------|--------------|--------------------------|
| `POST /documentacion/registrarfichero` | `registrarFicheroOperation` | `RegistrarFicheroRequest` (optional `confirmarProcedimiento`, `documentos: List<DocumentoRegistro>`, `xmlRegistro`, tramitation metadata) | `Uint8List` (binary justificante) | **Inferred** — N2/N8 cite it as the registry entry point for the justificante; N8 also flags the missing error-code definitions. |

### Publicación / expedientes

| Endpoint | Generated method | Request DTO | Response DTO | Functional confirmation |
|----------|------------------|-------------|--------------|--------------------------|
| `POST /publicacion/selectbynif` | `myPubliSelecByNifOperation` | `DTSELECTBYNIFREQ` | `ZCSRFCPUBLISELECTBYNIFResponse` | **Confirmed** — row 3.1, primary list. |
| `POST /publicacion/selectbynifexp` | `myPubliSelecByNifTipoProcOperation1` | `DTSELECTBYNIFV2REQ` (adds `tipoprocedimiento`) | `ZCSRFCPUBLISELECTBYNIFResponse` | **Inferred** — N2 lists `selectbynifexp` as un-screened. The generated description duplicates the v1 list-by-NIF text, so behaviour vs `selectbynif` is to confirm with backend. |
| `POST /publicacion/misexpedientes` | `siMisExpedientesOperation` | `ZCSRFCMISEXPEDIENTES` (`pnumdoc`, optional filters `pdescproc`, `pestado`, `pfechadesde`, `pfechahasta`) | `ZCSRFCMISEXPEDIENTESResponse` (`expedientes: EXPEDIENTES`, `error`, `subrc`) | **Inferred** — N2 lists it as un-screened. The DTO supports server-side filters that `selectbynif*` does not, so it is the better candidate for STORY-34's filter UX, but only after backend confirms the semantic difference. |

### Consulta

| Endpoint | Generated method | Request DTO | Response DTO | Functional confirmation |
|----------|------------------|-------------|--------------|--------------------------|
| `POST /consulta/miconsultareq` | `miConsultafaqOperation` | `ZCSRFCCONSULTAFAQ` (`idatos: ZCSSPORTAL`, `returns`, `tfaq`) | `ZCSRFCCONSULTAFAQResponse` (`isubrc`, `return_`, `returns`, `tfaq`) | **Inferred** — N2 lists it as un-screened. The `faq` naming and the `TFAQ` table strongly suggest a Consultas-y-Reclamaciones text retrieval, not part of EPIC-5 casework. |

## Decision — Sprint 5 in-scope vs follow-up

### In scope for Sprint 5

The Sprint 5 casework slice covers expediente listing, detail and
single-file aportación along the path that is **fully confirmed in the
functional documentation**:

1. **Listing and detail** (already mapped before TASK-40):
   - `selectbynif` for the citizen's own list (STORY-34).
   - `selectbynumexp` for the detail (STORY-35).
   - `selectbynumreg` for the third-party search by registry number
     (STORY-37).
2. **Aportación pipeline for STORY-38** (single confirmed path):
   - `obtenerhashdeadjunto` → optional client-side or server-side hash.
   - `subiradjuntosinfirma` as the **default Sprint 5 upload op** for
     citizen-initiated aportación. This avoids depending on the
     `Afirma` signing surface, which is owned by EPIC firma-digital
     and not part of EPIC-5.
   - `subiradjunto` (signed variant) is **wired through the same
     adapter contract** but kept behind a feature flag
     `kCaseworkSignedUploadEnabled = false` so STORY-38 can ship the UI
     without the firma-digital integration.
3. **Justificante surface for STORY-38**:
   - `documentacion/registrarfichero` is the only operation that
     returns a binary `Uint8List` justificante. The Sprint 5 adapter
     wraps the call but **only invokes it from a stub repository
     while a real `RegistrarFicheroRequest` builder is unavailable**
     (see open question Q3 below). The "Descargar justificante" CTA
     in STORY-38 binds to the wrapper from day one so the switch to
     the real call is transparent.

### Explicit follow-up (deferred out of Sprint 5)

The following endpoints are **scaffolded as typed gateway interfaces in
the contract layer but have no production caller in Sprint 5**:

1. **Tramitation flow** (`inicproc` → `miconfirmarproc` →
   `miobtenerres`). N2/N9 describe this as a future "Tramitación"
   surface and R6 explicitly marks it as scope-pending. EPIC-5 does
   **not** open a tramitation screen in Sprint 5; it only reads
   expedientes and aporta documentos to existing ones. These three
   operations get a typed `TramitacionGateway` interface in
   `lib/features/casework/3_data/tramitacion/` and a
   `NotImplementedTramitacionGateway` placeholder so a follow-up sprint
   can land the screen without DTO churn.
2. **`publicacion/selectbynifexp`** — likely a typed-by-procedure
   variant of `selectbynif`. Sprint 5 keeps `selectbynif` as the
   listing op. A follow-up will A/B the two against preproduction and
   pick one for STORY-34's "filtrar por procedimiento" sub-flow.
3. **`publicacion/misexpedientes`** — server-side filtered list. A
   strong candidate to *replace* `selectbynif` in a later sprint once
   the backend confirms the relationship; for now we treat it as a
   parallel adapter behind a `kCaseworkServerFiltersEnabled = false`
   flag.
4. **`consulta/miconsultareq`** — text of consulta/reclamación and the
   reply. Belongs to the Consultas-y-Reclamaciones epic, not casework.
   Sprint 5 leaves it out of EPIC-5 entirely; the operation is
   recorded here so the planner can route it to the right epic.

## Adapter and parsing strategy (no fake payloads)

The casework feature follows the layered approach already established
by TASK-32 / TASK-71:

```
3_data/casework/
  expedientes_gateway.dart            // selectbynif / selectbynumexp
  expedientes_filtered_gateway.dart   // misexpedientes (flagged off)
  aportacion_gateway.dart             // hash + subir + registrar
  tramitacion/
    tramitacion_gateway.dart          // inicproc / miconfirmar / miobtenerres
    not_implemented_tramitacion_gateway.dart
  mappers/
    expediente_mapper.dart
    adjunto_mapper.dart
    justificante_mapper.dart          // Uint8List → JustificantePayload
```

Per-operation strategy:

- **`selectbynif*` / `selectbynumexp` / `misexpedientes`** — DTOs are
  fully typed (`ZCSRFCPUBLISELECTBYNIFResponse`,
  `ZCSRFCMISEXPEDIENTESResponse`). The mapper rejects rows whose
  required identifiers (`numexp`, `nif`, `fecha`) are missing and
  surfaces a `partial` UI state when at least one row is dropped, in
  line with the SESCAM strategy for `partial` results.
- **`obtenerhashdeadjunto`** — reuses the `ADJUNTO` DTO. The Sprint 5
  client computes the hash locally first (SHA-256) and sends it in
  `ADJUNTO.hash`; the server response is a `RESULTADOPROCEDIMIENTO`
  whose `estado` discriminates ok / ko. No payload synthesis needed.
- **`subiradjuntosinfirma` / `subiradjunto`** — same `ADJUNTO` DTO
  with `data` set to the base64-encoded file content. The adapter
  enforces the 5-files / 50 MB / format whitelist constraint *before*
  hitting the network, mirroring the rule already cited in row 3.6
  and STORY-38's AC. The signed variant is gated by the feature flag
  above.
- **`documentacion/registrarfichero`** — request is built from
  `RegistrarFicheroRequest` but **the canonical request builder is
  unknown**: the DTO has many optional fields (`xmlRegistro`,
  `confirmarProcedimiento`, `documentos`, tramitation metadata) and
  N8 explicitly notes that error codes are undocumented. The Sprint 5
  adapter exposes a `JustificanteRepository` that returns a sealed
  `JustificanteResult` (`ok(bytes, mime)`, `unavailable(reason)`,
  `parseError(reason)`), and the default Sprint 5 implementation
  returns `unavailable('builder-pending-backend-confirmation')`.
  STORY-38 binds its CTA to this contract from day one.
- **`miobtenerres`** — response carries `ttextosrespuesta` plus a
  numeric `esubrc`. Treat `esubrc != 0` or non-empty `return_` as a
  `serverEnvelopeKo` recoverable error, mirroring the SESCAM error
  taxonomy.

## Impact on downstream stories

### STORY-35 — Expediente detail with metadata and associated files

- **In scope.** `selectbynumexp` is fully typed and confirmed; the
  detail page can be built against the generated DTO without any
  speculative parsing.
- The "ficheros asociados" list is rendered from the response of
  `selectbynumexp` itself; it does **not** require `miobtenerres` in
  Sprint 5.
- The "zona para añadir ficheros" CTA links into the STORY-38 pipeline
  via the shared `AportacionGateway`.
- Estado abierto/cerrado is read from the `ZCSRFCPUBLISELECTBYNUMEXP`
  response (`estado` field, behaviour to confirm with backend — open
  question Q1 below).

### STORY-37 — Third-party contribution wizard

- **In scope** for the navigation slice (intro screen, identification
  by document type/number, search by registry or expediente number,
  transition to detail).
- The wizard's identification step uses `DTSELECTBYNIFREQ` /
  `DTSELECTBYNIFV2REQ` shapes already typed; the search step reuses
  `selectbynumexp` and `selectbynumreg`.
- **No additional procedimiento endpoint is required for STORY-37.**
  The transition lands on the same expediente detail surface as
  STORY-35.

### STORY-38 — Upload with hash, validations and justificante

- **In scope** for the full pipeline against
  `obtenerhashdeadjunto` + `subiradjuntosinfirma`.
- **Partially in scope** for the justificante: the UI ships, the
  adapter ships, but the underlying `registrarfichero` call is
  stubbed until backend confirms the request shape (Q3). The
  fallback `unavailable` state is rendered as the "Justificante en
  preparación" affordance defined by STORY-38's empty-state copy.
- **Out of scope** for STORY-38: signed upload (`subiradjunto`)
  remains behind `kCaseworkSignedUploadEnabled = false`. No firma
  digital wiring in this sprint.

## Open questions for product / backend

- **Q1.** What are the canonical values of the `estado` field returned
  by `selectbynumexp` and `misexpedientes`? STORY-35's
  abierto/cerrado split depends on this and the OpenAPI document only
  declares it as `String`.
- **Q2.** What is the actual semantic difference between `selectbynif`,
  `selectbynifexp` and `misexpedientes`? They all return
  `ZCSRFCPUBLISELECTBYNIFResponse` (or near-identical) and N8 notes
  duplicated descriptions.
- **Q3.** What is the canonical `RegistrarFicheroRequest` payload for
  the Sprint 5 use case (citizen aporting a single file to an existing
  expediente)? Which of `xmlRegistro`, `confirmarProcedimiento`,
  `documentos`, tramitation metadata are required vs optional?
- **Q4.** Is the `Uint8List` justificante a PDF, a ZIP envelope or a
  base64-as-bytes payload? STORY-38 needs the MIME to drive the
  download CTA.
- **Q5.** Confirm scope of the tramitation flow (`inicproc` →
  `miconfirmarproc` → `miobtenerres`): is it part of EPIC-5 in a
  later sprint, or owned by a separate "Tramitación" epic? R6 is
  still open on this.
- **Q6.** Confirm `miconsultareq` belongs to the Consultas y
  Reclamaciones surface and **not** to EPIC-5.

## Resolution

This document closes TASK-40 with:

- A documented contract reading of all eight in-scope endpoints, sourced
  exclusively from the generated client and the functional docs.
- A clear in-scope / follow-up split for Sprint 5 that unblocks
  STORY-35, STORY-37 and STORY-38 without inventing payloads.
- A typed adapter outline (no Dart code is shipped under this ticket;
  the implementation lands with the matching stories).
- Six open questions for product / backend that should be resolved
  before the listed follow-ups are scheduled.

The natural follow-up tickets implied by this discovery are:

1. A "Tramitación" task to land the `inicproc` /
   `miconfirmarproc` / `miobtenerres` screen, blocked on Q5.
2. A "Server-side expediente filters" sub-task to A/B
   `selectbynif*` vs `misexpedientes`, blocked on Q2.
3. A `RegistrarFicheroRequest` builder task to lift the justificante
   adapter from `unavailable` to live, blocked on Q3 and Q4.
