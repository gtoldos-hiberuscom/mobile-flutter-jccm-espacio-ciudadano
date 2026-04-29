/// Familia numerosa carnet (EPIC-7 / STORY-49) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';

/// Thin wrapper over a single [BinaryArtifact] returned by the
/// repository per QR / PDF / PKPass request.
///
/// Exists so the domain contract can evolve (e.g. adding a per-export
/// metadata block) without touching the shared exporter primitives.
final class FamiliaNumerosaExport {
  const FamiliaNumerosaExport({required this.artifact});

  /// The validated binary artifact ready to flow through
  /// `WalletActionController.persistAndAct(...)`.
  final BinaryArtifact artifact;
}
