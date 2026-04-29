/// Single fichero attached to a registro de entrada / salida (STORY-36).
///
/// Pure-Dart entity — no Flutter, no Dio, no DTO knowledge. Mappers in
/// `3_data/` are responsible for turning the wire payload into this
/// shape.
final class RegistroFichero {
  const RegistroFichero({
    required this.id,
    required this.nombre,
    required this.mimeType,
    required this.descargaRef,
    this.sizeBytes,
  });

  /// Stable identifier within the registro detail.
  final String id;

  /// Human-readable filename as published by the back-office.
  final String nombre;

  /// MIME type — used to render the appropriate icon and to drive the
  /// "abrir" affordance in a later sprint.
  final String mimeType;

  /// Optional size in bytes — backend may omit it.
  final int? sizeBytes;

  /// Opaque download reference. The presentation layer treats it as a
  /// stable token and never parses it.
  final String descargaRef;
}
