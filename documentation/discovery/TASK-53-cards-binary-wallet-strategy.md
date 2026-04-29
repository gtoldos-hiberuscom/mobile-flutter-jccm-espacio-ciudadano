# TASK-53 — Carnets digitales: binary payload + wallet integration strategy

## Context

EPIC-7 ("Mis carnets digitales") groups four user stories that all consume the
`/carnet-digital/*` namespace and need to materialise binary or quasi-binary
artifacts (QR images, PDF documents, PKPass wallet bundles, plus the textual
"grado de discapacidad" payload). Before any of those stories starts coding,
the team needs a frozen contract for:

- what the generated Dio client actually returns per endpoint,
- how to discriminate functional success from a business error and from a
  malformed binary,
- which wallet integration paths are realistic on Apple/Google,
- how files are named, stored temporarily and cleaned up.

Inputs cross-checked:

- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md` section 6
  (rows 6.1–6.8, plus risk row R1).
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
  block 6 ("Mi Carnet Digital") and risk N4.
- `generated/dart_dio_client/doc/CarnetDigitalApi.md` and
  `generated/dart_dio_client/lib/src/api/carnet_digital_api.dart`.
- Generated models: `CarnetQr`, `CarnetJoven`, `DatosFamiliaNumerosa`,
  `PkpassFamiliaNumerosa`, `RequestFachadaDiscapacidadInterm`.
- `documentation/discovery/TASK-71-cards-surfaces-decision.md` — already
  resolves the catalogue surfaces (CIP read-only / biblioteca OUT_OF_MVP) and
  defers the federated payload strategy to **this** discovery. This document
  does **not** restate those surface decisions; it strictly closes the
  payload + wallet contract for the federated `carnet-digital/*` operations.

## Generated client signatures (frozen)

Source of truth: `generated/dart_dio_client/lib/src/api/carnet_digital_api.dart`.
All operations resolve to `Future<Response<T>>`, declared `Accept:
application/json`, no auth required at swagger level (the citizen token is
injected by our app interceptor). The DNI is a path parameter; the payload
is JSON only on POST endpoints.

| # | Operation                          | HTTP                                            | Return type (Dio)            | Wire shape                                               |
|---|------------------------------------|-------------------------------------------------|------------------------------|----------------------------------------------------------|
| 1 | `obtenerCarnetJoven`               | `GET /carnet-digital/joven/{dni}`               | `CarnetJoven`                | Structured JSON: `numero`, `titular`, `fechaNacimiento`, `fechaFinValidez`, `enTramitacion`. No binary. |
| 2 | `obtenerDatosFamiliaNumerosa2`     | `GET /carnet-digital/familia-numerosa/{dni}`    | `DatosFamiliaNumerosa`       | Structured JSON: `numeroTitulo`, `fechaValidezDesde/Hasta`, plus `codError`/`descError`/`datos` envelope. |
| 3 | `obtenerDatosFamiliaNumerosa1`     | `GET /carnet-digital/grado-discapacidad/{dni}`  | `String`                     | Opaque `string`. Per N4, structure unknown — could be a digit, a JSON literal, or base64 wrapper. |
| 4 | `obtenerDatosFamiliaNumerosa`      | `POST /intermediacion/discapacidad/datos`       | `String`                     | Opaque `string`. Same N4 risk profile. Body: `RequestFachadaDiscapacidadInterm`. |
| 5 | `obtenerQr`                        | `POST /carnet-digital/qr/{dni}`                 | `CarnetQr` (`{qr: String?}`) | Single string field; expected to be the QR payload (data URI / base64 PNG / raw text — to confirm). |
| 6 | `obtenerPdf`                       | `POST /carnet-digital/pdf/{dni}`                | `String`                     | Expected base64-encoded PDF (per row 6.7 + N4). |
| 7 | `obtenerPkPass`                    | `POST /carnet-digital/pkpass/{dni}`             | `String`                     | Expected base64-encoded `.pkpass` zip (per row 6.8 + N4). |
| 8 | `obtenerPkPassFamiliaNumerosa`     | `GET /carnet-digital/familia-numerosa-pkpass/{dni}` | `PkpassFamiliaNumerosa`  | Envelope `{pkpass, datos, codError, descError}` — `pkpass` expected base64. |
| 9 | `obtenerPkPassFamiliaNumerosa1`    | `GET /carnet-digital/discapacidad-pkpass/{dni}` | `String`                     | Bare string (no envelope) — expected base64 `.pkpass`. |

Two structural patterns coexist: **bare `String`** (ops 3, 4, 6, 7, 9) and
**typed envelope with `codError`/`descError` + payload field** (ops 2, 5, 8).
The contract is therefore *not* uniform — discrimination logic must be
declared per family.

## Success / business-error / invalid-binary discrimination

The Dio layer already throws `DioException` for HTTP ≥ 400 and for IO errors.
Beyond that, three stable signals must be combined per family. All thresholds
below are **provisional defaults** to be hardened once TASK-53 obtains a real
sample (see open questions); they are safe lower bounds derived from the
PKPass / PDF / PNG specifications.

### 1. Envelope endpoints (`DatosFamiliaNumerosa`, `CarnetQr`,
`PkpassFamiliaNumerosa`)

Order of checks:

1. **HTTP failure** → `Failure.network` / `Failure.server`.
2. **`codError` present and non-empty** → `Failure.business(codError, descError)`.
   Treat empty string and `"0"` / `"00"` as success sentinels until backend
   confirms; route any unknown value through a default "business error"
   branch, never through success.
3. **Required payload field missing or empty** (`numeroTitulo`,
   `qr`, `pkpass`) → `Failure.empty` (renders "no disponible" state).
4. **Otherwise** → success; pass the payload to the binary validator below
   when it is supposed to be binary (`pkpass`, `qr` if base64).

### 2. Bare `String` endpoints (PDF, PKPass generic, discapacidad-pkpass,
grado-discapacidad)

Order of checks:

1. **HTTP failure** → `Failure.network` / `Failure.server`.
2. **Empty / whitespace string** → `Failure.empty`.
3. **JSON-shaped error fallback**: defensive parse — if the body parses to a
   JSON object containing `codError` / `descError` / `error` / `mensaje`, route
   to `Failure.business`. Several JCCM façade endpoints reuse this shape even
   when typed as `string`.
4. **Binary validator** for PDF/PKPass families (see next subsection).
5. For `grado-discapacidad`, no binary validator: trim and try `int.tryParse`
   then a JSON object parse; if neither yields a usable value, surface as
   `Failure.parse` with the raw payload elided from logs (PII).

### 3. Binary validator (after base64 decode)

A single `BinaryArtifact` value object owns the validator. Steps applied in
order on the decoded bytes:

| Family | Magic header                              | Min length (provisional) | Expected MIME           |
|--------|--------------------------------------------|--------------------------|-------------------------|
| PDF    | `25 50 44 46 2D` (`%PDF-`)                 | 1 KiB                    | `application/pdf`       |
| PKPass | `50 4B 03 04` (ZIP) **and** archive must contain `pass.json` and `manifest.json` | 4 KiB | `application/vnd.apple.pkpass` |
| QR PNG | `89 50 4E 47 0D 0A 1A 0A`                  | 256 B                    | `image/png`             |
| QR raw | UTF-8 printable, ≤ 2953 chars              | n/a                      | `text/plain`            |

If the magic header check fails the artifact is classified
`Failure.invalidBinary` and never written to disk. The min-length thresholds
exist to reject obvious truncation; they are deliberately loose and must be
re-tuned with a real sample. The PKPass deep check (zip table of contents)
is required because Apple Wallet refuses installation otherwise — failing
fast in-app produces a much better UX than handing a broken file to the OS.

`CarnetQr.qr` may legitimately be either a base64 PNG (data URI prefixed or
not) or the raw textual payload meant to be re-encoded by a Flutter QR
widget. The validator therefore returns a *kind* (`png` / `text`) rather
than rejecting one of the two; the presentation layer chooses the renderer.

## Wallet integration constraints + Flutter package candidates

Versions below are **proposals**, not commitments. Each candidate must be
re-validated at adoption time against the current Flutter / Dart SDK and the
project's lints. No package is added in this discovery.

### Apple Wallet (`.pkpass`)

- iOS exposes `PKAddPassesViewController` from `PassKit`. The OS-level
  install dialog is mandatory; we do not control its UI.
- The pass must be a valid signed `.pkpass` (the backend signs server-side —
  we do not re-sign in app).
- Candidate packages:
  - **`pass_flutter`** — exposes a Dart wrapper to parse and add passes;
    last release lineage is small. Acceptable as a thin parsing helper but
    we should not depend on it for the *add to wallet* gesture if we can
    avoid the bridge.
  - **Native channel (preferred)** — a ~30 LOC `MethodChannel` calling
    `PKAddPassesViewController` with the bytes from the temp file. This is
    the lowest-risk path, owned in `lib/core/wallet/` per the canon.
- iOS Universal Links / `passkit-server` are **not** in scope for the MVP
  (no signed-by-us backend dialog, the user installs from the in-app file).

### Google Wallet

- Google Wallet does **not** consume `.pkpass`. It expects a JWT with a
  Google-issued class/object reference, requested via the
  `addToGoogleWallet` Web/Android intent.
- The JCCM backend currently exposes only `.pkpass`. Therefore, on Android
  the realistic options are:
  1. Open the `.pkpass` via system intent → falls through to any
     installed third-party wallet (PassWallet, WalletPasses). Most likely
     Sprint-5 path.
  2. Add a future Google Wallet pass class (separate backend work,
     out of scope for EPIC-7).
- Candidate packages:
  - **`flutter_google_wallet`** / **`add_to_wallet`** — only useful when
    the backend issues Google-signed JWTs. **Not adopted in MVP**.
  - **`open_filex`** + `share_plus` — to surface the `.pkpass` to the
    Android chooser.

### Cross-platform fallback

When neither native wallet path is viable (older OS, no wallet app
installed, or `Failure.invalidBinary`), the contract is:

- PDF/QR PNG → preview via `open_filex` (or in-app PDF viewer if the
  cards feature ever needs an embedded preview), and "Compartir" via
  `share_plus`.
- PKPass → "Compartir" via `share_plus` only; no in-app preview, no
  open-in-browser (the `.pkpass` MIME outside Wallet has no useful viewer).
- All fallbacks must be reachable from the same action menu so the UI does
  not branch by platform at the page level — branching is owned by a single
  `WalletAction` controller in `lib/features/digital_cards/2_presentation/`.

## File naming + temporary-file cleanup

### Naming convention

`<card-kind>-<format>-<yyyymmdd>-<shortHash>.<ext>`

- `card-kind`: `familia-numerosa` | `joven` | `discapacidad` | `qr`.
- `format`: `pdf` | `pkpass` | `qr`.
- `yyyymmdd`: date of generation (UTC, app clock — *not* the citizen's
  birthdate).
- `shortHash`: first 8 hex chars of `sha256(dni + endpoint + epochMillis)`.
  Provides uniqueness without leaking PII; the DNI itself **must not** appear
  in the filename.
- Extensions: `.pdf`, `.pkpass`, `.png`. The MIME is set explicitly when
  invoking `share_plus` / `open_filex`.

Examples (illustrative): `familia-numerosa-pdf-20260421-3f8b1c20.pdf`,
`joven-qr-20260421-9ab10042.png`.

### Temporary storage + cleanup

- Files land in `getTemporaryDirectory()/digital_cards/`. Never in
  `getApplicationDocumentsDirectory()` — the MVP does not persist citizen
  binaries.
- Each binary write is preceded by a directory sweep that deletes any file
  older than 24h or whose name matches the same `card-kind+format` (the
  freshest artifact wins; older variants are removed eagerly).
- Best-effort `try { … } finally { delete }` around the system intent is
  **not** sufficient because the OS may still hold the file open. The
  `digital_cards/` directory is therefore additionally swept on every cold
  start by `lib/core/storage/temp_cleanup.dart` (consumed via the app
  bootstrap; a hook owned by EPIC-7 if it does not exist yet — to be
  confirmed during STORY-52).
- No log line, telemetry event or analytics event ever includes the file
  body, the citizen DNI, or the holder name. The `shortHash` may be logged.

## Impact matrix on STORIES

| Story    | What unlocks                                                              | AC delta required                                                                                                        |
|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| STORY-49 | Familia numerosa: render `numeroTitulo`/`fechaValidez*`, plus QR/PDF/PKPass actions. | Bind to `obtenerDatosFamiliaNumerosa2` (envelope) for read; `obtenerQr`, `obtenerPdf`, `obtenerPkPassFamiliaNumerosa` for actions. Apply envelope discrimination + binary validator. AC4 ("errores") must reference `Failure.business` vs `Failure.invalidBinary`. |
| STORY-50 | Carnet joven: full data + QR/PDF/PKPass.                                   | Bind to `obtenerCarnetJoven` (no envelope, structured), plus `obtenerQr`/`obtenerPdf`/`obtenerPkPass` (generic). Modal variant reuses the same view-model. AC2 (modal) is purely presentation; no backend delta. |
| STORY-51 | Discapacidad: grado + PKPass; explicit "no vigente" branch.                | Bind to `obtenerDatosFamiliaNumerosa1` (`grado-discapacidad`) using the bare-string discrimination; PKPass via `obtenerPkPassFamiliaNumerosa1`. AC3 ("no vigente") is satisfied when grado parses but no PKPass payload returns (`Failure.empty`). AC4 ("parsing errors") maps to `Failure.parse`. |
| STORY-52 | Cross-cutting wallet pipeline.                                             | Owns the `BinaryArtifact` value object, the temp-file naming/cleanup contract, the wallet-action controller and the platform branching. AC1 binds to the validator; AC2 to `open_filex`+`share_plus`; AC3 to the iOS native channel + Android fallback documented above; AC4 to the cleanup contract. |

## Open backend / product questions

Each bullet is an explicit ask to escalate before the implementation tickets
of EPIC-7 leave Sprint 5.

- **Real samples** — request from the backend team one captured response per
  endpoint (PDF, generic PKPass, familia-numerosa PKPass, discapacidad
  PKPass, QR, grado-discapacidad). Without these, the magic-header thresholds
  in this document remain provisional.
- **`CarnetQr.qr` format** — confirm whether it is the raw QR payload
  (text), a base64 PNG, or a data URI. The validator already handles all
  three but the renderer choice affects accessibility (alt text vs image).
- **Envelope `codError` sentinels** — confirm the canonical "success" values
  for `codError` across the three envelope endpoints. Default assumption:
  `null`, empty string, `"0"`, `"00"`. Anything else → business error.
- **Discapacidad `grado` shape** — confirm whether the response is a bare
  integer percentage, a JSON object with `grado` field, or a free-form
  string. Affects STORY-51 AC4.
- **Google Wallet roadmap** — confirm whether JCCM intends to issue
  Google-signed wallet objects in a later release. If yes, schedule a
  follow-up ticket under EPIC-7 to add the JWT exchange; if no, the Android
  fallback documented here is the steady state.
- **Backend signing of `.pkpass`** — confirm that the bytes returned are
  already signed and ready for `PKAddPassesViewController`. If not, EPIC-7
  is blocked on backend work and STORY-52 cannot ship the iOS native add.
- **Temp cleanup hook** — confirm whether `lib/core/storage/temp_cleanup.dart`
  exists or must be created as part of STORY-52; the canon-compliant home is
  `lib/core/storage/`.

## Resolution

This discovery freezes the per-endpoint return types from the generated
client, defines the success / business-error / invalid-binary discrimination
per family, proposes the wallet integration path per platform with explicit
fallbacks, and pins the file-naming + temp-cleanup contract that STORY-52
will own. STORIES 49–51 may proceed in implementation against the matrix
above; STORY-52 owns the shared wallet pipeline. Real-sample validation and
the open backend questions remain to be closed before any of those stories
exit Sprint 5.
