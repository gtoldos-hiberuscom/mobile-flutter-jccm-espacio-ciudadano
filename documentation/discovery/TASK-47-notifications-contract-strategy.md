# TASK-47 — Notifications + contact-data registration contract strategy

## Context

Sprint 5 opens EPIC-6 (Notifications). The four downstream stories
(STORY-41 listing, STORY-42 contact registration, STORY-43 pending
detail with accept/reject, STORY-44 non-pending variants with
documents) all assume a backend contract that the initial documentation
flagged as **only provisionally assigned**:

- `MAPEO_DETALLADO_ENDPOINTS.md` §5 lists `POST /servicio/midetalle` as
  the listing/detail endpoint with the comment **"Endpoint por
  confirmar con backend"** (risk row R2).
- `DOCUMENTO_COMPRENSION_FUNCIONAL.md` N5 reiterates that the
  assignment is provisional and that confirmation is a pre-condition
  for development of the screen.
- `MAPEO_DETALLADO_ENDPOINTS.md` §5.2 reuses
  `POST /publicacion/midocfirmados` (also referenced in §9.3 for Firma
  Digital) as the source of associated documents.

This document closes the TASK-47 discovery question by reconciling
those references with the **generated Dio client** that ships in
`generated/dart_dio_client/` (the only signed contract we currently
have), proposes a state-model + document-association strategy, and
states explicitly what to do for STORY-42 given that the API has **no**
contact-registration operation.

Inputs cross-checked:

- `generated/dart_dio_client/doc/ServicioApi.md`
- `generated/dart_dio_client/doc/PublicacionApi.md`
- `generated/dart_dio_client/lib/src/api/servicio_api.dart`
- `generated/dart_dio_client/lib/src/api/publicacion_api.dart`
- Models: `DTQUERY`, `ZCSRFCPUBLISELECTBYNIFResponse`,
  `PUBLICACIONPORTAL`, `ZCSSTPUBPORTAL`, `ZCSSTTBDOCUMENTO`,
  `ZCSTBDOCUMENTO`, `ZCSRFCDOCSFIRMADOSPFEXPTE`,
  `ZCSRFCDOCSFIRMADOSPFEXPTEResponse`, `ETLISTDOCS`,
  `ZCSLISTADODOCSEXPTE`, `ETRETURN`, `BAPIRET2`.
- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md` §5
  + R2.
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
  N5 + R2.

## Real signatures observed in the generated client

### Listing / detail — `POST /api/v1/servicio/midetalle`

| Aspect              | Observed value                                                           |
|---------------------|--------------------------------------------------------------------------|
| Method / path       | `POST /api/v1/servicio/midetalle`                                        |
| Operation id        | `miDetalleOperation` (`ServicioApi`)                                     |
| Request body        | `DTQUERY { query: String }`                                              |
| Response body       | `ZCSRFCPUBLISELECTBYNIFResponse { isubrc, publicacionportal, resultado }`|
| Item collection     | `publicacionportal.item: List<ZCSSTPUBPORTAL>`                           |
| Auth                | "No authorization required" in doc, but JWT Cl@ve still expected at gateway level (consistent with the rest of the federated POST family). |

`ZCSSTPUBPORTAL` exposes fields relevant to a notification card:
`asunto`, `desasunto`, `estado`, `fechaini`, `fechafin`, `fechareg`,
`numexp`, `ejeexp`, `tipoproc`, `desproc`, `desuniorg`, `consej`,
`desconsej`, `email`, `tlfno`, plus a nested `documentos:
ZCSSTTBDOCUMENTO { item: List<ZCSTBDOCUMENTO> }` where each
`ZCSTBDOCUMENTO` carries `ejeexp`, `numexp`, `tipoproc`, `iddoc`.

**Contract status: confirmed at the wire-shape level, semantically
risk-flagged.** The endpoint exists, returns a list of expediente-shaped
objects with a state field and an embedded document list, which matches
the functional intent of a notifications inbox. What is *not*
confirmed is whether `estado` carries the four notification states the
product expects (pendiente / aceptada / rechazada / caducada) or the
expediente-lifecycle states ("en tramite", "finalizado", …). R2 from
the initial documentation therefore stays open at the *value-set*
level even though it can be closed at the *signature* level.

> Side observation (worth flagging upstream): the same operation is
> *also* generated under `PublicacionApi.miDetalleOperation` pointing
> to the identical `POST /api/v1/servicio/midetalle`. This is a swagger
> duplication, not a second endpoint. The notifications feature must
> bind to **`ServicioApi.miDetalleOperation`** to keep the call site
> consistent with the documented mapping.

### Document association — `POST /api/v1/publicacion/midocfirmados`

| Aspect              | Observed value                                                           |
|---------------------|--------------------------------------------------------------------------|
| Method / path       | `POST /api/v1/publicacion/midocfirmados`                                 |
| Operation id        | `miDocsfirmados` (`PublicacionApi`)                                      |
| Request body        | `ZCSRFCDOCSFIRMADOSPFEXPTE { ipclase, ipejeexp, ipnumexp, iprefdoc, etlistdocs?, etreturn? }` |
| Response body       | `ZCSRFCDOCSFIRMADOSPFEXPTEResponse { etlistdocs, etreturn }`             |
| Item collection     | `etlistdocs.item: List<ZCSLISTADODOCSEXPTE>`                             |
| Per item            | `clase`, `codmod`, `descrip`, `ejeexp`, `numexp`, `numdoc`, `fechadoc`, `horarege`, `numrege`, `datarege`, `idtransaccion` |

**Contract status: confirmed.** The request is **per-expediente**
(`ipejeexp` + `ipnumexp` + `ipclase` + `iprefdoc`), not per-NIF. This
is the key shape constraint for STORY-44: documents cannot be fetched
in a single bulk call for the whole inbox; they are fetched on detail
expansion using the expediente coordinates already present on the
`ZCSSTPUBPORTAL` item from the listing.

## Proposed notification state model

Given that `ZCSSTPUBPORTAL.estado` is a free-form `String` whose real
value-set is unknown, the domain enum is defined in code with a
**tolerant parser** that maps observed strings to canonical values and
funnels everything else to `unknown`, mirroring the strategy adopted by
TASK-32 for SESCAM.

Proposed enum (placeholder names; final mapping pending real sample):

```text
NotificationStatus
  pendiente   ← {"P", "PENDIENTE", "PEND", "0", … TBC}
  aceptada    ← {"A", "ACEPTADA", "ACEPT", "1", … TBC}
  rechazada   ← {"R", "RECHAZADA", "RECH", "2", … TBC}
  caducada    ← {"C", "CADUCADA", "EXPIRADA", "EXP", "3", … TBC}
  unknown     ← anything else (logged, surfaced as neutral chip)
```

Parser rules:

1. Trim + uppercase the raw value before lookup.
2. Lookup table is keyed by the **placeholder** sets above; each set is
   a `Set<String>` so the table is widened by appending observed values
   without code rewrites.
3. Unknown values must not block rendering: the row is shown with a
   neutral status chip and a structured warning is logged
   (`status_unknown` event with the raw value) so that the first real
   sample drives a one-line table update, not a redesign.
4. The enum is owned by `lib/features/notifications/0_entity/` (per the
   canon, layer 0). DTO → entity mapping happens in
   `3_data/mappers/`.

Open question to take to backend: confirm the actual value-set for
`estado` and whether it includes a "leída/no leída" axis distinct from
the lifecycle status. Until confirmed, "leída" is treated as a
client-side flag (not part of the enum) and persisted locally if
STORY-41 needs it.

## Document-association strategy

The listing already returns `documentos.item[]` per notification, so
the listing screen can show the **count** of associated documents
without a second call. The detail screen (STORY-43 / STORY-44) must
then call `POST /publicacion/midocfirmados` to obtain the full
metadata (descrip, fechadoc, numrege, …) needed to render a downloadable
list.

Mapping the listing item → the detail call:

| Listing field (`ZCSSTPUBPORTAL`) | Detail request field (`ZCSRFCDOCSFIRMADOSPFEXPTE`) |
|---------------------------------|-----------------------------------------------------|
| `ejeexp`                        | `ipejeexp`                                          |
| `numexp`                        | `ipnumexp`                                          |
| `tipoproc`                      | candidate for `ipclase` (pending backend confirm)   |
| `documentos.item[].iddoc`       | candidate for `iprefdoc` (per-document filter, optional in the bulk variant) |

`ipclase` semantics ("clase") are not documented in the swagger and
must be confirmed: the safe default for the notifications detail call
is to send `ipejeexp` + `ipnumexp` and let the backend return all
signed documents for the expediente, then filter client-side by
`iddoc` against the listing-embedded `documentos.item[]` if the user
opens a specific document. This keeps STORY-44 implementable with the
fields we are sure about.

## Contact-data registration backend (STORY-42)

**A literal scan of the generated client (`grep -i contacto|contact|
telefono|movil|email|alta` over `generated/dart_dio_client/doc/`)
returns only `ZCSSTPUBPORTAL` — i.e. those fields appear as
*response* properties of the notifications listing, not as the body
of any registration endpoint.** There is **no** `POST` operation
in the swagger that registers, updates or validates the citizen's
phone/email pair for the electronic-notification platform.

Operational consequence for STORY-42:

- The story **cannot** ship a real backend write in Sprint 5.
- Adopt the **mock-with-deferred-Dio-wiring** pattern already used by
  TASK-71 / STORY-48 for cards and by TASK-32 for SESCAM:
  - The `2_presentation/` form (phone + email, requires at least one)
    is implemented in full, including validation, copy and success
    state.
  - The `1_domain/` use case (`RegisterNotificationContactUseCase`)
    is defined against an abstract `NotificationContactRepository`.
  - The `3_data/` implementation ships a `MockNotificationContactRepository`
    behind a feature flag (proposed name:
    `kNotificationContactLiveBackendEnabled`, default `false`). The
    mock returns a deterministic success after a short artificial
    latency so the success state and the return-to-inbox flow are
    fully exercised.
  - The DI composition point in `2_presentation/providers/` resolves
    to the mock while the flag is `false`. When the real endpoint is
    published, only the data-layer adapter and the flag flip change;
    no UI rewrite is required.
- A follow-up ticket must be created against EPIC-6 to **wire the
  real backend** once the contract appears (proposed title:
  "TASK — Wire RegisterNotificationContact to real backend"). That
  ticket is out of scope for TASK-47 and out of scope for STORY-42's
  Sprint-5 acceptance.
- STORY-42 acceptance criterion 4 ("Se explicitan dependencias de
  backend si no existe contrato confirmado en la API actual") is
  satisfied **by this discovery document**; the story only needs to
  reference it.

## Impact matrix on STORY-41 / 42 / 43 / 44

| Story    | Status after TASK-47                | Concrete acceptance-criteria delta                                                                                          |
|----------|-------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| STORY-41 | Unblocked for implementation        | Bind listing to `ServicioApi.miDetalleOperation`; map `ZCSSTPUBPORTAL` → `Notification` entity; render the four canonical states via the tolerant parser; client-side filter + paginate (backend offers no pagination params, so paging is local on the returned list); ordering defaults to `fechareg desc`. |
| STORY-42 | Unblocked **with mock backend only**| Implement form + validation + copy + success state against `MockNotificationContactRepository` behind `kNotificationContactLiveBackendEnabled = false`; AC #4 satisfied by reference to this document; create follow-up ticket for real wiring. |
| STORY-43 | Partially unblocked                 | Detail screen reads from the same `ZCSSTPUBPORTAL` returned by the listing (no per-id detail endpoint exists); accept/reject **actions** have **no backend operation in the current swagger** — apply the same mock-with-deferred-wiring pattern (`kNotificationActionsLiveBackendEnabled`, default `false`); confirmation step before reject is purely client-side. **New open backend question** added below. |
| STORY-44 | Unblocked for implementation        | Variants aceptada / rechazada / caducada are rendered from the same `estado` enum; documents list is fetched on detail open via `PublicacionApi.miDocsfirmados` using `ipejeexp` + `ipnumexp` from the listing item; "no documents" and `etreturn` error envelope drive the empty/error states; download URL strategy is deferred (see open question). |

## Open backend questions

1. **`estado` value-set.** Confirm the literal strings emitted for
   the four notification states. Until confirmed, the parser maps
   permissively and unknown values render with a neutral chip.
2. **`ipclase` semantics** in `ZCSRFCDOCSFIRMADOSPFEXPTE`. Confirm
   whether it is required, derivable from `tipoproc`, or optional.
3. **Accept / reject actions.** Confirm the operation that records
   the citizen's accept / reject decision against an electronic
   notification. None is present in the current swagger.
4. **Contact-data registration.** Confirm if a backend operation is
   planned for the citizen's phone/email pair, and whether validation
   (SMS / email confirmation) is part of the same flow.
5. **Document download.** `ZCSLISTADODOCSEXPTE` exposes `idtransaccion`
   + `numdoc` but no direct download URL. Confirm whether download
   reuses an existing operation (e.g. the carnet-digital PDF pattern,
   `POST /carnet-digital/pdf/{dni}`-style) or if a dedicated operation
   is required.
6. **Push notifications (N3).** Out of scope for TASK-47 and confirmed
   to remain a fase-2 capability; no contract is expected in Sprint 5.

## Resolution

This document closes TASK-47 with:

- A **confirmed wire shape** for `POST /servicio/midetalle` and
  `POST /publicacion/midocfirmados` against the generated Dio client.
- A **placeholder-driven state model** with a tolerant parser to
  absorb the value-set risk (R2) without blocking Sprint-5
  implementation.
- A **document-association strategy** that uses the listing-embedded
  `documentos.item[]` for counts and defers full metadata to the
  detail-screen `midocfirmados` call.
- An **explicit statement that no contact-registration backend
  exists**, with a mock-with-deferred-wiring pattern so STORY-42 can
  ship Sprint-5 UI without inventing a contract.
- An **impact matrix** that lets STORY-41/43/44 proceed and pins
  STORY-42 to the mock path with a follow-up ticket reservation.

This document must be revisited as soon as backend confirms the
`estado` value-set, the accept/reject operation, and any future
contact-registration endpoint. Each of those confirmations is a
single-line table update inside this file plus a flag flip in code.

## Sprint 7 closure annotation

Reviewed during Sprint 7 (SP-EC-APP-SQ2-07) under STORY-67 QA-as-code.
No new defects surfaced that contradict the strategy recorded above.
The decision matrix in this document remains the authoritative input
for the corresponding implementation ticket; outstanding items stay
parked on their owner sprint per the roadmap and are not escalated to
new tickets at this point.
