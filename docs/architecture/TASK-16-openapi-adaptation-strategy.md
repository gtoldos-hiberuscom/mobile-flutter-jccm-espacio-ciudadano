# TASK-16 – OpenAPI Adaptation Strategy

> **Status**: Accepted  
> **Author**: GitHub Copilot (TASK-16 implementation)  
> **Branch**: `task/EPIC-1-foundations/TASK-16-openapi-strategy/audit-openapi-contracts`  
> **Date**: 2025-07

---

## 1. Purpose

This document establishes the **mandatory rules** for integrating the code-generated Dio client (`generated/dart_dio_client/`) into the application feature layers, and catalogues the contract gaps discovered during the audit that must be addressed before those features can be implemented.

---

## 2. Background

The backend API is described by an OpenAPI specification (`fachada-sede-api-swagger.yaml`).  
A `built_value`-backed Dart Dio client was code-generated from this spec into:

```
generated/dart_dio_client/lib/src/
  api/      ← 16 generated API classes
  model/    ← ~95 BuiltValue DTOs (+ .g.dart counterparts)
```

The generated code is **read-only** and **must never be modified by hand**.  
All regeneration is performed via the OpenAPI generator toolchain.

---

## 3. Architecture Rule: Layer Ownership

```
┌──────────────────────────────────────────────────────────────────┐
│  lib/features/<feature>/                                         │
│  ├── 0_entity/      Pure Dart domain entities & value objects    │
│  │   └── ❌ MUST NOT import generated/, Dio, or Flutter          │
│  │                                                               │
│  ├── 1_domain/      Use cases, repository interfaces, failures   │
│  │   └── ❌ MUST NOT know about generated/ or concrete Dio       │
│  │                                                               │
│  ├── 2_presentation/ UI, Riverpod notifiers, routing             │
│  │   └── ❌ MUST NOT import 3_data/ concrete implementations     │
│  │          except at the DI composition point in providers/     │
│  │                                                               │
│  └── 3_data/         ← generated client LIVES HERE ONLY         │
│      ├── api/        Wrapper classes extending GeneratedApiWrapper│
│      ├── datasources/ Remote & local datasource implementations  │
│      ├── mappers/    DTO → domain entity conversion              │
│      └── repositories/ Concrete repository implementations       │
└──────────────────────────────────────────────────────────────────┘
```

### 3.1 Non-negotiable constraints

| Rule | Rationale |
|------|-----------|
| Generated DTOs **MUST NOT** cross the `3_data/` boundary | Domain and presentation layers must be insulated from API churn |
| `0_entity/` classes **MUST NOT** import `generated/`, Dio, or `built_value` | Entity purity; entities are owned by the domain |
| All generated API calls **MUST** go through a wrapper extending `GeneratedApiWrapper` | Centralised error handling, consistent `Result<T>` surface |
| `generated/` is **read-only** — never edited by hand | Idempotent regeneration |
| Mappers **MUST** be stateless functions or classes in `3_data/mappers/` | Single responsibility, independently testable |

---

## 4. Base Wrapper: `GeneratedApiWrapper`

**File**: `lib/core/network/generated_api_wrapper.dart`

An `abstract base class` that every feature-level API wrapper **must** extend.

### 4.1 Provided methods

| Method | Signature | Use case |
|--------|-----------|----------|
| `safeCall<T>` | `Future<Result<T>> safeCall(Future<Response<T>> Function())` | All typed-model endpoints |
| `safeStringCall` | `Future<Result<String>> safeStringCall(...)` | Raw-string endpoints (see §6.1) |
| `safeBinaryCall` | `Future<Result<List<int>>> safeBinaryCall(...)` | Binary/byte endpoints (see §6.2) |

### 4.2 Error-mapping contract

`safeCall` maps outcomes as follows:

```
DioException.error is AppError  →  Failure(embeddedError)   // interceptor-classified
DioException (fallback)         →  Failure(NetworkError | UnauthorizedError | NotFoundError | UnknownError)
response.data == null           →  Failure(NotFoundError)
response.data != null           →  Success(data)
any other exception             →  Failure(UnknownError)
```

The `ErrorInterceptor` (already registered on every `Dio` instance) classifies errors first.  
`GeneratedApiWrapper` provides a **fallback** classifier for cases where the interceptor does not fire (e.g. test doubles, alternate `Dio` instances).

### 4.3 Implementation pattern per feature

```dart
// lib/features/publicacion/3_data/api/publicacion_api_wrapper.dart

import 'package:espacio_ciudadano_api/src/api/publicacion_api.dart';
import 'package:espacio_ciudadano_api/src/model/dtquery.dart';
import 'package:espacio_ciudadano_api/src/model/zcsrfcpubliselectbynif_response.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_wrapper.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';

final class PublicacionApiWrapper extends GeneratedApiWrapper {
  const PublicacionApiWrapper(this._api);

  final PublicacionApi _api;

  Future<Result<ZCSRFCPUBLISELECTBYNIFResponse>> miDetalleOperation(
    DTQUERY body,
  ) =>
      safeCall(() => _api.miDetalleOperation(dTQUERYBody: body));
}
```

### 4.4 Riverpod registration (DI composition point)

```dart
// lib/features/publicacion/2_presentation/providers/publicacion_providers.dart

@riverpod
PublicacionApiWrapper publicacionApiWrapper(Ref ref) =>
    PublicacionApiWrapper(
      PublicacionApi(ref.watch(dioClientProvider), standardSerializers),
    );
```

The concrete `PublicacionApi` (generated) is **only ever named** inside `3_data/` and the provider file that bridges `3_data/` to `2_presentation/`.

---

## 5. Mapper Pattern

Each feature's `3_data/mappers/` contains pure-function mappers:

```dart
// lib/features/publicacion/3_data/mappers/expediente_mapper.dart

import 'package:espacio_ciudadano_api/src/model/...'; // DTO — stays in 3_data
import 'package:jccm_espacio_ciudadano/features/publicacion/0_entity/expediente.dart';

Expediente toExpediente(ZCSRFCPUBLISELECTBYNIFResponse dto) => Expediente(
  // ... map fields
);
```

Mapper methods are invoked inside the **concrete repository** (`3_data/repositories/`) and must never be exposed to `1_domain/` or `2_presentation/`.

---

## 6. API Contract Gap Catalogue

The following gaps were identified during the TASK-16 audit.  Each entry carries a **severity** rating and the recommended **handling strategy**.

### 6.1 Raw `String` response endpoints

These endpoints return `Response<String>` instead of a typed model.  The backend may return XML, HTML, plain text, or a JSON string that was not typed in the OpenAPI spec.

| API class | Method | Domain area | Issue | Strategy |
|-----------|--------|-------------|-------|----------|
| `SescamApi` | `citasFuturas` | SESCAM / Health | String response — format unknown | Use `safeStringCall`; parse in datasource with fallback; raise discovery task |
| `SescamApi` | `citasPasadas` | SESCAM / Health | String response — format unknown | Same as above |
| `SescamApi` | `getCipFromNif` | SESCAM / Health | String response — likely plain CIP code | Use `safeStringCall`; wrap in a `Cip` value object in `0_entity/` |
| `CarnetDigitalApi` | `obtenerDatosFamiliaNumerosa` (overload 1) | Carnet Digital | String response — probable JSON not typed | Use `safeStringCall`; decode manually in datasource; raise discovery task |
| `CarnetDigitalApi` | `obtenerDatosFamiliaNumerosa` (overload 2 / v1) | Carnet Digital | Duplicate String endpoint | Same as above; verify with backend which to deprecate |
| `CarnetDigitalApi` | `obtenerPdf` | Carnet Digital | String response — may be Base64-encoded PDF | Use `safeStringCall`; decode Base64 in datasource; consider `safeBinaryCall` after spec update |
| `CarnetDigitalApi` | `obtenerPkPass` | Carnet Digital | String response — PKPass package as string | Use `safeStringCall`; decode in datasource |
| `CarnetDigitalApi` | `obtenerPkPassFamiliaNumerosa1` | Carnet Digital | String response — duplicate PKPass endpoint | Same as above |
| `IntermediacionApi` | `obtenerDatosFamiliaNumerosa` | Intermediación | String response — probable JSON not typed | Use `safeStringCall`; parse in datasource |

**Action required**: For each String endpoint, a follow-up `SUBTASK` ticket must be raised to:
  1. Confirm the actual content-type and payload format with the backend team.
  2. Update the OpenAPI spec accordingly.
  3. Regenerate the client and replace `safeStringCall` with `safeCall` where possible.

### 6.2 Binary / byte response endpoints

| API class | Method | Domain area | Issue | Strategy |
|-----------|--------|-------------|-------|----------|
| `DocumentacionApi` | `registrarFicheroOperation` | Documentación | `Response<Uint8List>` — binary document (PDF justificante) | Use `safeBinaryCall`; return `Uint8List` inside `3_data/`; expose as `bytes` field on entity |

### 6.3 Dynamic / opaque payload models

These models contain a `JsonObject?` field (`built_value` wrapper around `dynamic`) for the body, effectively bypassing type safety at the payload level.

| Model | Field | Affected APIs | Issue | Strategy |
|-------|-------|---------------|-------|----------|
| `Respuesta` | `body: JsonObject?` | `CatastroApi.getDatosCatastrales`, `HechosVitalesApi.*` (multiple) | Payload is `dynamic`; no compile-time shape guarantee | Map `body` to `Map<String, dynamic>` or a known sub-model at the datasource layer; document expected shape in a `// CONTRACT:` comment |
| `ZCSRMOBTRESPUESTAEXP` | (nested fields) | `ProcedimientoApi.miObtenerRespuestaOperation` | Deep nesting with optional fields | Apply nullable-safe mapping in mapper; add integration test |

### 6.4 Duplicate / redundant endpoints (overloads)

Some generated API classes expose multiple overloads of the same logical operation that appear to differ only by API version or minor parameter variation.

| API class | Duplicated methods | Recommendation |
|-----------|-------------------|----------------|
| `CarnetDigitalApi` | `obtenerDatosFamiliaNumerosa`, `obtenerDatosFamiliaNumerosa1`, `obtenerDatosFamiliaNumerosa2` | Confirm with backend which is the canonical endpoint; deprecate the rest |
| `CarnetDigitalApi` | `obtenerPkPass`, `obtenerPkPassFamiliaNumerosa1` | Same as above |
| `IntermediacionApi` | `obtenerDatosFamiliaNumerosa` vs `CarnetDigitalApi` equivalent | Possible duplication across API classes; verify routing |

### 6.5 Complex nested models requiring careful mapping

| Model chain | Affected API | Risk |
|-------------|-------------|------|
| `RESULTADOPROCEDIMIENTO → DATOSREGISTRO → DATOSPAGO → ADJUNTO[]` | `ProcedimientoApi` | Deep optional nesting; mapper must guard every level |
| `ZCSVECResponse → ZCSVEC → ZCSLISTADODOCSEXPTE → ZCSTBDOCUMENTO[]` | `AfirmaApi` | List of documents with multiple optional date/type fields |
| `ZCSRFCMISEXPEDIENTESResponse → ZCSRFCMISEXPEDIENTES → ZCSAUXSTEXPEDIENTES[]` | `PublicacionApi.siMisExpedientesOperation` | Paginated-like list; verify null safety on the list container |
| `ListaTramitesPorHechos → TramitesPorHecho[] → Tramite[]` | `HechosVitalesApi.getServicios` | Doubly nested list; serialiser must handle empty lists |
| `RespuestaRespuestaFachadaFamiliaNumerosaInterm` | `IntermediacionApi` | Long name suggests untidy spec; review with backend |

### 6.6 API classes with a single endpoint (low coverage)

| API class | Endpoints | Note |
|-----------|-----------|------|
| `CcaaApi` | 1 (`getDatosFamiliaNumerosa`) | Verify this is intentional and not a spec truncation |
| `CatastroApi` | 1 (`getDatosCatastrales`) | Same |
| `DgtApi` | 1 (`getListaVehiculos`) | Same |
| `IneApi` | 1 (`getDatosResidencia`) | Same |
| `SepeApi` | 1 (`getDemandanteEmpleoFechaActual`) | Same |

---

## 7. Per-Domain Adaptation Summary

| Domain / Feature | Generated API class | Wrapper location | Key gaps |
|-----------------|--------------------|--------------------|----------|
| Publicación (expedientes, documentos firmados) | `PublicacionApi`, `ServicioApi` | `publicacion/3_data/api/` | Deep nesting on `ZCSRFCMISEXPEDIENTESResponse` |
| Procedimiento (iniciar, confirmar, adjuntos) | `ProcedimientoApi` | `procedimiento/3_data/api/` | `RESULTADOPROCEDIMIENTO` nesting; hash-adjunto endpoint |
| SESCAM (citas) | `SescamApi` | `sescam/3_data/api/` | **All 3 endpoints return `String`** — highest priority gap |
| Carnet Digital (carnet joven, familia numerosa, QR) | `CarnetDigitalApi` | `carnet_digital/3_data/api/` | **5 String endpoints, duplicate overloads**, Base64 PDF |
| Hechos Vitales (lista hechos, trámites, cláusulas) | `HechosVitalesApi` | `hechos_vitales/3_data/api/` | `Respuesta.body` is `JsonObject?`; list nesting |
| Catastro | `CatastroApi` | `catastro/3_data/api/` | `Respuesta.body` is `JsonObject?` |
| DGT (vehículos) | `DgtApi` | `dgt/3_data/api/` | Single endpoint; model is well-typed |
| SEPE (demandante empleo) | `SepeApi` | `sepe/3_data/api/` | Single endpoint; model is well-typed |
| Educación (títulos) | `EducacionApi` | `educacion/3_data/api/` | Two endpoints, both well-typed |
| Consulta (FAQs) | `ConsultaApi` | `consulta/3_data/api/` | Single endpoint; model is well-typed |
| Afirma (documentos firmados, VEC) | `AfirmaApi` | `afirma/3_data/api/` | Nested `ZCSVECResponse`; list of docs |
| Intermediación (familia numerosa) | `IntermediacionApi` | `intermediacion/3_data/api/` | `String` endpoint + typed overload |
| INE (residencia) | `IneApi` | `ine/3_data/api/` | Single endpoint; model is well-typed |
| CCAA (familia numerosa) | `CcaaApi` | `ccaa/3_data/api/` | Single endpoint; model is well-typed |
| Documentación (registro fichero) | `DocumentacionApi` | `documentacion/3_data/api/` | `Uint8List` binary response |

---

## 8. Discovery Tasks Required

The following child tickets must be raised (via `ticket-manager`) to close the gaps catalogued above:

| Suggested ticket | Scope |
|-----------------|-------|
| `TASK-XX` – Clarify SESCAM String endpoints | Backend team to provide response schema for `citasFuturas`, `citasPasadas`, `getCipFromNif` |
| `TASK-XX` – Carnet Digital String endpoint audit | Confirm canonical endpoints; update OpenAPI spec; regenerate client |
| `TASK-XX` – `Respuesta.body` (`JsonObject?`) mapping strategy | Define per-feature sub-schemas and datasource guards |
| `TASK-XX` – `DocumentacionApi` binary response entity | Define `Uint8List` → entity mapping for PDF justificante |
| `TASK-XX` – Duplicate endpoint rationalisation | Identify and deprecate redundant CarnetDigital/Intermediacion overloads |

---

## 9. Compliance Checklist

Before any feature `3_data/` implementation is considered complete, verify:

- [ ] A concrete wrapper class extending `GeneratedApiWrapper` exists in `3_data/api/`
- [ ] No generated DTO is imported outside `3_data/`
- [ ] All `safeStringCall` usages have a `// CONTRACT:` comment documenting the expected content-type/format
- [ ] All `Respuesta.body` (`JsonObject?`) usages have a documented mapping guard
- [ ] Mapper unit tests cover null fields and empty list scenarios
- [ ] `dart analyze` passes with zero errors on the feature tree
