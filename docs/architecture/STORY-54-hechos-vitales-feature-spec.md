# STORY-54 - Mis Hechos Vitales

## 1. Purpose

Define the complete functional and technical specification for the `Mis hechos vitales` feature, using the generated Dart Dio client as the primary contract source.

This document covers:

- feature goal
- scope
- UI behavior
- API contract
- data models
- persistence flow
- loading/saving/reset states
- validation and error handling
- contract inconsistencies that affect implementation decisions


## 2. Source of Truth

Primary source of truth:

- `generated/dart_dio_client/lib/src/api/hechos_vitales_api.dart`
- `generated/dart_dio_client/doc/HechosVitalesApi.md`
- generated models referenced by that API

Secondary support sources:

- `tickets/STORY-54.md`
- `lib/l10n/app_es.arb`
- `image_references/03_Mis hechos vitales.png`
- legacy functional docs under `documentation/`

Implementation rule:

- if legacy functional documentation disagrees with the generated client, the generated client wins for integration design
- legacy docs remain useful for UX intent and screen semantics, but not for endpoint selection


## 3. Feature Summary

`Mis hechos vitales` allows the citizen to select the life situations that best describe their current context so the system can later personalize recommendations.

The core feature is:

1. load the citizen's current life-event selection
2. allow multiple selection changes
3. persist the new selection explicitly
4. optionally reset all saved preferences


## 4. Goal

The feature must let the user maintain a persisted set of selected life events tied to `idAgente`.

Expected business outcome:

- personalized recommendation surfaces can use the user's selected life events as input


## 5. Scope

### Included

- screen for viewing life events
- multiple selection by checkbox
- explicit save action
- explicit reset/delete action
- server-backed persistence
- loading, empty, error, success states

### Related but not part of the core screen flow

- data-consent / authorization management
- recommendation listing and segmentation
- recommendation empty states

Those capabilities live in the same API family but are separate feature slices.


## 6. Dependencies

The feature depends on:

- authenticated user session
- resolved `idAgente`
- optional but expected auth token for backend calls

Ticket-level dependency trace:

- blocked by `STORY-18`
- blocked by `TASK-21`
- blocks `STORY-56`
- blocks `STORY-57`

Reference:

- `tickets/STORY-54.md`


## 7. Functional Behavior

### 7.1 Main user flow

1. User opens `Mis hechos vitales`.
2. App resolves `idAgente`.
3. App loads current server state for that user.
4. User marks or unmarks one or more life events.
5. Changes remain local until the user explicitly saves.
6. User taps `Guardar`.
7. App sends the full selection payload to backend.
8. App shows success or error feedback.

### 7.2 Reset flow

1. User taps `Borrar preferencias`.
2. App shows destructive confirmation dialog.
3. If confirmed, app calls delete/reset endpoint.
4. App clears local state and reloads server state, or maps response into an equivalent empty selection state.


## 8. Screen Specification

### 8.1 Screen identity

- title: `Mis hechos vitales`
- descriptive text: `Selecciona los hechos vitales que mejor describen tu situación para recibir recomendaciones personalizadas.`

Reference:

- `lib/l10n/app_es.arb`

### 8.2 Visual structure

The reference image shows:

- a large introductory text block
- a vertical list of life-event options
- one row per life event
- checkbox aligned to the right
- selected rows highlighted with a soft green background and green check
- unselected rows on white background with an empty dark checkbox

### 8.3 Interaction model

- every row is selectable
- selection is multi-select
- there is no implied single-choice behavior
- there is no auto-save in the feature definition
- save is explicit

### 8.4 Copy currently defined in l10n

- `lifeEventsTitle`: `Mis hechos vitales`
- `lifeEventsHeaderDescription`: `Selecciona los hechos vitales que mejor describen tu situación para recibir recomendaciones personalizadas.`
- `lifeEventsSaveAction`: `Guardar`
- `lifeEventsResetAction`: `Borrar preferencias`
- `lifeEventsResetConfirmTitle`: `Borrar tus preferencias`
- `lifeEventsResetConfirmBody`: `Se eliminarán todos los hechos vitales seleccionados. Esta acción no se puede deshacer.`
- `lifeEventsSavedFeedback`: `Tus preferencias se han guardado correctamente.`
- `lifeEventsErrorFeedback`: `No hemos podido guardar tus preferencias. Inténtalo de nuevo.`
- `lifeEventsLoadError`: `No hemos podido cargar los hechos vitales.`
- `lifeEventsEmpty`: `No hay hechos vitales disponibles en este momento.`


## 9. API Contract

Only the generated client methods below are in scope for the core feature.

### 9.1 Load life events

Method:

- `obtenerListaHechosByIdAgente`

HTTP:

- `GET /api/v1/hechos-vitales/hechos/{idAgente}`

Parameters:

- `idAgente` required
- `authorization` optional in generated signature

Return type:

- `ListaHechos`

Meaning:

- returns the current life-event list for the citizen, including selection state

### 9.2 Save life events

Method:

- `actualizarListaHechos`

HTTP:

- `PATCH /api/v1/hechos-vitales/hechos`

Parameters:

- `listaHechosAgente` required
- `authorization` optional in generated signature

Return type:

- `Respuesta`

Meaning:

- persists the new full life-event selection for the citizen

### 9.3 Reset preferences

Method:

- `eliminarPreferencias`

HTTP:

- `DELETE /api/v1/hechos-vitales/preferencias/{idAgente}`

Parameters:

- `idAgente` required
- `authorization` optional in generated signature

Return type:

- `Respuesta`

Meaning:

- deletes the persisted life-event preferences for the citizen


## 10. Data Models

### 10.1 `Hecho`

Fields:

- `idHecho: int?`
- `nombreHecho: String?`
- `seleccionado: bool?`

Interpretation:

- `idHecho` is the stable backend identifier
- `nombreHecho` is the display label
- `seleccionado` represents current persisted selection state

### 10.2 `ListaHechos`

Fields:

- `listaHechos: BuiltList<Hecho>?`

Interpretation:

- server returns the full current list wrapped in this object

### 10.3 `ListaHechosAgente`

Fields:

- `idAgente: String?`
- `listaHechos: BuiltList<Hecho>?`

Interpretation:

- save payload combines user identity and full list state

### 10.4 `Respuesta`

Fields:

- `body: JsonObject?`
- `codigoRespuesta: String?`
- `mensajeRespuesta: String?`
- `timestamp: DateTime?`
- `infoError: InfoError?`

Interpretation:

- generic backend response wrapper for save and reset operations

### 10.5 `InfoError`

Fields:

- `errores: BuiltList<ApiError>?`
- `idError: String?`

Interpretation:

- backend error envelope nested inside `Respuesta`


## 11. Persistence Rules

### 11.1 Load rule

The screen must initialize from `GET /hechos/{idAgente}`.

The app must not fabricate a static catalog if the backend returns data.

### 11.2 Save rule

The save contract is not a plain list of ids.

The payload expected by the generated client is `ListaHechosAgente`, which contains:

- `idAgente`
- `listaHechos[]`

Each item is a full `Hecho` object, including `idHecho`, `nombreHecho`, and `seleccionado`.

Therefore the integration rule is:

1. load the full list from backend
2. mutate `seleccionado` locally
3. send the full list back on save

### 11.3 Reset rule

Reset is a separate destructive action.

Reset is not the normal save flow.

Normal persistence path:

- `PATCH /hechos`

Destructive reset path:

- `DELETE /preferencias/{idAgente}`


## 12. Recommended Request/Response Shapes

### 12.1 Load response example

```json
{
  "listaHechos": [
    {
      "idHecho": 1,
      "nombreHecho": "He tenido un hijo/a",
      "seleccionado": false
    },
    {
      "idHecho": 2,
      "nombreHecho": "Me he jubilado",
      "seleccionado": true
    }
  ]
}
```

### 12.2 Save request example

```json
{
  "idAgente": "123456",
  "listaHechos": [
    {
      "idHecho": 1,
      "nombreHecho": "He tenido un hijo/a",
      "seleccionado": true
    },
    {
      "idHecho": 2,
      "nombreHecho": "Me he jubilado",
      "seleccionado": false
    }
  ]
}
```

### 12.3 Save/reset response example

```json
{
  "codigo-respuesta": "OK",
  "mensaje-respuesta": "Operación realizada correctamente",
  "timestamp": "2026-05-12T10:00:00Z"
}
```


## 13. State Model

The feature should support at least the following states.

### 13.1 Data lifecycle

- `initial`
- `loading`
- `loaded`
- `empty`
- `error`

### 13.2 User action lifecycle

- `dirty` or equivalent local-changes flag
- `saving`
- `saveSuccess`
- `saveError`
- `resetConfirmOpen`
- `resetting`
- `resetSuccess`
- `resetError`

### 13.3 State transitions

- `initial -> loading`
- `loading -> loaded | empty | error`
- `loaded -> dirty` when user changes any checkbox
- `dirty -> saving -> loaded | saveError`
- `loaded | dirty -> resetConfirmOpen -> resetting -> empty | loaded | resetError`


## 14. UI Rules

### 14.1 Row behavior

- full row should be tappable
- checkbox tap and row tap must produce the same result
- selection is reversible

### 14.2 Save behavior

- save should be explicit
- save should use the current local snapshot
- repeated save taps during in-flight request must be prevented

### 14.3 Reset behavior

- reset must require confirmation
- reset is destructive
- reset must not happen silently

### 14.4 Empty state

If the loaded backend list is empty or null-equivalent:

- show `lifeEventsEmpty`
- hide selection list
- avoid showing misleading save success state

### 14.5 Error state

If the initial load fails:

- show `lifeEventsLoadError`
- allow retry


## 15. Validation Rules

### 15.1 Precondition validation

- `idAgente` must exist before load/save/reset
- the screen must not call the API with a missing `idAgente`

### 15.2 Item-level validation

- `idHecho` should be present for any selectable item
- `nombreHecho` should be present for display
- if backend returns malformed items, the app should either:
  - filter invalid entries out, or
  - render a safe fallback and avoid sending broken items without identifiers

### 15.3 Save payload integrity

- save should send a coherent full list
- local selection changes must be reflected in `seleccionado`
- the app should not send only a delta unless a custom adapter is introduced outside the generated client


## 16. Error Handling

### 16.1 Load errors

Possible sources:

- network failure
- auth/session problem
- invalid `idAgente`
- deserialization issue

UI response:

- show `lifeEventsLoadError`
- keep retry available

### 16.2 Save/reset errors

Possible sources:

- backend rejects payload
- auth/session expired
- deserialization problem on `Respuesta`

Error extraction priority:

1. HTTP error context from Dio
2. `Respuesta.mensajeRespuesta`
3. `Respuesta.infoError.idError`
4. `Respuesta.infoError.errores[]`
5. generic fallback message

UI response:

- show `lifeEventsErrorFeedback`
- keep current local edits after save failure
- after reset failure, keep previous local persisted snapshot


## 17. UX Decisions Implied by the Contract

### 17.1 Save is not automatic

Because the feature has a dedicated save endpoint and explicit save copy, the expected UX is explicit persistence, not auto-save.

### 17.2 The backend owns the catalog

Because the only generated read method is `GET /hechos/{idAgente}`, the safest assumption is that the backend already returns the catalog decorated with the user's selected state.

### 17.3 Normal save is not reset

The feature must distinguish:

- updating current selection
- deleting all preferences

They are separate user intentions and separate backend operations.


## 18. APIs in the Same Family but Outside the Core Screen Flow

These methods exist in the generated client but should not be treated as primary dependencies of the basic `Mis hechos vitales` selection screen:

- `obtenerClausulas`
- `enviarClausulas`
- `enviarClausulas1`
- `getServicios`
- `enviarClausulas2`

Reason:

- they belong to adjacent personalization/recommendation workflows
- the core `STORY-54` integration scope only requires life-event load, save, and reset


## 19. Known Contract Inconsistencies

These do not block the core life-event selection feature, but they matter for surrounding work.

### 19.1 `authorization` is optional in generated docs

The generated docs say `No authorization required`, but the method signatures accept `authorization`.

Implementation recommendation:

- pass auth token whenever available

### 19.2 `obtenerClausulas` return type is generic

`GET /clausulas/{idAgente}` returns `Respuesta`, not `ClausulasAgente`.

This suggests either:

- a generic response wrapper in the OpenAPI spec
- or an inconsistent schema definition

### 19.3 `enviarClausulas2` is misnamed

`enviarClausulas2` actually calls:

- `GET /api/v1/hechos-vitales/servicios/segmentacion/{idAgente}`

It also accepts:

- `operacion`
- `size`
- `page`
- `ultimosDias`
- `hechosvitales: BuiltList<int>`

Its generated return type is `Clausulas`, which is almost certainly inconsistent with the URL semantics.

Important interpretation:

- this is the only place in the generated API family where a plain list of life-event ids appears as query params
- that does **not** apply to the `PATCH /hechos` save contract for this screen


## 20. Acceptance Criteria

The feature is correctly implemented when all of the following hold:

1. entering the screen loads the current life-event selection for `idAgente`
2. the user can select and unselect multiple life events
3. tapping `Guardar` persists the changed selection through `PATCH /hechos`
4. success feedback is shown after a successful save
5. load failures show a proper error state
6. empty server lists show a proper empty state
7. tapping `Borrar preferencias` requires confirmation
8. confirmed reset calls `DELETE /preferencias/{idAgente}`
9. reset updates the screen to reflect cleared server state
10. save and reset remain clearly separate user actions


## 21. Implementation Notes

Recommended application flow:

1. map `ListaHechos.listaHechos` into view state
2. track local changes against the loaded snapshot
3. enable `Guardar` only when the state is dirty
4. on save, build `ListaHechosAgente(idAgente, listaHechos)`
5. on reset success, reload from backend for consistency

Recommended non-goals for this feature:

- infer categories from API data if the backend does not supply them
- collapse life-event persistence into recommendation-specific query contracts
- use clause-related methods to drive the main life-event selection UI


## 22. Final Integration Decision

For `STORY-54`, the definitive contract is:

- load with `GET /api/v1/hechos-vitales/hechos/{idAgente}`
- save with `PATCH /api/v1/hechos-vitales/hechos`
- reset with `DELETE /api/v1/hechos-vitales/preferencias/{idAgente}`

And the definitive persistence payload is:

- `ListaHechosAgente`
- containing a full `listaHechos[]` of `Hecho`
- not a flat list of ids
