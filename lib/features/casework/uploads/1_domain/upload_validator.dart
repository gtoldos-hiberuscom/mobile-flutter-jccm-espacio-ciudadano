import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_constraints.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_validation_failure.dart';

/// Pure validator for files about to enter the upload pipeline.
///
/// Returns `null` when the file is admitted, or the matching
/// [UploadValidationFailure] otherwise. Order of checks mirrors the
/// AC of STORY-38: count → empty → size → mime.
UploadValidationFailure? validateNewFile({
  required final int currentCount,
  required final String name,
  required final int sizeBytes,
  required final String mimeType,
}) {
  if (currentCount >= kMaxFiles) {
    return UploadValidationFailure.tooManyFiles;
  }
  if (sizeBytes <= 0) {
    return UploadValidationFailure.emptyFile;
  }
  if (sizeBytes > kMaxFileBytes) {
    return UploadValidationFailure.tooLarge;
  }
  if (!kAllowedMimeTypes.contains(mimeType.toLowerCase())) {
    return UploadValidationFailure.unsupportedMime;
  }
  // Defensive: name presence (kept for future extension).
  if (name.trim().isEmpty) {
    return UploadValidationFailure.unsupportedMime;
  }
  return null;
}

/// SHA-256 of [bytes] as lowercase hex. Used both client-side and to
/// emulate the server hash in the Sprint 5 mock repository.
String sha256HexOf(final Uint8List bytes) => sha256.convert(bytes).toString();
