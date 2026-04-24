import 'package:jccm_espacio_ciudadano/features/help/0_entity/picked_attachment.dart';

/// Domain contract for picking a single optional attachment from the
/// device (STORY-60).
///
/// Kept abstract so the MVP can ship behind a stub
/// (`3_data/stub_attachment_picker.dart`) without taking a dependency on
/// `file_picker` or any platform plugin.
///
// TODO(TASK-63): swap the stub for a real platform-backed implementation
/// behind a feature flag.
abstract interface class AttachmentPicker {
  /// Returns the picked attachment metadata, or `null` if the user
  /// cancelled the picker.
  Future<PickedAttachment?> pickSingle();
}
