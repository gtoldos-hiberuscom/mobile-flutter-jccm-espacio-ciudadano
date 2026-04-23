/// Pure-Dart entity for an educational title (universitario or no
/// universitario). Locale-independent.
final class EducationTitle {
  const EducationTitle({
    required this.id,
    required this.titulacion,
    required this.centro,
    required this.year,
  });

  /// Stable identifier — never PII content.
  final String id;
  final String titulacion;

  /// Centro / Universidad emisor (depending on the title type).
  final String centro;
  final int year;
}
