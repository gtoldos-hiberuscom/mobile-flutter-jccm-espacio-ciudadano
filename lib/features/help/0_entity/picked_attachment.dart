import 'package:meta/meta.dart';

/// Immutable value object describing an attachment picked by the user
/// for the support form (STORY-60).
///
/// Pure metadata: file bytes are intentionally NOT carried here so the
/// `0_entity/` layer remains free of platform / IO concerns (canon §11).
/// The real bytes (or stream) will be obtained by the data layer once a
/// real file picker is wired in (see TASK-63).
@immutable
final class PickedAttachment {
  const PickedAttachment({
    required this.name,
    required this.sizeBytes,
    this.mimeType,
  });

  /// Original file name (basename), e.g. `incident.png`.
  final String name;

  /// File size in bytes. Used for display + future server-side limits.
  final int sizeBytes;

  /// Optional best-effort MIME type. May be `null` until a real picker is
  /// wired in.
  final String? mimeType;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is PickedAttachment &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          sizeBytes == other.sizeBytes &&
          mimeType == other.mimeType;

  @override
  int get hashCode => Object.hash(name, sizeBytes, mimeType);

  @override
  String toString() =>
      'PickedAttachment(name: $name, sizeBytes: $sizeBytes, mimeType: $mimeType)';
}
