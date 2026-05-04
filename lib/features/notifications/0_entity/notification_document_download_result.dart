import 'dart:typed_data';

/// Outcome categories for a document download attempt (STORY-44).
///
/// Pure Dart — no Flutter / Dio / Riverpod (canon §11). The
/// presentation layer maps each status to the corresponding snackbar.
enum NotificationDocumentDownloadStatus {
  /// Document was retrieved successfully — `bytes` is non-null and
  /// ready to be persisted / opened.
  success,

  /// The backend acknowledges the document but reports it as not
  /// downloadable (e.g. archived, signed-off, retention window).
  unavailable,

  /// Network / unexpected failure. The presentation layer surfaces a
  /// generic error toast.
  error,
}

/// Result of `NotificationDetailRepository.downloadDocument`
/// (STORY-44). Pure-Dart value object so it can flow up through the
/// notifier without leaking implementation details.
final class NotificationDocumentDownloadResult {
  const NotificationDocumentDownloadResult._({
    required this.status,
    this.bytes,
    this.mimeType,
    this.message,
  });

  /// Successful download — [bytes] holds the payload retrieved from
  /// the backend.
  factory NotificationDocumentDownloadResult.success({
    required final Uint8List bytes,
    final String? mimeType,
    final String? message,
  }) => NotificationDocumentDownloadResult._(
    status: NotificationDocumentDownloadStatus.success,
    bytes: bytes,
    mimeType: mimeType,
    message: message,
  );

  /// Document is acknowledged by the backend but not downloadable
  /// right now.
  factory NotificationDocumentDownloadResult.unavailable({final String? message}) => NotificationDocumentDownloadResult._(
    status: NotificationDocumentDownloadStatus.unavailable,
    message: message,
  );

  /// Generic failure — typically network / 5xx.
  factory NotificationDocumentDownloadResult.error({final String? message}) => NotificationDocumentDownloadResult._(
    status: NotificationDocumentDownloadStatus.error,
    message: message,
  );

  final NotificationDocumentDownloadStatus status;
  final Uint8List? bytes;
  final String? mimeType;
  final String? message;
}
