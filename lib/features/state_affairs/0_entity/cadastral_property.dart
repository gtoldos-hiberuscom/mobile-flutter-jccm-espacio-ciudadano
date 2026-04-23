/// Pure-Dart entity describing a single cadastral property
/// (Catastro) owned by the citizen.
final class CadastralProperty {
  const CadastralProperty({
    required this.id,
    required this.direccion,
    required this.titularidad,
    required this.superficieM2,
    this.referenciaCatastral,
  });

  /// Stable identifier — locale-independent. Never PII content.
  final String id;
  final String direccion;
  final String titularidad;
  final double superficieM2;
  final String? referenciaCatastral;
}
