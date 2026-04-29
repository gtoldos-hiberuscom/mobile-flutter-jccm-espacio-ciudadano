/// Digital cards exporters (EPIC-7 / STORY-52) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

/// Kind of artifact transported through the wallet pipeline.
///
/// - [pdf]    — base64 / bytes of an `application/pdf` document.
/// - [png]    — base64 / bytes of an `image/png` (typically the QR image).
/// - [pkpass] — base64 / bytes of an Apple `.pkpass` zip bundle.
/// - [qrText] — raw textual QR payload meant to be re-encoded by a
///              renderer; not a binary at all.
enum BinaryArtifactKind {
  pdf,
  png,
  pkpass,
  qrText
  ;

  /// File extension used by the deterministic file naming helper.
  String get fileExtension => switch (this) {
    BinaryArtifactKind.pdf => 'pdf',
    BinaryArtifactKind.png => 'png',
    BinaryArtifactKind.pkpass => 'pkpass',
    BinaryArtifactKind.qrText => 'txt',
  };

  /// Format slug used in deterministic file names per TASK-53.
  String get formatSlug => switch (this) {
    BinaryArtifactKind.pdf => 'pdf',
    BinaryArtifactKind.png => 'qr',
    BinaryArtifactKind.pkpass => 'pkpass',
    BinaryArtifactKind.qrText => 'qr',
  };
}
