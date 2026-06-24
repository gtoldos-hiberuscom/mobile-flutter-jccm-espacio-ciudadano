final class EmploymentOfferRegistration {
  const EmploymentOfferRegistration({
    required this.title,
    this.publicationDate,
    this.registrationDate,
    this.selectionEndDate,
    this.applicationStatus,
  });

  final String title;
  final DateTime? publicationDate;
  final DateTime? registrationDate;
  final DateTime? selectionEndDate;
  final String? applicationStatus;
}
