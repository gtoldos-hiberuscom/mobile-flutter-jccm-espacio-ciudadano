/// Domain-level constraints for the upload pipeline (STORY-38).
///
/// Pure data — no Flutter, no I/O. Shared by validators, repositories,
/// presentation hints and tests so the limits never drift.
library;

/// Maximum number of files admitted in a single upload session.
const int kMaxFiles = 5;

/// Maximum size (in bytes) for a single file. 50 MB.
const int kMaxFileBytes = 50 * 1024 * 1024;

/// Conservative whitelist of MIME types accepted by the upload pipeline.
///
/// Mirrors the formats explicitly cited in the functional documentation
/// (PDF, image, office, plain text). Anything outside this list is
/// rejected with `UploadValidationFailure.unsupportedMime`.
const Set<String> kAllowedMimeTypes = <String>{
  'application/pdf',
  'image/jpeg',
  'image/png',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-excel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'text/plain',
};

/// Feature flag — gates the signed upload pipeline (`subiradjunto`).
///
/// Sprint 5 ships only the unsigned variant (`subiradjuntosinfirma`),
/// per the discovery decision in TASK-40. The signed surface is owned
/// by the firma-digital epic and will land in a later sprint.
const bool kCaseworkSignedUploadEnabled = false;
