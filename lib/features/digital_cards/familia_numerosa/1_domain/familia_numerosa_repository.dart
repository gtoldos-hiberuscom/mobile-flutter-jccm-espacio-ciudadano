/// Familia numerosa carnet (EPIC-7 / STORY-49) — domain.
///
/// Pure Dart contract — no Flutter / Riverpod / Dio (canon §12).
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_card.dart';

/// Abstract repository owning the lifecycle of the carnet digital de
/// familia numerosa: load metadata + request QR / PDF / PKPass exports.
///
/// Implementations live under `3_data/`. Tests inject fakes; the mock
/// implementation returns deterministic payloads while the live wiring
/// against `/carnet-digital/familia-numerosa/{dni}` and friends is
/// pending (see TODOs in the impl).
abstract interface class FamiliaNumerosaRepository {
  /// Loads the carnet metadata for the current citizen. Throws
  /// [FamiliaNumerosaUnavailable] when the citizen has no vigente
  /// carnet — the page renders the unavailable fallback instead of an
  /// error state.
  Future<FamiliaNumerosaCard> loadCard();

  /// Requests the QR payload (raw text or PNG, depending on backend
  /// projection — currently `qrText`).
  Future<BinaryArtifact> requestQr();

  /// Requests the PDF artifact.
  Future<BinaryArtifact> requestPdf();

  /// Requests the PKPass bundle for the Apple Wallet pipeline.
  Future<BinaryArtifact> requestPkpass();
}

/// Thrown by [FamiliaNumerosaRepository.loadCard] when the citizen
/// does not have a vigente carnet (no datos / caducado). The page
/// catches it and renders an explicit unavailable surface.
final class FamiliaNumerosaUnavailable implements Exception {
  const FamiliaNumerosaUnavailable([this.reason]);

  /// Optional opaque reason — never includes PII (canon §24).
  final String? reason;

  @override
  String toString() => 'FamiliaNumerosaUnavailable(${reason ?? ''})';
}
