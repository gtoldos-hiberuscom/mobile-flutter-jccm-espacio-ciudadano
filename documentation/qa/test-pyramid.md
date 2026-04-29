# Test pyramid

Sprint: Sprint 7 (SP-EC-APP-SQ3-07)
Last updated: 2026-04-29

## Snapshot

| Layer            | Files | Tests (approx) | Location                                  |
|------------------|------:|---------------:|-------------------------------------------|
| Unit / domain    |   ~57 |          ~285  | `test/core/**`, `test/features/**/*notifier*`, `*use_case*`, `*validator*` |
| Widget / state   |   ~29 |          ~140  | `test/features/**/*widget*`, `*page*`     |
| Contract         |     1 |              8 | `test/contract/`                          |
| Integration / e2e|     1 |              1 | `test/integration/` (smoke happy path)    |
| **Total**        |    87 |        **434** |                                           |

(Counts are derived from `find test -name '*_test.dart'` and
`flutter test` output as of 2026-04-29.)

## Per-layer policy

### Unit
- Pure Dart, no `WidgetTester`.
- Owns: domain notifiers, use cases, validators, mappers, core
  primitives (`TtlCache`, `RetryInterceptor`, connectivity mapping).
- Target: ≥1 test per public method on every notifier / use case.

### Widget / state
- Uses `flutter_test`'s `testWidgets` and `ProviderScope` with
  fakes / overrides; never touches real network or platform channels.
- Owns: page-level renders, golden-comparable visual states, accessible
  semantics for the high-traffic surfaces (home, agenda, casework,
  notifications, recommendations, carnets — see STORY-67 deliverables).

### Contract
- Located in `test/contract/`. Sprint 7 / STORY-66.
- Validates that the **generated** Dio client (`generated/dart_dio_client/`)
  can serialize / deserialize representative payloads sourced from
  `documentation/initial_documentation/MAPEO_DETALLADO_ENDPOINTS.md`.
- Endpoints currently covered:
  - `POST /publicacion/selectbynumexp` (request + response, happy +
    minimal)
  - `POST /publicacion/selectbynumreg` (request)
  - `CarnetJoven` and `CarnetQr` model deserialization (covers
    `/carnet-digital/qr/{dni}` and ancillary carnets endpoints)
  - Generated serializer registry sanity (roundtrip + non-empty)
- Endpoints **not yet** covered (declared as gaps to address when the
  features wire up real adapters in subsequent sprints):
  - `POST /publicacion/selectbynif` (mock-only repository today —
    contract test can be added when `CaseworkRepositoryImpl` swaps its
    mock for a Dio call)
  - `POST /servicio/midetalle` (endpoint not confirmed by backend per
    MAPEO §R2 — contract test deferred until the response shape is
    stable)
  - Recommendations endpoints (no spec entry available; tracked as a
    Sprint 8/9 gap, not a STORY-66 regression)

### Integration / e2e
- Located in `test/integration/` and tagged `e2e`.
- One smoke happy path per epic, exercising the route from login →
  feature → back. Sprint 7 ships the bootstrap test under STORY-67;
  Sprint 8/9 expand coverage as part of UAT closure.

## Drift protection

- `scripts/verify_codegen_drift.sh` (new in Sprint 7) hashes
  `fachada-sede-api-swagger.yaml` and compares against the pinned
  hash at `generated/dart_dio_client/.codegen-spec-sha256`. Fails if
  the spec was changed without a regen.
- Wired into `scripts/verify_codegen.sh` as a final step so a single
  `bash scripts/verify_codegen.sh` run catches both code drift and
  hash drift.

## Running the suite

```bash
# All tests (default, ~10s on M-class hardware):
flutter test

# Just the contract layer:
flutter test test/contract/

# Just the resilience primitives:
flutter test test/core/

# Performance budgets (opt-in, see TASK-70 doc):
flutter test --tags performance test/performance/
```

## Sprint 7 deltas

- 412 → 434 tests (+22):
  - +14 core resilience (cache, connectivity, retry — STORY-65)
  - +8 contract (STORY-66)
  - widget/golden/e2e additions land under STORY-67
