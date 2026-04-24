import 'dart:async';
import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/justificante_state.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_session.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_validator.dart';

/// Sprint 5 mock implementation of [UploadRepository].
///
/// Behaviour:
/// * `computeServerHash` re-runs SHA-256 locally — matches the client
///   hash, so the validator never reports a mismatch.
/// * `uploadUnsigned` simulates network latency and deterministically
///   fails when the file name contains `fail` (case-insensitive) so
///   widget tests can exercise the failure branch.
/// * `requestJustificante` returns the discovery-mandated
///   `JustificanteState.unavailable('builder-pending-backend-confirmation')`
///   until `documentacion/registrarfichero` shape is confirmed.
// TODO(future-sprint): swap [computeServerHash] to
//   `/procedimiento/obtenerhashdeadjunto`.
// TODO(future-sprint): wire the real Dio call to
//   `/procedimiento/subiradjuntosinfirma` and gate the signed variant
//   behind `kCaseworkSignedUploadEnabled`.
// ignore_for_file: flutter_style_todos
final class UploadRepositoryImpl implements UploadRepository {
  const UploadRepositoryImpl({
    this.simulatedDelay = const Duration(milliseconds: 200),
  });

  /// Delay applied before each simulated upload completes.
  final Duration simulatedDelay;

  @override
  Future<String> computeServerHash(final Uint8List bytes) async {
    return sha256HexOf(bytes);
  }

  @override
  Future<UploadAttachment> uploadUnsigned(
    final UploadAttachment attachment,
    final Uint8List bytes,
    final String expedienteRef,
  ) async {
    await Future<void>.delayed(simulatedDelay);
    if (attachment.displayName.toLowerCase().contains('fail')) {
      return attachment.copyWith(
        status: UploadAttachmentStatus.failed,
        errorMessage: 'mock-upload-failure',
      );
    }
    return attachment.copyWith(
      status: UploadAttachmentStatus.uploaded,
      clearError: true,
    );
  }

  @override
  Future<JustificanteState> requestJustificante(
    final UploadSession session,
  ) async {
    return const JustificanteState.unavailable(
      'builder-pending-backend-confirmation',
    );
  }
}
