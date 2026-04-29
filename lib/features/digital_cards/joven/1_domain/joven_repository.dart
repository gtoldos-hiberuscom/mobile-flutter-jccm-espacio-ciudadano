/// Carnet Joven (EPIC-7 / STORY-50) — domain.
///
/// Pure Dart contract — no Flutter / Riverpod / Dio (canon §12).
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/0_entity/joven_card.dart';

/// Abstract repository owning the lifecycle of the Carnet Joven: load
/// metadata + request QR / PDF / PKPass exports.
///
/// Implementations live under `3_data/`. Tests inject fakes; the mock
/// implementation returns deterministic payloads while the live wiring
/// against `/carnet-digital/joven/{dni}` and friends is pending (see
/// TODOs in the impl).
abstract interface class JovenRepository {
  /// Loads the carnet metadata for the current citizen. Throws
  /// [JovenUnavailable] when the citizen has no vigente carnet — the
  /// page renders the unavailable fallback instead of an error state.
  Future<JovenCard> loadCard();

  /// Requests the QR payload (raw text or PNG, depending on backend
  /// projection — currently `qrText`).
  Future<BinaryArtifact> requestQr();

  /// Requests the PDF artifact.
  Future<BinaryArtifact> requestPdf();

  /// Requests the PKPass bundle for the Apple Wallet pipeline.
  Future<BinaryArtifact> requestPkpass();
}

/// Thrown by [JovenRepository.loadCard] when the citizen does not have
/// a vigente carnet (no datos / caducado). The page catches it and
/// renders an explicit unavailable surface.
final class JovenUnavailable implements Exception {
  const JovenUnavailable([this.reason]);

  /// Optional opaque reason — never includes PII (canon §24).
  final String? reason;

  @override
  String toString() => 'JovenUnavailable(${reason ?? ''})';
}
