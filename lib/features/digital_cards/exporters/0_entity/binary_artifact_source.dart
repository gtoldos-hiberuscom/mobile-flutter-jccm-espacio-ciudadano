/// Digital cards exporters (EPIC-7 / STORY-52) — pure-Dart entity.
///
/// Pure Dart — no Flutter / Riverpod / Dio (canon §11).
library;

import 'dart:typed_data';

/// Sealed value object describing how the backend delivered the artifact
/// payload. The exporter pipeline normalises every variant to bytes (or
/// to text for `qrText`) before persisting to disk.
sealed class BinaryArtifactSource {
  const BinaryArtifactSource();

  /// Already-decoded raw bytes (typically Dio returned a `List<int>`).
  const factory BinaryArtifactSource.bytes(final Uint8List bytes) = BinaryArtifactSourceBytes;

  /// Base64-encoded payload, possibly with a `data:...;base64,` prefix.
  const factory BinaryArtifactSource.base64(final String value) = BinaryArtifactSourceBase64;

  /// Plain UTF-8 text (used for raw QR payloads).
  const factory BinaryArtifactSource.text(final String value) = BinaryArtifactSourceText;

  /// The backend explicitly reported the payload as unavailable. The
  /// [reason] is opaque, never includes PII, and is suitable for logs.
  const factory BinaryArtifactSource.unavailable(final String reason) = BinaryArtifactSourceUnavailable;
}

final class BinaryArtifactSourceBytes extends BinaryArtifactSource {
  const BinaryArtifactSourceBytes(this.bytes);
  final Uint8List bytes;
}

final class BinaryArtifactSourceBase64 extends BinaryArtifactSource {
  const BinaryArtifactSourceBase64(this.value);
  final String value;
}

final class BinaryArtifactSourceText extends BinaryArtifactSource {
  const BinaryArtifactSourceText(this.value);
  final String value;
}

final class BinaryArtifactSourceUnavailable extends BinaryArtifactSource {
  const BinaryArtifactSourceUnavailable(this.reason);
  final String reason;
}
