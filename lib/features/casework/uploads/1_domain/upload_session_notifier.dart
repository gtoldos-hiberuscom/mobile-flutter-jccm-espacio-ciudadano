import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_session.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_validator.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/3_data/upload_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_session_notifier.g.dart';

/// Picked-file payload used by the presentation layer to feed
/// [UploadSessionNotifier.addFiles]. Pure data — no Flutter types.
typedef PickedFile = ({
  String name,
  int sizeBytes,
  String mimeType,
  Uint8List bytes,
});

/// Owns the lifecycle of an [UploadSession] for STORY-38.
@riverpod
class UploadSessionNotifier extends _$UploadSessionNotifier {
  @override
  UploadSession build() => UploadSession.empty('');

  /// Initialises the session for [expedienteRef]. Resets the state.
  void start(final String expedienteRef) {
    state = UploadSession.empty(expedienteRef);
  }

  /// Validates, hashes and stages [picked] files. Files that fail
  /// validation are added with [UploadAttachmentStatus.failed] and a
  /// failure code in [UploadAttachment.errorMessage].
  Future<void> addFiles(final List<PickedFile> picked) async {
    if (state.finalized) {
      return;
    }
    final repo = ref.read(uploadRepositoryProvider);
    var current = state;
    var counter = current.files.length;
    for (final file in picked) {
      final failure = validateNewFile(
        currentCount: current.files.length,
        name: file.name,
        sizeBytes: file.sizeBytes,
        mimeType: file.mimeType,
      );
      final id = 'att-${++counter}-${DateTime.now().microsecondsSinceEpoch}';
      if (failure != null) {
        final rejected = UploadAttachment(
          id: id,
          displayName: file.name,
          sizeBytes: file.sizeBytes,
          mimeType: file.mimeType,
          status: UploadAttachmentStatus.failed,
          errorMessage: failure.name,
        );
        current = current.copyWith(
          files: <UploadAttachment>[...current.files, rejected],
        );
        state = current;
        continue;
      }

      var attachment = UploadAttachment(
        id: id,
        displayName: file.name,
        sizeBytes: file.sizeBytes,
        mimeType: file.mimeType,
        status: UploadAttachmentStatus.validating,
      );
      current = current.copyWith(
        files: <UploadAttachment>[...current.files, attachment],
      );
      state = current;

      final localHash = sha256HexOf(file.bytes);
      String serverHash;
      try {
        serverHash = await repo.computeServerHash(file.bytes);
      } on Object {
        attachment = attachment.copyWith(
          status: UploadAttachmentStatus.failed,
          errorMessage: UploadValidationFailure.hashMismatch.name,
        );
        current = _replace(current, attachment);
        state = current;
        continue;
      }

      if (localHash != serverHash) {
        attachment = attachment.copyWith(
          status: UploadAttachmentStatus.failed,
          errorMessage: UploadValidationFailure.hashMismatch.name,
        );
      } else {
        attachment = attachment.copyWith(
          status: UploadAttachmentStatus.hashed,
          sha256Hex: localHash,
        );
      }
      current = _replace(current, attachment);
      state = current;
    }
  }

  /// Uploads every staged file in order. Failures are recorded per
  /// file and do not abort the loop.
  Future<void> uploadAll(final Map<String, Uint8List> bytesById) async {
    if (state.finalized) {
      return;
    }
    final repo = ref.read(uploadRepositoryProvider);
    for (final attachment in List<UploadAttachment>.from(state.files)) {
      if (attachment.status != UploadAttachmentStatus.hashed) {
        continue;
      }
      final bytes = bytesById[attachment.id];
      if (bytes == null) {
        continue;
      }
      var inFlight = attachment.copyWith(
        status: UploadAttachmentStatus.uploading,
        clearError: true,
      );
      state = _replace(state, inFlight);
      try {
        inFlight = await repo.uploadUnsigned(
          inFlight,
          bytes,
          state.expedienteRef,
        );
      } on Object catch (e) {
        inFlight = inFlight.copyWith(
          status: UploadAttachmentStatus.failed,
          errorMessage: e.toString(),
        );
      }
      state = _replace(state, inFlight);
    }
  }

  /// Marks the session as finalized and asks the repository for the
  /// justificante. Only runs when every file has uploaded successfully.
  Future<void> finalizeAndRequestJustificante() async {
    if (state.finalized || state.files.isEmpty) {
      return;
    }
    final allUploaded = state.files.every(
      (final f) => f.status == UploadAttachmentStatus.uploaded,
    );
    if (!allUploaded) {
      return;
    }
    final repo = ref.read(uploadRepositoryProvider);
    final justificante = await repo.requestJustificante(state);
    state = state.copyWith(
      justificante: justificante,
      finalized: true,
    );
  }

  /// Removes a staged file by id. No-op once the session is finalized.
  void removeFile(final String id) {
    if (state.finalized) {
      return;
    }
    final remaining = state.files.where((final f) => f.id != id).toList(
      growable: false,
    );
    if (remaining.length == state.files.length) {
      return;
    }
    state = state.copyWith(files: remaining);
  }

  static UploadSession _replace(
    final UploadSession session,
    final UploadAttachment attachment,
  ) {
    final next = session.files
        .map((final f) => f.id == attachment.id ? attachment : f)
        .toList(growable: false);
    return session.copyWith(files: next);
  }
}
