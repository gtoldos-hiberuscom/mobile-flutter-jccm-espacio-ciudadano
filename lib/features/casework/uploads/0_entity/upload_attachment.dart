/// Lifecycle status of a single attachment inside an upload session.
///
/// Pure entity — no Flutter or infrastructure imports.
enum UploadAttachmentStatus {
  /// File has been picked but not yet validated.
  selected,

  /// Local validations are running (size / mime / count).
  validating,

  /// Local + server hashes computed; ready to upload.
  hashed,

  /// Network upload in progress.
  uploading,

  /// Upload finished successfully (server acknowledged the file).
  uploaded,

  /// Upload (or validation) failed. See `UploadAttachment.errorMessage`.
  failed,
}

/// One attachment inside an upload session.
///
/// Immutable value object. Use [copyWith] to transition to the next state.
final class UploadAttachment {
  const UploadAttachment({
    required this.id,
    required this.displayName,
    required this.sizeBytes,
    required this.mimeType,
    required this.status,
    this.sha256Hex,
    this.errorMessage,
  });

  /// Stable identifier for this attachment within its session.
  final String id;

  /// Human-readable file name as picked from the OS.
  final String displayName;

  /// Size of the original payload in bytes.
  final int sizeBytes;

  /// MIME type as resolved by the picker / mapper.
  final String mimeType;

  /// SHA-256 of the file bytes, lowercase hex, available from
  /// [UploadAttachmentStatus.hashed] onward.
  final String? sha256Hex;

  /// Current lifecycle position.
  final UploadAttachmentStatus status;

  /// Localized or technical error key (presentation maps to message).
  final String? errorMessage;

  UploadAttachment copyWith({
    final String? id,
    final String? displayName,
    final int? sizeBytes,
    final String? mimeType,
    final String? sha256Hex,
    final UploadAttachmentStatus? status,
    final String? errorMessage,
    final bool clearError = false,
  }) {
    return UploadAttachment(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      mimeType: mimeType ?? this.mimeType,
      sha256Hex: sha256Hex ?? this.sha256Hex,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
