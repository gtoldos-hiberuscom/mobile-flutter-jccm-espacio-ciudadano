import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/picked_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/attachment_picker.dart';

/// Stub implementation of [AttachmentPicker] used while a real platform
/// picker is not wired in (STORY-60).
///
/// Returns a deterministic fake [PickedAttachment] so the UI can exercise
/// the "attached" branch end-to-end without depending on `file_picker`
/// or any platform plugin.
///
// TODO(TASK-63): replace by a real implementation backed by `file_picker`
/// (or platform channels) behind a feature flag.
final class StubAttachmentPicker implements AttachmentPicker {
  const StubAttachmentPicker();

  @override
  Future<PickedAttachment?> pickSingle() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const PickedAttachment(
      name: 'incidencia.pdf',
      sizeBytes: 24 * 1024,
      mimeType: 'application/pdf',
    );
  }
}

/// DI provider exposing the active [AttachmentPicker]. Overridable in
/// tests to assert "no attachment" / "cancelled" branches.
final attachmentPickerProvider = Provider<AttachmentPicker>(
  (final ref) => const StubAttachmentPicker(),
  name: 'attachmentPickerProvider',
);
