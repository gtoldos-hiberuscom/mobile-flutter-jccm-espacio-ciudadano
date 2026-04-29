# TASK-58 — Recommendations + life-events segmentation strategy

## Context

Sprint 6 opens the citizen-facing **Mis Recomendaciones** experience
(STORY-56 list with filters + grouping, STORY-57 empty/onboarding state).
This task formalises the contract assumptions and segmentation semantics
so the two presentation slices can be implemented against a stable,
tolerant adapter while the backend confirms ambiguous fields.

Inputs reviewed:

- `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`
  sections **7. Mis Recomendaciones** (7.1–7.2) and **8. Mis Hechos
  Vitales** (8.1–8.6).
- `documentation/initial_documentation/DOCUMENTO_COMPRENSION_FUNCIONAL.md`
  pantallas N6/N7.
- Generated client `generated/dart_dio_client/lib/src/api/hechos_vitales_api.dart`
  and models `tramite.dart`, `tramites_por_hecho.dart`,
  `lista_tramites_por_hechos.dart`, `hecho.dart`.
- Existing personalization code under `lib/features/personalization/`
  (STORY-54 life events, STORY-55 data consent / autorizaciones).

Out of scope: live wiring to backend (deferred to Sprint 7 governance
slice). This task delivers the contract decisions only; STORY-56 / 57
implement the UI against a tolerant in-memory adapter that mirrors the
decisions captured here.

## Endpoints in scope

| Section | Endpoint | Purpose | Required input |
|---------|----------|---------|----------------|
| 7.1 | `GET /hechos-vitales/servicios/{idAgente}` | Full list of recommended *trámites* derived from the citizen's selected life events | `idAgente` from JWT Cl@ve |
| 7.2 | `GET /hechos-vitales/servicios/segmentacion/{idAgente}` | Segmented subset for one bucket | `idAgente` + query `operacion` ∈ {`ultimos_dias`, `novedades`, `inmediatos`} |
| 8.1 | `GET /hechos-vitales/hechos/{idAgente}` | Currently selected life events for the citizen | `idAgente` |
| 8.5 | `GET /hechos-vitales/preferencias/{idAgente}` | Notification preferences (used by STORY-57 to know whether the user has reached the configured-but-empty branch) | `idAgente` |

The presentation slices in Sprint 6 only consume **7.1**, **7.2**, **8.1**
and **8.5**. PATCH/DELETE endpoints (8.2/8.4/8.6) are owned by the
existing Sprint-5 personalization features and are not invoked here.

## Generated contracts

`Tramite` (recommended *trámite*):

| Field | Type | Nullable | Notes |
|-------|------|----------|-------|
| `idTramite` | `int` | yes | Stable identifier; required to deduplicate across buckets |
| `nombreTramite` | `String` | yes | Display title |
| `idUnidadResponsable` | `int` | yes | Linked to backoffice unit catalogue (no client-side catalog yet) |
| `nombreUnidadResponsable` | `String` | yes | Used as subtitle / chip |
| `fechaPresentacionIni` | `String` | yes | ISO-like date string; **format unconfirmed** (see Open questions) |
| `fechaPresentacionFin` | `String` | yes | Same caveat as `fechaPresentacionIni` |

`TramitesPorHecho` (grouping payload):

- Wraps a `Hecho` (life event) and a list of `Tramite`.
- The list endpoint (7.1) returns `ListaTramitesPorHechos` — i.e. a list
  of groups — preserving the **agrupación por hecho vital** that
  STORY-56 needs natively.

`Hecho`:

- `idHecho` (int), `nombreHecho` (String), and a flag for whether the
  citizen has selected it (handled by personalization 8.1/8.2).

The segmentation endpoint (7.2) returns the same `Tramite` shape but
**flattened** (no group wrapper). This means the UI must regroup by
hecho vital after the fact, or accept that segmented buckets are
ungrouped lists.

## Decisions

### D1. Segmentation buckets and labels

The four UI tabs requested by STORY-56 acceptance criteria map to
backend operations as follows:

| UI tab (STORY-56) | Backend call | `operacion` | Notes |
|-------------------|--------------|-------------|-------|
| Todos | `GET /hechos-vitales/servicios/{idAgente}` (7.1) | n/a | Returns groups; UI keeps native grouping |
| Últimos días | `GET /hechos-vitales/servicios/segmentacion/{idAgente}` (7.2) | `ultimos_dias` | Recently published *trámites* — ungrouped |
| Novedades | `GET /hechos-vitales/servicios/segmentacion/{idAgente}` (7.2) | `novedades` | Newly assigned by backend curation — ungrouped |
| Tramitación inmediata | `GET /hechos-vitales/servicios/segmentacion/{idAgente}` (7.2) | `inmediatos` | Short-deadline subset — ungrouped |

The exact backend semantics of each bucket are not formally documented;
treat the UI labels as **opaque pass-through** labels and surface the
unit responsible + dates returned by the backend without re-interpreting
"novedades" client-side.

### D2. Grouping rules for the "Todos" tab

- The "Todos" tab is the only one that preserves the
  `TramitesPorHecho` grouping returned by 7.1.
- For the three segmented tabs the UI shows a flat list; if a future
  iteration needs grouped segmentation, the client must regroup against
  the cached "Todos" payload.
- A `Tramite` may legitimately appear under multiple `Hecho` groups in
  7.1; the entity layer must therefore key on `(idHecho, idTramite)`
  not on `idTramite` alone when rendering grouped lists.

### D3. Date handling

- `fechaPresentacionIni` / `fechaPresentacionFin` are received as
  strings. The tolerant adapter parses them best-effort with
  `DateTime.tryParse`; failures degrade to surfacing the raw string
  and no relative formatting.
- "Plazo" rendering rule for the UI:
  - both dates parsed → range "Del *iniLocal* al *finLocal*".
  - only `fin` parsed → "Hasta *finLocal*".
  - neither parsed → fallback "Plazo no disponible".

### D4. `idAgente` dependency

- `idAgente` is a JWT-derived identifier (`R3` in
  `MAPEO_DETALLADO_ENDPOINTS.md`). No formal helper exists yet.
- Sprint 6 deliverables operate against an **in-memory mock** repository
  and **must not** wire `idAgente` extraction. The contract for the
  domain repository is `Future<RecommendationCatalog> load({required
  String idAgente})`, with a placeholder identifier injected by a
  presentation-level provider for now.
- A `// TODO(future-sprint)` marker must accompany every place where the
  real Cl@ve resolution will plug in, pointing back to this section.

### D5. Empty-state classification (STORY-57)

The empty state distinguishes three branches:

1. **Pre-configuration**: no life events selected (8.1 returns empty).
   CTA → `Routes.preferencesConsent` placeholder + future "Mis hechos
   vitales" route.
2. **Pre-authorisation**: life events selected but no autorizaciones for
   recomendaciones (8.5). CTA → `Routes.preferencesConsent` (STORY-55
   surface).
3. **Configured but empty**: life events selected, autorizaciones
   present, but 7.1 returns no groups. UI shows reassurance copy and a
   "Volver a intentar" CTA.

The Sprint-6 mock repository implements all three branches via in-memory
state so STORY-57 can exercise each transition deterministically.

### D6. Tolerant adapter contract

Domain entity hierarchy (`lib/features/recommendations/0_entity/`):

```
RecommendationCatalog
 ├─ List<RecommendationGroup> groups        // empty when buckets are flat
 ├─ List<Recommendation>      flatItems     // populated for 7.2 buckets
 └─ RecommendationConfigState configState   // see D5

RecommendationGroup
 ├─ LifeEventRef hecho                      // {id, name}
 └─ List<Recommendation> items

Recommendation
 ├─ String  id                              // idTramite as string
 ├─ String  title                           // nombreTramite
 ├─ String? unitName                        // nombreUnidadResponsable
 ├─ String? rawStart / rawEnd               // raw strings preserved for debugging
 ├─ DateTime? start / end                   // best-effort parse
 └─ RecommendationBucket bucket             // enum: all/ultimosDias/novedades/inmediatos
```

Repository signature:

```dart
abstract class RecommendationsRepository {
  Future<RecommendationCatalog> loadAll({required String idAgente});
  Future<RecommendationCatalog> loadBucket({
    required String idAgente,
    required RecommendationBucket bucket,
  });
  Future<RecommendationConfigState> loadConfigState({required String idAgente});
}
```

The Sprint 6 implementation provides a single in-memory `Fake`
implementation. STORY-56 and STORY-57 must not import anything from
`generated/dart_dio_client/`; that wiring is deferred behind a feature
flag (`kRecommendationsLiveBackendEnabled = false`).

## Open product questions (defer to Sprint 7 governance)

1. **OP-1 — `operacion` semantics**: confirm whether `novedades` is
   computed against the citizen's last-seen timestamp or against the
   backend publication date globally. UI today shows whatever the
   backend returns without re-interpretation.
2. **OP-2 — Date format**: confirm timezone and format of
   `fechaPresentacionIni/Fin`. Today's tolerant parser accepts ISO 8601;
   if the backend emits `dd/MM/yyyy`, an extra parser must be added.
3. **OP-3 — Multi-group trámites**: confirm whether duplicates across
   groups in 7.1 are intentional (same trámite, multiple hechos) or a
   bug. The UI keeps both occurrences for now.
4. **OP-4 — Empty vs unauthorised distinction**: confirm whether 7.1
   returns 200-empty when permissions are missing or returns a 403/4xx
   that the adapter must translate. Mock currently treats 200-empty as
   the configured-but-empty branch (D5.3).
5. **OP-5 — `idAgente` extraction**: align with EPIC-2 on the canonical
   helper that surfaces `idAgente` from the Cl@ve session. Until then,
   STORY-56/57 inject a placeholder identifier.

## Impact on STORY-56 / STORY-57

- STORY-56 implements the `Recommendations` list page consuming
  `RecommendationsRepository.loadAll` for the "Todos" tab and
  `loadBucket` for the segmented tabs (D1, D2). Cards render unit
  responsible + plazo per D3.
- STORY-57 wires the empty-state and onboarding screens against the
  three branches in D5 and provides the CTAs back to the existing
  Sprint-5 surfaces (life events / autorizaciones).
- Both stories rely on the entity contract in D6 and the mock
  repository; live backend wiring is **not** part of Sprint 6.

## Follow-ups

- Sprint 7 — STORY-67 QA: validate empty-state branches against backend
  fixtures once available.
- Sprint 7 — STORY-65/66 governance: define the audit/policy rules for
  recommendations consumption and finalise the `idAgente` helper
  (OP-5).
- A future ticket should track the live wiring of
  `RecommendationsRepository` against the generated Dio client when
  OP-1..OP-4 are resolved.

## Sprint 7 closure annotation

Reviewed during Sprint 7 (SP-EC-APP-SQ2-07) under STORY-67 QA-as-code.
No new defects surfaced that contradict the strategy recorded above.
The decision matrix in this document remains the authoritative input
for the corresponding implementation ticket; outstanding items stay
parked on their owner sprint per the roadmap and are not escalated to
new tickets at this point.
