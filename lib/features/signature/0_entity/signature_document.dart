import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document_status.dart';

/// Single document offered to the citizen for signing or already signed
/// (STORY-45).
///
/// Pure value type — no Flutter / Dio / Riverpod (canon §11).
final class SignatureDocument {
  const SignatureDocument({
    required this.id,
    required this.title,
    required this.organismoEmisor,
    required this.fechaCreacion,
    required this.status,
    this.expedienteRef,
    this.sizeBytes,
  });

  final String id;
  final String title;
  final String organismoEmisor;
  final DateTime fechaCreacion;
  final String? expedienteRef;
  final int? sizeBytes;
  final SignatureDocumentStatus status;
}
