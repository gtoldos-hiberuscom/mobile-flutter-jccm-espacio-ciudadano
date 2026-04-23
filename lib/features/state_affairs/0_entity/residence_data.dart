/// Pure-Dart entity describing the citizen residence record sourced from
/// the INE/Padrón feed (canon §11).
///
/// Locale-independent. The presentation layer formats values via ARB and
/// theme tokens; this object never holds rendered copy.
final class ResidenceData {
  const ResidenceData({
    required this.municipio,
    required this.provincia,
    required this.comunidadAutonoma,
    required this.lastUpdatedAt,
    this.direccion,
    this.codigoPostal,
  });

  final String municipio;
  final String provincia;
  final String comunidadAutonoma;
  final String? direccion;
  final String? codigoPostal;
  final DateTime lastUpdatedAt;
}
