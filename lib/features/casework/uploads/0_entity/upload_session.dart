import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/justificante_state.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';

/// Aggregate state of an upload session bound to a single expediente.
///
/// Immutable. The notifier produces a new instance on every transition.
final class UploadSession {
  const UploadSession({
    required this.expedienteRef,
    required this.files,
    required this.justificante,
    required this.finalized,
  });

  /// Empty session for the given expediente reference.
  factory UploadSession.empty(final String expedienteRef) => UploadSession(
    expedienteRef: expedienteRef,
    files: const <UploadAttachment>[],
    justificante: const JustificanteState.pending(),
    finalized: false,
  );

  /// Reference (numexp / dossier id) the session writes against.
  final String expedienteRef;

  /// Attached files, in pick order.
  final List<UploadAttachment> files;

  /// Current justificante state.
  final JustificanteState justificante;

  /// True once `finalizeAndRequestJustificante` resolved (regardless of
  /// availability). Locks the file list against further changes.
  final bool finalized;

  UploadSession copyWith({
    final String? expedienteRef,
    final List<UploadAttachment>? files,
    final JustificanteState? justificante,
    final bool? finalized,
  }) {
    return UploadSession(
      expedienteRef: expedienteRef ?? this.expedienteRef,
      files: files ?? this.files,
      justificante: justificante ?? this.justificante,
      finalized: finalized ?? this.finalized,
    );
  }
}
