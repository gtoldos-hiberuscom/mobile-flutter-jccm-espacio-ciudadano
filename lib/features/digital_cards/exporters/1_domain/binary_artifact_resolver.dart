/// Digital cards exporters (EPIC-7 / STORY-52) — domain.
///
/// Pure Dart helpers — no Flutter / Riverpod / Dio (canon §12).
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_validation_failure.dart';

/// Pure validator for a [BinaryArtifact]. Combines the magic-header
/// check with the length thresholds defined in TASK-53.
///
/// Returns `null` when the artifact looks safe to persist; otherwise a
/// [BinaryArtifactValidationFailure] explaining the rejection reason.
BinaryArtifactValidationFailure? validateBinaryArtifact(
  final BinaryArtifact artifact,
) => artifact.validateMagic();

/// Builds the deterministic file name described in the TASK-53 discovery:
///
/// `<card-kind>-<format>-<yyyymmdd>-<shortHash>.<ext>`
///
/// where `shortHash` is the first 8 hex characters of
/// `sha256(dni + endpoint + epochMillis)`. The DNI itself never appears
/// in the returned name — only its hash contribution.
///
/// [cardKind] is the canonical slug owned by the caller story
/// (`familia-numerosa`, `joven`, `discapacidad`, `qr`).
/// [dniHashSeed] MUST be the raw DNI exactly as the caller knows it; the
/// helper hashes it together with [endpoint] and the epoch milliseconds
/// of [now]. Callers must never log [dniHashSeed].
String deterministicFileName({
  required final String cardKind,
  required final BinaryArtifactKind format,
  required final String endpoint,
  required final String dniHashSeed,
  required final DateTime now,
}) {
  final utc = now.toUtc();
  final yyyymmdd =
      '${utc.year.toString().padLeft(4, '0')}'
      '${utc.month.toString().padLeft(2, '0')}'
      '${utc.day.toString().padLeft(2, '0')}';
  final seed = '$dniHashSeed|$endpoint|${utc.millisecondsSinceEpoch}';
  final digest = sha256.convert(utf8.encode(seed));
  final shortHash = digest.toString().substring(0, 8);
  final safeKind = _slug(cardKind);
  return '$safeKind-${format.formatSlug}-$yyyymmdd-$shortHash.${format.fileExtension}';
}

String _slug(final String raw) {
  final lower = raw.toLowerCase().trim();
  return lower.replaceAll(RegExp('[^a-z0-9-]+'), '-');
}
