/// Validation failure types raised by the upload pipeline.
///
/// Pure enum — UI translates each value to a localized message.
enum UploadValidationFailure {
  /// MIME type is not in the allowed whitelist.
  unsupportedMime,

  /// File exceeds the maximum file size constant.
  tooLarge,

  /// Adding this file would exceed the maximum number of files.
  tooManyFiles,

  /// File payload is empty (0 bytes).
  emptyFile,

  /// Locally computed hash differs from the server-side hash.
  hashMismatch,
}
