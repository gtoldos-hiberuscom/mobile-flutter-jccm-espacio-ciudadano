/// Availability of a notification document on the backing system
/// (STORY-44).
///
/// The real `/publicacion/midocfirmados` contract is not yet wired
/// (see TASK-47 strategy doc and the STORY-44 endpoint note). The
/// enum follows the tolerant-parser pattern: any unknown value falls
/// into [unknown] and is rendered as a neutral chip in the UI.
///
/// Pure Dart — no Flutter / Riverpod / l10n imports (canon §11).
enum NotificationDocumentAvailability {
  available,
  unavailable,
  unknown,
}

/// Value object describing a document attached to a notification
/// (STORY-44).
///
/// Pure Dart — no Flutter / Dio / Riverpod / l10n (canon §11). DTO
/// translation lives under `3_data/`.
final class NotificationDocument {
  const NotificationDocument({
    required this.id,
    required this.name,
    required this.availability,
    this.mimeType,
    this.sizeBytes,
    this.downloadHint,
  });

  final String id;
  final String name;

  /// IANA mime type (e.g. `application/pdf`). May be `null` if the
  /// backend does not report it; presentation falls back to a generic
  /// label in that case.
  final String? mimeType;

  /// File size in bytes when known. `null` ⇒ size unknown / not
  /// reported.
  final int? sizeBytes;

  final NotificationDocumentAvailability availability;

  /// Opaque locator used by the future Dio adapter to resolve the
  /// signed download URL (e.g. a signature reference). Treated as an
  /// implementation detail by the presentation layer.
  final String? downloadHint;
}
