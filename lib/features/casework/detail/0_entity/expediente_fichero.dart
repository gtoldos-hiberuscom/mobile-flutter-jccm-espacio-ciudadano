/// A file already associated with an expediente, as returned by
/// `/publicacion/selectbynumexp` (STORY-35).
///
/// Pure data — no Flutter or infrastructure dependencies.
final class ExpedienteFichero {
  const ExpedienteFichero({
    required this.id,
    required this.nombre,
    required this.mimeType,
    required this.fechaSubida,
    required this.descargaRef,
    this.sizeBytes,
  });

  /// Stable backend identifier — never PII content.
  final String id;

  /// Display name of the file as shown to the citizen.
  final String nombre;

  /// IANA MIME type (e.g. `application/pdf`).
  final String mimeType;

  /// Optional declared size in bytes. May be missing when the backend
  /// does not include it in the response.
  final int? sizeBytes;

  /// Date the file was attached to the expediente.
  final DateTime fechaSubida;

  /// Opaque reference used by the (future) download endpoint. The actual
  /// download is deferred to a follow-up sprint.
  final String descargaRef;
}
