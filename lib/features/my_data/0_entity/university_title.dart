/// Represents a university title/degree from the education API.
final class UniversityTitle {
  const UniversityTitle({
    required this.titleNumber,
    required this.titleName,
    required this.universityName,
    this.completionDate,
    this.expeditionDate,
  });

  /// Número de título (nordlib, numlib, nregnac, nregmec)
  final String titleNumber;

  /// Nombre del título (titulacion)
  final String titleName;

  /// Nombre de la universidad/centro (centro)
  final String universityName;

  /// Fecha de finalización (fecfin)
  final DateTime? completionDate;

  /// Fecha de expedición (fecexp)
  final DateTime? expeditionDate;
}
