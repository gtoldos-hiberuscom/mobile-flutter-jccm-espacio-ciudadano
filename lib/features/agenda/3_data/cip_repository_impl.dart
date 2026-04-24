import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/cip_summary.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/cip_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/sescam/sescam_payload_parser.dart';

/// In-memory implementation of [CipRepository] used while live SESCAM
/// parsing is gated off (Sprint 4, STORY-31).
///
/// ## Strategy
/// The endpoint `/sescam/cip/{numDocumento}` returns its body as
/// `string`. The exact shape is unknown until preproduction access is
/// granted (TASK-32 — see
/// `documentation/discovery/TASK-32-sescam-payload-strategy.md`).
///
/// While [kSescamLiveParsingEnabled] is `false` (today's default), this
/// implementation skips network entirely and returns a deterministic
/// stub [SescamCipPayload] mapped to a [CipSummary]. When the flag is
/// flipped on the same code path will instead delegate the raw response
/// to [SescamCipParser.parse] and translate any
/// [SescamParseErrorKind.unknownShape] / [SescamParseErrorKind.empty]
/// outcome into a [CipLoadState.parseError] snapshot so the UI keeps
/// the partial-error tolerance contract (canon §16).
///
/// Per the TASK-71 surface decision (CIP_REUSE), the CIP is treated as
/// a read-only datum — no PKPass / QR / PDF derivation is implemented
/// in this repository (no wallet semantics).
final class CipRepositoryImpl implements CipRepository {
  const CipRepositoryImpl({
    final SescamCipParser parser = const SescamCipParser(),
    final DateTime Function() clock = DateTime.now,
    final String Function()? rawPayloadProvider,
  })  : _parser = parser,
        _clock = clock,
        _rawPayloadProvider = rawPayloadProvider;

  final SescamCipParser _parser;
  final DateTime Function() _clock;

  /// Optional injection point used by tests to feed a raw SESCAM string
  /// through the parser even while [kSescamLiveParsingEnabled] is on.
  /// In production a Dio call would be plugged here once a
  /// preproduction sample is captured (TASK-32 R1).
  final String Function()? _rawPayloadProvider;

  @override
  Future<CipSummary> loadCip() async {
    final now = _clock();

    if (kSescamLiveParsingEnabled) {
      // ── Live path ──────────────────────────────────────────────────
      // Today this branch is dead-code in production (the constant is
      // `false` until TASK-32 R1 is signed off). Kept here so the
      // toggle is a one-liner change once a real sample is captured.
      final raw = _rawPayloadProvider?.call();
      if (raw == null) {
        return CipSummary(
          id: 'cip-live-no-source',
          cipCode: '',
          lastUpdatedAt: now,
          loadState: CipLoadState.error,
        );
      }
      final result = _parser.parse(raw);
      if (result.isOk) {
        return _fromPayload(result.value!, now);
      }
      return CipSummary(
        id: 'cip-live-parse-error',
        cipCode: '',
        lastUpdatedAt: now,
        loadState: CipLoadState.parseError,
        parseErrorReason: result.error?.reason ?? result.error?.kind.name,
      );
    }

    // ── Stub path (current Sprint 4 behaviour) ───────────────────────
    // Deterministic payload that exercises the loaded surface end-to-end
    // without touching the SESCAM façade.
    const stub = SescamCipPayload(
      cip: 'CLM01234567',
      titular: 'María Ejemplo',
      centroSalud: 'Centro de Salud Toledo Centro',
      regionSanitaria: 'Castilla-La Mancha',
    );
    return _fromPayload(stub, now);
  }

  CipSummary _fromPayload(final SescamCipPayload payload, final DateTime now) =>
      CipSummary(
        id: 'cip-${payload.cip}',
        cipCode: payload.cip,
        titular: payload.titular,
        centroSalud: payload.centroSalud,
        region: payload.regionSanitaria,
        lastUpdatedAt: now,
        loadState:
            payload.cip.isEmpty ? CipLoadState.empty : CipLoadState.loaded,
      );
}
