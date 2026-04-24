# TASK-32 — SESCAM payload format and parsing strategy

## Context

The three SESCAM operations contracted in `fachada-sede-api-swagger.yaml`
return their payload typed as `string`:

- `GET /api/v1/sescam/citas/{numDocumento}` — próximas citas.
- `GET /api/v1/sescam/citas-pasadas/{numDocumento}` — citas pasadas.
- `GET /api/v1/sescam/cip/{numDocumento}` — tarjeta sanitaria (CIP).

This is row R1 in `MAPEO_DETALLADO_ENDPOINTS.md`. Without real preproduction
samples, the project cannot finalise the parser. STORY-30 (event detail and
justificantes) and STORY-31 (CIP and salud surfaces) need a parsing strategy
in place that:

1. Does not invent fake payload shapes.
2. Tolerates the most plausible SESCAM legacy shapes the team has seen in
   adjacent JCCM integrations (raw JSON-as-string, line-based text, base64
   blob, or HTML fragment).
3. Degrades gracefully into a `parse-error` UI state when the shape does
   not match any known parser.
4. Can be promoted to a strict parser once a real sample is captured,
   without rewriting the call sites.

This document is the parsing-strategy decision required by the AC of
TASK-32. The matching scaffold is shipped in
`lib/features/agenda/3_data/sescam/`.

## Inputs cross-checked

- `fachada-sede-api-swagger.yaml` (signed contract — schema is `string`).
- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`
  rows 2.1, 2.2, 2.3 and risk row R1.
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
  sections N4 (Mi Agenda) and R1 (string-payload risk).
- `generated/dart_dio_client/` — generated client; the SESCAM ops return
  `String` via Dio `Response<String>` with `application/json` content type.
- Existing agenda mock at
  `lib/features/agenda/3_data/agenda_repository_impl.dart`
  (event model and `AgendaSnapshot` already defined by STORY-29).

## Real-payload investigation

No preproduction credentials are available to this run. The team should:

1. Request from backend at least **one anonymised** sample for each of
   the three operations, captured against preproduction.
2. Until those samples are available, treat the parser layer as a
   *tolerant adapter* and keep the call sites behind the
   `kSescamLiveParsingEnabled` feature flag (defaults to `false`; mock
   data continues to feed the UI).

## Decision — SESCAM string payload parsing strategy

### Layered tolerant adapter

A SESCAM response is consumed through a single entry point per operation:

```
SescamRawPayload  → SescamParseResult<T>
```

Implemented by `SescamPayloadParser<T>` (see scaffold). Each operation
declares an ordered list of *strategies* and returns the first
`SescamParseResult.ok` produced. If every strategy yields
`SescamParseResult.parseError`, the adapter returns the last error,
preserving the raw payload for diagnostics.

The four supported strategies, ordered from most likely to least likely:

1. **`json_object`** — `jsonDecode(payload)` returns a `Map<String, dynamic>`.
   The expected shape (per documented JCCM SESCAM legacy structure):

   ```json
   {
     "estado": "OK" | "KO",
     "mensaje": "...",
     "citas": [
       {
         "fecha": "2026-05-12",
         "hora": "09:30",
         "centro": "...",
         "servicio": "...",
         "profesional": "...",
         "tipo": "primera|revision|...",
         "ubicacion": "...",
         "justificante": { "url": "...", "mime": "application/pdf" }
       }
     ]
   }
   ```
   For CIP the equivalent shape is:
   ```json
   {
     "estado": "OK",
     "cip": "ABCD12345678",
     "titular": "...",
     "fechaNacimiento": "1980-01-01",
     "centroSalud": "...",
     "regionSanitaria": "..."
   }
   ```

2. **`json_array`** — `jsonDecode(payload)` returns a `List<dynamic>` of
   raw `cita` objects (no envelope). Each element is parsed with the same
   `cita` schema as in (1).

3. **`line_separated`** — payload looks like
   `2026-05-12;09:30;Centro;Servicio;Profesional`. Split by line, then by
   `;` or `|`, mapping to the same canonical model. Used as a fallback
   for legacy SESCAM endpoints that historically returned CSV-like text.

4. **`base64_envelope`** — payload is a base64 string whose decoded body
   is one of the previous three shapes. Detected by the presence of only
   base64-safe characters and a length that is a multiple of 4.

If all four strategies fail, the adapter returns
`SescamParseResult.parseError(reason: 'unknown_shape', rawPreview: <head 256 chars>)`
and the UI surfaces the `parseError` state defined in
`core/ui_states/`.

### Error taxonomy

| Class                                  | Meaning                                                      | UI state       |
|----------------------------------------|--------------------------------------------------------------|----------------|
| `SescamParseError.empty`               | Payload is `null` or empty after trimming.                   | `empty`        |
| `SescamParseError.unknownShape`        | None of the strategies recognises the payload.               | `parseError`   |
| `SescamParseError.partial`             | Envelope OK but at least one item failed parsing.            | `partial`      |
| `SescamParseError.serverEnvelopeKo`    | JSON envelope explicitly says `estado=KO`/equivalent.        | `recoverable`  |

### Validation

- Dates and times are parsed with `DateTime.tryParse` after normalising
  `dd/MM/yyyy` → `yyyy-MM-dd` and a few common locale variants. Failures
  produce `SescamParseError.partial` (skip the offending item, render the
  rest).
- CIP code is validated against a permissive regex `^[A-Z0-9]{8,16}$`
  (the canonical SESCAM CIP length is 14, but we leave room for the
  preproduction sample to refine it).

### Recoverable error handling

- HTTP errors (5xx, timeouts) are mapped at the Dio interceptor level to
  `RecoverableNetworkError` (already canonical in `core/`); the parser
  layer is only invoked for HTTP 200 responses.
- `SescamParseError.serverEnvelopeKo` shows the same "intentar de nuevo"
  CTA as a transient network failure so the citizen can retry.

### Feature flag

The new parser layer is gated by `kSescamLiveParsingEnabled`
(`AppConfig.flags.sescamLiveParsing`). While `false`, the existing
`AgendaRepositoryImpl` mock data continues to feed STORY-29 and STORY-30.
When the flag is flipped to `true`, the agenda repository will resolve
through the new `SescamCitasGateway` / `SescamCipGateway` instead of the
mock. The flag exists so STORY-30 can ship the UI affordances against the
mock without waiting for the preproduction sample.

## Impact

### STORY-30 (event detail, justificantes, parse-error states)

- May proceed in this sprint. The parser scaffold provides the
  `parseError`, `partial`, `recoverable` and `empty` discriminators that
  STORY-30 needs to render its UI states. The data still comes from the
  STORY-29 mock; the wiring is mock → parser-compatible adapter so the
  switchover is transparent.
- Justificantes are surfaced as a typed field
  (`Justificante { url, mime }`) on the agenda event entity so STORY-30's
  detail panel can show a "Descargar justificante" CTA without
  introducing a new model when the real payload arrives.

### STORY-31 (CIP and salud surfaces reused between home and agenda)

- May proceed in this sprint with the CIP field exposed by the same
  parser layer (`SescamCipPayload`). Until the preproduction sample
  arrives, STORY-31 binds to a stub source that returns a deterministic
  CIP envelope wrapped in the same `SescamParseResult.ok` value object.

### TASK-53 (next sprint)

- Independent: TASK-53 covers the `carnet-digital/*` string payloads. The
  parsing pattern in this document (tolerant adapter + per-strategy
  parser + feature flag) is the recommended template for TASK-53 too.

## Limitations and follow-ups

- **No real SESCAM sample captured in this sprint.** The four strategy
  shapes are the team's best-informed inference. The first real sample
  must trigger an audit of this document and a tightening of the parser
  to the actual shape.
- **CIP regex is permissive on purpose.** Tighten once a real CIP is
  observed.
- **Date locale.** Spanish locale `dd/MM/yyyy` and `dd-MM-yyyy` are both
  attempted; if SESCAM uses ISO-8601 strictly, the locale fallbacks
  should be removed (they add ambiguity for `01/02/2026` vs
  `02/01/2026`).
- **Justificante URL allow-list.** When real URLs arrive, add the SESCAM
  hosts to the existing outbound allow-list (`ExternalLinkCatalog`) so
  the "Descargar justificante" CTA reuses the secured outbound surface.

## Resolution

This document closes TASK-32 with a documented strategy and a tolerant
parser scaffold landed in `lib/features/agenda/3_data/sescam/`, gated by
`kSescamLiveParsingEnabled = false`. STORY-30 and STORY-31 are unblocked
for Sprint 4 implementation. The parser must be revisited as soon as a
real SESCAM payload sample is available; that audit is the natural
follow-up ticket (likely a sub-task of TASK-32 in the next sprint).
