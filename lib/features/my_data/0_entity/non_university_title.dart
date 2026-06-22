/// Non-university title entity (professional/vocational education titles).
///
/// Maps to the backend's "titulos no universitarios" response structure.
final class NonUniversityTitle {
  const NonUniversityTitle({
    required this.titleName,
    required this.centerName,
    this.book,
    this.order,
    this.folio,
    this.province,
    this.expeditionDate,
    this.completionDate,
  });

  /// Book number ("numlib")
  final String? book;

  /// Order number ("nordlib")
  final String? order;

  /// Folio number ("numfol")
  final String? folio;

  /// Name of the degree/title ("titulacion")
  final String titleName;

  /// Educational center name ("centro")
  final String centerName;

  /// Province where the title was issued ("provtit")
  final String? province;

  /// Expedition date ("fecexp")
  final DateTime? expeditionDate;

  /// Completion date ("fecfin")
  final DateTime? completionDate;
}
