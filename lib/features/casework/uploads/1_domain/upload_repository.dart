import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/justificante_state.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_session.dart';

/// Domain port for the STORY-38 upload pipeline.
///
/// All methods deal in domain types only — DTOs from
/// `generated/dart_dio_client` never leak through this contract.
abstract interface class UploadRepository {
  /// Returns the canonical SHA-256 hex of [bytes] as the server would
  /// compute it. Sprint 5 implementation re-hashes locally; later
  /// sprints will call `/procedimiento/obtenerhashdeadjunto`.
  Future<String> computeServerHash(final Uint8List bytes);

  /// Uploads [attachment] without an electronic signature
  /// (`/procedimiento/subiradjuntosinfirma`). Returns the attachment
  /// with its updated status.
  Future<UploadAttachment> uploadUnsigned(
    final UploadAttachment attachment,
    final Uint8List bytes,
    final String expedienteRef,
  );

  /// Requests the post-upload justificante for [session].
  ///
  /// Sprint 5 returns `JustificanteState.unavailable(...)` per the
  /// discovery decision in TASK-40.
  Future<JustificanteState> requestJustificante(final UploadSession session);
}
